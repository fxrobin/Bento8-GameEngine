********************************************************************************
* Game Engine (TO8 Thomson) - Benoit Rousseau 07/10/2020
* ------------------------------------------------------------------------------
*
*
********************************************************************************

(main)MAIN
        INCLUD CONSTANT
        org   $6000

********************************************************************************  
* Main Loop
********************************************************************************
LevelMainLoop
        jsr   WaitVBL
        jsr   UpdatePalette
        jsr   ReadJoypads
        jsr   RunObjects
        jsr   CheckSpritesRefresh
        jsr   EraseSprites
        jsr   UnsetDisplayPriority
        jsr   DrawSprites
        bra   LevelMainLoop

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
Glb_Cur_Wrk_Screen_Id_x2      fcb   $00   ; precalculated value
Glb_Camera_X_Pos              fdb   $0000 ; camera x position in palyfield coordinates
Glb_Camera_Y_Pos              fdb   $0000 ; camera y position in palyfield coordinates
Glb_Sprite_Screen_Pos_PartA   fdb   $0000 ; start address for rendering of current sprite PartA     
Glb_Sprite_Screen_Pos_PartB   fdb   $0000 ; start address for rendering of current sprite PartB

* ---------------------------------------------------------------------------
* Background Backup Cells - BBC
* ---------------------------------------------------------------------------

nb_free_cells                 equ   130
cell_size                     equ   64     ; 64 bytes x 130 from $3F80 to $6000 (buffer limit is $3F40 to $6000)
cell_start_adr                equ   $6000

Lst_FreeCellFirstEntry_0      fdb   $0000  ; Pointer to first entry in free cell list (buffer 0)
Lst_FreeCell_0                rmb   cell_size*(nb_free_cells/2),0 ; (buffer 0)

Lst_FreeCellFirstEntry_1      fdb   $0000  ; Pointer to first entry in free cell list (buffer 1)
Lst_FreeCell_1                rmb   cell_size*(nb_free_cells/2),0 ; (buffer 1)

* ----- Cells variables
nb_cells                      equ   0
cell_start                    equ   1
cell_end                      equ   3
next_entry                    equ   5
entry_size                    equ   7

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
* Sub Objects List - SOL
* ---------------------------------------------------------------------------

Tbl_Sub_Object_Erase          rmb   nb_objects*2,0             ; entries of objects that have erase flag in the order back to front
Tbl_Sub_Object_Draw           rmb   nb_objects*2,0             ; entries of objects that have draw flag in the order back to front

* ---------------------------------------------------------------------------
* Object Status Table - OST
* ---------------------------------------------------------------------------
        
Object_RAM *@globals
Reserved_Object_RAM
Obj_MainCharacter             rmb   object_size,0
Obj_Sidekick                  rmb   object_size,0
Reserved_Object_RAM_End
Dynamic_Object_RAM            rmb   nb_dynamic_objects*object_size,0
Dynamic_Object_RAM_End
LevelOnly_Object_RAM
Obj_TailsTails                rmb   object_size,0
Obj_SonicDust                 rmb   object_size,0
Obj_TailsDust                 rmb   object_size,0
LevelOnly_Object_RAM_End
Object_RAM_End

* ---------------------------------------------------------------------------
* Lifecycle
* ---------------------------------------------------------------------------

Glb_MainCharacter_Is_Dead     rmb   $1,0

* ---------------------------------------------------------------------------
* Get Orientation To Player
* ---------------------------------------------------------------------------

Glb_Closest_Player            rmb   $2,0  ; ptr objet de MainCharacter ou Sidekick
Glb_Player_Is_Left            rmb   $1,0  ; 0: player left from object, 2: right
Glb_Player_Is_Above           rmb   $1,0  ; 0: player above object, 2: below
Glb_Player_H_Distance         rmb   $2,0  ; closest character's h distance to obj
Glb_Player_V_Distance         rmb   $2,0  ; closest character's v distance to obj 
Glb_Abs_H_Distance_Mainc      rmb   $2,0  ; absolute horizontal distance to main character
Glb_H_Distance_Sidek          rmb   $2,0  ; horizontal distance to sidekick

* ==============================================================================
* Routines
* ==============================================================================
        INCLUD WAITVBL
        INCLUD UPDTPAL
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
(info)

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
        
        lda   Glb_Cur_Wrk_Screen_Id
        ora   1
        sta   Glb_Cur_Wrk_Screen_Id
        lsla
        sta   Glb_Cur_Wrk_Screen_Id_x2
                
SwapVideoPage
        ldb   am_SwapVideoPage+1 * charge la valeur du ldb suivant am_SwapVideoPage
        andb  #$40               * alterne bit6=0 et bit6=1 (suivant la valeur B $00 ou $FF)
        orb   #$80               * bit7=1, bit3 a bit0=couleur de cadre (ici 0)
        stb   $E7DD              * changement page (2 ou 3) affichee a l'ecran
        com   am_SwapVideoPage+1 * alterne $00 et $FF sur le ldb suivant am_SwapVideoPage
am_SwapVideoPage
        ldb   #$00
        andb  #$01               * alterne bit0=0 et bit0=1 (suivant la valeur B $00 ou $FF)
        orb   #$62               * bit6=1, bit5=1, bit1=1
        stb   $E7E6              * changement page (2 ou 3) visible dans l'espace cartouche
        ldb   $E7C3              * charge l'identifiant de la Demi-Page 0 configuree en espace ecran
        andb  #$01
        bne   SwapVideoPage_01   * si bit0==1, branch
        inc   $E7C3              * bit0=1 changement demi-page RAMB de la page 0 visible dans l'espace ecran
        rts
SwapVideoPage_01
        dec   $E7C3              * bit0=0 changement demi-page RAMA de la page 0 visible dans l'espace ecran
        rts
        
Vint_runcount rmb   $2,0 *@globals

(include)UPDTPAL
********************************************************************************
* Mise a jour de la palette
********************************************************************************
* TODO ajout systeme de refresh pour ne pas update la palette a chaque passage
* ou integrer le refresh palette en debut d'overscan avant que le faisceau entre en visu
* palette doit etre refresh avant le tracage avec les donnees de la precedente frame pas la nouvelle

cpt            fcb   $00
Ptr_palette    equ   Normal_palette
Normal_palette rmb   $20,0   *@globals
Black_palette  rmb   $20,0   *@globals
White_palette  rmb   $20,$FF *@globals

UpdatePalette
    	ldy   [Ptr_palette]
    	ldx   [Ptr_palette]
    	leax  $20,x
    	clr   cpt                      * registre A a 0
