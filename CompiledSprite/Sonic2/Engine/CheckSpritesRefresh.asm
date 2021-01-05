; ---------------------------------------------------------------------------
; CheckSpritesRefresh
; -------------------
; Subroutine to determine if sprites are gonna be erased and/or drawn
; Read Display Priority Structure (back to front)
; priority: 0 - unregistred
; priority: 1 - register non moving overlay sprite
; priority; 2-8 - register moving sprite (2:front, ..., 8:back)  
;
; input REG : none
; ---------------------------------------------------------------------------
									   
CheckSpritesRefresh

CSR_Start
        lda   Glb_Cur_Wrk_Screen_Id         ; read current screen buffer for write operations
        bne   CSR_SetBuffer1
        
CSR_SetBuffer0        
        lda   rsv_buffer_0                  ; set offset a to object variables that belongs to screen buffer 0
        sta   CSR_ProcessEachPriorityLevel+2        
CSR_P8                                           ; read DPS from priority 8 to priority 1
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+14
        beq   CSR_P7
        lda   #$08
        sta   CSR_CheckPriority+1        
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P7
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+12
        beq   CSR_P6
        lda   #$07
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P6
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+10
        beq   CSR_P5
        lda   #$06
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P5
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+8
        beq   CSR_P4
        lda   #$05
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P4
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+6
        beq   CSR_P3
        lda   #$04
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel               
CSR_P3
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+4
        beq   CSR_P2
        lda   #$03
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel      
CSR_P2
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry+2
        beq   CSR_P1
        lda   #$02
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel  
CSR_P1
        ldu   DPS_buffer_0+buf_Tbl_Priority_First_Entry
        beq   CSR_rts
        lda   #$01
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel
        rts
        
CSR_SetBuffer1       
        lda   rsv_buffer_1                  ; set offset a to object variables that belongs to screen buffer 1
        sta   CSR_ProcessEachPriorityLevel+2        
CSR_P8                                           ; read DPS from priority 8 to priority 1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+14
        beq   CSR_P7
        lda   #$08
        sta   CSR_CheckPriority+1        
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P7
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+12
        beq   CSR_P6
        lda   #$07
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P6
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+10
        beq   CSR_P5
        lda   #$06
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P5
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+8
        beq   CSR_P4
        lda   #$05
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P4
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+6
        beq   CSR_P3
        lda   #$04
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel               
CSR_P3
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+4
        beq   CSR_P2
        lda   #$03
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel      
CSR_P2
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry+2
        beq   CSR_P1
        lda   #$02
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel  
CSR_P1
        ldu   DPS_buffer_1+buf_Tbl_Priority_First_Entry
        beq   CSR_rts
        lda   #$01
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel
        rts

CSR_ProcessEachPriorityLevel
        leax  rsv_buffer_0,u                ; dynamic offset, x point to object variables relative to current writable buffer (beware that rsv_buffer_0 and rsv_buffer_1 should be equ >=16)
        lda   buf_priority,x
        
CSR_CheckPriority
        cmpa  #0                            ; dynamic current priority
        bne   CSR_NextObject                ; do not process this entry in case of priority change
        lda   render_flags,u
        anda  render_hide_mask!render_todelete_mask
        bne   CSR_DoNotDisplaySprite      
        
CSR_UpdSpriteImageBasedOnMirror             ; set image to display based on x and y mirror flags
        lda   render_flags,u
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
        
CSR_CheckVerticalPosition                   ; in screen coordinate mode, image offset is managed by object
        ldb   #0
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
        ...
        
CSR_CheckDraw
        ...        

        bra   CSR_NextObject
        
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
