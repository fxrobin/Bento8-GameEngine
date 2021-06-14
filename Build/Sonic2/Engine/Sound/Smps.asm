* ---------------------------------------------------------------------------
* SMPS 6809 - Sample Music Playback System for 6809 (LWASM)
* ---------------------------------------------------------------------------
* by Bentoc June 2021, based on
* Sonic the Hedgehog 2 disassembled Z80 sound driver
* Disassembled by Xenowhirl for AS
* Additional disassembly work by RAS Oct 2008
* RAS' work merged into SVN by Flamewing
* ---------------------------------------------------------------------------

; SMPS file format offsets
SMPS_DAC_FLAG                equ 8
SMPS_DAC_TRACK               equ 6
PlaybackControl              equ 0
DurationTimeout              equ 11

Track STRUCT
                                                      ;         "playback control"; bits 
                                                      ;         1 (02h)  seems to be "track is at rest"
                                                      ;         2 (04h)  SFX is overriding this track
                                                      ;         3 (08h)  modulation on
                                                      ;         4 (10h)  do not attack next note
                                                      ;         7 (80h)  track is playing
        PlaybackControl                rmb   1
                                                      ;         "voice control"; bits 
                                                      ;         2 (04h)  If set, bound for part II, otherwise 0 (see zWriteFMIorII)
                                                      ;                 -- bit 2 has to do with sending key on/off, which uses this differentiation bit directly
                                                      ;         7 (80h)  PSG Track
        VoiceControl                   rmb   1
        TempoDivider                   rmb   1        ; timing divisor; 1 = Normal, 2 = Half, 3 = Third...
        DataPointer                    rmb   2        ; Track's position
        Transpose                      rmb   1        ; Transpose (from coord flag E9)
        Volume                         rmb   1        ; channel volume (only applied at voice changes)
        AMSFMSPan                      rmb   1        ; Panning / AMS / FMS settings
        VoiceIndex                     rmb   1        ; Current voice in use OR current PSG tone
        VolFlutter                     rmb   1        ; PSG flutter (dynamically effects PSG volume for decay effects)
        StackPointer                   rmb   1        ; "Gosub" stack position offset (starts at 2Ah, i.e. end of track, and each jump decrements by 2)
        DurationTimeout                rmb   1        ; current duration timeout; counting down to zero
        SavedDuration                  rmb   1        ; last set duration (if a note follows a note, this is reapplied to 0Bh)
                                                      ; 0Dh / 0Eh change a little depending on track -- essentially they hold data relevant to the next note to play
        SavedDAC                                      ; DAC  Next drum to play
        FreqLow                        rmb   1        ; FM/PSG  frequency low byte
        FreqHigh                       rmb   1        ; FM/PSG  frequency high byte
        NoteFillTimeout                rmb   1        ; Currently set note fill; counts down to zero and then cuts off note
        NoteFillMaster                 rmb   1        ; Reset value for current note fill
        ModulationPtrLow               rmb   1        ; low byte of address of current modulation setting
        ModulationPtrHigh              rmb   1        ; high byte of address of current modulation setting
        ModulationWait                 rmb   1        ; Wait for ww period of time before modulation starts
        ModulationSpeed                rmb   1        ; Modulation Speed
        ModulationDelta                rmb   1        ; Modulation change per Mod. Step
        ModulationSteps                rmb   1        ; Number of steps in modulation (divided by 2)
        ModulationValLow               rmb   1        ; Current modulation value low byte
        ModulationValHigh              rmb   1        ; Current modulation value high byte
        Detune                         rmb   1        ; Set by detune coord flag E1; used to add directly to FM/PSG frequency
        VolTLMask                      rmb   1        ; zVolTLMaskTbl value set during voice setting (value based on algorithm indexing zGain table)
        PSGNoise                       rmb   1        ; PSG noise setting
        VoicePtrLow                    rmb   1        ; low byte of custom voice table (for SFX)
        VoicePtrHigh                   rmb   1        ; high byte of custom voice table (for SFX)
        TLPtrLow                       rmb   1        ; low byte of where TL bytes of current voice begin (set during voice setting)
        TLPtrHigh                      rmb   1        ; high byte of where TL bytes of current voice begin (set during voice setting)
        LoopCounters                   rmb   $A       ; Loop counter index 0
                                                      ;   ... open ...
        GoSubStack                                    ; start of next track, every two bytes below this is a coord flag "gosub" (F8h) return stack
                                                      ;
                                                      ;        The bytes between +20h and +29h are "open"; starting at +20h and going up are possible loop counters
                                                      ;        (for coord flag F7) while +2Ah going down (never AT 2Ah though) are stacked return addresses going
                                                      ;        down after calling coord flag F8h.  Of course, this does mean collisions are possible with either
                                                      ;        or other track memory if you're not careful with these!  No range checking is performed!
                                                      ;
                                                      ;        All tracks are 2Ah bytes long
