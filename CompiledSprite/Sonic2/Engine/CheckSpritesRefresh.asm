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
        bne   CSR_CheckErase
        
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
        bne   CSR_ProcessEachPriorityLevel   
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
        
        bra   CSR_NextObject

CSR_SetDrawFalse 
        lda   rsv_render_flags,u
        anda  #:rsv_render_displaysprite_mask
        bra   CSR_NextObject        
