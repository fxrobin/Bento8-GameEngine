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
        *addd  image_x_offset,y
        lbvs   CSR_SetOutOfRange             ; top left coordinate overflow of image
        lbmi   CSR_SetOutOfRange             ; branch if (x_pixel < 0)
        stb   x_pixel,u
        *addb  image_x_size_l,y
        lbvs   CSR_SetOutOfRange             ; bottom rigth coordinate overflow of image
        stb   rsv_x2_pixel,u
        cmpb  #screen_width
        lbgt   CSR_SetOutOfRange             ; branch if (x_pixel + image.x_size > screen width)

        ldd   y_pos,u
        subd  Glb_Camera_Y_Pos
        *addd  image_y1_offset,y
        bvs   CSR_SetOutOfRange             ; top left coordinate overflow of image        
        bmi   CSR_SetOutOfRange             ; branch if (y_pixel < 0)
        stb   y_pixel,u        
        *addb  image_y_size_l,y
        bvs   CSR_SetOutOfRange             ; bottom rigth coordinate overflow of image
        stb   rsv_y2_pixel,u
        cmpb  #screen_bottom
        bhi   CSR_SetOutOfRange             ; branch if (y_pixel + image.y_size > screen height)
        lda   rsv_render_flags,u
        anda  #:rsv_render_outofrange_mask  ; unset out of range flag
        sta   rsv_render_flags,u
        bra   CSR_CheckErase
        
CSR_DoNotDisplaySprite
        lda   priority,u                     
        cmpa  cur_priority 
        bne   CSR_NextObject                ; next object if this one is a new priority record (no need to erase) 
        
        lda   rsv_render_flags,u
        anda  #:rsv_render_erasesprite_mask&:rsv_render_displaysprite_mask ; set erase and display flag to false
        sta   rsv_render_flags,u
                
        ldb   buf_onscreen,x
        beq   CSR_NextObject                ; branch if not on screen
        
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
        ldb   y_pixel,u
        ldy   rsv_curr_mapping_frame,u
        
        addb  image_y1_offset_l,y
        stb   rsv_y1_pixel,u

        cmpb  #screen_top
        bcs   CSR_SetOutOfRange
        
        addb  image_y_size_l,y
        stb   rsv_y2_pixel,u

        cmpb  #screen_bottom
        bhi   CSR_SetOutOfRange
        
        ldb   x_pixel,u
        addb  image_x1_offset_l,y
        stb   rsv_x1_pixel,u
        addb  image_x_size_l,y
        stb   rsv_x2_pixel,u
        
        lda   rsv_render_flags,u
        anda  #:rsv_render_outofrange_mask  ; unset out of range flag
        sta   rsv_render_flags,u
        bra   CSR_CheckErase
                
CSR_SetOutOfRange
        lda   rsv_render_flags,u
        ora   #rsv_render_outofrange_mask   ; set out of range flag
        sta   rsv_render_flags,u

CSR_CheckErase
        sts   CSR_CheckDraw+2
        lda   buf_priority,x
        cmpa  cur_priority 
        lbne  CSR_CheckDraw
        
        ldy   cur_ptr_sub_obj_erase
        
        lda   buf_onscreen,x
        lbeq   CSR_SetEraseFalse             ; branch if object is not on screen
        ldd   xy_pixel,u
        cmpd  buf_prev_xy_pixel,x
        bne   CSR_SetEraseTrue              ; branch if object moved since last frame
        ldd   rsv_curr_mapping_frame,u
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

        lds   cur_ptr_sub_obj_erase        
        lda   Glb_Cur_Wrk_Screen_Id         ; read current screen buffer for write operations
        bne   CSR_SubEraseSearchB1
        
CSR_SubEraseSearchB0
        cmps  #Tbl_Sub_Object_Erase
        beq   CSR_SubDrawSpriteSearchInit   ; branch if no more sub objects
        ldy   ,--s
        
CSR_SubEraseCheckCollisionB0
        ldd   rsv_prev_xy1_pixel_0,y        ; sub entry : rsv_prev_x_pixel_0 and rsv_prev_y_pixel_0 in one instruction
        cmpa  rsv_x2_pixel,u                ;     entry : x_pixel + rsv_curr_mapping_frame.x_size
        bhs   CSR_SubEraseSearchB0
        cmpb  rsv_y2_pixel,u                ;     entry : y_pixel + rsv_curr_mapping_frame.y_size
        bhs   CSR_SubEraseSearchB0
        ldd   rsv_prev_xy2_pixel_0,y        ; sub entry : rsv_prev_x_pixel_0 + rsv_prev_mapping_frame_0.x_size and rsv_prev_y_pixel_0 + rsv_prev_mapping_frame_0.y_size in one instruction
        cmpa  rsv_x1_pixel,u                ;     entry : x_pixel
        bls   CSR_SubEraseSearchB0
        cmpb  rsv_y1_pixel,u                ;     entry : y_pixel
        bls   CSR_SubEraseSearchB0
        
        ldy   cur_ptr_sub_obj_erase
        bra   CSR_SetEraseTrue              ; found a collision

