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

page_bckdraw_routine          equ 0
bckdraw_routine               equ 1
page_draw_routine             equ 3
draw_routine                  equ 4
page_erase_routine            equ 6
erase_routine                 equ 7
erase_nb_cell                 equ 9
image_x1_offset_l             equ 10
image_y1_offset_l             equ 11
image_x_size_l                equ 12
image_y_size_l                equ 13
image_meta_size               equ 14 ; number of bytes for each image reference

* ===========================================================================
* Object Constants
* ===========================================================================

nb_reserved_objects           equ 2
nb_dynamic_objects            equ 18
nb_level_objects              equ 3
nb_objects                    equ 23 * max 64 total

* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------

object_size                   equ 82 ; the size of an object - DEPENDENCY ClearObj routine
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
prev_anim                     equ 6  ; and 7  ; reference to previous animation (Ani_)
anim_frame                    equ 8           ; index of current frame in animation
anim_frame_duration           equ 9           ; number of frames for each image in animation, range: 00-7F (0-127), 0 means display only during one frame
mapping_frame                 equ 10 ; and 11 ;reference to current image (Img_) (0000 if no image)
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
rsv_render_erasesprite_mask   equ $02 ; (bit 1) if a sprite need to be cleared on screen - DEPENDENCY adapt CSR_SetDrawTrue routine
rsv_render_displaysprite_mask equ $04 ; (bit 2) if a sprite need to be rendered on screen
rsv_render_outofrange_mask    equ $08 ; (bit 3) if a sprite is out of range for full rendering in screen

rsv_prev_anim                 equ 42 ; and 43 ; reference to previous animation (Ani_) w
rsv_curr_mapping_frame        equ 44 ; and 45 ; reference to current image regarding mirror flags (0000 if no image) w
rsv_xy1_pixel                 equ 46          ;
rsv_x1_pixel                  equ 46          ; x+x_offset-(x_size/2) screen coordinate
rsv_y1_pixel                  equ 47          ; y+y_offset-(y_size/2) screen coordinate, must follow rsv_x1_pixel
rsv_xy2_pixel                 equ 48          ;
rsv_x2_pixel                  equ 48          ; x+x_offset+(x_size/2) screen coordinate
rsv_y2_pixel                  equ 49          ; y+y_offset+(y_size/2) screen coordinate, must follow rsv_x2_pixel

* ---------------------------------------------------------------------------
* reserved variables (engine) - buffer specific

rsv_buffer_0                  equ 50 ; Start index of buffer 0 variables
rsv_priority_0                equ 50 ; internal value that hold priority in video buffer 0
rsv_priority_prev_obj_0       equ 51 ; and 52 ; previous object (OST address) in display priority list for video buffer 0 (0000 if none) w
rsv_priority_next_obj_0       equ 53 ; and 54 ; next object (OST address) in display priority list for video buffer 0 (0000 if none) w
rsv_prev_mapping_frame_0      equ 55 ; and 56 ; reference to previous image in video buffer 0 (Img_) (0000 if no image) w
rsv_bgdata_0                  equ 57 ; and 58 ; address of background data in screen 0 w
rsv_prev_xy_pixel_0           equ 59 ;
rsv_prev_x_pixel_0            equ 59 ; previous x screen coordinate b
rsv_prev_y_pixel_0            equ 60 ; previous y screen coordinate b, must follow x_pixel
rsv_prev_xy1_pixel_0          equ 61 ;
rsv_prev_x1_pixel_0           equ 61 ; previous x+x_offset-(x_size/2) screen coordinate b
rsv_prev_y1_pixel_0           equ 62 ; previous y+y_offset-(y_size/2) screen coordinate b, must follow x1_pixel
rsv_prev_xy2_pixel_0          equ 63 ;
rsv_prev_x2_pixel_0           equ 63 ; previous x+x_offset+(x_size/2) screen coordinate b
rsv_prev_y2_pixel_0           equ 64 ; previous y+y_offset+(y_size/2) screen coordinate b, must follow x2_pixel
rsv_onscreen_0                equ 65 ; has been rendered on screen buffer 0