ENDSTRUCT

Var STRUCT
        SFXPriorityVal                 rmb   1
        TempoTimeout                   rmb   1
        CurrentTempo                   rmb   1        ; Stores current tempo value here
        StopMusic                      rmb   1        ; Set to 7Fh to pause music, set to 80h to unpause. Otherwise 00h
        FadeOutCounter                 rmb   1
        FadeOutDelay                   rmb   1
        Communication                  rmb   1        ; Unused byte used to synchronise gameplay events with music
        QueueToPlay                    rmb   1        ; if NOT set to 80h, means new index was requested by 68K
        SFXToPlay                      rmb   1        ; When Genesis wants to play "normal" sound, it writes it here
        SFXStereoToPlay                rmb   1        ; When Genesis wants to play alternating stereo sound, it writes it here
        SFXUnknown                     rmb   1        ; Unknown type of sound queue, but it's in Genesis code like it was once used
        VoiceTblPtr                    rmb   2        ; address of the voices
        FadeInFlag                     rmb   1
        FadeInDelay                    rmb   1
        FadeInCounter                  rmb   1
        1upPlaying                     rmb   1
        TempoMod                       rmb   1
        TempoTurbo                     rmb   1        ; Stores the tempo if speed shoes are acquired (or 7Bh is played anywho)
        SpeedUpFlag                    rmb   1
        DACEnabled                     rmb   1
        MusicBankNumber                rmb   1
        IsPalFlag                      rmb   1
ENDSTRUCT

YM2413_A0       fdb   $E7B1 
YM2413_D0       fdb   $E7B2
PSG             fdb   $E7B0

AbsVar          Var

tracksStart		; This is the beginning of all BGM track memory
SongDACFMStart
SongDAC         Track
SongFMStart
SongFM1         Track
SongFM2         Track
SongFM3         Track
SongFM4         Track
SongFM5         Track
SongFM6         Track
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

PALUpdTick      fcb   0     ; this counts from 0 to 5 to periodically "double update" for PAL systems (basically every 6 frames you need to update twice to keep up)
CurDAC          fcb   0     ; indicate DAC sample playing status
CurSong         fcb   0     ; currently playing song index
DoSFXFlag       fcb   0     ; flag to indicate we're updating SFX (and thus use custom voice table); set to FFh while doing SFX, 0 when not.
Paused          fcb   0     ; 0 = normal, -1 = pause all sound and music

SongPage        fcb   0     ; memory page of song data
Sample_index    fdb   0
Sample_page     fcb   0
Sample_data     fdb   0
Sample_data_end fdb   0
Sample_rate     fcb   0

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
        stb   ,x
 ENDM  
 
_YMBusyWait MACRO
        jsr   YMBusyWait
 ENDM
 
_YMBusyWait2 MACRO
        jsr   YMBusyWait2
 ENDM
 
YMBusyWait
        nop
YMBusyWait2
        tst   #$0000
        pshs  pc

* ************************************************************************************
* receives in X the address of the  to start playing
* destroys A

PlayMusic 
        lda   ,x   
        sta   SongPage
        ldx   1,x
        
        ldd   SMPS_DAC_FLAG,x                         ; load DAC Track
        bne   @a
        ldd   SMPS_DAC_TRACK,x
        std   SongDAC.DataPointer
