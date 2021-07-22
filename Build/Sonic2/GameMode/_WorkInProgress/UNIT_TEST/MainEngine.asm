        opt   c,ct

********************************************************************************
* Game Engine (TO8 Thomson) - Benoit Rousseau 2020-2021
* ------------------------------------------------------------------------------
*
*
********************************************************************************

        INCLUDE "./GameMode/UNIT_TEST/Constants.asm"
        INCLUDE "Engine/Macros.asm"        
        org   $6100

* ==============================================================================
* Main Loop
* ==============================================================================
                                       ; init: 80 4000 6000
        lda   #$01                     ; allocate one cell
        jsr   BgBufferAlloc            ; result: 7F 4000 5FC0 y:6000
        
        lda   #$7E                     ; allocate 126 cell
        jsr   BgBufferAlloc            ; result: 01 4000 4040 y:5FC0
        
        lda   #$01                     ; allocate one cell
        jsr   BgBufferAlloc            ; result: 0000 00 4000 (4040 devrait etre 4000 mais ca ne fait pas de difference) y:4040
        
        lda   #$01                     ; allocate one cell
        jsr   BgBufferAlloc            ; result: 00 4000 (4040 devrait etre 4000 mais ca ne fait pas de difference) y:0000
        
        ; BgBufferFree - Cas 0
        
        lda   #$01
        ldu   #MainCharacter
        sta   rsv_prev_erase_nb_cell_0,u
        ldx   #$5FC0                   ; free one cell
        ldy   #$6000
        jsr   BgBufferFree
        
 ; Clean data structure        
        ldd   #Lst_FreeCell_0
        std   Lst_FreeCellFirstEntry_0

        lda   #$03
        sta   Lst_FreeCellFirstEntry_0+2
        ldd   #$4080
        std   Lst_FreeCellFirstEntry_0+3
        ldd   #$4140
        std   Lst_FreeCellFirstEntry_0+5
        ldd   #Lst_FreeCell_0+7
        std   Lst_FreeCellFirstEntry_0+7


        lda   #$01
        sta   Lst_FreeCellFirstEntry_0+9
        ldd   #$4000
        std   Lst_FreeCellFirstEntry_0+10
        ldd   #$4040
        std   Lst_FreeCellFirstEntry_0+12
        ldd   #$0000
        std   Lst_FreeCellFirstEntry_0+14
                       
        ldx   #Lst_FreeCellFirstEntry_0+16
        lda   #$00
clean_data
        sta   ,x+
        cmpx  #Lst_FreeCellFirstEntry_1
        bne   clean_data   
        
        ; BgBufferFree
        ; @6183 6185
        ; @6185 03 4080 4140 0000
        ; @618C 01 4000 4040 618C
        
        lda   #$05
        ldu   #MainCharacter
        sta   rsv_prev_erase_nb_cell_0,u
        ldx   #$5EC0                   ; free one cell
        ldy   #$6000
        jsr   BgBufferFree
        
        ; @6183 6193
        ; @6185 03 4080 4140 618C
        ; @618C 01 4000 4040 0000
        ; @6193 05 5EC0 6000 6185
        
        ; devrait etre:
        ; @6183 6193
        ; @6185 03 4080 4140 618C
        ; @618C 01 4000 4040 0000
        ; @6193 05 5EC0 6000 6185        
         
LevelMainLoop               
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
Glb_Camera_X_Pos              fdb   $0000 ; camera x position in palyfield coordinates
Glb_Camera_Y_Pos              fdb   $0000 ; camera y position in palyfield coordinates

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

* ---------------------------------------------------------------------------
* Object Status Table - OST
* ---------------------------------------------------------------------------
        
Object_RAM 
Reserved_Object_RAM
MainCharacter             fill  0,object_size
Sidekick                  fill  0,object_size
Reserved_Object_RAM_End

Dynamic_Object_RAM            fill  0,(nb_dynamic_objects)*object_size
Dynamic_Object_RAM_End

LevelOnly_Object_RAM                              * faire comme pour Dynamic_Object_RAM
Obj_TailsTails                fill  0,object_size * Positionnement et nommage a mettre dans objet Tails
Obj_SonicDust                 fill  0,object_size * Positionnement et nommage a mettre dans objet Tails
Obj_TailsDust                 fill  0,object_size * Positionnement et nommage a mettre dans objet Tails
LevelOnly_Object_RAM_End
Object_RAM_End                fdb   *

* ---------------------------------------------------------------------------
* Lifecycle
* ---------------------------------------------------------------------------

Glb_MainCharacter_Is_Dead     fcb   $00

* ==============================================================================
* Routines
* ==============================================================================
        INCLUDE "Engine/BgBufferAlloc.asm"
        INCLUDE "Engine/EraseSprites.asm"