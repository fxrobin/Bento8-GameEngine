; TODO Gérer les sprites onscreen_flag a effacer mais qui doivent être delete
;
; rétablissemet du fond pour chaque sprite
; Traiter Sprite_Table_Input du plus prioritaire au moins prioritaire (0 à 7 dans l'ordre de la liste)
; Rétablir le fond en effaçant les sprites qui ont (et/ou)
;    - flag fond sauvegardé à oui pour ce sprite => onscreen_flag
;    et
;    - status to be deleted à oui
;    ou - changé de position x ou y (écran pas subpixel)
;    ou - changé d'animation depuis le dernier affichage
;    ou - changé de flag mirror (x ou y)
; Effacement du sprite par appel à la méthode
; si render_onscreen_mask à vrai et objet dans zone camera (strictement) alors:
;    - ajout de la référence du sprite a redessiner dans une liste Sprite_Table_Refresh (et purge flag fond sauvegardé pour ce sprite =>  onscreen_flag)
;    - gérer le cas ou un sprite moins prioritaire (qui bouge) est en colision avec sprite plus prioritaire (qui est fixe et n'a donc pas rétabli son fond)
;      parcourir la liste des sprites immobiles de priorité plus hautes et tester colission (pas besoin de rétablir le fond du sprite plus prioritaire qui ne bouge pas, par contre on devra le redessiner)
;      - si colision:
;         - ajout AU BON ENDROIT dans Sprite_Table_Refresh des références de sprites impactés (et retrait des sprites impactés de la liste des sprites non rafraichis)
; sinon ajout de la référence sprite dans liste des sprites non rafraichists
; OPTIONEL: si cout cumulé des méthodes de dessin > max_paramétré on ne rend pas les autres sprites moins prioritaires => sortie
; boucle
;sortie: Sprite_Table_Refresh (copie de Sprite_Table_Input init a vide et remplie au fur et à mesure ?), Sprite_Table_No_Refresh

; Dessin des sprites
; Parcours des objets dans Sprite_Table_Refresh par ordre de priorité de la plus basse à la plus haute
;    calcul position mémoire à partir des coordonnées x y 
;    calcul page, adresse de la méthode de dessin en fonction du x_mirror et y_miror et de l'animation en cours
;    appel à la méthode de dessin avec: position mémoire dessin, position mémoire sauvegarde fond, page et adresse méthode dessin
;    + positionner flag fond sauvegardé pour ce sprite => onscreen_flag
; boucle





; 8192 octets de la RAMA + 192 octets invisibles dans la page 2 ou 3 = 8384 octets dispo pour les données d'effacement

                                       *; ---------------------------------------------------------------------------
                                       *; Subroutine to convert mappings (etc) to proper Megadrive sprites
                                       *; ---------------------------------------------------------------------------
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; sub_16604:
                                       *BuildSprites:
                                       *    tst.w   (Two_player_mode).w
                                       *    bne.w   BuildSprites_2P
                                       *    lea (Sprite_Table).w,a2
                                       *    moveq   #0,d5
                                       *    moveq   #0,d4
                                       *    tst.b   (Level_started_flag).w
                                       *    beq.s   +
                                       *    jsrto   (BuildHUD).l, JmpTo_BuildHUD
                                       *    bsr.w   BuildRings
                                       *+
                                       *    lea (Sprite_Table_Input).w,a4
                                       *    moveq   #7,d7   ; 8 priority levels
                                       *; loc_16628:
                                       *BuildSprites_LevelLoop:
                                       *    tst.w   (a4)    ; does this level have any objects?
                                       *    beq.w   BuildSprites_NextLevel  ; if not, check the next one
                                       *    moveq   #2,d6
                                       *; loc_16630:
                                       *BuildSprites_ObjLoop:
                                       *    movea.w (a4,d6.w),a0 ; a0=object
                                       *
                                       *    if gameRevision=0
                                       *    ; the additional check prevents a crash triggered by placing an object in debug mode while dead
                                       *    ; unfortunately, the code it branches *to* causes a crash of its own
                                       *    tst.b   id(a0)          ; is this object slot occupied?
                                       *    beq.w   BuildSprites_Unknown    ; if not, branch
                                       *    tst.l   mappings(a0)        ; does this object have any mappings?
                                       *    beq.w   BuildSprites_Unknown    ; if not, branch
                                       *    else
                                       *    ; REV01 uses a better branch, but removed the useful check
                                       *    tst.b   id(a0)          ; is this object slot occupied?
                                       *    beq.w   BuildSprites_NextObj    ; if not, check next one
                                       *    endif
                                       *
                                       *    andi.b  #$7F,render_flags(a0)   ; clear on-screen flag
                                       *    move.b  render_flags(a0),d0
                                       *    move.b  d0,d4
                                       *    btst    #6,d0   ; is the multi-draw flag set?
                                       *    bne.w   BuildSprites_MultiDraw  ; if it is, branch
                                       *    andi.w  #$C,d0  ; is this to be positioned by screen coordinates?
                                       *    beq.s   BuildSprites_ScreenSpaceObj ; if it is, branch
                                       *    lea (Camera_X_pos_copy).w,a1
                                       *    moveq   #0,d0
                                       *    move.b  width_pixels(a0),d0
                                       *    move.w  x_pos(a0),d3
                                       *    sub.w   (a1),d3
                                       *    move.w  d3,d1
                                       *    add.w   d0,d1   ; is the object right edge to the left of the screen?
                                       *    bmi.w   BuildSprites_NextObj    ; if it is, branch
                                       *    move.w  d3,d1
                                       *    sub.w   d0,d1
                                       *    cmpi.w  #320,d1 ; is the object left edge to the right of the screen?
                                       *    bge.w   BuildSprites_NextObj    ; if it is, branch
                                       *    addi.w  #128,d3
                                       *    btst    #4,d4       ; is the accurate Y check flag set?
                                       *    beq.s   BuildSprites_ApproxYCheck   ; if not, branch
                                       *    moveq   #0,d0
                                       *    move.b  y_radius(a0),d0
                                       *    move.w  y_pos(a0),d2
                                       *    sub.w   4(a1),d2
                                       *    move.w  d2,d1
                                       *    add.w   d0,d1
                                       *    bmi.s   BuildSprites_NextObj    ; if the object is above the screen
                                       *    move.w  d2,d1
                                       *    sub.w   d0,d1
                                       *    cmpi.w  #224,d1
                                       *    bge.s   BuildSprites_NextObj    ; if the object is below the screen
                                       *    addi.w  #128,d2
                                       *    bra.s   BuildSprites_DrawSprite
                                       *; ===========================================================================
                                       *; loc_166A6:
                                       *BuildSprites_ScreenSpaceObj:
                                       *    move.w  y_pixel(a0),d2
                                       *    move.w  x_pixel(a0),d3
                                       *    bra.s   BuildSprites_DrawSprite
                                       *; ===========================================================================
                                       *; loc_166B0:
                                       *BuildSprites_ApproxYCheck:
                                       *    move.w  y_pos(a0),d2
                                       *    sub.w   4(a1),d2
                                       *    addi.w  #128,d2
                                       *    andi.w  #$7FF,d2
                                       *    cmpi.w  #-32+128,d2 ; assume Y radius to be 32 pixels
                                       *    blo.s   BuildSprites_NextObj
                                       *    cmpi.w  #32+128+224,d2
                                       *    bhs.s   BuildSprites_NextObj
                                       *; loc_166CC:
                                       *BuildSprites_DrawSprite:
                                       *    movea.l mappings(a0),a1
                                       *    moveq   #0,d1
                                       *    btst    #5,d4   ; is the static mappings flag set?
                                       *    bne.s   +   ; if it is, branch
                                       *    move.b  mapping_frame(a0),d1
                                       *    add.w   d1,d1
                                       *    adda.w  (a1,d1.w),a1
                                       *    move.w  (a1)+,d1
                                       *    subq.w  #1,d1   ; get number of pieces
                                       *    bmi.s   ++  ; if there are 0 pieces, branch
                                       *+
                                       *    bsr.w   DrawSprite  ; draw the sprite
                                       *+
                                       *    ori.b   #$80,render_flags(a0)   ; set on-screen flag
                                       *; loc_166F2:
                                       *BuildSprites_NextObj:
                                       *    addq.w  #2,d6   ; load next object
                                       *    subq.w  #2,(a4) ; decrement object count
                                       *    bne.w   BuildSprites_ObjLoop    ; if there are objects left, repeat
                                       *; loc_166FA:
                                       *BuildSprites_NextLevel:
                                       *    lea $80(a4),a4  ; load next priority level
                                       *    dbf d7,BuildSprites_LevelLoop   ; loop
                                       *    move.b  d5,(Sprite_count).w
                                       *    cmpi.b  #80,d5  ; was the sprite limit reached?
                                       *    beq.s   +   ; if it was, branch
                                       *    move.l  #0,(a2) ; set link field to 0
                                       *    rts
                                       *+
                                       *    move.b  #0,-5(a2)   ; set link field to 0
                                       *    rts
                                       *; ===========================================================================
                                       *    if gameRevision=0
                                       *BuildSprites_Unknown:
                                       *    ; In the Simon Wai beta, this was a simple BranchTo, but later builds have this mystery line.
                                       *    ; This may have possibly been a debugging function, for helping the devs detect when an object
                                       *    ; tried to display with a blank ID or mappings pointer.
                                       *    ; The latter was actually an issue that plagued Sonic 1, but is (almost) completely absent in this game.
                                       *    move.w  (1).w,d0    ; causes a crash on hardware because of the word operation at an odd address
                                       *    bra.s   BuildSprites_NextObj
                                       *    endif
                                       *; loc_1671C:
                                       *BuildSprites_MultiDraw:
                                       *    move.l  a4,-(sp)
                                       *    lea (Camera_X_pos).w,a4
                                       *    movea.w art_tile(a0),a3
                                       *    movea.l mappings(a0),a5
                                       *    moveq   #0,d0
                                       *
                                       *    ; check if object is within X bounds
                                       *    move.b  mainspr_width(a0),d0    ; load pixel width
                                       *    move.w  x_pos(a0),d3
                                       *    sub.w   (a4),d3
                                       *    move.w  d3,d1
                                       *    add.w   d0,d1
                                       *    bmi.w   BuildSprites_MultiDraw_NextObj
                                       *    move.w  d3,d1
                                       *    sub.w   d0,d1
                                       *    cmpi.w  #320,d1
                                       *    bge.w   BuildSprites_MultiDraw_NextObj
                                       *    addi.w  #128,d3
                                       *
                                       *    ; check if object is within Y bounds
                                       *    btst    #4,d4
                                       *    beq.s   +
                                       *    moveq   #0,d0
                                       *    move.b  mainspr_height(a0),d0   ; load pixel height
                                       *    move.w  y_pos(a0),d2
                                       *    sub.w   4(a4),d2
                                       *    move.w  d2,d1
                                       *    add.w   d0,d1
                                       *    bmi.w   BuildSprites_MultiDraw_NextObj
                                       *    move.w  d2,d1
                                       *    sub.w   d0,d1
                                       *    cmpi.w  #224,d1
                                       *    bge.w   BuildSprites_MultiDraw_NextObj
                                       *    addi.w  #128,d2
                                       *    bra.s   ++
                                       *+
                                       *    move.w  y_pos(a0),d2
                                       *    sub.w   4(a4),d2
                                       *    addi.w  #128,d2
                                       *    andi.w  #$7FF,d2
                                       *    cmpi.w  #-32+128,d2
                                       *    blo.s   BuildSprites_MultiDraw_NextObj
                                       *    cmpi.w  #32+128+224,d2
                                       *    bhs.s   BuildSprites_MultiDraw_NextObj
                                       *+
                                       *    moveq   #0,d1
                                       *    move.b  mainspr_mapframe(a0),d1 ; get current frame
                                       *    beq.s   +
                                       *    add.w   d1,d1
                                       *    movea.l a5,a1
                                       *    adda.w  (a1,d1.w),a1
                                       *    move.w  (a1)+,d1
                                       *    subq.w  #1,d1
                                       *    bmi.s   +
                                       *    move.w  d4,-(sp)
                                       *    bsr.w   ChkDrawSprite   ; draw the sprite
                                       *    move.w  (sp)+,d4
                                       *+
                                       *    ori.b   #$80,render_flags(a0)   ; set onscreen flag
                                       *    lea sub2_x_pos(a0),a6
                                       *    moveq   #0,d0
                                       *    move.b  mainspr_childsprites(a0),d0 ; get child sprite count
                                       *    subq.w  #1,d0       ; if there are 0, go to next object
                                       *    bcs.s   BuildSprites_MultiDraw_NextObj
                                       *
                                       *-   swap    d0
                                       *    move.w  (a6)+,d3    ; get X pos
                                       *    sub.w   (a4),d3
                                       *    addi.w  #128,d3
                                       *    move.w  (a6)+,d2    ; get Y pos
                                       *    sub.w   4(a4),d2
                                       *    addi.w  #128,d2
                                       *    andi.w  #$7FF,d2
                                       *    addq.w  #1,a6
                                       *    moveq   #0,d1
                                       *    move.b  (a6)+,d1    ; get mapping frame
                                       *    add.w   d1,d1
                                       *    movea.l a5,a1
                                       *    adda.w  (a1,d1.w),a1
                                       *    move.w  (a1)+,d1
                                       *    subq.w  #1,d1
                                       *    bmi.s   +
                                       *    move.w  d4,-(sp)
                                       *    bsr.w   ChkDrawSprite
                                       *    move.w  (sp)+,d4
                                       *+
                                       *    swap    d0
                                       *    dbf d0,-    ; repeat for number of child sprites
                                       *; loc_16804:
                                       *BuildSprites_MultiDraw_NextObj:
                                       *    movea.l (sp)+,a4
                                       *    bra.w   BuildSprites_NextObj
                                       *; End of function BuildSprites
                                       *
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; sub_1680A:
                                       *ChkDrawSprite:
                                       *    cmpi.b  #80,d5      ; has the sprite limit been reached?
                                       *    blo.s   DrawSprite_Cont ; if it hasn't, branch
                                       *    rts ; otherwise, return
                                       *; End of function ChkDrawSprite
                                       *
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; sub_16812:
                                       *DrawSprite:
                                       *    movea.w art_tile(a0),a3
                                       *    cmpi.b  #80,d5
                                       *    bhs.s   DrawSprite_Done
                                       *; loc_1681C:
                                       *DrawSprite_Cont:
                                       *    btst    #0,d4   ; is the sprite to be X-flipped?
                                       *    bne.s   DrawSprite_FlipX    ; if it is, branch
                                       *    btst    #1,d4   ; is the sprite to be Y-flipped?
                                       *    bne.w   DrawSprite_FlipY    ; if it is, branch
                                       *; loc__1682A:
                                       *DrawSprite_Loop:
                                       *    move.b  (a1)+,d0
                                       *    ext.w   d0
                                       *    add.w   d2,d0
                                       *    move.w  d0,(a2)+    ; set Y pos
                                       *    move.b  (a1)+,(a2)+ ; set sprite size
                                       *    addq.b  #1,d5
                                       *    move.b  d5,(a2)+    ; set link field
                                       *    move.w  (a1)+,d0
                                       *    add.w   a3,d0
                                       *    move.w  d0,(a2)+    ; set art tile and flags
                                       *    addq.w  #2,a1
                                       *    move.w  (a1)+,d0
                                       *    add.w   d3,d0
                                       *    andi.w  #$1FF,d0
                                       *    bne.s   +
                                       *    addq.w  #1,d0   ; avoid activating sprite masking
                                       *+
                                       *    move.w  d0,(a2)+    ; set X pos
                                       *    dbf d1,DrawSprite_Loop  ; repeat for next sprite
                                       *; return_16852:
                                       *DrawSprite_Done:
                                       *    rts
                                       *; ===========================================================================
                                       *; loc_16854:
                                       *DrawSprite_FlipX:
                                       *    btst    #1,d4   ; is it to be Y-flipped as well?
                                       *    bne.w   DrawSprite_FlipXY   ; if it is, branch
                                       *
                                       *-   move.b  (a1)+,d0
                                       *    ext.w   d0
                                       *    add.w   d2,d0
                                       *    move.w  d0,(a2)+
                                       *    move.b  (a1)+,d4    ; store size for later use
                                       *    move.b  d4,(a2)+
                                       *    addq.b  #1,d5
                                       *    move.b  d5,(a2)+
                                       *    move.w  (a1)+,d0
                                       *    add.w   a3,d0
                                       *    eori.w  #$800,d0    ; toggle X flip flag
                                       *    move.w  d0,(a2)+
                                       *    addq.w  #2,a1
                                       *    move.w  (a1)+,d0
                                       *    neg.w   d0  ; negate X offset
                                       *    move.b  CellOffsets_XFlip(pc,d4.w),d4
                                       *    sub.w   d4,d0   ; subtract sprite size
                                       *    add.w   d3,d0
                                       *    andi.w  #$1FF,d0
                                       *    bne.s   +
                                       *    addq.w  #1,d0
                                       *+
                                       *    move.w  d0,(a2)+
                                       *    dbf d1,-
                                       *
                                       *    rts
                                       *; ===========================================================================
                                       *; offsets for horizontally mirrored sprite pieces
                                       *CellOffsets_XFlip:
                                       *    dc.b   8,  8,  8,  8    ; 4
                                       *    dc.b $10,$10,$10,$10    ; 8
                                       *    dc.b $18,$18,$18,$18    ; 12
                                       *    dc.b $20,$20,$20,$20    ; 16
                                       *; offsets for vertically mirrored sprite pieces
                                       *CellOffsets_YFlip:
                                       *    dc.b   8,$10,$18,$20    ; 4
                                       *    dc.b   8,$10,$18,$20    ; 8
                                       *    dc.b   8,$10,$18,$20    ; 12
                                       *    dc.b   8,$10,$18,$20    ; 16
                                       *; ===========================================================================
                                       *; loc_168B4:
                                       *DrawSprite_FlipY:
                                       *    move.b  (a1)+,d0
                                       *    move.b  (a1),d4
                                       *    ext.w   d0
                                       *    neg.w   d0
                                       *    move.b  CellOffsets_YFlip(pc,d4.w),d4
                                       *    sub.w   d4,d0
                                       *    add.w   d2,d0
                                       *    move.w  d0,(a2)+    ; set Y pos
                                       *    move.b  (a1)+,(a2)+ ; set size
                                       *    addq.b  #1,d5
                                       *    move.b  d5,(a2)+    ; set link field
                                       *    move.w  (a1)+,d0
                                       *    add.w   a3,d0
                                       *    eori.w  #$1000,d0   ; toggle Y flip flag
                                       *    move.w  d0,(a2)+    ; set art tile and flags
                                       *    addq.w  #2,a1
                                       *    move.w  (a1)+,d0
                                       *    add.w   d3,d0
                                       *    andi.w  #$1FF,d0
                                       *    bne.s   +
                                       *    addq.w  #1,d0
                                       *+
                                       *    move.w  d0,(a2)+    ; set X pos
                                       *    dbf d1,DrawSprite_FlipY
                                       *    rts
                                       *; ===========================================================================
                                       *; offsets for vertically mirrored sprite pieces
                                       *CellOffsets_YFlip2:
                                       *    dc.b   8,$10,$18,$20    ; 4
                                       *    dc.b   8,$10,$18,$20    ; 8
                                       *    dc.b   8,$10,$18,$20    ; 12
                                       *    dc.b   8,$10,$18,$20    ; 16
                                       *; ===========================================================================
                                       *; loc_168FC:
                                       *DrawSprite_FlipXY:
                                       *    move.b  (a1)+,d0
                                       *    move.b  (a1),d4
                                       *    ext.w   d0
                                       *    neg.w   d0
                                       *    move.b  CellOffsets_YFlip2(pc,d4.w),d4
                                       *    sub.w   d4,d0
                                       *    add.w   d2,d0
                                       *    move.w  d0,(a2)+
                                       *    move.b  (a1)+,d4
                                       *    move.b  d4,(a2)+
                                       *    addq.b  #1,d5
                                       *    move.b  d5,(a2)+
                                       *    move.w  (a1)+,d0
                                       *    add.w   a3,d0
                                       *    eori.w  #$1800,d0   ; toggle X and Y flip flags
                                       *    move.w  d0,(a2)+
                                       *    addq.w  #2,a1
                                       *    move.w  (a1)+,d0
                                       *    neg.w   d0
                                       *    move.b  CellOffsets_XFlip2(pc,d4.w),d4
                                       *    sub.w   d4,d0
                                       *    add.w   d3,d0
                                       *    andi.w  #$1FF,d0
                                       *    bne.s   +
                                       *    addq.w  #1,d0
                                       *+
                                       *    move.w  d0,(a2)+
                                       *    dbf d1,DrawSprite_FlipXY
                                       *    rts
                                       *; End of function DrawSprite
                                       *
                                       *; ===========================================================================
                                       *; offsets for horizontally mirrored sprite pieces
                                       *CellOffsets_XFlip2:
                                       *    dc.b   8,  8,  8,  8    ; 4
                                       *    dc.b $10,$10,$10,$10    ; 8
                                       *    dc.b $18,$18,$18,$18    ; 12
                                       *    dc.b $20,$20,$20,$20    ; 16
                                       *; ===========================================================================
