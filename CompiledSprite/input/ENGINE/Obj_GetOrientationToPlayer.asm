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
	
gotp_closest_player    fdb   $0000     * ptr objet de MainCharacter ou Sidekick
gotp_player_is_left    fcb   $00       * 0: player left from object, 2: right
gotp_player_is_above   fcb   $00       * 0: player above object, 2: below
gotp_player_h_distance fdb   $0000     * closest character's h distance to obj
gotp_player_v_distance fdb   $0000     * closest character's v distance to obj
										   
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
                                       *    moveq   #0,d0
                                       *    moveq   #0,d1
                                       *    lea (MainCharacter).w,a1 ; a1=character
                                       *    move.w  x_pos(a0),d2
                                       *    sub.w   x_pos(a1),d2
                                       *    mvabs.w d2,d4   ; absolute horizontal distance to main character
                                       *    lea (Sidekick).w,a2 ; a2=character
                                       *    move.w  x_pos(a0),d3
                                       *    sub.w   x_pos(a2),d3
                                       *    mvabs.w d3,d5   ; absolute horizontal distance to sidekick
                                       *    cmp.w   d5,d4   ; get shorter distance
                                       *    bls.s   +   ; branch, if main character is closer
                                       *    ; if sidekick is closer
                                       *    movea.l a2,a1
                                       *    move.w  d3,d2
                                       *+
                                       *    tst.w   d2  ; is player to enemy's left?
                                       *    bpl.s   +   ; if not, branch
                                       *    addq.w  #2,d0
                                       *+
                                       *    move.w  y_pos(a0),d3
                                       *    sub.w   y_pos(a1),d3    ; vertical distance to closest character
                                       *    bhs.s   +   ; branch, if enemy is under
                                       *    addq.w  #2,d1
                                       *+
        rts                            *    rts
                                       *
                                       *; macro to move the absolute value of the source in the destination
                                       *mvabs macro source,destination
                                       *    move.ATTRIBUTE  source,destination
                                       *    bpl.s   +
                                       *    neg.ATTRIBUTE   destination
                                       *+
                                       *endm

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