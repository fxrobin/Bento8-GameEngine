        opt   c,ct

********************************************************************************
* Game Engine (TO8 Thomson) - Benoit Rousseau 2020-2021
* ------------------------------------------------------------------------------
*
*
********************************************************************************

        INCLUDE "./GameMode/SpecialStage/Constants.asm"
        INCLUDE "./Engine/Macros.asm"        
        org   $6100

        _RunObject ObjID_HalfPipe,SpecialStageHalfPipe

* ==============================================================================
* Main Loop
* ==============================================================================
LevelMainLoop
        jsr   WaitVBL
        _RunObject ObjID_HalfPipe,SpecialStageHalfPipe
        jsr   RunObjects
        jsr   CheckSpritesRefresh                                              
        jsr   EraseSprites
        jsr   UnsetDisplayPriority
        jsr   DrawSprites       
        bra   LevelMainLoop
        
* ---------------------------------------------------------------------------
* Game Mode RAM variables
* ---------------------------------------------------------------------------
        
        INCLUDE "./Objects/SpecialStage/SpecialStageVariables.asm"        
        
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
* Engine
* ---------------------------------------------------------------------------

Glb_Page                      fcb   $00
Glb_Address                   fdb   $0000

* ---------------------------------------------------------------------------
* Level (Game Mode)
* ---------------------------------------------------------------------------

Glb_Cur_Game_Mode             fcb   GmID_SpecialStage
Glb_Next_Game_Mode            fcb   GmID_SpecialStage
Glb_Cur_Act                   fcb   $00

* ---------------------------------------------------------------------------
* Display
* ---------------------------------------------------------------------------

Glb_Cur_Wrk_Screen_Id         fcb   $00   ; screen buffer set to write operations (0 or 1)

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
nb_free_cells                 equ   128
cell_size                     equ   64     ; 64 bytes x 128 from $4000 to $5FFF
cell_start_adr                equ   $6000

Lst_FreeCellFirstEntry_0      fdb   Lst_FreeCell_0 ; Pointer to first entry in free cell list (buffer 0)
Lst_FreeCell_0                fcb   nb_free_cells ; init of first free cell
                              fdb   cell_start_adr-cell_size*nb_free_cells
                              fdb   cell_start_adr
                              fdb   $0000
                              fill  0,(entry_size*(nb_free_cells/2))-1 ; (buffer 0)
                              
Lst_FreeCellFirstEntry_1      fdb   Lst_FreeCell_1 ; Pointer to first entry in free cell list (buffer 1)
Lst_FreeCell_1                fcb   nb_free_cells ; init of first free cell
                              fdb   cell_start_adr-cell_size*nb_free_cells
                              fdb   cell_start_adr
                              fdb   $0000
                              fill  0,(entry_size*(nb_free_cells/2))-1 ; (buffer 1)
* ---------------------------------------------------------------------------
* Display Priority Structure - DPS
* ---------------------------------------------------------------------------

DPS_buffer_0
Tbl_Priority_First_Entry_0    fill  0,2+(nb_priority_levels*2) ; first address of object in linked list for each priority index (buffer 0) index 0 unused
Tbl_Priority_Last_Entry_0     fill  0,2+(nb_priority_levels*2) ; last address of object in linked list for each priority index (buffer 0) index 0 unused
Lst_Priority_Unset_0          fdb   Lst_Priority_Unset_0+2     ; pointer to end of list (initialized to its own address+2) (buffer 0)
                              fill  0,(nb_objects*2)           ; objects to delete from priority list
DPS_buffer_1                              
Tbl_Priority_First_Entry_1    fill  0,2+(nb_priority_levels*2) ; first address of object in linked list for each priority index (buffer 1) index 0 unused
Tbl_Priority_Last_Entry_1     fill  0,2+(nb_priority_levels*2) ; last address of object in linked list for each priority index (buffer 1) index 0 unused
Lst_Priority_Unset_1          fdb   Lst_Priority_Unset_1+2     ; pointer to end of list (initialized to its own address+2) (buffer 1)
                              fill  0,(nb_objects*2)           ; objects to delete from priority list
                              
buf_Tbl_Priority_First_Entry  equ   0                                                            
buf_Tbl_Priority_Last_Entry   equ   Tbl_Priority_Last_Entry_0-DPS_buffer_0          
buf_Lst_Priority_Unset        equ   Lst_Priority_Unset_0-DPS_buffer_0

* ---------------------------------------------------------------------------
* Sub Priority Objects List - SOL
* ---------------------------------------------------------------------------

Tbl_Sub_Object_Erase          fill  0,nb_objects*2             ; entries of objects that have erase flag in the order back to front
Tbl_Sub_Object_Draw           fill  0,nb_objects*2             ; entries of objects that have draw flag in the order back to front

* ==============================================================================
* Routines
* ==============================================================================
        INCLUDE "./Engine/Graphics/WaitVBL.asm"
        INCLUDE "./Engine/Graphics/DrawFullscreenImage.asm"	
        INCLUDE "./Engine/Graphics/AnimateSprite.asm"	
        INCLUDE "./Engine/Graphics/DisplaySprite.asm"	
        INCLUDE "./Engine/Graphics/CheckSpritesRefresh.asm"
        INCLUDE "./Engine/Graphics/EraseSprites.asm"
        INCLUDE "./Engine/Graphics/UnsetDisplayPriority.asm"
        INCLUDE "./Engine/Graphics/DrawSprites.asm"
        INCLUDE "./Engine/Graphics/BgBufferAlloc.asm"	
        INCLUDE "./Engine/Joypad/ReadJoypads.asm"
        INCLUDE "./Engine/ObjectManagement/RunObjects.asm"
        INCLUDE "./Engine/ObjectManagement/DeleteObject.asm"
        INCLUDE "./Engine/ObjectManagement/ClearObj.asm"
        INCLUDE "./Engine/ObjectManagement/RunPgSubRoutine.asm"	
        INCLUDE "./Engine/LevelManagement/LoadGameMode.asm"	
        INCLUDE "./Engine/Ram/ClearDataMemory.asm"
	INCLUDE "./Engine/Palette/UpdatePalette.asm"
        INCLUDE "./Engine/Sound/PSGlib.asm"
        INCLUDE "./Engine/Irq/IrqPsg.asm"	