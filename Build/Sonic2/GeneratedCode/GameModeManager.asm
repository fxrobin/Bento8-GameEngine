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
nb_dynamic_objects            equ 37
nb_level_objects              equ 3
nb_objects                    equ 42 * max 64 total

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

* TODO Doit etre gere dynamiquement par le builder en fonction du properties
PalID_TitleScreenRaster       equ 0

(include)GLOBALS
* Generated Code

GameModeLoader equ $414F
current_game_mode_data equ $41C7
ObjID_PaletteFade equ 1
ObjID_RasterFade equ 2
ObjID_SonicAndTailsIn equ 3
ObjID_SEGA equ 4
ObjID_TitleScreen equ 5
Glb_Sprite_Screen_Pos_Part1 equ $6122
Glb_Sprite_Screen_Pos_Part2 equ $6124
Object_RAM equ $6660
screen_border_color equ $7536
Vint_runcount equ $755C
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
Joypads_Held equ $7560
Dpad_Held equ $7560
Fire_Held equ $7561
Joypads_Press equ $7562
Dpad_Press equ $7562
Fire_Press equ $7563
MarkObjGone equ $75CD
DisplaySprite_x equ $75CF
DisplaySprite equ $75D5
AnimateSprite equ $764E
DeleteObject_x equ $7713
DeleteObject equ $7719
ClearObj equ $77DB
ClearCartMem equ $808B
Refresh_palette equ $80C5
Cur_palette equ $80C6
Dyn_palette equ $80C8
Black_palette equ $80E8
White_palette equ $8108
UpdatePalette equ $8128
PlayPCM equ $8150
PSGInit equ $81A7
PSGPlayNoRepeat equ $81B9
PSGStop equ $81E7
PSGResume equ $8210
PSGCancelLoop equ $825B
PSGGetStatus equ $825F
PSGSetMusicVolumeAttenuation equ $8263
PSGSilenceChannels equ $82C2
PSGRestoreVolumes equ $82D7
PSGSFXPlayLoop equ $834B
PSGSFXStop equ $8397
PSGSFXCancelLoop equ $840D
PSGSFXGetStatus equ $8411
PSGFrame equ $8415
_sendVolume2PSG equ $84CF
PSGSFXFrame equ $8522
_SFXsetLoopPoint equ $857F
irq_routine equ $6027
irq_timer_ctrl equ $E7C5
irq_timer equ $E7C6
irq_one_frame equ $4DFF
Irq_Raster_Page equ $85CB
Irq_Raster_Start equ $85CD
Irq_Raster_End equ $85CF
IrqOn equ $85D1
IrqOff equ $85DC
IrqSync equ $85E7
IrqPsg equ $8606
IrqPsgRaster equ $8615
Img_SonicAndTailsIn equ $8656
Img_SegaLogo_2 equ $8666
Img_SegaLogo_1 equ $8676
Img_SegaTrails_1 equ $8686
Img_SegaSonic_12 equ $869F
Img_SegaSonic_23 equ $86C0
Img_SegaSonic_13 equ $86E1
Img_SegaSonic_32 equ $8702
Img_SegaSonic_21 equ $8723
Img_SegaSonic_43 equ $8744
Img_SegaSonic_11 equ $8765
Img_SegaSonic_33 equ $8786
Img_SegaSonic_22 equ $87A7
Img_SegaSonic_41 equ $87C8
Img_SegaSonic_31 equ $87E9
Img_SegaSonic_42 equ $880A
Img_SegaTrails_6 equ $882B
Img_SegaTrails_5 equ $883B
Img_SegaTrails_4 equ $884B
Img_SegaTrails_3 equ $885B
Img_SegaTrails_2 equ $886B
Img_tails_5 equ $8884
Img_tails_4 equ $889B
Img_tails_3 equ $88AF
Img_tails_2 equ $88C3
Img_tails_1 equ $88D7
Img_islandWater15 equ $88EB
Img_islandWater14 equ $8906
Img_islandWater13 equ $8921
Img_islandWater12 equ $893C
Img_islandWater11 equ $8957
Img_islandMask_1 equ $8972
Img_islandWater10 equ $8982
Img_emblemBack02 equ $899D
Img_emblemBack01 equ $89AD
Img_islandMask_2 equ $89BD
Img_islandWater09 equ $89CD
Img_islandWater08 equ $89E8
Img_islandWater07 equ $8A03
Img_islandWater06 equ $8A1E
Img_islandWater05 equ $8A39
Img_islandWater04 equ $8A54
Img_islandWater03 equ $8A6F
Img_islandWater02 equ $8A8A
Img_star_4 equ $8AA5
Img_islandWater01 equ $8AB9
Img_star_3 equ $8AD4
Img_sonicHand equ $8AE8
Img_star_2 equ $8AFF
Img_star_1 equ $8B1A
Img_emblemBack08 equ $8B35
Img_emblemBack07 equ $8B45
Img_emblemBack09 equ $8B55
Img_emblemBack04 equ $8B65
Img_emblemBack03 equ $8B75
Img_emblemBack06 equ $8B85
Img_emblemBack05 equ $8B95
Img_tailsHand equ $8BA5
Img_island equ $8BBC
Img_sonic_1 equ $8BD7
Img_sonic_2 equ $8BEB
Img_sonic_5 equ $8BFF
Img_sonic_3 equ $8C16
Img_emblemFront07 equ $8C2A
Img_emblemFront08 equ $8C3A
Img_emblemFront05 equ $8C4A
Img_emblemFront06 equ $8C5A
Img_emblemFront03 equ $8C6A
Img_emblemFront04 equ $8C7A
Img_emblemFront01 equ $8C8A
Img_emblemFront02 equ $8C9A
Ani_SegaSonic_3 equ $8CAB
Ani_SegaSonic_2 equ $8CB5
Ani_SegaSonic_1 equ $8CBF
Ani_smallStar equ $8CC9
Ani_largeStar equ $8CCF
Ani_tails equ $8CDB
Ani_sonic equ $8CE7
Glb_Sprite_Screen_Pos_Part1 equ $6122
Glb_Sprite_Screen_Pos_Part2 equ $6124
Object_RAM equ $6660
screen_border_color equ $7536
Vint_runcount equ $755C
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
Joypads_Held equ $7560
Dpad_Held equ $7560
Fire_Held equ $7561
Joypads_Press equ $7562
Dpad_Press equ $7562
Fire_Press equ $7563
MarkObjGone equ $75CD
DisplaySprite_x equ $75CF
DisplaySprite equ $75D5
AnimateSprite equ $764E
DeleteObject_x equ $7713
DeleteObject equ $7719
ClearObj equ $77DB
ClearCartMem equ $808B
Refresh_palette equ $80C5
Cur_palette equ $80C6
Dyn_palette equ $80C8
Black_palette equ $80E8
White_palette equ $8108
UpdatePalette equ $8128
PlayPCM equ $8150
PSGInit equ $81A7
PSGPlayNoRepeat equ $81B9
PSGStop equ $81E7
PSGResume equ $8210
PSGCancelLoop equ $825B
PSGGetStatus equ $825F
PSGSetMusicVolumeAttenuation equ $8263
PSGSilenceChannels equ $82C2
PSGRestoreVolumes equ $82D7
PSGSFXPlayLoop equ $834B
PSGSFXStop equ $8397
PSGSFXCancelLoop equ $840D
PSGSFXGetStatus equ $8411
PSGFrame equ $8415
_sendVolume2PSG equ $84CF
PSGSFXFrame equ $8522
_SFXsetLoopPoint equ $857F
irq_routine equ $6027
irq_timer_ctrl equ $E7C5
irq_timer equ $E7C6
irq_one_frame equ $4DFF
Irq_Raster_Page equ $85CB
Irq_Raster_Start equ $85CD
Irq_Raster_End equ $85CF
IrqOn equ $85D1
IrqOff equ $85DC
IrqSync equ $85E7
IrqPsg equ $8606
IrqPsgRaster equ $8615
Img_SonicAndTailsIn equ $8656
Img_SegaLogo_2 equ $8666
Img_SegaLogo_1 equ $8676
Img_SegaTrails_1 equ $8686
Img_SegaSonic_12 equ $869F
Img_SegaSonic_23 equ $86C0
Img_SegaSonic_13 equ $86E1
Img_SegaSonic_32 equ $8702
Img_SegaSonic_21 equ $8723
Img_SegaSonic_43 equ $8744
Img_SegaSonic_11 equ $8765
Img_SegaSonic_33 equ $8786
Img_SegaSonic_22 equ $87A7
Img_SegaSonic_41 equ $87C8
Img_SegaSonic_31 equ $87E9
Img_SegaSonic_42 equ $880A
Img_SegaTrails_6 equ $882B
Img_SegaTrails_5 equ $883B
Img_SegaTrails_4 equ $884B
Img_SegaTrails_3 equ $885B
Img_SegaTrails_2 equ $886B
Img_tails_5 equ $8884
Img_tails_4 equ $889B
Img_tails_3 equ $88AF
Img_tails_2 equ $88C3
Img_tails_1 equ $88D7
Img_islandWater15 equ $88EB
Img_islandWater14 equ $8906
Img_islandWater13 equ $8921
Img_islandWater12 equ $893C
Img_islandWater11 equ $8957
Img_islandMask_1 equ $8972
Img_islandWater10 equ $8982
Img_emblemBack02 equ $899D
Img_emblemBack01 equ $89AD
Img_islandMask_2 equ $89BD
Img_islandWater09 equ $89CD
Img_islandWater08 equ $89E8
Img_islandWater07 equ $8A03
Img_islandWater06 equ $8A1E
Img_islandWater05 equ $8A39
Img_islandWater04 equ $8A54
Img_islandWater03 equ $8A6F
Img_islandWater02 equ $8A8A
Img_star_4 equ $8AA5
Img_islandWater01 equ $8AB9
Img_star_3 equ $8AD4
Img_sonicHand equ $8AE8
Img_star_2 equ $8AFF
Img_star_1 equ $8B1A
Img_emblemBack08 equ $8B35
Img_emblemBack07 equ $8B45
Img_emblemBack09 equ $8B55
Img_emblemBack04 equ $8B65
Img_emblemBack03 equ $8B75
Img_emblemBack06 equ $8B85
Img_emblemBack05 equ $8B95
Img_tailsHand equ $8BA5
Img_island equ $8BBC
Img_sonic_1 equ $8BD7
Img_sonic_2 equ $8BEB
Img_sonic_5 equ $8BFF
Img_sonic_3 equ $8C16
Img_emblemFront07 equ $8C2A
Img_emblemFront08 equ $8C3A
Img_emblemFront05 equ $8C4A
Img_emblemFront06 equ $8C5A
Img_emblemFront03 equ $8C6A
Img_emblemFront04 equ $8C7A
Img_emblemFront01 equ $8C8A
Img_emblemFront02 equ $8C9A
Ani_SegaSonic_3 equ $8CAB
Ani_SegaSonic_2 equ $8CB5
Ani_SegaSonic_1 equ $8CBF
Ani_smallStar equ $8CC9
Ani_largeStar equ $8CCF
Ani_tails equ $8CDB
Ani_sonic equ $8CE7
Pcm_SEGA equ $8FF0
Psg_TitleScreen equ $8FFB
Pal_Island equ $9035
Pal_SEGA equ $9055
Pal_TitleScreen equ $9075
Pal_SEGAMid equ $9095
Pal_SonicAndTailsIn equ $90B5
Pal_SEGAEnd equ $90D5

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
        fdb   current_game_mode_data+1331
