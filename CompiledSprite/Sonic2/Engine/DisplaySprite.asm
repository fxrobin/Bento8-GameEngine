* ---------------------------------------------------------------------------
* DisplaySprite
* -------------
* Subroutine to manage sprite priority.
* Object's priority is read and object is (un)registred in display engine.
* priority: 0 - unregistred
* priority: 1 - register non moving overlay sprite
* priority; 2-8 - register moving sprite (2:front, ..., 8:back)  
*
* Unlike original S2 code, sprite priority is stored in an open doubly linked list
* it allows to keep an exact sprite order for each screen buffer 
*
* DisplaySprite
* input REG : [u] object pointer (OST)
*
* DisplaySprite_x
* input REG : [x] object pointer (OST)
* ---------------------------------------------------------------------------
									   
DisplaySprite_x *@globals
        pshs  d,x,u
        tfr   x,u
        bra   DSP_Start
        
DisplaySprite *@globals
        pshs  d,x,u
        
DSP_Start
        lda   Glb_Cur_Wrk_Screen_Id         ; read current screen buffer for write operations
        bne   DSP_SetBuffer1
        
DSP_SetBuffer0        
        leax  rsv_buffer_0,u                ; set x pointer to object variables that belongs to screen buffer 0
        ldy   DPS_buffer_0                  ; set y pointer to Display Priority Structure that belongs to screen buffer 0
        bra   DSP_BufferPositionned
        
DSP_SetBuffer1       
        leax  rsv_buffer_1,u                ; set x pointer to object variables that belongs to screen buffer 1
        ldy   DPS_buffer_1                  ; set y pointer to Display Priority Structure that belongs to screen buffer 1        
        
DSP_BufferPositionned       
        lda   priority,u                    ; read priority set for this object
        cmpa  buf_priority,x
        beq   DSP_rts                       ; priority and current priority are the same: nothing to do
        ldb   buf_priority,x   
        bne   DSP_ChangePriority
        
DSP_InitPriority
        sta   buf_priority,x                ; init priority for this screen buffer with priority from object
        
DSP_CheckLastEntry
        leay  buf_Tbl_Priority_Last_Entry,y
        tst   a,y                           ; test left byte only is ok, no object will be stored at $00__ address
        bne   DSP_addToExistingNode         ; not the first object at this priority level, branch
        
DSP_addFirstNode        
        stu   a,y                           ; save object as last entry in linked list
        leay  buf_Tbl_Priority_First_Entry-buf_Tbl_Priority_Last_Entry,y
        stu   a,y                           ; save object as first entry in linked list
        ldd   0
        std   buf_priority_prev_obj,x       ; clear object prev and next link, it's the only object at this priority level
        std   buf_priority_next_obj,x
        bra   DSP_rts
        
DSP_addToExistingNode
        ldx   [a,y]                         ; x register now store last object at the priority level of current object
        ldb   Glb_Cur_Wrk_Screen_Id
        bne   DSP_LinkBuffer1
        stu   rsv_priority_next_obj_0,x     ; link last object with current object if active screen buffer 0
        bra   DSP_LinkCurWithPrev        
DSP_LinkBuffer1        
        stu   rsv_priority_next_obj_1,x     ; link last object with current object if active screen buffer 1
        
DSP_LinkCurWithPrev        
        stx   buf_priority_prev_obj,u       ; link current object with previous object
        stu   a,y                           ; update last object in index
        ldd   0
        std   buf_priority_next_obj,x       ; clear object next link                
        bra   DSP_rts
        
DSP_ChangePriority
        leay  buf_Lst_Priority_Unset,y
        stu   [,y]                          ; add object address to unset list
        leay  2,y
        sty   ,y                            ; set index to next free cell of unset list
        leay  -buf_Lst_Priority_Unset-2,y
        cmpa  0
        bne   DSP_CheckLastEntry            ; priority is != 0, branch to add object to display priority list

DSP_rts
        puls  d,x,u,pc
        
                                       *; ---------------------------------------------------------------------------
                                       *; Subroutine to display a sprite/object, when a0 is the object RAM
                                       *; ---------------------------------------------------------------------------
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; sub_164F4:
                                       *DisplaySprite:
                                       *    lea (Sprite_Table_Input).w,a1
                                       *    move.w  priority(a0),d0
                                       *    lsr.w   #1,d0
                                       *    andi.w  #$380,d0
                                       *    adda.w  d0,a1
                                       
                                       *    cmpi.w  #$7E,(a1)
                                       *    bhs.s   return_16510
                                       *    addq.w  #2,(a1)
                                       
                                       *    adda.w  (a1),a1
                                       *    move.w  a0,(a1)
                                       *
                                       *return_16510:
                                       
                                       *    rts
                                       *; End of function DisplaySprite        