(main)TEST
   org $6200
   setdp $90

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
image_y_size                  equ 16
image_meta_size               equ 18 ; number of bytes for each image reference

* ===========================================================================
* Object Constants
* ===========================================================================

nb_reserved_objects           equ 2
nb_dynamic_objects            equ 59
nb_level_objects              equ 3
nb_objects                    equ (nb_reserved_objects+nb_dynamic_objects)+nb_level_objects

* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------

object_size                   equ 67 ; the size of an object
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
anim_frame                    equ 6           ; index of current frame in animation
anim_frame_duration           equ 7           ; number of frames for each image in animation, range: 00-7F (0-127), 0 means display only during one frame
mapping_frame                 equ 8  ; and 9  ;reference to current image (Img_) (0000 if no image)
x_pos                         equ 10 ; and 11 ; x playfield coordinate
x_sub                         equ 12          ; x subpixel (1/256 of a pixel), must follow x_pos in data structure
y_pos                         equ 13 ; and 14 ; y playfield coordinate
y_sub                         equ 15          ; y subpixel (1/256 of a pixel), must follow y_pos in data structure
x_pixel                       equ 16          ; x screen coordinate
y_pixel                       equ 17          ; y screen coordinate
routine                       equ 18          ; index of current object routine
routine_secondary             equ 19          ; index of current secondary routine
ext_variables                 equ 20 ; to 40  ; reserved space for additionnal variables

* ---------------------------------------------------------------------------
* reserved variables (engine)

rsv_render_flags              equ 41

* --- rsv_render_flags bitfield variables ---
rsv_render_onscreen_0_mask    equ $01 ; (bit 0) has been rendered on screen buffer 0
rsv_render_onscreen_1_mask    equ $02 ; (bit 1) has been rendered on screen buffer 1
rsv_render_erasesprite_mask   equ $04 ; (bit 2) if a sprite need to be cleared on screen
rsv_render_displaysprite_mask equ $08 ; (bit 3) if a sprite need to be rendered on screen
rsv_render_outofrange_mask    equ $10 ; (bit 4) if a sprite is out of range for full rendering in screen

rsv_prev_anim                 equ 42 ; and 43 ; reference to previous animation (Ani_) w
rsv_curr_mapping_frame        equ 44 ; and 45 ; reference to current image regarding mirror flags (0000 if no image) w

* ---------------------------------------------------------------------------
* reserved variables (engine) - buffer specific

rsv_buffer_0                  equ 46 ; Start index of buffer 0 variables
rsv_priority_0                equ 46 ; internal value that hold priority in video buffer 0
rsv_priority_prev_obj_0       equ 47 ; and 48 ; previous object (OST address) in display priority list for video buffer 0 (0000 if none) w
rsv_priority_next_obj_0       equ 49 ; and 50 ; next object (OST address) in display priority list for video buffer 0 (0000 if none) w
rsv_prev_mapping_frame_0      equ 51 ; and 52 ; reference to previous image in video buffer 0 (Img_) (0000 if no image) w
rsv_bgdata_0                  equ 53 ; and 54 ; address of background data in screen 0 w
rsv_prev_x_pixel_0            equ 55 ; previous x screen coordinate b
rsv_prev_y_pixel_0            equ 56 ; previous y screen coordinate b
rsv_onscreen_0                equ 57 ; has been rendered on screen buffer 0

rsv_buffer_1                  equ 58 ; Start index of buffer 1 variables
rsv_priority_1                equ 58 ; internal value that hold priority in video buffer 1
rsv_priority_prev_obj_1       equ 59 ; and 59 ; previous object (OST address) in display priority list for video buffer 1 (0000 if none) w
rsv_priority_next_obj_1       equ 61 ; and 61 ; next object (OST address) in display priority list for video buffer 1 (0000 if none) w
rsv_prev_mapping_frame_1      equ 63 ; and 63 ; reference to previous image in video buffer 1 (Img_) (0000 if no image) w
rsv_bgdata_1                  equ 65 ; and 65 ; address of background data in screen 1 w
rsv_prev_x_pixel_1            equ 67 ; previous x screen coordinate b
rsv_prev_y_pixel_1            equ 68 ; previous y screen coordinate b
rsv_onscreen_1                equ 69 ; has been rendered on screen buffer 0

buf_priority                  equ 0  ; offset for each rsv_buffer variables
buf_priority_prev_obj         equ 1  ;
buf_priority_next_obj         equ 3  ;
buf_prev_mapping_frame        equ 5  ;
buf_bgdata                    equ 7  ;
buf_prev_x_pixel              equ 9  ;
buf_prev_y_pixel              equ 10 ;
buf_onscreen                  equ 11 ;

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

* ---------------------------------------------------------------------------
* Background Backup Cells - BBC
* ---------------------------------------------------------------------------

nb_free_cells                 equ   64
cell_size                     equ   ($6000-$3F40)/nb_free_cells

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
Lst_Priority_Unset_0          fdb   Lst_Priority_Unset_0+2     ; pointer to end of list (initialized to its own address) (buffer 0)
                              rmb   (nb_objects*2),0           ; objects to delete from priority list
DPS_buffer_1                              
Tbl_Priority_First_Entry_1    rmb   2+(nb_priority_levels*2),0 ; first address of object in linked list for each priority index (buffer 1) index 0 unused
Tbl_Priority_Last_Entry_1     rmb   2+(nb_priority_levels*2),0 ; last address of object in linked list for each priority index (buffer 1) index 0 unused
Lst_Priority_Unset_1          fdb   Lst_Priority_Unset_1+2     ; pointer to end of list (initialized to its own address) (buffer 1)
                              rmb   (nb_objects*2),0           ; objects to delete from priority list
                              
