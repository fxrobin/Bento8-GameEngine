********************************************************************************
* Game Engine (TO8 Thomson) - Benoit Rousseau 07/10/2020
* ------------------------------------------------------------------------------
*
*
********************************************************************************

(main)MAIN
        INCLUD CONSTANT
        org   $6100

        jsr   LoadAct
        * jsr   PSGInit

InitIRQ        
        ldd   #_IRQ                                   ; map IRQ routine                
        std   $6027
        ldd   #$09C4                                  ; 09C4 for 50hz 0823 for 60hz
        std   $E7C6                                   ; timer to 20ms      

* ==============================================================================
* Main Loop
* ==============================================================================
LevelMainLoop
        jsr   WaitVBL      
        jsr   ReadJoypads
        jsr   RunObjects
        jsr   CheckSpritesRefresh
        jsr   EraseSprites
        jsr   UnsetDisplayPriority
        jsr   DrawSprites        
        bra   LevelMainLoop
        
* ==============================================================================
* IRQ
* ==============================================================================       
_IRQ
        lda   $E7E5
        sta   _IRQ_end+1                              ; backup data page
        jsr   PSGFrame
        * jsr   PSGSFXFrame
_IRQ_end        
        lda   #$00
        sta   $E7E5                                   ; restore data page
        jmp   $E830  

* ==============================================================================
* Global Data
*
* Naming convention
* -----------------
* - underscore-separated names
* - first letter of each word in upper case, the others in lower case
*
* Templates
* ---------
* - Glb_*        : global variable
* - Tbl_*        : data table
* - Lst_*        : list is a data table with variable size, first word is the adress of last element in list, next words are data
* - Obj_*        : address of an object in Object_RAM
*
* - *_Object_RAM : sub group of objects
* - *_end        : data end label
*
* ==============================================================================

* ---------------------------------------------------------------------------
* Display
* ---------------------------------------------------------------------------
                             
Glb_Cur_Wrk_Screen_Id         fcb   $00   ; screen buffer set to write operations (0 or 1)
Glb_Camera_X_Pos              fdb   $0000 ; camera x position in palyfield coordinates
Glb_Camera_Y_Pos              fdb   $0000 ; camera y position in palyfield coordinates
Glb_Sprite_Screen_Pos_Part1   fdb   $0000 *@globals ; start address for rendering of current sprite PartA     
Glb_Sprite_Screen_Pos_Part2   fdb   $0000 *@globals ; start address for rendering of current sprite PartB (Must follow PartA)

* ---------------------------------------------------------------------------
* Background Backup Cells - BBC
* ---------------------------------------------------------------------------

* ----- Cell variables
nb_cells                      equ   0
cell_start                    equ   1
cell_end                      equ   3
next_entry                    equ   5
entry_size                    equ   7

* ----- Cells List
nb_free_cells                 equ   130
cell_size                     equ   64     ; 64 bytes x 130 from $3F80 to $6000 (buffer limit is $3F40 to $6000)
cell_start_adr                equ   $6000

Lst_FreeCellFirstEntry_0      fdb   Lst_FreeCell_0 ; Pointer to first entry in free cell list (buffer 0)
Lst_FreeCell_0                fcb   nb_free_cells ; init of first free cell
                              fdb   cell_start_adr-cell_size*nb_free_cells
                              fdb   cell_start_adr
                              fdb   $0000
                              rmb   (entry_size*(nb_free_cells/2))-1,0 ; (buffer 1)
                              
Lst_FreeCellFirstEntry_1      fdb   Lst_FreeCell_1 ; Pointer to first entry in free cell list (buffer 1)
Lst_FreeCell_1                fcb   nb_free_cells ; init of first free cell
                              fdb   cell_start_adr-cell_size*nb_free_cells
                              fdb   cell_start_adr
                              fdb   $0000
                              rmb   (entry_size*(nb_free_cells/2))-1,0 ; (buffer 1)
* ---------------------------------------------------------------------------
* Display Priority Structure - DPS
* ---------------------------------------------------------------------------

DPS_buffer_0
Tbl_Priority_First_Entry_0    rmb   2+(nb_priority_levels*2),0 ; first address of object in linked list for each priority index (buffer 0) index 0 unused
Tbl_Priority_Last_Entry_0     rmb   2+(nb_priority_levels*2),0 ; last address of object in linked list for each priority index (buffer 0) index 0 unused
Lst_Priority_Unset_0          fdb   Lst_Priority_Unset_0+2     ; pointer to end of list (initialized to its own address+2) (buffer 0)
                              rmb   (nb_objects*2),0           ; objects to delete from priority list
DPS_buffer_1                              
Tbl_Priority_First_Entry_1    rmb   2+(nb_priority_levels*2),0 ; first address of object in linked list for each priority index (buffer 1) index 0 unused
Tbl_Priority_Last_Entry_1     rmb   2+(nb_priority_levels*2),0 ; last address of object in linked list for each priority index (buffer 1) index 0 unused
Lst_Priority_Unset_1          fdb   Lst_Priority_Unset_1+2     ; pointer to end of list (initialized to its own address+2) (buffer 1)
                              rmb   (nb_objects*2),0           ; objects to delete from priority list
                              
buf_Tbl_Priority_First_Entry  equ   0                                                            
buf_Tbl_Priority_Last_Entry   equ   Tbl_Priority_Last_Entry_0-DPS_buffer_0          
buf_Lst_Priority_Unset        equ   Lst_Priority_Unset_0-DPS_buffer_0

* ---------------------------------------------------------------------------
* Sub Priority Objects List - SOL
* ---------------------------------------------------------------------------

Tbl_Sub_Object_Erase          rmb   nb_objects*2,0             ; entries of objects that have erase flag in the order back to front
Tbl_Sub_Object_Draw           rmb   nb_objects*2,0             ; entries of objects that have draw flag in the order back to front

* ---------------------------------------------------------------------------
* Object Status Table - OST
* ---------------------------------------------------------------------------
        
Object_RAM *@globals
Reserved_Object_RAM
Obj_MainCharacter             fdb   $0203
                              rmb   object_size-2,0
Obj_Sidekick                  rmb   object_size,0
Reserved_Object_RAM_End

Dynamic_Object_RAM            rmb   nb_dynamic_objects*object_size,0
Dynamic_Object_RAM_End

LevelOnly_Object_RAM                              * faire comme pour Dynamic_Object_RAM
Obj_TailsTails                rmb   object_size,0 * Positionnement et nommage a mettre dans objet Tails
Obj_SonicDust                 rmb   object_size,0 * Positionnement et nommage a mettre dans objet Tails
Obj_TailsDust                 rmb   object_size,0 * Positionnement et nommage a mettre dans objet Tails
LevelOnly_Object_RAM_End
Object_RAM_End                fdb *

* ---------------------------------------------------------------------------
* Lifecycle
* ---------------------------------------------------------------------------

Glb_MainCharacter_Is_Dead     rmb   $1,0

* ==============================================================================
* Routines
* ==============================================================================
        * a rendre dynamique a partir du properties game mode
        INCLUD WAITVBL
        INCLUD READJPDS
        INCLUD RUNOBJTS
        INCLUD MRKOBJGN        
        INCLUD DISPLSPR        
        INCLUD ANIMSPR
        INCLUD OBJMOVE
        INCLUD OBJLOAD
        INCLUD DELETOBJ
        INCLUD CLEAROBJ
        INCLUD CHECKSPR
        INCLUD ERASESPR
        INCLUD UNSETDSP
        INCLUD DRAWSPR
        INCLUD BGBALLOC
        INCLUD BGBFREE 
        INCLUD CLRCARTM  
        INCLUD UPDTPAL        
        INCLUD PLAYPCM * A rendre dynamique 
        INCLUD PSGLIB  * A rendre dynamique   
        
* ==============================================================================
* Level Specific Generated Data
* IMG and ANI should be in first position
* ==============================================================================
        INCLUD IMAGEIDX
        INCLUD ANIMSCPT
        INCLUD OBJINDEX
        INCLUD SOUNDIDX * A rendre dynamique
        INCLUD LOADACT
                                                                 

        INCLUD PALETTE


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

