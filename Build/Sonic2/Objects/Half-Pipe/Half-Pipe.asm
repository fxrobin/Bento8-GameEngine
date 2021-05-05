; ---------------------------------------------------------------------------
; Object - Half Pipe for Special Stage
;
; input REG : [u] pointer to Object Status Table (OST)
; ---------
;
; ---------------------------------------------------------------------------
HalfPipe
        lda   routine,u
        asla
        ldx   #HalfPipe_Routines
        jmp   [a,x]

HalfPipe_Routines
        fdb   HalfPipe_Init
        fdb   HalfPipe_Display

HalfPipe_Init
        ldd   #Ani_halfPipe_straight
        std   anim,u
        ldb   #$05
        stb   priority,u
        ldd   #$807F
        addb  subtype,u
        std   xy_pixel,u
        lda   render_flags,u
        ora   #render_overlay_mask
        sta   render_flags,u        
        inc   routine,u
        
HalfPipe_Display
        jsr   AnimateSprite
        jmp   DisplaySprite        
                                                      