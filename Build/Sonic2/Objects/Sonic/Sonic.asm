; ---------------------------------------------------------------------------
; Object - Sonic
;
; input REG : [u] pointer to Object Status Table (OST)
; ---------
;
; ---------------------------------------------------------------------------

        INCLUDE "./Engine/Macros.asm"   

TestImageSet
        lda   routine,u
        asla
        ldx   #TitleScreen_Routines
        jmp   [a,x]

TitleScreen_Routines
        fdb   Init
        fdb   MovePress
        fdb   MoveHeld
Init
        ldd   #SonAni_Walk
        std   anim,u
        ldb   #$01
        stb   priority,u
        ldd   #$807F
        std   xy_pixel,u
        ; lda   render_flags,u
        ; ora   #render_xloop_mask
        ; sta   render_flags,u
        inc   routine,u
MovePress
        lda   Dpad_Press
        ldb   Fire_Press
        bra   TestLeft
MoveHeld
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
        lda   routine,u
        cmpa  #$01
        bne   TestRtSub
        inca
        sta   routine,u
        bra   Continue
TestRtSub              
        deca
        sta   routine,u
Continue
        jsr   AnimateSprite   
        jmp   DisplaySprite
