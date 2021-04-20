; ---------------------------------------------------------------------------
; Object - TestImageSet
;
; input REG : [u] pointer to Object Status Table (OST)
; ---------
;
; ---------------------------------------------------------------------------

TestImageSet
        lda   routine,u
        asla
        ldx   #TitleScreen_Routines
        jmp   [a,x]

TitleScreen_Routines
        fdb   Init1
        fdb   Init2
        fdb   Move

Init1
        ldx   #$0000
        jsr   ClearDataMem    
        
        ldd   #Img_SonicWalk
        std   image_set,u
        ldb   #$01
        stb   priority,u
        ldd   #$807F
        std   xy_pixel,u
        inc   routine,u
        
Init2
        ldx   #$0000
        jsr   ClearDataMem    
        inc   routine,u
        
Move
        lda   Dpad_Press
        ldb   Fire_Press
TestLeft
        bita  #c1_button_left_mask
        beq   TestRight   
        dec   x_pixel,u
        bra   TestUp
TestRight        
        bita  #c1_button_right_mask
        beq   TestUp   
        inc   x_pixel,u
TestUp
        bita  #c1_button_up_mask
        beq   TestDown   
        dec   y_pixel,u
        bra   TestBtn
TestDown
        bita  #c1_button_down_mask
        beq   TestBtn   
        inc   y_pixel,u     
TestBtn
        bitb  #c1_button_A_mask
        beq   Continue
        *lda   render_flags,u
        *eora  #render_ymirror_mask
        *sta   render_flags,u
        bsr   NextTest
Continue
        jmp   DisplaySprite

NextTest
        lda   routine_secondary,u
        asla
        ldx   #TIS_SubRoutines
        jmp   [a,x]

TIS_SubRoutines
        fdb   Run
        fdb   Fall
        fdb   Breathe
        fdb   Walk        
        
Run
        ldd   #Img_SonicRun
        std   image_set,u
        lda   render_flags,u
        anda  #^render_overlay_mask
        sta   render_flags,u           
        inc   routine_secondary,u
        rts
Fall
        ldd   #Img_SonicFall
        std   image_set,u
        lda   render_flags,u
        ora   #render_overlay_mask
        sta   render_flags,u        
        inc   routine_secondary,u
        rts
Breathe     
        ldd   #Img_SonicBreathe
        std   image_set,u
        lda   render_flags,u
        ora   #render_overlay_mask
        sta   render_flags,u           
        inc   routine_secondary,u
        rts
Walk
        *ldd   #Img_SonicWalk
        std   image_set,u
        lda   render_flags,u
        anda  #^render_overlay_mask
        sta   render_flags,u           
        clr   routine_secondary,u
        rts           
       