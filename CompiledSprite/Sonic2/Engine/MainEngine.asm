********************************************************************************
* Game Engine (TO8 Thomson) - Benoit Rousseau 07/10/2020
* ------------------------------------------------------------------------------
*
*
********************************************************************************

(main)MAIN
        INCLUD CONSTANT
        org   $6100
        setdp $00

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

* ----- Cells variables
nb_cells                      equ   0
cell_start                    equ   1
cell_end                      equ   3
next_entry                    equ   5
entry_size                    equ   7

nb_free_cells                 equ   130
cell_size                     equ   64     ; 64 bytes x 130 from $3F80 to $6000 (buffer limit is $3F40 to $6000)
cell_start_adr                equ   $6000

Lst_FreeCellFirstEntry_0      fdb   $0000  ; Pointer to first entry in free cell list (buffer 0)
Lst_FreeCell_0                rmb   entry_size*(nb_free_cells/2),0 ; (buffer 0)

Lst_FreeCellFirstEntry_1      fdb   $0000  ; Pointer to first entry in free cell list (buffer 1)
Lst_FreeCell_1                rmb   entry_size*(nb_free_cells/2),0 ; (buffer 1)

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