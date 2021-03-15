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
Glb_Sprite_Screen_Pos_Part1 equ $6142
Glb_Sprite_Screen_Pos_Part2 equ $6144
Object_RAM equ $6630
screen_border_color equ $7182
Vint_runcount equ $71A8
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
Joypads_Held equ $71AC
Dpad_Held equ $71AC
Fire_Held equ $71AD
Joypads_Press equ $71AE
Dpad_Press equ $71AE
Fire_Press equ $71AF
MarkObjGone equ $7219
DisplaySprite_x equ $721B
DisplaySprite equ $7221
AnimateSprite equ $729A
DeleteObject_x equ $735F
DeleteObject equ $7365
ClearObj equ $7427
ClearCartMem equ $7CD7
Refresh_palette equ $7D11
Cur_palette equ $7D12
Dyn_palette equ $7D14
Black_palette equ $7D34
White_palette equ $7D54
UpdatePalette equ $7D74
PlayPCM equ $7D9C
PSGInit equ $7DF3
PSGPlayNoRepeat equ $7E05
PSGStop equ $7E33
PSGResume equ $7E5C
PSGCancelLoop equ $7EA7
PSGGetStatus equ $7EAB
PSGSetMusicVolumeAttenuation equ $7EAF
PSGSilenceChannels equ $7F0E
PSGRestoreVolumes equ $7F23
PSGSFXPlayLoop equ $7F97
PSGSFXStop equ $7FE3
PSGSFXCancelLoop equ $8059
PSGSFXGetStatus equ $805D
PSGFrame equ $8061
_sendVolume2PSG equ $811B
PSGSFXFrame equ $816E
_SFXsetLoopPoint equ $81CB
Img_SonicAndTailsIn equ $8217
Img_SegaLogo_2 equ $8227
Img_SegaLogo_1 equ $8237
Img_SegaTrails_1 equ $8247
Img_SegaSonic_12 equ $8260
Img_SegaSonic_23 equ $8281
Img_SegaSonic_13 equ $82A2
Img_SegaSonic_32 equ $82C3
Img_SegaSonic_21 equ $82E4
Img_SegaSonic_43 equ $8305
Img_SegaSonic_11 equ $8326
Img_SegaSonic_33 equ $8347
Img_SegaSonic_22 equ $8368
Img_SegaSonic_41 equ $8389
Img_SegaSonic_31 equ $83AA
Img_SegaSonic_42 equ $83CB
Img_SegaTrails_6 equ $83EC
Img_SegaTrails_5 equ $83FC
Img_SegaTrails_4 equ $840C
Img_SegaTrails_3 equ $841C
Img_SegaTrails_2 equ $842C
Img_star_4 equ $8445
Img_star_3 equ $8459
Img_sonicHand equ $846D
Img_star_2 equ $8484
Img_star_1 equ $849F
Img_emblemBack08 equ $84BA
Img_emblemBack07 equ $84CA
Img_emblemBack09 equ $84DA
Img_emblemBack04 equ $84EA
Img_emblemBack03 equ $84FA
Img_emblemBack06 equ $850A
Img_emblemBack05 equ $851A
Img_tails_5 equ $852A
Img_tails_4 equ $8541
Img_tails_3 equ $8555
Img_tails_2 equ $8569
Img_tails_1 equ $857D
Img_tailsHand equ $8591
Img_sonic_1 equ $85A8
Img_sonic_2 equ $85BC
Img_emblemBack02 equ $85D0
Img_emblemBack01 equ $85E0
Img_sonic_5 equ $85F0
Img_sonic_3 equ $8607
Img_sonic_4 equ $861B
Img_emblemFront07 equ $862F
Img_emblemFront08 equ $863F
Img_emblemFront05 equ $864F
Img_emblemFront06 equ $865F
Img_emblemFront03 equ $866F
Img_emblemFront04 equ $867F
Img_emblemFront01 equ $868F
Img_emblemFront02 equ $869F
Ani_SegaSonic_3 equ $86B0
Ani_SegaSonic_2 equ $86BA
Ani_SegaSonic_1 equ $86C4
Ani_smallStar equ $86CE
Ani_largeStar equ $86D4
Ani_tails equ $86E0
Ani_sonic equ $86EC
Glb_Sprite_Screen_Pos_Part1 equ $6142
Glb_Sprite_Screen_Pos_Part2 equ $6144
Object_RAM equ $6630
screen_border_color equ $7182
Vint_runcount equ $71A8
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
Joypads_Held equ $71AC
Dpad_Held equ $71AC
Fire_Held equ $71AD
Joypads_Press equ $71AE
Dpad_Press equ $71AE
Fire_Press equ $71AF
MarkObjGone equ $7219
DisplaySprite_x equ $721B
DisplaySprite equ $7221
AnimateSprite equ $729A
DeleteObject_x equ $735F
DeleteObject equ $7365
ClearObj equ $7427
ClearCartMem equ $7CD7
Refresh_palette equ $7D11
Cur_palette equ $7D12
Dyn_palette equ $7D14
Black_palette equ $7D34
White_palette equ $7D54
UpdatePalette equ $7D74
PlayPCM equ $7D9C
PSGInit equ $7DF3
PSGPlayNoRepeat equ $7E05
PSGStop equ $7E33
PSGResume equ $7E5C
PSGCancelLoop equ $7EA7
PSGGetStatus equ $7EAB
PSGSetMusicVolumeAttenuation equ $7EAF
PSGSilenceChannels equ $7F0E
PSGRestoreVolumes equ $7F23
PSGSFXPlayLoop equ $7F97
PSGSFXStop equ $7FE3
PSGSFXCancelLoop equ $8059
PSGSFXGetStatus equ $805D
PSGFrame equ $8061
_sendVolume2PSG equ $811B
PSGSFXFrame equ $816E
_SFXsetLoopPoint equ $81CB
Img_SonicAndTailsIn equ $8217
Img_SegaLogo_2 equ $8227
Img_SegaLogo_1 equ $8237
Img_SegaTrails_1 equ $8247
Img_SegaSonic_12 equ $8260
Img_SegaSonic_23 equ $8281
Img_SegaSonic_13 equ $82A2
Img_SegaSonic_32 equ $82C3
Img_SegaSonic_21 equ $82E4
Img_SegaSonic_43 equ $8305
Img_SegaSonic_11 equ $8326
Img_SegaSonic_33 equ $8347
Img_SegaSonic_22 equ $8368
Img_SegaSonic_41 equ $8389
Img_SegaSonic_31 equ $83AA
Img_SegaSonic_42 equ $83CB
Img_SegaTrails_6 equ $83EC
Img_SegaTrails_5 equ $83FC
Img_SegaTrails_4 equ $840C
Img_SegaTrails_3 equ $841C
Img_SegaTrails_2 equ $842C
Img_star_4 equ $8445
Img_star_3 equ $8459
Img_sonicHand equ $846D
Img_star_2 equ $8484
Img_star_1 equ $849F
Img_emblemBack08 equ $84BA
Img_emblemBack07 equ $84CA
Img_emblemBack09 equ $84DA
Img_emblemBack04 equ $84EA
Img_emblemBack03 equ $84FA
Img_emblemBack06 equ $850A
Img_emblemBack05 equ $851A
Img_tails_5 equ $852A
Img_tails_4 equ $8541
Img_tails_3 equ $8555
Img_tails_2 equ $8569
Img_tails_1 equ $857D
Img_tailsHand equ $8591
Img_sonic_1 equ $85A8
Img_sonic_2 equ $85BC
Img_emblemBack02 equ $85D0
Img_emblemBack01 equ $85E0
Img_sonic_5 equ $85F0
Img_sonic_3 equ $8607
Img_sonic_4 equ $861B
Img_emblemFront07 equ $862F
Img_emblemFront08 equ $863F
Img_emblemFront05 equ $864F
Img_emblemFront06 equ $865F
Img_emblemFront03 equ $866F
Img_emblemFront04 equ $867F
Img_emblemFront01 equ $868F
Img_emblemFront02 equ $869F
Ani_SegaSonic_3 equ $86B0
Ani_SegaSonic_2 equ $86BA
Ani_SegaSonic_1 equ $86C4
Ani_smallStar equ $86CE
Ani_largeStar equ $86D4
Ani_tails equ $86E0
Ani_sonic equ $86EC
Pcm_SEGA equ $89F5
Psg_TitleScreen equ $8A00
Pal_SEGA equ $8A3A
Pal_TitleScreen equ $8A5A
Pal_SEGAMid equ $8A7A
Pal_SonicAndTailsIn equ $8A9A
Pal_SEGAEnd equ $8ABA

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
        fcb   $07,$06,$00,$2C,$0A,$DE,$C0 * Img_SonicAndTailsIn ND0 Draw
        fcb   $0D,$00,$00,$D2,$05,$DF,$FA * SonicAndTailsIn Object code
        fcb   $0B,$08,$01,$B9,$0D,$DB,$3B * Img_SegaLogo_2 ND0 Draw
        fcb   $03,$05,$02,$65,$09,$DD,$CA * Img_SegaLogo_1 ND0 Draw
        fcb   $08,$00,$02,$EA,$05,$DD,$B9 * Img_SegaTrails_1 XD0 Draw
        fcb   $08,$01,$02,$83,$05,$DF,$30 * Img_SegaTrails_1 ND0 Draw
        fcb   $09,$03,$02,$E5,$09,$D1,$3D * Img_SegaSonic_12 XB0 Draw
        fcb   $0C,$01,$02,$F5,$06,$DF,$F9 * Img_SegaSonic_12 XB0 Erase
        fcb   $0D,$04,$02,$68,$08,$DF,$AC * Img_SegaSonic_12 NB0 Draw
        fcb   $01,$01,$03,$94,$05,$DC,$42 * Img_SegaSonic_12 NB0 Erase
        fcb   $02,$01,$03,$BA,$05,$D6,$61 * Img_SegaSonic_23 XB0 Draw
        fcb   $03,$01,$03,$44,$05,$D4,$12 * Img_SegaSonic_23 XB0 Erase
        fcb   $04,$01,$03,$7A,$05,$D9,$94 * Img_SegaSonic_23 NB0 Draw
        fcb   $05,$01,$03,$0A,$05,$D7,$47 * Img_SegaSonic_23 NB0 Erase
        fcb   $06,$01,$03,$8A,$06,$DA,$87 * Img_SegaSonic_13 XB0 Draw
        fcb   $07,$01,$03,$2D,$05,$D2,$1C * Img_SegaSonic_13 XB0 Erase
        fcb   $08,$01,$03,$CA,$06,$DD,$51 * Img_SegaSonic_13 NB0 Draw
        fcb   $09,$01,$03,$7F,$05,$D3,$2C * Img_SegaSonic_13 NB0 Erase
        fcb   $0A,$04,$03,$2E,$09,$C1,$1C * Img_SegaSonic_32 XB0 Draw
        fcb   $0E,$01,$03,$77,$06,$D4,$CF * Img_SegaSonic_32 XB0 Erase
        fcb   $0F,$04,$03,$77,$09,$C9,$78 * Img_SegaSonic_32 NB0 Draw
        fcb   $03,$01,$04,$D3,$06,$D7,$BB * Img_SegaSonic_32 NB0 Erase
        fcb   $04,$03,$04,$28,$07,$DF,$DD * Img_SegaSonic_21 XB0 Draw
        fcb   $07,$01,$04,$03,$05,$CF,$3F * Img_SegaSonic_21 XB0 Erase
        fcb   $08,$02,$04,$3A,$06,$D1,$DD * Img_SegaSonic_21 NB0 Draw
        fcb   $0A,$01,$04,$19,$05,$D1,$0D * Img_SegaSonic_21 NB0 Erase
        fcb   $0B,$01,$04,$35,$06,$CD,$3A * Img_SegaSonic_43 XB0 Draw
        fcb   $0C,$00,$04,$BD,$05,$CA,$3B * Img_SegaSonic_43 XB0 Erase
        fcb   $0C,$01,$04,$E3,$05,$CD,$70 * Img_SegaSonic_43 NB0 Draw
        fcb   $0D,$01,$04,$71,$05,$CB,$23 * Img_SegaSonic_43 NB0 Erase
        fcb   $0E,$02,$04,$CB,$08,$D3,$09 * Img_SegaSonic_11 XB0 Draw
        fcb   $10,$01,$04,$CF,$05,$C7,$59 * Img_SegaSonic_11 XB0 Erase
        fcb   $01,$03,$05,$08,$08,$D7,$DD * Img_SegaSonic_11 NB0 Draw
        fcb   $04,$00,$05,$FA,$05,$C9,$53 * Img_SegaSonic_11 NB0 Erase
        fcb   $04,$02,$05,$34,$05,$C2,$3A * Img_SegaSonic_33 XB0 Draw
        fcb   $06,$00,$05,$C3,$05,$C0,$04 * Img_SegaSonic_33 XB0 Erase
        fcb   $06,$02,$05,$14,$05,$C5,$5F * Img_SegaSonic_33 NB0 Draw
        fcb   $08,$00,$05,$A9,$05,$C3,$29 * Img_SegaSonic_33 NB0 Erase
        fcb   $08,$03,$05,$FA,$09,$B0,$95 * Img_SegaSonic_22 XB0 Draw
        fcb   $0B,$02,$05,$09,$06,$C8,$2E * Img_SegaSonic_22 XB0 Erase
        fcb   $0D,$03,$05,$9E,$09,$B8,$BC * Img_SegaSonic_22 NB0 Draw
        fcb   $10,$01,$05,$C9,$06,$CA,$ED * Img_SegaSonic_22 NB0 Erase
        fcb   $01,$03,$06,$13,$07,$D6,$C3 * Img_SegaSonic_41 XB0 Draw
        fcb   $04,$00,$06,$EA,$05,$BD,$56 * Img_SegaSonic_41 XB0 Erase
        fcb   $04,$03,$06,$17,$07,$DB,$3E * Img_SegaSonic_41 NB0 Draw
        fcb   $07,$00,$06,$F7,$05,$BF,$15 * Img_SegaSonic_41 NB0 Erase
        fcb   $07,$03,$06,$2A,$08,$C9,$60 * Img_SegaSonic_31 XB0 Draw
        fcb   $0A,$01,$06,$0E,$05,$B9,$AA * Img_SegaSonic_31 XB0 Erase
        fcb   $0B,$02,$06,$17,$08,$CE,$35 * Img_SegaSonic_31 NB0 Draw
        fcb   $0D,$00,$06,$E8,$05,$BB,$97 * Img_SegaSonic_31 NB0 Erase
        fcb   $0D,$04,$06,$7D,$0A,$CF,$E3 * Img_SegaSonic_42 XB0 Draw
        fcb   $01,$01,$07,$9D,$06,$C2,$A5 * Img_SegaSonic_42 XB0 Erase
        fcb   $02,$04,$07,$57,$09,$A8,$56 * Img_SegaSonic_42 NB0 Draw
        fcb   $06,$01,$07,$8A,$06,$C5,$72 * Img_SegaSonic_42 NB0 Erase
        fcb   $07,$00,$07,$C3,$05,$B7,$BD * Img_SegaTrails_6 XD0 Draw
        fcb   $07,$00,$07,$FC,$05,$B6,$47 * Img_SegaTrails_5 XD0 Draw
        fcb   $07,$01,$07,$35,$05,$B4,$D1 * Img_SegaTrails_4 ND0 Draw
        fcb   $08,$00,$07,$6E,$05,$B3,$5B * Img_SegaTrails_3 ND0 Draw
        fcb   $08,$00,$07,$EB,$05,$B0,$13 * Img_SegaTrails_2 XD0 Draw
        fcb   $08,$01,$07,$7A,$05,$B1,$E5 * Img_SegaTrails_2 ND0 Draw
        fcb   $09,$32,$07,$EF,$0E,$DF,$F6 * Pcm_SEGA0 Sound
        fcb   $0B,$1C,$0A,$94,$0D,$C1,$7E * Pcm_SEGA1 Sound
        fcb   $07,$02,$0C,$36,$06,$BF,$DA * SEGA Object code
        fcb   $07,$01,$0D,$20,$05,$AE,$39 * PaletteHandler Object code
        fcb   $06,$01,$0E,$31,$05,$AD,$4B * Img_star_4 NB0 Draw
        fcb   $07,$00,$0E,$A7,$05,$AB,$98 * Img_star_4 NB0 Erase
        fcb   $07,$01,$0E,$57,$05,$AB,$03 * Img_star_3 NB0 Draw
        fcb   $08,$00,$0E,$AC,$05,$AA,$01 * Img_star_3 NB0 Erase
        fcb   $08,$02,$0E,$C1,$06,$BC,$F6 * Img_sonicHand ND0 Draw
        fcb   $0A,$03,$0E,$78,$08,$C4,$8D * Img_sonicHand NB0 Draw
        fcb   $0D,$01,$0E,$8A,$05,$A9,$A3 * Img_sonicHand NB0 Erase
        fcb   $0E,$00,$0E,$F0,$05,$A7,$32 * Img_star_2 NB1 Draw
        fcb   $0E,$01,$0E,$32,$05,$A6,$C3 * Img_star_2 NB1 Erase
        fcb   $0F,$00,$0E,$99,$05,$A7,$D1 * Img_star_2 NB0 Draw
        fcb   $0F,$00,$0E,$DB,$05,$A7,$60 * Img_star_2 NB0 Erase
        fcb   $0F,$01,$0E,$28,$05,$A6,$1E * Img_star_1 NB1 Draw
        fcb   $10,$00,$0E,$64,$05,$A5,$CD * Img_star_1 NB1 Erase
        fcb   $10,$00,$0E,$B3,$05,$A6,$95 * Img_star_1 NB0 Draw
        fcb   $10,$00,$0E,$EF,$05,$A6,$42 * Img_star_1 NB0 Erase
        fcb   $10,$02,$0E,$D0,$07,$D2,$46 * Img_emblemBack08 ND0 Draw
        fcb   $02,$02,$0F,$7E,$06,$B9,$4F * Img_emblemBack07 ND0 Draw
        fcb   $04,$02,$0F,$3C,$06,$B5,$B7 * Img_emblemBack09 ND0 Draw
        fcb   $06,$01,$0F,$5B,$05,$A5,$A9 * Img_emblemBack04 ND0 Draw
        fcb   $07,$02,$0F,$27,$06,$B2,$4A * Img_emblemBack03 ND0 Draw
        fcb   $09,$00,$0F,$74,$05,$A4,$0E * Img_emblemBack06 ND0 Draw
        fcb   $09,$01,$0F,$FD,$06,$AE,$6C * Img_emblemBack05 ND0 Draw
        fcb   $0A,$06,$0F,$B2,$0A,$B8,$99 * Img_tails_5 ND0 Draw
        fcb   $10,$07,$0F,$AA,$0A,$C7,$7F * Img_tails_5 NB0 Draw
        fcb   $07,$02,$10,$69,$07,$CD,$BA * Img_tails_5 NB0 Erase
        fcb   $09,$06,$10,$DD,$0A,$AE,$3E * Img_tails_4 NB0 Draw
        fcb   $0F,$02,$10,$91,$07,$C9,$43 * Img_tails_4 NB0 Erase
        fcb   $01,$06,$11,$E7,$0B,$DE,$10 * Img_tails_3 NB0 Draw
        fcb   $07,$02,$11,$9F,$07,$C5,$02 * Img_tails_3 NB0 Erase
        fcb   $09,$06,$11,$63,$0B,$CF,$BB * Img_tails_2 NB0 Draw
        fcb   $0F,$01,$11,$BE,$06,$AA,$B6 * Img_tails_2 NB0 Erase
        fcb   $10,$05,$11,$7E,$0B,$C3,$57 * Img_tails_1 NB0 Draw
        fcb   $05,$01,$12,$91,$06,$A7,$05 * Img_tails_1 NB0 Erase
        fcb   $06,$01,$12,$5C,$05,$A1,$B1 * Img_tailsHand ND0 Draw
        fcb   $07,$01,$12,$8A,$06,$A3,$99 * Img_tailsHand NB0 Draw
        fcb   $08,$01,$12,$0B,$05,$A2,$53 * Img_tailsHand NB0 Erase
        fcb   $09,$03,$12,$B1,$0B,$B7,$ED * Img_sonic_1 NB0 Draw
        fcb   $0C,$01,$12,$AA,$07,$C0,$97 * Img_sonic_1 NB0 Erase
        fcb   $0D,$05,$12,$F2,$0C,$DE,$10 * Img_sonic_2 NB0 Draw
        fcb   $02,$02,$13,$24,$07,$BC,$68 * Img_sonic_2 NB0 Erase
        fcb   $04,$01,$13,$FF,$07,$B7,$BB * Img_emblemBack02 ND0 Draw
        fcb   $05,$02,$13,$C5,$07,$B4,$1D * Img_emblemBack01 ND0 Draw
        fcb   $07,$04,$13,$CA,$0B,$A9,$52 * Img_sonic_5 ND0 Draw
        fcb   $0B,$05,$13,$45,$0C,$CD,$86 * Img_sonic_5 NB0 Draw
        fcb   $10,$01,$13,$49,$07,$B0,$B9 * Img_sonic_5 NB0 Erase
        fcb   $01,$04,$14,$E5,$0C,$BE,$6F * Img_sonic_3 NB0 Draw
        fcb   $05,$01,$14,$DF,$08,$BF,$38 * Img_sonic_3 NB0 Erase
        fcb   $06,$05,$14,$44,$0C,$AE,$DF * Img_sonic_4 NB0 Draw
        fcb   $0B,$01,$14,$43,$07,$AC,$72 * Img_sonic_4 NB0 Erase
        fcb   $0C,$00,$14,$FB,$06,$A2,$05 * Img_emblemFront07 ND0 Draw
        fcb   $0C,$03,$14,$3A,$08,$BA,$D4 * Img_emblemFront08 ND0 Draw
        fcb   $0F,$02,$14,$6B,$08,$B6,$2B * Img_emblemFront05 ND0 Draw
        fcb   $01,$02,$15,$93,$07,$A8,$3D * Img_emblemFront06 ND0 Draw
        fcb   $03,$02,$15,$51,$07,$A4,$06 * Img_emblemFront03 ND0 Draw
        fcb   $05,$01,$15,$DF,$08,$B1,$66 * Img_emblemFront04 ND0 Draw
        fcb   $06,$01,$15,$62,$05,$A0,$AE * Img_emblemFront01 ND0 Draw
        fcb   $07,$01,$15,$DF,$08,$AE,$51 * Img_emblemFront02 ND0 Draw
        fcb   $08,$03,$15,$E6,$08,$AB,$5B * Psg_TitleScreen0 Sound
        fcb   $0B,$04,$15,$1A,$08,$A5,$53 * TitleScreen Object code
        fcb   $0F,$0E,$15,$28,$01,$8A,$DA * TITLESCR Main Engine code
        fcb   $FF