rsv_buffer_1                  equ 66 ; Start index of buffer 1 variables
rsv_priority_1                equ 66 ; internal value that hold priority in video buffer 1
rsv_priority_prev_obj_1       equ 67 ; and 68 ; previous object (OST address) in display priority list for video buffer 1 (0000 if none) w
rsv_priority_next_obj_1       equ 69 ; and 70 ; next object (OST address) in display priority list for video buffer 1 (0000 if none) w
rsv_prev_mapping_frame_1      equ 71 ; and 72 ; reference to previous image in video buffer 1 (Img_) (0000 if no image) w
rsv_bgdata_1                  equ 73 ; and 74 ; address of background data in screen 1 w
rsv_prev_xy_pixel_1           equ 75 ;
rsv_prev_x_pixel_1            equ 75 ; previous x screen coordinate b
rsv_prev_y_pixel_1            equ 76 ; previous y screen coordinate b, must follow x_pixel
rsv_prev_xy1_pixel_1          equ 77 ;
rsv_prev_x1_pixel_1           equ 77 ; previous x+x_size screen coordinate b
rsv_prev_y1_pixel_1           equ 78 ; previous y+y_size screen coordinate b, must follow x_pixel
rsv_prev_xy2_pixel_1          equ 79 ;
rsv_prev_x2_pixel_1           equ 79 ; previous x+x_size screen coordinate b
rsv_prev_y2_pixel_1           equ 80 ; previous y+y_size screen coordinate b, must follow x_pixel
rsv_onscreen_1                equ 81 ; has been rendered on screen buffer 1

buf_priority                  equ 0  ; offset for each rsv_buffer variables
buf_priority_prev_obj         equ 1  ;
buf_priority_next_obj         equ 3  ;
buf_prev_mapping_frame        equ 5  ;
buf_bgdata                    equ 7  ;
buf_prev_xy_pixel             equ 9  ;
buf_prev_x_pixel              equ 9  ;
buf_prev_y_pixel              equ 10 ;
buf_prev_xy1_pixel            equ 11 ;
buf_prev_x1_pixel             equ 11 ;
buf_prev_y1_pixel             equ 12 ;
buf_prev_xy2_pixel            equ 13 ;
buf_prev_x2_pixel             equ 13 ;
buf_prev_y2_pixel             equ 14 ;
buf_onscreen                  equ 15 ;

(include)GLOBALS
* Generated Code

