; ---------------------------------------------------------------------------
; Object - Bombs from Special Stage
;
; input REG : [u] pointer to Object Status Table (OST)
; ---------
;
; ---------------------------------------------------------------------------

                                                      *; ===========================================================================
                                                      *; ----------------------------------------------------------------------------
                                                      *; Object 61 - Bombs from Special Stage
                                                      *; ----------------------------------------------------------------------------
                                                      *; Sprite_34EB0:
SSBomb                                                *Obj61:
        lda   routine,u                               *        moveq   #0,d0
        asla                                          *        move.b  routine(a0),d0
        ldx   #SSB_Routines                           *        move.w  Obj61_Index(pc,d0.w),d1
        jmp   [a,x]                                   *        jmp     Obj61_Index(pc,d1.w)
                                                      *; ===========================================================================
                                                      *; off_34EBE:
SSB_Routines                                          *Obj61_Index:    offsetTable
        fdb   SSB_Init                                *                offsetTableEntry.w Obj61_Init   ; 0
        fdb   SSB_InTheAir                            *                offsetTableEntry.w loc_34F06    ; 2
        fdb   SSB_Main                                *                offsetTableEntry.w loc_3533A    ; 4
        fdb   SSB_Explode                             *                offsetTableEntry.w loc_34F6A    ; 6
                                                      *; ===========================================================================
                                                      *; loc_34EC6:
SSB_Init                                              *Obj61_Init:
        lda   routine,u
        adda  #2
        sta   routine,u                               *        addq.b  #2,routine(a0)
        ldd   #$0000                                  *        move.w  #$7F,x_pos(a0)
        std   xy_pixel,u                              *        move.w  #$58,y_pos(a0)
                                                      *        move.l  #Obj61_MapUnc_36508,mappings(a0)
                                                      *        move.w  #make_art_tile(ArtTile_ArtNem_SpecialBomb,1,0),art_tile(a0)
        ; coordinate system                           *        move.b  #4,render_flags(a0)
        ldd   #$0302
        sta   priority,u                              *        move.b  #3,priority(a0)
        stb   collision_flags,u                       *        move.b  #2,collision_flags(a0)
                                                      *        move.b  #-1,(SS_unk_DB4D).w
        tst   angle,u                                 *        tst.b   angle(a0)
        bmi   SSB_InTheAir                            *        bmi.s   loc_34F06
        jsr   SSB_InitShadow                          *        bsr.w   loc_3529C
                                                      *
SSB_InTheAir                                          *loc_34F06:
        jsr   SSB_ScaleAnim                           *        bsr.w   loc_3512A
        jsr   SSB_ComputeCoordinates                  *        bsr.w   loc_351A0
        ldd   Ani_SSBomb_0                            *        lea     (Ani_obj61).l,a1
        std   anim,u         ; anim is defaulted to 0
        jsr   AnimateSprite                           *        bsr.w   loc_3539E
        tst   rsv_render_flags,u                      *        tst.b   render_flags(a0)
        bpl   SSB_Init_return     ; already on screen *        bpl.s   return_34F26
        bsr   SSB_CheckCollision                      *        bsr.w   loc_34F28
        jmp   DisplaySprite                           *        bra.w   JmpTo44_DisplaySprite
                                                      *
SSB_Init_return                                       *return_34F26:
        rts                                           *        rts
                                                      *; ===========================================================================
SSB_InitShadow                                        *loc_3529C:
        jsr   SSSingleObjLoad2                        *    jsrto   (SSSingleObjLoad2).l, JmpTo_SSSingleObjLoad2
        bne   SSB_Init_return                         *    bne.w   return_3532C
        stu   ss_parent,x                             *    move.l  a0,objoff_34(a1)
        stx   ss_parent,u        
        lda   id,u
        sta   id,x                                    *    move.b  id(a0),id(a1)
        lda   #$0405
        sta   routine,x                               *    move.b  #4,routine(a1)
                                                      *    move.l  #Obj63_MapUnc_34492,mappings(a1)
                                                      *    move.w  #make_art_tile(ArtTile_ArtNem_SpecialFlatShadow,3,0),art_tile(a1)
                                                      *    move.b  #4,render_flags(a1)
        stb   priority,x                              *    move.b  #5,priority(a1)
        lda   angle,u                                 *    move.b  angle(a0),d0
        cmpa  #$10                                    *    cmpi.b  #$10,d0
        bgt   loc_352E6                               *    bgt.s   loc_352E6
        lda   render_flags,x
        ora   #render_xmirror_mask                    *    bset    #0,render_flags(a1)
        lda   #2
        sta   ss_shadow_tilt,x                        *    move.b  #2,objoff_2B(a1)
                                                      *    move.l  a1,objoff_34(a0)
        rts                                           *    rts
                                                      *; ===========================================================================
                                                      *
