; ---------------------------------------------------------------------------
; Object - SonicAndTailsIn
;
; Display Sonic And Tails In ... message
;
; input REG : [u] pointer to Object Status Table (OST)
; ---------
;
; Instructions for position-independent code
; ------------------------------------------
; - call to a Main Engine routine (6100 - 9FFF): use a jump (jmp, jsr, rts), do not use branch
; - call to internal object routine: use branch ((l)b__), do not use jump
; - use indexed addressing to access data table: first load table address by using "leax my_table,pcr"
;
; ---------------------------------------------------------------------------
(main)SATI
        INCLUD GLOBALS
        INCLUD CONSTANT
        org   $A000
        
Obj_PaletteHandler      equ Object_RAM+(object_size*1)        
        
SonicAndTailsIn
        lda   routine,u
        sta   *+4,pcr
        bra   SATI_Routines

SATI_Routines
        lbra  SATI_clearScreen
        lbra  SATI_fadeIn
        lbra  SATI_fadeOut        
        lbra  SATI_Wait
        lbra  SATI_End
 
SATI_clearScreen
        ldx   #$0000
        jsr   ClearCartMem        
        
        ldd   #Img_SonicAndTailsIn
        std   image_set,u
        
        ldd   #$807F
        std   xy_pixel,u
        
        lda   render_flags,u
        ora   #render_overlay_mask
        sta   render_flags,u   
        
        ldb   #1
        stb   priority,u     
        
        lda   routine,u
        adda  #$03
        sta   routine,u   

        jmp   DisplaySprite

SATI_fadeIn
        ldx   #$0000
        jsr   ClearCartMem        

        ldx   #Obj_PaletteHandler
        lda   #ObjID_PaletteHandler
        sta   id,x                 
        ldd   Cur_palette *@IgnoreUndefined
        std   ext_variables,x
        ldd   #Pal_SonicAndTailsIn *@IgnoreUndefined
        std   ext_variables+2,x    
        
        lda   routine,u
        adda  #$03
        sta   routine,u    
           
        ldd   #$0000
        std   Vint_runcount           
              
        jmp   DisplaySprite    
                
SATI_fadeOut
        ldd   Vint_runcount
        cmpd  #3*50 ; 3 seconds
        beq   SATI_fadeOut_continue
        rts

SATI_fadeOut_continue        
        ldx   #Obj_PaletteHandler
        lda   #ObjID_PaletteHandler
        sta   id,x                 
        ldd   Cur_palette *@IgnoreUndefined
        std   ext_variables,x
        ldd   #Black_palette *@IgnoreUndefined
        std   ext_variables+2,x  
          
        lda   routine,u
        adda  #$03
        sta   routine,u    
        rts                
                
SATI_Wait
        ldx   #Obj_PaletteHandler
        tst   ,x
        beq   SATI_clearScreen_end
        rts
        
SATI_clearScreen_end
        ldx   #$FFFF
        jsr   ClearCartMem
        
        lda   $E7DD                    * set border color
        anda  #$F0
        adda  #$0F
        sta   $E7DD
        anda  #$0F
        adda  #$80
        sta   screen_border_color+1    * maj WaitVBL
                     
        lda   routine,u
        adda  #$03
        sta   routine,u    
        rts            
                
SATI_End
        ldx   #$FFFF
        jsr   ClearCartMem  
        jsr   DeleteObject                    
        ldd   #(ObjID_TitleScreen<+8)+$03             ; Replace this object with Title Screen Object subtype 3
        std   ,u
        ldu   #Obj_PaletteHandler
        jsr   ClearObj        
        rts  
                        

(include)GLOBALS
* Generated Code

