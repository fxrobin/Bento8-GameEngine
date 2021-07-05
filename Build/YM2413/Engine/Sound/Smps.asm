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
PSG                          equ   $E7B0
YM2413_A0                    equ   $E7B1
YM2413_A1                    equ   $E7B2

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
                                                      ;         0-3 (00h-0Fh) Channel number
                                                      ;         7   (80h) PSG Track
                                                      ; PSG     Chn       |a| |1Fh|
                                                      ; VOL1    0x90	= 100 1xxxx	vol 4b xxxx = attenuation value
                                                      ; VOL2    0xb0	= 101 1xxxx	vol 4b
                                                      ; VOL3    0xd0	= 110 1xxxx	vol 4b                                                      
                                                      
VoiceControl                   rmb   1
                                                      ;         "note control"; bits
                                                      ;         0-3 (00h-0Fh) Current Block(0-2) and FNum(8)
                                                      ;         4   (10h) Key On
                                                      ;         5   (20h) Sustain On
NoteControl                    rmb   1
TempoDivider                   rmb   1                ; timing divisor; 1 = Normal, 2 = Half, 3 = Third...
DataPointer                    rmb   2                ; Track's position
Transpose                      rmb   1                ; Transpose (from coord flag E9)
InstrAndVolume                 rmb   1                ; (Dependency) Should follow Transpose - channel instrument and volume (only applied at voice changes)
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
                                                      ; start of next track, every two bytes below this is a coord flag "gosub" (F8h) return stack
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
TranspAndInstrAndVol         equ   6
Transpose                    equ   6
InstrAndVolume               equ   7
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
GoSubStack                   equ   42

******************************************************************************

Var STRUCT
SFXPriorityVal                 rmb   1        
TempoTimeout                   rmb   1        
CurrentTempo                   rmb   1                ; Stores current tempo value here
StopMusic                      rmb   1                ; Set to 7Fh to pause music, set to 80h to unpause. Otherwise 00h
FadeOutCounter                 rmb   1        
FadeOutDelay                   rmb   1        
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
 
_YMBusyWait13 MACRO
        nop
        nop
        nop
        nop
        nop                                        
        brn   *
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
        fdb   $36F0 ; drum at max vol        
        fdb   $3700 ; drum at max vol
        fdb   $3800 ; drum at max vol
        fcb   $FF
        
* ************************************************************************************
* Silent
* destroys A, B, U, X
*
* TODO replace with voice block in song

SN76489_Silent
        ldu   #PSG
        lda   #$9F
        sta   ,u
        lda   #$BF
        sta   ,u        
        lda   #$DF
        sta   ,u
        lda   #$FF
        sta   ,u                                
        rts        

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
        ldb   #GoSubStack
        stb   StackPointer,x
        ldd   SMPS_TRK_DATA_PTR,u
        addd  MusicData
        std   DataPointer,x
        ldd   SMPS_TRK_TR_VOL_PTR,u
        std   TranspAndInstrAndVol,x
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
        ldb   #GoSubStack
        stb   StackPointer,x        
        ldd   SMPS_TRK_DATA_PTR,u
        addd  MusicData
        std   DataPointer,x
        ldd   SMPS_TRK_TR_VOL_PTR,u
        std   TranspAndInstrAndVol,x
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
        _InitTrackFM SongDAC,$06,$00   ; optim VoiceControl inutile
@dyn    lda   #$00                     ; (dynamic)
        deca                           ; nb fm track - 1 (dac track)      
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

ipsg3   _InitTrackPSG SongPSG3,$D0
ipsg2   _InitTrackPSG SongPSG2,$B0  
ipsg1   _InitTrackPSG SongPSG1,$90
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
        _UpdateTrack SongFM0,FMUpdateTrack ; trompette (avec piano basse) 7      
        _UpdateTrack SongFM1,FMUpdateTrack ; trompette (avec piano basse) 9 doublage piste 0
        _UpdateTrack SongFM2,FMUpdateTrack ; trompette intro puis xylophone 12
        _UpdateTrack SongFM3,FMUpdateTrack ; bassline 14
        _UpdateTrack SongFM4,FMUpdateTrack ; trompette fantome 5
        _UpdateTrack SongFM5,FMUpdateTrack
        ;_UpdateTrack SongFM6,FMUpdateTrack
        ;_UpdateTrack SongFM7,FMUpdateTrack
        ;_UpdateTrack SongFM8,FMUpdateTrack                
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
        _WriteYM    
        rts
