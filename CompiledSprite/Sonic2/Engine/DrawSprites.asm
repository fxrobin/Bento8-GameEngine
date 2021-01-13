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

DSP_Start
        lda   Glb_Cur_Wrk_Screen_Id         ; read current screen buffer for write operations
        bne   DSP_SetBuffer1
        
DSP_P8B0                                    
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+14 ; read DPS from priority 8 to priority 1
        beq   DSP_P7B0
        jsr   DSP_ProcessEachPriorityLevelB0   
DSP_P7B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+12
        beq   DSP_P6B0
        jsr   DSP_ProcessEachPriorityLevelB0  
DSP_P6B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+10
        beq   DSP_P5B0
        jsr   DSP_ProcessEachPriorityLevelB0  
DSP_P5B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+8
        beq   DSP_P4B0
        jsr   DSP_ProcessEachPriorityLevelB0  
DSP_P4B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+6
        beq   DSP_P3B0
        jsr   DSP_ProcessEachPriorityLevelB0              
DSP_P3B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+4
        beq   DSP_P2B0
        jsr   DSP_ProcessEachPriorityLevelB0     
DSP_P2B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+2
        beq   DSP_P1B0
        jsr   DSP_ProcessEachPriorityLevelB0 
DSP_P1B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry
        beq   DSP_rtsB0
        jsr   DSP_ProcessEachPriorityLevelB0
DSP_rtsB0        
        rts
        
DSP_P8B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+14 ; read DPS from priority 8 to priority 1
        beq   DSP_P7B1
        jsr   DSP_ProcessEachPriorityLevelB1   
DSP_P7B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+12
        beq   DSP_P6B1
        jsr   DSP_ProcessEachPriorityLevelB1   
DSP_P6B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+10
        beq   DSP_P5B1
        jsr   DSP_ProcessEachPriorityLevelB1   
DSP_P5B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+8
        beq   DSP_P4B1
        jsr   DSP_ProcessEachPriorityLevelB1   
DSP_P4B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+6
        beq   DSP_P3B1
        jsr   DSP_ProcessEachPriorityLevelB1             
DSP_P3B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+4
        beq   DSP_P2B1
        jsr   DSP_ProcessEachPriorityLevelB1    
DSP_P2B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+2
        beq   DSP_P1B1
        jsr   DSP_ProcessEachPriorityLevelB1
DSP_P1B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry
        beq   DSP_rtsB1
        jsr   DSP_ProcessEachPriorityLevelB1
DSP_rtsB1        
        rts

DSP_ProcessEachPriorityLevelB0
        lda   rsv_render_flags,x
        anda  #rsv_render_displaysprite_mask
        beq   DSP_NextObjectB0
        lda   rsv_onscreen_0,x
        bne   DSP_NextObjectB0
        lda   render_flags,x
        anda  #render_fixedoverlay_mask
        bne   DSP_DrawWithoutBackupB0
        ldu   rsv_curr_mapping_frame,x
        lda   erase_nb_cell,u        
        jsr   BgBufferAlloc                 ; allocate free space to store sprite background data
        cmpy  #$0000                        ; y contains cell_end of allocated space 
        beq   DSP_NextObjectB0              ; branch if no more free space
        ldd   x_pixel,x                     ; load x position (0-156) and y position (0-199) in one operation
        std   rsv_prev_x_pixel_0,x          ; save previous x_pixel and y_pixel in one operation
        jsr   DSP_XYToAddress
        ldu   rsv_cur_mapping_frame_0,x     ; load image to draw (for this buffer)
        stu   rsv_prev_mapping_frame_0,x    ; save previous mapping_frame 
        lda   page_bckdraw_routine,u
        sta   $E7E5                         ; select page in RAM (A000-DFFF)
        leau  ,y                            ; cell_end for background data
        stx   DSP_dyn3B0+1                  ; save x reg
        jsr   [bckdraw_routine,x]           ; backup background and draw sprite on working screen buffer
DSP_dyn3B0        
        ldx   #$0000                        ; (dynamic) restore x reg
        stu   rsv_bgdata_0,x                ; store pointer to saved background data
        ldd   rsv_x2_pixel,x                ; load x' and y' in one operation
        std   rsv_prev_x2_pixel_0,x         ; save as previous x' and y'
        lda   #$01
        sta   rsv_onscreen_0,x              ; set the onscreen flag
DSP_NextObjectB0        
        ldx   rsv_priority_next_obj_0,x
        bne   DSP_ProcessEachPriorityLevelB0   
        rts
        
