* ---------------------------------------------------------------------------
* SMPS 6809 - Sample Music Playback System for 6809 (LWASM)
* ---------------------------------------------------------------------------
* by Bentoc June 2021, based on
* Sonic the Hedgehog 2 disassembled Z80 sound driver
* Disassembled by Xenowhirl for AS
* Additional disassembly work by RAS Oct 2008
* RAS' work merged into SVN by Flamewing
* ---------------------------------------------------------------------------

; SMPS Header
SMPS_VOICE                   equ   0
SMPS_NB_FM                   equ   2
SMPS_NB_PSG                  equ   3
SMPS_TEMPO                   equ   4
SMPS_TEMPO_DELAY             equ   4
SMPS_DELAY                   equ   5
SMPS_TRK_HEADER              equ   6
SMPS_DAC_FLAG                equ   8

; SMPS Header each track relative
SMPS_TRK_DATA_PTR            equ   0 
SMPS_TRK_TR_VOL_PTR          equ   2
SMPS_TRK_ENV_PTR             equ   5
SMPS_TRK_FM_HDR_LEN          equ   4
SMPS_TRK_PSG_HDR_LEN         equ   6

; Hardware Addresses
YM2413_A0                    equ   $E7B1
PSG                          equ   $E7B0

******************************************************************************

Track STRUCT
                                                      ;         "playback control"; bits 
                                                      ;         1 (02h)  seems to be "track is at rest"
                                                      ;         2 (04h)  SFX is overriding this track
                                                      ;         3 (08h)  modulation on
                                                      ;         4 (10h)  do not attack next note
                                                      ;         7 (80h)  track is playing
PlaybackControl                rmb   1
                                                      ;         "voice control"; bits 
                                                      ;         0-3 (00h-0Fh) Voice number
                                                      ;         7   (80h) PSG Track
VoiceControl                   rmb   1
                                                      ;         "note control"; bits
                                                      ;         0-3 (00h-0Fh) Current Block(0-2) and FNum(8)
                                                      ;         4   (10h) Key On
                                                      ;         5   (20h) Sustain On
NoteControl                    rmb   1
TempoDivider                   rmb   1                ; timing divisor; 1 = Normal, 2 = Half, 3 = Third...
DataPointer                    rmb   2                ; Track's position
Transpose                      rmb   1                ; Transpose (from coord flag E9)
Volume                         rmb   1                ; (Dependency) Should follow Transpose - channel volume (only applied at voice changes)
VoiceIndex                     rmb   1                ; Current voice in use OR current PSG tone
VolFlutter                     rmb   1                ; PSG flutter (dynamically effects PSG volume for decay effects)
StackPointer                   rmb   1                ; "Gosub" stack position offset (starts at 2Ah, i.e. end of track, and each jump decrements by 2)
DurationTimeout                rmb   1                ; current duration timeout; counting down to zero
SavedDuration                  rmb   1                ; last set duration (if a note follows a note, this is reapplied to 0Bh)
                                                      ; 0Dh / 0Eh change a little depending on track -- essentially they hold data relevant to the next note to play
NextData                       rmb   2                ; DAC Next drum to play - FM/PSG  frequency
NoteFillTimeout                rmb   1                ; Currently set note fill; counts down to zero and then cuts off note
NoteFillMaster                 rmb   1                ; Reset value for current note fill
ModulationPtr                  rmb   2                ; address of current modulation setting
ModulationWait                 rmb   1                ; Wait for ww period of time before modulation starts
ModulationSpeed                rmb   1                ; Modulation Speed
ModulationDelta                rmb   1                ; Modulation change per Mod. Step
ModulationSteps                rmb   1                ; Number of steps in modulation (divided by 2)
ModulationVal                  rmb   2                ; Current modulation value
Detune                         rmb   1                ; Set by detune coord flag E1; used to add directly to FM/PSG frequency
VolTLMask                      rmb   1                ; zVolTLMaskTbl value set during voice setting (value based on algorithm indexing zGain table)
PSGNoise                       rmb   1                ; PSG noise setting
VoicePtr                       rmb   2                ; custom voice table (for SFX)
TLPtr                          rmb   2                ; where TL bytes of current voice begin (set during voice setting)
LoopCounters                   rmb   $A               ; Loop counter index 0
                                                      ;   ... open ...