loc_352E6                                             *loc_352E6:
        cmpa  #$30                                    *    cmpi.b  #$30,d0
        bgt   loc_352FE                               *    bgt.s   loc_352FE
        lda   render_flags,x
        ora   #render_xmirror_mask                    *    bset    #0,render_flags(a1)
        lda   #1
        sta   ss_shadow_tilt,x                        *    move.b  #1,objoff_2B(a1)
                                                      *    move.l  a1,objoff_34(a0)
        rts                                           *    rts
                                                      *; ===========================================================================
                                                      *
loc_352FE                                             *loc_352FE:
        cmpa  #$50                                    *    cmpi.b  #$50,d0
        bgt   loc_35310                               *    bgt.s   loc_35310
        lda   #0
        sta   ss_shadow_tilt,x                        *    move.b  #0,objoff_2B(a1)
                                                      *    move.l  a1,objoff_34(a0)
        rts                                           *    rts
                                                      *; ===========================================================================
                                                      *
loc_35310                                             *loc_35310:
        cmpa  #$70                                    *    cmpi.b  #$70,d0
        bgt   loc_35322                               *    bgt.s   loc_35322
        lda   #1
        sta   ss_shadow_tilt,x                        *    move.b  #1,objoff_2B(a1)
                                                      *    move.l  a1,objoff_34(a0)
        rts                                           *    rts
                                                      *; ===========================================================================
                                                      *
loc_35322                                             *loc_35322:
        lda   #2
        sta   ss_shadow_tilt,x                        *    move.b  #2,objoff_2B(a1)
                                                      *    move.l  a1,objoff_34(a0)
                                                      *
                                                      *return_3532C:
        rts                                           *    rts
                                                      
SSB_ScaleAnim                                         *loc_3512A:
        tst   status,u ; ??? a quoi correspond ce flag, collision ? *    btst    #7,status(a0)
        bmi   SSB_DeleteObject                        *    bne.s   loc_3516C
        lda   SSTrack_drawing_index                   *    cmpi.b  #4,(SSTrack_drawing_index).w
        bne   loc_35146                               *    bne.s   loc_35146
        ldd   ss_z_pos,u                              *    subi.l  #$CCCC,objoff_30(a0)
        subd  #$CCCC ; ??? si ss_z_pos <= $CCCC on le delete, mais pourquoi ?
        ble   SSB_DeleteObject                        *    ble.s   loc_3516C
        bra   loc_35150                               *    bra.s   loc_35150
                                                      *
loc_35146                                             *loc_35146:
        ldd   ss_z_pos,u                              *    subi.l  #$CCCD,objoff_30(a0)
        subd  #$CCCD ; ??? si ss_z_pos <= $CCCD on le delete, mais pourquoi ?
        ble   SSB_DeleteObject                        *    ble.s   loc_3516C
                                                      *
loc_35150                                             *loc_35150:
        ldd   anim,u                                  *    cmpi.b  #$A,anim(a0)
        cmpd  #Ani_SSBomb_explode
        beq   SSB_ScaleAnim_return                    *    beq.s   return_3516A
        ldd   ss_z_pos,u                              *    move.w  objoff_30(a0),d0
        cmpa  #$1D                                    *    cmpi.w  #$1D,d0
        ble   SSB_ScaleAnim_LoadAnim                  *    ble.s   loc_35164
        lda   #$1E                                    *    moveq   #$1E,d0
                                                      *
SSB_ScaleAnim_LoadAnim                                *loc_35164:
        ldx   #Ani_SSBomb                             *    move.b  byte_35180(pc,d0.w),anim(a0)
        asla
        ldd   a,x
        std   anim,u
                                                      *
