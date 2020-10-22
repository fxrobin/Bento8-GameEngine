; ---------------------------------------------------------------------------
; Get Orientation To Player
; Returns the horizontal and vertical distances of the closest player object.
;
; input REG : [x] pointeur sur l'objet
; output    : gotp_closest_player    (ptr objet de MainCharacter ou Sidekick)
;             gotp_player_is_left (0: player left from object, 2: right)
;             gotp_player_v_location (0: player above object, 2: below)
;             gotp_player_h_distance (closest character's h distance to obj)
;             gotp_player_v_distance (closest character's v distance to obj)
; ---------------------------------------------------------------------------

(main)MAIN
	ORG $0000

	INCLUD Constant
										   
                                       *; ---------------------------------------------------------------------------
                                       *; Get Orientation To Player
                                       *; Returns the horizontal and vertical distances of the closest player object.
                                       *;
                                       *; input variables:
                                       *;  a0 = object
                                       *;
                                       *; returns:
                                       *;  a1 = address of closest player character
                                       *;  d0 = 0 if player is left from object, 2 if right
                                       *;  d1 = 0 if player is above object, 2 if below
                                       *;  d2 = closest character's horizontal distance to object
                                       *;  d3 = closest character's vertical distance to object
                                       *;
                                       *; writes:
                                       *;  d0, d1, d2, d3, d4, d5
                                       *;  a1
                                       *;  a2 = sidekick
                                       *; ---------------------------------------------------------------------------
                                       *;loc_366D6:
Obj_GetOrientationToPlayer             *Obj_GetOrientationToPlayer:
        pshs  d,y
        lda   #$00
        sta   gotp_player_is_left      *    moveq   #0,d0
        sta   gotp_player_is_above     *    moveq   #0,d1
        ldy   MainCharacter            *    lea (MainCharacter).w,a1 ; a1=character
        ldd   x_pos,x                  *    move.w  x_pos(a0),d2
        subd  x_pos,y                  *    sub.w   x_pos(a1),d2
                                       *    mvabs.w d2,d4   ; absolute horizontal distance to main character
        std   gotp_player_h_distance
        bpl   gotp_skip1
        coma
        comb
        addd  #$0001
gotp_skip1
        std   gotp_abs_h_distance_mainc
        ldy   Sidekick                 *    lea (Sidekick).w,a1 ; a1=character
        ldd   x_pos,x                  *    move.w  x_pos(a0),d3
        subd  x_pos,y                  *    sub.w   x_pos(a2),d3
        std   gotp_h_distance_sidek
                                       *    mvabs.w d3,d5   ; absolute horizontal distance to sidekick
        bpl   gotp_skip2
        coma
        comb
        addd  #$0001
gotp_skip2
        cmpd  gotp_abs_h_distance_mainc
                                       *    cmp.w   d5,d4   ; get shorter distance
        bhi   MainCharacterIsCloser    *    bls.s   +   ; branch, if main character is closer
                                       *    ; if sidekick is closer
        sty   gotp_closest_player      *    movea.l a2,a1
        ldd   gotp_h_distance_sidek
        std   gotp_player_h_distance   *    move.w  d3,d2
MainCharacterIsCloser                  *+
        lda   gotp_player_h_distance
        bita  #$80                     *    tst.w   d2  ; is player to enemy's left?
        beq   PlayerToEnemysLeft       *    bpl.s   +   ; if not, branch
        lda   #$02
        sta   gotp_player_is_left      *    addq.w  #2,d0
PlayerToEnemysLeft                     *+
        ldd   y_pos,x                  *    move.w  y_pos(a0),d3
        subd  y_pos,y                  *    sub.w   y_pos(a1),d3    ; vertical distance to closest character
        bhs   PlayerToEnemysAbove      *    bhs.s   +   ; branch, if enemy is under
        lda   #$02
        sta   gotp_player_is_above     *    addq.w  #2,d1
PlayerToEnemysAbove                    *+
        puls  d,y,pc
                                       *    rts

gotp_closest_player        fdb   $0000     * ptr objet de MainCharacter ou Sidekick
gotp_player_is_left        fcb   $00       * 0: player left from object, 2: right
gotp_player_is_above       fcb   $00       * 0: player above object, 2: below
gotp_player_h_distance     fdb   $0000     * closest character's h distance to obj
gotp_player_v_distance     fdb   $0000     * closest character's v distance to obj 
gotp_abs_h_distance_mainc  fdb   $0000     * absolute horizontal distance to main character
gotp_h_distance_sidek      fdb   $0000     * horizontal distance to sidekick

(include)Constant
MainCharacter                 equ $0000
Sidekick                      equ $0000

* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------

object_size                   equ $22 ; the size of an object
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
mapping_frame                 equ $0E
x_vel                         equ $0F ; and $10 ; horizontal velocity
y_vel                         equ $11 ; and $12 ; vertical velocity
y_radius                      equ $13 ; collision height / 2
x_radius                      equ $14 ; collision width / 2
anim_frame                    equ $15
anim                          equ $16
prev_anim                     equ $17
anim_frame_duration           equ $18 ; range: 00-7F (0-127)
status                        equ $19 ; note: exact meaning depends on the object...
routine                       equ $1A
routine_secondary             equ $1B
objoff_01                     equ $1C ; variables spécifiques aux objets
objoff_02                     equ $1D
objoff_03                     equ $1E
objoff_04                     equ $1F
objoff_05                     equ $20
collision_flags               equ $21
subtype                       equ $22

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