GoSubStack                                            ; start of next track, every two bytes below this is a coord flag "gosub" (F8h) return stack
                                                      ;
                                                      ;        The bytes between +20h and +29h are "open"; starting at +20h and going up are possible loop counters
                                                      ;        (for coord flag F7) while +2Ah going down (never AT 2Ah though) are stacked return addresses going
                                                      ;        down after calling coord flag F8h.  Of course, this does mean collisions are possible with either
                                                      ;        or other track memory if you're not careful with these!  No range checking is performed!
                                                      ;
                                                      ;        All tracks are 2Ah bytes long
 ENDSTRUCT

; Track STRUCT Constants
PlaybackControl              equ   0
VoiceControl                 equ   1
NoteControl                  equ   2
TempoDivider                 equ   3
DataPointer                  equ   4
TransposeAndVolume           equ   6
Transpose                    equ   6
Volume                       equ   7
VoiceIndex                   equ   8
VolFlutter                   equ   9
StackPointer                 equ   10
DurationTimeout              equ   11
SavedDuration                equ   12
NextData                     equ   13
NoteFillTimeout              equ   15
NoteFillMaster               equ   16
ModulationPtr                equ   17
ModulationWait               equ   19
ModulationSpeed              equ   20
ModulationDelta              equ   21
ModulationSteps              equ   22
ModulationVal                equ   23
Detune                       equ   25
VolTLMask                    equ   26
PSGNoise                     equ   27
VoicePtr                     equ   28
TLPtr                        equ   30
LoopCounters                 equ   32

******************************************************************************

Var STRUCT
SFXPriorityVal                 rmb   1        
TempoTimeout                   rmb   1        
CurrentTempo                   rmb   1                ; Stores current tempo value here
StopMusic                      rmb   1                ; Set to 7Fh to pause music, set to 80h to unpause. Otherwise 00h
FadeOutCounter                 rmb   1        
FadeOutDelay                   rmb   1        
Communication                  rmb   1                ; Unused byte used to synchronise gameplay events with music
QueueToPlay                    rmb   1                ; if NOT set to 80h, means new index was requested by 68K
SFXToPlay                      rmb   1                ; When Genesis wants to play "normal" sound, it writes it here
SFXStereoToPlay                rmb   1                ; When Genesis wants to play alternating stereo sound, it writes it here
SFXUnknown                     rmb   1                ; Unknown type of sound queue, but it's in Genesis code like it was once used
VoiceTblPtr                    rmb   2                ; address of the voices
FadeInFlag                     rmb   1        
FadeInDelay                    rmb   1        
FadeInCounter                  rmb   1        
1upPlaying                     rmb   1        
TempoMod                       rmb   1        
TempoTurbo                     rmb   1                ; Stores the tempo if speed shoes are acquired (or 7Bh is played anywho)
SpeedUpFlag                    rmb   1        
DACEnabled                     rmb   1        
MusicBankNumber                rmb   1        
IsPalFlag                      rmb   1        
 ENDSTRUCT

******************************************************************************

StructStart
AbsVar          Var

tracksStart		; This is the beginning of all BGM track memory
SongDACFMStart
SongDAC         Track
SongFMStart
SongFM0         Track
SongFM1         Track
SongFM2         Track
SongFM3         Track
SongFM4         Track
SongFM5         Track
SongFM6         Track
SongFM7         Track
SongFM8         Track
SongFMEnd
SongDACFMEnd
SongPSGStart
SongPSG1        Track
SongPSG2        Track
SongPSG3        Track
SongPSGEnd
tracksEnd

;tracksSFXStart
;SFX_FMStart
;SFX_FM3         Track
;SFX_FM4         Track
;SFX_FM5         Track
;SFX_FMEnd
;SFX_PSGStart
;SFX_PSG1        Track
;SFX_PSG2        Track
;SFX_PSG3        Track
;SFX_PSGEnd
;tracksSFXEnd
StructEnd

        org   StructStart
        fill  0,(StructEnd-StructStart)     ; I want struct data to be in binary please ...
        
******************************************************************************

PALUpdTick      fcb   0     ; this counts from 0 to 5 to periodically "double update" for PAL systems (basically every 6 frames you need to update twice to keep up)
;CurSong        fcb   0     ; currently playing song index
DoSFXFlag       fcb   0     ; flag to indicate we're updating SFX (and thus use custom voice table); set to FFh while doing SFX, 0 when not.
Paused          fcb   0     ; 0 = normal, -1 = pause all sound and music

