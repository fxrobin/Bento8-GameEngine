        INCLUDE "./includ.asm"
        org $A000
 opt c,ct        

test_TEST
        lda #$E7
        tfr a,dp
        ldd #img1
