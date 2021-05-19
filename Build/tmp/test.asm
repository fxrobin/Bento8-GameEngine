(main)MULS

        org   $A000
        ldd   #$00FF
        ldx   #data
(info)
        tsta
        beq   pos  ; cas $0000 <= d <= $00FF
        bpl   p256 ; cas d = $0100
        negb
        bne   neg  ; cas $FF01 >= d >= $FFFF    
(info)
n256    ldb   2,x  ; cas d = $FF00
        negb
        bra   end
(info)
p256    clra
        ldb   2,x
        bra   end
(info)
pos     lda   2,x 
        mul
        tfr   a,b
        clra
        bra   end
(info)
neg     lda   2,x    
        mul
        nega
        negb
        sbca  #0
        tfr   a,b
        lda   #$FF
(info)
end
        std   sx+1

data    fdb $0000
        fcb $FF
                                              
sx      ldd   #$0000                   ; (dynamic)
        ldx   *-2
        lsra
        rorb
        lsra
        rorb        
        abx

         
sxCenter
        ldb   #$00
        abx

(info)
        