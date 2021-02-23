* Generated Code

LoadAct
        ldd   #Black_palette
        std   Ptr_palette
        jsr   UpdatePalette
        ldx   #$1111                   * set Background solid color
        ldb   #$62                     * load page 2
        stb   $E7E6                    * in cartridge space ($0000-$3FFF)
        jsr   ClearCartMem
        lda   $E7DD                    * set border color
        anda  #$F0
        adda  #$01                     * color ref
        sta   $E7DD
        anda  #$0F
        adda  #$80
        sta   screen_border_color+1    * maj WaitVBL
        jsr   WaitVBL
        ldx   #$1111                   * set Background solid color
        ldb   #$63                     * load page 3
        stb   $E7E6                    * in cardtridge space ($0000-$3FFF)
        jsr   ClearCartMem
        ldd   #Pal_TitleScreen
        std   Ptr_palette
        jsr   UpdatePalette
        rts