SongPage        fcb   0     ; memory page of song data
SongDelay       fcb   0     ; song header delay
MusicData       fdb   0     ; address of song data

MUSIC_TRACK_COUNT = (tracksEnd-tracksStart)/sizeof{Track}
MUSIC_DAC_FM_TRACK_COUNT = (SongDACFMEnd-SongDACFMStart)/sizeof{Track}
MUSIC_FM_TRACK_COUNT = (SongFMEnd-SongFMStart)/sizeof{Track}
MUSIC_PSG_TRACK_COUNT = (SongPSGEnd-SongPSGStart)/sizeof{Track}

;SFX_TRACK_COUNT = (tracksSFXEnd-tracksSFXStart)/sizeof{Track}
;SFX_FM_TRACK_COUNT = (SFX_FMEnd-SFX_FMStart)/sizeof{Track}
;SFX_PSG_TRACK_COUNT = (SFX_PSGEnd-SFX_PSGStart)/sizeof{Track}

* ************************************************************************************
* writes to YM2413 (address val A to dest U, data val B to dest X) with required waits
*

_WriteYM MACRO
        sta   ,u
        nop
        nop
        stb   1,u
 ENDM  
 
_YMBusyWait10 MACRO
        nop
        nop
        nop
        nop
        nop
 ENDM
 
 _YMBusyWait17 MACRO
        nop
        nop
        nop
        nop
        nop
        nop
        nop                                        
        brn   *
 ENDM
 
_YMBusyWait19 MACRO
        exg   a,b
        exg   a,b
        brn   *
 ENDM

* ************************************************************************************
* Setup YM2413 for Drum Mode
* destroys A, B, U, X

YM2413_DrumModeOn
        ldu   #YM2413_A0
        ldx   #@data
@a      ldd   ,x++
        bmi   @end
        _WriteYM
        _YMBusyWait10
        bra   @a
@end    rts        
@data
        fdb   $0E20
        fdb   $1620
        fdb   $1750
        fdb   $18C0
        fdb   $2605
        fdb   $2705
        fdb   $2801
        fdb   $3600
        fdb   $3700
        fdb   $3800
        fcb   $FF

* ************************************************************************************
* receives in X the address of the song
* destroys A

_InitTrackFM MACRO
        ldx   #\1
        lda   #\2
        sta   VoiceControl,x
        lda   SongDelay        
        sta   TempoDivider,x
        ldd   #$8201
        sta   PlaybackControl,x
        stb   DurationTimeout,x
        ldd   SMPS_TRK_DATA_PTR,u
        addd  MusicData
        std   DataPointer,x
        ldd   SMPS_TRK_TR_VOL_PTR,u
        std   TransposeAndVolume,x
        leau  SMPS_TRK_FM_HDR_LEN,u       
 ENDM

_InitTrackPSG MACRO
        ldx   #\1
        lda   #\2
        sta   VoiceControl,x
        lda   AbsVar.CurrentTempo        
        sta   TempoDivider,x
        ldd   #$8201
        sta   PlaybackControl,x
        stb   DurationTimeout,x
        ldd   SMPS_TRK_DATA_PTR,u
        addd  MusicData
        std   DataPointer,x
        ldd   SMPS_TRK_TR_VOL_PTR,u
        std   TransposeAndVolume,x
        lda   SMPS_TRK_ENV_PTR,u
        sta   VoiceIndex,x
        leau  SMPS_TRK_PSG_HDR_LEN,u
 ENDM

PlayMusic
BGMLoad
        lda   ,x                       ; get memory page that contains track data
        sta   SongPage
        ldx   1,x                      ; get ptr to track data
        stx   MusicData
        _SetCartPageA
        
        ldd   SMPS_VOICE,x   
        std   AbsVar.VoiceTblPtr
        
        ldd   SMPS_TEMPO_DELAY,x
        sta   SongDelay
        stb   AbsVar.TempoMod
        stb   AbsVar.CurrentTempo
        stb   AbsVar.TempoTimeout
        
        lda   #$05
        sta   PALUpdTick
        
        ; TODO
        ; silence tracks that are not in use !
        
        lda   SMPS_NB_FM,x
        sta   @dyn+1
        leau  SMPS_TRK_HEADER,x
        ldy   SMPS_DAC_FLAG,x
        bne   @a
        _InitTrackFM SongDAC