gmboot * @globals
        fcb   $09,$01,$00,$13,$05,$DF,$F9 * PaletteFade Object code
        fcb   $09,$02,$01,$5A,$08,$DF,$78 * RasterFade Object code
        fcb   $0A,$06,$02,$B1,$0B,$DF,$1D * Img_SonicAndTailsIn ND0 Draw
        fcb   $10,$01,$02,$56,$05,$DF,$0B * SonicAndTailsIn Object code
        fcb   $10,$08,$03,$6B,$0D,$D8,$B2 * Img_SegaLogo_2 ND0 Draw
        fcb   $08,$04,$04,$F6,$0A,$DE,$90 * Img_SegaLogo_1 ND0 Draw
        fcb   $0C,$01,$04,$7B,$05,$DC,$CA * Img_SegaTrails_1 XD0 Draw
        fcb   $0D,$01,$04,$14,$05,$DE,$41 * Img_SegaTrails_1 ND0 Draw
        fcb   $0E,$03,$04,$72,$09,$D5,$F6 * Img_SegaSonic_12 XB0 Draw
        fcb   $01,$01,$05,$85,$06,$DD,$3E * Img_SegaSonic_12 XB0 Erase
        fcb   $02,$03,$05,$F4,$09,$DD,$C5 * Img_SegaSonic_12 NB0 Draw
        fcb   $05,$02,$05,$1D,$06,$DF,$EE * Img_SegaSonic_12 NB0 Erase
        fcb   $07,$01,$05,$43,$06,$D8,$49 * Img_SegaSonic_23 XB0 Draw
        fcb   $08,$00,$05,$CD,$05,$DA,$6D * Img_SegaSonic_23 XB0 Erase
        fcb   $08,$02,$05,$03,$06,$DA,$96 * Img_SegaSonic_23 NB0 Draw
        fcb   $0A,$00,$05,$93,$05,$DB,$53 * Img_SegaSonic_23 NB0 Erase
        fcb   $0A,$02,$05,$18,$06,$D3,$30 * Img_SegaSonic_13 XB0 Draw
        fcb   $0C,$00,$05,$BE,$05,$D8,$77 * Img_SegaSonic_13 XB0 Erase
        fcb   $0C,$02,$05,$58,$06,$D5,$FA * Img_SegaSonic_13 NB0 Draw
        fcb   $0E,$01,$05,$10,$05,$D9,$87 * Img_SegaSonic_13 NB0 Erase
        fcb   $0F,$03,$05,$CA,$09,$C5,$D7 * Img_SegaSonic_32 XB0 Draw
        fcb   $02,$02,$06,$14,$06,$CD,$76 * Img_SegaSonic_32 XB0 Erase
        fcb   $04,$04,$06,$0E,$09,$CE,$31 * Img_SegaSonic_32 NB0 Draw
        fcb   $08,$01,$06,$6A,$06,$D0,$64 * Img_SegaSonic_32 NB0 Erase
        fcb   $09,$02,$06,$BE,$08,$D6,$48 * Img_SegaSonic_21 XB0 Draw
        fcb   $0B,$01,$06,$99,$05,$D5,$9A * Img_SegaSonic_21 XB0 Erase
        fcb   $0C,$02,$06,$BE,$08,$DA,$E9 * Img_SegaSonic_21 NB0 Draw
        fcb   $0E,$01,$06,$97,$05,$D7,$68 * Img_SegaSonic_21 NB0 Erase
        fcb   $0F,$01,$06,$B3,$06,$C8,$35 * Img_SegaSonic_43 XB0 Draw
        fcb   $10,$01,$06,$3B,$05,$D2,$E3 * Img_SegaSonic_43 XB0 Erase
        fcb   $01,$01,$07,$61,$06,$CA,$82 * Img_SegaSonic_43 NB0 Draw
        fcb   $02,$00,$07,$EF,$05,$D3,$CB * Img_SegaSonic_43 NB0 Erase
        fcb   $02,$03,$07,$45,$08,$CC,$D3 * Img_SegaSonic_11 XB0 Draw
        fcb   $05,$01,$07,$46,$06,$C3,$EE * Img_SegaSonic_11 XB0 Erase
        fcb   $06,$02,$07,$86,$08,$D1,$A7 * Img_SegaSonic_11 NB0 Draw
        fcb   $08,$01,$07,$7E,$06,$C5,$E8 * Img_SegaSonic_11 NB0 Erase
        fcb   $09,$01,$07,$B8,$06,$BF,$BD * Img_SegaSonic_33 XB0 Draw
        fcb   $0A,$01,$07,$44,$05,$D1,$0C * Img_SegaSonic_33 XB0 Erase
        fcb   $0B,$01,$07,$93,$06,$C1,$F3 * Img_SegaSonic_33 NB0 Draw
        fcb   $0C,$01,$07,$27,$05,$D1,$FB * Img_SegaSonic_33 NB0 Erase
        fcb   $0D,$03,$07,$79,$09,$B5,$50 * Img_SegaSonic_22 XB0 Draw
        fcb   $10,$01,$07,$84,$06,$BA,$C8 * Img_SegaSonic_22 XB0 Erase
        fcb   $01,$04,$08,$19,$09,$BD,$77 * Img_SegaSonic_22 NB0 Draw
        fcb   $05,$01,$08,$44,$06,$BD,$87 * Img_SegaSonic_22 NB0 Erase
        fcb   $06,$02,$08,$92,$08,$C7,$FF * Img_SegaSonic_41 XB0 Draw
        fcb   $08,$01,$08,$6D,$05,$CE,$5E * Img_SegaSonic_41 XB0 Erase
        fcb   $09,$02,$08,$9A,$07,$DF,$FD * Img_SegaSonic_41 NB0 Draw
        fcb   $0B,$01,$08,$7B,$05,$D0,$1D * Img_SegaSonic_41 NB0 Erase
        fcb   $0C,$02,$08,$AA,$08,$BE,$AF * Img_SegaSonic_31 XB0 Draw
        fcb   $0E,$01,$08,$8A,$06,$B6,$1F * Img_SegaSonic_31 XB0 Erase
        fcb   $0F,$02,$08,$97,$08,$C3,$84 * Img_SegaSonic_31 NB0 Draw
        fcb   $01,$01,$09,$65,$06,$B8,$0C * Img_SegaSonic_31 NB0 Erase
        fcb   $02,$03,$09,$FD,$0A,$C9,$F0 * Img_SegaSonic_42 XB0 Draw
        fcb   $05,$02,$09,$1C,$06,$B1,$65 * Img_SegaSonic_42 XB0 Erase
        fcb   $07,$03,$09,$D6,$0A,$D2,$46 * Img_SegaSonic_42 NB0 Draw
        fcb   $0A,$02,$09,$07,$06,$B4,$32 * Img_SegaSonic_42 NB0 Erase
        fcb   $0C,$00,$09,$40,$05,$CC,$9F * Img_SegaTrails_6 XD0 Draw
        fcb   $0C,$00,$09,$79,$05,$CB,$29 * Img_SegaTrails_5 XD0 Draw
        fcb   $0C,$00,$09,$B2,$05,$C9,$B3 * Img_SegaTrails_4 ND0 Draw
        fcb   $0C,$00,$09,$EB,$05,$C8,$3D * Img_SegaTrails_3 ND0 Draw
        fcb   $0C,$01,$09,$68,$06,$AE,$9A * Img_SegaTrails_2 XD0 Draw
        fcb   $0D,$00,$09,$F7,$05,$C6,$C7 * Img_SegaTrails_2 ND0 Draw
        fcb   $0D,$33,$09,$6C,$0F,$DF,$F6 * Pcm_SEGA0 Sound
        fcb   $10,$1C,$0C,$11,$0E,$D1,$0E * Pcm_SEGA1 Sound
        fcb   $0C,$01,$0E,$B1,$06,$AC,$C0 * SEGA Object code
        fcb   $0D,$06,$0F,$01,$0A,$C1,$8C * Img_tails_5 ND0 Draw
        fcb   $03,$06,$10,$FD,$0C,$DA,$15 * Img_tails_5 NB0 Draw
        fcb   $09,$02,$10,$BB,$08,$B9,$DC * Img_tails_5 NB0 Erase
        fcb   $0B,$07,$10,$34,$0C,$CB,$2E * Img_tails_4 NB0 Draw
        fcb   $02,$01,$11,$E5,$07,$DB,$80 * Img_tails_4 NB0 Erase
        fcb   $03,$07,$11,$3C,$0C,$BC,$F0 * Img_tails_3 NB0 Draw
        fcb   $0A,$01,$11,$F2,$08,$B5,$62 * Img_tails_3 NB0 Erase
        fcb   $0B,$06,$11,$BF,$0B,$D0,$40 * Img_tails_2 NB0 Draw
        fcb   $01,$02,$12,$19,$07,$D7,$3F * Img_tails_2 NB0 Erase
        fcb   $03,$04,$12,$D9,$0B,$C3,$DE * Img_tails_1 NB0 Draw
        fcb   $07,$01,$12,$EC,$06,$A9,$DC * Img_tails_1 NB0 Erase
        fcb   $08,$01,$12,$2D,$05,$C4,$BE * Img_islandWater15 NB1 Draw
        fcb   $09,$00,$12,$5C,$05,$C4,$99 * Img_islandWater15 NB1 Erase
        fcb   $09,$00,$12,$9D,$05,$C4,$F5 * Img_islandWater15 NB0 Draw
        fcb   $09,$00,$12,$CC,$05,$C4,$D0 * Img_islandWater15 NB0 Erase
        fcb   $09,$01,$12,$0F,$05,$C4,$3B * Img_islandWater14 NB1 Draw
        fcb   $0A,$00,$12,$3E,$05,$C4,$14 * Img_islandWater14 NB1 Erase
        fcb   $0A,$00,$12,$8B,$05,$C4,$87 * Img_islandWater14 NB0 Draw
        fcb   $0A,$00,$12,$BD,$05,$C4,$51 * Img_islandWater14 NB0 Erase
        fcb   $0A,$01,$12,$0D,$05,$C3,$C3 * Img_islandWater13 NB1 Draw
        fcb   $0B,$00,$12,$42,$05,$C3,$86 * Img_islandWater13 NB1 Erase
        fcb   $0B,$00,$12,$8A,$05,$C4,$02 * Img_islandWater13 NB0 Draw
        fcb   $0B,$00,$12,$BC,$05,$C3,$D7 * Img_islandWater13 NB0 Erase
        fcb   $0B,$01,$12,$0E,$05,$C3,$07 * Img_islandWater12 NB1 Draw
        fcb   $0C,$00,$12,$43,$05,$C2,$CC * Img_islandWater12 NB1 Erase
        fcb   $0C,$00,$12,$A1,$05,$C3,$6C * Img_islandWater12 NB0 Draw
        fcb   $0C,$00,$12,$D9,$05,$C3,$23 * Img_islandWater12 NB0 Erase
        fcb   $0C,$01,$12,$32,$05,$C2,$64 * Img_islandWater11 NB1 Draw
        fcb   $0D,$00,$12,$69,$05,$C2,$21 * Img_islandWater11 NB1 Erase
        fcb   $0D,$00,$12,$B6,$05,$C2,$B2 * Img_islandWater11 NB0 Draw
        fcb   $0D,$00,$12,$E6,$05,$C2,$7A * Img_islandWater11 NB0 Erase
        fcb   $0D,$01,$12,$3C,$06,$A6,$70 * Img_islandMask_1 ND1 Draw
        fcb   $0E,$00,$12,$8E,$05,$C1,$8D * Img_islandWater10 NB1 Draw
        fcb   $0E,$00,$12,$C3,$05,$C1,$54 * Img_islandWater10 NB1 Erase
        fcb   $0E,$01,$12,$31,$05,$C2,$07 * Img_islandWater10 NB0 Draw
        fcb   $0F,$00,$12,$6E,$05,$C1,$AD * Img_islandWater10 NB0 Erase
        fcb   $0F,$02,$12,$49,$07,$D3,$8E * Img_emblemBack02 ND0 Draw
        fcb   $01,$02,$13,$0F,$07,$CF,$F0 * Img_emblemBack01 ND0 Draw
        fcb   $03,$00,$13,$4C,$05,$C1,$3C * Img_islandMask_2 ND1 Draw
        fcb   $03,$00,$13,$A1,$05,$BF,$E6 * Img_islandWater09 NB1 Draw
        fcb   $03,$00,$13,$D6,$05,$BF,$A6 * Img_islandWater09 NB1 Erase
        fcb   $03,$01,$13,$2C,$05,$C0,$40 * Img_islandWater09 NB0 Draw
        fcb   $04,$00,$13,$61,$05,$C0,$00 * Img_islandWater09 NB0 Erase
        fcb   $04,$00,$13,$BD,$05,$BF,$21 * Img_islandWater08 NB1 Draw
        fcb   $04,$00,$13,$F5,$05,$BE,$D9 * Img_islandWater08 NB1 Erase
        fcb   $04,$01,$13,$56,$05,$BF,$8C * Img_islandWater08 NB0 Draw
        fcb   $05,$00,$13,$8F,$05,$BF,$3F * Img_islandWater08 NB0 Erase
        fcb   $05,$00,$13,$FE,$05,$BE,$34 * Img_islandWater07 NB1 Draw
        fcb   $05,$01,$13,$3B,$05,$BD,$DF * Img_islandWater07 NB1 Erase
        fcb   $06,$00,$13,$B2,$05,$BE,$BB * Img_islandWater07 NB0 Draw
        fcb   $06,$00,$13,$F1,$05,$BE,$57 * Img_islandWater07 NB0 Erase
        fcb   $06,$01,$13,$97,$05,$BC,$B1 * Img_islandWater06 NB1 Draw
        fcb   $07,$00,$13,$E7,$05,$BB,$F3 * Img_islandWater06 NB1 Erase
        fcb   $07,$01,$13,$97,$05,$BD,$BF * Img_islandWater06 NB0 Draw
        fcb   $08,$00,$13,$ED,$05,$BC,$F3 * Img_islandWater06 NB0 Erase
        fcb   $08,$01,$13,$89,$05,$BA,$D6 * Img_islandWater05 NB1 Draw
        fcb   $09,$00,$13,$DB,$05,$BA,$18 * Img_islandWater05 NB1 Erase
        fcb   $09,$01,$13,$66,$05,$BB,$B3 * Img_islandWater05 NB0 Draw
        fcb   $0A,$00,$13,$B1,$05,$BB,$0C * Img_islandWater05 NB0 Erase
        fcb   $0A,$01,$13,$A2,$05,$B8,$A8 * Img_islandWater04 NB1 Draw
        fcb   $0B,$01,$13,$10,$05,$B7,$66 * Img_islandWater04 NB1 Erase
        fcb   $0C,$00,$13,$D6,$05,$B9,$DD * Img_islandWater04 NB0 Draw
        fcb   $0C,$01,$13,$2F,$05,$B8,$F4 * Img_islandWater04 NB0 Erase
        fcb   $0D,$01,$13,$19,$05,$B4,$FA * Img_islandWater03 NB1 Draw
        fcb   $0E,$00,$13,$82,$05,$B3,$71 * Img_islandWater03 NB1 Erase
        fcb   $0E,$01,$13,$7E,$05,$B6,$FF * Img_islandWater03 NB0 Draw
        fcb   $0F,$00,$13,$EC,$05,$B5,$6A * Img_islandWater03 NB0 Erase
        fcb   $0F,$01,$13,$91,$05,$B1,$D8 * Img_islandWater02 NB1 Draw
        fcb   $10,$00,$13,$D6,$05,$B0,$DA * Img_islandWater02 NB1 Erase
        fcb   $10,$01,$13,$6E,$05,$B3,$06 * Img_islandWater02 NB0 Draw
        fcb   $01,$00,$14,$AE,$05,$B2,$1A * Img_islandWater02 NB0 Erase
        fcb   $01,$01,$14,$B1,$05,$B0,$93 * Img_star_4 NB0 Draw
        fcb   $02,$01,$14,$27,$05,$AE,$E0 * Img_star_4 NB0 Erase
        fcb   $03,$00,$14,$C7,$05,$AD,$23 * Img_islandWater01 NB1 Draw
        fcb   $03,$01,$14,$07,$05,$AC,$2B * Img_islandWater01 NB1 Erase
        fcb   $04,$00,$14,$93,$05,$AE,$4B * Img_islandWater01 NB0 Draw
        fcb   $04,$00,$14,$C8,$05,$AD,$61 * Img_islandWater01 NB0 Erase
        fcb   $04,$01,$14,$78,$05,$AB,$E7 * Img_star_3 NB0 Draw
        fcb   $05,$00,$14,$CD,$05,$AA,$E5 * Img_star_3 NB0 Erase
        fcb   $05,$02,$14,$E2,$07,$CC,$8C * Img_sonicHand ND0 Draw
        fcb   $07,$03,$14,$98,$09,$AD,$11 * Img_sonicHand NB0 Draw
        fcb   $0A,$01,$14,$AB,$05,$AA,$87 * Img_sonicHand NB0 Erase
        fcb   $0B,$01,$14,$11,$05,$A8,$16 * Img_star_2 NB1 Draw
        fcb   $0C,$00,$14,$53,$05,$A7,$A7 * Img_star_2 NB1 Erase
        fcb   $0C,$00,$14,$BA,$05,$A8,$B5 * Img_star_2 NB0 Draw
        fcb   $0C,$00,$14,$FC,$05,$A8,$44 * Img_star_2 NB0 Erase
        fcb   $0C,$01,$14,$49,$05,$A7,$02 * Img_star_1 NB1 Draw
        fcb   $0D,$00,$14,$85,$05,$A6,$B1 * Img_star_1 NB1 Erase
        fcb   $0D,$00,$14,$D4,$05,$A7,$79 * Img_star_1 NB0 Draw
        fcb   $0D,$01,$14,$10,$05,$A7,$26 * Img_star_1 NB0 Erase
        fcb   $0E,$01,$14,$F1,$08,$B0,$F7 * Img_emblemBack08 ND0 Draw
        fcb   $0F,$02,$14,$9F,$07,$C8,$E5 * Img_emblemBack07 ND0 Draw
        fcb   $01,$02,$15,$5D,$07,$C5,$4D * Img_emblemBack09 ND0 Draw
        fcb   $03,$01,$15,$7C,$05,$A6,$8D * Img_emblemBack04 ND0 Draw
        fcb   $04,$02,$15,$48,$07,$C1,$E0 * Img_emblemBack03 ND0 Draw
        fcb   $06,$00,$15,$95,$05,$A4,$F2 * Img_emblemBack06 ND0 Draw
        fcb   $06,$02,$15,$1E,$07,$BE,$02 * Img_emblemBack05 ND0 Draw
        fcb   $08,$00,$15,$E9,$05,$A1,$03 * Img_tailsHand ND0 Draw
        fcb   $08,$02,$15,$14,$05,$A3,$37 * Img_tailsHand NB0 Draw
        fcb   $0A,$00,$15,$9A,$05,$A1,$A3 * Img_tailsHand NB0 Erase
        fcb   $0A,$07,$15,$38,$0B,$AC,$5B * Img_island NB1 Draw
        fcb   $01,$01,$16,$6F,$07,$BA,$4C * Img_island NB1 Erase
        fcb   $02,$06,$16,$DB,$0B,$B8,$74 * Img_island NB0 Draw
        fcb   $08,$01,$16,$FB,$06,$A3,$D7 * Img_island NB0 Erase
        fcb   $09,$04,$16,$A1,$0C,$AE,$9B * Img_sonic_1 NB0 Draw
        fcb   $0D,$01,$16,$9A,$07,$B7,$1C * Img_sonic_1 NB0 Erase
        fcb   $0E,$05,$16,$E2,$0D,$BF,$A1 * Img_sonic_2 NB0 Draw
        fcb   $03,$02,$17,$14,$08,$AC,$6B * Img_sonic_2 NB0 Erase
        fcb   $05,$04,$17,$19,$0A,$B7,$31 * Img_sonic_5 ND0 Draw
        fcb   $09,$04,$17,$94,$0D,$AF,$17 * Img_sonic_5 NB0 Draw
        fcb   $0D,$01,$17,$98,$07,$B2,$ED * Img_sonic_5 NB0 Erase
        fcb   $0E,$05,$17,$34,$0E,$AF,$90 * Img_sonic_3 NB0 Draw
        fcb   $03,$01,$18,$2E,$07,$AE,$A6 * Img_sonic_3 NB0 Erase
        fcb   $04,$00,$18,$E6,$07,$AA,$42 * Img_emblemFront07 ND0 Draw
        fcb   $04,$03,$18,$25,$08,$A7,$BE * Img_emblemFront08 ND0 Draw
        fcb   $07,$02,$18,$56,$09,$A7,$BB * Img_emblemFront05 ND0 Draw
        fcb   $09,$02,$18,$7E,$07,$A8,$3D * Img_emblemFront06 ND0 Draw
        fcb   $0B,$02,$18,$3C,$07,$A4,$06 * Img_emblemFront03 ND0 Draw
        fcb   $0D,$01,$18,$CA,$08,$A3,$15 * Img_emblemFront04 ND0 Draw
        fcb   $0E,$01,$18,$4D,$06,$A0,$AE * Img_emblemFront01 ND0 Draw
        fcb   $0F,$01,$18,$CA,$09,$A2,$F6 * Img_emblemFront02 ND0 Draw
        fcb   $10,$03,$18,$D1,$0A,$AD,$DF * Psg_TitleScreen0 Sound
        fcb   $03,$05,$19,$67,$0A,$A7,$D7 * TitleScreen Object code
        fcb   $08,$10,$19,$02,$01,$90,$F5 * TITLESCR Main Engine code
        fcb   $FF