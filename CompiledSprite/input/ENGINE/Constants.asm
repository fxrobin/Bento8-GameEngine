

* ---------------------------------------------------------------------------
* Physics Constants
* ---------------------------------------------------------------------------

gravity                       equ $38 ; Gravité: 56 sub-pixels par frame

* ===========================================================================
* Object Constants
* ===========================================================================

number_of_reserved_objects       equ 2
number_of_dynamic_objects        equ 45
number_of_level_objects          equ 3

* ---------------------------------------------------------------------------
* Sprite Table Input
* ---------------------------------------------------------------------------

sprite_table_nb_el               equ number_of_reserved_objects+number_of_dynamic_objects+number_of_level_objects
priority_0                       equ Sprite_Table_Input
priority_1                       equ Sprite_Table_Input+sprite_table_nb_el*2+2
priority_2                       equ Sprite_Table_Input+sprite_table_nb_el*2*2+4
priority_3                       equ Sprite_Table_Input+sprite_table_nb_el*2*3+6
priority_4                       equ Sprite_Table_Input+sprite_table_nb_el*2*4+8
priority_5                       equ Sprite_Table_Input+sprite_table_nb_el*2*5+10
priority_6                       equ Sprite_Table_Input+sprite_table_nb_el*2*6+12
priority_7                       equ Sprite_Table_Input+sprite_table_nb_el*2*7+14

* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------

object_size                   equ $1F ; the size of an object
next_object                   equ object_size
			                  
id                            equ $00 ; and $01 object ID (00: free slot, 01: Object1, ...)
render_flags                  equ $02 ; bitfield
x_pos                         equ $03 ; and $04 ... some objects use subpixel as well when extra precision is required (see ObjectMove)
x_sub                         equ $05 ; subpixel ; doit suivre x_pos, second octet supprimé car inutile en 6809
y_pos                         equ $05 ; and $06 ... some objects use subpixel as well when extra precision is required
y_sub                         equ $07 ; subpixel ; doit suivre y_pos, second octet supprimé car inutile en 6809
x_pixel                       equ x_pos
y_pixel                       equ x_pos+2
priority                      equ $08 ; $09 ; $00 priority 0 (front), $80 priority 1, ..., $380 priority 7
width_pixels                  equ $0A
mapping_frame                 equ $0B
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
render_xmirror_mask           equ $01 ; bit 0 This is the horizontal mirror flag. If set, the object will be flipped on its horizontal axis.
render_ymirror_mask           equ $02 ; bit 1 This is the vertical mirror flag.
render_coordinate1_mask       equ $04 ; bit 2,3 These are the coordinate system. If 0, the object will be positioned by absolute screen coordinates. This is used for things like the HUD and menu options. If 1, the object will be positioned by the playfield coordinates, i.e. where it is in a level. If 2 or 3, the object will be aligned to the background somehow (perhaps this was used for those MZ UFOs).
render_coordinate2_mask       equ $08 ;
render_ycheckonscreen_mask    equ $10 ; bit 4 This is the assume height flag. The object will be drawn if it is vertically within x pixels of the screen where x is #$20 if this flag is clear or $16(a0) if it is set.
render_staticmappings_mask    equ $20 ; bit 5 This is the raw mappings flag. If set, just 5 bytes will be read from the object's mappings offset when the BuildSprites routine draws the object, and these will be interpreted in the normal manner to display a single Mega Drive sprite. This format is used for objects such as breakable wall fragments.
render_subobjects_mask        equ $40 ; bit 6 Set if Sonic is behind a loop, clear if above. This is used to change loop collision, based on the chunk Sonic is standing in. (Unused for any other object.)
render_onscreen_mask          equ $80 ; bit 7 This is the on-screen flag. It will be set if the object is on-screen, and clear otherwise.

* ---------------------------------------------------------------------------
* status bitfield variables
status_leftfacing_mask        equ $01 ; bit 0 Object: X Orientation. Clear is right and set is left.                | Sonic: Orientation. Set is left and clear is right.
status_inair_mask             equ $02 ; bit 1 Object: Y Orientation. Clear is right-side up, and set is upside-down | Sonic: Set if Sonic is in the air
status_spinning_mask          equ $04 ; bit 2 Object: unused                                                        | Sonic: Set if jumping or rolling.
status_onobject_mask          equ $08 ; bit 3 Object: Set if Sonic is standing on this object.                      | Sonic: Set if Sonic isn't on the ground but shouldn't fall. (Usually when he is on a object that should stop him falling, like a platform or a bridge.)
status_rolljumping_mask       equ $10 ; bit 4 Object: unused                                                        | Sonic: Set if Sonic is jumping after rolling on the ground. (Used mainly to lock horizontal controls.)
status_pushing_mask           equ $20 ; bit 5 Object: Set if Sonic is pushing on this object.                       | Sonic: Set if pushing something.
status_underwater_mask        equ $40 ; bit 6 Object: unused                                                        | Sonic: Set if underwater.
status_specific_mask          equ $80 ; bit 7 Object: Object specific flag                                          | Sonic: unused