GameModeLoader equ $414F
current_game_mode_data equ $41C7
ObjID_PaletteHandler equ 1
ObjID_TitleScreen equ 2
Object_RAM equ $65C5
screen_border_color equ $6D3C
Vint_runcount equ $6D59
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
Dpad_Held equ $6D5B
Fire_Held equ $6D5C
Dpad_Press equ $6D5D
Fire_Press equ $6D5E
MarkObjGone equ $6DBF
DisplaySprite_x equ $6DC1
DisplaySprite equ $6DC7
AnimateSprite equ $6E40
DeleteObject_x equ $6F01
DeleteObject equ $6F07
ClearObj equ $6FC9
Img_star_4 equ $77CB
Img_star_3 equ $77D9
Img_sonicHand equ $77E7
Img_star_2 equ $77F5
Img_star_1 equ $7803
Img_emblemBack08 equ $7811
Img_emblemBack07 equ $781F
Img_emblemBack09 equ $782D
Img_emblemBack04 equ $783B
Img_emblemBack03 equ $7849
Img_emblemBack06 equ $7857
Img_emblemBack05 equ $7865
Img_tails_5 equ $7873
Img_tails_4 equ $7881
Img_tails_3 equ $788F
Img_tails_2 equ $789D
Img_tails_1 equ $78AB
Img_tailsHand equ $78B9
Img_sonic_1 equ $78C7
Img_sonic_2 equ $78D5
Img_emblemBack02 equ $78E3
Img_emblemBack01 equ $78F1
Img_sonic_5 equ $78FF
Img_sonic_3 equ $790D
Img_sonic_4 equ $791B
Img_emblemFront07 equ $7929
Img_emblemFront08 equ $7937
Img_emblemFront05 equ $7945
Img_emblemFront06 equ $7953
Img_emblemFront03 equ $7961
Img_emblemFront04 equ $796F
Img_emblemFront01 equ $797D
Img_emblemFront02 equ $798B
Ani_smallStar equ $799A
Ani_largeStar equ $79A0
Ani_tails equ $79AC
Ani_sonic equ $79B8
Object_RAM equ $65C5
screen_border_color equ $6D3C
Vint_runcount equ $6D59
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
Dpad_Held equ $6D5B
Fire_Held equ $6D5C
Dpad_Press equ $6D5D
Fire_Press equ $6D5E
MarkObjGone equ $6DBF
DisplaySprite_x equ $6DC1
DisplaySprite equ $6DC7
AnimateSprite equ $6E40
DeleteObject_x equ $6F01
DeleteObject equ $6F07
ClearObj equ $6FC9
Img_star_4 equ $77CB
Img_star_3 equ $77D9
Img_sonicHand equ $77E7
Img_star_2 equ $77F5
Img_star_1 equ $7803
Img_emblemBack08 equ $7811
Img_emblemBack07 equ $781F
Img_emblemBack09 equ $782D
Img_emblemBack04 equ $783B
Img_emblemBack03 equ $7849
Img_emblemBack06 equ $7857
Img_emblemBack05 equ $7865
Img_tails_5 equ $7873
Img_tails_4 equ $7881
Img_tails_3 equ $788F
Img_tails_2 equ $789D
Img_tails_1 equ $78AB
Img_tailsHand equ $78B9
Img_sonic_1 equ $78C7
Img_sonic_2 equ $78D5
Img_emblemBack02 equ $78E3
Img_emblemBack01 equ $78F1
Img_sonic_5 equ $78FF
Img_sonic_3 equ $790D
Img_sonic_4 equ $791B
Img_emblemFront07 equ $7929
Img_emblemFront08 equ $7937
Img_emblemFront05 equ $7945
Img_emblemFront06 equ $7953
Img_emblemFront03 equ $7961
Img_emblemFront04 equ $796F
Img_emblemFront01 equ $797D
Img_emblemFront02 equ $798B
Ani_smallStar equ $799A
Ani_largeStar equ $79A0
Ani_tails equ $79AC
Ani_sonic equ $79B8
Pal_TitleScreen equ $7D32
Ptr_palette equ $7D53
Black_palette equ $7D55
White_palette equ $7D75

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
        fdb   current_game_mode_data+372
