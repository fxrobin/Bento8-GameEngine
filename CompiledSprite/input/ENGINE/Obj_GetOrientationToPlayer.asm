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
* Physics Constants
* ---------------------------------------------------------------------------

gravity                       equ $38 ; Gravité: 56 sub-pixels par frame

* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------

object_size                   equ $1F ; the size of an object
next_object                   equ object_size
			                  
id                            equ $00 ; object ID (00: free slot, 01: Object1, ...)
render_flags                  equ $01 ; bitfield
x_pos                         equ $02 ; and $03 ... some objects use subpixel as well when extra precision is required (see ObjectMove)
x_sub                         equ $04 ; subpixel ; doit suivre x_pos, second octet supprimé car inutile en 6809
y_pos                         equ $05 ; and $06 ... some objects use subpixel as well when extra precision is required
y_sub                         equ $07 ; subpixel ; doit suivre y_pos, second octet supprimé car inutile en 6809
x_pixel                       equ x_pos
y_pixel                       equ x_pos+2
priority                      equ $08 ; 0 equ front
width_pixels                  equ $09
mapping_frame                 equ $0A
x_vel                         equ $0B ; and $0C ; horizontal velocity
y_vel                         equ $0D ; and $0E ; vertical velocity
y_radius                      equ $0F ; collision height / 2
x_radius                      equ $10 ; collision width / 2
anim_frame                    equ $11
anim                          equ $12
prev_anim                     equ $13
anim_frame_duration           equ $14 ; range: 00-7F (0-127)
status                        equ $15 ; note: exact meaning depends on the object...
routine                       equ $16
routine_secondary             equ $17
objoff_01                     equ $18 ; variables spécifiques aux objets
objoff_02                     equ $19
objoff_03                     equ $1A
objoff_04                     equ $1B
objoff_05                     equ $1C
collision_flags               equ $1D
subtype                       equ $1E

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