(main)test

        org   $6200
        setdp $E7
        lda #$E7
        tfr a,dp
        
Irq_Raster_End fdb $0000        
(info)
IrqPsgRaster_render
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
        bne   IrqPsgRaster_render 
(info) 