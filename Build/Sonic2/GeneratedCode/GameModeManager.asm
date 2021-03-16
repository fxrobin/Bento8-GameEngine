********************************************************************************
* Gestion des modes de jeu (TO8 Thomson) - Benoit Rousseau 07/11/2020
* ------------------------------------------------------------------------------
*
* Permet de gerer les differents etats/modes d'un jeu
* - introduction
* - ecran de titre
* - ecran d'options
* - niveaux de jeu
* - animation de fin
* - ...
* 
* A pour role de charger un etat memoire par rapport a une configuration
* Les donnees sont chargees depuis la disquette puis decompressees par exomizer
* ------------------------------------------------------------------------------
* 
* Positionnement de la page 3 a l'ecran
* Positionnement de la page 2 en zone 0000-3FFF
* Positionnement de la page 0a en zone 4000-5FFF
* Copie en page 0a du moteur Game Mode (dont exomizer) et des donnees du mode a charger
* Execution du moteur Game Mode en page 0a
* Chargement des donnees du Mode depuis la disquette vers 0000-3FFF (buffer)
* Decompression et ecriture de la RAM en A000-DFFF (pages 5-31)
* Chargement du programme principal du nouveau Mode en page 1 a 6100
* Re-initialisation de la pile systeme a 9FFF
* Branchement en 6000
*
* input REG : [u] GameMode pointer
*
********************************************************************************

(main)GAMEMODE
        INCLUD CONSTANT
        INCLUD GLOBALS
        org $A000

GameModeManager

* Positionnement de la page 3 a l'ecran
***********************************************************
WaitVBL
        tst   $E7E7                    * le faisceau n'est pas dans l'ecran
        bpl   WaitVBL                  * tant que le bit est a 0 on boucle
WaitVBL_01
        tst   $E7E7                    * le faisceau est dans l'ecran
        bmi   WaitVBL_01               * tant que le bit est a 1 on boucle
SwapVideoPage
        ldb   #$C0                     * page 3, couleur de cadre 0
        stb   $E7DD                    * affiche la page a l'ecran
        
* Positionnement de la page 2 en zone 0000-3FFF
***********************************************************
        ldb   #$62                     * changement page 2
        stb   $E7E6                    * visible dans l'espace cartouche
        
* Positionnement de la page 0a en zone 4000-5FFF
***********************************************************
        ldb   $E7C3                    * charge l'id de la demi-Page 0 en espace ecran
        andb  #$FE                     * positionne bit0=0 pour page 0 RAMA
        stb   $E7C3                    * dans l'espace ecran

* Copie en page 0a des donnees du mode a charger
* les groupes de 7 octets sont recopiees a l'envers
* si on souhaite implanter le debut du moteur du niveau en $6000
* il faut le charger en dernier (car ecrase les registres moniteur)
* la fin des donnees est marquee par un octet negatif ($FF par exemple)
************************************************************            
        sts   CopyCode3+2              ; sauve s
        lds   -2,u                     ; s=destination u=source
        lda   #$FF                     ; ecriture balise de fin
        pshs  a                        ; pour GameModeEngine
CopyData1
        pulu  d,x,y,dp                 ; on lit 7 octets
        pshs  d,x,y,dp                 ; on ecrit 7 octets
CopyData2
        tsta                           ; fin ?
        bpl   CopyData1                ; non => boucle 2 + 3 cycles

* Copie en page 0a du code Game Mode Engine
* les groupes de 7 octets sont recopiees a l'envers, le builder va inverser
* les donnees a l'avance on gagne un leas dans la boucle.
************************************************************     
        ldu   #GameModeLoaderBin       * source
CopyCode1
        pulu  d,x,y,dp                 ; on lit 7 octets
        pshs  d,x,y,dp                 ; on ecrit 7 octets
CopyCode2
        cmps  #$4000                   ; fin ?
        bne   CopyCode1                ; non => boucle 5 + 3 cycles
CopyCode3
        lds   #0                       ; restaure s
        
* Execution du Game Mode Engine en page 0a
************************************************************         
        jmp   GameModeLoader     

* ==============================================================================
* GameModeEngine
* ==============================================================================
GameModeLoaderBin
        INCLUD GMLOADER
        INCLUD GMDATA


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

