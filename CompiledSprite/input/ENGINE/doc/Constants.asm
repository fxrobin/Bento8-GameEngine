; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equates section - Names for variables.

; ---------------------------------------------------------------------------
; Screen limits
;
screen_A_start 	equ $0000
screen_A_end   	equ $1F40
screen_B_start 	equ $2000
screen_B_end   	equ $3F40

; ---------------------------------------------------------------------------
; Controller Buttons
;

button_down_right             equ $05
button_up_right               equ $06
button_right                  equ $07
button_down_left              equ $09
button_up_left                equ $0A
button_left                   equ $0B
button_down                   equ $0D
button_up                     equ $0E
button_center                 equ $0F
button_A                      equ $40

; ---------------------------------------------------------------------------
; Animation flags
;

afEnd        equ $FF ; return to beginning of animation
afBack       equ $FE ; go back (specified number) bytes
afChange     equ $FD ; run specified animation
afRoutine    equ $FC ; increment routine counter
afReset      equ $FB ; reset animation and 2nd object routine counter
af2ndRoutine equ $FA ; increment 2nd routine counter

; ---------------------------------------------------------------------------
; Object Status Table offsets
; ---------------------------------------------------------------------------
; universally followed object conventions

object_size                   equ $40 ; the size of an object
			                  
id                            equ 0 ; object ID (00: free slot, 01: Object1, ...)
render_flags                  equ 1 ; bitfield
; ---------------------------------------------------------------------------
; render bitfield variables
render_xmirror_mask           equ $01 ; bit 0
render_ymirror_mask           equ $02 ; bit 1
render_coordinate_mask        equ $04 ; bit 2
render_?_mask                 equ $08 : bit 3
render_ycheckonscreen_mask    equ $10 : bit 4
render_staticmappings_mask    equ $20 : bit 5
render_subobjects_mask        equ $40 ; bit 6
render_onscreen_mask          equ $80 ; bit 7

x_pos                         equ 8 ; and 9 ... some objects use $A and $B as well when extra precision is required (see ObjectMove)
x_pixel                       equ 8 ;
x_sub                         equ $A ; and $B ; subpixel
y_pos                         equ $C ; and $D ... some objects use $E and $F as well when extra precision is required
y_pixel                       equ $C ;
y_sub                         equ $E ; and $F ; subpixel
priority                      equ $18 ; 0 equ front
width_pixels                  equ $19
x_vel                         equ $10 ; and $11 ; horizontal velocity
y_vel                         equ $12 ; and $13 ; vertical velocity
y_radius                      equ $16 ; collision height / 2
x_radius                      equ $17 ; collision width / 2
anim_frame                    equ $1B
anim                          equ $1C
prev_anim                     equ $1D
anim_frame_duration           equ $1E
status                        equ $22 ; note: exact meaning depends on the object...
; ---------------------------------------------------------------------------
; status bitfield variables
status_leftfacing_mask        equ $01 ; bit 0
status_inair_mask             equ $02 ; bit 1
status_spinning_mask          equ $04 ; bit 2
status_onobject_mask          equ $08 ; bit 3
status_rolljumping_mask       equ $10 ; bit 4
status_pushing_mask           equ $20 ; bit 5
status_underwater_mask        equ $40 ; bit 6
status_?_mask                 equ $80 ; bit 7

routine                       equ $24
routine_secondary             equ $25
angle                         equ $26 ; angle about the z axis (360 degrees equ 256)
collision_flags               equ $20
collision_property            equ $21
respawn_index                 equ $23
subtype                       equ $28
					          
inertia                       equ $14 ; and $15 ; directionless representation of speed... not updated in the air - First byte : Frame, Second byte : 1/256 Frame
flip_angle                    equ $27 ; angle about the x axis (360 degrees equ 256) (twist/tumble)
air_left                      equ $28
flip_turned                   equ $29 ; 0 for normal, 1 to invert flipping (it's a 180 degree rotation about the axis of Sonic's spine, so he stays in the same position but looks turned around)
obj_control                   equ $2A ; 0 for normal, 1 for hanging or for resting on a flipper, $81 for going through CNZ/OOZ/MTZ tubes or stopped in CNZ cages or stoppers or flying if Tails
status_secondary              equ $2B
; ---------------------------------------------------------------------------
; status_secondary bitfield variables
status_sec_hasShield_mask     equ $01 ; bit 0
status_sec_isInvincible_mask  equ $02 ; bit 1
status_sec_hasSpeedShoes_mask equ $04 ; bit 2
status_sec_isSliding_mask     equ $80 ; bit 7

flips_remaining               equ $2C ; number of flip revolutions remaining
flip_speed                    equ $2D ; number of flip revolutions per frame / 256
move_lock                     equ $2E ; and $2F ; horizontal control lock, counts down to 0
invulnerable_time             equ $30 ; and $31 ; time remaining until you stop blinking
invincibility_time            equ $32 ; and $33 ; remaining
speedshoes_time               equ $34 ; and $35 ; remaining
next_tilt                     equ $36 ; angle on ground in front of sprite
tilt                          equ $37 ; angle on ground
stick_to_convex               equ $38 ; 0 for normal, 1 to make Sonic stick to convex surfaces like the rotating discs in Sonic 1 and 3 (unused in Sonic 2 but fully functional)
spindash_flag                 equ $39 ; 0 for normal, 1 for charging a spindash or forced rolling
pinball_mode                  equ spindash_flag
spindash_counter              equ $3A ; and $3B
restart_countdown             equ spindash_counter; and 1+spindash_counter
jumping                       equ $3C
interact                      equ $3D ; RAM address of the last object Sonic stood on, minus $FFFFB000 and divided by $40
top_solid_bit                 equ $3E ; the bit to check for top solidity (either $C or $E)
lrb_solid_bit                 equ $3F ; the bit to check for left/right/bottom solidity (either $D or $F)
					          
boss_subtype                  equ $A
boss_invulnerable_time        equ $14
boss_sine_count               equ $1A   ;mapping_frame
boss_routine                  equ $26   ;angle
boss_defeated                 equ $2C
boss_hitcount2                equ $32
boss_hurt_sonic               equ $38   ; flag set by collision response routine when sonic has just been hurt (by boss?)

; ---------------------------------------------------------------------------
; Object IDs
ObjID_Sonic                   equ $00
ObjID_Tails                   equ $01

; ---------------------------------------------------------------------------
; Animation IDs
AniIDSonAni_Walk              equ $00
AniIDSonAni_Run               equ $01

