; ---------------------------------------------------------------------------
; Subroutine translating object speed to update object position
; This moves the object horizontally and vertically
; but does not apply gravity to it
; ---------------------------------------------------------------------------

                                       *; ---------------------------------------------------------------------------
                                       *; Subroutine translating object speed to update object position
                                       *; This moves the object horizontally and vertically
                                       *; but does not apply gravity to it
                                       *; ---------------------------------------------------------------------------
                                       *
                                       *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                       *
                                       *; sub_163AC: SpeedToPos:
ObjectMove                             *ObjectMove:
                                       *    move.l  x_pos(a0),d2    ; load x position
                                       *    move.l  y_pos(a0),d3    ; load y position
                                       *    move.w  x_vel(a0),d0    ; load horizontal speed
                                       *    ext.l   d0
                                       *    asl.l   #8,d0   ; shift velocity to line up with the middle 16 bits of the 32-bit position
                                       *    add.l   d0,d2   ; add to x-axis position    ; note this affects the subpixel position x_sub(a0) = 2+x_pos(a0)
        ldb   x_vel,u
        sex                            ; la v�locit� est positive ou n�gative, on en tient compte dans l'addition
        sta   am_ObjectMove_01+1
        ldd   x_vel,u
        addd  x_pos+1,u                ; x_pos doit �tre suivi de x_sub en m�moire
        std   x_pos+1,u                ; maj octet poids faible de x_pos et octet de x_sub
        lda   x_pos,u
am_ObjectMove_01
        adca  #$00                     ; le param�tre est modifi�e par le r�sultat du sign extend
        sta   x_pos,u                  ; maj octet poids fort de x_pos
                                       *    move.w  y_vel(a0),d0    ; load vertical speed
                                       *    ext.l   d0
                                       *    asl.l   #8,d0   ; shift velocity to line up with the middle 16 bits of the 32-bit position
                                       *    add.l   d0,d3   ; add to y-axis position    ; note this affects the subpixel position y_sub(a0) = 2+y_pos(a0)
                                       *    move.l  d2,u_pos(a0)    ; update x-axis position
                                       *    move.l  d3,y_pos(a0)    ; update y-axis position
        ldb   y_vel,u
        sex                            ; la v�locit� est positive ou n�gative, on en tient compte dans l'addition
        sta   am_ObjectMove_02+1
        ldd   y_vel,u
        addd  y_pos+1,u                ; y_pos doit �tre suivi de y_sub en m�moire
        std   y_pos+1,u                ; maj octet poids faible de y_pos et octet de y_sub
        lda   y_pos,u
am_ObjectMove_02
        adca  #$00                     ; le param�tre est modifi�e par le r�sultat du sign extend
        sta   y_pos,u                  ; maj octet poids fort de y_pos
        rts                            *    rts
                                       *; End of function ObjectMove
                                       *; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>