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
screen_bottom                 equ 200+28 ; in pixel
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
nb_objects                    equ 64 * max 64 total

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
render_free3_mask             equ $80 ; (bit 7) free
 
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
*rsv_image_set                equ 44 ; and 45 ; reference to current image set w
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
ObjID_SEGA equ 1
ObjID_PaletteHandler equ 2
ObjID_TitleScreen equ 3
Object_RAM equ $6730
screen_border_color equ $7289
Vint_runcount equ $72A6
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
Joypads_Held equ $72AA
Dpad_Held equ $72AA
Fire_Held equ $72AB
Joypads_Press equ $72AC
Dpad_Press equ $72AC
Fire_Press equ $72AD
MarkObjGone equ $7317
DisplaySprite_x equ $7319
DisplaySprite equ $731F
AnimateSprite equ $7398
DeleteObject_x equ $745D
DeleteObject equ $7463
ClearObj equ $7525
PlayPCM equ $7D60
PSGInit equ $7DB2
PSGPlayNoRepeat equ $7DC4
PSGStop equ $7DF2
PSGResume equ $7E1B
PSGCancelLoop equ $7E66
PSGGetStatus equ $7E6A
PSGSetMusicVolumeAttenuation equ $7E6E
PSGSilenceChannels equ $7ECD
PSGRestoreVolumes equ $7EE2
PSGSFXPlayLoop equ $7F56
PSGSFXStop equ $7FA2
PSGSFXCancelLoop equ $8018
PSGSFXGetStatus equ $801C
PSGFrame equ $8021
_sendVolume2PSG equ $80DA
PSGSFXFrame equ $812D
_SFXsetLoopPoint equ $818A
Img_star_4 equ $81D6
Img_star_3 equ $81E9
Img_sonicHand equ $81FC
Img_star_2 equ $8212
Img_star_1 equ $822C
Img_emblemBack08 equ $8246
Img_emblemBack07 equ $8255
Img_emblemBack09 equ $8264
Img_emblemBack04 equ $8273
Img_emblemBack03 equ $8282
Img_emblemBack06 equ $8291
Img_emblemBack05 equ $82A0
Img_tails_5 equ $82AF
Img_tails_4 equ $82C5
Img_tails_3 equ $82D8
Img_tails_2 equ $82EB
Img_tails_1 equ $82FE
Img_tailsHand equ $8311
Img_sonic_1 equ $8327
Img_sonic_2 equ $833A
Img_emblemBack02 equ $834D
Img_emblemBack01 equ $835C
Img_sonic_5 equ $836B
Img_sonic_3 equ $8381
Img_sonic_4 equ $8394
Img_emblemFront07 equ $83A7
Img_emblemFront08 equ $83B6
Img_emblemFront05 equ $83C5
Img_emblemFront06 equ $83D4
Img_emblemFront03 equ $83E3
Img_emblemFront04 equ $83F2
Img_emblemFront01 equ $8401
Img_emblemFront02 equ $8410
Ani_smallStar equ $8420
Ani_largeStar equ $8426
Ani_tails equ $8432
Ani_sonic equ $843E
Object_RAM equ $6730
screen_border_color equ $7289
Vint_runcount equ $72A6
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
Joypads_Held equ $72AA
Dpad_Held equ $72AA
Fire_Held equ $72AB
Joypads_Press equ $72AC
Dpad_Press equ $72AC
Fire_Press equ $72AD
MarkObjGone equ $7317
DisplaySprite_x equ $7319
DisplaySprite equ $731F
AnimateSprite equ $7398
DeleteObject_x equ $745D
DeleteObject equ $7463
ClearObj equ $7525
PlayPCM equ $7D60
PSGInit equ $7DB2
PSGPlayNoRepeat equ $7DC4
PSGStop equ $7DF2
PSGResume equ $7E1B
PSGCancelLoop equ $7E66
PSGGetStatus equ $7E6A
PSGSetMusicVolumeAttenuation equ $7E6E
PSGSilenceChannels equ $7ECD
PSGRestoreVolumes equ $7EE2
PSGSFXPlayLoop equ $7F56
PSGSFXStop equ $7FA2
PSGSFXCancelLoop equ $8018
PSGSFXGetStatus equ $801C
PSGFrame equ $8021
_sendVolume2PSG equ $80DA
PSGSFXFrame equ $812D
_SFXsetLoopPoint equ $818A
Img_star_4 equ $81D6
Img_star_3 equ $81E9
Img_sonicHand equ $81FC
Img_star_2 equ $8212
Img_star_1 equ $822C
Img_emblemBack08 equ $8246
Img_emblemBack07 equ $8255
Img_emblemBack09 equ $8264
Img_emblemBack04 equ $8273
Img_emblemBack03 equ $8282
Img_emblemBack06 equ $8291
Img_emblemBack05 equ $82A0
Img_tails_5 equ $82AF
Img_tails_4 equ $82C5
Img_tails_3 equ $82D8
Img_tails_2 equ $82EB
Img_tails_1 equ $82FE
Img_tailsHand equ $8311
Img_sonic_1 equ $8327
Img_sonic_2 equ $833A
Img_emblemBack02 equ $834D
Img_emblemBack01 equ $835C
Img_sonic_5 equ $836B
Img_sonic_3 equ $8381
Img_sonic_4 equ $8394
Img_emblemFront07 equ $83A7
Img_emblemFront08 equ $83B6
Img_emblemFront05 equ $83C5
Img_emblemFront06 equ $83D4
Img_emblemFront03 equ $83E3
Img_emblemFront04 equ $83F2
Img_emblemFront01 equ $8401
Img_emblemFront02 equ $8410
Ani_smallStar equ $8420
Ani_largeStar equ $8426
Ani_tails equ $8432
Ani_sonic equ $843E
Pcm_SEGA equ $8747
Psg_TitleScreen equ $8752
Pal_TitleScreen equ $87C9
Ptr_palette equ $87EA
Black_palette equ $87EC
White_palette equ $880C

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
        fdb   current_game_mode_data+456