SSB_ScaleAnim_return                                  *return_3516A:
        rts                                           *    rts                                                      
                                                      *; ===========================================================================
SSB_CheckCollision                                    *loc_34F28:
                                                      *        move.w  #8,d6
        jsr   SSB_CheckCollisionContinue              *        bsr.w   loc_350A0
        bcc   return_34F68                            *        bcc.s   return_34F68
                                                      *        move.b  #1,collision_property(a1)
                                                      *        move.w  #SndID_SlowSmash,d0
                                                      *        jsr     (PlaySoundStereo).l
        lda   #6
        sta   routine,u                               *        move.b  #6,routine(a0)
                                                      *        move.b  #0,anim_frame(a0)
                                                      *        move.b  #0,anim_frame_duration(a0)
                                                      *        move.l  objoff_34(a0),d0
                                                      *        beq.s   return_34F68
                                                      *        move.l  #0,objoff_34(a0)
                                                      *        movea.l d0,a1 ; a1=object
                         ; tell shadow to self delete *        st      objoff_2A(a1)
                                                      *
return_34F68                                          *return_34F68:
        rts                                           *        rts
                                                      *; ===========================================================================
                                                      *
SSB_Explode                                           *loc_34F6A:
        ldd   #Ani_SSBomb_explode                     *        move.b  #$A,anim(a0)
        std   anim,u
                                                      *        move.w  #make_art_tile(ArtTile_ArtNem_SpecialExplosion,2,0),art_tile(a0)
        jsr   SSB_CheckIfForeground                   *        bsr.w   loc_34F90
        jsr   SSB_ScaleAnim                           *        bsr.w   loc_3512A
        jsr   SSB_ComputeCoordinates                  *        bsr.w   loc_351A0
                                                      *        lea     (Ani_obj61).l,a1
        jsr   AnimateSprite                           *        jsrto   (AnimateSprite).l, JmpTo24_AnimateSprite
        jmp   DisplaySprite                           *        bra.w   JmpTo44_DisplaySprite
                                                      *; ===========================================================================
SSB_ComputeCoordinates                                *loc_351A0:
                                                      *    move.w  d7,-(sp)
                                                      *    moveq   #0,d2
                                                      *    moveq   #0,d3
        ; no need to init                             *    moveq   #0,d4
        ; no need to init                             *    moveq   #0,d5
                                                      *    moveq   #0,d6
                                                      *    moveq   #0,d7
        ldx   #SS_CurrentPerspective                  *    movea.l (SS_CurrentPerspective).w,a1
        ldd   ss_z_pos,u                              *    move.w  objoff_30(a0),d0
        beq   SSB_HideSprite                          *    beq.w   loc_35258
                                                      *    cmp.w   (a1)+,d0
                                                      *    bgt.w   loc_35258
                                                      *    subq.w  #1,d0
                                                      *    add.w   d0,d0
                                                      *    move.w  d0,d1
                                                      *    add.w   d0,d0
                                                      *    add.w   d1,d0
                                                      *    tst.b   (SSTrack_Orientation).w
                                                      *    bne.w   loc_35260
                                                      *    move.b  4(a1,d0.w),d6
                                                      *    move.b  5(a1,d0.w),d7
                                                      *    beq.s   loc_351E8
                                                      *    move.b  angle(a0),d1
                                                      *    cmp.b   d6,d1
                                                      *    blo.s   loc_351E8
                                                      *    cmp.b   d7,d1
                                                      *    blo.s   loc_35258
                                                      *
                                                      *loc_351E8:
                                                      *    move.b  (a1,d0.w),d2
        ldd   2,x                                     *    move.b  2(a1,d0.w),d4
        std   d4+2 ; store to LSB                                                     
        std   d5+2 ; store to LSB                     *    move.b  3(a1,d0.w),d5
                                                      *    move.b  1(a1,d0.w),d3                                                              
                                                      *
                                                      *loc_351F8:
                                                      *    bpl.s   loc_35202
                                                      *    cmpi.b  #$48,d3
                                                      *    blo.s   loc_35202
                                                      *    ext.w   d3
                                                      *
                                                      *loc_35202:
        ldb   angle,u                                 *    move.b  angle(a0),d0
                                                      *    jsrto   (CalcSine).l, JmpTo14_CalcSine
                                                      
                                                      * ------------------------------------------
                                                      *CalcSine:
        lda   #$00                                    *        andi.w  #$FF,d0
        aslb                                          *        add.w   d0,d0
	    rola
                                                      *        addi.w  #$80,d0
        ldx   #Sine_Data
	    ldy   d,x                                     *        move.w  Sine_Data(pc,d0.w),d1 ; cos
        addd  #$80                                    *        subi.w  #$80,d0
        ldx   d,x                                     *        move.w  Sine_Data(pc,d0.w),d0 ; sin                                                      
                                                      * ------------------------------------------                                                      
                                                      
                                                      *    muls.w  d4,d1
                                                      *    muls.w  d5,d0
                                                      *    asr.l   #8,d0
                                                      *    asr.l   #8,d1
                                                      *    add.w   d2,d1
                                                      *    add.w   d3,d0
                                                      *    move.w  d1,x_pos(a0)
                                                      *    move.w  d0,y_pos(a0)
                                                      *    move.l  objoff_34(a0),d0
                                                      *    beq.s   loc_3524E
                                                      *    movea.l d0,a1 ; a1=object
                                                      *    move.b  angle(a0),d0
                                                      *    jsrto   (CalcSine).l, JmpTo14_CalcSine
