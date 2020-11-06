; ---------------------------------------------------------------------------
; D�termine si un objet doit �tre conserv� en m�moire ou supprim�
; dans le cas d'une suppression, certaines donn�es de l'objet sont
; sauvegard�es pour permettre de restaurer son �tat lors de l'�ventuelle
; r�apparition de l'objet
;
; TODO A mettre en place avec la gestion du d�placement camera
;
; input REG : [u] pointeur sur l'objet 
; ---------------------------------------------------------------------------

                                       *; ---------------------------------------------------------------------------
                                       *; Routines to mark an enemy/monitor/ring/platform as destroyed
                                       *; ---------------------------------------------------------------------------
                                       *
                                       *; ===========================================================================
                                       *; input: a0 = the object
                                       *; loc_163D2:
MarkObjGone                            *MarkObjGone:
                                       *    tst.w   (Two_player_mode).w ; is it two player mode?
                                       *    beq.s   +           ; if not, branch
        bra   DisplaySprite            *    bra.w   DisplaySprite
                                       *+
                                       *    move.w  x_pos(a0),d0
                                       *    andi.w  #$FF80,d0
                                       *    sub.w   (Camera_X_pos_coarse).w,d0
                                       *    cmpi.w  #$80+320+$40+$80,d0 ; This gives an object $80 pixels of room offscreen before being unloaded (the $40 is there to round up 320 to a multiple of $80)
                                       *    bhi.w   +
                                       *    bra.w   DisplaySprite
                                       *
                                       *+   lea (Object_Respawn_Table).w,a2
                                       *    moveq   #0,d0
                                       *    move.b  respawn_index(a0),d0
                                       *    beq.s   +
                                       *    bclr    #7,2(a2,d0.w)
                                       *+
                                       *    bra.w   MarkObjToBeDeleted