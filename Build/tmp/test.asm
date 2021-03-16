(main)test

        org   $6200
        setdp $E7
        lda #$E7
        tfr a,dp
        
Irq_Raster_End fdb $0000        
(info)
IrqPsgRaster_render
        mul
        mul
        mul
        mul
        tfr   a,b
        lda   #$1E
        sta   <$E7DB
        ldd   ,x++
        sta   <$E7DA                                    ; 3rd cycle of sta should be near col 62
        stb   <$E7DA                                    ; 3rd cycle of stb should be near col 2
        cmpx  Irq_Raster_End
        bne   IrqPsgRaster_render 
(info)