SetColor
        lda   cpt			           * sauvegarde A
    	asla				           * multiplication par deux de A 
    	sta   $E7DB			           * determine l'indice de couleur (x2): 0=0, 1=2, 2=4, .. 15=30
    	ldd   ,y++			           * chargement de la couleur et increment du poiteur Y
    	stb   $E7DA			           * set de la couleur Vert et Rouge
    	sta   $E7DA                    * set de la couleur Bleu
    	inc   cpt			           * et increment de A
    	cmpy  ,x                       * test fin de liste
    	bne   SetColor                 * on reboucle si fin de liste pas atteinte
        rts


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

Joypads
Joypads_Held
Dpad_Held                    fcb   $00
Fire_Held                    fcb   $00
Joypads_Press
Dpad_Press                   fcb   $00
Fire_Press                   fcb   $00

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
        ldd   #$E7CC                   *    or.b    d1,d0             ; Fuse together into one controller bit array
        coma                           *    not.b   d0
        comb
                                       *    move.b  (a0),d1           ; Get held button data
                                       *    eor.b   d0,d1             ; Toggle off buttons that are being held                               
                                       *    move.b  d0,(a0)+          ; Put raw controller input (for held buttons) in F604/F606
        std   Joypads_Held
        eora  Dpad_Held
        eorb  Fire_Held
        anda  Dpad_Held                *    and.b   d0,d1
        andb  Fire_Held
        std   Joypads_Press            *    move.b  d1,(a0)+          ; Put pressed controller input in F605/F607
        rts                            *    rts
                                       *; End of function Joypad_Read


(include)RUNOBJTS
* -------------------------------------------------------------------------------
* This runs the code of all the objects that are in Object_RAM
*
* ecart par rapport au code d'origine :
* Il n'y a pas de tableau de pointeur Obj_Index, les ids d'objets sont l'adresse
* du code de l'objet
* -------------------------------------------------------------------------------

                                       *; -------------------------------------------------------------------------------
                                       *; This runs the code of all the objects that are in Object_RAM
                                       *; -------------------------------------------------------------------------------
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; sub_15F9C: ObjectsLoad:
RunObjects                             *RunObjects:
                                       *    tst.b   (Teleport_flag).w
                                       *    bne.s   RunObjects_End  ; rts
        ldy   #Object_RAM              *    lea (Object_RAM).w,a0 ; a0=object
                                       *
                                       *    moveq   #(Dynamic_Object_RAM_End-Object_RAM)/object_size-1,d7 ; run the first $80 objects out of levels
                                       *    moveq   #0,d0
                                       *    cmpi.b  #GameModeID_Demo,(Game_Mode).w  ; demo mode?
                                       *    beq.s   +   ; if in a level in a demo, branch
                                       *    cmpi.b  #GameModeID_Level,(Game_Mode).w ; regular level mode?
                                       *    bne.s   RunObject ; if not in a level, branch to RunObject
RunObjects_01                          *+
                                       *    move.w  #(Object_RAM_End-Object_RAM)/object_size-1,d7   ; run the first $90 objects in levels
                                       *    tst.w   (Two_player_mode).w
                                       *    bne.s   RunObject ; if in 2 player competition mode, branch to RunObject
                                       *
                                       *    cmpi.b  #6,(MainCharacter+routine).w
        tst   Glb_MainCharacter_Is_Dead
        beq   RunObjectsWhenPlayerIsDead
                                       *    bhs.s   RunObjectsWhenPlayerIsDead ; if dead, branch
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
RunObject                              *RunObject:
        ldu   ,y                       *    move.b  id(a0),d0   ; get the object's ID
        beq   RunNextObject            *    beq.s   RunNextObject ; if it's obj00, skip it
                                       *
                                       *    add.w   d0,d0
                                       *    add.w   d0,d0   ; d0 = object ID * 4
                                       *    movea.l Obj_Index-4(pc,d0.w),a1 ; load the address of the object's code
        jsr   ,u                       *    jsr (a1)    ; dynamic call! to one of the the entries in Obj_Index
                                       *    moveq   #0,d0
                                       *
                                       *; loc_15FDC:
RunNextObject                          *RunNextObject:
        leay  next_object,y            *    lea next_object(a0),a0 ; load 0bj address
am_RunNextObject
        cmpy  #Object_RAM_End          *    dbf d7,RunObject
        bne   RunObject                *; return_15FE4:
RunObjects_End                         *RunObjects_End:
        rts                            *    rts
                                       *
                                       *; ---------------------------------------------------------------------------
                                       *; this skips certain objects to make enemies and things pause when Sonic dies
                                       *; loc_15FE6:
RunObjectsWhenPlayerIsDead             *RunObjectsWhenPlayerIsDead:
                                       *    moveq   #(Reserved_Object_RAM_End-Reserved_Object_RAM)/object_size-1,d7
                                       *    bsr.s   RunObject   ; run the first $10 objects normally
        ldy   #Reserved_Object_RAM
        ldx   #Reserved_Object_RAM_End
        stx   am_RunNextObject+2
        bsr   RunObject
                                       *    moveq   #(Dynamic_Object_RAM_End-Dynamic_Object_RAM)/object_size-1,d7
                                       *    bsr.s   RunObjectDisplayOnly ; all objects in this range are paused      
        ldy   #Dynamic_Object_RAM
        bsr   RunObjectDisplayOnly                            
                                       *    moveq   #(LevelOnly_Object_RAM_End-LevelOnly_Object_RAM)/object_size-1,d7
                                       *    bra.s   RunObject   ; run the last $10 objects normally
        ldy   #LevelOnly_Object_RAM 
        ldx   #LevelOnly_Object_RAM_End
        stx   am_RunNextObject+2    
        bra   RunObject                                          
                                       *
        ldx   #Object_RAM_End          * repositionne la fin du RunObject avec sa valeur par d�faut
        stx   am_RunNextObject+2
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; sub_15FF2:
RunObjectDisplayOnly                   *RunObjectDisplayOnly:
                                       *    moveq   #0,d0
        ldu   ,y                       *    move.b  id(a0),d0   ; get the object's ID
        beq   RunNextObjectDisplayOnly *    beq.s   +   ; if it's obj00, skip it
        tst   render_flags,y           *    tst.b   render_flags(a0)    ; should we render it?
        bpl   RunNextObjectDisplayOnly *    bpl.s   +           ; if not, skip it
        bsr   DisplaySprite            *    bsr.w   DisplaySprite