DSP_DrawWithoutBackupB0
        ldd   x_pixel,x                     ; load x position (0-156) and y position (0-199) in one operation
        jsr   DSP_XYToAddress 
        ldu   rsv_cur_mapping_frame_0,x     ; load image to draw (for this buffer)
        lda   page_draw_routine,u
        sta   $E7E5                         ; select page in RAM (A000-DFFF)
        stx   DSP_dyn4B0+1                  ; save x reg
        jsr   [draw_routine,x]              ; backup background and draw sprite on working screen buffer
DSP_dyn4B0
        ldx   #$0000                        ; (dynamic) restore x reg
        ldx   rsv_priority_next_obj_0,x
        bne   DSP_ProcessEachPriorityLevelB0   
        rts          

DSP_XYToAddress
        lsra                                ; x=x/2, sprites moves by 2 pixels on x axis  
        bcs   DSP_XYToAddressRAMBFirst      ; Branch if write must begin in RAMB first
DSP_XYToAddressRAMAFirst
        sta   DSP_dyn1+2
        lda   #$28                          ; 40 bytes per line in RAMA or RAMB
        ldb   y_pixel,x                     ; load y position (0-199)
        mul
DSP_dyn1        
        addd  $0000                         ; (dynamic) RAMA start at $0000
        std   Glb_Sprite_Screen_Pos_PartA
        ora   #$20                          ; add $2000 to d register
        std   Glb_Sprite_Screen_Pos_PartB        
        rts
DSP_XYToAddressRAMBFirst
        sta   DSP_dyn2+2
        lda   #$28                          ; 40 bytes per line in RAMA or RAMB
        ldb   y_pixel,x                     ; load y position (0-199)
        mul
DSP_dyn2        
        addd  $2000                         ; (dynamic) RAMB start at $0000
        std   Glb_Sprite_Screen_Pos_PartA
        subd  $1FFF
        std   Glb_Sprite_Screen_Pos_PartB
        rts
        
DSP_ProcessEachPriorityLevelB1
        lda   rsv_render_flags,x
        anda  #rsv_render_displaysprite_mask
        beq   DSP_NextObjectB1
        lda   rsv_onscreen_1,x
        bne   DSP_NextObjectB1
        lda   render_flags,x
        anda  #render_fixedoverlay_mask
        bne   DSP_DrawWithoutBackupB1
        ldu   rsv_curr_mapping_frame,x
        lda   erase_nb_cell,u        
        jsr   BgBufferAlloc                 ; allocate free space to store sprite background data
        cmpy  #$0000                        ; y contains cell_end of allocated space 
        beq   DSP_NextObjectB1              ; branch if no more free space
        ldd   x_pixel,x                     ; load x position (0-156) and y position (0-199) in one operation
        std   rsv_prev_x_pixel_1,x          ; save previous x_pixel and y_pixel in one operation
        jsr   DSP_XYToAddress
        ldu   rsv_cur_mapping_frame_1,x     ; load image to draw (for this buffer)
        stu   rsv_prev_mapping_frame_1,x    ; save previous mapping_frame 
        lda   page_bckdraw_routine,u
        sta   $E7E5                         ; select page in RAM (A000-DFFF)
        leau  ,y                            ; cell_end for background data
        stx   DSP_dyn3B1+1                  ; save x reg
        jsr   [bckdraw_routine,x]           ; backup background and draw sprite on working screen buffer
DSP_dyn3B1        
        ldx   #$0000                        ; (dynamic) restore x reg
        stu   rsv_bgdata_1,x                ; store pointer to saved background data
        ldd   rsv_x2_pixel,x                ; load x' and y' in one operation
        std   rsv_prev_x2_pixel_1,x         ; save as previous x' and y'
        lda   #$01
        sta   rsv_onscreen_1,x              ; set the onscreen flag
DSP_NextObjectB1        
        ldx   rsv_priority_next_obj_1,x
        bne   DSP_ProcessEachPriorityLevelB1   
        rts
        
DSP_DrawWithoutBackupB1
        ldd   x_pixel,x                     ; load x position (0-156) and y position (0-199) in one operation
        jsr   DSP_XYToAddress 
        ldu   rsv_cur_mapping_frame_1,x     ; load image to draw (for this buffer)
        lda   page_draw_routine,u
        sta   $E7E5                         ; select page in RAM (A000-DFFF)
        stx   DSP_dyn4B1+1                  ; save x reg
        jsr   [draw_routine,x]              ; backup background and draw sprite on working screen buffer
DSP_dyn4B1
        ldx   #$0000                        ; (dynamic) restore x reg
        ldx   rsv_priority_next_obj_1,x
        bne   DSP_ProcessEachPriorityLevelB1   
        rts              