@a        
        ldd   #$FF05
        sta   AbsVar.StopMusic                        ; music is unpaused
        stb   zPALUpdTick                             ; reset PAL tick
        rts
        
        
* ************************************************************************************
* processes a music frame
*
* SMPS Song Data
* --------------
* value in range [$00, $7F] : Duration value
* value in range [$80]      : Rest (counts as a note value)
* value in range [$81, $DF] : Note value
* value in range [$E0, $FF] : Coordination flag
*
* destroys A,B,X
        
MusicFrame 
        lda   SongPage                 ; page switch to the music
        _SetCartPageA
        clr   DoSFXFlag
        lda   AbsVar.StopMusic
        beq   UpdateEverything         ; branch if music is playing
        jsr   PauseMusic               ; check if we have to unpause
        bra   UpdateDAC
        
UpdateEverything        
        lda   AbsVar.IsPalFlag
        beq   @a
        dec   zPALUpdTick
        bne   @a
        lda   #5
        sta   zPALUpdTick
        jsr   UpdateMusic              ; play 2 frames in one to keep original speed
@a      jsr   UpdateMusic        
        
UpdateDAC   
        lda   Sample_page
        _SetCartPageA                  ; Bankswitch to the DAC data
        lda   SongDAC.CurDAC          ; Get currently playing DAC sound
        bmi   @a                       ; If one is queued (80h+), go to it!
        rts
@a      suba  #$81
        sta   SongDAC.CurDAC
        
        ; TODO
            
        rts

* ************************************************************************************
* 

_UpdateTrack MACRO
        ldx   #\1
        lda   PlaybackControl,x        ; Is bit 7 (80h) set on playback control byte? (means "is playing")
        bpl   @a                       
        jsr   \2                       ; If so, UpdateTrack
@a
 ENDM

UpdateMusic
        jsr   TempoWait
        _UpdateTrack SongDAC,DACUpdateTrack
        _UpdateTrack SongFM1,FMUpdateTrack
        _UpdateTrack SongFM2,FMUpdateTrack
        _UpdateTrack SongFM3,FMUpdateTrack
        _UpdateTrack SongFM4,FMUpdateTrack
        _UpdateTrack SongFM5,FMUpdateTrack
        _UpdateTrack SongFM6,FMUpdateTrack
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

        lda   Var.CurrentTempo  ; tempo value
        adda  Var.TempoTimeout  ; Adds previous value to
        sta   Var.TempoTimeout  ; Store this as new
        bcc   @a
        rts                     ; If addition overflowed (answer greater than FFh), return
@a
        ; So if adding tempo value did NOT overflow, then we add 1 to all durations
        inc   SongDAC.DurationTimeout
        inc   SongFM1.DurationTimeout
        inc   SongFM2.DurationTimeout
        inc   SongFM3.DurationTimeout
        inc   SongFM4.DurationTimeout
        inc   SongFM5.DurationTimeout
        inc   SongFM6.DurationTimeout
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
@b      lda   ,x+                      ; read DAC song data
        cmpa  #$E0
        blo   @a                       ; test for >= E0h, which is a coordination flag
        jsr   CoordFlag
        bra   @b                       ; read all consecutive coordination flags 
@a        
        bpl   SetDuration              ; test for 80h not set, which is a note duration
        sta   SongDAC.SavedDAC	       ; This is a note; store it here
        lda   ,x
        bpl   SetDurationAndForward    ; test for 80h not set, which is a note duration
        lda   SongDAC.SavedDuration
        sta   SongDAC.DurationTimeout
        bra   DACAfterDur

SetDurationAndForward
        leax  1,x
SetDuration
        ; TODO
DACAfterDur
        stx   SongDAC.DataPointer
        ; TODO SFX
        lda   SongDAC.SavedDAC
        cmpa  #$80
        bne   @a
        rts                            ; if a rest, quit