RunNextObjectDisplayOnly               *+
        leay  next_object,y            *    lea next_object(a0),a0 ; load 0bj address
        cmpy  #Dynamic_Object_RAM_End  *    dbf d7,RunObjectDisplayOnly
        bne   RunObjectDisplayOnly
        rts                            *    rts
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
        lda   Glb_Cur_Wrk_Screen_Id         ; read current screen buffer for write operations
        bne   DSP_SetBuffer1
        
DSP_SetBuffer0        
        leax  rsv_buffer_0,u                ; set x pointer to object variables that belongs to screen buffer 0
        ldy   DPS_buffer_0                  ; set y pointer to Display Priority Structure that belongs to screen buffer 0
        bra   DSP_BufferPositionned
        
DSP_SetBuffer1       
        leax  rsv_buffer_1,u                ; set x pointer to object variables that belongs to screen buffer 1
        ldy   DPS_buffer_1                  ; set y pointer to Display Priority Structure that belongs to screen buffer 1        
        
DSP_BufferPositionned       
        lda   priority,u                    ; read priority set for this object
        cmpa  buf_priority,x
        beq   DSP_rts                       ; priority and current priority are the same: nothing to do
        ldb   buf_priority,x   
        bne   DSP_ChangePriority
        
DSP_InitPriority
        sta   buf_priority,x                ; init priority for this screen buffer with priority from object
        
DSP_CheckLastEntry
        leay  buf_Tbl_Priority_Last_Entry,y
        tst   a,y                           ; test left byte only is ok, no object will be stored at $00__ address
        bne   DSP_addToExistingNode         ; not the first object at this priority level, branch
        
DSP_addFirstNode        
        stu   a,y                           ; save object as last entry in linked list
        leay  buf_Tbl_Priority_First_Entry-buf_Tbl_Priority_Last_Entry,y
        stu   a,y                           ; save object as first entry in linked list
        ldd   0
        std   buf_priority_prev_obj,x       ; clear object prev and next link, it's the only object at this priority level
        std   buf_priority_next_obj,x
        bra   DSP_rts
        
DSP_addToExistingNode
        ldx   [a,y]                         ; x register now store last object at the priority level of current object
        ldb   Glb_Cur_Wrk_Screen_Id
        bne   DSP_LinkBuffer1
        stu   rsv_priority_next_obj_0,x     ; link last object with current object if active screen buffer 0
        bra   DSP_LinkCurWithPrev        
DSP_LinkBuffer1        
        stu   rsv_priority_next_obj_1,x     ; link last object with current object if active screen buffer 1
        
DSP_LinkCurWithPrev        
        stx   buf_priority_prev_obj,u       ; link current object with previous object
        stu   a,y                           ; update last object in index
        ldd   0
        std   buf_priority_next_obj,x       ; clear object next link                
        bra   DSP_rts
        
DSP_ChangePriority
        leay  buf_Lst_Priority_Unset,y
        stu   [,y]                          ; add object address to unset list
        leay  2,y
        sty   ,y                            ; set index to next free cell of unset list
        leay  -buf_Lst_Priority_Unset-2,y
        cmpa  0
        bne   DSP_CheckLastEntry            ; priority is != 0, branch to add object to display priority list

DSP_rts
        puls  d,x,u,pc
        
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
AnimateSprite                               *AnimateSprite:
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
        ldb   ,x                            
		stb   anim_frame_duration,u         *    move.b  (a1),anim_frame_duration(a0) ; load frame duration
                                            *    moveq   #0,d1
        ldb   anim_frame,u                  *    move.b  anim_frame(a0),d1 ; load current frame number
        incb                                
        aslb
        leay  b,x                                
        ldd   ,y                            *    move.b  1(a1,d1.w),d0 ; read sprite number from script
        * bmi   Anim_End_FF                 *    bmi.s   Anim_End_FF   ; if animation is complete, branch MJ: Delete this line
		cmpa  #$FA                          *    cmp.b   #$FA,d0       ; MJ: is it a flag from FA to FF?
		bhs   Anim_End_FF                   *    bhs     Anim_End_FF   ; MJ: if so, branch to flag routines
                                            *; loc_1657C:
Anim_Next                                   *Anim_Next:
	    * ne pas utiliser                   *    andi.b  #$7F,d0               ; clear sign bit
        std   mapping_frame,u               *    move.b  d0,mapping_frame(a0)  ; load sprite number
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
        ldd   1,x                           *    move.b  1(a1),d0          ; read sprite number
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
        inc   routine,u                     
        inc   routine,u                     *    addq.b  #2,routine(a0) ; jump to next routine
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
        inc   routine_secondary,u           *    addq.b  #2,routine_secondary(a0) ; jump to next routine
        inc   routine_secondary,u    
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
        tfr   x,u                      *; sub_164E8:
        bra   DOB_Start
DeleteObject *@globals                 *DeleteObject2:
        pshs  d,x,u
DOB_Start
        lda   rsv_onscreen_0,u
        beq   DOB_TestOnscreen1Delete  ; branch if not onscreen on buffer 0
        
DOB_Unset0        
        ldx   Lst_Priority_Unset_0     ; add object to unset list on buffer 0
        stu   ,x
        leax  2,x
        stx   Lst_Priority_Unset_0
        
DOB_TestOnscreen1
        lda   rsv_onscreen_1,u
        beq   DOB_ToDeleteFlag         ; branch if not onscreen on buffer 1
        
DOB_Unset1
        ldx   Lst_Priority_Unset_1     ; add object to unset list on buffer 1                       
        stu   ,x
        leax  2,x
        stx   Lst_Priority_Unset_1
        bra  DOB_ToDeleteFlag 
        
DOB_TestOnscreen1Delete
        lda   rsv_onscreen_1,u
        bne   DOB_Unset1               ; branch if onscreen on buffer 1        

        jsr   ClearObj                 ; this object is not onscreen anymore, clear this object now
        bra   DOB_rts
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
DOB_ToDeleteFlag                                       
        lda   render_flags,u
        ora   render_todelete_mask
        sta   render_flags,u           ; set todelete flag, object will be deleted after sprite erase on all screen buffers
                                               
DOB_rts
        puls  d,x,u,pc                 *    rts
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
        sts   CLO_1+2
        stx   CLO_2+2        
        ldd   #$0000
        ldx   #$0000
        leay  ,x
        leas  ,x
        leau  object_size,u
        pshu  d,x,y,s
        pshu  d,x,y,s
        pshu  d,x,y,s
        pshu  d,x,y,s
        pshu  d,x,y,s
        pshu  d,x,y,s
        pshu  d,x,y,s
        pshu  d,x,y,s
        pshu  d,x,y,s
        pshu  d,x,y,s