(include)GMLOADER

        fcb   $00,$35,$40,$20,$8F,$00,$00
        fcb   $86,$00,$B7,$E7,$E5,$BD,$40
        fcb   $C9,$01,$00,$33,$C9,$FE,$00
        fcb   $DB,$B6,$41,$B8,$27,$08,$33
        fcb   $DE,$4F,$11,$83,$00,$00,$23
        fcb   $04,$0F,$4B,$0C,$49,$0C,$4F
        fcb   $0C,$4B,$96,$4B,$81,$4F,$23
        fcb   $10,$23,$10,$86,$01,$97,$4C
        fcb   $E8,$2A,$0C,$4C,$96,$4C,$81
        fcb   $34,$40,$86,$02,$97,$48,$BD
        fcb   $26,$B7,$41,$B8,$F7,$41,$BA
        fcb   $DD,$4A,$C6,$00,$DD,$4F,$37
        fcb   $01,$C4,$7F,$97,$49,$86,$00
        fcb   $F7,$41,$A8,$E6,$C0,$1D,$84
        fcb   $9F,$FF,$7E,$61,$00,$97,$4C
        fcb   $8B,$EC,$C1,$2A,$07,$10,$CE
        fcb   $41,$CE,$34,$40,$86,$60,$1F
        fcb   $00,$00,$00,$00,$00,$00,$CE
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $00,$00,$00,$00,$00,$00,$00
        fcb   $04,$10,$30,$20,$00,$00,$00
        fcb   $8D,$DC,$E3,$01,$39,$04,$02
        fcb   $30,$8D,$00,$0E,$3A,$58,$3A
        fcb   $2A,$F6,$97,$8D,$EC,$E1,$39
        fcb   $27,$FB,$69,$61,$69,$E4,$5A
        fcb   $86,$12,$20,$09,$A6,$C2,$46
        fcb   $FF,$E6,$84,$6F,$E2,$6F,$E2
        fcb   $F4,$20,$B3,$10,$AF,$66,$35
        fcb   $12,$34,$A7,$A4,$30,$1F,$26
        fcb   $77,$35,$10,$31,$3F,$A6,$A9
        fcb   $8D,$1B,$EB,$03,$8D,$32,$DD
        fcb   $10,$83,$00,$03,$24,$01,$3A
        fcb   $8D,$44,$34,$06,$30,$8C,$4B
        fcb   $A2,$30,$1F,$26,$F8,$20,$D9
        fcb   $8D,$39,$1F,$01,$A6,$C2,$A7
        fcb   $C1,$10,$27,$37,$25,$0F,$5A
        fcb   $5C,$8D,$46,$27,$F9,$C6,$00
        fcb   $26,$15,$D7,$45,$8C,$0C,$45
        fcb   $10,$AE,$66,$C6,$01,$8D,$50
        fcb   $35,$06,$5C,$C1,$34,$26,$DC
        fcb   $FA,$E6,$E4,$AF,$A1,$30,$8B
        fcb   $A0,$53,$69,$E4,$49,$5C,$2B
        fcb   $00,$01,$C6,$04,$8D,$6D,$E7
        fcb   $34,$06,$C5,$0F,$26,$03,$8E
        fcb   $8D,$00,$A9,$5F,$D7,$8D,$4F
        fcb   $34,$7F,$1F,$50,$1F,$8B,$31

(include)GMDATA
* Generated Code

* structure: sector, nb sector, drive (bit 7) track (bit 6-0), end offset, ram dest page, ram dest end addr. hb, ram dest end addr. lb
gm_TITLESCR
        fdb   current_game_mode_data+876
