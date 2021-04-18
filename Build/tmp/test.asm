        org   $A000
        opt   c,ct
        nop
        mul                                           ; tempo
        tfr   a,b                                     ; tempo        
        ldd   1,x
        std   *+8
        lda   ,x        
        sta   <$DB
        ldd   #$0000
        stb   <$DA 
        sta   <$DA