GameModeLoader equ $414F
current_game_mode_data equ $41C7
ObjID_SonicAndTailsIn equ 1
ObjID_SEGA equ 2
ObjID_PaletteHandler equ 3
ObjID_TitleScreen equ 4
Glb_Sprite_Screen_Pos_Part1 equ $6122
Glb_Sprite_Screen_Pos_Part2 equ $6124
Object_RAM equ $6610
screen_border_color equ $7162
Vint_runcount equ $7188
c1_button_up_mask equ $0001
c1_button_down_mask equ $0002
c1_button_left_mask equ $0004
c1_button_right_mask equ $0008
c2_button_up_mask equ $0010
c2_button_down_mask equ $0020
c2_button_left_mask equ $0040
c2_button_right_mask equ $0080
c1_button_A_mask equ $0040
c2_button_A_mask equ $0080
Joypads_Held equ $718C
Dpad_Held equ $718C
Fire_Held equ $718D
Joypads_Press equ $718E
Dpad_Press equ $718E
Fire_Press equ $718F
MarkObjGone equ $71F9
DisplaySprite_x equ $71FB
DisplaySprite equ $7201
AnimateSprite equ $727A
DeleteObject_x equ $733F
DeleteObject equ $7345
ClearObj equ $7407
ClearCartMem equ $7CB7
Refresh_palette equ $7CF1
Cur_palette equ $7CF2
Dyn_palette equ $7CF4
Black_palette equ $7D14
White_palette equ $7D34
UpdatePalette equ $7D54
PlayPCM equ $7D7C
PSGInit equ $7DD3
PSGPlayNoRepeat equ $7DE5
PSGStop equ $7E13
PSGResume equ $7E3C
PSGCancelLoop equ $7E87
PSGGetStatus equ $7E8B
PSGSetMusicVolumeAttenuation equ $7E8F
PSGSilenceChannels equ $7EEE
PSGRestoreVolumes equ $7F03
PSGSFXPlayLoop equ $7F77
PSGSFXStop equ $7FC3
PSGSFXCancelLoop equ $8039
PSGSFXGetStatus equ $803D
PSGFrame equ $8041
_sendVolume2PSG equ $80FB
PSGSFXFrame equ $814E
_SFXsetLoopPoint equ $81AB
irq_routine equ $6027
irq_timer_ctrl equ $E7C5
irq_timer equ $E7C6
irq_one_frame equ $4DFF
Irq_Raster_Page equ $81F7
Irq_Raster_Start equ $81F9
Irq_Raster_End equ $81FB
IrqOn equ $81FD
IrqOff equ $8208
IrqSync equ $8213
IrqPsg equ $8232
IrqPsgRaster equ $8241
Img_SonicAndTailsIn equ $8278
Img_SegaLogo_2 equ $8288
Img_SegaLogo_1 equ $8298
Img_SegaTrails_1 equ $82A8
Img_SegaSonic_12 equ $82C1
Img_SegaSonic_23 equ $82E2
Img_SegaSonic_13 equ $8303
Img_SegaSonic_32 equ $8324
Img_SegaSonic_21 equ $8345
Img_SegaSonic_43 equ $8366
Img_SegaSonic_11 equ $8387
Img_SegaSonic_33 equ $83A8
Img_SegaSonic_22 equ $83C9
Img_SegaSonic_41 equ $83EA
Img_SegaSonic_31 equ $840B
Img_SegaSonic_42 equ $842C
Img_SegaTrails_6 equ $844D
Img_SegaTrails_5 equ $845D
Img_SegaTrails_4 equ $846D
Img_SegaTrails_3 equ $847D
Img_SegaTrails_2 equ $848D
Img_star_4 equ $84A6
Img_star_3 equ $84BA
Img_sonicHand equ $84CE
Img_star_2 equ $84E5
Img_star_1 equ $8500
Img_emblemBack08 equ $851B
Img_emblemBack07 equ $852B
Img_emblemBack09 equ $853B
Img_emblemBack04 equ $854B
Img_emblemBack03 equ $855B
Img_emblemBack06 equ $856B
Img_emblemBack05 equ $857B
Img_tails_5 equ $858B
Img_tails_4 equ $85A2
Img_tails_3 equ $85B6
Img_tails_2 equ $85CA
Img_tails_1 equ $85DE
Img_tailsHand equ $85F2
Img_island equ $8609
Img_sonic_1 equ $861D
Img_sonic_2 equ $8631
Img_emblemBack02 equ $8645
Img_emblemBack01 equ $8655
Img_sonic_3 equ $8665
Img_sonic_4 equ $8679
Img_emblemFront07 equ $8690
Img_emblemFront08 equ $86A0
Img_emblemFront05 equ $86B0
Img_emblemFront06 equ $86C0
Img_emblemFront03 equ $86D0
Img_emblemFront04 equ $86E0
Img_emblemFront01 equ $86F0
Img_emblemFront02 equ $8700
Ani_SegaSonic_3 equ $8711
Ani_SegaSonic_2 equ $871B
Ani_SegaSonic_1 equ $8725
Ani_smallStar equ $872F
Ani_largeStar equ $8735
Ani_tails equ $8741
Ani_sonic equ $874D
Glb_Sprite_Screen_Pos_Part1 equ $6122
Glb_Sprite_Screen_Pos_Part2 equ $6124
Object_RAM equ $6610
screen_border_color equ $7162
Vint_runcount equ $7188
c1_button_up_mask equ $0001
c1_button_down_mask equ $0002
c1_button_left_mask equ $0004
c1_button_right_mask equ $0008
c2_button_up_mask equ $0010
c2_button_down_mask equ $0020
c2_button_left_mask equ $0040
c2_button_right_mask equ $0080
c1_button_A_mask equ $0040
c2_button_A_mask equ $0080
Joypads_Held equ $718C
Dpad_Held equ $718C
Fire_Held equ $718D
Joypads_Press equ $718E
Dpad_Press equ $718E
Fire_Press equ $718F
MarkObjGone equ $71F9
DisplaySprite_x equ $71FB
DisplaySprite equ $7201
AnimateSprite equ $727A
DeleteObject_x equ $733F
DeleteObject equ $7345
ClearObj equ $7407
ClearCartMem equ $7CB7
Refresh_palette equ $7CF1
Cur_palette equ $7CF2
Dyn_palette equ $7CF4
Black_palette equ $7D14
White_palette equ $7D34
UpdatePalette equ $7D54
PlayPCM equ $7D7C
PSGInit equ $7DD3
PSGPlayNoRepeat equ $7DE5
PSGStop equ $7E13
PSGResume equ $7E3C
PSGCancelLoop equ $7E87
PSGGetStatus equ $7E8B
PSGSetMusicVolumeAttenuation equ $7E8F
PSGSilenceChannels equ $7EEE
PSGRestoreVolumes equ $7F03
PSGSFXPlayLoop equ $7F77
PSGSFXStop equ $7FC3
PSGSFXCancelLoop equ $8039
PSGSFXGetStatus equ $803D
PSGFrame equ $8041
_sendVolume2PSG equ $80FB
PSGSFXFrame equ $814E
_SFXsetLoopPoint equ $81AB
irq_routine equ $6027
irq_timer_ctrl equ $E7C5
irq_timer equ $E7C6
irq_one_frame equ $4DFF
Irq_Raster_Page equ $81F7
Irq_Raster_Start equ $81F9
Irq_Raster_End equ $81FB
IrqOn equ $81FD
IrqOff equ $8208
IrqSync equ $8213
IrqPsg equ $8232
IrqPsgRaster equ $8241
Img_SonicAndTailsIn equ $8278
Img_SegaLogo_2 equ $8288
Img_SegaLogo_1 equ $8298
Img_SegaTrails_1 equ $82A8
Img_SegaSonic_12 equ $82C1
Img_SegaSonic_23 equ $82E2
Img_SegaSonic_13 equ $8303
Img_SegaSonic_32 equ $8324
Img_SegaSonic_21 equ $8345
Img_SegaSonic_43 equ $8366
Img_SegaSonic_11 equ $8387
Img_SegaSonic_33 equ $83A8
Img_SegaSonic_22 equ $83C9
Img_SegaSonic_41 equ $83EA
Img_SegaSonic_31 equ $840B
Img_SegaSonic_42 equ $842C
Img_SegaTrails_6 equ $844D
Img_SegaTrails_5 equ $845D
Img_SegaTrails_4 equ $846D
Img_SegaTrails_3 equ $847D
Img_SegaTrails_2 equ $848D
Img_star_4 equ $84A6
Img_star_3 equ $84BA
Img_sonicHand equ $84CE
Img_star_2 equ $84E5
Img_star_1 equ $8500
Img_emblemBack08 equ $851B
Img_emblemBack07 equ $852B
Img_emblemBack09 equ $853B
Img_emblemBack04 equ $854B
Img_emblemBack03 equ $855B
Img_emblemBack06 equ $856B
Img_emblemBack05 equ $857B
Img_tails_5 equ $858B
Img_tails_4 equ $85A2
Img_tails_3 equ $85B6
Img_tails_2 equ $85CA
Img_tails_1 equ $85DE
Img_tailsHand equ $85F2
Img_island equ $8609
Img_sonic_1 equ $861D
Img_sonic_2 equ $8631
Img_emblemBack02 equ $8645
Img_emblemBack01 equ $8655
Img_sonic_3 equ $8665
Img_sonic_4 equ $8679
Img_emblemFront07 equ $8690
Img_emblemFront08 equ $86A0
Img_emblemFront05 equ $86B0
Img_emblemFront06 equ $86C0
Img_emblemFront03 equ $86D0
Img_emblemFront04 equ $86E0
Img_emblemFront01 equ $86F0
Img_emblemFront02 equ $8700
Ani_SegaSonic_3 equ $8711
Ani_SegaSonic_2 equ $871B
Ani_SegaSonic_1 equ $8725
Ani_smallStar equ $872F
Ani_largeStar equ $8735
Ani_tails equ $8741
Ani_sonic equ $874D
Pcm_SEGA equ $8A56
Psg_TitleScreen equ $8A61
Pal_SEGA equ $8A9B
Pal_TitleScreen equ $8ABB
Pal_SEGAMid equ $8ADB
Pal_SonicAndTailsIn equ $8AFB
Pal_SEGAEnd equ $8B1B

