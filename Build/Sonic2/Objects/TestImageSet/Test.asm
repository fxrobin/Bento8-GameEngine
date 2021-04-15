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

TestImageSet
        lda   routine,u
        sta   *+4,pcr
        bra   TitleScreen_Routines

TitleScreen_Routines
        lbra  Init1
        lbra  Init2
        lbra  Move
Init1
        ldx   #$0000
        jsr   ClearDataMem    
        ldd   #Img_SonicWalk
        std   image_set,u
        ldb   #$01
        stb   priority,u
        ldd   #$807F
        std   xy_pixel,u
        lda   routine,u
        adda  #$03
        sta   routine,u   
Init2
        ldx   #$0000
        jsr   ClearDataMem    
        lda   routine,u
        adda  #$03
        sta   routine,u           
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
        bra   Continue
TestDown
        bita  #c1_button_down_mask
        beq   Continue   
        inc   y_pixel,u     
Continue
        jmp   DisplaySprite
        
       