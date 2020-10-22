; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Scans vertically for up to 2 16x16 blocks to find solid ground or ceiling.
; d2 = y_pos
; d3 = x_pos
; d5 = ($c,$d) or ($e,$f) - solidity type bit (L/R/B or top)
; d6 = $0000 for no flip, $0800 for vertical flip
; a3 = delta-y for next location to check if current one is empty
; a4 = pointer to angle buffer
; returns relevant block ID in (a1)
; returns distance in d1
; returns angle in (a4)


                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; Scans vertically for up to 2 16x16 blocks to find solid ground or ceiling.
                                       *; d2 = y_pos
                                       *; d3 = x_pos
                                       *; d5 = ($c,$d) or ($e,$f) - solidity type bit (L/R/B or top)
                                       *; d6 = $0000 for no flip, $0800 for vertical flip
                                       *; a3 = delta-y for next location to check if current one is empty
                                       *; a4 = pointer to angle buffer
                                       *; returns relevant block ID in (a1)
                                       *; returns distance in d1
                                       *; returns angle in (a4)
                                       *
                                       *; loc_1E7D0:
                                       *FindFloor:
                                       *    bsr.w   Find_Tile
                                       *    move.w  (a1),d0
                                       *    move.w  d0,d4
                                       *    andi.w  #$3FF,d0
                                       *    beq.s   loc_1E7E2
                                       *    btst    d5,d4
                                       *    bne.s   loc_1E7F0
                                       *
                                       *loc_1E7E2:
                                       *    add.w   a3,d2
                                       *    bsr.w   FindFloor2
                                       *    sub.w   a3,d2
                                       *    addi.w  #$10,d1
                                       *    rts
                                       *; ===========================================================================
                                       *
                                       *loc_1E7F0:  ; block has some solidity
                                       *    movea.l (Collision_addr).w,a2   ; pointer to collision data, i.e. blockID -> collisionID array
                                       *    move.b  (a2,d0.w),d0    ; get collisionID
                                       *    andi.w  #$FF,d0
                                       *    beq.s   loc_1E7E2
                                       *    lea (ColCurveMap).l,a2
                                       *    move.b  (a2,d0.w),(a4)  ; get angle from AngleMap --> (a4)
                                       *    lsl.w   #4,d0
                                       *    move.w  d3,d1   ; x_pos
                                       *    btst    #$A,d4  ; adv.blockID in d4 - X flipping
                                       *    beq.s   +
                                       *    not.w   d1
                                       *    neg.b   (a4)
                                       *+
                                       *    btst    #$B,d4  ; Y flipping
                                       *    beq.s   +
                                       *    addi.b  #$40,(a4)
                                       *    neg.b   (a4)
                                       *    subi.b  #$40,(a4)
                                       *+
                                       *    andi.w  #$F,d1  ; x_pos (mod 16)
                                       *    add.w   d0,d1   ; d0 = 16*blockID -> offset in ColArray to look up
                                       *    lea (ColArray).l,a2
                                       *    move.b  (a2,d1.w),d0    ; heigth from ColArray
                                       *    ext.w   d0
                                       *    eor.w   d6,d4
                                       *    btst    #$B,d4  ; Y flipping
                                       *    beq.s   +
                                       *    neg.w   d0
                                       *+
                                       *    tst.w   d0
                                       *    beq.s   loc_1E7E2   ; no collision
                                       *    bmi.s   loc_1E85E
                                       *    cmpi.b  #$10,d0
                                       *    beq.s   loc_1E86A
                                       *    move.w  d2,d1
                                       *    andi.w  #$F,d1
                                       *    add.w   d1,d0
                                       *    move.w  #$F,d1
                                       *    sub.w   d0,d1
                                       *    rts
                                       *; ===========================================================================
                                       *
                                       *loc_1E85E:
                                       *    move.w  d2,d1
                                       *    andi.w  #$F,d1
                                       *    add.w   d1,d0
                                       *    bpl.w   loc_1E7E2
                                       *
                                       *loc_1E86A:
                                       *    sub.w   a3,d2
                                       *    bsr.w   FindFloor2
                                       *    add.w   a3,d2
                                       *    subi.w  #$10,d1
                                       *    rts
                                       *; End of function FindFloor