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

DRS_Start
        lda   Glb_Cur_Wrk_Screen_Id         ; read current screen buffer for write operations
        bne   DRS_P8B1
        
DRS_P8B0                                    
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+16 ; read DPS from priority 8 to priority 1
        beq   DRS_P7B0
        jsr   DRS_ProcessEachPriorityLevelB0   
DRS_P7B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+14
        beq   DRS_P6B0
        jsr   DRS_ProcessEachPriorityLevelB0  
DRS_P6B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+12
        beq   DRS_P5B0
        jsr   DRS_ProcessEachPriorityLevelB0  
DRS_P5B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+10
        beq   DRS_P4B0
        jsr   DRS_ProcessEachPriorityLevelB0  
DRS_P4B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+8
        beq   DRS_P3B0
        jsr   DRS_ProcessEachPriorityLevelB0              
DRS_P3B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+6
        beq   DRS_P2B0
        jsr   DRS_ProcessEachPriorityLevelB0     
DRS_P2B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+4
        beq   DRS_P1B0
        jsr   DRS_ProcessEachPriorityLevelB0 
DRS_P1B0
        ldx   DPS_buffer_0+buf_Tbl_Priority_First_Entry+2
        beq   DRS_rtsB0
        jsr   DRS_ProcessEachPriorityLevelB0
DRS_rtsB0        
        rts
        
DRS_P8B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+16 ; read DPS from priority 8 to priority 1
        beq   DRS_P7B1
        jsr   DRS_ProcessEachPriorityLevelB1   
DRS_P7B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+14
        beq   DRS_P6B1
        jsr   DRS_ProcessEachPriorityLevelB1   
DRS_P6B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+12
        beq   DRS_P5B1
        jsr   DRS_ProcessEachPriorityLevelB1   
DRS_P5B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+10
        beq   DRS_P4B1
        jsr   DRS_ProcessEachPriorityLevelB1   
DRS_P4B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+8
        beq   DRS_P3B1
        jsr   DRS_ProcessEachPriorityLevelB1             
DRS_P3B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+6
        beq   DRS_P2B1
        jsr   DRS_ProcessEachPriorityLevelB1    
DRS_P2B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+4
        beq   DRS_P1B1
        jsr   DRS_ProcessEachPriorityLevelB1
DRS_P1B1
        ldx   DPS_buffer_1+buf_Tbl_Priority_First_Entry+2
        beq   DRS_rtsB1
        jsr   DRS_ProcessEachPriorityLevelB1
DRS_rtsB1        
        rts

DRS_ProcessEachPriorityLevelB0
        lda   rsv_render_flags,x
        anda  #rsv_render_displaysprite_mask
        beq   DRS_NextObjectB0
        lda   rsv_onscreen_0,x
        bne   DRS_NextObjectB0
        lda   render_flags,x
        anda  #render_fixedoverlay_mask
        bne   DRS_DrawWithoutBackupB0
        ldu   rsv_curr_mapping_frame,x
        lda   erase_nb_cell,u        
        jsr   BgBufferAlloc                 ; allocate free space to store sprite background data
        cmpy  #$0000                        ; y contains cell_end of allocated space 
        beq   DRS_NextObjectB0              ; branch if no more free space
        ldd   x_pixel,x                     ; load x position (48-207) and y position (28-227) in one operation
        std   rsv_prev_x_pixel_0,x          ; save previous x_pixel and y_pixel in one operation
        jsr   DRS_XYToAddress
        ldu   rsv_curr_mapping_frame,x      ; load image to draw
        stu   rsv_prev_mapping_frame_0,x    ; save previous mapping_frame 
        lda   page_bckdraw_routine,u
        sta   $E7E5                         ; select page in RAM (A000-DFFF)
        leau  ,y                            ; cell_end for background data
        stx   DRS_dyn3B0+1                  ; save x reg
        jsr   [bckdraw_routine,x]           ; backup background and draw sprite on working screen buffer
DRS_dyn3B0        
        ldx   #$0000                        ; (dynamic) restore x reg
        stu   rsv_bgdata_0,x                ; store pointer to saved background data
        ldd   rsv_x2_pixel,x                ; load x' and y' in one operation
        std   rsv_prev_x2_pixel_0,x         ; save as previous x' and y'
        lda   #$01
        sta   rsv_onscreen_0,x              ; set the onscreen flag
DRS_NextObjectB0        
        ldx   rsv_priority_next_obj_0,x
        bne   DRS_ProcessEachPriorityLevelB0   
        rts
        
DRS_DrawWithoutBackupB0
        ldd   x_pixel,x                     ; load x position (48-207) and y position (28-227) in one operation
        jsr   DRS_XYToAddress 
        ldu   rsv_curr_mapping_frame,x      ; load image to draw
        lda   page_draw_routine,u
        sta   $E7E5                         ; select page in RAM (A000-DFFF)
        stx   DRS_dyn4B0+1                  ; save x reg
        jsr   [draw_routine,x]              ; backup background and draw sprite on working screen buffer
