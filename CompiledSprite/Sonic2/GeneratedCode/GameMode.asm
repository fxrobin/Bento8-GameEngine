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
* Chargement de la page 3 a l'ecran
* Chargement de la page 2 en zone 0000-3FFF
* Chargement de la page 0a en zone 4000-5FFF
* Copie en page 0a du moteur Game Mode et des donnees du mode a charger
* Execution du moteur Game Mode en page 0a
* Chargement des donnees du Mode depuis la disquette vers 0000-3FFF (buffer)
* Decompression et ecriture de la RAM en A000-DFFF (pages 5-31)
* Chargement du programme principal du nouveau Mode en page 1 a 6000
* (effectue en dernier car ecrase les registres moniteurs necessaires a la
* gestion disque)
* Re-initialisation du pointeur S a 9FFF
* Branchement en 6000
*
********************************************************************************

(main)GAMEMODE
        INCLUD CONSTANT
        INCLUD GLOBALS
        org $A000

* ==============================================================================
* GameModeEngineLoader
* ==============================================================================

GameModeEngineLoader

* Chargement de la page 3 a l'ecran
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
        
* Chargement de la page 2 en zone 0000-3FFF
***********************************************************
        ldb   #$62                     * changement page 2
        stb   $E7E6                    * visible dans l'espace cartouche
        
* Chargement de la page 0a en zone 4000-5FFF
***********************************************************
        ldb   $E7C3                    * charge l'id de la demi-Page 0 en espace ecran
        andb  #$FE                     * positionne bit0=0 pour page 0 RAMA
        stb   $E7C3                    * dans l'espace ecran

* Copie en page 0a des donnees du mode a charger (adaptation du code COPY8k de __sam__)
* les groupes de 7 octets sont recopiees a l'envers, on termine par l'ecriture
* en page 1 des donnees 0000-0100 puis derniere ligne 7x$FF
************************************************************            
        sts   CopyCode3+2              ; sauve s
        lda   current_game_mode
        ldx   GameModesArray
        ldu   a,x++                    ; u=source
        lds   a,x++                    ; s=longueur des donnees
        ldy   a,x                      ; adresse de fin de lecture de la source
        sty   CopyData2+2              ; met a jour test de fin
        leas  current_game_mode_data,s ; s=dest
CopyData1
        pulu  d,x,y,dp                 ; on lit 7 octets
        pshs  d,x,y,dp                 ; on ecrit 7 octets
CopyData2
        cmpu  #0                       ; fin ?
        bne   CopyData1                ; non => boucle 5 + 3 cycles

* Copie en page 0a du code Game Mode Engine
* les groupes de 7 octets sont recopiees a l'envers, le builder va inverser
* les donnees a l'avance on gagne un leas dans la boucle.
* le builder ajoute des donnees pour que le code soit un multiple de 7 octets
************************************************************     
        ldu   #GameModeEngineBin       * source
CopyCode1
        pulu  d,x,y,dp                 ; on lit 7 octets
        pshs  d,x,y,dp                 ; on ecrit 7 octets
CopyCode2
        cmps  #$4000                   ; fin ?
        bne   CopyCode1                ; non => boucle 5 + 3 cycles
CopyCode3
        lds   #0                       ; recup s d'entree
        puls  dp
        
* Execution du Game Mode Engine en page 0a
************************************************************         
        jmp   $4000      

* ==============================================================================
* GameModeEngine
* ==============================================================================
GameModeEngineBin
        INCLUD GMENGINE
        INCLUD GMEDATA


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
image_y_size                  equ 15 ; must follow x_size
image_meta_size               equ 16 ; number of bytes for each image reference

* ===========================================================================
* Object Constants
* ===========================================================================

nb_reserved_objects           equ 2
nb_dynamic_objects            equ 43
nb_level_objects              equ 3
nb_objects                    equ (nb_reserved_objects+nb_dynamic_objects)+nb_level_objects

* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------

object_size                   equ 80 ; the size of an object
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
rsv_curr_mapping_frame        equ 44 ; and 45 ; reference to current image regarding mirror flags (0000 if no image) w
rsv_ptr_sub_object_erase      equ 46 ; and 47 ; point to the first entry of objects under this one (that have erase flag)
rsv_ptr_sub_object_draw       equ 48 ; and 49 ; point to the first entry of objects under this one (that have draw flag)
rsv_x2_pixel                  equ 50          ; x+x_size screen coordinate
rsv_y2_pixel                  equ 51          ; y+y_size screen coordinate, must follow rsv_x2_pixel

* ---------------------------------------------------------------------------
* reserved variables (engine) - buffer specific

