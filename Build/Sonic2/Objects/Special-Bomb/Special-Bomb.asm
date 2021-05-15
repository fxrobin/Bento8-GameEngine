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
        bpl   SSB_InTheAir_return                     *        bpl.s   return_34F26
        bsr   SSB_CheckCollision                      *        bsr.w   loc_34F28
        jmp   DisplaySprite                           *        bra.w   JmpTo44_DisplaySprite
                                                      *
SSB_InTheAir_return                                   *return_34F26:
        rts                                           *        rts
                                                      *; ===========================================================================
SSB_InitShadow                                        *loc_3529C:
                                                      *    jsrto   (SSSingleObjLoad2).l, JmpTo_SSSingleObjLoad2
                                                      *    bne.w   return_3532C
                                                      *    move.l  a0,objoff_34(a1)
                                                      *    move.b  id(a0),id(a1)
                                                      *    move.b  #4,routine(a1)
                                                      *    move.l  #Obj63_MapUnc_34492,mappings(a1)
                                                      *    move.w  #make_art_tile(ArtTile_ArtNem_SpecialFlatShadow,3,0),art_tile(a1)
                                                      *    move.b  #4,render_flags(a1)
                                                      *    move.b  #5,priority(a1)
                                                      *    move.b  angle(a0),d0
                                                      *    cmpi.b  #$10,d0
                                                      *    bgt.s   loc_352E6
                                                      *    bset    #0,render_flags(a1)
                                                      *    move.b  #2,objoff_2B(a1)
                                                      *    move.l  a1,objoff_34(a0)
        rts                                           *    rts
                                                      *; ===========================================================================
SSB_ScaleAnim                                         *loc_3512A:
                                                      *    btst    #7,status(a0)
        bne   SSB_CheckDelete                         *    bne.s   loc_3516C
                                                      *    cmpi.b  #4,(SSTrack_drawing_index).w
                                                      *    bne.s   loc_35146
        lda   z_pos,u                                 *    subi.l  #$CCCC,objoff_30(a0)
        ble   SSB_CheckDelete                         *    ble.s   loc_3516C
                                                      *    bra.s   loc_35150
                                                      *
                                                      *loc_35146:
        lda   z_pos,u                                 *    subi.l  #$CCCD,objoff_30(a0)
        ble   SSB_CheckDelete                         *    ble.s   loc_3516C
                                                      *
                                                      *loc_35150:
        ldd   anim,u                                  *    cmpi.b  #$A,anim(a0)
        cmpd  #Ani_SSBomb_explode
        beq   SSB_ScaleAnim_return                    *    beq.s   return_3516A
        lda   z_pos,u                                 *    move.w  objoff_30(a0),d0
        cmpa  #$3A                                    *    cmpi.w  #$1D,d0
        ble   SSB_ScaleAnim_LoadAnim                  *    ble.s   loc_35164
        lda   #$3C                                    *    moveq   #$1E,d0
                                                      *
SSB_ScaleAnim_LoadAnim                                *loc_35164:
        ldx   #Ani_SSBomb                             *    move.b  byte_35180(pc,d0.w),anim(a0)
        ldd   a,x
        std   anim,u
                                                      *
SSB_ScaleAnim_return                                  *return_3516A:
        rts                                           *    rts                                                      
                                                      *; ===========================================================================
SSB_CheckCollision                                    *loc_34F28:
                                                      *        move.w  #8,d6
        jsr   SSB_CheckCollisionContinue              *        bsr.w   loc_350A0
                                                      *        bcc.s   return_34F68
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
                                                      *        st      objoff_2A(a1)
                                                      *
                                                      *return_34F68:
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
                                                      *    moveq   #0,d4
                                                      *    moveq   #0,d5
                                                      *    moveq   #0,d6
                                                      *    moveq   #0,d7
                                                      *    movea.l (SS_CurrentPerspective).w,a1
        lda   z_pos,u                                 *    move.w  objoff_30(a0),d0
                                                      *    beq.w   loc_35258
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
                                                      *    move.b  2(a1,d0.w),d4
                                                      *    move.b  3(a1,d0.w),d5
                                                      *    move.b  1(a1,d0.w),d3
                                                      *
                                                      *loc_351F8:
                                                      *    bpl.s   loc_35202
                                                      *    cmpi.b  #$48,d3
                                                      *    blo.s   loc_35202
                                                      *    ext.w   d3
                                                      *
                                                      *loc_35202:
                                                      *    move.b  angle(a0),d0
                                                      *    jsrto   (CalcSine).l, JmpTo14_CalcSine
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
                                                      *    move.w  d4,d7
                                                      *    lsr.w   #2,d7
                                                      *    add.w   d7,d4
                                                      *    muls.w  d4,d1
                                                      *    move.w  d5,d7
                                                      *    asr.w   #2,d7
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
SSB_CheckIfForeground                                 *loc_34F90:
        ldd   z_pos,u
        cmpd  #4                                      *        cmpi.w  #4,objoff_30(a0)
        bhs                                           *        bhs.s   return_34F9E
        lda   #1
        sta   priority,u                              *        move.b  #1,priority(a0)
                                                      *
return_34F9E                                          *return_34F9E:
        rts                                           *        rts
                                                      *; ===========================================================================
SSB_CheckDelete                                       *loc_3516C:
                                                      *    move.l  (sp)+,d0
                                                      *    move.l  objoff_34(a0),d0
                                                      *    beq.w   JmpTo63_DeleteObject
                                                      *    movea.l d0,a1 ; a1=object
                                                      *    st  objoff_2A(a1)
                                                      *
                                                      *    if removeJmpTos
                                                      *JmpTo63_DeleteObject ; JmpTo
                                                      *    endif
                                                      *
        jmp   DeleteObject                            *    jmpto   (DeleteObject).l, JmpTo63_DeleteObject
                                                      *; =========================================================================== 
SSB_CheckCollisionContinue                            *loc_350A0:
                                                      *    cmpi.b  #8,anim(a0)
                                                      *    bne.s   loc_350DC
                                                      *    tst.b   collision_flags(a0)
                                                      *    beq.s   loc_350DC
                                                      *    lea (MainCharacter).w,a2 ; a2=object (special stage sonic)
                                                      *    lea (Sidekick).w,a3 ; a3=object (special stage tails)
                                                      *    move.w  objoff_34(a2),d0
                                                      *    cmp.w   objoff_34(a3),d0
                                                      *    blo.s   loc_350CE
                                                      *    movea.l a3,a1
                                                      *    bsr.w   loc_350E2
                                                      *    bcs.s   return_350E0
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
                                                      *loc_350DC:
                                                      *    move    #0,ccr
                                                      *
                                                      *return_350E0:
        rts                                           *    rts
                                                      *; ===========================================================================
                                                      
        ... il manque des routines ...
                                                      
SSB_Main                                              *loc_3533A:
                                                      *    tst.b   objoff_2A(a0)
                                                      *    bne.w   BranchTo_JmpTo63_DeleteObject
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