DRS_dyn4B0
        ldx   #$0000                        ; (dynamic) restore x reg
        ldx   rsv_priority_next_obj_0,x
        bne   DRS_ProcessEachPriorityLevelB0   
        rts          

********************************************************************************
* x_pixel and y_pixel coordinate system
* x coordinates:
*    - off-screen left 00-2F (0-47)
*    - on screen 30-CF (48-207)
*    - off-screen right D0-FF (208-255)
*
* y coordinates:
*    - off-screen top 00-1B (0-27)
*    - on screen 1C-E3 (28-227)
*    - off-screen bottom E4-FF (228-255)
********************************************************************************

DRS_XYToAddress
*        suba  #$30
*        subb  #$1C
        lsra                                ; x=x/2, sprites moves by 2 pixels on x axis  
        bcs   DRS_XYToAddressRAMBFirst      ; Branch if write must begin in RAMB first
DRS_XYToAddressRAMAFirst
        sta   DRS_dyn1+2
        lda   #$28                          ; 40 bytes per line in RAMA or RAMB
        ldb   y_pixel,x                     ; load y position (28-227)
        mul
DRS_dyn1        
        addd  $0000                         ; (dynamic) RAMA start at $0000
        std   Glb_Sprite_Screen_Pos_PartA
        ora   #$20                          ; add $2000 to d register
        std   Glb_Sprite_Screen_Pos_PartB        
        rts
DRS_XYToAddressRAMBFirst
        sta   DRS_dyn2+2
        lda   #$28                          ; 40 bytes per line in RAMA or RAMB
        ldb   y_pixel,x                     ; load y position (28-227)
        mul
DRS_dyn2        
        addd  $2000                         ; (dynamic) RAMB start at $0000
        std   Glb_Sprite_Screen_Pos_PartA
        subd  $1FFF
        std   Glb_Sprite_Screen_Pos_PartB
        rts
        
DRS_ProcessEachPriorityLevelB1
        lda   rsv_render_flags,x
        anda  #rsv_render_displaysprite_mask
        beq   DRS_NextObjectB1
        lda   rsv_onscreen_1,x
        bne   DRS_NextObjectB1
        lda   render_flags,x
        anda  #render_fixedoverlay_mask
        bne   DRS_DrawWithoutBackupB1
        ldu   rsv_curr_mapping_frame,x
        lda   erase_nb_cell,u        
        jsr   BgBufferAlloc                 ; allocate free space to store sprite background data
        cmpy  #$0000                        ; y contains cell_end of allocated space 
        beq   DRS_NextObjectB1              ; branch if no more free space
        ldd   x_pixel,x                     ; load x position (48-207) and y position (28-227) in one operation
        std   rsv_prev_x_pixel_1,x          ; save previous x_pixel and y_pixel in one operation
        jsr   DRS_XYToAddress
        ldu   rsv_curr_mapping_frame,x      ; load image to draw
        stu   rsv_prev_mapping_frame_1,x    ; save previous mapping_frame 
        lda   page_bckdraw_routine,u
        sta   $E7E5                         ; select page in RAM (A000-DFFF)
        leau  ,y                            ; cell_end for background data
        stx   DRS_dyn3B1+1                  ; save x reg
        ldy   #Glb_Sprite_Screen_Pos_PartA  ; position is a parameter, it allows different Main engines
        ldd   Glb_Sprite_Screen_Pos_PartB   ; to be used with compiled sprites in a single program
        jsr   [bckdraw_routine,x]           ; backup background and draw sprite on working screen buffer
DRS_dyn3B1        
        ldx   #$0000                        ; (dynamic) restore x reg
        stu   rsv_bgdata_1,x                ; store pointer to saved background data
        ldd   rsv_x2_pixel,x                ; load x' and y' in one operation
        std   rsv_prev_x2_pixel_1,x         ; save as previous x' and y'
        lda   #$01
        sta   rsv_onscreen_1,x              ; set the onscreen flag
DRS_NextObjectB1        
        ldx   rsv_priority_next_obj_1,x
        bne   DRS_ProcessEachPriorityLevelB1   
        rts
        
DRS_DrawWithoutBackupB1
        ldd   x_pixel,x                     ; load x position (48-207) and y position (28-227) in one operation
        jsr   DRS_XYToAddress 
        ldu   rsv_curr_mapping_frame,x      ; load image to draw
        lda   page_draw_routine,u
        sta   $E7E5                         ; select page in RAM (A000-DFFF)
        stx   DRS_dyn4B1+1                  ; save x reg
        jsr   [draw_routine,x]              ; backup background and draw sprite on working screen buffer
DRS_dyn4B1
        ldx   #$0000                        ; (dynamic) restore x reg
        ldx   rsv_priority_next_obj_1,x
        bne   DRS_ProcessEachPriorityLevelB1   
        rts              