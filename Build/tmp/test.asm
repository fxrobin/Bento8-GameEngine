        INCLUDE "./includ.asm"
        org $A000
 opt c,ct        
        lda #$E7
        tfr a,dp
        
Irq_Raster_End fdb $0000    
    
offset  equ 0

param1  equ $FF
param2  equ $10
 
        tfr  b,a

m_ldd MACRO
        ldd   #(\1*256)+\2
 ENDM  

IrqPsgRaster_render
        lda   #included_equ
        tfr   a,b                                     ; tempo
        tfr   a,b                                     ; tempo
        tfr   a,b                                     ; tempo        
        ldx   1,x
        stx   *+6
        lda   ,x   
        sta   <$E7DB
        ldd   #$0000
        stb   <$E7DA
        sta   <$E7DA
        leax  3,x
        cmpx  Irq_Raster_End
        lda   #offset
        bne   IrqPsgRaster_render 
        lda   #^param2
        m_ldd  param1,param2   
          