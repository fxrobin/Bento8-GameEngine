* ---------------------------------------------------------------------------
* Smps 6809
* ---------
*
* ---------------------------------------------------------------------------

MUSIC_STOPPED                equ 0
MUSIC_PLAYING                equ 1
SMPS_DAC_FLAG                equ 8
SMPS_DAC_TRACK               equ 6

* ************************************************************************************
* receives in X the address of the  to start playing
* destroys A

PlayMusic 
        lda   ,x   
        sta   Music_page
        ldx   1,x
        
        ; search DAC Track
        ldd   SMPS_DAC_FLAG,x
        bne   @a
        ldd   SMPS_DAC_TRACK,x
        std   DAC_track
@a        
        stx   Music_start                             ; store the begin point of music
        stx   Music_pointer                           ; set music pointer to begin of music
        stx   Music_loop_point                        ; looppointer points to begin too
        lda   #0
        sta   Music_skip_frames                       ; reset the skip frames
        lda   #MUSIC_PLAYING
        sta   MusicStatus                             ; music is ready for playing by MusicFrame
        rts
        
        
* ************************************************************************************
* processes a music frame
*
* SMPS Song Data
* --------------
* value in range [$00, $7F]: Duration value
* value in range [$80]: Rest (counts as a note value)
* value in range [$81, $DF]: Note value
* value in range [$E0, $FF]: Coordination flag
*
* destroys A,B,X
        
MusicFrame 
        lda   Music_status                            ; check if we have got to play a tune
        bne   @a
        rts
@a
        lda   Music_page
        _SetCartPageA
        
ProcessDAC        
        ldx   DAC_track
        beq   ProcessPSG
        lda   ,x
        bpl   DACNoteDuration
        suba  #$81
        bcs   DACClearNote
        cmpa  #$5E
        bhi   ProcessCoordinationFlag
        asla
        ldx   #DACPtrTbl
        ldu   a,x
        stu   Sample_index
        lda   ,u
        sta   Sample_page
        _SetCartPageA
        ldd   3,u
        std   Sample_data_end
        ldd   1,u
        std   Sample_data
        
DACNoteDuration

DACClearNote
        ; mute DAC
        ldd   #$3880
        ldu   #YM2413_REG
        ldx   #YM2413_DATA        
        sta   ,u
        nop
        nop        
        stb   ,x
        deca
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop                                        
        sta   ,u
        nop
        nop
        stb   ,x           
        deca
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop                                        
        sta   ,u
        nop
        nop
        stb   ,x
                
ProcessPSG     

ProcessCoordinationFlag
        suba  #$E0
        asla
        ldx   #coordflagLookup
        jsr   [a,x] 
        

        rts

coordflagLookup
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
cfDetune             
cfSetCommunication   
cfJumpReturn         
cfFadeInToPrevious   
cfSetTempoDivider    
cfChangeFMVolume     
cfPreventAttack      
cfNoteFill           
cfChangeTransposition
cfSetTempo           
cfSetTempoMod        
cfChangePSGVolume    
cfClearPush          
cfStopSpecialFM4     
cfSetVoice           
cfModulation         
cfEnableModulation   
cfStopTrack          
cfSetPSGNoise        
cfDisableModulation  
cfSetPSGTone         
cfJumpTo             
cfRepeatAtPos        
cfJumpToGosub        
cfOpF9               
cfNop 
        rts                                          

YM2413_REG                   fdb   $E7B1 
YM2413_DATA                  fdb   $E7B2
Music_status                 fcb   $00   ; are we playing a background music?        
Music_page                   fcb   $00   ; memory page of Music Data
Music_start                  fdb   $0000 ; the pointer to the beginning of music
Music_pointer                fdb   $0000 ; the pointer to the current
Music_loop_point             fdb   $0000 ; the pointer to the loop begin
Music_skip_frames            fcb   $00   ; the frames we need to skip
DAC_track                    fdb   $0000 ; the pointer to the DAC track
Sample_index                 fdb   $0000
Sample_page                  fdb   $00
Sample_data                  fdb   $0000
Sample_data_end              fdb   $0000

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
        
        