@       suba  #$81                     ; Otherwise, transform note into an index...
        ldx   #DACPitchPtrTbl
        ldb   a,x
        stb   Sample_rate
        asla
        ldx   #DACPtrTbl
        ldu   a,x
        sta   SongDAC.CurDAC
        stu   Sample_index
        lda   ,u
        sta   Sample_page
        ldd   3,u
        std   Sample_data_end
        ldd   1,u
        std   Sample_data        
        rts

DACClearNote
        ldd   #$3880                        ; mute DAC
        ldu   #YM2413_A0
        ldx   #YM2413_D0        
        _WriteYM
        deca
        _YMBusyWait2
        _WriteYM         
        deca
        _YMBusyWait2
        _WriteYM
        rts
        
DACPtrTbl
        fdb   DAC_Sample1 ; $81 - Kick
        fdb   DAC_Sample2 ; $82 - Snare
        fdb   DAC_Sample3 ; $83 - Clap
        fdb   DAC_Sample4 ; $84 - Scratch
        fdb   DAC_Sample5 ; $85 - Timpani
        fdb   DAC_Sample6 ; $86 - Hi Tom
        fdb   DAC_Sample7 ; $87 - Bongo
        fdb   DAC_Sample5 ; $88 - Hi Timpani
        fdb   DAC_Sample5 ; $89 - Mid Timpani
        fdb   DAC_Sample5 ; $8A - Mid Low Timpani
        fdb   DAC_Sample5 ; $8B - Low Timpani
        fdb   DAC_Sample6 ; $8C - Mid Tom
        fdb   DAC_Sample6 ; $8D - Low Tom
        fdb   DAC_Sample6 ; $8E - Floor Tom
        fdb   DAC_Sample7 ; $8F - Hi Bongo
        fdb   DAC_Sample7 ; $90 - Mid Bongo
        fdb   DAC_Sample7 ; $91 - Low Bongo
         
DACPitchPtrTbl
        fcb   $17 ; $81 - Kick
        fcb   $01 ; $82 - Snare
        fcb   $06 ; $83 - Clap
        fcb   $08 ; $84 - Scratch
        fcb   $1B ; $85 - Timpani
        fcb   $0A ; $86 - Hi Tom
        fcb   $1B ; $87 - Bongo
        fcb   $12 ; $88 - Hi Timpani
        fcb   $15 ; $89 - Mid Timpani
        fcb   $1C ; $8A - Mid Low Timpani
        fcb   $1D ; $8B - Low Timpani
        fcb   $02 ; $8C - Mid Tom
        fcb   $05 ; $8D - Low Tom
        fcb   $08 ; $8E - Floor Tom
        fcb   $08 ; $8F - Hi Bongo
        fcb   $0B ; $90 - Mid Bongo
        fcb   $12 ; $91 - Low Bongo
        
DACDecodeTbl
        fcb   0,1,2,4,8,$10,$20,$40
        fcb   $80,$FF,$FE,$FC,$F8,$F0,$E0,$C0