@data
        fcb   $34 ; $81 - Kick
        fcb   $28 ; $82 - Snare
        fcb   $21 ; $83 - Clap
        fcb   $22 ; $84 - Scratch
        fcb   $22 ; $85 - Timpani
        fcb   $24 ; $86 - Hi Tom
        fcb   $24 ; $87 - Bongo
        fcb   $24 ; $88 - Hi Timpani
        fcb   $28 ; $89 - Mid Timpani
        fcb   $30 ; $8A - Mid Low Timpani
        fcb   $30 ; $8B - Low Timpani
        fcb   $28 ; $8C - Mid Tom
        fcb   $30 ; $8D - Low Tom
        fcb   $30 ; $8E - Floor Tom
        fcb   $24 ; $8F - Hi Bongo
        fcb   $28 ; $90 - Mid Bongo
        fcb   $30 ; $91 - Low Bongo
 
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
* FM Track Update

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
        lda   1,x
        sta   ModulationSpeed,y
        lda   ModulationSteps,y
        bne   @e
        lda   3,x
        sta   ModulationSteps,y     
        neg   ModulationDelta,y
        rts                
@e      dec   ModulationSteps,y
        ldb   ModulationDelta,y
        sex
        addd  ModulationVal,y
        std   ModulationVal,y
                
FMUpdateFreqNoteFill
        ldb   Detune,y
        sex
        addd  NextData,y               ; Apply detune but don't update stored frequency
        addd  ModulationVal,y        
        sta   @dyn+1
        lda   #$10                     ; set LSB Frequency Command
        adda  VoiceControl,y
        sta   YM2413_A0
        adda  #$10                     ; set Sus/Key/Block/FNum(MSB) Command(and used as 2 cycles tempo)
        nop
        stb   YM2413_A1
        _YMBusyWait17
        ldb   NoteControl,y            ; load current value (do not erase FNum MSB) (and used as 5 cycles tempo)
        sta   YM2413_A0
        andb  #$F0                     ; Clear FNum MSB (and used as 2 cycles tempo)
@dyn    addb  #0                       ; (dynamic) Set Fnum MSB (and used as 2 cycles tempo)
        stb   YM2413_A1
        stb   NoteControl,y
        rts
 
NoteFillUpdate
        lda   NoteFillTimeout,y        ; Get current note fill value
        beq   DoModulationNoteFill     ; If zero, return!
        dec   NoteFillTimeout,y        ; Decrement note fill
        bne   DoModulationNoteFill     ; If not zero, return
        
        lda   PlaybackControl,y
        ora   #$02                     ; Set bit 1 (track is at rest)
        sta   PlaybackControl,y        
        lda   VoiceControl,y           ; Send a Key Off
        adda  #$20                     ; set Sus/Key/Block/FNum(MSB) Command
        sta   YM2413_A0
        ldb   NoteControl,y            ; load current value (do not erase FNum MSB)  (and used as 2 cycles tempo)
        andb  #$EF                     ; Clear bit 4 (10h) Key Off (and used as 2 cycles tempo)
        stb   YM2413_A1                ; send to YM
        stb   NoteControl,y                
        rts 
 
FMUpdateTrack
        dec   DurationTimeout,y        ; Decrement duration
        bne   NoteFillUpdate           ; If not time-out yet, go do updates only
        lda   PlaybackControl,y
        anda  #$EF
        sta   PlaybackControl,y        ; When duration over, clear "do not attack" bit 4 (0x10) of track's play control
        
FMDoNext
        ldx   DataPointer,y
        lda   PlaybackControl,y        ; Clear bit 1 (02h) "track is rest" from track
        anda  #$FD
        sta   PlaybackControl,y        
       
FMReadCoordFlag        
        ldb   ,x+                      ; Read song data
        stb   NoteDyn+1
        cmpb  #$E0
        blo   FMNoteOff                ; Test for >= E0h, which is a coordination flag
        jsr   CoordFlag
        bra   FMReadCoordFlag          ; Read all consecutive coordination flags