CLO_1        
        lds   #$0000
CLO_2        
        ldx   #$0000        
        rts

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
        lda   rsv_buffer_0                  ; set offset a to object variables that belongs to screen buffer 0
        sta   CSR_ProcessEachPriorityLevel+2    
CSR_P8B0                                    
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+14 ; read DPS from priority 8 to priority 1
        beq   CSR_P7B0
        lda   #$08
        sta   cur_priority        
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P7B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+12
        beq   CSR_P6B0
        dec   cur_priority               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P6B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+10
        beq   CSR_P5B0
        dec   cur_priority               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P5B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+8
        beq   CSR_P4B0
        dec   cur_priority               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P4B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+6
        beq   CSR_P3B0
        dec   cur_priority               
        jsr   CSR_ProcessEachPriorityLevel               
CSR_P3B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+4
        beq   CSR_P2B0
        dec   cur_priority               
        jsr   CSR_ProcessEachPriorityLevel      
CSR_P2B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+2
        beq   CSR_P1B0
        dec   cur_priority               
        jsr   CSR_ProcessEachPriorityLevel  
CSR_P1B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry
        beq   CSR_rtsB0
        dec   cur_priority               
        jsr   CSR_ProcessEachPriorityLevel
CSR_rtsB0        
        rts
        
CSR_SetBuffer1       
        lda   rsv_buffer_1                  ; set offset a to object variables that belongs to screen buffer 1
        sta   CSR_ProcessEachPriorityLevel+2        
CSR_P8B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+14 ; read DPS from priority 8 to priority 1
        beq   CSR_P7B1
        lda   #$08
        sta   cur_priority        
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P7B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+12
        beq   CSR_P6B1
        dec   cur_priority               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P6B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+10
        beq   CSR_P5B1
        dec   cur_priority               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P5B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+8
        beq   CSR_P4B1
        dec   cur_priority               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P4B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+6
        beq   CSR_P3B1
        dec   cur_priority               
        jsr   CSR_ProcessEachPriorityLevel               
CSR_P3B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+4
        beq   CSR_P2B1
        dec   cur_priority               
        jsr   CSR_ProcessEachPriorityLevel      
CSR_P2B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+2
        beq   CSR_P1B1
        dec   cur_priority               
        jsr   CSR_ProcessEachPriorityLevel  
CSR_P1B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry
        beq   CSR_rtsB1
        dec   cur_priority               
        jsr   CSR_ProcessEachPriorityLevel
CSR_rtsB1        
        rts

CSR_ProcessEachPriorityLevel
        leax  16,u                          ; dynamic offset, x point to object variables relative to current writable buffer (beware that rsv_buffer_0 and rsv_buffer_1 should be equ >=16)
        lda   rsv_render_flags,u
        anda  #rsv_render_checkrefresh_mask ; branch if checkrefresh is true
        lbne  CSR_CheckErase
        
CSR_CheckDelHide
        lda   render_flags,u
        anda  #render_hide_mask!render_todelete_mask
        bne   CSR_DoNotDisplaySprite      

CSR_UpdSpriteImageBasedOnMirror
        lda   rsv_render_flags,u
        ora   #rsv_render_checkrefresh_mask
        sta   rsv_render_flags,u            ; set checkrefresh flag 
        lda   render_flags,u                ; set image to display based on x and y mirror flags
        anda  #render_xmirror_mask!render_ymirror_mask
        ldb   #image_meta_size
        mul
        addd  mapping_frame,u
        std   rsv_curr_mapping_frame,u
        
CSR_CheckPlayFieldCoord
        lda   render_flags,u
        anda  #render_playfieldcoord_mask
        beq   CSR_CheckVerticalPosition     ; branch if position is already expressed in screen coordinate
        
        ldd   x_pos,u
        subd  Glb_Camera_X_Pos
        ldy   rsv_curr_mapping_frame,u
        addd  image_x_offset,y
        bvs   CSR_SetOutOfRange             ; top left coordinate overflow of image
        bmi   CSR_SetOutOfRange             ; branch if (x_pixel < 0)
        stb   x_pixel,u
        addb  image_x_size,y
        bvs   CSR_SetOutOfRange             ; bottom rigth coordinate overflow of image
        stb   rsv_x2_pixel,u
        cmpb  #screen_width
        bgt   CSR_SetOutOfRange             ; branch if (x_pixel + image.x_size > screen width)

        ldd   y_pos,u
        subd  Glb_Camera_Y_Pos
        addd  image_y_offset,y
        bvs   CSR_SetOutOfRange             ; top left coordinate overflow of image        
        bmi   CSR_SetOutOfRange             ; branch if (y_pixel < 0)
        stb   y_pixel,u        
        addb  image_y_size,y
        bvs   CSR_SetOutOfRange             ; bottom rigth coordinate overflow of image
        stb   rsv_y2_pixel,u
        cmpb  #screen_height
        bgt   CSR_SetOutOfRange             ; branch if (y_pixel + image.y_size > screen height)
        lda   rsv_render_flags,u
        anda  #:rsv_render_outofrange_mask  ; unset out of range flag
        sta   rsv_render_flags,u
        bra   CSR_CheckErase
        
CSR_DoNotDisplaySprite        
        lda   rsv_render_flags,u
        anda  #:rsv_render_erasesprite_mask&:rsv_render_displaysprite_mask ; set erase and display flag to false
        sta   rsv_render_flags,u        
        ldb   buf_onscreen,x
        beq   CSR_NextObject                ; branch if not on screen
        ora   #rsv_render_erasesprite_mask  ; set erase flag to true if on screen                  
        sta   rsv_render_flags,u
        
        ldy   cur_ptr_sub_obj_erase
        sty   rsv_ptr_sub_object_erase,u
        stu   ,y++
        sty   cur_ptr_sub_obj_erase 
        
CSR_NextObject
        ldu   buf_priority_next_obj,x
        lbne  CSR_ProcessEachPriorityLevel   
        rts

CSR_CheckVerticalPosition
        ldb   y_pixel,u                     ; in screen coordinate mode, image offset is managed by object
        addd  image_y_size,y
        bvs   CSR_SetOutOfRange             ; bottom rigth coordinate overflow of image
        cmpd  #screen_height
        bgt   CSR_SetOutOfRange             ; branch if (y_pixel + image.y_size > screen height)
        lda   rsv_render_flags,u
        anda  #:rsv_render_outofrange_mask  ; unset out of range flag
        sta   rsv_render_flags,u
        bra   CSR_CheckErase
                
