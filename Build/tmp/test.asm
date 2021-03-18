(main)test

        org   $6200
        setdp $E7
        lda #$E7
        tfr a,dp
        
Irq_Raster_End fdb $0000        
(info)
IrqPsgRaster_render
        nop                                           ; tempo
        nop                                           ; tempo
        mul                                           ; tempo
        mul                                           ; tempo
        tfr   a,b                                     ; tempo
        lda   ,x+
        sta   <$E7DB
        ldd   ,x++
        stb   <$E7DA 
        sta   <$E7DA
        cmpx  Irq_Raster_End
        bne   IrqPsgRaster_render 
(info) 