CSR_SubEraseSearchB1
        cmps  #Tbl_Sub_Object_Erase
        beq   CSR_SubDrawSpriteSearchInit   ; branch if no more sub objects
        ldy   ,--s
        
CSR_SubEraseCheckCollisionB1
        ldd   rsv_prev_xy1_pixel_1,y        ; sub entry : rsv_prev_x_pixel_1 and rsv_prev_y_pixel_1 in one instruction
        cmpa  rsv_x2_pixel,u                ;     entry : x_pixel + rsv_curr_mapping_frame.x_size
        bhi   CSR_SubEraseSearchB1
        cmpb  rsv_y2_pixel,u                ;     entry : y_pixel + rsv_curr_mapping_frame.y_size
        bhi   CSR_SubEraseSearchB1
        ldd   rsv_prev_xy2_pixel_1,y        ; sub entry : rsv_prev_x_pixel_1 + rsv_prev_mapping_frame_1.x_size and rsv_prev_y_pixel_1 + rsv_prev_mapping_frame_1.y_size in one instruction
        cmpa  rsv_x1_pixel,u                ;     entry : x_pixel
        blo   CSR_SubEraseSearchB1
        cmpb  rsv_y1_pixel,u                ;     entry : y_pixel
        blo   CSR_SubEraseSearchB1
        
        ldy   cur_ptr_sub_obj_erase
        bra   CSR_SetEraseTrue              ; found a collision

CSR_SubDrawSpriteSearchInit
        lds   cur_ptr_sub_obj_draw
        
CSR_SubDrawSearch
        cmps  #Tbl_Sub_Object_Draw
        beq   CSR_SetEraseFalse             ; branch if no more sub objects
        ldy   ,--s

CSR_SubDrawCheckCollision
        ldd   rsv_xy1_pixel,y               ; sub entry : x_pixel and y_pixel in one instruction
        cmpa  rsv_x2_pixel,u                ;     entry : x_pixel + rsv_curr_mapping_frame.x_size
        bhi   CSR_SubDrawSearch
        cmpb  rsv_y2_pixel,u                ;     entry : y_pixel + rsv_curr_mapping_frame.y_size
        bhi   CSR_SubDrawSearch
        ldd   rsv_xy2_pixel,y               ; sub entry : x_pixel + rsv_curr_mapping_frame.x_size and y_pixel + rsv_curr_mapping_frame.y_size in one instruction
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
        lds   #$FFFF                        ; dynamic restore s
        lda   priority,u
        cmpa  cur_priority 
        lbne  CSR_NextObject
        
        ldy   cur_ptr_sub_obj_draw
        
        lda   rsv_render_flags,u
        anda  #rsv_render_outofrange_mask
        bne   CSR_SetDrawFalse              ; branch if object image is out of range
        ldd   rsv_curr_mapping_frame,u
        beq   CSR_SetDrawFalse              ; branch if object have no image
        lda   render_flags,u
        anda  #render_hide_mask
        bne   CSR_SetDrawFalse              ; branch if object is hidden
        
CSR_SetDrawTrue 
        lda   rsv_render_flags,u
        ora   #rsv_render_displaysprite_mask ; set displaysprite flag   
        sta   rsv_render_flags,u         
        
        lda   rsv_render_flags,u
        anda  #rsv_render_erasesprite_mask
        lsra                                ; DEPENDECY on rsv_render_erasesprite_mask value (here should be 2)      
        cmpa  buf_onscreen,x
        bne   CSR_SetHide         
        
        stu   ,y++
        sty   cur_ptr_sub_obj_draw          ; maintain list of changing sprites to draw, should be to draw and ((on screen and to erase) or (not on screen and not to erase)) 

CSR_SetHide        
        lda   render_flags,u
        ora   #render_hide_mask             ; set hide flag
        sta   render_flags,u        
        
        ldu   buf_priority_next_obj,x
        lbne   CSR_ProcessEachPriorityLevel   
        rts

CSR_SetDrawFalse 
        lda   rsv_render_flags,u
        anda  #:rsv_render_displaysprite_mask
        sta   rsv_render_flags,u
        
        ldu   buf_priority_next_obj,x
        lbne   CSR_ProcessEachPriorityLevel   
        rts      