CSR_SetOutOfRange
        lda   rsv_render_flags,u
        ora   #rsv_render_outofrange_mask   ; set out of range flag
        sta   rsv_render_flags,u

CSR_CheckErase
        lda   buf_priority,x
        cmpa  cur_priority 
        bne   CSR_CheckDraw
        
        ldy   cur_ptr_sub_obj_erase
        sty   rsv_ptr_sub_object_erase,u
        
        lda   buf_onscreen,x
        beq   CSR_SetEraseFalse             ; branch if object is not on screen
        ldd   x_pixel,u                     ; load x_pixel and y_pixel
        cmpd  buf_prev_x_pixel,x
        bne   CSR_SetEraseTrue              ; branch if object moved since last frame
        ldd   rsv_curr_mapping_frame,u
        cmpd  buf_prev_mapping_frame,x
        bne   CSR_SetEraseTrue              ; branch if object image changed since last frame
        lda   priority,u
        cmpa  buf_priority,x
        bne   CSR_SetEraseTrue              ; branch if object priority changed since last frame
        bra   CSR_SetEraseFalse             ; branch if object is on screen but unchanged since last frame
        
CSR_SetEraseTrue        
        lda   rsv_render_flags,u
        ora   #rsv_render_erasesprite_mask
        
        stu   ,y++
        sty   cur_ptr_sub_obj_erase
                
        bra   CSR_CheckDraw
        
CSR_SetEraseFalse
        lda   rsv_render_flags,u
        anda  #:rsv_render_erasesprite_mask
        
CSR_CheckDraw
        lda   priority,u
        cmpa  cur_priority 
        bne   CSR_NextObject
        
        ldy   cur_ptr_sub_obj_draw
        sty   rsv_ptr_sub_object_draw,u
        
        lda   rsv_render_flags,u
        anda  #rsv_render_outofrange_mask
        bne   CSR_SetDrawFalse              ; branch if object image is out of range
        ldd   rsv_curr_mapping_frame,u
        beq   CSR_SetDrawFalse              ; branch if object have no image
        lda   render_flags
        anda  #render_hide_mask
        bne   CSR_SetDrawFalse              ; branch if object is hidden
        
CSR_SetDrawTrue 
        lda   rsv_render_flags,u
        ora   #rsv_render_displaysprite_mask     
        
        stu   ,y++
        sty   cur_ptr_sub_obj_draw
        
        ldu   buf_priority_next_obj,x
        lbne   CSR_ProcessEachPriorityLevel   
        rts

CSR_SetDrawFalse 
        lda   rsv_render_flags,u
        anda  #:rsv_render_displaysprite_mask
        
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
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry ; read DPS from priority 1 to priority 8
        beq   ESP_P2B0
        lda   #$01
        sta   ESP_CheckPriorityB0+1
        jsr   ESP_ProcessEachPriorityLevelB0
ESP_P2B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+2
        beq   ESP_P3B0
        inc   ESP_CheckPriorityB0+1
        jsr   ESP_ProcessEachPriorityLevelB0   
ESP_P3B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+4
        beq   ESP_P4B0
        inc   ESP_CheckPriorityB0+1               
        jsr   ESP_ProcessEachPriorityLevelB0   
ESP_P4B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+6
        beq   ESP_P5B0
        inc   ESP_CheckPriorityB0+1               
        jsr   ESP_ProcessEachPriorityLevelB0   
ESP_P5B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+8
        beq   ESP_P6B0
        inc   ESP_CheckPriorityB0+1               
        jsr   ESP_ProcessEachPriorityLevelB0               
ESP_P6B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+10
        beq   ESP_P7B0
        inc   ESP_CheckPriorityB0+1               
        jsr   ESP_ProcessEachPriorityLevelB0      
ESP_P7B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+12
        beq   ESP_P8B0
        inc   ESP_CheckPriorityB0+1               
        jsr   ESP_ProcessEachPriorityLevelB0  
ESP_P8B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+14
        beq   ESP_rtsB0
        inc   ESP_CheckPriorityB0+1               
        jsr   ESP_ProcessEachPriorityLevelB0
ESP_rtsB0        
        rts
        
ESP_P1B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry ; read DPS from priority 1 to priority 8
        beq   ESP_P2B1
        lda   #$08
        sta   ESP_CheckPriorityB1+1        
        jsr   ESP_ProcessEachPriorityLevelB1   
ESP_P2B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+2
        beq   ESP_P3B1
        lda   #$07
        sta   ESP_CheckPriorityB1+1               
        jsr   ESP_ProcessEachPriorityLevelB1   
ESP_P3B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+4
        beq   ESP_P4B1
        lda   #$06
        sta   ESP_CheckPriorityB1+1               
        jsr   ESP_ProcessEachPriorityLevelB1   
ESP_P4B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+6
        beq   ESP_P5B1
        lda   #$05
        sta   ESP_CheckPriorityB1+1               
        jsr   ESP_ProcessEachPriorityLevelB1   
ESP_P5B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+8
        beq   ESP_P6B1
        lda   #$04
        sta   ESP_CheckPriorityB1+1               
        jsr   ESP_ProcessEachPriorityLevelB1               
ESP_P6B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+10
        beq   ESP_P7B1
        lda   #$03
        sta   ESP_CheckPriorityB1+1               
        jsr   ESP_ProcessEachPriorityLevelB1      
ESP_P7B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+12
        beq   ESP_P8B1
        lda   #$02
        sta   ESP_CheckPriorityB1+1               
        jsr   ESP_ProcessEachPriorityLevelB1  
ESP_P8B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+14
        beq   ESP_rtsB1
        lda   #$01
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
        anda  #:rsv_render_checkrefresh_mask ; unset checkrefresh flag (CheckSpriteRefresh)
        sta   rsv_render_flags,u        
        
ESP_CheckEraseB0
        anda  #rsv_render_erasesprite_mask
        bne   ESP_CallEraseRoutineB0        ; branch if sprite is supposed to be refreshed
        
        * if not supposed to be refreshed check if the current sprite is rendered on screen
        
        lda   rsv_onscreen_0,u
        beq   ESP_NextObjectB0
        
        * search a collision with a sprite under the current sprite
        * the sprite under should have to be erased or displayed
        * in this case it forces the refresh of the current sprite that was not supposed to be refreshed
        * as a sub loop, this should be optimized as much as possible ... I hope it is
        
ESP_SubEraseSpriteSearchInitB0        
        ldx   rsv_ptr_sub_object_erase,u
        