(include)CONSTANT
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
dk_pisteL                     equ $604B
dk_secteur                    equ $604C
dk_destination                equ $604F

* ===========================================================================
* Display Constants
* ===========================================================================

screen_width                  equ 160 ; screen width in pixel
screen_top                    equ 28 ; in pixel
screen_bottom                 equ 28+199 ; in pixel
screen_left                   equ 48 ; in pixel
screen_right                  equ 48+159 ; in pixel
nb_priority_levels            equ 8   ; number of priority levels (need code change if modified)

* ===========================================================================
* Physics Constants
* ===========================================================================

gravity                       equ $38 ; Gravite: 56 sub-pixels par frame

* ===========================================================================
* Animation Constants
* ===========================================================================

_resetAnim                    equ $FF
_goBackNFrames                equ $FE
_goToAnimation                equ $FD
_nextRoutine                  equ $FC
_resetAnimAndSubRoutine       equ $FB
_nextSubRoutine               equ $FA

* ===========================================================================
* Images Constants
* ===========================================================================

image_x_size                  equ 4
image_y_size                  equ 5
image_center_offset           equ 6

image_subset_x1_offset        equ 4
image_subset_y1_offset        equ 5

page_draw_routine             equ 0
draw_routine                  equ 1
page_erase_routine            equ 3
erase_routine                 equ 4
erase_nb_cell                 equ 6

