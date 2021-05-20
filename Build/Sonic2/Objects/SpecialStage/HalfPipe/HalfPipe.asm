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
        fdb   HalfPipe_End

HalfPipe_Init
        ldd   Vint_runcount
        std   HalfPipe_Vint_runcount

        ldb   #$05
        stb   priority,u
        
        ldd   #$807F
        addb  subtype,u
        std   xy_pixel,u
 
        lda   render_flags,u
        ora   #render_overlay_mask
        sta   render_flags,u
        
        ; load start and end of sequences for this level
        ; ----------------------------------------------
        
        ldx   SS_CurrentLevelLayout
        ldd   ,x
        leay  d,x
        sty   HalfPipe_Seq_Position
        ldd   2,x
        subd  #$01                               ; in original game last byte seems not used, skip it
        leay  d,x
        sty   HalfPipe_Seq_End        

        ; load first animation id
        ; -----------------------
        
        ldx   HalfPipe_Seq_Position
        ldb   ,x                
        stb   HalfPipe_Seq
        andb  #$7F
        ldx   #Ani_SpecialStageTrack
        aslb        
        abx
        ldd   ,x
        std   anim,u
                        
        inc   routine,u
        
HalfPipe_Display
        cmpu  #Dynamic_Object_RAM
        beq   @a
        ldx   #Dynamic_Object_RAM
        ldd   image_set,x                        ; clone image_set when secondary HalfPipe sprite is running
        std   image_set,u
        lda   render_flags,x
        sta   render_flags,u
        lda   routine,x
        sta   routine,u        
        jmp   DisplaySprite
@a

        ldd   Vint_runcount
        subd  HalfPipe_Vint_runcount
        cmpb  #$02                               ; ensure track is not refreshed more than 8fps 
        bgt   @a
        stb   SSTrack_drawing_index        
        jmp   DisplaySprite        
@a      ldd   Vint_runcount
        std   HalfPipe_Vint_runcount
        clr   SSTrack_drawing_index
        jsr   AnimateSprite
        
        ; chain animations (AnimateSprite will inc routine_secondary after each animation ends)
        ; -------------------------------------------------------------------------------------
        
        lda   routine_secondary,u
        asla
        ldx   #HalfPipe_SubRoutines
        jmp   [a,x]

HalfPipe_SubRoutines
        fdb   HalfPipe_Continue
        fdb   HalfPipe_LoadNewSequence
        
HalfPipe_LoadNewSequence
        ldx   HalfPipe_Seq_Position
        leax  1,x
        cmpx  HalfPipe_Seq_End
        bne   @a
        inc   routine,u   
        bra   HalfPipe_End
@a      stx   HalfPipe_Seq_Position

        lda   HalfPipe_Seq
        anda  #$7F
        ldb   ,x        
        stb   HalfPipe_Seq
        andb  #$7F
        cmpd  #$0303
        bne   @a
        ldd   #Ani_StraightAfterStraight
        std   anim,u
        bra   @b
@a      ldx   #Ani_SpecialStageTrack
        aslb
        abx
        ldd   ,x
        std   anim,u
@b      clr   routine_secondary,u
        clr   prev_anim,u                        ; force loading of new animation
        jsr   AnimateSprite

HalfPipe_Continue

        ; set orirentation of track
        ; -------------------------
        
        lda   HalfPipe_Seq_UpdFlip
        beq   @a
        ldb   HalfPipe_Seq_UpdFlip+1
        bpl   @b   
        lda   status,u
        ora   #status_x_orientation         ; set flip - left orientation
        sta   status,u
        bra   @c
@b      lda   status,u
        anda   #^status_x_orientation       ; unset flip - right orientation
        sta   status,u
@c      com   HalfPipe_Seq_UpdFlip
@a      ldd   image_set,u                   ; orientation can only change on specific frames
        cmpd  #Img_tk_036
        beq   @d
        cmpd  #Img_tk_044
        beq   @d       
        cmpd  #Img_tk_002
        beq   @d
        jmp   DisplaySprite
@d      com   HalfPipe_Seq_UpdFlip
        ldb   HalfPipe_Seq
        stb   HalfPipe_Seq_UpdFlip+1
        jmp   DisplaySprite
        
HalfPipe_End
        jmp   DisplaySprite
        
Ani_SpecialStageTrack
        fdb   Ani_TurnThenRise
        fdb   Ani_TurnThenDrop
        fdb   Ani_TurnThenStraight
        fdb   Ani_Straight
        fdb   Ani_StraightThenTurn        

HalfPipe_Seq_Position  fdb $0000
HalfPipe_Seq_End       fdb $0000
HalfPipe_Seq           fcb $00
HalfPipe_Seq_UpdFlip   fdb $0000
HalfPipe_Vint_runcount fdb $0000
                                                      