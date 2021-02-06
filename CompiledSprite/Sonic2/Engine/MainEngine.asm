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
Glb_Sprite_Screen_Pos_PartB   fdb   $0000 ; start address for rendering of current sprite PartB (Must follow PartA)

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
Obj_MainCharacter             fdb   $0102                      ; id=01 subtype=02
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
Object_RAM_End

* ---------------------------------------------------------------------------
* Lifecycle
* ---------------------------------------------------------------------------

Glb_MainCharacter_Is_Dead     rmb   $1,0

* ==============================================================================
* Routines
* ==============================================================================
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
        
* ==============================================================================
* Level Specific Generated Data
* IMG and ANI should be in first position
* ==============================================================================
        INCLUD IMAGEIDX
        INCLUD ANIMSCPT
        INCLUD OBJINDEX
        INCLUD LOADACT
                                                                 