FMNoteOff
        lda   PlaybackControl,y
        anda  #$14                     ; Are bits 4 (no attack) or 2 (SFX overriding) set?
        bne   NoteDyn                  ; If they are, skip
        lda   VoiceControl,y           ; Otherwise, send a Key Off
        adda  #$20                     ; set Sus/Key/Block/FNum(MSB) Command
        sta   YM2413_A0
        ldb   NoteControl,y            ; load current value (do not erase FNum MSB)  (and used as 2 cycles tempo)
        andb  #$EF                     ; Clear bit 4 (10h) Key Off (and used as 2 cycles tempo)
        stb   YM2413_A1                ; send to YM
        stb   NoteControl,y                
NoteDyn ldb   #0                       ; (dynamic) retore note value   
        bpl   FMSetDuration            ; Test for 80h not set, which is a note duration
        
FMSetFreq
        subb  #$80                     ; Test for a rest
        bne   @a
        lda   PlaybackControl,y        ; Set bit 1 (track is at rest)
        ora   #$02
        sta   PlaybackControl,y
        bra   @b        
@a      addb  Transpose,y              ; Add current channel transpose (coord flag E9)
        aslb                           ; Transform note into an index...
        ldu   #FMFrequencies
        lda   #0    
        ldd   d,u
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
        beq   @a                       
        bra   FMPrepareNote            ; If so, quit
@a      ldb   NoteFillMaster,y
        stb   NoteFillTimeout,y        ; Reset 0Fh "note fill" value to master
        clr   VolFlutter,y             ; Reset PSG flutter byte
        bita  #$08                     ; Is bit 3 (08h) modulation turned on?
        bne   @b
        bra   FMPrepareNote            ; if not, quit
@b      ldx   ModulationPtr,y
        jsr   SetModulation            ; reload modulation settings for the new note
        
FMPrepareNote
        lda   PlaybackControl,y
        bita  #$02                     ; Is bit 1 (02h) "track is at rest" set on playback?
        beq   FMUpdateFreqAndNoteOn                       
        rts                            ; If so, quit
FMUpdateFreqAndNoteOn
        ldb   Detune,y
        sex
        addd  NextData,y               ; Apply detune but don't update stored frequency
        sta   @dyn+1
        lda   #$10                     ; set LSB Frequency Command
        adda  VoiceControl,y
        sta   YM2413_A0
        adda  #$10                     ; set Sus/Key/Block/FNum(MSB) Command(and used as 2 cycles tempo)
        nop
        stb   YM2413_A1
        _YMBusyWait17
        ldb   NoteControl,y            ; load current value (do not erase FNum MSB) (and used as 5 cycles tempo)
        orb   #$10                     ; Set bit 4 (10h) Key On        
        sta   YM2413_A0
        andb  #$F0                     ; Clear FNum MSB (and used as 2 cycles tempo)
@dyn    addb  #0                       ; (dynamic) Set Fnum MSB (and used as 2 cycles tempo)
        stb   YM2413_A1   
        stb   NoteControl,y
        
DoModulation  
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
        lda   1,x
        sta   ModulationSpeed,y
        lda   ModulationSteps,y
        bne   @e
        lda   3,x
        sta   ModulationSteps,y     
        neg   ModulationDelta,y
        rts                
@e      dec   ModulationSteps,y
        ldb   ModulationDelta,y
        sex
        addd  ModulationVal,y
        std   ModulationVal,y        
              
FMUpdateFreq
        ldb   Detune,y
        sex
        addd  NextData,y               ; apply detune but don't update stored frequency
        addd  ModulationVal,y          ; add modulation effect
        sta   @dyn+1
        lda   #$10                     ; set LSB Frequency Command
        adda  VoiceControl,y           ; get channel number
        sta   YM2413_A0                ; send Fnum update Command
        adda  #$10                     ; set Sus/Key/Block/FNum(MSB) Command(and used as 2 cycles tempo)
        nop                            ; total wait 4 cycles
        stb   YM2413_A1                ; send FNum (b0-b7)
        _YMBusyWait17                  ; total wait 24 cycles
        ldb   NoteControl,y            ; load current value (do not erase FNum MSB) (and used as 5 cycles tempo)
        sta   YM2413_A0                ; send command
        andb  #$F0                     ; clear FNum MSB (and used as 2 cycles tempo)
@dyn    addb  #0                       ; (dynamic) Set Fnum MSB (and used as 2 cycles tempo)
        stb   YM2413_A1                ; send FNum (b8) and Block (b0-b2)
        stb   NoteControl,y
        rts        
 