buf_Tbl_Priority_First_Entry  equ   0                                                        
buf_Tbl_Priority_Last_Entry   equ   Tbl_Priority_Last_Entry_0-DPS_buffer_0          
buf_Lst_Priority_Unset        equ   Lst_Priority_Unset_0-DPS_buffer_0
* ---------------------------------------------------------------------------
* Object Status Table - OST
* ---------------------------------------------------------------------------
        
Object_RAM * @globals
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
									   
CheckSpritesRefresh

CSR_Start
        lda   Glb_Cur_Wrk_Screen_Id         ; read current screen buffer for write operations
        bne   CSR_SetBuffer1
        
CSR_SetBuffer0        
        lda   rsv_buffer_0                  ; set offset a to object variables that belongs to screen buffer 0
        sta   CSR_ProcessEachPriorityLevel+2    
CSR_P8B0                                    
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+14 ; read DPS from priority 8 to priority 1
        beq   CSR_P7B0
        lda   #$08
        sta   CSR_CheckPriority+1        
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P7B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+12
        beq   CSR_P6B0
        lda   #$07
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P6B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+10
        beq   CSR_P5B0
        lda   #$06
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P5B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+8
        beq   CSR_P4B0
        lda   #$05
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P4B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+6
        beq   CSR_P3B0
        lda   #$04
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel               
CSR_P3B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+4
        beq   CSR_P2B0
        lda   #$03
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel      
CSR_P2B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+2
        beq   CSR_P1B0
        lda   #$02
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel  
CSR_P1B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry
        beq   CSR_rtsB0
        lda   #$01
        sta   CSR_CheckPriority+1               
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
        sta   CSR_CheckPriority+1        
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P7B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+12
        beq   CSR_P6B1
        lda   #$07
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P6B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+10
        beq   CSR_P5B1
        lda   #$06
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P5B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+8
        beq   CSR_P4B1
        lda   #$05
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P4B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+6
        beq   CSR_P3B1
        lda   #$04
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel               
CSR_P3B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+4
        beq   CSR_P2B1
        lda   #$03
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel      
CSR_P2B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+2
        beq   CSR_P1B1
        lda   #$02
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel  
CSR_P1B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry
        beq   CSR_rtsB1
        lda   #$01
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel
CSR_rtsB1        
        rts

CSR_ProcessEachPriorityLevel
        leax  16,u                          ; dynamic offset, x point to object variables relative to current writable buffer (beware that rsv_buffer_0 and rsv_buffer_1 should be equ >=16)
        lda   buf_priority,x
        
CSR_CheckPriority
        cmpa  #0                            ; dynamic current priority
        bne   CSR_NextObject                ; do not process this entry in case of priority change
        lda   render_flags,u
        anda  render_hide_mask!render_todelete_mask
        bne   CSR_DoNotDisplaySprite      
        
CSR_UpdSpriteImageBasedOnMirror
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
        sta   x_pixel,u        
        addd  image_x_size,y
        bvs   CSR_SetOutOfRange             ; bottom rigth coordinate overflow of image
        cmpd  #screen_width
        bgt   CSR_SetOutOfRange             ; branch if (x_pixel + image.x_size > screen width)

        ldd   y_pos,u
        subd  Glb_Camera_Y_Pos
        addd  image_y_offset,y
        bvs   CSR_SetOutOfRange             ; top left coordinate overflow of image        
        bmi   CSR_SetOutOfRange             ; branch if (y_pixel < 0)
        sta   y_pixel,u        
        addd  image_y_size,y
        bvs   CSR_SetOutOfRange             ; bottom rigth coordinate overflow of image        
        cmpd  #screen_height
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
        
CSR_NextObject
        ldu   buf_priority_next_obj,x
        bne   CSR_ProcessEachPriorityLevel   
        rts        
        
CSR_CheckVerticalPosition
        ldb   #0                            ; in screen coordinate mode, image offset is managed by object
        lda   y_pixel,u
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
        lda   buf_onscreen,x
        beq   CSR_SetEraseFalse             ; branch if object is not on screen
        ldd   x_pixel,u                     ; load x_pixel and y_pixel
        cmpd  buf_prev_x_pixel,x
        bne   CSR_SetEraseTrue              ; branch if object moved since last frame
        ldd   rsv_curr_mapping_frame,u
        cmpd  buf_prev_mapping_frame,x
        bne   CSR_SetEraseTrue              ; branch if object image changed since last frame
        ldd   priority,u
        cmpd  buf_priority,x
        bne   CSR_SetEraseTrue              ; branch if object priority changed since last frame
        bra   CSR_SetEraseFalse             ; branch if object is on screen but unchanged since last frame
        
CSR_SetEraseTrue        
        lda   rsv_render_flags,u
        ora   #rsv_render_erasesprite_mask        
        bra   CSR_CheckDraw
        
CSR_SetEraseFalse
        lda   rsv_render_flags,u
        anda  #:rsv_render_erasesprite_mask
        
CSR_CheckDraw
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
        bra   CSR_NextObject

CSR_SetDrawFalse 
        lda   rsv_render_flags,u
        anda  #:rsv_render_displaysprite_mask
        bra   CSR_NextObject        
