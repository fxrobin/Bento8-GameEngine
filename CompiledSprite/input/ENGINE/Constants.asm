* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------

object_size                   equ $21 ; the size of an object
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