rsv_buffer_0                  equ 52 ; Start index of buffer 0 variables
rsv_priority_0                equ 52 ; internal value that hold priority in video buffer 0
rsv_priority_prev_obj_0       equ 53 ; and 54 ; previous object (OST address) in display priority list for video buffer 0 (0000 if none) w
rsv_priority_next_obj_0       equ 55 ; and 56 ; next object (OST address) in display priority list for video buffer 0 (0000 if none) w
rsv_prev_mapping_frame_0      equ 57 ; and 58 ; reference to previous image in video buffer 0 (Img_) (0000 if no image) w
rsv_bgdata_0                  equ 59 ; and 60 ; address of background data in screen 0 w
rsv_prev_x_pixel_0            equ 61 ; previous x screen coordinate b
rsv_prev_y_pixel_0            equ 62 ; previous y screen coordinate b, must follow x_pixel
rsv_prev_x2_pixel_0           equ 63 ; previous x+x_size screen coordinate b
rsv_prev_y2_pixel_0           equ 64 ; previous y+y_size screen coordinate b, must follow x_pixel
rsv_onscreen_0                equ 65 ; has been rendered on screen buffer 0

rsv_buffer_1                  equ 66 ; Start index of buffer 1 variables
rsv_priority_1                equ 66 ; internal value that hold priority in video buffer 1
rsv_priority_prev_obj_1       equ 67 ; and 68 ; previous object (OST address) in display priority list for video buffer 1 (0000 if none) w
rsv_priority_next_obj_1       equ 69 ; and 70 ; next object (OST address) in display priority list for video buffer 1 (0000 if none) w
rsv_prev_mapping_frame_1      equ 71 ; and 72 ; reference to previous image in video buffer 1 (Img_) (0000 if no image) w
rsv_bgdata_1                  equ 73 ; and 74 ; address of background data in screen 1 w
rsv_prev_x_pixel_1            equ 75 ; previous x screen coordinate b
rsv_prev_y_pixel_1            equ 76 ; previous y screen coordinate b, must follow x_pixel
rsv_prev_x2_pixel_1           equ 77 ; previous x+x_size screen coordinate b
rsv_prev_y2_pixel_1           equ 78 ; previous y+y_size screen coordinate b, must follow x_pixel
rsv_onscreen_1                equ 79 ; has been rendered on screen buffer 1

buf_priority                  equ 0  ; offset for each rsv_buffer variables
buf_priority_prev_obj         equ 1  ;
buf_priority_next_obj         equ 3  ;
buf_prev_mapping_frame        equ 5  ;
buf_bgdata                    equ 7  ;
buf_prev_x_pixel              equ 9  ;
buf_prev_y_pixel              equ 10 ;
buf_prev_x2_pixel             equ 11 ;
buf_prev_y2_pixel             equ 12 ;
buf_onscreen                  equ 13 ;

(include)GLOBALS
* Generated Code
current_game_mode_data equ $41B2


