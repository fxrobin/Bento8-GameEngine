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
        ldy   DPS_buffer_0                  ; set pointer y to Display Priority Structure that belongs to screen buffer 0
        bra   CSR_BufferPositionned
        
CSR_SetBuffer1       
        lda   rsv_buffer_1                  ; set offset a to object variables that belongs to screen buffer 1
        ldy   DPS_buffer_1                  ; set pointer y to Display Priority Structure that belongs to screen buffer 1       

CSR_BufferPositionned
        sta   CSR_ProcessEachPriorityLevel+1     ; dynamic change of offset   
CSR_P8                                           ; read DPS from priority 8 to priority 1
        ldu   buf_Tbl_Priority_First_Entry+14,y
        beq   CSR_P7
        lda   #$08
        sta   CSR_CheckPriority+1        
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P7
        ldu   buf_Tbl_Priority_First_Entry+12,y
        beq   CSR_P6
        lda   #$07
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P6
        ldu   buf_Tbl_Priority_First_Entry+10,y
        beq   CSR_P5
        lda   #$06
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P5
        ldu   buf_Tbl_Priority_First_Entry+8,y
        beq   CSR_P4
        lda   #$05
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel   
CSR_P4
        ldu   buf_Tbl_Priority_First_Entry+6,y
        beq   CSR_P3
        lda   #$04
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel               
CSR_P3
        ldu   buf_Tbl_Priority_First_Entry+4,y
        beq   CSR_P2
        lda   #$03
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel      
CSR_P2
        ldu   buf_Tbl_Priority_First_Entry+2,y
        beq   CSR_P1
        lda   #$02
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel  
CSR_P1
        ldu   buf_Tbl_Priority_First_Entry,y
        beq   CSR_rts
        lda   #$01
        sta   CSR_CheckPriority+1               
        jsr   CSR_ProcessEachPriorityLevel
CSR_rts        
        rts

CSR_ProcessEachPriorityLevel
        leax  0,u                           ; dynamic offset, x point to object variables relative to current writable buffer
        lda   buf_priority,x
        
CSR_CheckPriority
        cmpa  0                             ; dynamic current priority
        bne   CSR_NextObject                ; do not process this entry in case of priority change
        lda   render_flags,u
        anda  render_hide_mask!render_todelete_mask
        bne   CSR_DoNotDisplaySprite      
        
CSR_UpdSpriteImageBasedOnMirror             ; set image to display based on x and y mirror flags
        lda   render_flags
        anda  #render_xmirror_mask!render_ymirror_mask
        ldb   #image_meta_size
        mul
        addd  mapping_frame,u
        std   rsv_curr_mapping_frame,u
        
CSR_CheckPlayFieldCoord
        ...
        bra   CSR_ComputeScreenPosition
        ...
        
CSR_ComputeScreenPosition
        ...
        
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
