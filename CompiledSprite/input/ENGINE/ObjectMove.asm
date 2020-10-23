; ---------------------------------------------------------------------------
; Subroutine translating object speed to update object position
; This moves the object horizontally and vertically
; but does not apply gravity to it
; ---------------------------------------------------------------------------

(main)MAIN
	ORG $0000
	
	INCLUD Constant
	
                                       *; ---------------------------------------------------------------------------
                                       *; Subroutine translating object speed to update object position
                                       *; This moves the object horizontally and vertically
                                       *; but does not apply gravity to it
                                       *; ---------------------------------------------------------------------------
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; sub_163AC: SpeedToPos:
ObjectMove                             *ObjectMove:
                                       *    move.l  x_pos(a0),d2    ; load x position
                                       *    move.l  y_pos(a0),d3    ; load y position
                                       *    move.w  x_vel(a0),d0    ; load horizontal speed
                                       *    ext.l   d0
                                       *    asl.l   #8,d0   ; shift velocity to line up with the middle 16 bits of the 32-bit position
                                       *    add.l   d0,d2   ; add to x-axis position    ; note this affects the subpixel position x_sub(a0) = 2+x_pos(a0)
        ldb   x_vel,x
        sex                            ; la vélocité est positive ou négative, on en tient compte dans l'addition
        sta   am_ObjectMove_01+1
        ldd   x_vel,x
        addd  x_pos+1,x                ; x_pos doit être suivi de x_sub en mémoire
        std   x_pos+1,x                ; maj octet poids faible de x_pos et octet de x_sub
        lda   x_pos,x
am_ObjectMove_01
        adca  #$00                     ; le paramètre est modifiée par le résultat du sign extend
        sta   x_pos,x                  ; maj octet poids fort de x_pos
                                       *    move.w  y_vel(a0),d0    ; load vertical speed
                                       *    ext.l   d0
                                       *    asl.l   #8,d0   ; shift velocity to line up with the middle 16 bits of the 32-bit position
                                       *    add.l   d0,d3   ; add to y-axis position    ; note this affects the subpixel position y_sub(a0) = 2+y_pos(a0)
                                       *    move.l  d2,x_pos(a0)    ; update x-axis position
                                       *    move.l  d3,y_pos(a0)    ; update y-axis position
        ldb   y_vel,x
        sex                            ; la vélocité est positive ou négative, on en tient compte dans l'addition
        sta   am_ObjectMove_02+1
        ldd   y_vel,x
        addd  y_pos+1,x                ; y_pos doit être suivi de y_sub en mémoire
        std   y_pos+1,x                ; maj octet poids faible de y_pos et octet de y_sub
        lda   y_pos,x
am_ObjectMove_02
        adca  #$00                     ; le paramètre est modifiée par le résultat du sign extend
        sta   y_pos,x                  ; maj octet poids fort de y_pos
        rts                            *    rts
                                       *; End of function ObjectMove
                                       *; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

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