(include)WAITVBL
********************************************************************************
* Attente VBL
* Alternance de la page 2 et 3 entre affichage et espace cartouche
* Alternance de la RAMA et RAM B dans l'espace ecran
* ------------------------------------------------------------------------------
*
* Page Affichee par l'automate Video
* ----------------------------------
*   $E7DD determine la page affichee a l'ecran
*   bit7=0 bit6=0 bit5=0 bit4=0 (#$0_) : page 0
*   bit7=0 bit6=1 bit5=0 bit4=0 (#$4_) : page 1
*   bit7=1 bit6=0 bit5=0 bit4=0 (#$8_) : page 2
*   bit7=1 bit6=1 bit5=0 bit4=0 (#$C_) : page 3
*   bit3 bit2 bit1 bit0  (#$_0 a #$_F) : couleur du cadre
*   Remarque : bit5 et bit4 utilisable uniquement en mode MO
*
* Page en espace cartouche (ecriture dans buffer invisible)
* --------------------------------------------------------------------
*   $E7E6 determine la page visible dans l'espace cartouche (0000 a 3FFF)
*   bit7 toujours a 0
*   bit6=1 : ecriture autorisee
*   bit5=1 : espace cartouche recouvert par de la RAM
*   bit4=0 : CAS1N valide : banques 0-15 / 1 = CAS2N valide : banques 16-31
*   bit5=1 bit4=0 bit3=0 bit2=0 bit1=0 bit0=0 (#$60) : page 0
*   ...
*   bit5=1 bit4=0 bit3=1 bit2=1 bit1=1 bit0=1 (#$6F) : page 15
*   bit5=1 bit4=1 bit3=0 bit2=0 bit1=0 bit0=0 (#$70) : page 16
*   ...
*   bit5=1 bit4=1 bit3=1 bit2=1 bit1=1 bit0=1 (#$7F) : page 31
*
* Demi-Page 0 en espace ecran (4000 a 5FFF)
* -----------------------------------------
*   $E7C3 determine la demi-page de la page 0 visible dans l'espace ecran
*   bit0=0 : 8Ko RAMA
*   bit0=1 : 8ko RAMB
*
********************************************************************************
WaitVBL
        tst   $E7E7              * le faisceau n'est pas dans l'ecran
        bpl   WaitVBL            * tant que le bit est a 0 on boucle
WaitVBL_01
        tst   $E7E7              * le faisceau est dans l'ecran
        bmi   WaitVBL_01         * tant que le bit est a 1 on boucle
        
        ldd   Vint_runcount
        addd  #1
        std   Vint_runcount
                        
SwapVideoPage
        ldb   am_SwapVideoPage+1 * charge la valeur du ldb suivant am_SwapVideoPage
        andb  #$40               * alterne bit6=0 et bit6=1 (suivant la valeur B $00 ou $FF)
screen_border_color *@globals       
        orb   #$80               * bit7=1, bit3 a bit0=couleur de cadre (ici 0)
        stb   $E7DD              * changement page (2 ou 3) affichee a l'ecran
        com   am_SwapVideoPage+1 * alterne $00 et $FF sur le ldb suivant am_SwapVideoPage
am_SwapVideoPage
        ldb   #$00
        andb  #$01               * alterne bit0=0 et bit0=1 (suivant la valeur B $00 ou $FF)
        stb   Glb_Cur_Wrk_Screen_Id
        orb   #$62               * bit6=1, bit5=1, bit1=1
        stb   $E7E6              * changement page (2 ou 3) visible dans l'espace cartouche
        ldb   $E7C3              * charge l'identifiant de la demi-page 0 configuree en espace ecran
        eorb  #$01               * alterne bit0 = 0 ou 1 changement demi-page de la page 0 visible dans l'espace ecran
        stb   $E7C3
        rts
        
Vint_runcount rmb   $2,0 *@globals

(include)READJPDS
* ---------------------------------------------------------------------------
* Controller Buttons
*
c1_button_up_mask            equ   $01 *@globals
c1_button_down_mask          equ   $02 *@globals
c1_button_left_mask          equ   $04 *@globals
c1_button_right_mask         equ   $08 *@globals
c2_button_up_mask            equ   $10 *@globals
c2_button_down_mask          equ   $20 *@globals
c2_button_left_mask          equ   $40 *@globals
c2_button_right_mask         equ   $80 *@globals
c1_button_A_mask             equ   $40 *@globals
c2_button_A_mask             equ   $80 *@globals

Joypads_Read
Dpad_Read                    fcb   $00
Fire_Read                    fcb   $00
   
Joypads
Joypads_Held                           *@globals
Dpad_Held                    fcb   $00 *@globals
Fire_Held                    fcb   $00 *@globals
Joypads_Press                          *@globals
Dpad_Press                   fcb   $00 *@globals
Fire_Press                   fcb   $00 *@globals

********************************************************************************
* Get joystick parameters
*
* Direction des Joypads
* ---------------------
* Registre: $E7CC (8bits)
*
* Joypad2     Joypad1
* 1111        1111 (0: appuye | 1: relache)  
* ||||_Haut   ||||_Haut
* |||__Bas    |||__Bas
* ||___Gauche ||___Gauche
* |____Droite |____Droite
*
* Boutons des Joypads
* -------------------
* Registre: $E7CD (8bits)
*
* 11 000000 (0: appuye | 1: relache) 
* ||[------] 6 bits convertisseur numerique-analogique
* ||_Fire Joypad1
* |__Fire Joypad2
*
* Variables globales: Joypads_Held, Joypads_Press
* -----------------------------------------------
* (16 bits)
* Joypad2     Joypad1                                                          
* 0000        0000 (0: relache | 1: appuye) 00 000000 (0: relache | 1: appuye)  
* ||||_Haut   ||||_Haut                     ||[------] Non utilise             
* |||__Bas    |||__Bas                      ||_Fire Joypad1                    
* ||___Gauche ||___Gauche                   |__Fire Joypad2                    
* |____Droite |____Droite                                                      
* 
********************************************************************************
   
                                       *; ---------------------------------------------------------------------------
                                       *; Subroutine to read joypad input, and send it to the RAM
                                       *; ---------------------------------------------------------------------------
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; sub_111C:
ReadJoypads                            *ReadJoypads:
                                       *    lea (Ctrl_1).w,a0         ; address where joypad states are written
                                       *    lea (HW_Port_1_Data).l,a1 ; first joypad port
                                       *    bsr.s   Joypad_Read       ; do the first joypad
                                       *    addq.w  #2,a1             ; do the second joypad
                                       *
                                       *; sub_112A:
                                       *Joypad_Read:
                                       *    move.b  #0,(a1)           ; Poll controller data port
                                       *    nop
                                       *    nop
                                       *    move.b  (a1),d0           ; Get controller port data (start/A)
                                       *    lsl.b   #2,d0
                                       *    andi.b  #$C0,d0
                                       *    move.b  #$40,(a1)         ; Poll controller data port again
                                       *    nop
                                       *    nop
                                       *    move.b  (a1),d1           ; Get controller port data (B/C/Dpad)
                                       *    andi.b  #$3F,d1
                                       *    or.b    d1,d0             ; Fuse together into one controller bit array
        ldd   $E7CC
        coma
        comb                           *    not.b   d0
        std   Joypads_Read        
        ldd   Joypads_Held             *    move.b  (a0),d1           ; Get held button data
        eora  Dpad_Read                *    eor.b   d0,d1             ; Toggle off buttons that are being held                       
        eorb  Fire_Read
                                       *    move.b  d0,(a0)+          ; Put raw controller input (for held buttons) in F604/F606
        anda  Dpad_Read                *    and.b   d0,d1
        andb  Fire_Read
        std   Joypads_Press            *    move.b  d1,(a0)+          ; Put pressed controller input in F605/F607
        ldd   Joypads_Read
        std   Joypads_Held
        rts                            *    rts
                                       *; End of function Joypad_Read


(include)RUNOBJTS
* ---------------------------------------------------------------------------
* RunObjects
* ------------
* Subroutine to run objects code
*
* input REG : none
* ---------------------------------------------------------------------------
                                            *; -------------------------------------------------------------------------------
                                            *; This runs the code of all the objects that are in Object_RAM
                                            *; -------------------------------------------------------------------------------
                                            *
                                            *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                            *
                                            *; sub_15F9C: ObjectsLoad:
RunObjects                                  *RunObjects:
                                            *    tst.b   (Teleport_flag).w
                                            *    bne.s   RunObjects_End  ; rts
        ldu   #Object_RAM                   *    lea (Object_RAM).w,a0 ; a0=object
                                            *
                                            *    moveq   #(Dynamic_Object_RAM_End-Object_RAM)/object_size-1,d7 ; run the first $80 objects out of levels
                                            *    moveq   #0,d0
                                            *    cmpi.b  #GameModeID_Demo,(Game_Mode).w  ; demo mode?
                                            *    beq.s   +   ; if in a level in a demo, branch
                                            *    cmpi.b  #GameModeID_Level,(Game_Mode).w ; regular level mode?
                                            *    bne.s   RunObject ; if not in a level, branch to RunObject
RunObjects_01                               *+
                                            *    move.w  #(Object_RAM_End-Object_RAM)/object_size-1,d7   ; run the first $90 objects in levels
                                            *    tst.w   (Two_player_mode).w
                                            *    bne.s   RunObject ; if in 2 player competition mode, branch to RunObject
                                            *
        tst   Glb_MainCharacter_Is_Dead     *    cmpi.b  #6,(MainCharacter+routine).w
        bne   RunObjectsWhenPlayerIsDead    *    bhs.s   RunObjectsWhenPlayerIsDead ; if dead, branch
                                            *    ; continue straight to RunObject
                                            *; ---------------------------------------------------------------------------
                                            *
                                            *; -------------------------------------------------------------------------------
                                            *; This is THE place where each individual object's code gets called from
                                            *; -------------------------------------------------------------------------------
                                            *
                                            *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                            *
                                            *; sub_15FCC:
RunObject                                   *RunObject:
        lda   #$00                          
        ldb   ,u                            *    move.b  id(a0),d0   ; get the object's ID
        beq   RunNextObject                 *    beq.s   RunNextObject ; if it's obj00, skip it

        ldy   #Obj_Index_Page
        lda   d,y                           ; page memoire
        sta   $E7E5                         ; selection de la page en RAM Donnees (A000-DFFF)
        lda   #$00
        aslb                                *    add.w   d0,d0
        rola                                *    add.w   d0,d0   ; d0 = object ID * 4
        ldy   #Obj_Index_Address            *    movea.l Obj_Index-4(pc,d0.w),a1 ; load the address of the object's code
        jsr   [d,y]                         *    jsr (a1)    ; dynamic call! to one of the the entries in Obj_Index
                                            *    moveq   #0,d0
                                            *
                                            *; loc_15FDC:
RunNextObject                               *RunNextObject:
        leau  next_object,u                 *    lea next_object(a0),a0 ; load 0bj address
am_RunNextObject                            
        cmpu  #Object_RAM_End               *    dbf d7,RunObject
        bne   RunObject                     *; return_15FE4:
RunObjects_End                              *RunObjects_End:
        rts                                 *    rts
                                            *
                                            *; ---------------------------------------------------------------------------
                                            *; this skips certain objects to make enemies and things pause when Sonic dies
                                            *; loc_15FE6:
RunObjectsWhenPlayerIsDead                  *RunObjectsWhenPlayerIsDead:
        ldu   #Reserved_Object_RAM
        ldx   #Reserved_Object_RAM_End
        stx   am_RunNextObject+2            *    moveq   #(Reserved_Object_RAM_End-Reserved_Object_RAM)/object_size-1,d7
        bsr   RunObject                     *    bsr.s   RunObject   ; run the first $10 objects normally
                                            *    moveq   #(Dynamic_Object_RAM_End-Dynamic_Object_RAM)/object_size-1,d7
                                            *    bsr.s   RunObjectDisplayOnly ; all objects in this range are paused      
        ldu   #LevelOnly_Object_RAM 
        ldx   #LevelOnly_Object_RAM_End
        stx   am_RunNextObject+2            *    moveq   #(LevelOnly_Object_RAM_End-LevelOnly_Object_RAM)/object_size-1,d7
        bsr   RunObject                     *    bra.s   RunObject   ; run the last $10 objects normally
                                            *
        ldx   #Object_RAM_End               * repositionne la fin du RunObject avec sa valeur par d�faut
        stx   am_RunNextObject+2
        rts            
                                            *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                            *
                                            *; sub_15FF2:
                                            *RunObjectDisplayOnly:
                                            *    moveq   #0,d0
                                            *    move.b  id(a0),d0   ; get the object's ID
                                            *    beq.s   +   ; if it's obj00, skip it
                                            *    tst.b   render_flags(a0)    ; should we render it?
                                            *    bpl.s   +           ; if not, skip it
                                            *    bsr.w   DisplaySprite
                                            *+
                                            *    lea next_object(a0),a0 ; load 0bj address
                                            *    dbf d7,RunObjectDisplayOnly
                                            
                                            *    rts
                                            *; End of function RunObjectDisplayOnly
                                            *
                                            *; ===========================================================================

(include)MRKOBJGN
* ---------------------------------------------------------------------------
* MarkObjGone
* -----------
* Subroutine to destroy an object that is outside of destroy/respawn limit
* -- TODO --
* waiting for camera implementation
*
* input REG : none
* clear REG : none
* ---------------------------------------------------------------------------

                                       *; ---------------------------------------------------------------------------
                                       *; Routines to mark an enemy/monitor/ring/platform as destroyed
                                       *; ---------------------------------------------------------------------------
                                       *
                                       *; ===========================================================================
                                       *; input: a0 = the object
                                       *; loc_163D2:
MarkObjGone *@globals                  *MarkObjGone:
                                       *    tst.w   (Two_player_mode).w ; is it two player mode?
                                       *    beq.s   +           ; if not, branch
        bra   DisplaySprite            *    bra.w   DisplaySprite
                                       *+
                                       *    move.w  x_pos(a0),d0
                                       *    andi.w  #$FF80,d0
                                       *    sub.w   (Camera_X_pos_coarse).w,d0
                                       *    cmpi.w  #$80+320+$40+$80,d0 ; This gives an object $80 pixels of room offscreen before being unloaded (the $40 is there to round up 320 to a multiple of $80)
                                       *    bhi.w   +
                                       *    bra.w   DisplaySprite
                                       *
                                       *+   lea (Object_Respawn_Table).w,a2
                                       *    moveq   #0,d0
                                       *    move.b  respawn_index(a0),d0
                                       *    beq.s   +
                                       *    bclr    #7,2(a2,d0.w)
                                       *+
                                       *    bra.w   MarkObjToBeDeleted

(include)DISPLSPR
* ---------------------------------------------------------------------------
* DisplaySprite
* -------------
* Subroutine to manage sprite priority.
* Object's priority is read and object is (un)registred in display engine.
* priority: 0 - unregistred
* priority: 1 - register non moving overlay sprite
* priority; 2-8 - register moving sprite (2:front, ..., 8:back)  
*
* Unlike original S2 code, sprite priority is stored in an open doubly linked list
* it allows to keep an exact sprite order for each screen buffer 
*
* DisplaySprite
* input REG : [u] object pointer (OST)
*
* DisplaySprite_x
* input REG : [x] object pointer (OST)
* ---------------------------------------------------------------------------
									   
DisplaySprite_x *@globals
        pshs  d,x,u
        tfr   x,u
        bra   DSP_Start
        
DisplaySprite *@globals
        pshs  d,x,u
        
DSP_Start
        lda   render_flags,u
        anda  #:render_hide_mask            ; unset hide flag
        sta   render_flags,u

        lda   Glb_Cur_Wrk_Screen_Id         ; read current screen buffer for write operations
        bne   DSP_SetBuffer1
        
DSP_SetBuffer0        
        leax  rsv_buffer_0,u                ; set x pointer to object variables that belongs to screen buffer 0
        ldy   #DPS_buffer_0                 ; set y pointer to Display Priority Structure that belongs to screen buffer 0
        bra   DSP_BufferPositionned
        
DSP_SetBuffer1       
        leax  rsv_buffer_1,u                ; set x pointer to object variables that belongs to screen buffer 1
        ldy   #DPS_buffer_1                 ; set y pointer to Display Priority Structure that belongs to screen buffer 1        
        
DSP_BufferPositionned       
        lda   priority,u                    ; read priority set for this object
        cmpa  buf_priority,x
        beq   DSP_rts                       ; priority and current priority are the same: nothing to do
        ldb   buf_priority,x   
        bne   DSP_ChangePriority
        
DSP_InitPriority
        sta   buf_priority,x                ; init priority for this screen buffer with priority from object
        asla                                ; change priority number to priority index (value x2)
        
DSP_CheckLastEntry
        leay  buf_Tbl_Priority_Last_Entry,y
        tst   a,y                           ; test left byte only is ok, no object will be stored at $00__ address
        bne   DSP_addToExistingNode         ; not the first object at this priority level, branch
        
DSP_addFirstNode        
        stu   a,y                           ; save object as last entry in linked list
        leay  buf_Tbl_Priority_First_Entry-buf_Tbl_Priority_Last_Entry,y
        stu   a,y                           ; save object as first entry in linked list
        ldd   #0
        std   buf_priority_prev_obj,x       ; clear object prev and next link, it's the only object at this priority level
        std   buf_priority_next_obj,x
        
DSP_rts
        puls  d,x,u,pc                      ; rts        
        
DSP_addToExistingNode
        ldx   a,y                           ; x register now store last object at the priority level of current object
        ldb   Glb_Cur_Wrk_Screen_Id
        bne   DSP_LinkBuffer1
        stu   rsv_priority_next_obj_0,x     ; link last object with current object if active screen buffer 0
        stx   rsv_priority_prev_obj_0,u     ; link current object with previous object
        clr   rsv_priority_next_obj_0,u     ; clear object next link        
        clr   rsv_priority_next_obj_0+1,u   ; clear object next link        
        bra   DSP_LinkCurWithPrev        
DSP_LinkBuffer1        
        stu   rsv_priority_next_obj_1,x     ; link last object with current object if active screen buffer 1
        stx   rsv_priority_prev_obj_1,u     ; link current object with previous object
        clr   rsv_priority_next_obj_1,u     ; clear object next link        
        clr   rsv_priority_next_obj_1+1,u   ; clear object next link        
        
DSP_LinkCurWithPrev        
        stu   a,y                           ; update last object in index
        puls  d,x,u,pc                      ; rts
        
DSP_ChangePriority
        leay  buf_Lst_Priority_Unset,y
        stu   [,y]                          ; add object address to unset list
        leay  2,y
        sty   ,y                            ; set index to next free cell of unset list
        leay  -buf_Lst_Priority_Unset-2,y
        cmpa  #0
        bne   DSP_CheckLastEntry            ; priority is != 0, branch to add object to display priority list
        puls  d,x,u,pc                      ; rts

        
                                       *; ---------------------------------------------------------------------------
                                       *; Subroutine to display a sprite/object, when a0 is the object RAM
                                       *; ---------------------------------------------------------------------------
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; sub_164F4:
                                       *DisplaySprite:
                                       *    lea (Sprite_Table_Input).w,a1
                                       *    move.w  priority(a0),d0
                                       *    lsr.w   #1,d0
                                       *    andi.w  #$380,d0
                                       *    adda.w  d0,a1
                                       
                                       *    cmpi.w  #$7E,(a1)
                                       *    bhs.s   return_16510
                                       *    addq.w  #2,(a1)
                                       
                                       *    adda.w  (a1),a1
                                       *    move.w  a0,(a1)
                                       *
                                       *return_16510:
                                       
                                       *    rts
                                       *; End of function DisplaySprite        

(include)ANIMSPR
* ---------------------------------------------------------------------------
* Subroutine to animate a sprite using an animation script
*
*   this function also change render flags to match orientation given by
*   the status byte;
*
* input REG : [u] pointeur sur l'objet
*
* ---------------------------------------------------------------------------

resetAnim              equ $FF
goBackNFrames          equ $FE ; followed by one byte (nb frames)
goToAnimation          equ $FD ; followed by one word (animation)
nextRoutine            equ $FC
resetAnimAndSubRoutine equ $FB
nextSubRoutine         equ $FA

                                            *; ---------------------------------------------------------------------------
                                            *; Subroutine to animate a sprite using an animation script
                                            *; ---------------------------------------------------------------------------
                                            *
                                            *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                            *
                                            *; sub_16544:
AnimateSprite * @globals                    *AnimateSprite:
                                            *    moveq   #0,d0
        ldx   anim,u                        *    move.b  anim(a0),d0      ; move animation number to d0
        cmpx  prev_anim,u                   *    cmp.b   prev_anim(a0),d0 ; is animation set to change?
        beq   Anim_Run                      *    beq.s   Anim_Run         ; if not, branch
        stx   prev_anim,u                   *    move.b  d0,prev_anim(a0) ; set prev anim to current animation
		ldb   #0                            
        stb   anim_frame,u                  *    move.b  #0,anim_frame(a0)          ; reset animation
        stb   anim_frame_duration,u         *    move.b  #0,anim_frame_duration(a0) ; reset frame duration
                                            *; loc_16560:
Anim_Run                                    *Anim_Run:
        dec   anim_frame_duration,u         *    subq.b  #1,anim_frame_duration(a0)   ; subtract 1 from frame duration
        bpl   Anim_Wait                     *    bpl.s   Anim_Wait                    ; if time remains, branch
        * no offset table                   *    add.w   d0,d0
        * anim is the address of anim       *    adda.w  (a1,d0.w),a1                 ; calculate address of appropriate animation script
        ldb   -1,x                            
		stb   anim_frame_duration,u         *    move.b  (a1),anim_frame_duration(a0) ; load frame duration
                                            *    moveq   #0,d1
        ldb   anim_frame,u                  *    move.b  anim_frame(a0),d1 ; load current frame number
        aslb
        leay  b,x                                
        ldd   ,y                            *    move.b  1(a1,d1.w),d0 ; read sprite number from script
        * bmi   Anim_End_FF                 *    bmi.s   Anim_End_FF   ; if animation is complete, branch MJ: Delete this line
		cmpa  #$FA                          *    cmp.b   #$FA,d0       ; MJ: is it a flag from FA to FF?
		bhs   Anim_End_FF                   *    bhs     Anim_End_FF   ; MJ: if so, branch to flag routines
                                            *; loc_1657C:
Anim_Next                                   *Anim_Next:
	    * ne pas utiliser                   *    andi.b  #$7F,d0               ; clear sign bit
        std   image_set,u                   *    move.b  d0,mapping_frame(a0)  ; load sprite number
        ldb   status,u                      *    move.b  status(a0),d1         ; match the orientaion dictated by the object
        andb  #status_x_orientation+status_y_orientation
        stb   Anim_dyn+1
                                            *    andi.b  #3,d1                 ; with the orientation used by the object engine
        lda   render_flags,u                *    andi.b  #$FC,render_flags(a0)
        anda  #:(render_xmirror_mask+render_ymirror_mask)
Anim_dyn        
        ora   #$00                          ; (dynamic)
                                            *    or.b    d1,render_flags(a0)
        sta   render_flags,u                
        inc   anim_frame,u                  *    addq.b  #1,anim_frame(a0)     ; next frame number
                                            *; return_1659A:
Anim_Wait                                   *Anim_Wait:
        rts                                 *    rts 
                                            *; ===========================================================================
                                            *; loc_1659C:
Anim_End_FF                                 *Anim_End_FF:
        inca                                *    addq.b  #1,d0       ; is the end flag = $FF ?
        bne   Anim_End_FE                   *    bne.s   Anim_End_FE ; if not, branch
		ldb   #0                            
        stb   anim_frame,u                  *    move.b  #0,anim_frame(a0) ; restart the animation
        ldd   ,x                            *    move.b  1(a1),d0          ; read sprite number
        bra   Anim_Next                     *    bra.s   Anim_Next
                                            *; ===========================================================================
                                            *; loc_165AC:
Anim_End_FE                                 *Anim_End_FE:
        inca                                *    addq.b  #1,d0             ; is the end flag = $FE ?
        bne   Anim_End_FD                   *    bne.s   Anim_End_FD       ; if not, branch
        lda   anim_frame,u                  
        stb   Anim_End_FE_dyn+1             *    move.b  2(a1,d1.w),d0     ; read the next byte in the script
Anim_End_FE_dyn
        suba  #$00                          ; (dynamic)                          
        sta   anim_frame,u                  *    sub.b   d0,anim_frame(a0) ; jump back d0 bytes in the script
                                            *    sub.b   d0,d1
        asla                                             
        ldd   a,x                           *    move.b  1(a1,d1.w),d0     ; read sprite number
        bra   Anim_Next                     *    bra.s   Anim_Next
                                            *; ===========================================================================
                                            *; loc_165C0:
Anim_End_FD                                 *Anim_End_FD:
        inca                                *    addq.b  #1,d0               ; is the end flag = $FD ?
        bne   Anim_End_FC                   *    bne.s   Anim_End_FC         ; if not, branch
        ldd   1,y                           ; read word after FD
        std   anim,u                        *    move.b  2(a1,d1.w),anim(a0) ; read next byte, run that animation
        rts                                 *    rts
                                            *; ===========================================================================
                                            *; loc_165CC:
Anim_End_FC                                 *Anim_End_FC:
        inca                                *    addq.b  #1,d0          ; is the end flag = $FC ?
        bne   Anim_End_FB                   *    bne.s   Anim_End_FB    ; if not, branch
        ldb   routine,u
        addb  #$03                     
        stb   routine,u                     *    addq.b  #2,routine(a0) ; jump to next routine
        lda   #0                            
        sta   anim_frame_duration,u         *    move.b  #0,anim_frame_duration(a0)
        inc   anim_frame,u                  *    addq.b  #1,anim_frame(a0)
        rts                                 *    rts
                                            *; ===========================================================================
                                            *; loc_165E0:
Anim_End_FB                                 *Anim_End_FB:
        inca                                *    addq.b  #1,d0                 ; is the end flag = $FB ?
        bne   Anim_End_FA                   *    bne.s   Anim_End_FA           ; if not, branch
        lda   #0                            
        sta   anim_frame,u                  *    move.b  #0,anim_frame(a0)     ; reset animation
        sta   routine_secondary,u           *    clr.b   routine_secondary(a0) ; reset 2nd routine counter
        rts                                 *    rts
                                            *; ===========================================================================
                                            *; loc_165F0:
Anim_End_FA                                 *Anim_End_FA:
        inca                                *    addq.b  #1,d0                    ; is the end flag = $FA ?
        bne   Anim_End                      *    bne.s   Anim_End_F9              ; if not, branch
        ldb   routine_secondary,u           *    addq.b  #2,routine_secondary(a0) ; jump to next routine
        addb  #$03
        stb   routine_secondary,u    
Anim_End               
        rts                                 *    rts
                                            *; ===========================================================================
                                            *; loc_165FA:
                                            *Anim_End_F9:
                                            *    addq.b  #1,d0            ; is the end flag = $F9 ?
                                            *    bne.s   Anim_End         ; if not, branch
                                            *    addq.b  #2,objoff_2A(a0) ; Actually obj89_arrow_routine
                                            *; return_16602:
                                            *Anim_End:
                                            *    rts
                                            *; End of function AnimateSprite

(include)OBJMOVE
* ---------------------------------------------------------------------------
* Subroutine translating object speed to update object position
* This moves the object horizontally and vertically
* but does not apply gravity to it
* ---------------------------------------------------------------------------

                                       *; ---------------------------------------------------------------------------
                                       *; Subroutine translating object speed to update object position
                                       *; This moves the object horizontally and vertically
                                       *; but does not apply gravity to it
                                       *; ---------------------------------------------------------------------------
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; sub_163AC: SpeedToPos:
ObjectMove                             *ObjectMove:
                                       *    move.l  x_pos(a0),d2    ; load x position
                                       *    move.l  y_pos(a0),d3    ; load y position
                                       *    move.w  x_vel(a0),d0    ; load horizontal speed
                                       *    ext.l   d0
                                       *    asl.l   #8,d0   ; shift velocity to line up with the middle 16 bits of the 32-bit position
                                       *    add.l   d0,d2   ; add to x-axis position    ; note this affects the subpixel position x_sub(a0) = 2+x_pos(a0)
        ldb   x_vel,u
        sex                            ; velocity is positive or negative, take care of that
        sta   am_ObjectMove_01+1
        ldd   x_vel,u
        addd  x_pos+1,u                ; x_pos must be followed by x_sub in memory
        std   x_pos+1,u                ; update low byte of x_pos and x_sub byte
        lda   x_pos,u
am_ObjectMove_01
        adca  #$00                     ; parameter is modified by the result of sign extend
        sta   x_pos,u                  ; update high byte of x_pos
        
                                       *    move.w  y_vel(a0),d0    ; load vertical speed
                                       *    ext.l   d0
                                       *    asl.l   #8,d0   ; shift velocity to line up with the middle 16 bits of the 32-bit position
                                       *    add.l   d0,d3   ; add to y-axis position    ; note this affects the subpixel position y_sub(a0) = 2+y_pos(a0)
                                       *    move.l  d2,u_pos(a0)    ; update x-axis position
                                       *    move.l  d3,y_pos(a0)    ; update y-axis position
        ldb   y_vel,u
        sex                            ; velocity is positive or negative, take care of that
        sta   am_ObjectMove_02+1
        ldd   y_vel,u
        addd  y_pos+1,u                ; y_pos must be followed by y_sub in memory
        std   y_pos+1,u                ; update low byte of y_pos and y_sub byte
        lda   y_pos,u
am_ObjectMove_02
        adca  #$00                     ; parameter is modified by the result of sign extend
        sta   y_pos,u                  ; update high byte of y_pos
        rts                            *    rts
                                       *; End of function ObjectMove
                                       *; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

(include)OBJLOAD
* ---------------------------------------------------------------------------
* Single object loading subroutine
* Find an empty object array
*
* input  REG : [u] pointeur sur l'objet courant  
* output REG : [x] pointeur sur l'objet libre   
* ---------------------------------------------------------------------------

                                       *; ---------------------------------------------------------------------------
                                       *; Single object loading subroutine
                                       *; Find an empty object array
                                       *; ---------------------------------------------------------------------------
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; loc_17FDA: ; allocObject:
                                       *SingleObjLoad:
                                       *    lea (Dynamic_Object_RAM).w,a1 ; a1=object
                                       *    move.w  #(Dynamic_Object_RAM_End-Dynamic_Object_RAM)/object_size-1,d0 ; search to end of table
                                       *    tst.w   (Two_player_mode).w
                                       *    beq.s   +
                                       *    move.w  #(Dynamic_Object_RAM_2P_End-Dynamic_Object_RAM)/object_size-1,d0 ; search to $BF00 exclusive
                                       *
                                       */
                                       *    tst.b   id(a1)  ; is object RAM slot empty?
                                       *    beq.s   return_17FF8    ; if yes, branch
                                       *    lea next_object(a1),a1 ; load obj address ; goto next object RAM slot
                                       *    dbf d0,-    ; repeat until end
                                       *
                                       *return_17FF8:
                                       *    rts
                                       *; ===========================================================================
                                       *; ---------------------------------------------------------------------------
                                       *; Single object loading subroutine
                                       *; Find an empty object array AFTER the current one in the table
                                       *; ---------------------------------------------------------------------------
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; loc_17FFA: ; allocObjectAfterCurrent:
SingleObjLoad2                         *SingleObjLoad2:
        tfr   u,x                      *    movea.l a0,a1
        leax  next_object,x            *    move.w  #Dynamic_Object_RAM_End,d0  ; $D000
        cmpx  #Dynamic_Object_RAM_End  *    sub.w   a0,d0   ; subtract current object location
        beq   SingleObjLoad2_02        *    if object_size=$40
                                       *    lsr.w   #6,d0   ; divide by $40
                                       *    subq.w  #1,d0   ; keep from going over the object zone
                                       *    bcs.s   return_18014
                                       *    else
                                       *    lsr.w   #6,d0           ; divide by $40
                                       *    move.b  +(pc,d0.w),d0       ; load the right number of objects from table
                                       *    bmi.s   return_18014        ; if negative, we have failed!
                                       *    endif
                                       *
SingleObjLoad2_01                      *-
        tst   ,x                       *    tst.b   id(a1)  ; is object RAM slot empty?
        beq   SingleObjLoad2_02        *    beq.s   return_18014    ; if yes, branch
        leax  next_object,x            *    lea next_object(a1),a1 ; load obj address ; goto next object RAM slot
        cmpx  #Dynamic_Object_RAM_End
        bne   SingleObjLoad2_01        *    dbf d0,-    ; repeat until end
                                       *
SingleObjLoad2_02                      *return_18014:
        rts                            *    rts
                                       *
                                       *    if object_size<>$40
                                       *+   dc.b -1
                                       *.a :=   1       ; .a is the object slot we are currently processing
                                       *.b :=   1       ; .b is used to calculate when there will be a conversion error due to object_size being > $40
                                       *
                                       *    rept (LevelOnly_Object_RAM-Reserved_Object_RAM_End)/object_size-1
                                       *        if (object_size * (.a-1)) / $40 > .b+1  ; this line checks, if there would be a conversion error
                                       *            dc.b .a-1, .a-1         ; and if is, it generates 2 entries to correct for the error
                                       *        else
                                       *            dc.b .a-1
                                       *        endif
                                       *
                                       *.b :=       (object_size * (.a-1)) / $40        ; this line adjusts .b based on the iteration count to check
                                       *.a :=       .a+1                    ; run interation counter
                                       *    endm
                                       *    even
                                       *    endif
                                       *; ===========================================================================
                                       *; ---------------------------------------------------------------------------
                                       *; Single object loading subroutine
                                       *; Find an empty object at or within < 12 slots after a3
                                       *; ---------------------------------------------------------------------------
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; loc_18016:
                                       *SingleObjLoad3:
                                       *    movea.l a3,a1
                                       *    move.w  #$B,d0
                                       *
                                       *-
                                       *    tst.b   id(a1)  ; is object RAM slot empty?
                                       *    beq.s   return_18028    ; if yes, branch
                                       *    lea next_object(a1),a1 ; load obj address ; goto next object RAM slot
                                       *    dbf d0,-    ; repeat until end
                                       *
                                       *return_18028:
                                       *    rts
                                       *; ===========================================================================


(include)DELETOBJ
* ---------------------------------------------------------------------------
* DeleteObject
* ------------
* Subroutine to delete an object.
* If the object is rendered as a sprite it will be deleted by EraseSprites
* routine
*
* DeleteObject
* input REG : [u] object pointer (OST)
*
* DeleteObject_x
* input REG : [x] object pointer (OST)
* ---------------------------------------------------------------------------

                                       *; ---------------------------------------------------------------------------
                                       *; Subroutine to delete an object
                                       *; ---------------------------------------------------------------------------
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; freeObject:
DeleteObject_x *@globals               *DeleteObject:
        pshs  d,x,u                    *    movea.l a0,a1
        leau  ,x                       *; sub_164E8:
        bra   DOB_Start
        
DeleteObject *@globals                 *DeleteObject2:
        pshs  d,x,u
        
DOB_Start
        lda   rsv_prev_render_flags_0,u
        bpl   DOB_RemoveFromDPSB0           ; branch if not onscreen on buffer 0

DOB_ToDeleteFlag0
        lda   render_flags,u
        ora   #render_todelete_mask
        sta   render_flags,u                ; set todelete flag, object will be deleted after sprite erase
        
DOB_Unset0        
        ldx   Lst_Priority_Unset_0          ; add object to unset list on buffer 0
        stu   ,x
        leax  2,x
        stx   Lst_Priority_Unset_0
        
DOB_TestOnscreen1
        lda   rsv_prev_render_flags_1,u
        bpl   DOB_RemoveFromDPSB1           ; branch if not onscreen on buffer 1
        
DOB_ToDeleteFlag1
        lda   render_flags,u
        ora   #render_todelete_mask
        sta   render_flags,u                ; set todelete flag, object will be deleted after sprite erase
        
DOB_Unset1
        ldx   Lst_Priority_Unset_1          ; add object to unset list on buffer 1                       
        stu   ,x
        leax  2,x
        stx   Lst_Priority_Unset_1
        puls  d,x,u,pc                      ; rts

DOB_RemoveFromDPSB0
        ldd   rsv_priority_prev_obj_0,u     ; remove object from DSP on buffer 0
        bne   DOB_ChainPrevB0
        
        lda   rsv_priority_0,u
        lsla
        ldy   #Tbl_Priority_First_Entry_0
        leay  a,y
        ldd   rsv_priority_next_obj_0,u
        std   ,y
        bra   DOB_CheckPrioNextB0
                
DOB_ChainPrevB0
        ldd   rsv_priority_next_obj_0,u
        ldy   rsv_priority_prev_obj_0,u        
        std   rsv_priority_next_obj_0,y        

DOB_CheckPrioNextB0       
        ldd   rsv_priority_next_obj_0,u
        bne   DOB_ChainNextB0

        lda   rsv_priority_0,u
        lsla
        ldy   #Tbl_Priority_Last_Entry_0
        leay  a,y
        ldd   rsv_priority_prev_obj_0,u
        std   ,y
        bra   DOB_TestOnscreen1
                
DOB_ChainNextB0
        ldd   rsv_priority_prev_obj_0,u
        ldy   rsv_priority_next_obj_0,u        
        std   rsv_priority_prev_obj_0,y
        bra   DOB_TestOnscreen1        

DOB_RemoveFromDPSB1
        ldd   rsv_priority_prev_obj_1,u
        bne   DOB_ChainPrevB1
        
        lda   rsv_priority_1,u
        lsla
        ldy   #Tbl_Priority_First_Entry_1
        leay  a,y
        ldd   rsv_priority_next_obj_1,u
        std   ,y
        bra   DOB_CheckPrioNextB1
                
DOB_ChainPrevB1
        ldd   rsv_priority_next_obj_1,u
        ldy   rsv_priority_prev_obj_1,u        
        std   rsv_priority_next_obj_1,y        

DOB_CheckPrioNextB1       
        ldd   rsv_priority_next_obj_1,u
        bne   DOB_ChainNextB1

        lda   rsv_priority_1,u
        lsla
        ldy   #Tbl_Priority_Last_Entry_1
        leay  a,y
        ldd   rsv_priority_prev_obj_1,u
        std   ,y
        lda   rsv_prev_render_flags_0,u
        bmi   DOB_rts                       ; branch if onscreen on buffer 0 (do not erase object)        
        jsr   ClearObj                      ; this object is not onscreen anymore, clear this object now
DOB_rts                                *
        puls  d,x,u,pc        
                
DOB_ChainNextB1
        ldd   rsv_priority_prev_obj_1,u
        ldy   rsv_priority_next_obj_1,u        
        std   rsv_priority_prev_obj_1,y
        lda   rsv_prev_render_flags_0,u
        bmi   DOB_rts                       ; branch if onscreen on buffer 0 (do not erase object)        
        jsr   ClearObj                      ; this object is not onscreen anymore, clear this object now
        puls  d,x,u,pc        

                                       *    moveq   #0,d1
                                       *
                                       *    moveq   #bytesToLcnt(next_object),d0 ; we want to clear up to the next object
                                       *    ; delete the object by setting all of its bytes to 0
                                       *-   move.l  d1,(a1)+
                                       *    dbf d0,-
                                       *    if object_size&3
                                       *    move.w  d1,(a1)+
                                       *    endif
                                       *
                                       *    rts
                                       *; End of function DeleteObject2                                            

(include)CLEAROBJ
* ---------------------------------------------------------------------------
* ClearObj
* --------
* Subroutine to clear an object data in OST
*
* input REG : [u] pointer on objet (OST)
* clear REG : [d,y]
* ---------------------------------------------------------------------------

ClearObj *@globals
        pshs  d,x,y,u
        sts   CLO_1+2
        leas  object_size,u        
        ldd   #$0000
        ldx   #$0000
        leay  ,x
        leau  ,x
        pshs  d,x,y,u
        pshs  d,x,y,u
        pshs  d,x,y,u
        pshs  d,x,y,u
        pshs  d,x,y,u
        pshs  d,x,y,u
        pshs  d,x,y,u
        pshs  d,x,y,u
        pshs  d,x,y,u
        leau  ,s
CLO_1        
        lds   #$0000        ; start of object should not be written with S as an index because of IRQ        
        pshu  d,x,y         ; saving 12 bytes + (2 bytes * _sr calls) inside IRQ routine
        pshu  d,x,y         ; DEPENDENCY on nb of _sr calls inside IRQ routine  (here 18 bytes of margin)
        pshu  d,x,y         ; DEPENDENCY on object_size definition
CLO_2        
        puls  d,x,y,u,pc

(include)CHECKSPR
* ---------------------------------------------------------------------------
* CheckSpritesRefresh
* -------------------
* Subroutine to determine if sprites are gonna be erased and/or drawn
* Read Display Priority Structure (back to front)
* priority: 0 - unregistred
* priority: 1 - register non moving overlay sprite
* priority; 2-8 - register moving sprite (2:front, ..., 8:back)  
*
* input REG : none
* ---------------------------------------------------------------------------

cur_priority            fdb   $00
cur_ptr_sub_obj_erase   fdb   $0000
cur_ptr_sub_obj_draw    fdb   $0000
									   
CheckSpritesRefresh

CSR_Start
        ldd   #Tbl_Sub_Object_Erase
        std   cur_ptr_sub_obj_erase
        ldd   #Tbl_Sub_Object_Draw
        std   cur_ptr_sub_obj_draw
        lda   Glb_Cur_Wrk_Screen_Id         ; read current screen buffer for write operations
        bne   CSR_SetBuffer1
        
CSR_SetBuffer0        
        lda   #rsv_buffer_0                 ; set offset to object variables that belongs to screen buffer 0
        sta   CSR_ProcessEachPriorityLevel+2    
CSR_P8B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+16 ; read DPS from priority 8 to priority 1
        beq   CSR_P7B0
        lda   #$08
        sta   cur_priority        
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P7B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+14
        beq   CSR_P6B0
        lda   #$07
        sta   cur_priority        
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P6B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+12
        beq   CSR_P5B0
        lda   #$06
        sta   cur_priority        
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P5B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+10
        beq   CSR_P4B0
        lda   #$05
        sta   cur_priority                       
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P4B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+8
        beq   CSR_P3B0
        lda   #$04
        sta   cur_priority                       
        jsr   CSR_ProcessEachPriorityLevel               
CSR_P3B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+6
        beq   CSR_P2B0
        lda   #$03
        sta   cur_priority                       
        jsr   CSR_ProcessEachPriorityLevel      
CSR_P2B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+4
        beq   CSR_P1B0
        lda   #$02
        sta   cur_priority                       
        jsr   CSR_ProcessEachPriorityLevel  
CSR_P1B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+2
        beq   CSR_rtsB0
        lda   #$01
        sta   cur_priority                       
        jsr   CSR_ProcessEachPriorityLevel
CSR_rtsB0        
        rts
        
CSR_SetBuffer1       
        lda   #rsv_buffer_1                 ; set offset to object variables that belongs to screen buffer 1
        sta   CSR_ProcessEachPriorityLevel+2        
CSR_P8B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+16 ; read DPS from priority 8 to priority 1
        beq   CSR_P7B1
        lda   #$08
        sta   cur_priority        
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P7B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+14
        beq   CSR_P6B1
        lda   #$07
        sta   cur_priority                       
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P6B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+12
        beq   CSR_P5B1
        lda   #$06
        sta   cur_priority                       
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P5B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+10
        beq   CSR_P4B1
        lda   #$05
        sta   cur_priority                       
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P4B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+8
        beq   CSR_P3B1
        lda   #$04
        sta   cur_priority
        jsr   CSR_ProcessEachPriorityLevel               
CSR_P3B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+6
        beq   CSR_P2B1
        lda   #$03
        sta   cur_priority                       
        jsr   CSR_ProcessEachPriorityLevel      
CSR_P2B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+4
        beq   CSR_P1B1
        lda   #$02
        sta   cur_priority                       
        jsr   CSR_ProcessEachPriorityLevel  
CSR_P1B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+2
        beq   CSR_rtsB1
        lda   #$01
        sta   cur_priority                       
        jsr   CSR_ProcessEachPriorityLevel
CSR_rtsB1        
        rts

CSR_ProcessEachPriorityLevel
        leax  16,u                          ; dynamic offset, x point to object variables relative to current writable buffer (beware that rsv_buffer_0 and rsv_buffer_1 should be equ >=16)
        
CSR_CheckDelHide
        lda   render_flags,u
        anda  #render_hide_mask!render_todelete_mask
        bne   CSR_DoNotDisplaySprite      

CSR_CheckRefresh        
        lda   rsv_render_flags,u
        anda  #rsv_render_checkrefresh_mask ; branch if checkrefresh is true
        lbne  CSR_CheckErase

CSR_UpdSpriteImageBasedOnMirror
        lda   rsv_render_flags,u
        ora   #rsv_render_checkrefresh_mask
        sta   rsv_render_flags,u            ; set checkrefresh flag to true
        
        lda   render_flags,u                ; set image to display based on x and y mirror flags
        anda  #render_xmirror_mask!render_ymirror_mask
        ldy   image_set,u
        ldb   image_center_offset,y
        stb   rsv_image_center_offset,u        
        ldb   a,y
        leay  b,y                           ; read image set index
        sty   rsv_image_subset,u
        
CSR_CheckPlayFieldCoord
        lda   render_flags,u
        anda  #render_playfieldcoord_mask
        beq   CSR_CheckVerticalPosition     ; branch if position is already expressed in screen coordinate
        
        * not yet implemented
        * need to be updated with new algorithm (see drawio)
        *ldd   x_pos,u
        *subd  Glb_Camera_X_Pos
        *ldy   rsv_mapping_frame,u
        *addd  image_x_offset,y
        *lbvs   CSR_SetOutOfRange             ; top left coordinate overflow of image
        *lbmi   CSR_SetOutOfRange             ; branch if (x_pixel < 0)
        *stb   x_pixel,u
        *addb  image_x_size_l,y
        *lbvs   CSR_SetOutOfRange             ; bottom rigth coordinate overflow of image
        *stb   rsv_x2_pixel,u
        *cmpb  #screen_width
        *lbgt   CSR_SetOutOfRange             ; branch if (x_pixel + image.x_size > screen width)

        *ldd   y_pos,u
        *subd  Glb_Camera_Y_Pos
        *addd  image_y1_offset,y
        *bvs   CSR_SetOutOfRange             ; top left coordinate overflow of image        
        *bmi   CSR_SetOutOfRange             ; branch if (y_pixel < 0)
        *stb   y_pixel,u        
        *addb  image_y_size_l,y
        *bvs   CSR_SetOutOfRange             ; bottom rigth coordinate overflow of image
        *stb   rsv_y2_pixel,u
        *cmpb  #screen_bottom
        *bhi   CSR_SetOutOfRange             ; branch if (y_pixel + image.y_size > screen height)
        *lda   rsv_render_flags,u
        *anda  #:rsv_render_outofrange_mask  ; unset out of range flag
        *sta   rsv_render_flags,u
        *bra   CSR_CheckErase
        
CSR_DoNotDisplaySprite
        lda   priority,u                     
        cmpa  cur_priority 
        bne   CSR_NextObject                ; next object if this one is a new priority record (no need to erase) 
        
        lda   rsv_render_flags,u
        anda  #:rsv_render_erasesprite_mask&:rsv_render_displaysprite_mask ; set erase and display flag to false
        sta   rsv_render_flags,u
                
        ldb   buf_prev_render_flags,x
        bpl   CSR_NextObject                ; branch if not on screen
        
        ora   #rsv_render_erasesprite_mask  ; set erase flag to true if on screen                  
        sta   rsv_render_flags,u
        
        ldy   cur_ptr_sub_obj_erase         ; maintain list of changing sprites to erase
        stu   ,y++
        sty   cur_ptr_sub_obj_erase 
        
CSR_NextObject
        ldu   buf_priority_next_obj,x
        lbne  CSR_ProcessEachPriorityLevel   
        rts

CSR_CheckVerticalPosition
        lda   x_pixel,u                     ; compute mapping_frame 
        eora  rsv_image_center_offset,u     ; case of odd image center switch shifted image with normal
        anda  #$01                          ; index of sub image is encoded in two bits: 00|B0, 01|D0, 10|B1, 11|D1         
        asla                                ; set bit2 for 1px shifted image  
        ldb   render_flags,u            
        andb  #render_overlay_mask          ; set bit1 for normal (background save) or overlay sprite (no background save)
        beq   CSR_NoOverlay
        inca
CSR_NoOverlay
        ldb   a,y
        beq   CSR_NoDefinedFrame
        leay  b,y                           ; read image subset index
        sty   rsv_mapping_frame,u
        bra CSR_CVP_Continue
        
CSR_NoDefinedFrame
        anda  #$01                          ; test if there is an image without 1px shift
        ldb   a,y
        beq   CSR_NoFrameFound              ; no defined frame, nothing will be displayed
        leay  b,y                           ; read image subset index
        sty   rsv_mapping_frame,u
        bra CSR_CVP_Continue        
           
CSR_NoFrameFound
        ldy   #$0000        
        sty   rsv_mapping_frame,u

CSR_CVP_Continue        
        ldb   y_pixel,u                               ; check if sprite is fully in screen vertical range
        ldy   rsv_image_subset,u
        addb  image_subset_y1_offset,y
        cmpb  #screen_bottom
        bhi   CSR_SetOutOfRange
        cmpb  #screen_top
        blo   CSR_SetOutOfRange        
        stb   rsv_y1_pixel,u
        ldy   image_set,u
        addb  image_y_size,y
        cmpb  #screen_bottom
        bhi   CSR_SetOutOfRange
        cmpb  #screen_top
        blo   CSR_SetOutOfRange        
        stb   rsv_y2_pixel,u
        cmpb  rsv_y1_pixel,u                          ; check wrapping
        blo   CSR_SetOutOfRange
                
        lda   render_flags,u                          ; check if sprite is fully in screen horizontal range
        bita  #render_xloop_mask
        bne   CSR_DontCheckXFrontier   
        
        ldb   x_pixel,u
        ldy   rsv_image_subset,u
        addb  image_subset_x1_offset,y
        cmpb  #screen_right
        bhi   CSR_SetOutOfRange
        cmpb  #screen_left
        blo   CSR_SetOutOfRange
        stb   rsv_x1_pixel,u
        ldy   image_set,u
        addb  image_x_size,y
        cmpb  #screen_right
        bhi   CSR_SetOutOfRange
        cmpb  #screen_left
        blo   CSR_SetOutOfRange
        stb   rsv_x2_pixel,u
        cmpb  rsv_x1_pixel,u                          ; check wrapping
        blo   CSR_SetOutOfRange 
                
        bra   CSR_DontCheckXFrontier_end        
        
CSR_DontCheckXFrontier  
        ldb   x_pixel,u
        ldy   rsv_image_subset,u
        addb  image_subset_x1_offset,y
        stb   rsv_x1_pixel,u
        
        ldy   image_set,u
        addb  image_x_size,y
        stb   rsv_x2_pixel,u      

CSR_DontCheckXFrontier_end        
        lda   rsv_render_flags,u
        anda  #:rsv_render_outofrange_mask  ; unset out of range flag
        sta   rsv_render_flags,u
        bra   CSR_CheckErase
                
CSR_SetOutOfRange
        lda   rsv_render_flags,u
        ora   #rsv_render_outofrange_mask   ; set out of range flag
        sta   rsv_render_flags,u

CSR_CheckErase
        stx   CSR_CheckDraw+1
        lda   buf_priority,x
        cmpa  cur_priority 
        lbne  CSR_CheckDraw
        
        ldy   cur_ptr_sub_obj_erase
        
        lda   rsv_render_flags,u
        anda  #rsv_render_outofrange_mask
        beq   CSR_CheckErase_InRange
        lda   buf_prev_render_flags,x
        lbpl  CSR_SetEraseDrawFalse         ; branch if object is not on screen    
        bra   CSR_SetEraseTrue
                
CSR_CheckErase_InRange        
        lda   buf_prev_render_flags,x
        lbpl  CSR_SetEraseFalse             ; branch if object is not on screen
        ldd   xy_pixel,u
        lsra                                ; x position precision is x_pixel/2 and mapping_frame with or without 1px shit, y position precision is y_pixel  
        cmpd  buf_prev_xy_pixel,x
        bne   CSR_SetEraseTrue              ; branch if object moved since last frame
        ldd   rsv_mapping_frame,u
        cmpd  buf_prev_mapping_frame,x
        bne   CSR_SetEraseTrue              ; branch if object image changed since last frame
        lda   priority,u
        cmpa  buf_priority,x
        bne   CSR_SetEraseTrue              ; branch if object priority changed since last frame
        bra   CSR_SubEraseSpriteSearchInit  ; branch if object is on screen but unchanged since last frame
        
CSR_SetEraseTrue        
        lda   rsv_render_flags,u
        ora   #rsv_render_erasesprite_mask
        sta   rsv_render_flags,u
        
        stu   ,y++
        sty   cur_ptr_sub_obj_erase
                
        lbra   CSR_CheckDraw
        
CSR_SubEraseSpriteSearchInit

        * search a collision with a sprite under the current sprite
        * the sprite under should have to be erased or displayed
        * in this case it forces the refresh of the current sprite that was not supposed to be refreshed
        * as a sub loop, this should be optimized as much as possible ... I hope it is
        * there are two lists because a sprite can be erased at a position
        * and displayed at another position : both cases should be tested !

        ldx   cur_ptr_sub_obj_erase       
        lda   Glb_Cur_Wrk_Screen_Id         ; read current screen buffer for write operations
        bne   CSR_SubEraseSearchB1
        
CSR_SubEraseSearchB0
        cmpx  #Tbl_Sub_Object_Erase
        beq   CSR_SubDrawSpriteSearchInit   ; branch if no more sub objects
        ldy   ,--x
        
CSR_SubEraseCheckCollisionB0
        ldd   rsv_prev_xy1_pixel_0,y        ; sub entry : rsv_prev_x_pixel_0 and rsv_prev_y_pixel_0 in one instruction
        cmpa  rsv_x2_pixel,u                ;     entry : x_pixel + rsv_mapping_frame.x_size
        bhi   CSR_SubEraseSearchB0
        cmpb  rsv_y2_pixel,u                ;     entry : y_pixel + rsv_mapping_frame.y_size
        bhi   CSR_SubEraseSearchB0
        ldd   rsv_prev_xy2_pixel_0,y        ; sub entry : rsv_prev_x_pixel_0 + rsv_prev_mapping_frame_0.x_size and rsv_prev_y_pixel_0 + rsv_prev_mapping_frame_0.y_size in one instruction
        cmpa  rsv_x1_pixel,u                ;     entry : x_pixel
        blo   CSR_SubEraseSearchB0
        cmpb  rsv_y1_pixel,u                ;     entry : y_pixel
        blo   CSR_SubEraseSearchB0
        
        ldy   cur_ptr_sub_obj_erase
        bra   CSR_SetEraseTrue              ; found a collision

CSR_SubEraseSearchB1
        cmpx  #Tbl_Sub_Object_Erase
        beq   CSR_SubDrawSpriteSearchInit   ; branch if no more sub objects
        ldy   ,--x
        
CSR_SubEraseCheckCollisionB1
        ldd   rsv_prev_xy1_pixel_1,y        ; sub entry : rsv_prev_x_pixel_1 and rsv_prev_y_pixel_1 in one instruction
        cmpa  rsv_x2_pixel,u                ;     entry : x_pixel + rsv_mapping_frame.x_size
        bhi   CSR_SubEraseSearchB1
        cmpb  rsv_y2_pixel,u                ;     entry : y_pixel + rsv_mapping_frame.y_size
        bhi   CSR_SubEraseSearchB1
        ldd   rsv_prev_xy2_pixel_1,y        ; sub entry : rsv_prev_x_pixel_1 + rsv_prev_mapping_frame_1.x_size and rsv_prev_y_pixel_1 + rsv_prev_mapping_frame_1.y_size in one instruction
        cmpa  rsv_x1_pixel,u                ;     entry : x_pixel
        blo   CSR_SubEraseSearchB1
        cmpb  rsv_y1_pixel,u                ;     entry : y_pixel
        blo   CSR_SubEraseSearchB1
        
        ldy   cur_ptr_sub_obj_erase
        bra   CSR_SetEraseTrue              ; found a collision

CSR_SubDrawSpriteSearchInit
        ldx   cur_ptr_sub_obj_draw
        
CSR_SubDrawSearch
        cmpx  #Tbl_Sub_Object_Draw
        beq   CSR_SetEraseFalse             ; branch if no more sub objects
        ldy   ,--x

CSR_SubDrawCheckCollision
        ldd   rsv_xy1_pixel,y               ; sub entry : x_pixel and y_pixel in one instruction
        cmpa  rsv_x2_pixel,u                ;     entry : x_pixel + rsv_mapping_frame.x_size
        bhi   CSR_SubDrawSearch
        cmpb  rsv_y2_pixel,u                ;     entry : y_pixel + rsv_mapping_frame.y_size
        bhi   CSR_SubDrawSearch
        ldd   rsv_xy2_pixel,y               ; sub entry : x_pixel + rsv_mapping_frame.x_size and y_pixel + rsv_mapping_frame.y_size in one instruction
        cmpa  rsv_x1_pixel,u                ;     entry : x_pixel
        blo   CSR_SubDrawSearch
        cmpb  rsv_y1_pixel,u                ;     entry : y_pixel
        blo   CSR_SubDrawSearch
        
        ldy   cur_ptr_sub_obj_erase
        lbra  CSR_SetEraseTrue              ; found a collision

CSR_SetEraseFalse
        lda   rsv_render_flags,u 
        anda  #:rsv_render_erasesprite_mask
        sta   rsv_render_flags,u        
               
CSR_CheckDraw
        ldx   #$FFFF                        ; dynamic restore x
        lda   priority,u
        cmpa  cur_priority 
        lbne  CSR_NextObject
        
        ldy   cur_ptr_sub_obj_draw
        
        lda   rsv_render_flags,u
        anda  #rsv_render_outofrange_mask
        bne   CSR_SetDrawFalse              ; branch if object image is out of range
        ldd   rsv_mapping_frame,u
        beq   CSR_SetDrawFalse              ; branch if object have no image
        lda   render_flags,u
        anda  #render_hide_mask
        bne   CSR_SetDrawFalse              ; branch if object is hidden
        
CSR_SetDrawTrue 
        lda   rsv_render_flags,u
        ora   #rsv_render_displaysprite_mask ; set displaysprite flag   
        sta   rsv_render_flags,u         
        
        bita  #rsv_render_erasesprite_mask
        beq   CSR_SDT1
        bra   CSR_SDT2
CSR_SDT1                      
        ldb   buf_prev_render_flags,x
        bmi   CSR_SetHide
        bra   CSR_SDT3      
CSR_SDT2                      
        ldb   buf_prev_render_flags,x
        bpl   CSR_SetHide
CSR_SDT3
        stu   ,y++
        sty   cur_ptr_sub_obj_draw          ; maintain list of changing sprites to draw, should be to draw and ((on screen and to erase) or (not on screen and not to erase)) 

CSR_SetHide        
        lda   render_flags,u
        ora   #render_hide_mask             ; set hide flag
        sta   render_flags,u        
        
        ldu   buf_priority_next_obj,x
        lbne  CSR_ProcessEachPriorityLevel   
        rts

CSR_SetEraseDrawFalse 
        lda   rsv_render_flags,u 
        anda  #:rsv_render_erasesprite_mask
        sta   rsv_render_flags,u 

CSR_SetDrawFalse 
        lda   rsv_render_flags,u
        anda  #:rsv_render_displaysprite_mask
        sta   rsv_render_flags,u
        
        ldu   buf_priority_next_obj,x
        lbne   CSR_ProcessEachPriorityLevel   
        rts      


(include)ERASESPR
* ---------------------------------------------------------------------------
* EraseSprites
* ------------
* Subroutine to erase sprites on screen
* Read Display Priority Structure (front to back)
* priority: 0 - unregistred
* priority: 1 - register non moving overlay sprite
* priority; 2-8 - register moving sprite (2:front, ..., 8:back)  
*
* input REG : none
* ---------------------------------------------------------------------------
									   
EraseSprites

ESP_Start
        lda   Glb_Cur_Wrk_Screen_Id         ; read current screen buffer for write operations
        bne   ESP_P1B1

ESP_P1B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+2 ; read DPS from priority 1 to priority 8
        beq   ESP_P2B0
        lda   #$01
        sta   ESP_CheckPriorityB0+1        
        jsr   ESP_ProcessEachPriorityLevelB0
ESP_P2B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+4
        beq   ESP_P3B0
        lda   #$02
        sta   ESP_CheckPriorityB0+1        
        jsr   ESP_ProcessEachPriorityLevelB0   
ESP_P3B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+6
        beq   ESP_P4B0
        lda   #$03
        sta   ESP_CheckPriorityB0+1        
        jsr   ESP_ProcessEachPriorityLevelB0   
ESP_P4B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+8
        beq   ESP_P5B0
        lda   #$04
        sta   ESP_CheckPriorityB0+1        
        jsr   ESP_ProcessEachPriorityLevelB0   
ESP_P5B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+10
        beq   ESP_P6B0
        lda   #$05
        sta   ESP_CheckPriorityB0+1        
        jsr   ESP_ProcessEachPriorityLevelB0               
ESP_P6B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+12
        beq   ESP_P7B0
        lda   #$06
        sta   ESP_CheckPriorityB0+1        
        jsr   ESP_ProcessEachPriorityLevelB0      
ESP_P7B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+14
        beq   ESP_P8B0
        lda   #$07
        sta   ESP_CheckPriorityB0+1        
        jsr   ESP_ProcessEachPriorityLevelB0  
ESP_P8B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+16
        beq   ESP_rtsB0
        lda   #$08
        sta   ESP_CheckPriorityB0+1                   
        jsr   ESP_ProcessEachPriorityLevelB0
ESP_rtsB0        
        rts
        
ESP_P1B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+2 ; read DPS from priority 1 to priority 8
        beq   ESP_P2B1
        lda   #$01
        sta   ESP_CheckPriorityB1+1        
        jsr   ESP_ProcessEachPriorityLevelB1
ESP_P2B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+4
        beq   ESP_P3B1
        lda   #$02
        sta   ESP_CheckPriorityB1+1        
        jsr   ESP_ProcessEachPriorityLevelB1   
ESP_P3B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+6
        beq   ESP_P4B1
        lda   #$03
        sta   ESP_CheckPriorityB1+1        
        jsr   ESP_ProcessEachPriorityLevelB1   
ESP_P4B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+8
        beq   ESP_P5B1
        lda   #$04
        sta   ESP_CheckPriorityB1+1        
        jsr   ESP_ProcessEachPriorityLevelB1   
ESP_P5B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+10
        beq   ESP_P6B1
        lda   #$05
        sta   ESP_CheckPriorityB1+1        
        jsr   ESP_ProcessEachPriorityLevelB1               
ESP_P6B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+12
        beq   ESP_P7B1
        lda   #$06
        sta   ESP_CheckPriorityB1+1        
        jsr   ESP_ProcessEachPriorityLevelB1      
ESP_P7B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+14
        beq   ESP_P8B1
        lda   #$07
        sta   ESP_CheckPriorityB1+1        
        jsr   ESP_ProcessEachPriorityLevelB1  
ESP_P8B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+16
        beq   ESP_rtsB1
        lda   #$08
        sta   ESP_CheckPriorityB1+1        
        jsr   ESP_ProcessEachPriorityLevelB1
ESP_rtsB1        
        rts

* *******
* BUFFER0
* *******

ESP_ProcessEachPriorityLevelB0
        lda   rsv_priority_0,u
        
ESP_CheckPriorityB0
        cmpa  #0                            ; dynamic current priority
        bne   ESP_NextObjectB0              ; do not process this entry (case of priority change)
        
ESP_UnsetCheckRefreshB0
        lda   rsv_render_flags,u
        ldb   render_flags,u
        andb  #render_motionless_mask
        bne   ESP_CheckEraseB0
        anda  #:rsv_render_checkrefresh_mask ; unset checkrefresh flag
        sta   rsv_render_flags,u        
        
ESP_CheckEraseB0
        anda  #rsv_render_erasesprite_mask
        beq   ESP_NextObjectB0
        ldb   rsv_prev_render_flags_0,u
        andb  #rsv_prev_render_overlay_mask
        bne   ESP_UnsetOnScreenFlagB0
        
ESP_CallEraseRoutineB0
        stu   ESP_CallEraseRoutineB0_00+1   ; backup u (pointer to object)
        ldx   rsv_prev_mapping_frame_0,u    ; load previous image to erase (for this buffer) 
        lda   page_erase_routine,x
        sta   $E7E5                         ; select page in RAM (A000-DFFF)
        ldu   rsv_bgdata_0,u                ; cell_start background data
        jsr   [erase_routine,x]             ; erase sprite on working screen buffer
        leay  ,u                            ; cell_end background data stored in y
ESP_CallEraseRoutineB0_00        
        ldu   #$0000                        ; restore u (pointer to object)
        ldd   rsv_bgdata_0,u                ; cell_start
        subd  #16
        andb  #256-cell_size                ; round cell_start to cell size
        tfr   d,x                           ; cell_start rounded stored in x
                        
ESP_FreeEraseBufferB0
        jsr   BgBufferFree                  ; free background data in memory
        
ESP_UnsetOnScreenFlagB0
        lda   rsv_prev_render_flags_0,u
        anda  #:rsv_prev_render_onscreen_mask,u ; sprite is no longer on screen
        sta   rsv_prev_render_flags_0,u

ESP_NextObjectB0
        ldu   rsv_priority_prev_obj_0,u
        bne   ESP_ProcessEachPriorityLevelB0   
        rts           

* *******        
* BUFFER1
* *******        
                
ESP_ProcessEachPriorityLevelB1
        lda   rsv_priority_1,u
        
ESP_CheckPriorityB1
        cmpa  #0                            ; dynamic current priority
        bne   ESP_NextObjectB1              ; do not process this entry (case of priority change)
        
ESP_UnsetCheckRefreshB1
        lda   rsv_render_flags,u
        ldb   render_flags,u
        andb  #render_motionless_mask
        bne   ESP_CheckEraseB1
        anda  #:rsv_render_checkrefresh_mask ; unset checkrefresh flag (CheckSpriteRefresh)
        sta   rsv_render_flags,u        
        
ESP_CheckEraseB1
        anda  #rsv_render_erasesprite_mask
        beq   ESP_NextObjectB1
        ldb   rsv_prev_render_flags_1,u
        andb  #rsv_prev_render_overlay_mask
        bne   ESP_UnsetOnScreenFlagB1        
        
ESP_CallEraseRoutineB1
        stu   ESP_CallEraseRoutineB1_00+1   ; backup u (pointer to object)
        ldx   rsv_prev_mapping_frame_1,u    ; load previous image to erase (for this buffer) 
        lda   page_erase_routine,x
        sta   $E7E5                         ; select page 04 in RAM (A000-DFFF)
        ldu   rsv_bgdata_1,u                ; cell_start background data
        jsr   [erase_routine,x]             ; erase sprite on working screen buffer
        leay  ,u                            ; cell_end background data stored in y
ESP_CallEraseRoutineB1_00        
        ldu   #$0000                        ; restore u (pointer to object)
        ldd   rsv_bgdata_1,u                ; cell_start
        subd  #16
        andb  #256-cell_size                ; round cell_start to cell size
        tfr   d,x                           ; cell_start rounded stored in x
                        
ESP_FreeEraseBufferB1
        jsr   BgBufferFree                  ; free background data in memory
        
ESP_UnsetOnScreenFlagB1
        lda   rsv_prev_render_flags_1,u
        anda  #:rsv_prev_render_onscreen_mask,u ; sprite is no longer on screen
        sta   rsv_prev_render_flags_1,u
        
ESP_NextObjectB1
        ldu   rsv_priority_prev_obj_1,u
        bne   ESP_ProcessEachPriorityLevelB1   
        rts        

(include)UNSETDSP
* ---------------------------------------------------------------------------
* UnsetDisplayPriority
* --------------------
* Subroutine to unset sprites in Display Sprite Priority structure
* Read Lst_Priority_Unset_0/1
*
* input REG : none
* ---------------------------------------------------------------------------
									   
UnsetDisplayPriority

UDP_Start
        lda   Glb_Cur_Wrk_Screen_Id         ; read current screen buffer for write operations
        bne   UDP_B1
        
UDP_B0                                    
        ldx   #Lst_Priority_Unset_0+2
        
UDP_CheckEndB0        
        cmpx  Lst_Priority_Unset_0          ; end of priority unset list
        bne   UDP_CheckPrioPrevB0
        
UDP_InitListB0      
        ldx   #Lst_Priority_Unset_0+2 
        stx   Lst_Priority_Unset_0          ; set Lst_Priority_Unset_0 index
        rts
        
UDP_CheckPrioPrevB0
        ldu   ,x++
        ldd   rsv_priority_prev_obj_0,u
        bne   UDP_ChainPrevB0
        
        lda   rsv_priority_0,u
        lsla
        ldy   #Tbl_Priority_First_Entry_0
        leay  a,y
        ldd   rsv_priority_next_obj_0,u
        std   ,y
        bra   UDP_CheckPrioNextB0
                
UDP_ChainPrevB0
        ldd   rsv_priority_next_obj_0,u
        ldy   rsv_priority_prev_obj_0,u        
        std   rsv_priority_next_obj_0,y        

UDP_CheckPrioNextB0       
        ldd   rsv_priority_next_obj_0,u
        bne   UDP_ChainNextB0

        lda   rsv_priority_0,u
        lsla
        ldy   #Tbl_Priority_Last_Entry_0
        leay  a,y
        ldd   rsv_priority_prev_obj_0,u
        std   ,y
        bra   UDP_CheckDeleteB0
                
UDP_ChainNextB0
        ldd   rsv_priority_prev_obj_0,u
        ldy   rsv_priority_next_obj_0,u        
        std   rsv_priority_prev_obj_0,y
        
UDP_CheckDeleteB0
        lda   render_flags,u
        anda  #render_todelete_mask
        beq   UDP_SetNewPrioB0
        lda   rsv_prev_render_flags_0,u
        bmi   UDP_SetNewPrioB0
        lda   rsv_prev_render_flags_1,u
        bmi   UDP_SetNewPrioB0
        jsr   ClearObj
        bra   UDP_CheckEndB0
        
UDP_SetNewPrioB0
        lda   priority,u
        sta   rsv_priority_0,u
        bra   UDP_CheckEndB0        

UDP_B1                                    
        ldx   #Lst_Priority_Unset_1+2
        
UDP_CheckEndB1        
        cmpx  Lst_Priority_Unset_1          ; end of priority unset list
        bne   UDP_CheckPrioPrevB1
        
UDP_InitListB1      
        ldx   #Lst_Priority_Unset_1+2 
        stx   Lst_Priority_Unset_1          ; set Lst_Priority_Unset_0 index
        rts
        
UDP_CheckPrioPrevB1
        ldu   ,x++
        ldd   rsv_priority_prev_obj_1,u
        bne   UDP_ChainPrevB1
        
        lda   rsv_priority_1,u
        lsla
        ldy   #Tbl_Priority_First_Entry_1
        leay  a,y
        ldd   rsv_priority_next_obj_1,u
        std   ,y
        bra   UDP_CheckPrioNextB1
                
UDP_ChainPrevB1
        ldd   rsv_priority_next_obj_1,u
        ldy   rsv_priority_prev_obj_1,u        
        std   rsv_priority_next_obj_1,y        

UDP_CheckPrioNextB1       
        ldd   rsv_priority_next_obj_1,u
        bne   UDP_ChainNextB1

        lda   rsv_priority_1,u
        lsla
        ldy   #Tbl_Priority_Last_Entry_1
        leay  a,y
        ldd   rsv_priority_prev_obj_1,u
        std   ,y
        bra   UDP_CheckDeleteB1
                
UDP_ChainNextB1
        ldd   rsv_priority_prev_obj_1,u
        ldy   rsv_priority_next_obj_1,u        
        std   rsv_priority_prev_obj_1,y
        
UDP_CheckDeleteB1
        lda   render_flags,u
        anda  #render_todelete_mask
        beq   UDP_SetNewPrioB1
        lda   rsv_prev_render_flags_0,u
        bmi   UDP_SetNewPrioB1
        lda   rsv_prev_render_flags_1,u
        bmi   UDP_SetNewPrioB1
        jsr   ClearObj
        bra   UDP_CheckEndB1
        
UDP_SetNewPrioB1
        lda   priority,u
        sta   rsv_priority_1,u
        bra   UDP_CheckEndB1

(include)DRAWSPR
* ---------------------------------------------------------------------------
* DrawSprites
* ------------
* Subroutine to draw sprites on screen
* Read Display Priority Structure (back to front)
* priority: 0 - unregistred
* priority: 1 - register non moving overlay sprite
* priority; 2-8 - register moving sprite (2:front, ..., 8:back)  
*
* input REG : none
* ---------------------------------------------------------------------------
									   
DrawSprites

DRS_Start
        lda   Glb_Cur_Wrk_Screen_Id         ; read current screen buffer for write operations
        bne   DRS_P8B1
        
DRS_P8B0                                    
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+16 ; read DPS from priority 8 to priority 1
        beq   DRS_P7B0
        jsr   DRS_ProcessEachPriorityLevelB0   
DRS_P7B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+14
        beq   DRS_P6B0
        jsr   DRS_ProcessEachPriorityLevelB0  
DRS_P6B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+12
        beq   DRS_P5B0
        jsr   DRS_ProcessEachPriorityLevelB0  
DRS_P5B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+10
        beq   DRS_P4B0
        jsr   DRS_ProcessEachPriorityLevelB0  
DRS_P4B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+8
        beq   DRS_P3B0
        jsr   DRS_ProcessEachPriorityLevelB0              
DRS_P3B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+6
        beq   DRS_P2B0
        jsr   DRS_ProcessEachPriorityLevelB0     
DRS_P2B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+4
        beq   DRS_P1B0
        jsr   DRS_ProcessEachPriorityLevelB0 
DRS_P1B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+2
        beq   DRS_rtsB0
        jsr   DRS_ProcessEachPriorityLevelB0
DRS_rtsB0        
        rts
        
DRS_P8B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+16 ; read DPS from priority 8 to priority 1
        beq   DRS_P7B1
        jsr   DRS_ProcessEachPriorityLevelB1   
DRS_P7B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+14
        beq   DRS_P6B1
        jsr   DRS_ProcessEachPriorityLevelB1   
DRS_P6B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+12
        beq   DRS_P5B1
        jsr   DRS_ProcessEachPriorityLevelB1   
DRS_P5B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+10
        beq   DRS_P4B1
        jsr   DRS_ProcessEachPriorityLevelB1   
DRS_P4B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+8
        beq   DRS_P3B1
        jsr   DRS_ProcessEachPriorityLevelB1             
DRS_P3B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+6
        beq   DRS_P2B1
        jsr   DRS_ProcessEachPriorityLevelB1    
DRS_P2B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+4
        beq   DRS_P1B1
        jsr   DRS_ProcessEachPriorityLevelB1
DRS_P1B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+2
        beq   DRS_rtsB1
        jsr   DRS_ProcessEachPriorityLevelB1
DRS_rtsB1        
        rts

DRS_ProcessEachPriorityLevelB0
        lda   rsv_render_flags,x
        anda  #rsv_render_displaysprite_mask
        beq   DRS_NextObjectB0
        lda   rsv_prev_render_flags_0,x
        bmi   DRS_NextObjectB0
        lda   render_flags,x
        anda  #render_overlay_mask
        bne   DRS_DrawWithoutBackupB0
        ldu   rsv_mapping_frame,x
        lda   erase_nb_cell,u        
        jsr   BgBufferAlloc                 ; allocate free space to store sprite background data
        cmpy  #$0000                        ; y contains cell_end of allocated space 
        beq   DRS_NextObjectB0              ; branch if no more free space
        ldd   xy_pixel,x                    ; load x position (48-207) and y position (28-227) in one operation
        suba  rsv_image_center_offset,x
        jsr   DRS_XYToAddress
*        ldu   rsv_image_subset,x
*        stu   rsv_prev_image_subset_0,x        
        ldu   rsv_mapping_frame,x           ; load image to draw
        stu   rsv_prev_mapping_frame_0,x    ; save previous mapping_frame
        lda   page_draw_routine,u
        sta   $E7E5                         ; select page in RAM (A000-DFFF)
        stx   DRS_dyn3B0+1                  ; save x reg
        ldx   draw_routine,u        
        leau  ,y                            ; cell_end for background data
        ldy   #Glb_Sprite_Screen_Pos_Part2  ; position is a parameter, it allows different Main engines
        ldd   Glb_Sprite_Screen_Pos_Part1   ; to be used with compiled sprites in a single program
        jsr   ,x                            ; backup background and draw sprite on working screen buffer
DRS_dyn3B0        
        ldx   #$0000                        ; (dynamic) restore x reg
        stu   rsv_bgdata_0,x                ; store pointer to saved background data
        ldd   xy_pixel,x                    ; load x position (48-207) and y position (28-227) in one operation
        lsra                                ; x position precision is x_pixel/2 and mapping_frame with or without 1px shit
        std   rsv_prev_xy_pixel_0,x         ; save previous x_pixel and y_pixel in one operation             
        ldd   rsv_xy1_pixel,x               ; load x' and y' in one operation
        std   rsv_prev_xy1_pixel_0,x        ; save as previous x' and y'        
        ldd   rsv_xy2_pixel,x               ; load x'' and y'' in one operation
        std   rsv_prev_xy2_pixel_0,x        ; save as previous x'' and y''
        lda   rsv_prev_render_flags_0,x
        ora   #rsv_prev_render_onscreen_mask
        ldb   render_flags,x
        bitb  #render_overlay_mask
        beq   DRS_NoOverlayB0
        ora   #rsv_prev_render_overlay_mask
        bra   DRS_UpdateRenderFlagB0
        
DRS_NoOverlayB0
        anda   #:rsv_prev_render_overlay_mask

DRS_UpdateRenderFlagB0        
        sta   rsv_prev_render_flags_0,x     ; set the onscreen flag and save overlay flag
        
DRS_NextObjectB0        
        ldx   rsv_priority_next_obj_0,x
        lbne  DRS_ProcessEachPriorityLevelB0   
        rts
        
DRS_DrawWithoutBackupB0
        ldd   xy_pixel,x                    ; load x position (48-207) and y position (28-227) in one operation
        suba  rsv_image_center_offset,x        
        jsr   DRS_XYToAddress
        ldu   rsv_mapping_frame,x      ; load image to draw
        stu   rsv_prev_mapping_frame_0,x    ; save previous mapping_frame
        lda   page_draw_routine,u
        sta   $E7E5                         ; select page in RAM (A000-DFFF)
        stx   DRS_dyn3B0+1                  ; save x reg
        ldx   draw_routine,u        
        ldy   #Glb_Sprite_Screen_Pos_Part2  ; position is a parameter, it allows different Main engines
        ldd   Glb_Sprite_Screen_Pos_Part1   ; to be used with compiled sprites in a single program
        jsr   ,x                            ; draw sprite on working screen buffer
        bra   DRS_dyn3B0          

********************************************************************************
* x_pixel and y_pixel coordinate system
* x coordinates:
*    - off-screen left 00-2F (0-47)
*    - on screen 30-CF (48-207)
*    - off-screen right D0-FF (208-255)
*
* y coordinates:
*    - off-screen top 00-1B (0-27)
*    - on screen 1C-E3 (28-227)
*    - off-screen bottom E4-FF (228-255)
********************************************************************************

DRS_XYToAddress
        suba  #$30
        bcc   DRS_XYToAddressPositive
        suba  #$60                          ; get x position one line up, skipping (160-255)
        decb
DRS_XYToAddressPositive        
        subb  #$1C                          ; TODO same thing as x for negative case
        lsra                                ; x=x/2, sprites moves by 2 pixels on x axis
        lsra                                ; x=x/2, RAMA RAMB enterlace  
        bcs   DRS_XYToAddressRAM2First      ; Branch if write must begin in RAMB first
DRS_XYToAddressRAM1First
        sta   DRS_dyn1+2
        lda   #$28                          ; 40 bytes per line in RAMA or RAMB
        mul
DRS_dyn1        
        addd  #$0000                        ; (dynamic) RAMA start at $0000
        std   Glb_Sprite_Screen_Pos_Part2
        ora   #$20                          ; add $2000 to d register
        std   Glb_Sprite_Screen_Pos_Part1     
        rts
DRS_XYToAddressRAM2First
        sta   DRS_dyn2+2
        lda   #$28                          ; 40 bytes per line in RAMA or RAMB
        mul
DRS_dyn2        
        addd  #$2000                        ; (dynamic) RAMB start at $0000
        std   Glb_Sprite_Screen_Pos_Part2
        subd  #$1FFF
        std   Glb_Sprite_Screen_Pos_Part1
        rts
        
DRS_ProcessEachPriorityLevelB1
        lda   rsv_render_flags,x
        anda  #rsv_render_displaysprite_mask
        beq   DRS_NextObjectB1
        lda   rsv_prev_render_flags_1,x
        bmi   DRS_NextObjectB1
        lda   render_flags,x
        anda  #render_overlay_mask
        bne   DRS_DrawWithoutBackupB1
        ldu   rsv_mapping_frame,x
        lda   erase_nb_cell,u        
        jsr   BgBufferAlloc                 ; allocate free space to store sprite background data
        cmpy  #$0000                        ; y contains cell_end of allocated space 
        beq   DRS_NextObjectB1              ; branch if no more free space
        ldd   xy_pixel,x                    ; load x position (48-207) and y position (28-227) in one operation
        suba  rsv_image_center_offset,x
        jsr   DRS_XYToAddress
        *ldu   rsv_image_subset,x
        *stu   rsv_prev_image_subset_1,x          
        ldu   rsv_mapping_frame,x      ; load image to draw
        stu   rsv_prev_mapping_frame_1,x    ; save previous mapping_frame 
        lda   page_draw_routine,u
        sta   $E7E5                         ; select page in RAM (A000-DFFF)
        stx   DRS_dyn3B1+1                  ; save x reg
        ldx   draw_routine,u        
        leau  ,y                            ; cell_end for background data
        ldy   #Glb_Sprite_Screen_Pos_Part2  ; position is a parameter, it allows different Main engines
        ldd   Glb_Sprite_Screen_Pos_Part1   ; to be used with compiled sprites in a single program
        jsr   ,x                            ; backup background and draw sprite on working screen buffer
DRS_dyn3B1        
        ldx   #$0000                        ; (dynamic) restore x reg
        stu   rsv_bgdata_1,x                ; store pointer to saved background data
        ldd   xy_pixel,x                    ; load x position (48-207) and y position (28-227) in one operation
        lsra                                ; x position precision is x_pixel/2 and mapping_frame with or without 1px shit
        std   rsv_prev_xy_pixel_1,x         ; save previous x_pixel and y_pixel in one operation         
        ldd   rsv_xy1_pixel,x               ; load x' and y' in one operation
        std   rsv_prev_xy1_pixel_1,x        ; save as previous x' and y'        
        ldd   rsv_xy2_pixel,x               ; load x'' and y'' in one operation
        std   rsv_prev_xy2_pixel_1,x        ; save as previous x'' and y''
        lda   rsv_prev_render_flags_1,x
        ora   #rsv_prev_render_onscreen_mask
        ldb   render_flags,x
        bitb  #render_overlay_mask
        beq   DRS_NoOverlayB1
        ora   #rsv_prev_render_overlay_mask
        bra   DRS_UpdateRenderFlagB1
        
DRS_NoOverlayB1
        anda   #:rsv_prev_render_overlay_mask

DRS_UpdateRenderFlagB1
        sta   rsv_prev_render_flags_1,x     ; set the onscreen flag and save overlay flag
                
DRS_NextObjectB1        
        ldx   rsv_priority_next_obj_1,x
        lbne  DRS_ProcessEachPriorityLevelB1   
        rts
        
DRS_DrawWithoutBackupB1
        ldd   xy_pixel,x                    ; load x position (48-207) and y position (28-227) in one operation
        suba  rsv_image_center_offset,x        
        jsr   DRS_XYToAddress
        ldu   rsv_mapping_frame,x      ; load image to draw
        stu   rsv_prev_mapping_frame_1,x    ; save previous mapping_frame        
        lda   page_draw_routine,u
        sta   $E7E5                         ; select page in RAM (A000-DFFF)
        stx   DRS_dyn3B1+1                  ; save x reg
        ldx   draw_routine,u        
        ldy   #Glb_Sprite_Screen_Pos_Part2  ; position is a parameter, it allows different Main engines
        ldd   Glb_Sprite_Screen_Pos_Part1   ; to be used with compiled sprites in a single program
        jsr   ,x                            ; draw sprite on working screen buffer
        bra   DRS_dyn3B1

(include)BGBALLOC
* ---------------------------------------------------------------------------
* BgBufferAlloc
* -------------
* Subroutine to allocate memory into background buffer
*
* input  REG : [a] number of requested cells
* output REG : [y] cell_end or 0000 if no more space
* ---------------------------------------------------------------------------

BgBufferAlloc
        pshs  b,x
        ldb   Glb_Cur_Wrk_Screen_Id         ; read current screen buffer for write operations
        bne   BBA1                          ; branch if buffer 1 is current
        
BBA0        
        ldx   #Lst_FreeCellFirstEntry_0     ; save previous cell.next_entry into x for future update
        ldy   Lst_FreeCellFirstEntry_0      ; load first cell for screen buffer 0
        bra   BBA_Next
        
BBA1        
        ldx   #Lst_FreeCellFirstEntry_1     ; save previous cell.next_entry into x for future update
        ldy   Lst_FreeCellFirstEntry_1      ; load first cell for screen buffer 1
        
BBA_Next
        beq   BBA_rts                       ; loop thru all entries, branch if no more free space
        cmpa  nb_cells,y                    ; compare current nb of free cells with requested
        beq   BBA_FitCell                   ; branch if current free cells is the same size than requested
        bls   BBA_DivideCell                ; branch if current free cells are greater than requested
        leax  next_entry,y                  ; save previous cell.next_entry into x for future update        
        ldy   next_entry,y                  ; move to next entry
        bra   BBA_Next
          
BBA_FitCell
        ldd   next_entry,y
        std   ,x                            ; chain previous cell with next cell
        clr   nb_cells,y                    ; delete current cell
        ldy   cell_end,y                    ; return cell_end
        bra   BBA_rts
        
BBA_DivideCell
        sta   BBA_dyn+1
        ldb   nb_cells,y
BBA_dyn
        subb  #$00                          ; substract requested cells to nb_cells
        stb   nb_cells,y                    ; update nb_cells
        
        ldb   #cell_size
        mul
        eora  #$FF                          ; set negative
        eorb  #$FF                          ; set negative        
        addd  #$01
        ldx   cell_end,y
        stx   cell_end_return+2        
        leax  d,x                           ; cell_end = cell_end - (number of requested cells * nb of bytes in a cell)
        stx   cell_end,y                    ; update cell_end
cell_end_return        
        ldy   #$0000
BBA_rts
        puls  b,x,pc

(include)BGBFREE
* ---------------------------------------------------------------------------
* BgBufferFree
* ------------
* Subroutine to free memory from background buffer
*
* input  REG : [x] cell_start
*              [y] cell_end
* output REG : none
* ---------------------------------------------------------------------------

BgBufferFree
        pshs  d,u
        ldd   #$0000
        std   BBF_SetNewEntryNextentry+1    ; init next entry of new entry to 0000
        ldb   Glb_Cur_Wrk_Screen_Id         ; read current screen buffer for write operations
        bne   BBF1                          ; branch if buffer 1 is current
        
BBF0
        ldu   rsv_prev_mapping_frame_0,u     ; get sprite last image for this buffer
        lda   erase_nb_cell,u               ; get nb of cell to free
        ldu   #Lst_FreeCellFirstEntry_0        
        stu   BBF_SetNewEntryPrevLink+1     ; init prev address destination as Lst_FreeCellFirstEntry
        ldu   #Lst_FreeCell_0               ; get cell table for this buffer
        stu   BBF_AddNewEntryAtEnd+1        ; auto-modification to access cell table later
        ldu   Lst_FreeCellFirstEntry_0      ; load first cell for screen buffer 0
        bra   BBF_Next
        
BBF1        
        ldu   rsv_prev_mapping_frame_1,u
        lda   erase_nb_cell,u        
        ldu   #Lst_FreeCellFirstEntry_1        
        stu   BBF_SetNewEntryPrevLink+1        
        ldu   #Lst_FreeCell_1
        stu   BBF_AddNewEntryAtEnd+1        
        ldu   Lst_FreeCellFirstEntry_1
        
BBF_Next        
        beq   BBF_AddNewEntryAtEnd          ; loop thru all entry, branch if no more entry to expand
        cmpy  cell_start,u                  ; compare current cell_start with input param cell_end
        beq   BBF_ExpandAtStart             ; branch if current cell_start equals input param cell_end
        bhi   BBF_ExpandAtEnd               ; branch if current cell_start < input param cell_end
        ldu   next_entry,u                  ; move to next entry
        tfr   u,d
        addd  #next_entry                   ; there is a previous entry, save next_entry address
        std   BBF_SetNewEntryPrevLink+1
        bra   BBF_Next

BBF_AddNewEntry
        stu   BBF_SetNewEntryNextentry+1
BBF_AddNewEntryAtEnd
        ldu   #$0000                        ; (dynamic) first element of the table (Lst_FreeCell_0 or Lst_FreeCell_1)
BBF_FindFreeSlot        
        ldb   nb_cells,u                    ; read Lst_FreeCell as a table (not a linked list)
        beq   BBF_SetNewEntry               ; branch if empty entry
        leau  entry_size,u                  ; move to next entry
        bra   BBF_FindFreeSlot              ; loop     
BBF_SetNewEntry
        sta   nb_cells,u                    ; store released cells
        stx   cell_start,u                  ; store cell start adress
        sty   cell_end,u                    ; store cell end adress
BBF_SetNewEntryNextentry        
        ldx   #$0000                        ; (dynamic) value is dynamically set
        stx   next_entry,u                  ; link to 0000 if no more entry or next_entry
BBF_SetNewEntryPrevLink        
        stu   $FFFF                         ; (dynamic) set Lst_FreeCellFirstEntry or prev_entry.next_entry with new entry
        bra   BBF_rts

BBF_ExpandAtStart
        stx   cell_start,u
        adda  nb_cells,u
        sta   nb_cells,u
        ldy   next_entry,u
        beq   BBF_rts        
BBF_Join
        cmpx  cell_end,y
        bne   BBF_rts
        ldd   cell_start,y
        std   cell_start,u
        lda   nb_cells,y
        adda  nb_cells,u
        sta   nb_cells,u
        clr   nb_cells,y                    ; delete next entry
        ldd   next_entry,y
        std   next_entry,u                  ; join
        bra   BBF_rts

BBF_ExpandAtEnd
        cmpx  cell_end,u
        bne   BBF_AddNewEntry
        sty   cell_end,u
        adda  nb_cells,u
        sta   nb_cells,u
        
BBF_rts
        puls  d,u,pc

(include)CLRCARTM
********************************************************************************
* Clear memory in cardtridge area
********************************************************************************

ClearCartMem *@globals
        pshs  u,dp
        sts   ClearCartMem_3+2
        lds   #$4000
        leau  ,x
        leay  ,x
        tfr   x,d
        tfr   a,dp
ClearCartMem_2
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp
        cmps  #$0010                        
        bne   ClearCartMem_2
        leau  ,s        
ClearCartMem_3        
        lds   #$0000        ; start of memory should not be written with S as an index because of IRQ        
        pshu  d,x,y         ; saving 12 bytes + (2 bytes * _sr calls) inside IRQ routine
        pshu  d,x,y         ; DEPENDENCY on nb of _sr calls inside IRQ routine (here 16 bytes of margin)
        pshu  d,x
        puls  dp,u,pc


(include)UPDTPAL
********************************************************************************
* Mise a jour de la palette
********************************************************************************
* TODO ajout systeme de refresh pour ne pas update la palette a chaque passage
* ou integrer le refresh palette en debut d'overscan avant que le faisceau entre en visu
* palette doit etre refresh avant le tracage avec les donnees de la precedente frame pas la nouvelle

cpt            fcb   $00
Ptr_palette    fdb   Black_palette  *@globals
Black_palette  rmb   $20,0          *@globals
White_palette  fdb   $ff0f          *@globals
               fdb   $ff0f
               fdb   $ff0f
               fdb   $ff0f
               fdb   $ff0f
               fdb   $ff0f
               fdb   $ff0f
               fdb   $ff0f
               fdb   $ff0f               
               fdb   $ff0f
               fdb   $ff0f
               fdb   $ff0f
               fdb   $ff0f
               fdb   $ff0f
               fdb   $ff0f
               fdb   $ff0f

UpdatePalette *@globals
    	ldx   Ptr_palette
    	clr   cpt                      * compteur couleur a 0
        lda   cpt			           *
SetColor
    	asla				           * multiplication par deux de A 
    	sta   $E7DB			           * determine l'indice de couleur (x2): 0=0, 1=2, 2=4, .. 15=30
    	ldd   ,x++			           * chargement de la couleur et increment du poiteur Y
    	sta   $E7DA			           * set de la couleur Vert et Rouge
    	stb   $E7DA                    * set de la couleur Bleu
    	inc   cpt			           * et increment de A
    	lda   cpt
    	cmpa  #$10                     * test fin de liste
    	bne   SetColor                 * on reboucle si fin de liste pas atteinte
        rts


(include)PLAYPCM
* ---------------------------------------------------------------------------
* PlayPCM
* ------------
* Subroutine to play a PCM sample at 16kHz
* This will freeze anything running
* DAC Init from Mission: Liftoff (merci Prehisto ;-))
*
* input REG : [y] Pcm_ index to play
* reset REG : [d] [x] [y]
* ---------------------------------------------------------------------------

PlayPCM *@globals

        lda   $E7E5
        sta   PlayPCM_RestorePage+1

        ldd   #$fb3f  ! Mute by CRA to 
        anda  $e7cf   ! avoid sound when 
        sta   $e7cf   ! $e7cd written
        stb   $e7cd   ! Full sound line
        ora   #$04    ! Disable mute by
        sta   $e7cf   ! CRA and sound
        
PlayPCM_ReadChunk
        lda   pcm_page,y                    ; load memory page
        cmpa  #$FF
        beq   PlayPCM_End
        sta   $E7E5                         ; mount page in A000-DFFF                
        ldx   pcm_start_addr,y              ; Chunk start addr
       
PlayPCM_Loop      
        lda   ,x+
        sta   $e7cd                         ; send byte to DAC
        cmpx  pcm_end_addr,y
        beq   PlayPCM_NextChunk        
        mul                                 ; tempo for 16hHz
        mul
        mul
        tfr   a,b
        bra   PlayPCM_Loop                  ; loop is 63 cycles instead of 62,5
         
PlayPCM_NextChunk
        leay  pcm_meta_size,y
        mul                                 ; tempo for 16kHz
        nop
        bra   PlayPCM_ReadChunk
        
PlayPCM_End
        lda   #$00
        sta   $e7cd
                
        ldd   #$fbfc  ! Mute by CRA to
        anda  $e7cf   ! avoid sound when
        sta   $e7cf   ! $e7cd is written
        andb  $e7cd   ! Activate
        stb   $e7cd   ! joystick port
        ora   #$04    ! Disable mute by
        sta   $e7cf   ! CRA + joystick

PlayPCM_RestorePage        
        lda   #$00
        sta   $E7E5
        
        rts   


(include)PSGLIB
* ---------------------------------------------------------------------------
* PSGlib
* ------------
* Converted to 6809 from:
* PSGlib - Programmable Sound Generator audio library - by sverx
*          https://github.com/sverx/PSGlib
*
* Typical workflow:
* 1) You (or a friend of yours) track one or more module(s) and SFX(s) using either Mod2PSG2 or DefleMask (or whatever you prefer as long as it supports exporting in VGM format).
* 2) Optional, but warmly suggested: optimize your VGM(s) using Maxim's VGMTool
* 3) Convert the VGM to PSG file(s) using the vgm2psg tool.
* 4) Optional, suggested: compress the PSG file(s) using the psgcomp tool. The psgdecomp tool can be used to verify that the compression was right.
* 5) include the library and 'incbin' the PSG file(s) to your Z80 ASM source.
* 6) call PSGInit once somewhere near the beginning of your code.
* 7) Set up a steady interrupt (vertical blanking for instance) so to call PSGFrame and PSGSFXFrame at a constant pace (very important!). The two calls are separated so you can eventually switch banks when done processing background music and need to process SFX.
* 8) Start/stop tunes when needed using PSGPlay and PSGStop calls, start/stop SFXs when needed using PSGSFXPlay and PSGSFXStop calls.
* - Looping SFXs are supported too: fire them using a PSGSFXPlayLoop call, cancel their loop using a PSGSFXCancelLoop call.
* - Tunes can be set to run just once instead of endlessly using PSGPlayNoRepeat call, or set a playing tune to have no more loops using PSGCancelLoop call at any time.
* - To check if a tune is still playing use PSGGetStatus call, to check if a SFX is still playing use PSGSFXGetStatus call.
*
* PSGlib functions reference
* ==========================
* 
* engine initializer function
* ---------------------------
* 
* **PSGInit**: initializes the PSG engine
* - no required parameters
* - no return values
* - destroys A
* 
* functions for music
* -------------------
* 
* **PSGFrame**: processes a music frame
* - no required parameters
* - no return values
* - destroys A,B,X
* 
* **PSGPlay** / **PSGPlayNoRepeat**: starts a tune (playing it repeatedly or only once)
* - *needs* the address of the PSG to start playing in X
* - no return values
* - destroys A
* 
* **PSGStop**: stops (pauses) the music (leaving the SFX on, if one is playing)
* - no required parameters
* - no return values
* - destroys A
* 
* **PSGResume**: resume the previously stopped music
* - no required parameters
* - no return values
* - destroys A
* 
* **PSGCancelLoop**: sets the currently looping music to no more loops after the current
* - no required parameters
* - no return values
* - destroys A
* 
* **PSGGetStatus**: gets the current status of music into register A
* - no required parameters
* - *returns* `PSG_PLAYING` in register A the engine is playing music, `PSG_STOPPED` otherwise.
* 
* functions for SFX
* -----------------
* 
* **PSGSFXFrame**: processes a SFX frame
* - no required parameters
* - no return values
* - destroys A,B,Y
* 
* **PSGSFXPlay** / **PSGSFXPlayLoop**: starts a SFX (playing it once or repeatedly)
* - *needs* the address of the SFX to start playing in X
* - *needs* a mask indicating which channels to be used by the SFX in B. The only possible values are `SFX_CHANNEL2`,`SFX_CHANNEL3` and `SFX_CHANNELS2AND3`.
* - destroys A
* 
* **PSGSFXStop**: stops the SFX (leaving the music on, if music is playing)
* - no required parameters
* - no return values
* - destroys A
* 
* **PSGSFXCancelLoop**: sets the currently looping SFX to no more loops after the current
* - no required parameters
* - no return values
* - destroys A
* 
* **PSGSFXGetStatus**: gets the current status of SFX into register A
* - no required parameters
* - *returns* `PSG_PLAYING` in register A if the engine is playing a SFX, `PSG_STOPPED` otherwise.
* 
* functions for music volume and hardware channels handling
* ---------------------------------------------------------
* 
* **PSGSetMusicVolumeAttenuation**: sets the volume attenuation for the music
* - *needs* the volume attenuation value in A (valid value are 0-15 where 0 means no attenuation and 15 is complete silence)
* - no return values
* - destroys A
* 
* **PSGSilenceChannels**: sets all hardware channels to volume ZERO (useful if you need to pause all audio)
* - no required parameters
* - no return values
* - destroys A
* 
* **PSGRestoreVolumes**: resets silenced hardware channels to previous volume
* - no required parameters
* - no return values
* - destroys A
*
* ---------------------------------------------------------------------------

