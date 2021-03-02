; ---------------------------------------------------------------------------
; Object - TestImageSet
;
; input REG : [u] pointer to Object Status Table (OST)
; ---------
;
; Instructions for position-independent code
; ------------------------------------------
; - call to a Main Engine routine (6100 - 9FFF): use a jump (jmp, jsr, rts), do not use branch
; - call to internal object routine: use branch ((l)b__), do not use jump
; - use indexed addressing to access data table: first load table address by using "leax my_table,pcr"
; ---------------------------------------------------------------------------

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
        lda   routine,u
        adda  #$03
        sta   routine,u   
        
Move
        lda   Dpad_Held
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
        sta   *+4,pcr
        bra   TIS_SubRoutines

TIS_SubRoutines
        lbra  Run
        lbra  Fall
        lbra  Breathe
        lbra  Walk        
        
Run
        ldd   #Img_SonicRun
        std   image_set,u
        lda   render_flags,u
        anda  #:render_overlay_mask
        sta   render_flags,u           
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u
        rts
Fall
        ldd   #Img_SonicFall
        std   image_set,u
        lda   render_flags,u
        ora   #render_overlay_mask
        sta   render_flags,u        
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u
        rts
Breathe     
        ldd   #Img_SonicBreathe
        std   image_set,u
        lda   render_flags,u
        ora   #render_overlay_mask
        sta   render_flags,u           
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u
        rts
Walk
        ldd   #Img_SonicWalk
        std   image_set,u
        lda   render_flags,u
        anda  #:render_overlay_mask
        sta   render_flags,u           
        clr   routine_secondary,u
        rts           
       