ESP_SubEraseSearchB0
        cmpx  cur_ptr_sub_obj_erase
        beq   ESP_SubDrawSpriteSearchInitB0 ; branch if no more sub objects
        ldy   ,--x
        
ESP_SubEraseCheckCollisionB0
        ldd   rsv_prev_x_pixel_0,y          ; sub entry : rsv_prev_x_pixel_0 and rsv_prev_y_pixel_0 in one instruction
        cmpa  rsv_x2_pixel,u                ;     entry : x_pixel + rsv_curr_mapping_frame.x_size
        bhs   ESP_SubEraseSearchB0
        cmpb  rsv_y2_pixel,u                ;     entry : y_pixel + rsv_curr_mapping_frame.y_size
        bhs   ESP_SubEraseSearchB0
        ldd   rsv_prev_x2_pixel_0,y         ; sub entry : rsv_prev_x_pixel_0 + rsv_prev_mapping_frame_0.x_size and rsv_prev_y_pixel_0 + rsv_prev_mapping_frame_0.y_size in one instruction
        cmpa  x_pixel,u                     ;     entry : x_pixel
        bls   ESP_SubEraseSearchB0
        cmpb  y_pixel,u                     ;     entry : y_pixel
        bls   ESP_SubEraseSearchB0
        bra   ESP_SubCheckOverlayB0   

ESP_NextObjectB0
        ldu   rsv_priority_prev_obj_0,u
        bne   ESP_ProcessEachPriorityLevelB0   
        rts   

ESP_SubDrawSpriteSearchInitB0
        ldx   rsv_ptr_sub_object_draw,u
        
ESP_SubDrawSearchB0
        cmpx  cur_ptr_sub_obj_draw
        beq   ESP_SubCheckOverlayB0         ; branch if no more sub objects
        ldy   ,--x

ESP_SubDrawCheckCollisionB0
        ldd   x_pixel,y                     ; sub entry : x_pixel and y_pixel in one instruction
        cmpa  rsv_x2_pixel,u                ;     entry : x_pixel + rsv_curr_mapping_frame.x_size
        bhs   ESP_SubDrawSearchB0
        cmpb  rsv_y2_pixel,u                ;     entry : y_pixel + rsv_curr_mapping_frame.y_size
        bhs   ESP_SubDrawSearchB0
        ldd   rsv_x2_pixel,y                ; sub entry : x_pixel + rsv_curr_mapping_frame.x_size and y_pixel + rsv_curr_mapping_frame.y_size in one instruction
        cmpa  x_pixel,u                     ;     entry : x_pixel
        bls   ESP_SubDrawSearchB0
        cmpb  y_pixel,u                     ;     entry : y_pixel
        bls   ESP_SubDrawSearchB0
        
ESP_SubCheckOverlayB0
        lda   render_flags,u
        anda  #render_fixedoverlay_mask
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
        andb  #cell_size                    ; round cell_start to cell size
        tfr   d,x                           ; cell_start rounded stored in x
                        
ESP_FreeEraseBufferB0
        jsr   BgBufferFree                  ; free background data in memory
        
ESP_UnsetOnScreenFlagB0
        clr   rsv_onscreen_0,u              ; sprite is no longer on screen
        bra   ESP_NextObjectB0   

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
        anda  #:rsv_render_checkrefresh_mask ; unset checkrefresh flag (CheckSpriteRefresh)
        sta   rsv_render_flags,u        
        
ESP_CheckEraseB1
        anda  #rsv_render_erasesprite_mask
        bne   ESP_CallEraseRoutineB1        ; branch if sprite is supposed to be refreshed
        
        * if not supposed to be refreshed check if the current sprite is rendered on screen
        
        lda   rsv_onscreen_1,u
        beq   ESP_NextObjectB1
        
        * search a collision with a sprite under the current sprite
        * the sprite under should have to be erased or displayed
        * in this case it forces the refresh of the current sprite that was not supposed to be refreshed
        * as a sub loop, this should be optimized as much as possible ... I hope it is
        
ESP_SubEraseSpriteSearchInitB1        
        ldx   rsv_ptr_sub_object_erase,u
        
ESP_SubEraseSearchB1
        cmpx  cur_ptr_sub_obj_erase
        beq   ESP_SubDrawSpriteSearchInitB1 ; branch if no more sub objects
        ldy   ,--x
        
ESP_SubEraseCheckCollisionB1
        ldd   rsv_prev_x_pixel_1,y          ; sub entry : rsv_prev_x_pixel_0 and rsv_prev_y_pixel_0 in one instruction
        cmpa  rsv_x2_pixel,u                ;     entry : x_pixel + rsv_curr_mapping_frame.x_size
        bhs   ESP_SubEraseSearchB1
        cmpb  rsv_y2_pixel,u                ;     entry : y_pixel + rsv_curr_mapping_frame.y_size
        bhs   ESP_SubEraseSearchB1
        ldd   rsv_prev_x2_pixel_1,y         ; sub entry : rsv_prev_x_pixel_0 + rsv_prev_mapping_frame_0.x_size and rsv_prev_y_pixel_0 + rsv_prev_mapping_frame_0.y_size in one instruction
        cmpa  x_pixel,u                     ;     entry : x_pixel
        bls   ESP_SubEraseSearchB1
        cmpb  y_pixel,u                     ;     entry : y_pixel
        bls   ESP_SubEraseSearchB1
        bra   ESP_SubCheckOverlayB1   

ESP_NextObjectB1
        ldu   rsv_priority_prev_obj_1,u
        bne   ESP_ProcessEachPriorityLevelB1   
        rts

ESP_SubDrawSpriteSearchInitB1
        ldx   rsv_ptr_sub_object_draw,u
        
ESP_SubDrawSearchB1
        cmpx  cur_ptr_sub_obj_draw
        beq   ESP_SubCheckOverlayB1         ; branch if no more sub objects
        ldy   ,--x

ESP_SubDrawCheckCollisionB1
        ldd   x_pixel,y                     ; sub entry : x_pixel and y_pixel in one instruction
        cmpa  rsv_x2_pixel,u                ;     entry : x_pixel + rsv_curr_mapping_frame.x_size
        bhs   ESP_SubDrawSearchB1
        cmpb  rsv_y2_pixel,u                ;     entry : y_pixel + rsv_curr_mapping_frame.y_size
        bhs   ESP_SubDrawSearchB1
        ldd   rsv_x2_pixel,y                ; sub entry : x_pixel + rsv_curr_mapping_frame.x_size and y_pixel + rsv_curr_mapping_frame.y_size in one instruction
        cmpa  x_pixel,u                     ;     entry : x_pixel
        bls   ESP_SubDrawSearchB1
        cmpb  y_pixel,u                     ;     entry : y_pixel
        bls   ESP_SubDrawSearchB1
        
