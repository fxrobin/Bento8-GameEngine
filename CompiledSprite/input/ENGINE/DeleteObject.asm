; ---------------------------------------------------------------------------
; Subroutine to delete an object
;
; �cart par rapport au code d'origine :
; Les donn�es a effac�es imp�rativement doivent �tre plac�es en d�but de SST
; ne pas effacer toutes les donn�es mais seulement celles n�cessaires 
; ---------------------------------------------------------------------------
(main)MAIN
	org $6300
                                       *; ---------------------------------------------------------------------------
                                       *; Subroutine to delete an object
                                       *; ---------------------------------------------------------------------------
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; freeObject:
DeleteObject                           *DeleteObject:
    ldd   #$0000                       *    movea.l a0,a1
    std   14,u
    std   12,u
    std   10,u
    std   8,u
    std   6,u
    std   4,u
    std   2,u
    std   ,u
    rts                                       
                                       *; sub_164E8:
DeleteObject2                          *DeleteObject2:
    ldd   #$0000                       *    moveq   #0,d1
                                       *
                                       *    moveq   #bytesToLcnt(next_object),d0 ; we want to clear up to the next object
                                       *    ; delete the object by setting all of its bytes to 0
                                       *-   move.l  d1,(a1)+
                                       *    dbf d0,-
                                       *    if object_size&3
                                       *    move.w  d1,(a1)+
                                       *    endif
                                       *
    std   14,x
    std   12,x
    std   10,x
    std   8,x
    std   6,x
    std   4,x
    std   2,x
    std   ,x
    rts                                *    rts
                                       *; End of function DeleteObject2