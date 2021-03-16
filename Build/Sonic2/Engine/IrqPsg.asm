* ---------------------------------------------------------------------------
* IrqPsg
* ------
* IRQ Subroutine to play sound with SN76489
*
* input REG : [dp] with value E7 (from Monitor ROM)
* reset REG : none
*
* IrqOn
* reset REG : [a]
*
* IrqOff
* reset REG : [a]
* ---------------------------------------------------------------------------

irq_routine       equ $6027 
irq_timer_ctrl    equ $E7C5 *@globals
irq_timer         equ $E7C6
irq_one_frame     equ 312*64-1 *@globals              ; one frame timer (lines*cycles_per_lines-1), timer launch at -1
       
IrqOn *@globals        
        lda   $6019                           
        ora   #$20
        sta   $6019                                   ; STATUS register
        andcc #$EF                                    ; tell 6809 to activate irq
        rts
        
IrqOff *@globals
        lda   $6019                           
        anda  #$DF
        sta   $6019                                   ; STATUS register
        orcc  #$10                                    ; tell 6809 to activate irq
        rts
        
IrqPsg *@globals
        lda   <$E5
        sta   IrqPsg_end+1                            ; backup data page
        jsr   PSGFrame
       *jsr   PSGSFXFrame
IrqPsg_end        
        lda   #$00
        sta   <$E5                                    ; restore data page
        jmp   $E830                                   ; return to caller