@dyn    lda   #$00                                    ; (dynamic)      
        deca
@a      asla
        ldy   #ifmjmp
        jmp   [a,y]    
ifmjmp        
        fdb   ifm
        fdb   ifm0        
        fdb   ifm1        
        fdb   ifm2
        fdb   ifm3
        fdb   ifm4
        fdb   ifm5
        fdb   ifm6
        fdb   ifm7
        fdb   ifm8

ifm8    _InitTrackFM SongFM8,$08
ifm7    _InitTrackFM SongFM7,$07
ifm6    _InitTrackFM SongFM6,$06
ifm5    _InitTrackFM SongFM5,$05
ifm4    _InitTrackFM SongFM4,$04
ifm3    _InitTrackFM SongFM3,$03
ifm2    _InitTrackFM SongFM2,$02
ifm1    _InitTrackFM SongFM1,$01
ifm0    _InitTrackFM SongFM0,$00
ifm
        ldx   MusicData
        lda   SMPS_NB_PSG,x
@a      asla
        ldy   #ipsgjmp
        jmp   [a,y]    
ipsgjmp    
        fdb   ipsg0
        fdb   ipsg1
        fdb   ipsg2
        fdb   ipsg3

ipsg3   _InitTrackPSG SongPSG3,$82
ipsg2   _InitTrackPSG SongPSG2,$81  
ipsg1   _InitTrackPSG SongPSG1,$80
ipsg0
        rts
        
        
* ************************************************************************************
* processes a music frame (VInt)
*
* SMPS Song Data
* --------------
* value in range [$00, $7F] : Duration value
* value in range [$80]      : Rest (counts as a note value)
* value in range [$81, $DF] : Note value
* value in range [$E0, $FF] : Coordination flag
*
* destroys A,B,X
        
@a      rts        
MusicFrame 
        lda   SongPage                 ; page switch to the music
        beq   @a                       ; no music to play
        _SetCartPageA
        ;clr   DoSFXFlag
        lda   AbsVar.StopMusic
        beq   UpdateEverything
        jmp   PauseMusic 

UpdateEverything        
        lda   AbsVar.IsPalFlag
        beq   @a
        dec   PALUpdTick
        bne   @a
        lda   #5
        sta   PALUpdTick
        jsr   UpdateMusic              ; play 2 frames in one to keep original speed
@a      jmp   UpdateMusic        

* ************************************************************************************
* 

_UpdateTrack MACRO
        ldy   #\1
        lda   PlaybackControl,y        ; Is bit 7 (80h) set on playback control byte? (means "is playing")
        bpl   a@                       
        jsr   \2                       ; If so, UpdateTrack
a@      equ   *        
 ENDM

UpdateMusic
        jsr   TempoWait
        _UpdateTrack SongDAC,DACUpdateTrack
        _UpdateTrack SongFM0,FMUpdateTrack        
        _UpdateTrack SongFM1,FMUpdateTrack
        _UpdateTrack SongFM2,FMUpdateTrack
        _UpdateTrack SongFM3,FMUpdateTrack
        _UpdateTrack SongFM4,FMUpdateTrack
        _UpdateTrack SongFM5,FMUpdateTrack
        _UpdateTrack SongFM6,FMUpdateTrack
        _UpdateTrack SongFM7,FMUpdateTrack
        _UpdateTrack SongFM8,FMUpdateTrack                
        _UpdateTrack SongPSG1,PSGUpdateTrack
        _UpdateTrack SongPSG2,PSGUpdateTrack
        _UpdateTrack SongPSG3,PSGUpdateTrack        
        rts
        
* ************************************************************************************
* 
TempoWait
        ; Tempo works as divisions of the 60Hz clock (there is a fix supplied for
        ; PAL that "kind of" keeps it on track.)  Every time the internal music clock
        ; overflows, it will update.  So a tempo of 80h will update every other
        ; frame, or 30 times a second.

        lda   AbsVar.CurrentTempo  ; tempo value
        adda  AbsVar.TempoTimeout  ; Adds previous value to
        sta   AbsVar.TempoTimeout  ; Store this as new
        bcc   @a
        rts                     ; If addition overflowed (answer greater than FFh), return