d4      ldd   #$00FF ; (dynamic)                      *    move.w  d4,d7
        lsrb ; d4 is one byte no need to lsra/rorb    *    lsr.w   #2,d7
        lsrb
                                                      *    add.w   d7,d4
                                                      *    muls.w  d4,d1
d5      ldd   #$00FF ; (dynamic)                      *    move.w  d5,d7
        lsrb ; d5 is one byte no need to lsra/rorb    *    asr.w   #2,d7
        lsrb ; asr.w is useless since d5 is a byte padded with 0
                                                      *    add.w   d7,d5
                                                      *    muls.w  d5,d0
                                                      *    asr.l   #8,d0
                                                      *    asr.l   #8,d1
                                                      *    add.w   d2,d1
                                                      *    add.w   d3,d0
                                                      *    move.w  d1,x_pos(a1)
                                                      *    move.w  d0,y_pos(a1)
                                                      *
                                                      *loc_3524E:
                                                      *    ori.b   #$80,render_flags(a0)
                                                      *
                                                      *loc_35254:
                                                      *    move.w  (sp)+,d7
        rts                                           *    rts                                                      
                                                      *; ===========================================================================

SSB_HideSprite                                        *loc_35258:
                                                      *    andi.b  #$7F,render_flags(a0)
        rts                                           *    bra.s   loc_35254
                                                      *; ===========================================================================                                                 
                                                      

                                                      *loc_35260:
                                                      *    move.b  #$80,d1
                                                      *    move.b  4(a1,d0.w),d6
                                                      *    move.b  5(a1,d0.w),d7
                                                      *    beq.s   loc_35282
                                                      *    sub.w   d1,d6
                                                      *    sub.w   d1,d7
                                                      *    neg.w   d6
                                                      *    neg.w   d7
                                                      *    move.b  angle(a0),d1
                                                      *    cmp.b   d7,d1
                                                      *    blo.s   loc_35282
                                                      *    cmp.b   d6,d1
                                                      *    blo.s   loc_35258
                                                      *
                                                      *loc_35282:
                                                      *    move.b  (a1,d0.w),d2
                                                      *    move.b  2(a1,d0.w),d4
                                                      *    move.b  3(a1,d0.w),d5
                                                      *    subi.w  #$100,d2
                                                      *    neg.w   d2
                                                      *    move.b  1(a1,d0.w),d3
                                                      *    bra.w   loc_351F8
                                                      *; ===========================================================================
                                                      
SSB_CheckIfForeground                                 *loc_34F90:
        ldd   ss_z_pos,u
        cmpd  #4                                      *        cmpi.w  #4,objoff_30(a0)
        bhs                                           *        bhs.s   return_34F9E
        lda   #1
        sta   priority,u                              *        move.b  #1,priority(a0)
                                                      *