ESP_SubCheckOverlayB1
        lda   render_flags,u
        anda  #render_fixedoverlay_mask
        bne   ESP_UnsetOnScreenFlagB1
        
ESP_CallEraseRoutineB1
        stu   ESP_CallEraseRoutineB1_00+1   ; backup u (pointer to object)
        ldx   rsv_prev_mapping_frame_1,u    ; load previous image to erase (for this buffer) 
        lda   page_erase_routine,x
        sta   $E7E5                         ; select page 04 in RAM (A000-DFFF)
        ldu   rsv_bgdata_1,u                ; cell_start background data
        jsr   [erase_routine,x]             ; erase sprite un working screen buffer
        leay  ,u                            ; cell_end background data stored in y
ESP_CallEraseRoutineB1_00        
        ldu   #$0000                        ; restore u (pointer to object)
        ldd   rsv_bgdata_1,u                ; cell_start
        andb  #cell_size                    ; round cell_start to cell size
        tfr   d,x                           ; cell_start rounded stored in x
                        
ESP_FreeEraseBufferB1
        jsr   BgBufferFree                  ; free background data in memory
        
ESP_UnsetOnScreenFlagB1
        clr   rsv_onscreen_1,u              ; sprite is no longer on screen
        bra   ESP_NextObjectB1

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
        deca
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
        deca
        lsla
        ldy   #Tbl_Priority_Last_Entry_0
        leay  a,y
        ldd   rsv_priority_next_obj_0,u
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
        lda   rsv_onscreen_0,u
        bne   UDP_SetNewPrioB0
        lda   rsv_onscreen_1,u
        bne   UDP_SetNewPrioB0
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
        deca
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
        deca
        lsla
        ldy   #Tbl_Priority_Last_Entry_1
        leay  a,y
        ldd   rsv_priority_next_obj_1,u
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
        lda   rsv_onscreen_1,u
        bne   UDP_SetNewPrioB1
        lda   rsv_onscreen_1,u
        bne   UDP_SetNewPrioB1
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
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+14 ; read DPS from priority 8 to priority 1
        beq   DRS_P7B0
        jsr   DRS_ProcessEachPriorityLevelB0   
DRS_P7B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+12
        beq   DRS_P6B0
        jsr   DRS_ProcessEachPriorityLevelB0  
DRS_P6B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+10
        beq   DRS_P5B0
        jsr   DRS_ProcessEachPriorityLevelB0  
DRS_P5B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+8
        beq   DRS_P4B0
        jsr   DRS_ProcessEachPriorityLevelB0  
DRS_P4B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+6
        beq   DRS_P3B0
        jsr   DRS_ProcessEachPriorityLevelB0              
DRS_P3B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+4
        beq   DRS_P2B0
        jsr   DRS_ProcessEachPriorityLevelB0     
DRS_P2B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+2
        beq   DRS_P1B0
        jsr   DRS_ProcessEachPriorityLevelB0 
DRS_P1B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry
        beq   DRS_rtsB0
        jsr   DRS_ProcessEachPriorityLevelB0
DRS_rtsB0        
        rts
        
DRS_P8B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+14 ; read DPS from priority 8 to priority 1
        beq   DRS_P7B1
        jsr   DRS_ProcessEachPriorityLevelB1   
DRS_P7B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+12
        beq   DRS_P6B1
        jsr   DRS_ProcessEachPriorityLevelB1   
DRS_P6B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+10
        beq   DRS_P5B1
        jsr   DRS_ProcessEachPriorityLevelB1   
DRS_P5B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+8
        beq   DRS_P4B1
        jsr   DRS_ProcessEachPriorityLevelB1   
DRS_P4B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+6
        beq   DRS_P3B1
        jsr   DRS_ProcessEachPriorityLevelB1             
DRS_P3B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+4
        beq   DRS_P2B1
        jsr   DRS_ProcessEachPriorityLevelB1    
DRS_P2B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+2
        beq   DRS_P1B1
        jsr   DRS_ProcessEachPriorityLevelB1
DRS_P1B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry
        beq   DRS_rtsB1
        jsr   DRS_ProcessEachPriorityLevelB1
DRS_rtsB1        
        rts

DRS_ProcessEachPriorityLevelB0
        lda   rsv_render_flags,x
        anda  #rsv_render_displaysprite_mask
        beq   DRS_NextObjectB0
        lda   rsv_onscreen_0,x
        bne   DRS_NextObjectB0
        lda   render_flags,x
        anda  #render_fixedoverlay_mask
        bne   DRS_DrawWithoutBackupB0
        ldu   rsv_curr_mapping_frame,x
        lda   erase_nb_cell,u        
        jsr   BgBufferAlloc                 ; allocate free space to store sprite background data
        cmpy  #$0000                        ; y contains cell_end of allocated space 
        beq   DRS_NextObjectB0              ; branch if no more free space
        ldd   x_pixel,x                     ; load x position (0-156) and y position (0-199) in one operation
        std   rsv_prev_x_pixel_0,x          ; save previous x_pixel and y_pixel in one operation
        jsr   DRS_XYToAddress
        ldu   rsv_curr_mapping_frame,x      ; load image to draw
        stu   rsv_prev_mapping_frame_0,x    ; save previous mapping_frame 
        lda   page_bckdraw_routine,u
        sta   $E7E5                         ; select page in RAM (A000-DFFF)
        leau  ,y                            ; cell_end for background data
        stx   DRS_dyn3B0+1                  ; save x reg
        jsr   [bckdraw_routine,x]           ; backup background and draw sprite on working screen buffer
DRS_dyn3B0        
        ldx   #$0000                        ; (dynamic) restore x reg
        stu   rsv_bgdata_0,x                ; store pointer to saved background data
        ldd   rsv_x2_pixel,x                ; load x' and y' in one operation
        std   rsv_prev_x2_pixel_0,x         ; save as previous x' and y'
        lda   #$01
        sta   rsv_onscreen_0,x              ; set the onscreen flag
DRS_NextObjectB0        
        ldx   rsv_priority_next_obj_0,x
        bne   DRS_ProcessEachPriorityLevelB0   
        rts
        
