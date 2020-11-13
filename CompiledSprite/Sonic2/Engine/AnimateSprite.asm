; ---------------------------------------------------------------------------
; Subroutine to animate a sprite using an animation script
;
;   this function also change render flags to match orientation given by
;   the status byte;
;
; input REG : [u] pointeur sur l'objet
;             [x] pointeur sur le script d'animation de l'objet
; ---------------------------------------------------------------------------

                                       *; ---------------------------------------------------------------------------
                                       *; Subroutine to animate a sprite using an animation script
                                       *; ---------------------------------------------------------------------------
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; sub_16544:
AnimateSprite                          *AnimateSprite:
                                       *    moveq   #0,d0
        lda   anim,u                   *    move.b  anim(a0),d0      ; move animation number to d0
        cmpa  prev_anim,u              *    cmp.b   prev_anim(a0),d0 ; is animation set to change?
        beq   Anim_Run                 *    beq.s   Anim_Run         ; if not, branch
        sta   prev_anim,u              *    move.b  d0,prev_anim(a0) ; set prev anim to current animation
		ldb   #0
        stb   anim_frame,u             *    move.b  #0,anim_frame(a0)          ; reset animation
        stb   anim_frame_duration,u    *    move.b  #0,anim_frame_duration(a0) ; reset frame duration
                                       *; loc_16560:
Anim_Run                               *Anim_Run:
        dec   anim_frame_duration,u    *    subq.b  #1,anim_frame_duration(a0)   ; subtract 1 from frame duration
        bpl   Anim_Wait                *    bpl.s   Anim_Wait                    ; if time remains, branch
        adda  anim,u                   *    add.w   d0,d0                        ; i*2 position de l'adresse 
        leax  a,x                      *    adda.w  (a1,d0.w),a1                 ; calculate address of appropriate animation script
        ldb   ,x
		stb   anim_frame_duration,u    *    move.b  (a1),anim_frame_duration(a0) ; load frame duration
                                       *    moveq   #0,d1
        ldb   anim_frame,u             *    move.b  anim_frame(a0),d1 ; load current frame number
        incb
        lda   b,x                      *    move.b  1(a1,d1.w),d0 ; read sprite number from script
        * bmi   Anim_End_FF            *    bmi.s   Anim_End_FF   ; if animation is complete, branch
		cmpa  #$FA                     *    cmp.b   #$FA,d0       ; MJ: is it a flag from FA to FF?
		bhs   Anim_End_FF              *    bhs     Anim_End_FF   ; MJ: if so, branch to flag routines
                                       *; loc_1657C:
Anim_Next                              *Anim_Next:
	    * ne pas utiliser              *    andi.b  #$7F,d0               ; clear sign bit
        sta   mapping_frame,u          *    move.b  d0,mapping_frame(a0)  ; load sprite number
        ldb   status,u                 *    move.b  status(a0),d1         ; match the orientaion dictated by the object
        andb  #3                       *    andi.b  #3,d1                 ; with the orientation used by the object engine
        lda   render_flags,u           *    andi.b  #$FC,render_flags(a0)
        anda  #$FC
        sta   render_flags,u       
        orb   render_flags,u           *    or.b    d1,render_flags(a0)
        inc   anim_frame,u             *    addq.b  #1,anim_frame(a0)     ; next frame number
                                       *; return_1659A:
Anim_Wait                              *Anim_Wait:
        rts                            *    rts 
                                       *; ===========================================================================
                                       *; loc_1659C:
Anim_End_FF                            *Anim_End_FF:
        inca                           *    addq.b  #1,d0       ; is the end flag = $FF ?
        bne   Anim_End_FE              *    bne.s   Anim_End_FE ; if not, branch
		ldb   #0
        stb   anim_frame,u             *    move.b  #0,anim_frame(a0) ; restart the animation
        lda   1,x                      *    move.b  1(a1),d0          ; read sprite number
        bra   Anim_Next                *    bra.s   Anim_Next
                                       *; ===========================================================================
                                       *; loc_165AC:
Anim_End_FE                            *Anim_End_FE:
        inca                           *    addq.b  #1,d0             ; is the end flag = $FE ?
        bne   Anim_End_FD              *    bne.s   Anim_End_FD       ; if not, branch
        incb
        lda   anim_frame,u             *    move.b  2(a1,d1.w),d0     ; read the next byte in the script
        suba  b,x                      *    sub.b   d0,anim_frame(a0) ; jump back d0 bytes in the script
        sta   anim_frame,u
        tfr   a,b                      *    sub.b   d0,d1
        incb
        lda   b,x                      *    move.b  1(a1,d1.w),d0     ; read sprite number
        bra   Anim_Next                *    bra.s   Anim_Next
                                       *; ===========================================================================
                                       *; loc_165C0:
Anim_End_FD                            *Anim_End_FD:
        inca                           *    addq.b  #1,d0               ; is the end flag = $FD ?
        bne   Anim_End_FC              *    bne.s   Anim_End_FC         ; if not, branch
        incb
        lda   b,x
        sta   anim,u                   *    move.b  2(a1,d1.w),anim(a0) ; read next byte, run that animation
        rts                            *    rts
                                       *; ===========================================================================
                                       *; loc_165CC:
Anim_End_FC                            *Anim_End_FC:
        inca                           *    addq.b  #1,d0          ; is the end flag = $FC ?
        bne   Anim_End_FB              *    bne.s   Anim_End_FB    ; if not, branch
        inc   routine,u
        inc   routine,u                *    addq.b  #2,routine(a0) ; jump to next routine
        lda   #0
        sta   anim_frame_duration,u    *    move.b  #0,anim_frame_duration(a0)
        inc   anim_frame,u             *    addq.b  #1,anim_frame(a0)
        rts                            *    rts
                                       *; ===========================================================================
                                       *; loc_165E0:
Anim_End_FB                            *Anim_End_FB:
        inca                           *    addq.b  #1,d0                 ; is the end flag = $FB ?
        bne   Anim_End_FA              *    bne.s   Anim_End_FA           ; if not, branch
        lda   #0
        sta   anim_frame,u             *    move.b  #0,anim_frame(a0)     ; reset animation
        sta   routine_secondary,u      *    clr.b   routine_secondary(a0) ; reset 2nd routine counter
    rts                                *    rts
                                       *; ===========================================================================
                                       *; loc_165F0:
Anim_End_FA                            *Anim_End_FA:
        * inca                         *    addq.b  #1,d0                    ; is the end flag = $FA ?
        bne   Anim_End                 *    bne.s   Anim_End_F9              ; if not, branch
        inc   routine_secondary,u      *    addq.b  #2,routine_secondary(a0) ; jump to next routine
        inc   routine_secondary,u
        rts                            *    rts
                                       *; ===========================================================================
                                       *; loc_165FA:
                                       *Anim_End_F9:
                                       *    addq.b  #1,d0            ; is the end flag = $F9 ?
                                       *    bne.s   Anim_End         ; if not, branch
                                       *    addq.b  #2,objoff_2A(a0) ; Actually obj89_arrow_routine
                                       *; return_16602:
Anim_End                               *Anim_End:
    rts                                *    rts
                                       *; End of function AnimateSprite