return_34F9E                                          *return_34F9E:
        rts                                           *        rts
                                                      *; ===========================================================================

; TODO : dupliquer ce code pour eviter son appel en tant que sous routine
; TODO : reutiliser les obj pour ne pas avoir a faire de delete (tester performance)
                                                      
SSB_DeleteObject                                      *loc_3516C:
                                                      *    move.l  (sp)+,d0
        ldx   ss_parent,u                             *    move.l  objoff_34(a0),d0
        beq   SSB_SetDeleteFlag ; branch if no child  *    beq.w   JmpTo63_DeleteObject
                                                      *    movea.l d0,a1 ; a1=object
        com   ss_self_delete,x ; shadow to delete     *    st  objoff_2A(a1)
                                                      *
                                                      *    if removeJmpTos
                                                      *JmpTo63_DeleteObject ; JmpTo
                                                      *    endif
SSB_SetDeleteFlag                                     *
        lda   render_flags,u
        ora   #render_todelete_mask                   *    jmpto   (DeleteObject).l, JmpTo63_DeleteObject
        lda   render_flags,u
        rts
                                                      *; =========================================================================== 
SSB_CheckCollisionContinue                            *loc_350A0:
        ldd   anim,u
        cmpd  #Ani_SSBomb_8                           *    cmpi.b  #8,anim(a0)
        bne   loc_350DC                               *    bne.s   loc_350DC
        tst   collision_flags,u                       *    tst.b   collision_flags(a0)
        beq   loc_350DC                               *    beq.s   loc_350DC
                                                      *    lea (MainCharacter).w,a2 ; a2=object (special stage sonic)
                                                      *    lea (Sidekick).w,a3 ; a3=object (special stage tails)
                                                      *    move.w  objoff_34(a2),d0
                                                      *    cmp.w   objoff_34(a3),d0
                                                      *    blo.s   loc_350CE
                                                      *    movea.l a3,a1
                                                      *    bsr.w   loc_350E2
        bcs   return_350E0                            *    bcs.s   return_350E0
                                                      *    movea.l a2,a1
                                                      *    bra.w   loc_350E2
                                                      *; ===========================================================================
                                                      *
                                                      *loc_350CE:
                                                      *    movea.l a2,a1
                                                      *    bsr.w   loc_350E2
                                                      *    bcs.s   return_350E0
                                                      *    movea.l a3,a1
                                                      *    bra.w   loc_350E2
                                                      *; ===========================================================================
                                                      *
loc_350DC                                             *loc_350DC:
        andcc #$FE                                    *    move    #0,ccr
                                                      *
return_350E0                                          *return_350E0:
        rts                                           *    rts
                                                      *; ===========================================================================
                                                      
        ... il manque des routines ...
                                                      
SSB_Main                                              *loc_3533A:
        tst                                           *    tst.b   objoff_2A(a0)
        bne   SSB_SetDeleteFlag                       *    bne.w   BranchTo_JmpTo63_DeleteObject
                                                      *    movea.l objoff_34(a0),a1 ; a1=object
                                                      *    tst.b   render_flags(a1)
                                                      *    bmi.s   loc_3534E
        rts                                           *    rts
                                                      *; ===========================================================================
                                                      *
                                                      *loc_3534E:
                                                      *    moveq   #9,d0
                                                      *    sub.b   anim(a1),d0
                                                      *    addi_.b #1,d0
                                                      *    cmpi.b  #$A,d0
                                                      *    bne.s   loc_35362
                                                      *    move.w  #9,d0
                                                      *
                                                      *loc_35362:
                                                      *    move.w  d0,d1
                                                      *    add.w   d0,d0
                                                      *    add.w   d1,d0
                                                      *    moveq   #0,d1
                                                      *    move.b  objoff_2B(a0),d1
                                                      *    beq.s   loc_3538A
                                                      *    cmpi.b  #1,d1
                                                      *    beq.s   loc_35380
                                                      *    add.w   d1,d0
                                                      *    move.w  #make_art_tile(ArtTile_ArtNem_SpecialSideShadow,3,0),art_tile(a0)
                                                      *    bra.s   loc_35392
                                                      *; ===========================================================================
                                                      *
                                                      *loc_35380:
                                                      *    add.w   d1,d0
                                                      *    move.w  #make_art_tile(ArtTile_ArtNem_SpecialDiagShadow,3,0),art_tile(a0)
                                                      *    bra.s   loc_35392
                                                      *; ===========================================================================
                                                      *
                                                      *loc_3538A:
                                                      *    add.w   d1,d0
                                                      *    move.w  #make_art_tile(ArtTile_ArtNem_SpecialFlatShadow,3,0),art_tile(a0)
                                                      *
                                                      *loc_35392:
                                                      *    move.b  d0,mapping_frame(a0)
        jmp   DisplaySprite                           *    bra.w   JmpTo44_DisplaySprite
                                                      *; ===========================================================================                                                      

                                                      *; ---------------------------------------------------------------------------
                                                      *; Subroutine to calculate sine and cosine of an angle
                                                      *; d0 = input byte = angle (360 degrees == 256)
                                                      *; d0 = output word = 255 * sine(angle)
                                                      *; d1 = output word = 255 * cosine(angle)
                                                      *; ---------------------------------------------------------------------------
                                                      *
                                                      *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                                      *
                                                      *; sub_33B6:
CalcSine                                              *CalcSine:
        lda   #$00                                    *        andi.w  #$FF,d0
        aslb                                          *        add.w   d0,d0
	    rola
                                                      *        addi.w  #$80,d0
        ldx   #Sine_Data
	    ldy   d,x                                     *        move.w  Sine_Data(pc,d0.w),d1 ; cos
        addd  #$80                                    *        subi.w  #$80,d0
        ldx   d,x                                     *        move.w  Sine_Data(pc,d0.w),d0 ; sin
        rts                                           *        rts
                                                      *; End of function CalcSine
                                                      *
                                                      *; ===========================================================================
                                                      *; word_33CE:
Sine_Data                                             *Sine_Data:      BINCLUDE        "misc/sinewave.bin"
        INCLUDEBIN "./Engine/sinewave.bin"

                                                      *; ===========================================================================
                                                      *byte_35180:
                                                      *    dc.b   9,  9,  9,  8,  8,  7,  7,  6,  6,  5,  5,  4,  4,  3,  3,  3
                                                      *    dc.b   2,  2,  2,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0; 16
                                                      *; ===========================================================================
Ani_SSBomb
        fdb   Ani_SSBomb_9 ; 0
        fdb   Ani_SSBomb_9 ; 2
        fdb   Ani_SSBomb_9 ; 4
        fdb   Ani_SSBomb_8 ; 6
        fdb   Ani_SSBomb_8 ; 8
        fdb   Ani_SSBomb_7 ; $A
        fdb   Ani_SSBomb_7 ; $C
        fdb   Ani_SSBomb_6 ; $E
        fdb   Ani_SSBomb_6 ; $10
        fdb   Ani_SSBomb_5 ; $12
        fdb   Ani_SSBomb_5 ; $14
        fdb   Ani_SSBomb_4 ; $16
        fdb   Ani_SSBomb_4 ; $18                                                
        fdb   Ani_SSBomb_3 ; $1A
        fdb   Ani_SSBomb_3 ; $1C
        fdb   Ani_SSBomb_3 ; $1E
        fdb   Ani_SSBomb_2 ; $20                               
		fdb   Ani_SSBomb_2 ; $22
        fdb   Ani_SSBomb_2 ; $24
        fdb   Ani_SSBomb_1 ; $26
        fdb   Ani_SSBomb_1 ; $28
        fdb   Ani_SSBomb_1 ; $2A
        fdb   Ani_SSBomb_1 ; $2C
        fdb   Ani_SSBomb_1 ; $2E
        fdb   Ani_SSBomb_1 ; $30
        fdb   Ani_SSBomb_1 ; $32
        fdb   Ani_SSBomb_1 ; $34
        fdb   Ani_SSBomb_1 ; $36
        fdb   Ani_SSBomb_1 ; $38
        fdb   Ani_SSBomb_1 ; $3A
        fdb   Ani_SSBomb_0 ; $3C removed one index ($3E) from original code, since every index > $3A is capped to index $3C
