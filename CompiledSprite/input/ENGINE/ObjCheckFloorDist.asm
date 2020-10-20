; ---------------------------------------------------------------------------
; Subroutine checking if an object should interact with the floor
; (objects such as a monitor Sonic bumps from underneath)
; input REG : 
; output    : gotp_closest_player    (ptr objet de MainCharacter ou Sidekick)
;             gotp_player_is_left (0: player left from object, 2: right)
;             gotp_player_v_location (0: player above object, 2: below)
;             gotp_player_h_distance (closest character's h distance to obj)
;             gotp_player_v_distance (closest character's v distance to obj)
; ---------------------------------------------------------------------------
									   
                                       *; ---------------------------------------------------------------------------
                                       *; Subroutine checking if an object should interact with the floor
                                       *; (objects such as a monitor Sonic bumps from underneath)
                                       *; ---------------------------------------------------------------------------
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; loc_1EDFA: ObjHitFloor:
                                       *ObjCheckFloorDist:
                                       *    move.w  x_pos(a0),d3
                                       *    move.w  y_pos(a0),d2
                                       *    move.b  y_radius(a0),d0
                                       *    ext.w   d0
                                       *    add.w   d0,d2
                                       *    lea (Primary_Angle).w,a4
                                       *    move.b  #0,(a4)
                                       *    movea.w #$10,a3
                                       *    move.w  #0,d6
                                       *    moveq   #$C,d5
                                       *    bsr.w   FindFloor
                                       *    move.b  (Primary_Angle).w,d3
                                       *    btst    #0,d3
                                       *    beq.s   +
                                       *    move.b  #0,d3
                                       *+
                                       *    rts
                                       *; ===========================================================================