(include)GMENGINE

        fcb   $34
        fcb   $7F
        fcb   $1F
        fcb   $50
        fcb   $1F
        fcb   $8B
        fcb   $31
        fcb   $8D
        fcb   $00
        fcb   $A9
        fcb   $5F
        fcb   $D7
        fcb   $8D
        fcb   $4F
        fcb   $34
        fcb   $06
        fcb   $C5
        fcb   $0F
        fcb   $26
        fcb   $03
        fcb   $8E
        fcb   $00
        fcb   $01
        fcb   $C6
        fcb   $04
        fcb   $8D
        fcb   $6D
        fcb   $E7
        fcb   $A0
        fcb   $53
        fcb   $69
        fcb   $E4
        fcb   $49
        fcb   $5C
        fcb   $2B
        fcb   $FA
        fcb   $E6
        fcb   $E4
        fcb   $AF
        fcb   $A1
        fcb   $30
        fcb   $8B
        fcb   $35
        fcb   $06
        fcb   $5C
        fcb   $C1
        fcb   $34
        fcb   $26
        fcb   $DC
        fcb   $10
        fcb   $AE
        fcb   $66
        fcb   $C6
        fcb   $01
        fcb   $8D
        fcb   $50
        fcb   $26
        fcb   $15
        fcb   $D7
        fcb   $45
        fcb   $8C
        fcb   $0C
        fcb   $45
        fcb   $5C
        fcb   $8D
        fcb   $46
        fcb   $27
        fcb   $F9
        fcb   $C6
        fcb   $00
        fcb   $C1
        fcb   $10
        fcb   $27
        fcb   $37
        fcb   $25
        fcb   $0F
        fcb   $5A
        fcb   $8D
        fcb   $39
        fcb   $1F
        fcb   $01
        fcb   $A6
        fcb   $C2
        fcb   $A7
        fcb   $A2
        fcb   $30
        fcb   $1F
        fcb   $26
        fcb   $F8
        fcb   $20
        fcb   $D9
        fcb   $8D
        fcb   $44
        fcb   $34
        fcb   $06
        fcb   $30
        fcb   $8C
        fcb   $4B
        fcb   $10
        fcb   $83
        fcb   $00
        fcb   $03
        fcb   $24
        fcb   $01
        fcb   $3A
        fcb   $8D
        fcb   $1B
        fcb   $EB
        fcb   $03
        fcb   $8D
        fcb   $32
        fcb   $DD
        fcb   $77
        fcb   $35
        fcb   $10
        fcb   $31
        fcb   $3F
        fcb   $A6
        fcb   $A9
        fcb   $12
        fcb   $34
        fcb   $A7
        fcb   $A4
        fcb   $30
        fcb   $1F
        fcb   $26
        fcb   $F4
        fcb   $20
        fcb   $B3
        fcb   $10
        fcb   $AF
        fcb   $66
        fcb   $35
        fcb   $FF
        fcb   $E6
        fcb   $84
        fcb   $6F
        fcb   $E2
        fcb   $6F
        fcb   $E2
        fcb   $86
        fcb   $12
        fcb   $20
        fcb   $09
        fcb   $A6
        fcb   $C2
        fcb   $46
        fcb   $27
        fcb   $FB
        fcb   $69
        fcb   $61
        fcb   $69
        fcb   $E4
        fcb   $5A
        fcb   $2A
        fcb   $F6
        fcb   $97
        fcb   $8D
        fcb   $EC
        fcb   $E1
        fcb   $39
        fcb   $30
        fcb   $8D
        fcb   $00
        fcb   $0E
        fcb   $3A
        fcb   $58
        fcb   $3A
        fcb   $8D
        fcb   $DC
        fcb   $E3
        fcb   $01
        fcb   $39
        fcb   $04
        fcb   $02
        fcb   $04
        fcb   $10
        fcb   $30
        fcb   $20
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $CE
        fcb   $41
        fcb   $B2
        fcb   $34
        fcb   $40
        fcb   $86
        fcb   $60
        fcb   $1F
        fcb   $8B
        fcb   $E6
        fcb   $C0
        fcb   $1D
        fcb   $84
        fcb   $01
        fcb   $C4
        fcb   $80
        fcb   $97
        fcb   $49
        fcb   $86
        fcb   $00
        fcb   $DD
        fcb   $4A
        fcb   $C6
        fcb   $00
        fcb   $DD
        fcb   $4F
        fcb   $EC
        fcb   $C1
        fcb   $2A
        fcb   $02
        fcb   $0E
        fcb   $00
        fcb   $97
        fcb   $4C
        fcb   $F7
        fcb   $41
        fcb   $99
        fcb   $37
        fcb   $26
        fcb   $B7
        fcb   $41
        fcb   $9F
        fcb   $F7
        fcb   $41
        fcb   $A2
        fcb   $34
        fcb   $40
        fcb   $86
        fcb   $02
        fcb   $97
        fcb   $48
        fcb   $BD
        fcb   $E8
        fcb   $2A
        fcb   $0C
        fcb   $4C
        fcb   $96
        fcb   $4C
        fcb   $81
        fcb   $10
        fcb   $23
        fcb   $06
        fcb   $86
        fcb   $01
        fcb   $97
        fcb   $4C
        fcb   $0C
        fcb   $4B
        fcb   $0C
        fcb   $4F
        fcb   $DE
        fcb   $4F
        fcb   $11
        fcb   $83
        fcb   $00
        fcb   $00
        fcb   $23
        fcb   $E5
        fcb   $33
        fcb   $C9
        fcb   $FF
        fcb   $00
        fcb   $86
        fcb   $00
        fcb   $B7
        fcb   $E7
        fcb   $E5
        fcb   $BD
        fcb   $40
        fcb   $00
        fcb   $35
        fcb   $40
        fcb   $20
        fcb   $A7
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00

(include)GMEDATA
* Generated Code

gm_TITLESCR equ $00
current_game_mode
        fcb   gm_TITLESCR
gm_data_TITLESCR
        fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF
gm_dataEnd
GameModesArray
        fdb   gm_data_TITLESCR,gm_dataEnd-gm_data_TITLESCR