PSG_STOPPED         equ 0
PSG_PLAYING         equ 1

PSGDataPort         equ $e7b0

PSGLatch            equ $80
PSGData             equ $40

PSGChannel0         equ $00
PSGChannel1         equ $20
PSGChannel2         equ $40
PSGChannel3         equ $60
PSGVolumeData       equ $10

PSGWait             equ $38
PSGSubString        equ $08
PSGLoop             equ $01
PSGEnd              equ $00

SFX_CHANNEL2        equ $01
SFX_CHANNEL3        equ $02
SFX_CHANNELS2AND3   equ SFX_CHANNEL2!SFX_CHANNEL3

* ************************************************************************************
* initializes the PSG 'engine'
* destroys A

PSGInit *@globals
        lda   #PSG_STOPPED                            ; ld a,PSG_STOPPED
        sta   PSGMusicStatus                          ; set music status to PSG_STOPPED
        sta   PSGSFXStatus                            ; set SFX status to PSG_STOPPED
        sta   PSGChannel2SFX                          ; set channel 2 SFX to PSG_STOPPED
        sta   PSGChannel3SFX                          ; set channel 3 SFX to PSG_STOPPED
        sta   PSGMusicVolumeAttenuation               ; volume attenuation = none
        rts

* ************************************************************************************
* receives in X the address of the PSG to start playing
* destroys A

