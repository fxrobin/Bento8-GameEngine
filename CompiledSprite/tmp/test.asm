(main)PlayPCM
        org $A000

        lda   #$0F
        cmpa  #$0F
        bcs   test
        nop
test
        nop