gmboot * @globals
        fcb   $07,$06,$00,$2C,$0A,$DF,$DE * Img_SonicAndTailsIn ND0 Draw
        fcb   $0D,$00,$00,$D2,$05,$DF,$FB * SonicAndTailsIn Object code
        fcb   $0C,$08,$01,$04,$0C,$DD,$55 * Img_SegaLogo_2 ND0 Draw
        fcb   $04,$04,$02,$B0,$0A,$D1,$01 * Img_SegaLogo_1 ND0 Draw
        fcb   $08,$01,$02,$35,$05,$DD,$BA * Img_SegaTrails_1 XD0 Draw
        fcb   $09,$00,$02,$CE,$05,$DF,$31 * Img_SegaTrails_1 ND0 Draw
        fcb   $09,$04,$02,$2D,$08,$D8,$0A * Img_SegaSonic_12 XB0 Draw
        fcb   $0D,$01,$02,$3D,$06,$DF,$F7 * Img_SegaSonic_12 XB0 Erase
        fcb   $0E,$03,$02,$B7,$08,$DF,$D9 * Img_SegaSonic_12 NB0 Draw
        fcb   $01,$01,$03,$E2,$05,$DC,$43 * Img_SegaSonic_12 NB0 Erase
        fcb   $02,$02,$03,$08,$05,$D6,$60 * Img_SegaSonic_23 XB0 Draw
        fcb   $04,$00,$03,$92,$05,$D4,$11 * Img_SegaSonic_23 XB0 Erase
        fcb   $04,$01,$03,$C8,$05,$D9,$93 * Img_SegaSonic_23 NB0 Draw
        fcb   $05,$01,$03,$58,$05,$D7,$46 * Img_SegaSonic_23 NB0 Erase
        fcb   $06,$01,$03,$D8,$06,$DA,$85 * Img_SegaSonic_13 XB0 Draw
        fcb   $07,$01,$03,$81,$05,$D2,$1B * Img_SegaSonic_13 XB0 Erase
        fcb   $08,$02,$03,$22,$06,$DD,$4F * Img_SegaSonic_13 NB0 Draw
        fcb   $0A,$00,$03,$DA,$05,$D3,$2B * Img_SegaSonic_13 NB0 Erase
        fcb   $0A,$04,$03,$95,$09,$D6,$DB * Img_SegaSonic_32 XB0 Draw
        fcb   $0E,$01,$03,$D9,$06,$D4,$CD * Img_SegaSonic_32 XB0 Erase
        fcb   $0F,$04,$03,$D3,$09,$DF,$37 * Img_SegaSonic_32 NB0 Draw
        fcb   $03,$02,$04,$30,$06,$D7,$B9 * Img_SegaSonic_32 NB0 Erase
        fcb   $05,$02,$04,$8B,$07,$DF,$FF * Img_SegaSonic_21 XB0 Draw
        fcb   $07,$01,$04,$6B,$05,$CF,$3E * Img_SegaSonic_21 XB0 Erase
        fcb   $08,$02,$04,$8E,$06,$D1,$DA * Img_SegaSonic_21 NB0 Draw
        fcb   $0A,$01,$04,$64,$05,$D1,$0C * Img_SegaSonic_21 NB0 Erase
        fcb   $0B,$01,$04,$80,$06,$CD,$39 * Img_SegaSonic_43 XB0 Draw
        fcb   $0C,$01,$04,$08,$05,$CA,$3A * Img_SegaSonic_43 XB0 Erase
        fcb   $0D,$01,$04,$2E,$05,$CD,$6F * Img_SegaSonic_43 NB0 Draw
        fcb   $0E,$00,$04,$BC,$05,$CB,$22 * Img_SegaSonic_43 NB0 Erase
        fcb   $0E,$03,$04,$0A,$08,$CB,$71 * Img_SegaSonic_11 XB0 Draw
        fcb   $01,$01,$05,$09,$05,$C7,$58 * Img_SegaSonic_11 XB0 Erase
        fcb   $02,$02,$05,$4C,$08,$D0,$45 * Img_SegaSonic_11 NB0 Draw
        fcb   $04,$01,$05,$46,$05,$C9,$52 * Img_SegaSonic_11 NB0 Erase
        fcb   $05,$01,$05,$81,$05,$C2,$38 * Img_SegaSonic_33 XB0 Draw
        fcb   $06,$01,$05,$11,$05,$C0,$02 * Img_SegaSonic_33 XB0 Erase
        fcb   $07,$01,$05,$61,$05,$C5,$5D * Img_SegaSonic_33 NB0 Draw
        fcb   $08,$00,$05,$F5,$05,$C3,$27 * Img_SegaSonic_33 NB0 Erase
        fcb   $08,$04,$05,$48,$09,$CE,$7B * Img_SegaSonic_22 XB0 Draw
        fcb   $0C,$01,$05,$55,$06,$C8,$2D * Img_SegaSonic_22 XB0 Erase
        fcb   $0D,$03,$05,$E5,$08,$C6,$9D * Img_SegaSonic_22 NB0 Draw
        fcb   $10,$02,$05,$0C,$06,$CA,$EC * Img_SegaSonic_22 NB0 Erase
        fcb   $02,$02,$06,$5E,$07,$D6,$E1 * Img_SegaSonic_41 XB0 Draw
        fcb   $04,$01,$06,$37,$05,$BD,$54 * Img_SegaSonic_41 XB0 Erase
        fcb   $05,$02,$06,$66,$07,$DB,$5E * Img_SegaSonic_41 NB0 Draw
        fcb   $07,$01,$06,$45,$05,$BF,$13 * Img_SegaSonic_41 NB0 Erase
        fcb   $08,$02,$06,$79,$08,$B9,$A1 * Img_SegaSonic_31 XB0 Draw
        fcb   $0A,$01,$06,$5B,$05,$B9,$A8 * Img_SegaSonic_31 XB0 Erase
        fcb   $0B,$02,$06,$69,$08,$BE,$76 * Img_SegaSonic_31 NB0 Draw
        fcb   $0D,$01,$06,$3C,$05,$BB,$95 * Img_SegaSonic_31 NB0 Erase
        fcb   $0E,$03,$06,$D0,$09,$BD,$E6 * Img_SegaSonic_42 XB0 Draw
        fcb   $01,$01,$07,$F3,$06,$C2,$A5 * Img_SegaSonic_42 XB0 Erase
        fcb   $02,$04,$07,$AB,$09,$C6,$3C * Img_SegaSonic_42 NB0 Draw
        fcb   $06,$01,$07,$E0,$06,$C5,$71 * Img_SegaSonic_42 NB0 Erase
        fcb   $07,$01,$07,$19,$05,$B7,$BB * Img_SegaTrails_6 XD0 Draw
        fcb   $08,$00,$07,$52,$05,$B6,$45 * Img_SegaTrails_5 XD0 Draw
        fcb   $08,$00,$07,$8B,$05,$B4,$CF * Img_SegaTrails_4 ND0 Draw
        fcb   $08,$00,$07,$C4,$05,$B3,$59 * Img_SegaTrails_3 ND0 Draw
        fcb   $08,$01,$07,$41,$05,$B0,$11 * Img_SegaTrails_2 XD0 Draw
        fcb   $09,$00,$07,$D0,$05,$B1,$E3 * Img_SegaTrails_2 ND0 Draw
        fcb   $09,$33,$07,$45,$0E,$DF,$F6 * Pcm_SEGA0 Sound
        fcb   $0C,$1B,$0A,$EA,$0D,$DF,$ED * Pcm_SEGA1 Sound
        fcb   $07,$02,$0C,$8C,$06,$BF,$DA * SEGA Object code
        fcb   $07,$01,$0D,$C1,$05,$AE,$37 * PaletteHandler Object code
        fcb   $07,$01,$0E,$1D,$05,$AD,$49 * Img_star_4 NB0 Draw
        fcb   $08,$00,$0E,$93,$05,$AB,$96 * Img_star_4 NB0 Erase
        fcb   $08,$01,$0E,$43,$05,$AB,$01 * Img_star_3 NB0 Draw
        fcb   $09,$00,$0E,$98,$05,$A9,$FF * Img_star_3 NB0 Erase
        fcb   $09,$02,$0E,$AD,$06,$BC,$F6 * Img_sonicHand ND0 Draw
        fcb   $0B,$03,$0E,$5E,$08,$B4,$CE * Img_sonicHand NB0 Draw
        fcb   $0E,$01,$0E,$71,$05,$A9,$A1 * Img_sonicHand NB0 Erase
        fcb   $0F,$00,$0E,$D7,$05,$A7,$32 * Img_star_2 NB1 Draw
        fcb   $0F,$01,$0E,$19,$05,$A6,$C3 * Img_star_2 NB1 Erase
        fcb   $10,$00,$0E,$80,$05,$A7,$D1 * Img_star_2 NB0 Draw
        fcb   $10,$00,$0E,$C2,$05,$A7,$60 * Img_star_2 NB0 Erase
        fcb   $10,$01,$0E,$0F,$05,$A6,$1E * Img_star_1 NB1 Draw
        fcb   $01,$00,$0F,$4B,$05,$A5,$CD * Img_star_1 NB1 Erase
        fcb   $01,$00,$0F,$9A,$05,$A6,$95 * Img_star_1 NB0 Draw
        fcb   $01,$00,$0F,$D6,$05,$A6,$42 * Img_star_1 NB0 Erase
        fcb   $01,$02,$0F,$B7,$07,$D2,$64 * Img_emblemBack08 ND0 Draw
        fcb   $03,$02,$0F,$65,$06,$B9,$4F * Img_emblemBack07 ND0 Draw
        fcb   $05,$02,$0F,$23,$06,$B5,$B7 * Img_emblemBack09 ND0 Draw
        fcb   $07,$01,$0F,$42,$05,$A5,$A9 * Img_emblemBack04 ND0 Draw
        fcb   $08,$02,$0F,$0E,$06,$B2,$4A * Img_emblemBack03 ND0 Draw
        fcb   $0A,$00,$0F,$5B,$05,$A4,$0E * Img_emblemBack06 ND0 Draw
        fcb   $0A,$01,$0F,$E4,$06,$AE,$6C * Img_emblemBack05 ND0 Draw
        fcb   $0B,$06,$0F,$99,$09,$B5,$82 * Img_tails_5 ND0 Draw
        fcb   $01,$07,$10,$94,$0A,$C4,$74 * Img_tails_5 NB0 Draw
        fcb   $08,$02,$10,$53,$07,$CD,$D8 * Img_tails_5 NB0 Erase
        fcb   $0A,$06,$10,$CD,$0B,$DC,$C7 * Img_tails_4 NB0 Draw
        fcb   $10,$02,$10,$80,$07,$C9,$60 * Img_tails_4 NB0 Erase
        fcb   $02,$06,$11,$D8,$0B,$CE,$89 * Img_tails_3 NB0 Draw
        fcb   $08,$02,$11,$8D,$07,$C5,$1F * Img_tails_3 NB0 Erase
        fcb   $0A,$06,$11,$58,$0A,$B5,$8E * Img_tails_2 NB0 Draw
        fcb   $10,$01,$11,$B2,$06,$AA,$B6 * Img_tails_2 NB0 Erase
        fcb   $01,$05,$12,$72,$0B,$C0,$33 * Img_tails_1 NB0 Draw
        fcb   $06,$01,$12,$85,$06,$A7,$05 * Img_tails_1 NB0 Erase
        fcb   $07,$01,$12,$50,$05,$A1,$B1 * Img_tailsHand ND0 Draw
        fcb   $08,$01,$12,$7E,$06,$A3,$99 * Img_tailsHand NB0 Draw
        fcb   $09,$00,$12,$00,$05,$A2,$53 * Img_tailsHand NB0 Erase
        fcb   $0A,$09,$12,$E0,$0C,$C3,$98 * Img_island NB0 Draw
        fcb   $03,$02,$13,$FB,$09,$AB,$27 * Img_island NB0 Erase
        fcb   $05,$04,$13,$A1,$0B,$B4,$C9 * Img_sonic_1 NB0 Draw
        fcb   $09,$01,$13,$9A,$07,$C0,$B4 * Img_sonic_1 NB0 Erase
        fcb   $0A,$05,$13,$E2,$0C,$B0,$8A * Img_sonic_2 NB0 Draw
        fcb   $0F,$02,$13,$14,$07,$BC,$85 * Img_sonic_2 NB0 Erase
        fcb   $01,$01,$14,$EF,$07,$B7,$D8 * Img_emblemBack02 ND0 Draw
        fcb   $02,$02,$14,$B5,$07,$B4,$3A * Img_emblemBack01 ND0 Draw
        fcb   $04,$05,$14,$51,$0D,$BE,$6F * Img_sonic_3 NB0 Draw
        fcb   $09,$01,$14,$4B,$07,$B0,$D6 * Img_sonic_3 NB0 Erase
        fcb   $0A,$04,$14,$3C,$0A,$A9,$2B * Img_sonic_4 ND0 Draw
        fcb   $0E,$04,$14,$A1,$0D,$AE,$DF * Img_sonic_4 NB0 Draw
        fcb   $02,$01,$15,$A0,$07,$AC,$72 * Img_sonic_4 NB0 Erase
        fcb   $03,$01,$15,$58,$06,$A2,$05 * Img_emblemFront07 ND0 Draw
        fcb   $04,$02,$15,$97,$08,$AF,$79 * Img_emblemFront08 ND0 Draw
        fcb   $06,$02,$15,$C8,$08,$AA,$D0 * Img_emblemFront05 ND0 Draw
        fcb   $08,$02,$15,$F0,$07,$A8,$3D * Img_emblemFront06 ND0 Draw
        fcb   $0A,$02,$15,$AE,$07,$A4,$06 * Img_emblemFront03 ND0 Draw
        fcb   $0C,$02,$15,$3C,$08,$A6,$0B * Img_emblemFront04 ND0 Draw
        fcb   $0E,$00,$15,$BF,$05,$A0,$AE * Img_emblemFront01 ND0 Draw
        fcb   $0E,$02,$15,$3C,$08,$A2,$F6 * Img_emblemFront02 ND0 Draw
        fcb   $10,$03,$15,$43,$09,$A6,$08 * Psg_TitleScreen0 Sound
        fcb   $03,$03,$16,$DC,$0B,$A6,$2E * TitleScreen Object code
        fcb   $06,$0F,$16,$35,$01,$8B,$3B * TITLESCR Main Engine code
        fcb   $FF