@a
        ; So if adding tempo value did NOT overflow, then we add 1 to all durations
        inc   SongDAC.DurationTimeout
        inc   SongFM0.DurationTimeout        
        inc   SongFM1.DurationTimeout
        inc   SongFM2.DurationTimeout
        inc   SongFM3.DurationTimeout
        inc   SongFM4.DurationTimeout
        inc   SongFM5.DurationTimeout
        inc   SongFM6.DurationTimeout
        inc   SongFM7.DurationTimeout
        inc   SongFM8.DurationTimeout                
        inc   SongPSG1.DurationTimeout
        inc   SongPSG2.DurationTimeout
        inc   SongPSG3.DurationTimeout
        rts

* ************************************************************************************
* 

DACUpdateTrack        
        dec   SongDAC.DurationTimeout
        beq   @a
        rts
@a
        ldx   SongDAC.DataPointer
        
        ldd   #$0E20                   ; note has ended, so note off
        ldu   #YM2413_A0    
        _WriteYM
                 
@b      ldb   ,x+                      ; read DAC song data
        cmpb  #$E0
        blo   @a                       ; test for >= E0h, which is a coordination flag
        jsr   CoordFlag
        bra   @b                       ; read all consecutive coordination flags 
@a        
        bpl   SetDuration              ; test for 80h not set, which is a note duration
        stb   SongDAC.NextData	       ; This is a note; store it here
        ldb   ,x
        bpl   SetDurationAndForward    ; test for 80h not set, which is a note duration
        ldb   SongDAC.SavedDuration
        bra   DACAfterDur

SetDurationAndForward
        leax  1,x
SetDuration
        lda   SongDAC.TempoDivider
        mul
        stb   SongDAC.SavedDuration
DACAfterDur
        stb   SongDAC.DurationTimeout
        stx   SongDAC.DataPointer
        ldb   SongDAC.NextData
        cmpb  #$80
        bne   @a
        rts                            ; if a rest, quit
@a
        ldx   #@data            
        subb  #$81                     ; transform note into an index...      
        ldb   b,x
        lda   #$0E
        ldu   #YM2413_A0      
        _WriteYM    
        rts
@data
        fcb   $30 ; $81 - Kick
        fcb   $28 ; $82 - Snare
        fcb   $21 ; $83 - Clap
        fcb   $22 ; $84 - Scratch
        fcb   $22 ; $85 - Timpani
        fcb   $24 ; $86 - Hi Tom
        fcb   $24 ; $87 - Bongo
        fcb   $24 ; $88 - Hi Timpani
        fcb   $24 ; $89 - Mid Timpani
        fcb   $24 ; $8A - Mid Low Timpani
        fcb   $24 ; $8B - Low Timpani
        fcb   $24 ; $8C - Mid Tom
        fcb   $24 ; $8D - Low Tom
        fcb   $24 ; $8E - Floor Tom
        fcb   $24 ; $8F - Hi Bongo
        fcb   $24 ; $90 - Mid Bongo
        fcb   $24 ; $91 - Low Bongo
 
; PSG Noise Drum       
;Note	NMode	Env	Vol	Ch3Vol	Ch3Freq	Slide
;88	E7	02	0	F	030	02
;89	E7	02	0	F	030	02
;8D	E7	02	0	F	030	02
;9D	E7	02	0	F	030	02

;82	E7	01	0	F	030	02
;81	E7	01	4	6	010	02
;85	E7	01	4	6	010	02
;84	E7	01	4	6	010	02

;91?	E7	04	3	6	010	02
;90?	E7	03	3	6	010	02
        

* ************************************************************************************
* 
 
FMUpdateTrack
        dec   DurationTimeout,y        ; Decrement duration
        bne   NoteFillUpdate           ; If not time-out yet, go do updates only
        lda   PlaybackControl,y
        anda  #$F7
        sta   PlaybackControl,y        ; When duration over, clear "do not attack" bit 4 (0x10) of track's play control
        
FMDoNext
        ldx   DataPointer,y
        lda   PlaybackControl,y        ; Clear bit 1 (02h) "track is rest" from track
        anda  #$FD
        sta   PlaybackControl,y        
       