* ===========================================================================
* Sound Constants
* ===========================================================================

pcm_page        equ 0
pcm_start_addr  equ 1
pcm_end_addr    equ 3
pcm_meta_size   equ 5

* ===========================================================================
* Object Constants
* ===========================================================================

nb_reserved_objects           equ 2
nb_dynamic_objects            equ 27
nb_level_objects              equ 3
nb_objects                    equ 32 * max 64 total

* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------

object_size                   equ 90 ; the size of an object - DEPENDENCY ClearObj routine
next_object                   equ object_size

id                            equ 0           ; reference to object model id (ObjID_) (0: free slot)
subtype                       equ 1           ; reference to object subtype (Sub_)
render_flags                  equ 2

* --- render_flags bitfield variables ---
render_xmirror_mask           equ $01 ; (bit 0) DEPENDENCY should be bit 0 - tell display engine to mirror sprite on horizontal axis
render_ymirror_mask           equ $02 ; (bit 1) DEPENDENCY should be bit 1 - tell display engine to mirror sprite on vertical axis
render_overlay_mask           equ $04 ; (bit 2) DEPENDENCY should be bit 2 - compilated sprite with no background save
render_motionless_mask        equ $08 ; (bit 3) tell display engine to compute sub image and position check only once until the flag is removed  
render_playfieldcoord_mask    equ $10 ; (bit 4) tell display engine to use playfield (1) or screen (0) coordinates
render_hide_mask              equ $20 ; (bit 5) tell display engine to hide sprite (keep priority and mapping_frame)
render_todelete_mask          equ $40 ; (bit 6) tell display engine to delete sprite and clear OST for this object
render_xloop_mask             equ $80 ; (bit 7) (screen coordinate) tell display engine to hide sprite when x is out of screen (0) or to display (1)  
 
