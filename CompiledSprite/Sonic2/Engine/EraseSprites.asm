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
        bne   ESP_SetBuffer1
        
ESP_SetBuffer0        
        lda   rsv_buffer_0                  ; set offset a to object variables that belongs to screen buffer 0
        sta   ESP_ProcessEachPriorityLevel+2
        adda  #buf_prev_mapping_frame
        sta   ESP_SubCheckEraseCollision_00+3    
ESP_P1B0                                    
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry ; read DPS from priority 8 to priority 1
        beq   ESP_P2B0
        lda   #$08
        sta   ESP_CheckPriority+1        
        jsr   ESP_ProcessEachPriorityLevel   
ESP_P2B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+2
        beq   ESP_P3B0
        lda   #$07
        sta   ESP_CheckPriority+1               
        jsr   ESP_ProcessEachPriorityLevel   
ESP_P3B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+4
        beq   ESP_P4B0
        lda   #$06
        sta   ESP_CheckPriority+1               
        jsr   ESP_ProcessEachPriorityLevel   
ESP_P4B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+6
        beq   ESP_P5B0
        lda   #$05
        sta   ESP_CheckPriority+1               
        jsr   ESP_ProcessEachPriorityLevel   
ESP_P5B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+8
        beq   ESP_P6B0
        lda   #$04
        sta   ESP_CheckPriority+1               
        jsr   ESP_ProcessEachPriorityLevel               
ESP_P6B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+10
        beq   ESP_P7B0
        lda   #$03
        sta   ESP_CheckPriority+1               
        jsr   ESP_ProcessEachPriorityLevel      
ESP_P7B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+12
        beq   ESP_P8B0
        lda   #$02
        sta   ESP_CheckPriority+1               
        jsr   ESP_ProcessEachPriorityLevel  
ESP_P8B0
        ldu   DPS_buffer_0+buf_Tbl_Priority_Last_Entry+14
        beq   ESP_rtsB0
        lda   #$01
        sta   ESP_CheckPriority+1               
        jsr   ESP_ProcessEachPriorityLevel
ESP_rtsB0        
        rts
        
ESP_SetBuffer1       
        lda   rsv_buffer_1                  ; set offset a to object variables that belongs to screen buffer 1
        sta   ESP_ProcessEachPriorityLevel+2 
        adda  #buf_prev_mapping_frame
        sta   ESP_SubCheckEraseCollision_00+3              
ESP_P1B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry ; read DPS from priority 8 to priority 1
        beq   ESP_P2B1
        lda   #$08
        sta   ESP_CheckPriority+1        
        jsr   ESP_ProcessEachPriorityLevel   
ESP_P2B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+2
        beq   ESP_P3B1
        lda   #$07
        sta   ESP_CheckPriority+1               
        jsr   ESP_ProcessEachPriorityLevel   
ESP_P3B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+4
        beq   ESP_P4B1
        lda   #$06
        sta   ESP_CheckPriority+1               
        jsr   ESP_ProcessEachPriorityLevel   
ESP_P4B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+6
        beq   ESP_P5B1
        lda   #$05
        sta   ESP_CheckPriority+1               
        jsr   ESP_ProcessEachPriorityLevel   
ESP_P5B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+8
        beq   ESP_P6B1
        lda   #$04
        sta   ESP_CheckPriority+1               
        jsr   ESP_ProcessEachPriorityLevel               
ESP_P6B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+10
        beq   ESP_P7B1
        lda   #$03
        sta   ESP_CheckPriority+1               
        jsr   ESP_ProcessEachPriorityLevel      
ESP_P7B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+12
        beq   ESP_P8B1
        lda   #$02
        sta   ESP_CheckPriority+1               
        jsr   ESP_ProcessEachPriorityLevel  
ESP_P8B1
        ldu   DPS_buffer_1+buf_Tbl_Priority_Last_Entry+14
        beq   ESP_rtsB1
        lda   #$01
        sta   ESP_CheckPriority+1               
        jsr   ESP_ProcessEachPriorityLevel