FMNoteOff        
        ; TODO : Check if Note Off must be moved after Coord Flag reading or not
        anda  #$14                     ; Are bits 4 (no attack) or 2 (SFX overriding) set?
        bne   @b                       ; If they are, skip
        lda   VoiceControl,y           ; Otherwise, send a Key Off
        adda  #$20                     ; set Sus/Key/Block/FNum(MSB) Command
        ldu   #YM2413_A0
        sta   ,u
        ldb   NoteControl,y            ; load current value (do not erase FNum MSB)  (and used as 2 cycles tempo)
        andb  #$EF                     ; Clear bit 5 (10h) Key Off (and used as 2 cycles tempo)
        stb   1,u                      ; send to YM
        stb   NoteControl,y        
        
@b      ldb   ,x+                      ; Read song data
        cmpb  #$E0
        blo   @a                       ; Test for >= E0h, which is a coordination flag
        jsr   CoordFlag
        bra   @b                       ; Read all consecutive coordination flags 
@a      bpl   FMSetDuration            ; Test for 80h not set, which is a note duration
        
FMSetFreq
        subb  #$80                     ; Test for a rest
        bne   @a
        lda   PlaybackControl,y        ; Set bit 1 (track is at rest)
        ora   #$02
        sta   PlaybackControl,y
        bra   @b        
@a      addb  Transpose,y              ; Add current channel transpose (coord flag E9)
        aslb                           ; Transform note into an index...
        ldu   #Frequencies
        ldd   b,u
        std   NextData,y               ; Store Frequency
@b      ldb   ,x                       ; Get next byte
        bpl   FMSetDurationAndForward  ; Test for 80h not set, which is a note duration
        ldb   SavedDuration,y        
        bra   FinishTrackUpdate

FMSetDurationAndForward
        leax  1,x
        
FMSetDuration
        lda   TempoDivider,y
        mul
        stb   SavedDuration,y
        
FinishTrackUpdate
        stb   DurationTimeout,y        ; Last set duration ... put into ticker
        stx   DataPointer,y            ; Stores to the track pointer memory
        lda   PlaybackControl,y
        bita  #$10                     ; Is bit 4 (10h) "do not attack next note" set on playback?
        bne   @a                       
        bra   FMPrepareNote            ; If so, quit
@a      ldb   NoteFillMaster,y
        stb   NoteFillTimeout,y        ; Reset 0Fh "note fill" value to master
        clr   VolFlutter,y             ; Reset PSG flutter byte
        bita  #$08                     ; Is bit 3 (08h) modulation turned on?
        beq   @b
        bra   FMPrepareNote            ; if not, quit
@b      ldx   ModulationPtr,y
        jsr   SetModulation            ; reload modulation settings for the new note
        
FMPrepareNote
        lda   PlaybackControl,y
        bita  #$02                     ; Is bit 1 (02h) "track is at rest" set on playback?
        beq   FMUpdateFreqAndNoteOn                       
        rts                            ; If so, quit
FMUpdateFreqAndNoteOn
        ldb   Track.Detune
        sex
        addd  NextData,y               ; Apply detune but don't update stored frequency
        stb   @dyn+1
        ldb   #$10                     ; set LSB Frequency Command
        addb  VoiceControl,y
        ldu   #YM2413_A0        
        stb   ,u
        addb  #$20                     ; set Sus/Key/Block/FNum(MSB) Command(and used as 2 cycles tempo)
        nop
        sta   1,u
        _YMBusyWait17
        lda   NoteControl,y            ; load current value (do not erase FNum MSB) (and used as 5 cycles tempo)
        ora   #$10                     ; Set bit 5 (10h) Key On        
        stb   ,u
        anda  #$F0                     ; Clear FNum MSB (and used as 2 cycles tempo)
@dyn    adda  #0                       ; (dynamic) Set Fnum MSB (and used as 2 cycles tempo)
        sta   1,u   
        sta   NoteControl,y
        
DoModulation  
        
        
              
FMUpdateFreq
        ldb   Track.Detune
        sex
        addd  NextData,y               ; Apply detune but don't update stored frequency
        stb   @dyn+1
        ldb   #$10                     ; set LSB Frequency Command
        addb  VoiceControl,y
        ldu   #YM2413_A0        
        stb   ,u
        addb  #$20                     ; set Sus/Key/Block/FNum(MSB) Command(and used as 2 cycles tempo)
        nop
        sta   1,u
        _YMBusyWait19
        lda   NoteControl,y            ; load current value (do not erase FNum MSB) (and used as 5 cycles tempo)
        stb   ,u
        anda  #$F0                     ; Clear FNum MSB (and used as 2 cycles tempo)