priority                      equ 3           ; display priority (0: nothing to display, 1:front, ..., 8:back)
anim                          equ 4  ; and 5  ; reference to current animation (Ani_)
prev_anim                     equ 6  ; and 7  ; reference to previous animation (Ani_)
anim_frame                    equ 8           ; index of current frame in animation
anim_frame_duration           equ 9           ; number of frames for each image in animation, range: 00-7F (0-127), 0 means display only during one frame
image_set                     equ 10 ; and 11 ;reference to current image (Img_) (0000 if no image)
x_pos                         equ 12 ; and 13 ; x playfield coordinate
x_sub                         equ 14          ; x subpixel (1/256 of a pixel), must follow x_pos in data structure
y_pos                         equ 15 ; and 16 ; y playfield coordinate
y_sub                         equ 17          ; y subpixel (1/256 of a pixel), must follow y_pos in data structure
xy_pixel                      equ 18          ; x and y screen coordinate
x_pixel                       equ 18          ; x screen coordinate
y_pixel                       equ 19          ; y screen coordinate, must follow x_pixel
x_vel                         equ 20 ; and 21 ; horizontal velocity
y_vel                         equ 22 ; and 23 ; vertical velocity
routine                       equ 24          ; index of current object routine
routine_secondary             equ 25          ; index of current secondary routine
status                        equ 26 

* --- status bitfield variables for objects ---
status_x_orientation          equ   $01 ; (bit 0) X Orientation. Clear is left and set is right
status_y_orientation          equ   $02 ; (bit 1) Y Orientation. Clear is right-side up, and set is upside-down
status_bit2                   equ   $04 ; (bit 2) Unused
status_mainchar_standing      equ   $08 ; (bit 3) Set if Main character is standing on this object
status_sidekick_standing      equ   $10 ; (bit 4) Set if Sidekick is standing on this object
status_mainchar_pushing       equ   $20 ; (bit 5) Set if Main character is pushing on this object
status_sidekick_pushing       equ   $40 ; (bit 6) Set if Sidekick is pushing on this object
status_bit7                   equ   $80 ; (bit 7) Unused

* --- status bitfield variables for Main characters ---
status_inair                  equ   $02 ; (bit 1) Set if in the air (jump counts)
status_jumporroll             equ   $04 ; (bit 2) Set if jumping or rolling
status_norgroundnorfall       equ   $08 ; (bit 3) Set if isn't on the ground but shouldn't fall. (Usually when he is on a object that should stop him falling, like a platform or a bridge.)
status_jumpingafterrolling    equ   $10 ; (bit 4) Set if jumping after rolling
status_pushing                equ   $20 ; (bit 5) Set if pushing something
status_underwater             equ   $40 ; (bit 6) Set if underwater

ext_variables                 equ 27 ; to 40  ; reserved space for additionnal variables

* ---------------------------------------------------------------------------
* reserved variables (engine)

rsv_render_flags              equ 41

* --- rsv_render_flags bitfield variables ---
rsv_render_checkrefresh_mask  equ $01 ; (bit 0) if erasesprite and display sprite flag are processed for this frame
rsv_render_erasesprite_mask   equ $02 ; (bit 1) if a sprite need to be cleared on screen
rsv_render_displaysprite_mask equ $04 ; (bit 2) if a sprite need to be rendered on screen
rsv_render_outofrange_mask    equ $08 ; (bit 3) if a sprite is out of range for full rendering in screen

rsv_prev_anim                 equ 42 ; and 43 ; reference to previous animation (Ani_) w
rsv_image_center_offset       equ 44 ; 0 or 1 offset that indicate if image center is even or odd (DRS_XYToAddress)
* ne sert plus                       ; and 45 ; reference to current image set w
rsv_image_subset              equ 46 ; and 47 ; reference to current image regarding mirror flags w
rsv_mapping_frame             equ 48 ; and 49 ; reference to current image regarding mirror flags, overlay flag and x precision w
rsv_xy1_pixel                 equ 50          ;
rsv_x1_pixel                  equ 50          ; x+x_offset-(x_size/2) screen coordinate
rsv_y1_pixel                  equ 51          ; y+y_offset-(y_size/2) screen coordinate, must follow rsv_x1_pixel
rsv_xy2_pixel                 equ 52          ;
rsv_x2_pixel                  equ 52          ; x+x_offset+(x_size/2) screen coordinate
rsv_y2_pixel                  equ 53          ; y+y_offset+(y_size/2) screen coordinate, must follow rsv_x2_pixel

* ---------------------------------------------------------------------------
* reserved variables (engine) - buffer specific

