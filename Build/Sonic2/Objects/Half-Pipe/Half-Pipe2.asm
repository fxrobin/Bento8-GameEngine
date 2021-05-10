; ---------------------------------------------------------------------------
; Object - Half Pipe for Special Stage
;
; input REG : [u] pointer to Object Status Table (OST)
; ---------
;
; ---------------------------------------------------------------------------
;
; Level Layout
; ------------
; Offset to each level data (7 word offsets for the 7 levels)
;
; Track
; -----
; $x0 Turn the rise
; $x1 Turn then drop
; $x2 Turn then straight
; $x3 straight
; $x4 Straight then turn
;
; Orientation
; -----------
; $0x Towards right
; $8x Towards left
;
; ----------------------------------
;
; Segment type
; ------------
; 0 Regular segment
; 1 Rings message
; 2 Checkpoint
; 3 Choas Emerald
;
; 0,0,0,0,0,0,0,0,0,0,1,0,2,0,0,0,0,0,0,0,0,0,0,1,0,0,2,0,0,0,0,0,0,0,0,0,0,1,0,0,0,3,0,0,0

HalfPipe
        lda   routine,u
        asla
        ldx   #HalfPipe_Routines
        jmp   [a,x]

HalfPipe_Routines
        fdb   HalfPipe_Init
        fdb   HalfPipe_Display

HalfPipe_Init
        ldb   #$05
        stb   priority,u
        
        ldd   #$807F
        addb  subtype,u
        std   xy_pixel,u
 
        lda   render_flags,u
        ora   #render_overlay_mask
        sta   render_flags,u
        
        ldd   #Ani_TurnThenDrop
        std   anim,u
                        
        inc   routine,u
        
HalfPipe_Display
        jsr   AnimateSprite        
        jmp   DisplaySprite
        

                                                      