*(main)test
	opt c,ct

        org   $A000

YM2413_Voices
        ldu   #$FFFF
        ldx   #@data
        lda   #$30
@a      ldb   ,x+
        inca
        cmpa  #$39
        bne   @a
@end    rts   
@data