rsv_buffer_0                  equ 54 ; Start index of buffer 0 variables
rsv_priority_0                equ 54 ; internal value that hold priority in video buffer 0
rsv_priority_prev_obj_0       equ 55 ; and 56 ; previous object (OST address) in display priority list for video buffer 0 (0000 if none) w
rsv_priority_next_obj_0       equ 57 ; and 58 ; next object (OST address) in display priority list for video buffer 0 (0000 if none) w
*rsv_prev_image_subset_0       equ 59 ; and 60 ; reference to previous image subset in video buffer 0 w
rsv_prev_mapping_frame_0      equ 61 ; and 62 ; reference to previous image in video buffer 0 w
rsv_bgdata_0                  equ 63 ; and 64 ; address of background data in screen 0 w
rsv_prev_xy_pixel_0           equ 65 ;
rsv_prev_x_pixel_0            equ 65 ; previous x screen coordinate b
rsv_prev_y_pixel_0            equ 66 ; previous y screen coordinate b, must follow x_pixel
rsv_prev_xy1_pixel_0          equ 67 ;
rsv_prev_x1_pixel_0           equ 67 ; previous x+x_offset-(x_size/2) screen coordinate b
rsv_prev_y1_pixel_0           equ 68 ; previous y+y_offset-(y_size/2) screen coordinate b, must follow x1_pixel
rsv_prev_xy2_pixel_0          equ 69 ;
rsv_prev_x2_pixel_0           equ 69 ; previous x+x_offset+(x_size/2) screen coordinate b
rsv_prev_y2_pixel_0           equ 70 ; previous y+y_offset+(y_size/2) screen coordinate b, must follow x2_pixel
rsv_prev_render_flags_0       equ 71 ;
* --- rsv_prev_render_flags_0 bitfield variables ---
rsv_prev_render_overlay_mask  equ $01 ; (bit 0) if a sprite has been rendered with compilated sprite and no background save on screen buffer 0/1
rsv_prev_render_onscreen_mask equ $80 ; (bit 7) DEPENDENCY should be bit 7 - has been rendered on screen buffer 0/1

rsv_buffer_1                  equ 72 ; Start index of buffer 1 variables
rsv_priority_1                equ 72 ; internal value that hold priority in video buffer 1
rsv_priority_prev_obj_1       equ 73 ; and 74 ; previous object (OST address) in display priority list for video buffer 1 (0000 if none) w
rsv_priority_next_obj_1       equ 75 ; and 76 ; next object (OST address) in display priority list for video buffer 1 (0000 if none) w
*rsv_prev_image_subset_1       equ 77 ; and 78 ; reference to previous image subset in video buffer 1 w
rsv_prev_mapping_frame_1      equ 79 ; and 80 ; reference to previous image in video buffer 1 w
rsv_bgdata_1                  equ 81 ; and 82 ; address of background data in screen 1 w
rsv_prev_xy_pixel_1           equ 83 ;
rsv_prev_x_pixel_1            equ 83 ; previous x screen coordinate b
rsv_prev_y_pixel_1            equ 84 ; previous y screen coordinate b, must follow x_pixel
rsv_prev_xy1_pixel_1          equ 85 ;
rsv_prev_x1_pixel_1           equ 85 ; previous x+x_size screen coordinate b
rsv_prev_y1_pixel_1           equ 86 ; previous y+y_size screen coordinate b, must follow x_pixel
rsv_prev_xy2_pixel_1          equ 87 ;
rsv_prev_x2_pixel_1           equ 87 ; previous x+x_size screen coordinate b
rsv_prev_y2_pixel_1           equ 88 ; previous y+y_size screen coordinate b, must follow x_pixel
rsv_prev_render_flags_1       equ 89 ;

buf_priority                  equ 0  ; offset for each rsv_buffer variables
buf_priority_prev_obj         equ 1  ;
buf_priority_next_obj         equ 3  ;
*buf_prev_image_subset         equ 5  ;
buf_prev_mapping_frame        equ 7  ;
buf_bgdata                    equ 9  ;
buf_prev_xy_pixel             equ 11 ;
buf_prev_x_pixel              equ 11 ;
buf_prev_y_pixel              equ 12 ;
buf_prev_xy1_pixel            equ 13 ;
buf_prev_x1_pixel             equ 13 ;
buf_prev_y1_pixel             equ 14 ;
buf_prev_xy2_pixel            equ 15 ;
buf_prev_x2_pixel             equ 15 ;
buf_prev_y2_pixel             equ 16 ;
buf_prev_render_flags         equ 17 ;