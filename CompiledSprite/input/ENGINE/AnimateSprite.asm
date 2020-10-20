; ---------------------------------------------------------------------------
; Subroutine to animate a sprite using an animation script
;
;   this function also change render flags to match orientation given by
;   the status byte;
;
; input REG : [x] pointeur sur l'objet
;             [y] pointeur sur le script d'animation de l'objet
; ---------------------------------------------------------------------------

(main)MAIN
	ORG $0000
	
	INCLUD Constant
                                       *; ---------------------------------------------------------------------------
                                       *; Subroutine to animate a sprite using an animation script
                                       *; ---------------------------------------------------------------------------
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; sub_16544:
AnimateSprite                          *AnimateSprite:
                                       *    moveq   #0,d0
        lda   anim,x                   *    move.b  anim(a0),d0      ; move animation number to d0
        cmpa  prev_anim,x              *    cmp.b   prev_anim(a0),d0 ; is animation set to change?
        beq   Anim_Run                 *    beq.s   Anim_Run         ; if not, branch
        sta   prev_anim,x              *    move.b  d0,prev_anim(a0) ; set prev anim to current current
		ldb   #0
        stb   anim_frame,x             *    move.b  #0,anim_frame(a0)          ; reset animation
        stb   anim_frame_duration,x    *    move.b  #0,anim_frame_duration(a0) ; reset frame duration
                                       *; loc_16560:
Anim_Run                               *Anim_Run:
        dec   anim_frame_duration,x    *    subq.b  #1,anim_frame_duration(a0)   ; subtract 1 from frame duration
        bpl   Anim_Wait                *    bpl.s   Anim_Wait                    ; if time remains, branch
        adda  anim,x                   *    add.w   d0,d0                        ; i*2 position de l'adresse 
        leay  [a,y]                    *    adda.w  (a1,d0.w),a1                 ; calculate address of appropriate animation script
        ldb   ,y
		stb   anim_frame_duration,x    *    move.b  (a1),anim_frame_duration(a0) ; load frame duration
                                       *    moveq   #0,d1
        ldb   anim_frame,x             *    move.b  anim_frame(a0),d1 ; load current frame number
        incb
        lda   b,y                      *    move.b  1(a1,d1.w),d0 ; read sprite number from script
        * bmi   Anim_End_FF            *    bmi.s   Anim_End_FF   ; if animation is complete, branch
		cmpa  #$FA                     *    cmp.b   #$FA,d0       ; MJ: is it a flag from FA to FF?
		bhs   Anim_End_FF              *    bhs     Anim_End_FF   ; MJ: if so, branch to flag routines
                                       *; loc_1657C:
Anim_Next                              *Anim_Next:
	    * non implémenté               *    andi.b  #$7F,d0               ; clear sign bit
        * non implémenté               *    move.b  d0,mapping_frame(a0)  ; load sprite number
        ldb   status,x                 *    move.b  status(a0),d1         ; match the orientaion dictated by the object
        andb  #3                       *    andi.b  #3,d1                 ; with the orientation used by the object engine
        lda   render_flags,x           *    andi.b  #$FC,render_flags(a0)
        anda  #$FC
        sta   render_flags,x       
        orb   render_flags,x           *    or.b    d1,render_flags(a0)
        inc   anim_frame,x             *    addq.b  #1,anim_frame(a0)     ; next frame number
                                       *; return_1659A:
Anim_Wait                              *Anim_Wait:
        rts                            *    rts 
                                       *; ===========================================================================
                                       *; loc_1659C:
Anim_End_FF                            *Anim_End_FF:
        inca                           *    addq.b  #1,d0       ; is the end flag = $FF ?
        bne   Anim_End_FE              *    bne.s   Anim_End_FE ; if not, branch
		ldb   #0
        stb   anim_frame,x             *    move.b  #0,anim_frame(a0) ; restart the animation
        lda   1,y                      *    move.b  1(a1),d0          ; read sprite number
        bra   Anim_Next                *    bra.s   Anim_Next
                                       *; ===========================================================================
                                       *; loc_165AC:
Anim_End_FE                            *Anim_End_FE:
        inca                           *    addq.b  #1,d0             ; is the end flag = $FE ?
        bne   Anim_End_FD              *    bne.s   Anim_End_FD       ; if not, branch
        incb
        lda   anim_frame,x             *    move.b  2(a1,d1.w),d0     ; read the next byte in the script
        suba  b,y                      *    sub.b   d0,anim_frame(a0) ; jump back d0 bytes in the script
        sta   anim_frame,x
        tfr   a,b                      *    sub.b   d0,d1
        incb
        lda   b,y                      *    move.b  1(a1,d1.w),d0     ; read sprite number
        bra   Anim_Next                *    bra.s   Anim_Next
                                       *; ===========================================================================
                                       *; loc_165C0:
Anim_End_FD                            *Anim_End_FD:
        inca                           *    addq.b  #1,d0               ; is the end flag = $FD ?
        bne   Anim_End_FC              *    bne.s   Anim_End_FC         ; if not, branch
        incb
        lda   b,y
        sta   anim,x                   *    move.b  2(a1,d1.w),anim(a0) ; read next byte, run that animation
        rts                            *    rts
                                       *; ===========================================================================
                                       *; loc_165CC:
Anim_End_FC                            *Anim_End_FC:
        inca                           *    addq.b  #1,d0          ; is the end flag = $FC ?
        bne   Anim_End_FB              *    bne.s   Anim_End_FB    ; if not, branch
        inc   routine,x
        inc   routine,x                *    addq.b  #2,routine(a0) ; jump to next routine
        lda   #0
        sta   anim_frame_duration,x    *    move.b  #0,anim_frame_duration(a0)
        inc   anim_frame,x             *    addq.b  #1,anim_frame(a0)
        rts                            *    rts
                                       *; ===========================================================================
                                       *; loc_165E0:
Anim_End_FB                            *Anim_End_FB:
        inca                           *    addq.b  #1,d0                 ; is the end flag = $FB ?
        bne   Anim_End_FA              *    bne.s   Anim_End_FA           ; if not, branch
        lda   #0
        sta   anim_frame,x             *    move.b  #0,anim_frame(a0)     ; reset animation
        sta   routine_secondary,x      *    clr.b   routine_secondary(a0) ; reset 2nd routine counter
    rts                                *    rts
                                       *; ===========================================================================
                                       *; loc_165F0:
Anim_End_FA                            *Anim_End_FA:
        inca                           *    addq.b  #1,d0                    ; is the end flag = $FA ?
        bne   Anim_End                 *    bne.s   Anim_End_F9              ; if not, branch
        inc   routine_secondary,x      *    addq.b  #2,routine_secondary(a0) ; jump to next routine
        inc   routine_secondary,x
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
                                       
(include)Constant
* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------

object_size                   equ $20 ; the size of an object
next_object                   equ object_size
			                  
id                            equ $00 ; object ID (00: free slot, 01: Object1, ...)
render_flags                  equ $01 ; bitfield
x_pos                         equ $02 ; and $03 ... some objects use $A and $B as well when extra precision is required (see ObjectMove)
x_pixel                       equ $04 ;
x_sub                         equ $05 ; and $06 ; subpixel
y_pos                         equ $07 ; and $08 ... some objects use $E and $F as well when extra precision is required
y_pixel                       equ $09 ;
y_sub                         equ $0A ; and $0B ; subpixel
priority                      equ $0C ; 0 equ front
width_pixels                  equ $0D
x_vel                         equ $0E ; and $0F ; horizontal velocity
y_vel                         equ $10 ; and $11 ; vertical velocity
y_radius                      equ $12 ; collision height / 2
x_radius                      equ $13 ; collision width / 2
anim_frame                    equ $14
anim                          equ $15
prev_anim                     equ $16
anim_frame_duration           equ $17
status                        equ $18 ; note: exact meaning depends on the object...
routine                       equ $19
routine_secondary             equ $1A
objoff_01                     equ $1B ; variables génériques
objoff_02                     equ $1C
objoff_03                     equ $1D
objoff_04                     equ $1E
objoff_05                     equ $1F
collision_flags               equ $20

* ---------------------------------------------------------------------------
* render_flags bitfield variables
render_xmirror_mask           equ $01 ; bit 0
render_ymirror_mask           equ $02 ; bit 1
render_coordinate_mask        equ $04 ; bit 2
render_7_mask                 equ $08 : bit 3
render_ycheckonscreen_mask    equ $10 : bit 4
render_staticmappings_mask    equ $20 : bit 5
render_subobjects_mask        equ $40 ; bit 6
render_onscreen_mask          equ $80 ; bit 7

* ---------------------------------------------------------------------------
* status bitfield variables
status_leftfacing_mask        equ $01 ; bit 0
status_inair_mask             equ $02 ; bit 1
status_spinning_mask          equ $04 ; bit 2
status_onobject_mask          equ $08 ; bit 3
status_rolljumping_mask       equ $10 ; bit 4
status_pushing_mask           equ $20 ; bit 5
status_underwater_mask        equ $40 ; bit 6
status_7_mask                 equ $80 ; bit 7