gmboot * @globals
        fcb   $05,$01,$00,$04,$05,$DF,$F4 * PaletteHandler Object code
        fcb   $0E,$01,$00,$F0,$05,$DF,$5A * Img_star_4 BckDraw
        fcb   $0F,$01,$00,$63,$05,$DD,$A9 * Img_star_4 Erase
        fcb   $10,$01,$00,$13,$05,$DD,$18 * Img_star_3 BckDraw
        fcb   $01,$00,$01,$68,$05,$DC,$18 * Img_star_3 Erase
        fcb   $01,$03,$01,$21,$06,$DF,$38 * Img_sonicHand BckDraw
        fcb   $04,$01,$01,$2E,$05,$DB,$BE * Img_sonicHand Erase
        fcb   $05,$00,$01,$94,$05,$D9,$F2 * Img_star_2 BckDraw
        fcb   $05,$00,$01,$D2,$05,$D9,$83 * Img_star_2 Erase
        fcb   $05,$01,$01,$1D,$05,$D9,$59 * Img_star_1 BckDraw
        fcb   $06,$00,$01,$53,$05,$D9,$08 * Img_star_1 Erase
        fcb   $06,$02,$01,$4A,$05,$D8,$E8 * Img_emblemBack08 Draw
        fcb   $08,$02,$01,$1E,$05,$D4,$C9 * Img_emblemBack07 Draw
        fcb   $0A,$01,$01,$EB,$05,$D1,$3E * Img_emblemBack09 Draw
        fcb   $0B,$02,$01,$0B,$05,$CD,$C7 * Img_emblemBack04 Draw
        fcb   $0D,$01,$01,$D0,$05,$CC,$31 * Img_emblemBack03 Draw
        fcb   $0E,$01,$01,$27,$05,$C8,$9A * Img_emblemBack06 Draw
        fcb   $0F,$01,$01,$BC,$05,$C6,$D0 * Img_emblemBack05 Draw
        fcb   $10,$07,$01,$CE,$07,$D7,$E5 * Img_tails_5 BckDraw
        fcb   $07,$02,$02,$82,$05,$C3,$03 * Img_tails_5 Erase
        fcb   $09,$07,$02,$1C,$07,$C8,$FC * Img_tails_4 BckDraw
        fcb   $10,$01,$02,$C2,$05,$BE,$8F * Img_tails_4 Erase
        fcb   $01,$07,$03,$32,$07,$BA,$BF * Img_tails_3 BckDraw
        fcb   $08,$01,$03,$E7,$05,$BA,$52 * Img_tails_3 Erase
        fcb   $09,$06,$03,$D7,$07,$AC,$63 * Img_tails_2 BckDraw
        fcb   $0F,$02,$03,$33,$05,$B5,$EB * Img_tails_2 Erase
        fcb   $01,$05,$04,$19,$06,$D9,$E5 * Img_tails_1 BckDraw
        fcb   $06,$01,$04,$29,$05,$B2,$3E * Img_tails_1 Erase
        fcb   $07,$01,$04,$51,$05,$AE,$D4 * Img_tailsHand BckDraw
        fcb   $08,$00,$04,$D2,$05,$AD,$42 * Img_tailsHand Erase
        fcb   $08,$04,$04,$7B,$08,$DD,$C4 * Img_sonic_1 BckDraw
        fcb   $0C,$01,$04,$6C,$06,$CE,$73 * Img_sonic_1 Erase
        fcb   $0D,$05,$04,$B5,$08,$CF,$2B * Img_sonic_2 BckDraw
        fcb   $02,$01,$05,$D9,$06,$CA,$48 * Img_sonic_2 Erase
        fcb   $03,$02,$05,$B8,$05,$AC,$A4 * Img_emblemBack02 Draw
        fcb   $05,$02,$05,$8B,$05,$A9,$10 * Img_emblemBack01 Draw
        fcb   $07,$05,$05,$0A,$08,$BE,$A3 * Img_sonic_5 BckDraw
        fcb   $0C,$01,$05,$0B,$06,$C5,$9F * Img_sonic_5 Erase
        fcb   $0D,$04,$05,$AF,$08,$AF,$8E * Img_sonic_3 BckDraw
        fcb   $01,$01,$06,$A2,$06,$C1,$5C * Img_sonic_3 Erase
        fcb   $02,$05,$06,$0C,$09,$AE,$DD * Img_sonic_4 BckDraw
        fcb   $07,$01,$06,$08,$06,$BC,$FC * Img_sonic_4 Erase
        fcb   $08,$00,$06,$CD,$05,$A5,$A1 * Img_emblemFront07 Draw
        fcb   $08,$03,$06,$1E,$06,$B8,$CB * Img_emblemFront08 Draw
        fcb   $0B,$02,$06,$4D,$06,$B4,$2D * Img_emblemFront05 Draw
        fcb   $0D,$02,$06,$67,$06,$AF,$9E * Img_emblemFront06 Draw
        fcb   $0F,$02,$06,$26,$06,$AB,$6E * Img_emblemFront03 Draw
        fcb   $01,$01,$07,$C0,$05,$A3,$99 * Img_emblemFront04 Draw
        fcb   $02,$01,$07,$4E,$05,$A0,$AC * Img_emblemFront01 Draw
        fcb   $03,$01,$07,$D8,$06,$A7,$7B * Img_emblemFront02 Draw
        fcb   $04,$03,$07,$B5,$06,$A4,$A3 * TitleScreen Object code
        fcb   $07,$09,$07,$9C,$01,$7D,$B5 * TITLESCR Main Engine code
        fcb   $FF