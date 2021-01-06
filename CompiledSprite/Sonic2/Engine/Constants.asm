* ---------------------------------------------------------------------------
* Constants
*
* Naming convention
* -----------------
* - lower case
* - underscore-separated names
*
* ---------------------------------------------------------------------------

* ===========================================================================
* TO8 Registers
* ===========================================================================

dk_lecteur                    equ $6049
dk_piste                      equ $604A
dk_secteur                    equ $604C
dk_destination                equ $604F

* ===========================================================================
* Display Constants
* ===========================================================================

screen_width                  equ 160 ; screen width in pixel
screen_height                 equ 200 ; screen height in pixel
nb_priority_levels            equ 8   ; number of priority levels (need code change if modified)

* ===========================================================================
* Physics Constants
* ===========================================================================

gravity                       equ $38 ; Gravite: 56 sub-pixels par frame

* ===========================================================================
* Images Constants
* ===========================================================================

page_bckdraw_routine          equ 0
bckdraw_routine               equ 1
page_draw_routine             equ 3
draw_routine                  equ 4
page_erase_routine            equ 6
erase_routine                 equ 7
erase_nb_cell                 equ 9
image_x_offset                equ 10
image_y_offset                equ 12
image_x_size                  equ 14
image_y_size                  equ 16
image_meta_size               equ 18 ; number of bytes for each image reference

* ===========================================================================
* Object Constants
* ===========================================================================

nb_reserved_objects           equ 2
nb_dynamic_objects            equ 59
nb_level_objects              equ 3
nb_objects                    equ (nb_reserved_objects+nb_dynamic_objects)+nb_level_objects

* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------

object_size                   equ 70 ; the size of an object
next_object                   equ object_size

id                            equ 0           ; reference to object model id (ObjID_) (0: free slot)
subtype                       equ 1           ; reference to object subtype (Sub_)
render_flags                  equ 2

* --- render_flags bitfield variables ---
render_xmirror_mask           equ $01 ; (bit 0) tell display engine to mirror sprite on horizontal axis
render_ymirror_mask           equ $02 ; (bit 1) tell display engine to mirror sprite on vertical axis
render_playfieldcoord_mask    equ $04 ; (bit 2) tell display engine to use playfield (1) or screen (0) coordinates
render_hide_mask              equ $08 ; (bit 3) tell display engine to hide sprite (keep priority and mapping_frame)
render_fixedoverlay_mask      equ $10 ; (bit 4) non moving sprite on top of the others (you should also set priority=1, playfieldcoord=0)
render_todelete_mask          equ $20 ; (bit 5) tell display engine to delete sprite and clear OST for this object
render_free2_mask             equ $40 ; (bit 6) free
render_free3_mask             equ $80 ; (bit 7) free
 
priority                      equ 3           ; display priority (0: nothing to display, 1:front, ..., 8:back)
anim                          equ 4  ; and 5  ; reference to current animation (Ani_)
anim_frame                    equ 6           ; index of current frame in animation
anim_frame_duration           equ 7           ; number of frames for each image in animation, range: 00-7F (0-127), 0 means display only during one frame
mapping_frame                 equ 8  ; and 9  ;reference to current image (Img_) (0000 if no image)
x_pos                         equ 10 ; and 11 ; x playfield coordinate
x_sub                         equ 12          ; x subpixel (1/256 of a pixel), must follow x_pos in data structure
y_pos                         equ 13 ; and 14 ; y playfield coordinate
y_sub                         equ 15          ; y subpixel (1/256 of a pixel), must follow y_pos in data structure
x_pixel                       equ 16          ; x screen coordinate
y_pixel                       equ 17          ; y screen coordinate, must follow x_pixel
routine                       equ 18          ; index of current object routine
routine_secondary             equ 19          ; index of current secondary routine
ext_variables                 equ 20 ; to 40  ; reserved space for additionnal variables

* ---------------------------------------------------------------------------
* reserved variables (engine)

rsv_render_flags              equ 41

* --- rsv_render_flags bitfield variables ---
rsv_render_onscreen_0_mask    equ $01 ; (bit 0) has been rendered on screen buffer 0
rsv_render_onscreen_1_mask    equ $02 ; (bit 1) has been rendered on screen buffer 1
rsv_render_erasesprite_mask   equ $04 ; (bit 2) if a sprite need to be cleared on screen
rsv_render_displaysprite_mask equ $08 ; (bit 3) if a sprite need to be rendered on screen
rsv_render_outofrange_mask    equ $10 ; (bit 4) if a sprite is out of range for full rendering in screen

rsv_prev_anim                 equ 42 ; and 43 ; reference to previous animation (Ani_) w
rsv_curr_mapping_frame        equ 44 ; and 45 ; reference to current image regarding mirror flags (0000 if no image) w

* ---------------------------------------------------------------------------
* reserved variables (engine) - buffer specific

rsv_buffer_0                  equ 46 ; Start index of buffer 0 variables
rsv_priority_0                equ 46 ; internal value that hold priority in video buffer 0
rsv_priority_prev_obj_0       equ 47 ; and 48 ; previous object (OST address) in display priority list for video buffer 0 (0000 if none) w
rsv_priority_next_obj_0       equ 49 ; and 50 ; next object (OST address) in display priority list for video buffer 0 (0000 if none) w
rsv_prev_mapping_frame_0      equ 51 ; and 52 ; reference to previous image in video buffer 0 (Img_) (0000 if no image) w
rsv_bgdata_0                  equ 53 ; and 54 ; address of background data in screen 0 w
rsv_prev_x_pixel_0            equ 55 ; previous x screen coordinate b
rsv_prev_y_pixel_0            equ 56 ; previous y screen coordinate b, must follow x_pixel
rsv_onscreen_0                equ 57 ; has been rendered on screen buffer 0

rsv_buffer_1                  equ 58 ; Start index of buffer 1 variables
rsv_priority_1                equ 58 ; internal value that hold priority in video buffer 1
rsv_priority_prev_obj_1       equ 59 ; and 59 ; previous object (OST address) in display priority list for video buffer 1 (0000 if none) w
rsv_priority_next_obj_1       equ 61 ; and 61 ; next object (OST address) in display priority list for video buffer 1 (0000 if none) w
rsv_prev_mapping_frame_1      equ 63 ; and 63 ; reference to previous image in video buffer 1 (Img_) (0000 if no image) w
rsv_bgdata_1                  equ 65 ; and 65 ; address of background data in screen 1 w
rsv_prev_x_pixel_1            equ 67 ; previous x screen coordinate b
rsv_prev_y_pixel_1            equ 68 ; previous y screen coordinate b, must follow x_pixel
rsv_onscreen_1                equ 69 ; has been rendered on screen buffer 0

buf_priority                  equ 0  ; offset for each rsv_buffer variables
buf_priority_prev_obj         equ 1  ;
buf_priority_next_obj         equ 3  ;
buf_prev_mapping_frame        equ 5  ;
buf_bgdata                    equ 7  ;
buf_prev_x_pixel              equ 9  ;
buf_prev_y_pixel              equ 10 ;
buf_onscreen                  equ 11 ;