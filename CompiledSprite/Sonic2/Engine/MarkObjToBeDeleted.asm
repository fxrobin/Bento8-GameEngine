; ---------------------------------------------------------------------------
; Subroutine to mark an object to be deleted during BuildSprites
;
; Si render_onscreen et status_tobedeleted
;    - déclenche l'effacement du sprite lors du prochain BuildSprites
;      (mais pas l'affichage du sprite)
;
; input REG : [u] pointeur sur l'objet (SST)
; ---------------------------------------------------------------------------
(main)MAIN
	org $6300

MarkObjToBeDeleted
    ldd   #$0000
    std   14,u
    std   12,u
    std   10,u
    std   8,u
    std   6,u
    std   4,u
    std   2,u
    std   ,u
    rts