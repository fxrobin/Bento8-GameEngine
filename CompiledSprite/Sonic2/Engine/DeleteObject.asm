* ---------------------------------------------------------------------------
* DeleteObject
* ------------
* Subroutine to delete an object.
* If the object is rendered as a sprite it will be deleted by EraseSprites
* routine
*
* DeleteObject
* input REG : [u] object pointer (OST)
*
* DeleteObject_x
* input REG : [x] object pointer (OST)
* ---------------------------------------------------------------------------

                                       *; ---------------------------------------------------------------------------
                                       *; Subroutine to delete an object
                                       *; ---------------------------------------------------------------------------
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; freeObject:
DeleteObject_x *@globals               *DeleteObject:
        pshs  d,x,u                    *    movea.l a0,a1
        tfr   x,u                      *; sub_164E8:
        bra   DOB_Start
DeleteObject *@globals                 *DeleteObject2:
        pshs  d,x,u
DOB_Start
        lda   rsv_onscreen_0,u
        beq   DOB_TestOnscreen1Delete  ; branch if not onscreen on buffer 0
        
DOB_Unset0        
        ldx   Lst_Priority_Unset_0     ; add object to unset list on buffer 0
        stu   ,x
        leax  2,x
        stx   Lst_Priority_Unset_0
        
DOB_TestOnscreen1
        lda   rsv_onscreen_1,u
        beq   DOB_ToDeleteFlag         ; branch if not onscreen on buffer 1
        
DOB_Unset1
        ldx   Lst_Priority_Unset_1     ; add object to unset list on buffer 1                       
        stu   ,x
        leax  2,x
        stx   Lst_Priority_Unset_1
        bra  DOB_ToDeleteFlag 
        
DOB_TestOnscreen1Delete
        lda   rsv_onscreen_1,u
        bne   DOB_Unset1               ; branch if onscreen on buffer 1        

        jsr   ClearObj                 ; this object is not onscreen anymore, clear this object now
        bra   DOB_rts
                                       *    moveq   #0,d1
                                       *
                                       *    moveq   #bytesToLcnt(next_object),d0 ; we want to clear up to the next object
                                       *    ; delete the object by setting all of its bytes to 0
                                       *-   move.l  d1,(a1)+
                                       *    dbf d0,-
                                       *    if object_size&3
                                       *    move.w  d1,(a1)+
                                       *    endif
                                       *
DOB_ToDeleteFlag                                       
        lda   render_flags,u
        ora   render_todelete_mask
        sta   render_flags,u           ; set todelete flag, object will be deleted after sprite erase on all screen buffers
                                               
DOB_rts
        puls  d,x,u,pc                 *    rts
                                       *; End of function DeleteObject2