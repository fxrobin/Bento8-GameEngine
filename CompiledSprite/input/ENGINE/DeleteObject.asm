; ---------------------------------------------------------------------------
; Subroutine to delete an object
; ---------------------------------------------------------------------------

                                       *; ---------------------------------------------------------------------------
                                       *; Subroutine to delete an object
                                       *; ---------------------------------------------------------------------------
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; freeObject:
                                       *DeleteObject:
                                       *    movea.l a0,a1

                                       *; sub_164E8:
                                       *DeleteObject2:
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
                                       *    rts
                                       *; End of function DeleteObject2