@dyn    adda  #0                       ; (dynamic) Set Fnum MSB (and used as 2 cycles tempo)
        sta   1,u   
        sta   NoteControl,y
        rts
        
                
NoteFillUpdate
        lda   NoteFillTimeout,y        ; Get current note fill value
        beq   DoModulationNoteFill     ; If zero, return!
        dec   NoteFillTimeout,y        ; Decrement note fill
        bne   DoModulationNoteFill     ; If not zero, return
        
        lda   PlaybackControl,y
        ora   #$02                     ; Set bit 1 (track is at rest)
        lda   VoiceControl,y           ; Send a Key Off
        adda  #$20                     ; set Sus/Key/Block/FNum(MSB) Command
        ldu   #YM2413_A0
        sta   ,u
        ldb   NoteControl,y            ; load current value (do not erase FNum MSB)  (and used as 2 cycles tempo)
        andb  #$EF                     ; Clear bit 5 (10h) Key Off (and used as 2 cycles tempo)
        stb   1,u                      ; send to YM
        stb   NoteControl,y                
        rts
        
DoModulationNoteFill
        lda   PlaybackControl,y
        bita  #$02                     ; Is bit 1 (02h) "track is at rest" set on playback?
        beq   @a
        rts                            ; If so, quit        
@a      bita  #$08                     ; Is bit 3 (08h) "modulation on" set on playback?
        bne   @b
        rts                            ; If not, quit        
@b      lda   ModulationWait,y         ; 'ww' period of time before modulation starts
        beq   @c                       ; if zero, go to it!
        dec   ModulationWait,y         ; Otherwise, decrement timer
        rts                            ; return if decremented
@c      dec   ModulationSpeed,y        ; Decrement modulation speed counter
        beq   @d
        rts                            ; Return if not yet zero
@d      ldx   ModulationPtr,y
        addd  #1
        lda   ,x
        
FMUpdateFreqNoteFill
        ldb   Track.Detune
        sex
        addd  NextData,y               ; Apply detune but don't update stored frequency
        stb   @dyn+1
        ldb   #$10                     ; set LSB Frequency Command
        addb  VoiceControl,y
        ldu   #YM2413_A0        
        stb   ,u
        addb  #$20                     ; set Sus/Key/Block/FNum(MSB) Command(and used as 2 cycles tempo)
        nop
        sta   1,u
        _YMBusyWait19
        lda   NoteControl,y            ; load current value (do not erase FNum MSB) (and used as 5 cycles tempo)
        stb   ,u
        anda  #$F0                     ; Clear FNum MSB (and used as 2 cycles tempo)
@dyn    adda  #0                       ; (dynamic) Set Fnum MSB (and used as 2 cycles tempo)
        sta   1,u   
        sta   NoteControl,y
        rts        
 
