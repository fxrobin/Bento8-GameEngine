; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a0 is the object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_164F4:
DisplaySprite:
    lea (Sprite_Table_Input).w,a1
    move.w  priority(a0),d0
    lsr.w   #1,d0
    andi.w  #$380,d0
    adda.w  d0,a1
    cmpi.w  #$7E,(a1)
    bhs.s   return_16510
    addq.w  #2,(a1)
    adda.w  (a1),a1
    move.w  a0,(a1)

return_16510:
    rts
; End of function DisplaySprite

; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a1 is the object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16512:
DisplaySprite2:
    lea (Sprite_Table_Input).w,a2
    move.w  priority(a1),d0
    lsr.w   #1,d0
    andi.w  #$380,d0
    adda.w  d0,a2
    cmpi.w  #$7E,(a2)
    bhs.s   return_1652E
    addq.w  #2,(a2)
    adda.w  (a2),a2
    move.w  a1,(a2)

return_1652E:
    rts
; End of function DisplaySprite2

; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a0 is the object RAM
; and d0 is already (priority/2)&$380
; ---------------------------------------------------------------------------

; loc_16530:
DisplaySprite3:
    lea (Sprite_Table_Input).w,a1
    adda.w  d0,a1
    cmpi.w  #$7E,(a1)
    bhs.s   return_16542
    addq.w  #2,(a1)
    adda.w  (a1),a1
    move.w  a0,(a1)

return_16542:
    rts