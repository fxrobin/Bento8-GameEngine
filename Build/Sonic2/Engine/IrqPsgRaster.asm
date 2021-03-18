* ---------------------------------------------------------------------------
* IrqPsgRaster/IrqPsg
* ------
* IRQ Subroutine to play sound with SN76489 and render some Raster lines
*
* input REG : [dp] with value E7 (from Monitor ROM)
* reset REG : none
*
* IrqOn
* reset REG : [a]
*
* IrqOff
* reset REG : [a]
*
* IrqSync
* input REG : [a] screen line (0-199)
*             [x] timer value
* reset REG : [d]
*
* IrqSync
* reset REG : [d]
* ---------------------------------------------------------------------------
       
irq_routine       equ $6027 *@globals
irq_timer_ctrl    equ $E7C5 *@globals
irq_timer         equ $E7C6 *@globals
irq_one_frame     equ 312*64-1 *@globals              ; one frame timer (lines*cycles_per_lines-1), timer launch at -1
Irq_Raster_Page   fdb $00 *@globals
Irq_Raster_Start  fdb $0000 *@globals
Irq_Raster_End    fdb $0000 *@globals
       
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

IrqSync *@globals
        ldb   #$42
        stb   irq_timer_ctrl
        
        ldb   #8                                      ; ligne * 64 (cycles par ligne) / 8 (nb cycles boucle tempo)
        mul
        tfr   d,y
        leay  -32,y                                   ; manual adjustment

IrqSync_1
        tst   $E7E7                                   ;
        bmi   IrqSync_1                               ; while spot is in a visible screen line        
IrqSync_2
        tst   $E7E7                                   ;
        bpl   IrqSync_2                               ; while spot is not in a visible screen line
IrqSync_3
        leay  -1,y                                    ;
        bne   IrqSync_3                               ; wait until desired line
       
        stx   irq_timer                               ; spot is at the end of desired line
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
       
IrqPsgRaster *@globals
        lda   <$E5
        sta   IrqPsgRaster_end+1                      ; backup data page
        
        lda   Irq_Raster_Page
        sta   <$E5                                    ; load Raster data page
        ldx   Irq_Raster_Start
        lda   #32        
IrqPsgRaster_1      
        bita  <$E7
        beq   IrqPsgRaster_1                          ; while spot is not in a visible screen col
IrqPsgRaster_2        
        bita  <$E7 
        bne   IrqPsgRaster_2                          ; while spot is in a visible screen col
                
        mul                                           ; tempo                
IrqPsgRaster_render
        mul                                           ; tempo
        mul                                           ; tempo
        tfr   a,b                                     ; tempo
        lda   ,x+
        sta   <$DB
        ldd   ,x++
        stb   <$DA 
        sta   <$DA
        cmpx  Irq_Raster_End
        bne   IrqPsgRaster_render 

       jsr   PSGFrame
       *jsr   PSGSFXFrame
IrqPsgRaster_end        
        lda   #$00
        sta   <$E5                                    ; restore data page
        jmp   $E830                                   ; return to caller 
