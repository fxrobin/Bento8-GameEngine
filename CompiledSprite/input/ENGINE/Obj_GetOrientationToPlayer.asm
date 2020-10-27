; ---------------------------------------------------------------------------
; Get Orientation To Player
; Returns the horizontal and vertical distances of the closest player object.
;
; input REG : [u] pointeur sur l'objet
; output    : gotp_closest_player    (ptr objet de MainCharacter ou Sidekick)
;             gotp_player_is_left    (0: player left from object, 2: right)
;             gotp_player_v_location (0: player above object, 2: below)
;             gotp_player_h_distance (closest character's h distance to obj)
;             gotp_player_v_distance (closest character's v distance to obj)
; ---------------------------------------------------------------------------
									   
                                       *; ---------------------------------------------------------------------------
                                       *; Get Orientation To Player
                                       *; Returns the horizontal and vertical distances of the closest player object.
                                       *;
                                       *; input variables:
                                       *;  a0 = object
                                       *;
                                       *; returns:
                                       *;  a1 = address of closest player character
                                       *;  d0 = 0 if player is left from object, 2 if right
                                       *;  d1 = 0 if player is above object, 2 if below
                                       *;  d2 = closest character's horizontal distance to object
                                       *;  d3 = closest character's vertical distance to object
                                       *;
                                       *; writes:
                                       *;  d0, d1, d2, d3, d4, d5
                                       *;  a1
                                       *;  a2 = sidekick
                                       *; ---------------------------------------------------------------------------
                                       *;loc_366D6:
Obj_GetOrientationToPlayer             *Obj_GetOrientationToPlayer:
        pshs  d,x
        lda   #$00
        sta   gotp_player_is_left      *    moveq   #0,d0
        sta   gotp_player_is_above     *    moveq   #0,d1
        ldx   MainCharacter            *    lea (MainCharacter).w,a1 ; a1=character
        ldd   x_pos,u                  *    move.w  x_pos(a0),d2
        subd  x_pos,x                  *    sub.w   x_pos(a1),d2
                                       *    mvabs.w d2,d4   ; absolute horizontal distance to main character
        std   gotp_player_h_distance
        bpl   gotp_skip1
        coma
        comb
        addd  #$0001
gotp_skip1
        std   gotp_abs_h_distance_mainc
        ldx   Sidekick                 *    lea (Sidekick).w,a1 ; a1=character
        ldd   x_pos,u                  *    move.w  x_pos(a0),d3
        subd  x_pos,x                  *    sub.w   x_pos(a2),d3
        std   gotp_h_distance_sidek
                                       *    mvabs.w d3,d5   ; absolute horizontal distance to sidekick
        bpl   gotp_skip2
        coma
        comb
        addd  #$0001
gotp_skip2
        cmpd  gotp_abs_h_distance_mainc
                                       *    cmp.w   d5,d4   ; get shorter distance
        bhi   MainCharacterIsCloser    *    bls.s   +   ; branch, if main character is closer
                                       *    ; if sidekick is closer
        stx   gotp_closest_player      *    movea.l a2,a1
        ldd   gotp_h_distance_sidek
        std   gotp_player_h_distance   *    move.w  d3,d2
MainCharacterIsCloser                  *+
        lda   gotp_player_h_distance
        bita  #$80                     *    tst.w   d2  ; is player to enemy's left?
        beq   PlayerToEnemysLeft       *    bpl.s   +   ; if not, branch
        lda   #$02
        sta   gotp_player_is_left      *    addq.w  #2,d0
PlayerToEnemysLeft                     *+
        ldd   y_pos,u                  *    move.w  y_pos(a0),d3
        subd  y_pos,x                  *    sub.w   y_pos(a1),d3    ; vertical distance to closest character
        bhs   PlayerToEnemysAbove      *    bhs.s   +   ; branch, if enemy is under
        lda   #$02
        sta   gotp_player_is_above     *    addq.w  #2,d1
PlayerToEnemysAbove                    *+
        puls  d,x,pc
                                       *    rts