ESP_rtsB1        
        rts

ESP_ProcessEachPriorityLevel
        leay  16,u                          ; dynamic offset, x point to object variables relative to current writable buffer (beware that rsv_buffer_0 and rsv_buffer_1 should be equ >=16)
        lda   buf_priority,y
        
ESP_CheckPriority
        cmpa  #0                            ; dynamic current priority
        bne   ESP_NextObject                ; do not process this entry (case of priority change)
        
ESP_CheckErase
        lda   rsv_render_flags,u
        anda  #rsv_render_erasesprite_mask
        bne   ESP_CallEraseRoutine          ; branch if sprite is supposed to be refreshed
        
        * if not supposed to be refreshed
        * check if the current sprite is rendered on screen and should continue to be displayed
        
        lda   buf_onscreen,y
        beq   ESP_NextObject
        lda   rsv_render_flags,u   
        anda  #rsv_render_displaysprite_mask
        beq   ESP_NextObject
        
        * search a collision with a sprite under the current sprite
        * the sprite under should have the erase flag or is not on screen and new to display
        * in this case it forces the refresh of the current sprite that was not supposed to be refreshed
        * as a sub loop, this should be optimized as much as possible
        
ESP_SubSpriteSearch
        ...
        x => sub entry
        
        lda   rsv_render_flags,x
        anda  #rsv_render_erasesprite_mask
        beq   ESP_SubCheckAppearCollision   ; branch if sub sprite is not supposed to be refreshed
        
ESP_SubInitOnce
        ...
        
        =>>>>>>>>>>>>>>>> TROP COMPLEXE ON DEMULTIPLIE le code pour chaque buffer ...
        
ESP_SubCheckEraseCollision
        ldd   buf_prev_x_pixel,x marche pas ! add du buuf0 ou 1           ; load sub entry : rsv_prev_x_pixel_0/1 and rsv_prev_y_pixel_0/1 in one instruction
        cmpa  #0                            ; (dynamic) entry : x_pixel_0/1 + rsv_curr_mapping_frame_0/1.x_size - 1
        blo   ESP_SubCheckAppearCollision
        cmpb  #0                            ; (dynamic) entry : y_pixel_0/1 + rsv_curr_mapping_frame_0/1.y_size - 1
        blo   ESP_SubCheckAppearCollision
ESP_SubCheckEraseCollision_00        
        ldx   16,x                          ; (dynamic) sub entry : buf_prev_mapping_frame
        addd  image_x_size,x                ; add image_x_size and image_y_size in one instruction, overflow is not possible because out of range images are already excluded         
        cmpa  #0                            ; (dynamic) entry : x_pixel_0/1 + 1
        bhi   ESP_SubCheckAppearCollision
        cmpb  #0                            ; (dynamic) entry : y_pixel_0/1 + 1
        bhi   ESP_SubCheckAppearCollision
        bra   ESP_SubCheckOverlay

ESP_SubCheckAppearCollision
        lda   rsv_render_flags,x
        anda  #rsv_render_displaysprite_mask
        beq   ESP_SubNextObject   ; branch if sub sprite is not supposed to be displayed
        ldx   16,x                          ; (dynamic) sub entry : buf_prev_mapping_frame        
        lda   buf_onscreen,x
        beq   ESP_SubNextObject   ; branch if sub sprite is already on screen
        ...
        
ESP_SubNextObject
        ...        
        
ESP_SubCheckOverlay
        ...
        
ESP_NextObject
        ldu   buf_priority_prev_obj,y
        bne   ESP_ProcessEachPriorityLevel   
        rts        

ESP_CallEraseRoutine
        ...        
        
ESP_FreeEraseBuffer
        ...
        
ESP_UnsetOnScreenFlag
        ...
        bra   ESP_NextObject
        