DACTable        
; 30 val ignorées à $00 ($00-$1D inclus)
; 32 val ignorées à $EE ($DF-$FF inclus)
        fdb   $00,$00,$02
        fdb   $00,$20,$02
        fdb   $00,$20,$02
        fdb   $00,$20,$02
        fdb   $00,$20,$02
        fdb   $00,$20,$02
        fdb   $00,$20,$02
        fdb   $00,$20,$02
        fdb   $00,$20,$04
        fdb   $00,$40,$04
        fdb   $00,$40,$04
        fdb   $00,$40,$04
        fdb   $00,$40,$06
        fdb   $00,$60,$06
        fdb   $00,$60,$08
        fdb   $00,$80,$0A
        fdb   $00,$A0,$22
        fdb   $02,$20,$22
        fdb   $02,$20,$22
        fdb   $02,$20,$22
        fdb   $02,$20,$22
        fdb   $02,$20,$22
        fdb   $02,$20,$22
        fdb   $02,$20,$22
        fdb   $02,$20,$24
        fdb   $02,$40,$24
        fdb   $02,$40,$24
        fdb   $02,$40,$24
        fdb   $02,$40,$26
        fdb   $02,$60,$26
        fdb   $02,$60,$28
        fdb   $02,$80,$2A
        fdb   $02,$A0,$44
        fdb   $04,$40,$44
        fdb   $04,$40,$44
        fdb   $04,$40,$44
        fdb   $04,$40,$46
        fdb   $04,$60,$46
        fdb   $04,$60,$48
        fdb   $04,$80,$4A
        fdb   $04,$A0,$66
        fdb   $06,$60,$66
        fdb   $06,$60,$68
        fdb   $06,$80,$6A
        fdb   $06,$A0,$88
        fdb   $08,$80,$8A
        fdb   $08,$A0,$AA
        fdb   $0A,$A0,$CC
        fdb   $0C,$C2,$44
        fdb   $24,$42,$44
        fdb   $24,$42,$44
        fdb   $24,$42,$44
        fdb   $24,$42,$46
        fdb   $24,$62,$46
        fdb   $24,$62,$48
        fdb   $24,$82,$4A
        fdb   $24,$A2,$66
        fdb   $26,$62,$66
        fdb   $26,$62,$68
        fdb   $26,$82,$6A
        fdb   $26,$A2,$88
        fdb   $28,$82,$8A
        fdb   $28,$A2,$AA
        fdb   $2A,$A2,$CC
        fdb   $2C,$C4,$66
        fdb   $46,$64,$66
        fdb   $46,$64,$68
        fdb   $46,$84,$6A
        fdb   $46,$A4,$88
        fdb   $48,$84,$8A
        fdb   $48,$A4,$AA
        fdb   $4A,$A4,$CC
        fdb   $4C,$C6,$88
        fdb   $68,$86,$8A
        fdb   $68,$A6,$AA
        fdb   $6A,$A6,$CC
        fdb   $6C,$C8,$AA
        fdb   $8A,$A8,$CC
        fdb   $8C,$CA,$CC
        fdb   $AC,$CC,$EE
        fdb   $CE,$EE,$EE        

* ************************************************************************************
* 
        
FMUpdateTrack
        dec   DurationTimeout,x
        rts
  
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
        suba  #$E0
        asla
        ldx   #CoordFlagLookup
        jmp   [a,x] 

CoordFlagLookup
        fdb   #cfPanningAMSFMS       ; E0
        fdb   #cfDetune              ; E1
        fdb   #cfSetCommunication    ; E2
        fdb   #cfJumpReturn          ; E3
        fdb   #cfFadeInToPrevious    ; E4
        fdb   #cfSetTempoDivider     ; E5
        fdb   #cfChangeFMVolume      ; E6
        fdb   #cfPreventAttack       ; E7
        fdb   #cfNoteFill            ; E8
        fdb   #cfChangeTransposition ; E9
        fdb   #cfSetTempo            ; EA
        fdb   #cfSetTempoMod         ; EB
        fdb   #cfChangePSGVolume     ; EC
        fdb   #cfClearPush           ; ED
        fdb   #cfStopSpecialFM4      ; EE
        fdb   #cfSetVoice            ; EF
        fdb   #cfModulation          ; F0
        fdb   #cfEnableModulation    ; F1
        fdb   #cfStopTrack           ; F2
        fdb   #cfSetPSGNoise         ; F3
        fdb   #cfDisableModulation   ; F4
        fdb   #cfSetPSGTone          ; F5
        fdb   #cfJumpTo              ; F6
        fdb   #cfRepeatAtPos         ; F7
        fdb   #cfJumpToGosub         ; F8
        fdb   #cfOpF9                ; F9
        fdb   #cfNop                 ; FA
        fdb   #cfNop                 ; FB
        fdb   #cfNop                 ; FC
        fdb   #cfNop                 ; FD
        fdb   #cfNop                 ; FE
        fdb   #cfNop                 ; FF      
        
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

cfModulation
        rts         

cfEnableModulation
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
        rts             

cfRepeatAtPos
        rts        

cfJumpToGosub
        rts        

cfOpF9     
        rts          

cfNop 
        rts                                                 
        