        INCLUDE "./includ.asm"
        org $A000
 opt c,ct        

        lda #$E7
        tfr a,dp
        ldd #img1
