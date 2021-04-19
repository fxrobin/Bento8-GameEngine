; ---------------------------------------------------------------------------
; Object - Sonic
;
; input REG : [u] pointer to Object Status Table (OST)
; ---------
;
; Instructions for position-independent code
; ------------------------------------------
; - call to a Main Engine routine (6100 - 9FFF): use a jump (jmp, jsr, rts), do not use branch
; - call to internal object routine: use branch ((l)b__), do not use jump
; - use indexed addressing to access data table: first load table address by using "leax my_table,pcr"
;
; ---------------------------------------------------------------------------

        INCLUDE "./Engine/Macros.asm"   

TestImageSet
        lda   routine,u
        sta   *+4,pcr
        bra   TitleScreen_Routines

TitleScreen_Routines
        lbra  Init1
        lbra  Init2
        lbra  MovePress
        lbra  MoveHeld
Init1
        ldx   #$0000
        jsr   ClearDataMem    
        ldd   #SonAni_Walk
        std   anim,u
        ldb   #$01
        stb   priority,u
        ldd   #$807F
        std   xy_pixel,u
        ; lda   render_flags,u
        ; ora   #render_xloop_mask
        ; sta   render_flags,u
        lda   routine,u
        adda  #$03
        sta   routine,u   
Init2
        ldx   #$0000
        jsr   ClearDataMem    
        lda   routine,u
        adda  #$03
        sta   routine,u           
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
        cmpa  #$06
        bne   TestRtSub
        adda  #$03
        sta   routine,u
        bra   Continue
TestRtSub              
        suba  #$03
        sta   routine,u
Continue
        jsr   AnimateSprite   
        jmp   DisplaySprite
