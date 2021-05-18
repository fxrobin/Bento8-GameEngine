(main)MULS

        org   $A000
        ldd   #$00FF
        ldx   #data

        tsta
        beq   pos  ; cas $0000 <= d <= $00FF
        bpl   p256 ; cas d = $0100
        tstb
        bne   neg  ; cas $FF01 >= d >= $FFFF    

n256    ldb   2,x  ; cas d = $FF00
        negb
        bra   end

p256    clra
        ldb   2,x
        bra   end

pos     lda   2,x 
        mul
        tfr   a,b
        clra
        bra   end

neg     lda   2,x    
        negb
        mul
        nega
        negb
        sbca  #0
        tfr   a,b
        lda   #$FF

end

data    fdb $0000
        fcb $FF