PSGPlayNoRepeat *@globals
        lda   #0                                      ; We don't want the song to loop
        bra   PSGPlay1
PSGPlay
        lda   #1                                      ; the song can loop when finished
PSGPlay1
        sta   PSGLoopFlag
        bsr   PSGStop                                 ; if there's a tune already playing, we should stop it!
        
        lda   ,x   
        sta   PSGMusicPage
        ldx   1,x
        stx   PSGMusicStart                           ; store the begin point of music
        stx   PSGMusicPointer                         ; set music pointer to begin of music
        stx   PSGMusicLoopPoint                       ; looppointer points to begin too
        lda   #0
        sta   PSGMusicSkipFrames                      ; reset the skip frames
        sta   PSGMusicSubstringLen                    ; reset the substring len (for compression)
        lda   #PSGLatch!PSGChannel0!PSGVolumeData!$0F ; latch channel 0, volume=0xF (silent)
        sta   PSGMusicLastLatch                       ; reset last latch to chn 0 volume 0
        lda   #PSG_PLAYING
        sta   PSGMusicStatus                          ; set status to PSG_PLAYING
        rts

* ************************************************************************************
* stops the music (leaving the SFX on, if it's playing)
* destroys A

PSGStop *@globals
        lda   PSGMusicStatus                          ; if it's already stopped, leave
        beq   PSGStop_end
        lda   #PSGLatch!PSGChannel0!PSGVolumeData!$0F ; latch channel 0, volume=0xF (silent)
        sta   PSGDataPort
        lda   #PSGLatch!PSGChannel1!PSGVolumeData!$0F ; latch channel 1, volume=0xF (silent)
        sta   PSGDataPort
        lda   PSGChannel2SFX
        bne   PSGStop2
        lda   #PSGLatch!PSGChannel2!PSGVolumeData!$0F ; latch channel 2, volume=0xF (silent)
        sta   PSGDataPort
PSGStop2
        lda   PSGChannel3SFX
        bne   PSGStop3
        lda   #PSGLatch!PSGChannel3!PSGVolumeData!$0F ; latch channel 3, volume=0xF (silent)
        sta   PSGDataPort
PSGStop3
        lda   #PSG_STOPPED                            ; ld a,PSG_STOPPED
        sta   PSGMusicStatus                          ; set status to PSG_STOPPED
PSGStop_end
  rts


* ************************************************************************************
* resume a previously stopped music
* destroys A

PSGResume *@globals
        lda   PSGMusicStatus                          ; if it's already playing, leave
        bne   PSGResume_end
        lda   PSGChan0Volume                          ; restore channel 0 volume
        ora   #PSGLatch!PSGChannel0!PSGVolumeData
        sta   PSGDataPort
        lda   PSGChan1Volume                          ; restore channel 1 volume
        ora   #PSGLatch!PSGChannel1!PSGVolumeData
        sta   PSGDataPort
        lda   PSGChannel2SFX
        bne   PSGResume1
        lda   PSGChan2LowTone                         ; restore channel 2 frequency
        ora   #PSGLatch!PSGChannel2
        sta   PSGDataPort
        lda   PSGChan2HighTone
        sta   PSGDataPort
        lda   PSGChan2Volume                          ; restore channel 2 volume
        ora   #PSGLatch!PSGChannel2!PSGVolumeData
        sta   PSGDataPort
PSGResume1
        lda   PSGChannel3SFX
        bne   PSGResume2
        lda   PSGChan3LowTone                         ; restore channel 3 frequency
        ora   #PSGLatch!PSGChannel3
        sta   PSGDataPort
        lda   PSGChan3Volume                          ; restore channel 3 volume
        ora   #PSGLatch!PSGChannel2!PSGVolumeData
        sta   PSGDataPort
PSGResume2
        lda   #PSG_PLAYING
        sta   PSGMusicStatus                          ; set status to PSG_PLAYING
PSGResume_end        
        rts

* ************************************************************************************
* sets the currently looping music to no more loops after the current
* destroys A

PSGCancelLoop *@globals
          clr   PSGLoopFlag
          rts

* ************************************************************************************
* gets the current status of music into register A

PSGGetStatus *@globals
        lda   PSGMusicStatus
        rts

* ************************************************************************************
* receives in A the volume attenuation for the music (0-15)
* destroys A

PSGSetMusicVolumeAttenuation *@globals
        sta   PSGMusicVolumeAttenuation
        lda   PSGMusicStatus                          ; if tune is not playing, leave
        beq   PSGSetMusicVolumeAttenuation_end

        lda   PSGChan0Volume
        anda  #$0F
        adda  PSGMusicVolumeAttenuation
        cmpa  #$10                                    ; check overflow
        bcs   PSGSetMusicVolumeAttenuation1           ; if it's <=15 then ok
        lda   #$0F                                    ; else, reset to 15
PSGSetMusicVolumeAttenuation1
        ora   #PSGLatch!PSGChannel0!PSGVolumeData
        sta   PSGDataPort                             ; output the byte
        
        lda   PSGChan1Volume
        anda  #$0F
        adda  PSGMusicVolumeAttenuation
        cmpa  #$10                                    ; check overflow
        bcs   PSGSetMusicVolumeAttenuation2           ; if it's <=15 then ok
        lda   #$0F                                    ; else, reset to 15
PSGSetMusicVolumeAttenuation2
        ora   #PSGLatch!PSGChannel1!PSGVolumeData
        sta   PSGDataPort                             ; output the byte        
  

        lda   PSGChannel2SFX                          ; channel 2 busy with SFX?
        bne   _restore_channel3                       ; if so, skip channel 2

        lda   PSGChan2Volume
        anda  #$0F
        adda  PSGMusicVolumeAttenuation
        cmpa  #$10                                    ; check overflow
        bcs   PSGSetMusicVolumeAttenuation3           ; if it's <=15 then ok
        lda   #$0F                                    ; else, reset to 15
PSGSetMusicVolumeAttenuation3
        ora   #PSGLatch!PSGChannel2!PSGVolumeData
        sta   PSGDataPort 

_restore_channel3
        lda   PSGChannel3SFX                          ; channel 3 busy with SFX?
        bne   PSGSetMusicVolumeAttenuation_end        ; if so, we're done

        lda   PSGChan3Volume
        anda  #$0F
        adda  PSGMusicVolumeAttenuation
        cmpa  #$10                                    ; check overflow
        bcs   PSGSetMusicVolumeAttenuation4           ; if it's <=15 then ok
        lda   #$0F                                    ; else, reset to 15
PSGSetMusicVolumeAttenuation4
        ora   #PSGLatch!PSGChannel3!PSGVolumeData
        sta   PSGDataPort 
        
PSGSetMusicVolumeAttenuation_end
        rts

* ************************************************************************************
* sets all PSG channels to volume ZERO (useful if you need to pause music)
* destroys A

PSGSilenceChannels *@globals
        lda   #PSGLatch!PSGChannel0!PSGVolumeData!$0F ; latch channel 0, volume=0xF (silent)
        sta   PSGDataPort
        lda   #PSGLatch!PSGChannel1!PSGVolumeData!$0F ; latch channel 1, volume=0xF (silent)
        sta   PSGDataPort
        lda   #PSGLatch!PSGChannel2!PSGVolumeData!$0F ; latch channel 2, volume=0xF (silent)
        sta   PSGDataPort
        lda   #PSGLatch!PSGChannel3!PSGVolumeData!$0F ; latch channel 3, volume=0xF (silent)
        sta   PSGDataPort
        rts

* ************************************************************************************
* resets all PSG channels to previous volume
* destroys A

PSGRestoreVolumes *@globals
        lda   PSGMusicStatus                          ; check if tune is playing
        beq   _chkchn2                                ; if not, skip chn0 and chn1

        lda   PSGChan0Volume
        anda  #$0F
        adda  PSGMusicVolumeAttenuation
        cmpa  #$10                                    ; check overflow
        bcs   PSGRestoreVolumes1                      ; if it's <=15 then ok
        lda   #$0F                                    ; else, reset to 15
PSGRestoreVolumes1
        ora   #PSGLatch!PSGChannel0!PSGVolumeData
        sta   PSGDataPort                             ; output the byte

        lda   PSGChan1Volume
        anda  #$0F
        adda  PSGMusicVolumeAttenuation
        cmpa  #$10                                    ; check overflow
        bcs   PSGRestoreVolumes2                      ; if it's <=15 then ok
        lda   #$0F                                    ; else, reset to 15
PSGRestoreVolumes2
        ora   #PSGLatch!PSGChannel1!PSGVolumeData
        sta   PSGDataPort                             ; output the byte
  
_chkchn2
        lda   PSGChannel2SFX                          ; channel 2 busy with SFX?
        bne   _restoreSFX2
  
        lda   PSGMusicStatus                          ; check if tune is playing
        beq   _chkchn3                                ; if not, skip chn2

        lda   PSGChan2Volume
        anda  #$0F
        adda  PSGMusicVolumeAttenuation
        cmpa  #$10                                    ; check overflow
        bcs   PSGRestoreVolumes3                      ; if it's <=15 then ok
        lda   #$0F                                    ; else, reset to 15
        bra   PSGRestoreVolumes3

_restoreSFX2
        lda   PSGSFXChan2Volume
        anda  $0F
PSGRestoreVolumes3
        ora   #PSGLatch!PSGChannel2!PSGVolumeData
        sta   PSGDataPort                             ; output the byte

_chkchn3
        lda   PSGChannel3SFX                          ; channel 3 busy with SFX?
        bne   _restoreSFX3
  
        lda   PSGMusicStatus                          ; check if tune is playing
        beq   _restoreSFX2_end                        ; if not, we've done

        lda   PSGChan3Volume
        anda  #$0F
        adda  PSGMusicVolumeAttenuation
        cmpa  #$10                                    ; check overflow
        bcs   PSGRestoreVolumes4                      ; if it's <=15 then ok
        lda   #$0F                                    ; else, reset to 15
        bra   PSGRestoreVolumes4

_restoreSFX3
        lda   PSGSFXChan3Volume
        anda  #$0F
PSGRestoreVolumes4
        ora   #PSGLatch!PSGChannel3!PSGVolumeData
        sta   PSGDataPort                             ; output the byte
_restoreSFX2_end
        rts


* ************************************************************************************
* receives in X the address of the SFX PSG to start
* receives in B the mask that indicates which channel(s) the SFX will use
* destroys A

PSGSFXPlayLoop *@globals
        lda   #1                                      ; SFX _IS_ a looping one
        bra   PSGSFXPlay1
PSGSFXPlay
        lda   #0                                      ; SFX is _NOT_ a looping one
PSGSFXPlay1
        sta   PSGSFXLoopFlag
        bsr   PSGSFXStop                              ; if there's a SFX already playing, we should stop it!

        lda   ,x   
        sta   PSGSFXPage
        ldx   1,x        
        stx   PSGSFXStart                             ; store begin of SFX
        stx   PSGSFXPointer                           ; set the pointer to begin of SFX
        stx   PSGSFXLoopPoint                         ; looppointer points to begin too
        lda   #0
        sta   PSGSFXSkipFrames                        ; reset the skip frames
        sta   PSGSFXSubstringLen                      ; reset the substring len
        bitb  #SFX_CHANNEL2                           ; channel 2 needed?
        beq   PSGSFXPlay2
        lda   #PSG_PLAYING
        sta   PSGChannel2SFX
PSGSFXPlay2
        bitb  #SFX_CHANNEL3                           ; channel 3 needed?
        beq   PSGSFXPlay3
        lda   #PSG_PLAYING
        sta   PSGChannel3SFX
PSGSFXPlay3
        sta   PSGSFXStatus                            ; set status to PSG_PLAYING
        lda   PSGChan3LowTone                         ; test if channel 3 uses the frequency of channel 2
        anda  #SFX_CHANNELS2AND3
        cmpa  #SFX_CHANNELS2AND3
        bne   PSGSFXPlayLoop_end                      ; if channel 3 doesn't use the frequency of channel 2 we're done
        lda   #PSG_PLAYING
        sta   PSGChannel3SFX                          ; otherwise mark channel 3 as occupied by the SFX
        lda   #PSGLatch!PSGChannel3!PSGVolumeData!$0F ; and silence channel 3
        sta   PSGDataPort
PSGSFXPlayLoop_end        
        rts


* ************************************************************************************
* stops the SFX (leaving the music on, if it's playing)
* destroys A

PSGSFXStop *@globals
        lda   PSGSFXStatus                            ; check status
        beq   PSGSFXStop_end                          ; no SFX playing, leave
        lda   PSGChannel2SFX                          ; channel 2 playing?
        beq   PSGSFXStop1
        lda   #PSGLatch!PSGChannel2!PSGVolumeData!$0F ; latch channel 2, volume=0xF (silent)
        sta   PSGDataPort
PSGSFXStop1
        lda   PSGChannel3SFX                          ; channel 3 playing?
        beq   PSGSFXStop2
        lda   #PSGLatch!PSGChannel3!PSGVolumeData!$0F ; latch channel 3, volume=0xf (silent)
        sta   PSGDataPort
PSGSFXStop2
        lda   PSGMusicStatus                          ; check if a tune is playing
        beq   _skipRestore                            ; if it's not playing, skip restoring PSG values
        lda   PSGChannel2SFX                          ; channel 2 playing?
        beq   _skip_chn2
        lda   PSGChan2LowTone
        anda  #$0F                                    ; use only low 4 bits of byte
        ora   #PSGLatch|PSGChannel2                   ; latch channel 2, low part of tone
        sta   PSGDataPort
        lda   PSGChan2HighTone                        ; high part of tone (latched channel 2, tone)
        anda  #$3F                                    ; use only low 6 bits of byte
        sta   PSGDataPort
        lda   PSGChan2Volume                          ; restore music' channel 2 volume
        anda  #$0F                                    ; use only low 4 bits of byte
        adda  PSGMusicVolumeAttenuation
        cmpa  #$10                                    ; check overflow
        bcs   PSGSFXStop3                             ; if it's <=15 then ok
        lda   #$0F                                    ; else, reset to 15
PSGSFXStop3
        ora   #PSGLatch!PSGChannel2!PSGVolumeData
        sta   PSGDataPort                             ; output the byte
_skip_chn2
        lda   PSGChannel3SFX                          ; channel 3 playing?
        beq   _skip_chn3
        lda   PSGChan3LowTone
        anda  $07                                     ; use only low 3 bits of byte
        ora   #PSGLatch!PSGChannel3                   ; latch channel 3, low part of tone (no high part)
        sta   PSGDataPort
        lda   PSGChan3Volume                          ; restore music' channel 3 volume
        anda  #$0F                                    ; use only low 4 bits of byte
        adda  PSGMusicVolumeAttenuation
        cmpa  #$10                                    ; check overflow
        bcs   PSGSFXStop4                             ; if it's <=15 then ok
        lda   #$0F                                    ; else, reset to 15
PSGSFXStop4
        ora   #PSGLatch!PSGChannel3!PSGVolumeData
        sta   PSGDataPort                             ; output the byte

_skip_chn3
        lda   #PSG_STOPPED                            ; ld a,PSG_STOPPED
_skipRestore
        sta   PSGChannel2SFX
        sta   PSGChannel3SFX
        sta   PSGSFXStatus                            ; set status to PSG_STOPPED
PSGSFXStop_end  
        rts

* ************************************************************************************
* sets the currently looping SFX to no more loops after the current
* destroys A

PSGSFXCancelLoop *@globals
        clr   PSGSFXLoopFlag
        rts


* ************************************************************************************
* gets the current SFX status into register A

PSGSFXGetStatus *@globals
        lda   PSGSFXStatus
        rts


* ************************************************************************************
* processes a music frame
* destroys A,B,X
        
PSGFrame *@globals

        lda   PSGMusicPage
        sta   $E7E5

        lda   PSGMusicStatus                          ; check if we have got to play a tune
        bne   PSGFrame_continue
        rts

PSGFrame_continue        
        lda   PSGMusicSkipFrames                      ; check if we havve got to skip frames
        bne   _skipFrame
        ldx   PSGMusicPointer                         ; read current address

_intLoop
        ldb   ,x+                                     ; load PSG byte (in B)
        lda   PSGMusicSubstringLen                    ; read substring len
        beq   _continue                               ; check if it is 0 (we are not in a substring)
        deca                                          ; decrease len
        sta   PSGMusicSubstringLen                    ; save len
        bne   _continue
        ldx   PSGMusicSubstringRetAddr                ; substring is over, retrieve return address

_continue
        cmpb  #PSGLatch                               ; is it a latch?
        bcs   _noLatch                                ; if < $80 then it is NOT a latch
        stb   PSGMusicLastLatch                       ; it is a latch - save it in "LastLatch"
  
        bitb  #4                                      ; test if it is a volume
        bne   _latch_Volume                           ; jump if volume data
        bitb  #6                                      ; test if the latch it is for channels 0-1 or for 2-3
        beq   _send2PSG                               ; send data to PSG if it is for channels 0-1

        bitb  #5                                      ; test if tone it is for channel 2 or 3
        beq   _ifchn2                                 ; jump if channel 2
        stb   PSGChan3LowTone                         ; save tone LOW data
        lda   PSGChannel3SFX                          ; channel 3 free?
        bne   _intLoop
        lda   PSGChan3LowTone
        anda  #3                                      ; test if channel 3 is set to use the frequency of channel 2
        cmpa  #3
        bne   _send2PSG                               ; if channel 3 does not use frequency of channel 2 jump
        lda   PSGSFXStatus                            ; test if an SFX is playing
        beq   _send2PSG                               ; if no SFX is playing jump
        sta   PSGChannel3SFX                          ; otherwise mark channel 3 as occupied
        lda   #PSGLatch!PSGChannel3!PSGVolumeData!$0F ; and silence channel 3
        sta   PSGDataPort
        bra   _intLoop

_ifchn2
        stb   PSGChan2LowTone                         ; save tone LOW data
        lda   PSGChannel2SFX                          ; channel 2 free?
        beq   _send2PSG
        bra   _intLoop
  
_latch_Volume
        bitb  #6                                      ; test if the latch it is for channels 0-1 or for 2-3
        bne   _latch_Volume_23                        ; volume is for channel 2 or 3
        bitb  #5                                      ; test if volume it is for channel 0 or 1
        beq   _ifchn0                                 ; jump for channel 0
        stb   PSGChan1Volume                          ; save volume data
        bra   _sendVolume2PSG
        
_ifchn0
        stb   PSGChan0Volume                          ; save volume data
        bra   _sendVolume2PSG

_latch_Volume_23
        bitb  #5                                      ; test if volume it is for channel 2 or 3
        beq   _chn2                                   ; jump for channel 2
        stb   PSGChan3Volume                          ; save volume data
        lda   PSGChannel3SFX                          ; channel 3 free?
        beq   _sendVolume2PSG
        bra   _intLoop

_chn2
        stb   PSGChan2Volume                          ; save volume data
        lda   PSGChannel2SFX                          ; channel 2 free?
        beq   _sendVolume2PSG
        bra   _intLoop
        
_send2PSG
        stb   PSGDataPort                             ; output the byte
        bra   _intLoop            
  
_skipFrame
        deca
        sta   PSGMusicSkipFrames
        rts

_noLatch
        cmpb  #PSGData
        bcs   _command                                ; if < $40 then it is a command
                                                      * it's a data
        lda   PSGMusicLastLatch                       ; retrieve last latch
        bra   _output_NoLatch

_command
        cmpb  #PSGWait
        beq   _done                                   ; no additional frames
        bcs   _otherCommands                          ; other commands?
        andb  #$07                                    ; take only the last 3 bits for skip frames
        stb   PSGMusicSkipFrames                      ; we got additional frames
  
_done
        stx   PSGMusicPointer                         ; save current address
        rts                                           ; frame done

_otherCommands
        cmpb  #PSGSubString
        bcc   _substring
        cmpb  #PSGEnd
        beq   _musicLoop
        cmpb  #PSGLoop
        beq   _setLoopPoint

  * ***************************************************************************
  * we should never get here!
  * if we do, it means the PSG file is probably corrupted, so we just RET
  * ***************************************************************************

        rts  

_sendVolume2PSG *@globals
        stb   _sendVolume2PSG1+1                      ; save the PSG command byte
        andb  #$0F                                    ; keep lower nibble
        addb  PSGMusicVolumeAttenuation               ; add volume attenuation
        cmpb  #$10                                    ; check overflow
        bcs   _sendVolume2PSG1                        ; if it is <=15 then ok
        ldb   #$0F                                    ; else, reset to 15
_sendVolume2PSG1  
        lda   #0                                      ; retrieve PSG command
        stb   _sendVolume2PSG2+1   
        anda  #$F0                                    ; keep upper nibble
_sendVolume2PSG2        
        ora   #0                                      ; set attenuated volume
        sta   PSGDataPort                             ; output the byte
        lbra   _intLoop

_output_NoLatch
  * we got the last latch in A and the PSG data in B
  * and we have to check if the value should pass to PSG or not
  * note that non-latch commands can be only contain frequencies (no volumes)
  * for channels 0,1,2 only (no noise)
        bita  #6                                      ; test if the latch it is for channels 0-1 or for chn 2
        bne   _high_part_Tone                         ;  it is tone data for channel 2
        bra   _send2PSG                               ; otherwise, it is for chn 0 or 1 so we have done!

_setLoopPoint
        stx   PSGMusicLoopPoint
        lbra   _intLoop

_musicLoop
        lda   PSGLoopFlag                             ; looping requested?
        lbeq   PSGStop                                ; No:stop it! (tail call optimization)
        ldx   PSGMusicLoopPoint
        lbra   _intLoop

_substring
        subb  #PSGSubString-4                         ; len is value - $08 + 4
        stb   PSGMusicSubstringLen                    ; save len
        ldd   ,x++                                    ; load substring address (offset)
        stx   PSGMusicSubstringRetAddr                ; save return address
        ldx   PSGMusicStart
        leax  d,x                                     ; make substring current
        lbra   _intLoop

_high_part_Tone
        stb   PSGChan2HighTone                        ; save channel 2 tone HIGH data
        lda   PSGChannel2SFX                          ; channel 2 free?
        beq   _send2PSG
        lbra   _intLoop


* ************************************************************************************
* processes a SFX frame
* destroys A,B,X

PSGSFXFrame *@globals

        lda   PSGSFXPage
        sta   $E7E5
        
        lda   PSGSFXStatus                            ; check if we have got to play SFX
        beq   PSGSFXFrame_end

        lda   PSGSFXSkipFrames                        ; check if we have got to skip frames
        bne   _skipSFXFrame
  
        ldx   PSGSFXPointer                           ; read current SFX address

_intSFXLoop
        ldb   ,x+                                     ; load a byte in B
        lda   PSGSFXSubstringLen                      ; read substring len
        beq   _SFXcontinue                            ; check if it is 0 (we are not in a substring)
        deca                                          ; decrease len
        sta   PSGSFXSubstringLen                      ; save len
        bne   _SFXcontinue
        ldx   PSGSFXSubstringRetAddr                  ; substring over, retrieve return address

_SFXcontinue
        cmpb   #PSGData
        bcs    _SFXcommand                            ; if less than $40 then it is a command
        bitb   #4                                     ; check if it is a volume byte
        beq    _SFXoutbyte                            ; if not, output it
        bitb   #5                                     ; check if it is volume for channel 2 or channel 3
        bne    _SFXvolumechn3
        stb    PSGSFXChan2Volume
        bra   _SFXoutbyte

_SFXvolumechn3
        stb   PSGSFXChan3Volume

_SFXoutbyte
        stb   PSGDataPort                             ; output the byte
        bra   _intSFXLoop
  
_skipSFXFrame
        deca
        sta   PSGSFXSkipFrames
PSGSFXFrame_end  
        rts

_SFXcommand
        cmpb   #PSGWait
        beq    _SFXdone                               ; no additional frames
        bcs    _SFXotherCommands                      ; other commands?
        andb   #$07                                   ; take only the last 3 bits for skip frames
        stb    PSGSFXSkipFrames                       ; we got additional frames to skip
_SFXdone
        stx    PSGSFXPointer                          ; save current address
        rts                                           ; frame done

_SFXotherCommands
        cmpb   #PSGSubString
        bcc    _SFXsubstring
        cmpb   #PSGEnd
        beq    _sfxLoop
        cmpb   #PSGLoop
        beq    _SFXsetLoopPoint
  
  * ***************************************************************************
  * we should never get here!
  * if we do, it means the PSG SFX file is probably corrupted, so we just RET
  * ***************************************************************************

        rts

_SFXsetLoopPoint *@globals
        stx   PSGSFXLoopPoint
        bra   _intSFXLoop
  
_sfxLoop
        lda   PSGSFXLoopFlag                          ; is it a looping SFX?
        lbeq   PSGSFXStop                             ; No:stop it! (tail call optimization)
        ldx   PSGSFXLoopPoint
        stx   PSGSFXPointer
        bra   _intSFXLoop

_SFXsubstring
        subb  #PSGSubString-4                         ; len is value - $08 + 4
        stb   PSGSFXSubstringLen                      ; save len
        ldd   ,x++                                    ; load substring address (offset)
        stx   PSGSFXSubstringRetAddr                  ; save return address
        ldx   PSGSFXStart
        leax  d,x                                     ; make substring current
        bra   _intSFXLoop

  * fundamental vars
PSGMusicStatus             rmb 1,0 ; are we playing a background music?
PSGMusicPage               rmb 1,0 ; Memory Page of Music Data
PSGMusicStart              rmb 2,0 ; the pointer to the beginning of music
PSGMusicPointer            rmb 2,0 ; the pointer to the current
PSGMusicLoopPoint          rmb 2,0 ; the pointer to the loop begin
PSGMusicSkipFrames         rmb 1,0 ; the frames we need to skip
PSGLoopFlag                rmb 1,0 ; the tune should loop or not (flag)
PSGMusicLastLatch          rmb 1,0 ; the last PSG music latch

  * decompression vars
PSGMusicSubstringLen       rmb 1,0 ; lenght of the substring we are playing
PSGMusicSubstringRetAddr   rmb 2,0 ; return to this address when substring is over

  * command buffers
PSGChan0Volume             rmb 1,0 ; the volume for channel 0
PSGChan1Volume             rmb 1,0 ; the volume for channel 1
PSGChan2Volume             rmb 1,0 ; the volume for channel 2
PSGChan3Volume             rmb 1,0 ; the volume for channel 3
PSGChan2LowTone            rmb 1,0 ; the low tone bits for channels 2
PSGChan3LowTone            rmb 1,0 ; the low tone bits for channels 3
PSGChan2HighTone           rmb 1,0 ; the high tone bits for channel 2

PSGMusicVolumeAttenuation  rmb 1,0 ; the volume attenuation applied to the tune (0-15)

  * ******* SFX *************

  * flags for channels 2-3 access
PSGChannel2SFX             rmb 1,0 ; !0 means channel 2 is allocated to SFX
PSGChannel3SFX             rmb 1,0 ; !0 means channel 3 is allocated to SFX

  * command buffers for SFX
PSGSFXChan2Volume          rmb 1,0 ; the volume for channel 2
PSGSFXChan3Volume          rmb 1,0 ; the volume for channel 3

  * fundamental vars for SFX
PSGSFXStatus               rmb 1,0 ; are we playing a SFX?
PSGSFXPage                 rmb 1,0 ; Memory Page of SFX Data
PSGSFXStart                rmb 2,0 ; the pointer to the beginning of SFX
PSGSFXPointer              rmb 2,0 ; the pointer to the current address
PSGSFXLoopPoint            rmb 2,0 ; the pointer to the loop begin
PSGSFXSkipFrames           rmb 1,0 ; the frames we need to skip
PSGSFXLoopFlag             rmb 1,0 ; the SFX should loop or not (flag)

  * decompression vars for SFX
PSGSFXSubstringLen         rmb 1,0 ; lenght of the substring we are playing
PSGSFXSubstringRetAddr     rmb 2,0 ; return to this address when substring is over



(include)IMAGEIDX
* Generated Code

Img_SonicAndTailsIn *@globals
        fcb   $07,$00,$00,$00,$88,$4F,$00,$00,$06,$00,$00,$BB,$D9,$0A
        fcb   $D0,$04
Img_SegaLogo_2 *@globals
        fcb   $07,$00,$00,$00,$5C,$39,$03,$00,$06,$00,$00,$D2,$E4,$0D
        fcb   $C1,$7E
Img_SegaLogo_1 *@globals
        fcb   $07,$00,$00,$00,$5C,$38,$03,$00,$06,$00,$00,$D2,$E5,$09
        fcb   $D1,$3B
Img_SegaTrails_1 *@globals
        fcb   $07,$10,$00,$00,$07,$3E,$00,$00,$06,$00,$00,$10,$E0,$05
        fcb   $DD,$7E,$00,$06,$00,$00,$E8,$E0,$05,$DC,$07
Img_SegaSonic_12 *@globals
        fcb   $07,$14,$00,$00,$0F,$45,$00,$06,$00,$00,$00,$F8,$E3,$08
        fcb   $D8,$26,$06,$DD,$48,$0A,$06,$00,$00,$00,$F8,$E3,$09,$C9
        fcb   $76,$06,$DA,$A2,$0A
Img_SegaSonic_23 *@globals
        fcb   $07,$14,$00,$00,$06,$1F,$00,$06,$00,$00,$00,$F1,$01,$05
        fcb   $D9,$BA,$05,$D8,$D4,$02,$06,$00,$00,$00,$08,$01,$05,$D6
        fcb   $85,$05,$D5,$9F,$02
Img_SegaSonic_13 *@globals
        fcb   $07,$14,$00,$00,$06,$25,$00,$06,$00,$00,$00,$F1,$01,$06
        fcb   $D7,$D8,$05,$D4,$8F,$03,$06,$00,$00,$00,$08,$01,$06,$D5
        fcb   $0C,$05,$D3,$80,$03
Img_SegaSonic_32 *@globals
        fcb   $07,$14,$00,$00,$0F,$45,$00,$06,$00,$00,$00,$F8,$E3,$09
        fcb   $C1,$1C,$06,$D2,$1E,$0A,$06,$00,$00,$00,$F8,$E3,$09,$B8
        fcb   $BC,$06,$CF,$2D,$0A
Img_SegaSonic_21 *@globals
        fcb   $07,$14,$00,$00,$07,$3F,$00,$06,$00,$00,$00,$08,$E5,$07
        fcb   $DB,$55,$05,$D1,$B2,$04,$06,$00,$00,$00,$F0,$E5,$07,$D6
        fcb   $B6,$05,$CF,$E3,$04
Img_SegaSonic_43 *@globals
        fcb   $07,$14,$00,$00,$06,$1F,$00,$06,$00,$00,$00,$F1,$01,$05
        fcb   $CD,$96,$05,$CC,$AE,$02,$06,$00,$00,$00,$08,$01,$05,$CA
        fcb   $61,$05,$C9,$79,$02
Img_SegaSonic_11 *@globals
        fcb   $07,$14,$00,$00,$07,$3F,$00,$06,$00,$00,$00,$08,$E5,$08
        fcb   $D3,$52,$05,$C7,$7F,$04,$06,$00,$00,$00,$F0,$E5,$08,$CE
        fcb   $7E,$05,$C5,$84,$04
Img_SegaSonic_33 *@globals
        fcb   $07,$14,$00,$00,$05,$25,$00,$06,$00,$00,$00,$F2,$01,$05
        fcb   $C3,$4E,$05,$C2,$5F,$02,$06,$00,$00,$00,$08,$01,$05,$C0
        fcb   $29,$05,$BF,$3A,$02
Img_SegaSonic_22 *@globals
        fcb   $07,$14,$00,$00,$0F,$47,$00,$06,$00,$00,$00,$F8,$E1,$09
        fcb   $B0,$95,$06,$CC,$6F,$0A,$06,$00,$00,$00,$F8,$E1,$09,$A8
        fcb   $56,$06,$C9,$B3,$0A
Img_SegaSonic_41 *@globals
        fcb   $07,$14,$00,$00,$07,$3F,$00,$06,$00,$00,$00,$08,$E5,$07
        fcb   $D2,$3B,$05,$BD,$7B,$04,$06,$00,$00,$00,$F0,$E5,$07,$CD
        fcb   $BE,$05,$BB,$BC,$04
Img_SegaSonic_31 *@globals
        fcb   $07,$14,$00,$00,$07,$3F,$00,$06,$00,$00,$00,$08,$E5,$08
        fcb   $C9,$A9,$05,$B9,$CF,$04,$06,$00,$00,$00,$F0,$E5,$08,$C4
        fcb   $D6,$05,$B7,$E2,$04
Img_SegaSonic_42 *@globals
        fcb   $07,$14,$00,$00,$0F,$47,$00,$06,$00,$00,$00,$F8,$E1,$09
        fcb   $A0,$00,$06,$C6,$E6,$0A,$06,$00,$00,$00,$F8,$E1,$0A,$C7
        fcb   $A0,$06,$C4,$1B,$0A
Img_SegaTrails_6 *@globals
        fcb   $00,$07,$00,$00,$0F,$44,$00,$00,$06,$00,$00,$10,$DE,$05
        fcb   $B6,$6C
Img_SegaTrails_5 *@globals
        fcb   $00,$07,$00,$00,$0F,$44,$00,$00,$06,$00,$00,$00,$DE,$05
        fcb   $B4,$F6
Img_SegaTrails_4 *@globals
        fcb   $07,$00,$00,$00,$0F,$44,$00,$00,$06,$00,$00,$E0,$DE,$05
        fcb   $B3,$80
Img_SegaTrails_3 *@globals
        fcb   $07,$00,$00,$00,$0F,$44,$00,$00,$06,$00,$00,$F0,$DE,$05
        fcb   $B2,$0A
Img_SegaTrails_2 *@globals
        fcb   $07,$10,$00,$00,$0F,$44,$00,$00,$06,$00,$00,$00,$DE,$05
        fcb   $B0,$38,$00,$06,$00,$00,$F0,$DE,$05,$AE,$5E
Img_star_4 *@globals
        fcb   $07,$00,$00,$00,$0A,$16,$00,$06,$00,$00,$00,$FB,$F5,$05
        fcb   $AB,$97,$05,$AB,$02,$02
Img_star_3 *@globals
        fcb   $07,$00,$00,$00,$06,$0E,$00,$06,$00,$00,$00,$FD,$F9,$05
        fcb   $AA,$00,$05,$A9,$A2,$01
Img_sonicHand *@globals
        fcb   $07,$00,$00,$00,$0E,$2A,$00,$06,$0D,$00,$00,$04,$01,$08
        fcb   $BF,$81,$05,$A7,$D1,$05,$06,$BD,$90
Img_star_2 *@globals
        fcb   $07,$00,$00,$00,$02,$06,$00,$06,$00,$0D,$00,$FF,$FD,$05
        fcb   $A7,$60,$05,$A7,$32,$01,$05,$A6,$C3,$05,$A6,$95,$01
Img_star_1 *@globals
        fcb   $07,$00,$00,$00,$02,$04,$00,$06,$00,$0D,$00,$FF,$FE,$05
        fcb   $A6,$42,$05,$A6,$1E,$01,$05,$A5,$CD,$05,$A5,$A9,$01
Img_emblemBack08 *@globals
        fcb   $07,$00,$00,$00,$1F,$27,$00,$00,$06,$00,$00,$10,$DD,$07
        fcb   $C9,$32
Img_emblemBack07 *@globals
        fcb   $07,$00,$00,$00,$1F,$1F,$00,$00,$06,$00,$00,$10,$BD,$06
        fcb   $B9,$F8
Img_emblemBack09 *@globals
        fcb   $07,$00,$00,$00,$0F,$38,$00,$00,$06,$00,$00,$30,$B3,$06
        fcb   $B6,$8B
Img_emblemBack04 *@globals
        fcb   $07,$00,$00,$00,$24,$09,$00,$00,$06,$00,$00,$EE,$B3,$05
        fcb   $A4,$0E
Img_emblemBack03 *@globals
        fcb   $07,$00,$00,$00,$1F,$26,$00,$00,$06,$00,$00,$D0,$DD,$06
        fcb   $B2,$AD
Img_emblemBack06 *@globals
        fcb   $07,$00,$00,$00,$1F,$1C,$00,$00,$06,$00,$00,$F0,$DD,$05
        fcb   $A2,$53
Img_emblemBack05 *@globals
        fcb   $07,$00,$00,$00,$1F,$1F,$00,$00,$06,$00,$00,$F0,$BD,$06
        fcb   $AE,$F7
Img_tails_5 *@globals
        fcb   $07,$00,$00,$00,$2B,$3F,$00,$06,$0D,$00,$00,$03,$0D,$0A
        fcb   $B8,$B4,$07,$C4,$BA,$11,$0A,$AE,$41
Img_tails_4 *@globals
        fcb   $07,$00,$00,$00,$2C,$3A,$00,$06,$00,$00,$00,$03,$12,$0A
        fcb   $A0,$00,$06,$AA,$B8,$10
Img_tails_3 *@globals
        fcb   $07,$00,$00,$00,$2B,$3C,$00,$06,$00,$00,$00,$04,$11,$0B
        fcb   $CF,$C7,$07,$C0,$4E,$0F
Img_tails_2 *@globals
        fcb   $07,$00,$00,$00,$2B,$37,$00,$06,$00,$00,$00,$02,$16,$0B
        fcb   $C3,$61,$06,$A7,$07,$0F
Img_tails_1 *@globals
        fcb   $07,$00,$00,$00,$1B,$3F,$00,$06,$00,$00,$00,$0C,$11,$0B
        fcb   $B7,$ED,$06,$A3,$99,$0E
Img_tailsHand *@globals
        fcb   $07,$00,$00,$00,$07,$12,$00,$06,$0D,$00,$00,$04,$06,$06
        fcb   $A2,$05,$05,$A1,$B1,$02,$05,$A0,$AE
Img_sonic_1 *@globals
        fcb   $07,$00,$00,$00,$23,$42,$00,$06,$00,$00,$00,$02,$0E,$0B
        fcb   $A9,$52,$07,$BC,$1F,$14
Img_sonic_2 *@globals
        fcb   $07,$00,$00,$00,$24,$53,$00,$06,$00,$00,$00,$03,$0D,$0C
        fcb   $CD,$86,$08,$BA,$D4,$17
Img_emblemBack02 *@globals
        fcb   $07,$00,$00,$00,$1F,$1F,$00,$00,$06,$00,$00,$D0,$BD,$07
        fcb   $B8,$81
Img_emblemBack01 *@globals
        fcb   $07,$00,$00,$00,$0F,$37,$00,$00,$06,$00,$00,$C0,$B3,$07
        fcb   $B5,$1D
Img_sonic_5 *@globals
        fcb   $07,$00,$00,$00,$23,$49,$00,$06,$0D,$00,$00,$0C,$0A,$0C
        fcb   $BE,$6F,$07,$B0,$D6,$14,$0B,$A0,$00
Img_sonic_3 *@globals
        fcb   $07,$00,$00,$00,$24,$46,$00,$06,$00,$00,$00,$0B,$0D,$0C
        fcb   $AE,$DF,$07,$AC,$72,$15
Img_sonic_4 *@globals
        fcb   $07,$00,$00,$00,$23,$49,$00,$06,$00,$00,$00,$0C,$0A,$0C
        fcb   $A0,$00,$07,$A8,$3D,$14
Img_emblemFront07 *@globals
        fcb   $07,$00,$00,$00,$12,$12,$00,$00,$06,$00,$00,$F7,$3D,$06
        fcb   $A0,$00
Img_emblemFront08 *@globals
        fcb   $07,$00,$00,$00,$26,$25,$00,$00,$06,$00,$00,$10,$1D,$08
        fcb   $B6,$2B
Img_emblemFront05 *@globals
        fcb   $07,$00,$00,$00,$26,$25,$00,$00,$06,$00,$00,$C9,$1D,$08
        fcb   $B1,$66
Img_emblemFront06 *@globals
        fcb   $07,$00,$00,$00,$1F,$1F,$00,$00,$06,$00,$00,$F0,$1D,$07
        fcb   $A4,$06
Img_emblemFront03 *@globals
        fcb   $07,$00,$00,$00,$1F,$1F,$00,$00,$06,$00,$00,$F0,$FD,$07
        fcb   $A0,$00
Img_emblemFront04 *@globals
        fcb   $07,$00,$00,$00,$1B,$1F,$00,$00,$06,$00,$00,$10,$FD,$08
        fcb   $AE,$51
Img_emblemFront01 *@globals
        fcb   $07,$00,$00,$00,$3D,$03,$00,$00,$06,$00,$00,$E1,$F9,$05
        fcb   $A0,$00
Img_emblemFront02 *@globals
        fcb   $07,$00,$00,$00,$1A,$1F,$00,$00,$06,$00,$00,$D5,$FD,$08
        fcb   $AB,$5B

(include)ANIMSCPT
* Generated Code

        fcb   0
Ani_SegaSonic_3 *@globals
        fdb   Img_SegaSonic_13
        fdb   Img_SegaSonic_23
        fdb   Img_SegaSonic_33
        fdb   Img_SegaSonic_43
        fcb   _resetAnim
        fcb   0
Ani_SegaSonic_2 *@globals
        fdb   Img_SegaSonic_12
        fdb   Img_SegaSonic_22
        fdb   Img_SegaSonic_32
        fdb   Img_SegaSonic_42
        fcb   _resetAnim
        fcb   0
Ani_SegaSonic_1 *@globals
        fdb   Img_SegaSonic_11
        fdb   Img_SegaSonic_21
        fdb   Img_SegaSonic_31
        fdb   Img_SegaSonic_41
        fcb   _resetAnim
        fcb   3
Ani_smallStar *@globals
        fdb   Img_star_2
        fdb   Img_star_1
        fcb   _resetAnim
        fcb   1
Ani_largeStar *@globals
        fdb   Img_star_1
        fdb   Img_star_2
        fdb   Img_star_3
        fdb   Img_star_2
        fdb   Img_star_1
        fcb   _nextSubRoutine
        fcb   1
Ani_tails *@globals
        fdb   Img_tails_1
        fdb   Img_tails_2
        fdb   Img_tails_3
        fdb   Img_tails_4
        fdb   Img_tails_5
        fcb   _nextSubRoutine
        fcb   1
Ani_sonic *@globals
        fdb   Img_sonic_1
        fdb   Img_sonic_2
        fdb   Img_sonic_3
        fdb   Img_sonic_4
        fcb   _nextSubRoutine

(include)OBJINDEX
* Generated Code

Obj_Index_Page
        fcb   $00
        fcb   $05
        fcb   $06
        fcb   $05
        fcb   $08
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
Obj_Index_Address
        fcb   $00,$00
        fcb   $DE,$F5
        fcb   $C1,$37
        fcb   $AD,$4A
        fcb   $A0,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00
        fcb   $00,$00

(include)SOUNDIDX
* Generated Code

Pcm_SEGA *@globals
        fcb   $0E,$A0,$00,$DF,$F6
        fcb   $0D,$A0,$00,$C1,$7E
        fcb   $FF
Psg_TitleScreen *@globals
        fcb   $08,$A5,$53,$AB,$5B
        fcb   $FF

(include)LOADACT
* Generated Code

LoadAct
        ldx   #$0000                   * set Background solid color
        ldb   #$62                     * load page 2
        stb   $E7E6                    * in cartridge space ($0000-$3FFF)
        jsr   ClearCartMem
        lda   $E7DD                    * set border color
        anda  #$F0
        adda  #$00                     * color ref
        sta   $E7DD
        anda  #$0F
        adda  #$80
        sta   screen_border_color+1    * maj WaitVBL
        jsr   WaitVBL
        ldx   #$0000                   * set Background solid color
        ldb   #$63                     * load page 3
        stb   $E7E6                    * in cardtridge space ($0000-$3FFF)
        jsr   ClearCartMem
        ldd   #Pal_SEGA
        std   Ptr_palette
        jsr   UpdatePalette
        rts

(include)PALETTE
* Generated Code

Pal_SEGA * @globals
        fdb   $ff0f
        fdb   $4404
        fdb   $1101
        fdb   $0000
        fdb   $0300
        fdb   $0f00
        fdb   $5e03
        fdb   $2501
        fdb   $b70b
        fdb   $740b
        fdb   $410b
        fdb   $100b
        fdb   $110c
        fdb   $0008
        fdb   $100b
        fdb   $100b

Pal_TitleScreen * @globals
        fdb   $ff0f
        fdb   $0000
        fdb   $0800
        fdb   $0200
        fdb   $5d03
        fdb   $1600
        fdb   $4f00
        fdb   $2700
        fdb   $ff00
        fdb   $f300
        fdb   $f80f
        fdb   $750c
        fdb   $530e
        fdb   $2205
        fdb   $000e
        fdb   $0100

Pal_SEGAMid * @globals
        fdb   $ff0f
        fdb   $4404
        fdb   $1101
        fdb   $0000
        fdb   $0300
        fdb   $0f00
        fdb   $5e03
        fdb   $2501
        fdb   $b70b
        fdb   $740b
        fdb   $410b
        fdb   $100b
        fdb   $110c
        fdb   $0008
        fdb   $ff0f
        fdb   $100b

Pal_SonicAndTailsIn * @globals
        fdb   $0000
        fdb   $ff0f
        fdb   $0000
        fdb   $0000
        fdb   $0000
        fdb   $0000
        fdb   $0000
        fdb   $0000
        fdb   $0000
        fdb   $0000
        fdb   $0000
        fdb   $0000
        fdb   $0000
        fdb   $0000
        fdb   $ff0f
        fdb   $ff0f

Pal_SEGAEnd * @globals
        fdb   $ff0f
        fdb   $4404
        fdb   $1101
        fdb   $0000
        fdb   $0300
        fdb   $0f00
        fdb   $5e03
        fdb   $2501
        fdb   $b70b
        fdb   $740b
        fdb   $410b
        fdb   $100b
        fdb   $110c
        fdb   $0008
        fdb   $ff0f
        fdb   $ff0f
