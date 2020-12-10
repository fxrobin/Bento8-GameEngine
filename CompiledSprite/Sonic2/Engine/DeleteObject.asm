; ---------------------------------------------------------------------------
; DeleteObject
; ------------
; Subroutine to delete an object.
; If the object is rendered as a sprite it will be deleted by EraseSprites
; routine
;
; DeleteObject
; input REG : [u] pointeur sur l'objet (SST)
;
; DeleteObject2
; input REG : [x] pointeur sur l'objet (SST)
; ---------------------------------------------------------------------------

                                       *; ---------------------------------------------------------------------------
                                       *; Subroutine to delete an object
                                       *; ---------------------------------------------------------------------------
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; freeObject:
DeleteObject2                          *DeleteObject:
        stu   DeleteObject_dyn_01+1    *    movea.l a0,a1
        tfr x,u                        *; sub_164E8:
DeleteObject                           *DeleteObject2:
        lda   priority,u
        bne   DeleteObject_AddPUnset
        jsr   ClearObj                 ; priority is 0, object is not referenced in display engine, clear this object now
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
        bra   DeleteObject_dyn_01
DeleteObject_AddPUnset                                       
        ldy   Lst_Priority_Unset       ; priority is set: object will be deleted in Display engine                       
        stu   ,y
        leay  2,y
        sty   Lst_Priority_Unset
        lda   render_flags,u           ; set todelete flag to 1
        ora   render_todelete_mask
        sta   render_flags,u
DeleteObject_dyn_01                                       
        ldu   #0000                                 
        rts                            *    rts
                                       *; End of function DeleteObject2