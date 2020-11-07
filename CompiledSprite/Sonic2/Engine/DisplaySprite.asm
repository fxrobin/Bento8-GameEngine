; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a0 is the object RAM
;
; Difference avec la m�thode d'origine: on stocke la priorit� par pas de $80
; � la maniere de s3k au lieu d'une priorit� de 0 � 7.
; La priorit� est l'adresse m�moire de l'entr�e du tableau Sprite_Table_Input
; directement � l'index de la priorit� concern�e.
;
; input REG : [u] pointeur sur l'objet 
; ---------------------------------------------------------------------------

                                       *; ---------------------------------------------------------------------------
                                       *; Subroutine to display a sprite/object, when a0 is the object RAM
                                       *; ---------------------------------------------------------------------------
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; sub_164F4:
DisplaySprite                          *DisplaySprite:
                                       *    lea (Sprite_Table_Input).w,a1
        ldx   priority,u               *    move.w  priority(a0),d0
                                       *    lsr.w   #1,d0
                                       *    andi.w  #$380,d0
                                       *    adda.w  d0,a1
        lda   ,x
        cmpa  SpriteTableNbEl*2        *    cmpi.w  #$7E,(a1)
        bhs   DisplaySprite_01         *    bhs.s   return_16510
        adda  #2                       *    addq.w  #2,(a1)
        sta   ,x
        leax  a,x                      *    adda.w  (a1),a1
        stu   ,x                       *    move.w  a0,(a1)
                                       *
DisplaySprite_01                       *return_16510:
        rts                            *    rts
                                       *; End of function DisplaySprite