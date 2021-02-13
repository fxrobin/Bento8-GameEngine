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
        cmpx  #Tbl_Sub_Object_Erase
        beq   ESP_SubDrawSpriteSearchInitB0 ; branch if no more sub objects
        ldy   ,--x
        
ESP_SubEraseCheckCollisionB0
        ldd   rsv_prev_xy_pixel_0,y         ; sub entry : rsv_prev_x_pixel_0 and rsv_prev_y_pixel_0 in one instruction
        cmpa  rsv_x2_pixel,u                ;     entry : x_pixel + rsv_curr_mapping_frame.x_size
        bhs   ESP_SubEraseSearchB0
        cmpb  rsv_y2_pixel,u                ;     entry : y_pixel + rsv_curr_mapping_frame.y_size
        bhs   ESP_SubEraseSearchB0
        ldd   rsv_prev_xy2_pixel_0,y        ; sub entry : rsv_prev_x_pixel_0 + rsv_prev_mapping_frame_0.x_size and rsv_prev_y_pixel_0 + rsv_prev_mapping_frame_0.y_size in one instruction
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
        cmpx  #Tbl_Sub_Object_Draw
        beq   ESP_NextObjectB0              ; branch if no more sub objects
        ldy   ,--x

ESP_SubDrawCheckCollisionB0
        ldd   xy_pixel,y                    ; sub entry : x_pixel and y_pixel in one instruction
        cmpa  rsv_x2_pixel,u                ;     entry : x_pixel + rsv_curr_mapping_frame.x_size
        bhs   ESP_SubDrawSearchB0
        cmpb  rsv_y2_pixel,u                ;     entry : y_pixel + rsv_curr_mapping_frame.y_size
        bhs   ESP_SubDrawSearchB0
        ldd   rsv_xy2_pixel,y               ; sub entry : x_pixel + rsv_curr_mapping_frame.x_size and y_pixel + rsv_curr_mapping_frame.y_size in one instruction
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
        andb  #256-cell_size                ; round cell_start to cell size
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
        cmpx  #Tbl_Sub_Object_Erase
        beq   ESP_SubDrawSpriteSearchInitB1 ; branch if no more sub objects
        ldy   ,--x
        
ESP_SubEraseCheckCollisionB1
        ldd   rsv_prev_xy_pixel_1,y         ; sub entry : rsv_prev_x_pixel_0 and rsv_prev_y_pixel_0 in one instruction
        cmpa  rsv_x2_pixel,u                ;     entry : x_pixel + rsv_curr_mapping_frame.x_size
        bhs   ESP_SubEraseSearchB1
        cmpb  rsv_y2_pixel,u                ;     entry : y_pixel + rsv_curr_mapping_frame.y_size
        bhs   ESP_SubEraseSearchB1
        ldd   rsv_prev_xy2_pixel_1,y        ; sub entry : rsv_prev_x_pixel_0 + rsv_prev_mapping_frame_0.x_size and rsv_prev_y_pixel_0 + rsv_prev_mapping_frame_0.y_size in one instruction
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
        cmpx  #Tbl_Sub_Object_Draw
        beq   ESP_NextObjectB1              ; branch if no more sub objects
        ldy   ,--x

ESP_SubDrawCheckCollisionB1
        ldd   xy_pixel,y                    ; sub entry : x_pixel and y_pixel in one instruction
        cmpa  rsv_x2_pixel,u                ;     entry : x_pixel + rsv_curr_mapping_frame.x_size
        bhs   ESP_SubDrawSearchB1
        cmpb  rsv_y2_pixel,u                ;     entry : y_pixel + rsv_curr_mapping_frame.y_size
        bhs   ESP_SubDrawSearchB1
        ldd   rsv_xy2_pixel,y               ; sub entry : x_pixel + rsv_curr_mapping_frame.x_size and y_pixel + rsv_curr_mapping_frame.y_size in one instruction
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
        jsr   [erase_routine,x]              ; erase sprite un working screen buffer
        leay  ,u                            ; cell_end background data stored in y
ESP_CallEraseRoutineB1_00        
        ldu   #$0000                        ; restore u (pointer to object)
        ldd   rsv_bgdata_1,u                ; cell_start
        andb  #256-cell_size                ; round cell_start to cell size
        tfr   d,x                           ; cell_start rounded stored in x
                        
ESP_FreeEraseBufferB1
        jsr   BgBufferFree                  ; free background data in memory
        
ESP_UnsetOnScreenFlagB1
        clr   rsv_onscreen_1,u              ; sprite is no longer on screen
        bra   ESP_NextObjectB1