; 95 notes (Note value $81=C0 $DF=A#7)
FMFrequencies
        fdb   $0000 ; padding for ($80=rest), saves a dec instruction
        fdb   $00AD,$00B7,$00C2,$00CD,$00DA,$00E6,$00F4,$0102,$0112,$0122,$0133,$0146 ; C0 - B0
        fdb   $0159,$016D,$0183,$019A,$01B3,$01CC,$01E8,$0302,$0312,$0322,$0333,$0346 ; C1 - B1
        fdb   $0359,$036D,$0383,$039A,$03B3,$03CC,$03E8,$0502,$0512,$0522,$0533,$0546 ; C2 - B2
        fdb   $0559,$056D,$0583,$059A,$05B3,$05CC,$05E8,$0702,$0712,$0722,$0733,$0746 ; C3 - B3
        fdb   $0759,$076D,$0783,$079A,$07B3,$07CC,$07E8,$0902,$0912,$0922,$0933,$0946 ; C4 - B4
        fdb   $0959,$096D,$0983,$099A,$09B3,$09CC,$09E8,$0B02,$0B12,$0B22,$0B33,$0B46 ; C5 - B5
        fdb   $0B59,$0B6D,$0B83,$0B9A,$0BB3,$0BCC,$0BE8,$0D02,$0D12,$0D22,$0D33,$0D46 ; C6 - B6
        fdb   $0D59,$0D6D,$0D83,$0D9A,$0DB3,$0DCC,$0DE8,$0F02,$0F12,$0F22,$0F33       ; C7 - A#7        
        
* ************************************************************************************
*   PSG Update Track

_PSGNoteOff MACRO
        lda   VoiceControl,y           ; Get "voice control" byte (loads upper bits which specify attenuation setting)
        ora   #$1F                     ; Attenuation Off
        sta   PSG
 ENDM
        
PSGDoModulationNoteFill
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
        lda   1,x
        sta   ModulationSpeed,y
        lda   ModulationSteps,y
        bne   @e
        lda   3,x
        sta   ModulationSteps,y     
        neg   ModulationDelta,y
        rts                
@e      dec   ModulationSteps,y
        ldb   ModulationDelta,y
        sex
        addd  ModulationVal,y
        std   ModulationVal,y
                
PSGUpdateFreqNoteFill
        ldb   Detune,y
        sex
        addd  NextData,y               ; Apply detune but don't update stored frequency
        addd  ModulationVal,y        
        sta   @dyn+1
        lda   #$10                     ; set LSB Frequency Command
        adda  VoiceControl,y
        sta   YM2413_A0
        adda  #$10                     ; set Sus/Key/Block/FNum(MSB) Command(and used as 2 cycles tempo)
        nop
        stb   YM2413_A1
        _YMBusyWait17
        ldb   NoteControl,y            ; load current value (do not erase FNum MSB) (and used as 5 cycles tempo)
        sta   YM2413_A0
        andb  #$F0                     ; Clear FNum MSB (and used as 2 cycles tempo)
@dyn    addb  #0                       ; (dynamic) Set Fnum MSB (and used as 2 cycles tempo)
        stb   YM2413_A1   
        stb   NoteControl,y
        rts
 
PSGNoteFillUpdate
        lda   NoteFillTimeout,y        ; Get current note fill value
        beq   PSGDoModulationNoteFill  ; If zero, return!
        dec   NoteFillTimeout,y        ; Decrement note fill
        bne   PSGDoModulationNoteFill  ; If not zero, return
        
        lda   PlaybackControl,y
        ora   #$02                     ; Set bit 1 (track is at rest)
        sta   PlaybackControl,y        
        lda   VoiceControl,y           ; Send a Key Off
        adda  #$20                     ; set Sus/Key/Block/FNum(MSB) Command
        sta   YM2413_A0
        ldb   NoteControl,y            ; load current value (do not erase FNum MSB)  (and used as 2 cycles tempo)
        andb  #$EF                     ; Clear bit 4 (10h) Key Off (and used as 2 cycles tempo)
        stb   YM2413_A1                ; send to YM
        stb   NoteControl,y                
        rts 
 
PSGUpdateTrack
        dec   DurationTimeout,y        ; Decrement duration
        bne   PSGNoteFillUpdate        ; If not time-out yet, go do updates only
        lda   PlaybackControl,y
        anda  #$EF
        sta   PlaybackControl,y        ; When duration over, clear "do not attack" bit 4 (0x10) of track's play control
        
PSGDoNext
        ldx   DataPointer,y
        lda   PlaybackControl,y        ; Clear bit 1 (02h) "track is rest" from track
        anda  #$FD
        sta   PlaybackControl,y        
       
PSGReadCoordFlag        
        ldb   ,x+                      ; Read song data
        cmpb  #$E0
        blo   @a                       ; Test for >= E0h, which is a coordination flag
        jsr   CoordFlag
        bra   PSGReadCoordFlag         ; Read all consecutive coordination flags
@a      bpl   PSGSetDuration           ; Test for 80h not set, which is a note duration
        
PSGSetFreq
        subb  #$81                     ; Test for a rest
        bcc   @a                       ; If a note branch
        lda   PlaybackControl,y        ; If carry (only time that happens if 80h because of earlier logic) this is a rest!
        ora   #$02
        sta   PlaybackControl,y        ; Set bit 1 (track is at rest)
        ldd   #$FFFF                   ; TODO toujours utile ???
        std   NextData,y               ; Store Frequency
        _PSGNoteOff
        rts        
@a
        addb  Transpose,y              ; Add current channel transpose (coord flag E9)
        aslb                           ; Transform note into an index...
        ldu   #PSGFrequencies
        lda   #0    
        ldd   d,u
        std   NextData,y               ; Store Frequency
       
        ldb   ,x                       ; Get next byte
        bpl   PSGSetDurationAndForward  ; Test for 80h not set, which is a note duration
        ldb   SavedDuration,y        
        bra   PSGFinishTrackUpdate

PSGSetDurationAndForward
        leax  1,x
        
PSGSetDuration
        lda   TempoDivider,y
        mul
        stb   SavedDuration,y
        
PSGFinishTrackUpdate
        stb   DurationTimeout,y        ; Last set duration ... put into ticker
        stx   DataPointer,y            ; Stores to the track pointer memory
        lda   PlaybackControl,y
        bita  #$10                     ; Is bit 4 (10h) "do not attack next note" set on playback?
        beq   @a                       
        bra   PSGPrepareNote            ; If so, quit
@a      ldb   NoteFillMaster,y
        stb   NoteFillTimeout,y        ; Reset 0Fh "note fill" value to master
        clr   VolFlutter,y             ; Reset PSG flutter byte
        bita  #$08                     ; Is bit 3 (08h) modulation turned on?
        bne   @b
        bra   PSGPrepareNote           ; if not, quit
@b      ldx   ModulationPtr,y
        jsr   SetModulation            ; reload modulation settings for the new note
        
PSGDoNoteOn
        lda   PlaybackControl,y
        bita  #$02                     ; Is bit 1 (02h) "track is at rest" set on playback?
        beq   PSGUpdateFreqAndNoteOn                       
        rts                            ; If so, quit
PSGUpdateFreq
        ldb   Detune,y
        sex
        addd  NextData,y               ; Apply detune but don't update stored frequency
..


        stb   NoteControl,y
        
PSGDoModulation  
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
        lda   1,x
        sta   ModulationSpeed,y
        lda   ModulationSteps,y
        bne   @e
        lda   3,x
        sta   ModulationSteps,y     
        neg   ModulationDelta,y
        rts                
@e      dec   ModulationSteps,y
        ldb   ModulationDelta,y
        sex
        addd  ModulationVal,y
        std   ModulationVal,y        
              
PSGUpdateFreq
        ldb   Detune,y
        sex
        addd  NextData,y               ; apply detune but don't update stored frequency
        addd  ModulationVal,y          ; add modulation effect
        sta   @dyn+1
        lda   #$10                     ; set LSB Frequency Command
        adda  VoiceControl,y           ; get channel number
        sta   YM2413_A0                ; send Fnum update Command
        adda  #$10                     ; set Sus/Key/Block/FNum(MSB) Command(and used as 2 cycles tempo)
        nop                            ; total wait 4 cycles
        stb   YM2413_A1                ; send FNum (b0-b7)
        _YMBusyWait17                  ; total wait 24 cycles
        ldb   NoteControl,y            ; load current value (do not erase FNum MSB) (and used as 5 cycles tempo)
        sta   YM2413_A0                ; send command
        andb  #$F0                     ; clear FNum MSB (and used as 2 cycles tempo)
@dyn    addb  #0                       ; (dynamic) Set Fnum MSB (and used as 2 cycles tempo)
        stb   YM2413_A1                ; send FNum (b8) and Block (b0-b2)
        stb   NoteControl,y
        rts        
 
; 70 notes
PSGFrequencies
        fdb   $0356,$0326,$02F9,$02CE,$02A5,$0280,$025C,$023A,$021A,$01FB,$01DF,$01C4
        fdb   $10AB,$0193,$017D,$0167,$0153,$0140,$012E,$011D,$010D,$00FE,$00EF,$00E2
        fdb   $00D6,$00C9,$00BE,$00B4,$00A9,$00A0,$0097,$008F,$0087,$007F,$0078,$0071
        fdb   $000B,$0065,$005F,$005A,$0055,$0050,$004B,$0047,$0043,$0040,$003C,$0039
        fdb   $0036,$0033,$0030,$002D,$002B,$0028,$0026,$0024,$0022,$0020,$001F,$001D
        fdb   $001B,$001A,$0018,$0017,$0016,$0015,$0013,$0012,$0011,$0000
                 
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
        fdb   cfSkip1               ; E0 -- unsupported (panning)
        fdb   cfDetune              ; E1 -- done
        fdb   cfSkip1               ; E2 -- unsupported
        fdb   cfJumpReturn          ; E3 -- done
        fdb   cfFadeInToPrevious    ; E4 --todo
        fdb   cfSetTempoDivider     ; E5 -- done
        fdb   cfChangeFMVolume      ; E6 -- done
        fdb   cfPreventAttack       ; E7 -- done
        fdb   cfNoteFill            ; E8 -- done
        fdb   cfChangeTransposition ; E9 -- done
        fdb   cfSetTempo            ; EA -- done
        fdb   cfSetTempoMod         ; EB -- done
        fdb   cfChangePSGVolume     ; EC --todo
        fdb   cfNop                 ; ED -- unsupported
        fdb   cfNop                 ; EE -- unsupported
        fdb   cfSetVoice            ; EF --todo
        fdb   cfModulation          ; F0 -- done
        fdb   cfEnableModulation    ; F1 -- done
        fdb   cfStopTrack           ; F2 -- done
        fdb   cfSetPSGNoise         ; F3 --todo
        fdb   cfDisableModulation   ; F4 -- done
        fdb   cfSetPSGTone          ; F5 -- done
        fdb   cfJumpTo              ; F6 -- done
        fdb   cfRepeatAtPos         ; F7 -- done
        fdb   cfJumpToGosub         ; F8 -- done
        fdb   cfNop                 ; F9 -- unsupported
        fdb   cfNop                 ; FA -- free
        fdb   cfNop                 ; FB -- free
        fdb   cfNop                 ; FC -- free
        fdb   cfNop                 ; FD -- free
        fdb   cfNop                 ; FE -- free
        fdb   cfNop                 ; FF -- free

; (via Saxman's doc): Alter note values by xx
; More or less a pitch bend; this is applied to the frequency as a signed value
;              
cfDetune
        lda   ,x+
        sta   Detune,y
        rts           

; Return (Sonic 1 & 2)
;
cfJumpReturn
        lda   StackPointer,y           ; retrieve stack ptr
        ldx   a,y                      ; load return address
        adda  #2                       
        sta   StackPointer,y           ; free stack position
        rts         
        
cfFadeInToPrevious
        rts   

; Change tempo divider to xx
;        
cfSetTempoDivider
        lda   ,x+
        sta   TempoDivider,y
        rts    
        
; (via Saxman's doc): Change channel volume BY xx; xx is signed
;
cfChangeFMVolume
        ldb   InstrAndVolume,y
        addb  ,x+
        stb   InstrAndVolume,y
        lda   #$30
        adda  VoiceControl,y
        _WriteYM        
        rts     

cfPreventAttack
        lda   PlaybackControl,y
        ora   #$10
        sta   PlaybackControl,y        ; Set bit 4 (10h) on playback control; do not attack next note
        rts      

; (via Saxman's doc): set note fill amount to xx
;
cfNoteFill 
        lda   ,x+
        sta   NoteFillTimeout,y
        sta   NoteFillMaster,y
        rts          

; (via Saxman's doc): add xx to channel key
;
cfChangeTransposition
        lda   Transpose,y
        adda  ,x+
        sta   Transpose,y
        rts

; (via Saxman's doc): set music tempo to xx
;
cfSetTempo 
        lda   ,x+
        sta   AbsVar.CurrentTempo
        rts          

; (via Saxman's doc): Change Tempo Modifier to xx for ALL channels
;
cfSetTempoMod
        lda   ,x+
        sta   SongDAC.TempoDivider
        sta   SongFM0.TempoDivider
        sta   SongFM1.TempoDivider
        sta   SongFM2.TempoDivider
        sta   SongFM3.TempoDivider
        sta   SongFM4.TempoDivider
        sta   SongFM5.TempoDivider
        sta   SongFM6.TempoDivider
        sta   SongFM7.TempoDivider
        sta   SongFM8.TempoDivider
        sta   SongPSG1.TempoDivider
        sta   SongPSG2.TempoDivider
        sta   SongPSG3.TempoDivider
        rts        

cfChangePSGVolume
        rts    
        
; (via Saxman's doc): set voice selection to xx
;
cfSetVoice
        lda   VoiceControl,y           ; read channel nb   
        adda  #$30
        ldb   ,x+
        stb   InstrAndVolume,y        
        _WriteYM
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
        ldd   ,x++                     ; also read ModulationSteps
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

; (via Saxman's doc): stop the track
;
cfStopTrack
        lda   PlaybackControl,y
        anda  #$6F                     ; clear playback byte bit 7 (80h) -- currently playing (not anymore)
        sta   PlaybackControl,y        ; clear playback byte bit 4 (10h) -- do not attack
        
        lda   VoiceControl,y           ; send a Key Off - read channel nb
        adda  #$20                     ; set Sus/Key/Block/FNum(MSB) Command
        sta   YM2413_A0
        ldb   NoteControl,y            ; load current value (do not erase FNum MSB)  (and used as 2 cycles tempo)
        andb  #$EF                     ; clear bit 4 (10h) Key Off (and used as 2 cycles tempo)
        stb   YM2413_A1                ; send to YM
        stb   NoteControl,y               
        
        puls  u                        ; removing return address from stack; will not return to coord flag loop                        
        rts

; (via Saxman's doc): Change current PSG noise to xx (For noise channel, E0-E7)
;
cfSetPSGNoise
        leax  1,x
        rts        

cfDisableModulation
        lda   PlaybackControl,y
        anda  #$F7
        sta   PlaybackControl,y        ; Clear bit 3 (08h) of "playback control" byte (modulation off)        
        rts  

; (via Saxman's doc): Change current PSG tone to xx
;
cfSetPSGTone
        lda   ,x+
        sta   VoiceIndex,y
        rts         

; (via Saxman's doc):  $F6zzzz - jump to position
;    * zzzz - position to loop back to (negative offset)
;
cfJumpTo
        ldd   ,x
        leax  d,x
        rts             

; (via Saxman's doc): $F7xxyyzzzz - repeat section of music
;    * xx - loop index, for loops within loops without confusing the engine.
;          o EXAMPLE: Some notes, then a section that is looped twice, then some more notes, and finally the whole thing is looped three times.
;            The "inner" loop (the section that is looped twice) would have an xx of 01, looking something along the lines of F70102zzzz, whereas the "outside" loop (the whole thing loop) would have an xx of 00, looking something like F70003zzzz.
;    * yy - number of times to repeat
;          o NOTE: This includes the initial encounter of the F7 flag, not number of times to repeat AFTER hitting the flag.
;    * zzzz - position to loop back to (negative offset)
;
cfRepeatAtPos
        ldd   ,x++                     ; Loop index is in 'a'
        adda  LoopCounters             ; Add to make loop index offset
        leau  a,y
        tst   ,u
        bne   @a
        stb   ,u                       ; Otherwise, set it to the new number of repeats  
@a      dec   ,u                       ; One less loop
        beq   @b                       ; If counted to zero, skip the rest of this (hence start loop count of 1 terminates the loop without ever looping)
        ldd   ,x
        leax  d,x                      ; loop back
        rts
@b      leax  2,x
        rts        

; (via Saxman's doc): jump to position yyyy (keep previous position in memory for returning)
cfJumpToGosub
        lda   StackPointer,y
        suba  #2
        sta   StackPointer,y           ; move stack backward
        leau  2,x                      ; move x to return address
        stu   a,y                      ; store return address to stack
        ldd   ,x                       ; read sub address
        leax  d,x                      ; gosub
        rts        

cfOpF9     
        rts          

cfSkip1
        leax  1,x
        rts 

cfNop 
        rts                                                 
                   