gmboot * @globals
        fcb   $05,$33,$00,$41,$0A,$DF,$F6 * Pcm_SEGA0 Sound
        fcb   $08,$1B,$03,$E6,$09,$DF,$74 * Pcm_SEGA1 Sound
        fcb   $03,$01,$05,$1A,$05,$DF,$9A * SEGA Object code
        fcb   $10,$00,$05,$F3,$05,$DF,$83 * PaletteHandler Object code
        fcb   $0D,$01,$06,$16,$05,$DE,$A2 * Img_star_4 NB0 Draw
        fcb   $0E,$00,$06,$8D,$05,$DC,$EF * Img_star_4 NB0 Erase
        fcb   $0E,$01,$06,$41,$05,$DC,$5A * Img_star_3 NB0 Draw
        fcb   $0F,$00,$06,$99,$05,$DB,$58 * Img_star_3 NB0 Erase
        fcb   $0F,$02,$06,$B3,$05,$D9,$29 * Img_sonicHand ND0 Draw
        fcb   $01,$03,$07,$6E,$06,$DD,$45 * Img_sonicHand NB0 Draw
        fcb   $04,$01,$07,$7A,$05,$DA,$FA * Img_sonicHand NB0 Erase
        fcb   $05,$00,$07,$E2,$05,$D4,$E1 * Img_star_2 NB1 Draw
        fcb   $05,$01,$07,$24,$05,$D4,$72 * Img_star_2 NB1 Erase
        fcb   $06,$00,$07,$8F,$05,$D5,$80 * Img_star_2 NB0 Draw
        fcb   $06,$00,$07,$D1,$05,$D5,$0F * Img_star_2 NB0 Erase
        fcb   $06,$01,$07,$1F,$05,$D3,$CD * Img_star_1 NB1 Draw
        fcb   $07,$00,$07,$5A,$05,$D3,$7C * Img_star_1 NB1 Erase
        fcb   $07,$00,$07,$AA,$05,$D4,$44 * Img_star_1 NB0 Draw
        fcb   $07,$00,$07,$E5,$05,$D3,$F1 * Img_star_1 NB0 Erase
        fcb   $07,$02,$07,$C9,$05,$D3,$58 * Img_emblemBack08 ND0 Draw
        fcb   $09,$02,$07,$7F,$05,$CE,$CA * Img_emblemBack07 ND0 Draw
        fcb   $0B,$02,$07,$47,$05,$CB,$30 * Img_emblemBack09 ND0 Draw
        fcb   $0D,$01,$07,$68,$05,$C7,$C1 * Img_emblemBack04 ND0 Draw
        fcb   $0E,$02,$07,$31,$05,$C6,$24 * Img_emblemBack03 ND0 Draw
        fcb   $10,$00,$07,$80,$05,$C2,$44 * Img_emblemBack06 ND0 Draw
        fcb   $10,$02,$07,$0D,$05,$C0,$87 * Img_emblemBack05 ND0 Draw
        fcb   $02,$05,$08,$D8,$07,$D0,$E2 * Img_tails_5 ND0 Draw
        fcb   $07,$07,$08,$E9,$07,$DF,$CE * Img_tails_5 NB0 Draw
        fcb   $0E,$02,$08,$A4,$05,$BC,$CF * Img_tails_5 NB0 Erase
        fcb   $10,$07,$08,$43,$08,$DB,$C4 * Img_tails_4 NB0 Draw
        fcb   $07,$01,$09,$F3,$05,$B8,$58 * Img_tails_4 NB0 Erase
        fcb   $08,$07,$09,$6A,$08,$CD,$83 * Img_tails_3 NB0 Draw
        fcb   $0F,$02,$09,$20,$06,$D7,$F1 * Img_tails_3 NB0 Erase
        fcb   $01,$06,$0A,$10,$07,$C6,$6D * Img_tails_2 NB0 Draw
        fcb   $07,$01,$0A,$6F,$05,$B4,$19 * Img_tails_2 NB0 Erase
        fcb   $08,$05,$0A,$55,$07,$BA,$08 * Img_tails_1 NB0 Draw
        fcb   $0D,$01,$0A,$6A,$05,$B0,$68 * Img_tails_1 NB0 Erase
        fcb   $0E,$01,$0A,$37,$05,$AA,$C2 * Img_tailsHand ND0 Draw
        fcb   $0F,$01,$0A,$64,$05,$AC,$FA * Img_tailsHand NB0 Draw
        fcb   $10,$00,$0A,$EA,$05,$AB,$66 * Img_tailsHand NB0 Erase
        fcb   $10,$04,$0A,$97,$08,$BF,$25 * Img_sonic_1 NB0 Draw
        fcb   $04,$01,$0B,$8C,$06,$D3,$86 * Img_sonic_1 NB0 Erase
        fcb   $05,$05,$0B,$D7,$08,$B0,$8A * Img_sonic_2 NB0 Draw
        fcb   $0A,$01,$0B,$FE,$06,$CF,$57 * Img_sonic_2 NB0 Erase
        fcb   $0B,$02,$0B,$D2,$05,$A9,$BD * Img_emblemBack02 ND0 Draw
        fcb   $0D,$02,$0B,$9E,$05,$A6,$1D * Img_emblemBack01 ND0 Draw
        fcb   $0F,$04,$0B,$AA,$07,$AE,$94 * Img_sonic_5 ND0 Draw
        fcb   $03,$05,$0C,$2D,$09,$BD,$F6 * Img_sonic_5 NB0 Draw
        fcb   $08,$01,$0C,$32,$06,$CA,$AA * Img_sonic_5 NB0 Erase
        fcb   $09,$04,$0C,$DC,$0B,$AF,$90 * Img_sonic_3 NB0 Draw
        fcb   $0D,$01,$0C,$D3,$06,$C6,$63 * Img_sonic_3 NB0 Erase
        fcb   $0E,$05,$0C,$40,$09,$AE,$DF * Img_sonic_4 NB0 Draw
        fcb   $03,$01,$0D,$41,$06,$C1,$FF * Img_sonic_4 NB0 Erase
        fcb   $04,$00,$0D,$FD,$05,$A2,$B7 * Img_emblemFront07 ND0 Draw
        fcb   $04,$03,$0D,$3E,$06,$BD,$CA * Img_emblemFront08 ND0 Draw
        fcb   $07,$02,$0D,$72,$06,$B9,$1F * Img_emblemFront05 ND0 Draw
        fcb   $09,$02,$0D,$91,$06,$B4,$58 * Img_emblemFront06 ND0 Draw
        fcb   $0B,$02,$0D,$4A,$06,$B0,$1F * Img_emblemFront03 ND0 Draw
        fcb   $0D,$01,$0D,$D9,$06,$AC,$17 * Img_emblemFront04 ND0 Draw
        fcb   $0E,$01,$0D,$5D,$05,$A0,$B0 * Img_emblemFront01 ND0 Draw
        fcb   $0F,$01,$0D,$D9,$06,$A9,$00 * Img_emblemFront02 ND0 Draw
        fcb   $10,$03,$0D,$E0,$06,$A6,$08 * Psg_TitleScreen0 Sound
        fcb   $03,$04,$0E,$03,$07,$A5,$40 * TitleScreen Object code
        fcb   $07,$0C,$0E,$1E,$01,$88,$4C * TITLESCR Main Engine code
        fcb   $FF