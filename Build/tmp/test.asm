        org   $A000
        opt   c,ct
        
        stb   *+6
        stb   *+12
        lda   20,u                          *        subq.w  #2,x_pixel(a0)
        suba  #$00
        sta   20,u
        lda   20,u                          *        addq.w  #1,y_pixel(a0)
        adda  #$00     
        sta   20,u 