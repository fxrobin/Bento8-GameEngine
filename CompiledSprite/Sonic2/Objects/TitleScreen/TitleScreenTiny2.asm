(main)TITLESCR
        INCLUD GLOBALS
        INCLUD CONSTANT
        org   $A000

        ldd   #Img_emblemFront
        std   mapping_frame,u
        ldb   #$01
        stb   priority,u
        ldd   #$807F
        std   x_pixel,u
        lda   render_flags,u
        ora   #render_fixedoverlay_mask
        sta   render_flags,u        
        jmp   DisplaySprite
       