DRS_DrawWithoutBackupB0
        ldd   x_pixel,x                     ; load x position (0-156) and y position (0-199) in one operation
        jsr   DRS_XYToAddress 
        ldu   rsv_curr_mapping_frame,x      ; load image to draw
        lda   page_draw_routine,u
        sta   $E7E5                         ; select page in RAM (A000-DFFF)
        stx   DRS_dyn4B0+1                  ; save x reg
        jsr   [draw_routine,x]              ; backup background and draw sprite on working screen buffer
DRS_dyn4B0
        ldx   #$0000                        ; (dynamic) restore x reg
        ldx   rsv_priority_next_obj_0,x
        bne   DRS_ProcessEachPriorityLevelB0   
        rts          

DRS_XYToAddress
        lsra                                ; x=x/2, sprites moves by 2 pixels on x axis  
        bcs   DRS_XYToAddressRAMBFirst      ; Branch if write must begin in RAMB first
DRS_XYToAddressRAMAFirst
        sta   DRS_dyn1+2
        lda   #$28                          ; 40 bytes per line in RAMA or RAMB
        ldb   y_pixel,x                     ; load y position (0-199)
        mul
DRS_dyn1        
        addd  $0000                         ; (dynamic) RAMA start at $0000
        std   Glb_Sprite_Screen_Pos_PartA
        ora   #$20                          ; add $2000 to d register
        std   Glb_Sprite_Screen_Pos_PartB        
        rts
DRS_XYToAddressRAMBFirst
        sta   DRS_dyn2+2
        lda   #$28                          ; 40 bytes per line in RAMA or RAMB
        ldb   y_pixel,x                     ; load y position (0-199)
        mul
DRS_dyn2        
        addd  $2000                         ; (dynamic) RAMB start at $0000
        std   Glb_Sprite_Screen_Pos_PartA
        subd  $1FFF
        std   Glb_Sprite_Screen_Pos_PartB
        rts
        
DRS_ProcessEachPriorityLevelB1
        lda   rsv_render_flags,x
        anda  #rsv_render_displaysprite_mask
        beq   DRS_NextObjectB1
        lda   rsv_onscreen_1,x
        bne   DRS_NextObjectB1
        lda   render_flags,x
        anda  #render_fixedoverlay_mask
        bne   DRS_DrawWithoutBackupB1
        ldu   rsv_curr_mapping_frame,x
        lda   erase_nb_cell,u        
        jsr   BgBufferAlloc                 ; allocate free space to store sprite background data
        cmpy  #$0000                        ; y contains cell_end of allocated space 
        beq   DRS_NextObjectB1              ; branch if no more free space
        ldd   x_pixel,x                     ; load x position (0-156) and y position (0-199) in one operation
        std   rsv_prev_x_pixel_1,x          ; save previous x_pixel and y_pixel in one operation
        jsr   DRS_XYToAddress
        ldu   rsv_curr_mapping_frame,x      ; load image to draw
        stu   rsv_prev_mapping_frame_1,x    ; save previous mapping_frame 
        lda   page_bckdraw_routine,u
        sta   $E7E5                         ; select page in RAM (A000-DFFF)
        leau  ,y                            ; cell_end for background data
        stx   DRS_dyn3B1+1                  ; save x reg
        jsr   [bckdraw_routine,x]           ; backup background and draw sprite on working screen buffer
DRS_dyn3B1        
        ldx   #$0000                        ; (dynamic) restore x reg
        stu   rsv_bgdata_1,x                ; store pointer to saved background data
        ldd   rsv_x2_pixel,x                ; load x' and y' in one operation
        std   rsv_prev_x2_pixel_1,x         ; save as previous x' and y'
        lda   #$01
        sta   rsv_onscreen_1,x              ; set the onscreen flag
DRS_NextObjectB1        
        ldx   rsv_priority_next_obj_1,x
        bne   DRS_ProcessEachPriorityLevelB1   
        rts
        
DRS_DrawWithoutBackupB1
        ldd   x_pixel,x                     ; load x position (0-156) and y position (0-199) in one operation
        jsr   DRS_XYToAddress 
        ldu   rsv_curr_mapping_frame,x      ; load image to draw
        lda   page_draw_routine,u
        sta   $E7E5                         ; select page in RAM (A000-DFFF)
        stx   DRS_dyn4B1+1                  ; save x reg
        jsr   [draw_routine,x]              ; backup background and draw sprite on working screen buffer
DRS_dyn4B1
        ldx   #$0000                        ; (dynamic) restore x reg
        ldx   rsv_priority_next_obj_1,x
        bne   DRS_ProcessEachPriorityLevelB1   
        rts              

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
        ora   #80                           ; set negative
        ldx   cell_end,y
        leax  d,x                           ; cell_end = cell_end - (number of requested cells * nb of bytes in a cell)
        stx   cell_end,y                    ; update cell_end
        leay  ,x                            ; return cell_end
        
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
        ldu   rsv_prev_mapping_frame_0,u    ; get sprite last image for this buffer
        lda   erase_nb_cell,u               ; get nb of cell to free
        ldu   Lst_FreeCell_0                ; get cell table for this buffer
        stu   BBF_AddNewEntryAtEnd+4        ; auto-modification to access cell table later
        ldu   Lst_FreeCellFirstEntry_0      ; load first cell for screen buffer 0
        bra   BBF_Next
        
BBF1        
        ldu   rsv_prev_mapping_frame_1,u
        lda   erase_nb_cell,u        
        ldu   Lst_FreeCell_1
        stu   BBF_AddNewEntryAtEnd+4        
        ldu   Lst_FreeCellFirstEntry_1
        
BBF_Next        
        beq   BBF_AddNewEntryAtEnd          ; loop thru all entry, branch if no more entry to expand
        cmpy  cell_start,u                  ; compare current cell_start with input param cell_end
        beq   BBF_ExpandAtStart             ; branch if current cell_start equals input param cell_end
        bhi   BBF_ExpandAtEnd               ; branch if current cell_start < input param cell_end
        ldu   next_entry,u                  ; move to next entry
        bra   BBF_Next
          
BBF_AddNewEntry
        stu   BBF_SetNewEntryNextentry+1
        leau  next_entry,u                  ; there is a previous entry, save next_entry adress to store new entry
BBF_AddNewEntryAtEnd
        stu   BBF_SetNewEntryPrevLink+1     ; if no previous entry we will be using Lst_FreeCellFirstEntry from BBF
        ldu   #$0000                        ; (dynamic) Lst_FreeCell_0 or Lst_FreeCell_1
BBF_FindFreeSlot        
        ldb   nb_cells,u                    ; read Lst_FreeCell
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
        stu   $0000                         ; (dynamic) set Lst_FreeCellFirstEntry or prev_entry.next_entry with new entry
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