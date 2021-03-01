(main)TITLESCR
        INCLUD GLOBALS
        INCLUD CONSTANT
        org   $A000

TestImageSet
        lda   routine,u
        sta   *+4,pcr
        bra   TitleScreen_Routines

TitleScreen_Routines
        lbra  Init
        lbra  Move

Init
        ldd   #Img_SonicWalk
        std   image_set,u
        ldb   #$01
        stb   priority,u
        ldd   #$807F
        std   xy_pixel,u
        inc   routine,u
        jmp   DisplaySprite
                
        *lda   render_flags,u
        *ora   #render_overlay_mask
        *sta   render_flags,u
        
Move
        lda   Dpad_Press
        bita  #c1_button_left_mask
        beq   TestRight   
        inc   x_pixel,u
        bra   Continue
TestRight        
        bita  #c1_button_right_mask
        beq   Continue   
        dec   x_pixel,u
Continue        
        jmp   DisplaySprite                

       