; 95 notes (Note value $81=C0 $DF=A#7), lowest note for YM2413 is G0
; lower notes (YM2612 compatibility) are mapped to C1 - F#1
Frequencies
        fdb   $0000 ; padding for ($80=rest), saves a dec instruction
        fdb   $0157,$016B,$0181,$0198,$01B0,$01CA,$01E5,$0101,$0110,$0120,$0131,$0143 ; C1 - F#1 / G0 - B0
        fdb   $0157,$016B,$0181,$0198,$01B0,$01CA,$01E5,$0301,$0310,$0320,$0331,$0343 ; C1 - B1
        fdb   $0357,$036B,$0381,$0398,$03B0,$03CA,$03E5,$0501,$0510,$0520,$0531,$0543 ; ...
        fdb   $0557,$056B,$0581,$0598,$05B0,$05CA,$05E5,$0701,$0710,$0720,$0731,$0743 ; 
        fdb   $0757,$076B,$0781,$0798,$07B0,$07CA,$07E5,$0901,$0910,$0920,$0931,$0943 ; 
        fdb   $0957,$096B,$0981,$0998,$09B0,$09CA,$09E5,$0B01,$0B10,$0B20,$0B31,$0B43 ;
        fdb   $0B57,$0B6B,$0B81,$0B98,$0BB0,$0BCA,$0BE5,$0D01,$0D10,$0D20,$0D31,$0D43 ; 
        fdb   $0D57,$0D6B,$0D81,$0D98,$0DB0,$0DCA,$0DE5,$0F01,$0F10,$0F20,$0F31       ; C7 - A#7
        
* ************************************************************************************
*   
        
PSGUpdateTrack
        dec   DurationTimeout,x
        rts        
  
* ************************************************************************************
*   
        
PauseMusic
        rts        

* ************************************************************************************
* 

CoordFlag
        subb  #$E0
        aslb
        ldu   #CoordFlagLookup
        jmp   [b,u] 

CoordFlagLookup
        fdb   cfPanningAMSFMS       ; E0
        fdb   cfDetune              ; E1
        fdb   cfSetCommunication    ; E2
        fdb   cfJumpReturn          ; E3 -- todo
        fdb   cfFadeInToPrevious    ; E4
        fdb   cfSetTempoDivider     ; E5
        fdb   cfChangeFMVolume      ; E6 -- todo
        fdb   cfPreventAttack       ; E7 -- todo
        fdb   cfNoteFill            ; E8
        fdb   cfChangeTransposition ; E9 -- todo
        fdb   cfSetTempo            ; EA
        fdb   cfSetTempoMod         ; EB
        fdb   cfChangePSGVolume     ; EC
        fdb   cfClearPush           ; ED
        fdb   cfStopSpecialFM4      ; EE
        fdb   cfSetVoice            ; EF -- todo
        fdb   cfModulation          ; F0 -- done
        fdb   cfEnableModulation    ; F1 -- done
        fdb   cfStopTrack           ; F2
        fdb   cfSetPSGNoise         ; F3 -- todo
        fdb   cfDisableModulation   ; F4 -- todo
        fdb   cfSetPSGTone          ; F5
        fdb   cfJumpTo              ; F6 -- todo
        fdb   cfRepeatAtPos         ; F7 -- todo
        fdb   cfJumpToGosub         ; F8 -- todo
        fdb   cfOpF9                ; F9
        fdb   cfNop                 ; FA
        fdb   cfNop                 ; FB
        fdb   cfNop                 ; FC
        fdb   cfNop                 ; FD
        fdb   cfNop                 ; FE
        fdb   cfNop                 ; FF

cfPanningAMSFMS
        rts
              
cfDetune
        rts         
            
cfSetCommunication
        rts   
        
cfJumpReturn
        rts         
        
cfFadeInToPrevious
        rts   
        
cfSetTempoDivider
        rts    
        
cfChangeFMVolume
        rts     

cfPreventAttack
        rts      

cfNoteFill 
        rts          

cfChangeTransposition
        rts

cfSetTempo 
        rts          

cfSetTempoMod
        rts        

cfChangePSGVolume
        rts    

cfClearPush
        rts          

cfStopSpecialFM4
        rts     

cfSetVoice
        rts

; (via Saxman's doc): F0wwxxyyzz - modulation
; o	ww - Wait for ww period of time before modulation starts
; o	xx - Modulation Speed
; o	yy - Modulation change per Mod. Step
; o	zz - Number of steps in modulation
;
cfModulation
        lda   PlaybackControl,y
        ora   #$08
        sta   PlaybackControl,y        ; Set bit 3 (08h) of "playback control" byte (modulation on)
        stx   ModulationPtr,y          ; Back up modulation setting address
SetModulation
        ldd   ,x++                     ; also read ModulationSpeed
        std   ModulationWait,y         ; also write ModulationSpeed
        ldd   2,x++                    ; also read ModulationSteps
        sta   ModulationDelta,y        
        lsrb                           ; divide number of steps by 2
        stb   ModulationSteps,y
        lda   PlaybackControl,y
        bita  #$10                     ; Is bit 4 "do not attack next note" (10h) set?
        bne   @a                       ; If so, quit!
        ldd   #0
        std   ModulationVal,y          ; Clear modulation value
@a      rts         

; (via Saxman's doc): Turn on modulation
;
cfEnableModulation
        lda   PlaybackControl,y
        ora   #$08
        sta   PlaybackControl,y        ; Set bit 3 (08h) of "playback control" byte (modulation on)
        rts   

cfStopTrack
        rts

cfSetPSGNoise
        rts        

cfDisableModulation
        rts  

cfSetPSGTone
        rts         

cfJumpTo
        ldd   ,x
        ldx   MusicData
        leax  d,x
        rts             

cfRepeatAtPos
        rts        

cfJumpToGosub
        rts        

cfOpF9     
        rts          

cfNop 
        rts                                                 
                   