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
SSBomb                                                                    *Obj61:
        lda   routine,u                                                   *        moveq   #0,d0
        asla                                                              *        move.b  routine(a0),d0
        ldx   #SSB_Routines                                               *        move.w  Obj61_Index(pc,d0.w),d1
        jmp   [a,x]                                                       *        jmp     Obj61_Index(pc,d1.w)
                                                                          *; ===========================================================================
                                                                          *; off_34EBE:
SSB_Routines                                                              *Obj61_Index:    offsetTable
        fdb   SSB_Init                                                    *                offsetTableEntry.w Obj61_Init   ; 0
        fdb   SSB_Bomb                                                    *                offsetTableEntry.w loc_34F06    ; 2
        fdb   SSB_Shadow                                                  *                offsetTableEntry.w loc_3533A    ; 4
        fdb   SSB_Explode                                                 *                offsetTableEntry.w loc_34F6A    ; 6
                                                                          *; ===========================================================================
                                                                          *; loc_34EC6:
SSB_Init                                                                  *Obj61_Init:
        inc   routine,u                                                   *        addq.b  #2,routine(a0)
        ldd   #$0000                                                      *        move.w  #$7F,x_pos(a0)
        std   xy_pixel,u                                                  *        move.w  #$58,y_pos(a0)
                                                                          *        move.l  #Obj61_MapUnc_36508,mappings(a0)
                                                                          *        move.w  #make_art_tile(ArtTile_ArtNem_SpecialBomb,1,0),art_tile(a0)
        ; coordinate system                                               *        move.b  #4,render_flags(a0)
        ldd   #$0302                                                      
        sta   priority,u                                                  *        move.b  #3,priority(a0)
        stb   collision_flags,u                                           *        move.b  #2,collision_flags(a0)
                                                                          *        move.b  #-1,(SS_unk_DB4D).w
        tst   angle,u                                                     *        tst.b   angle(a0)
        bmi   SSB_Main                                                    *        bmi.s   loc_34F06
        jsr   SSB_InitShadow                                              *        bsr.w   loc_3529C
                                                                          *
SSB_Bomb                                                                  *loc_34F06:
        jsr   SSB_ScaleAnim                                               *        bsr.w   loc_3512A
        jsr   SSB_ComputeCoordinates                                      *        bsr.w   loc_351A0
        ldd   Ani_SSBomb_0                                                *        lea     (Ani_obj61).l,a1
        std   anim,u         ; anim is defaulted to 0                     
        jsr   AnimateSprite                                               *        bsr.w   loc_3539E
        tst   rsv_render_flags,u                                          *        tst.b   render_flags(a0)
        bpl   SSB_Init_return     ; already on screen                     *        bpl.s   return_34F26
        bsr   SSB_CheckCollision                                          *        bsr.w   loc_34F28
        jmp   DisplaySprite                                               *        bra.w   JmpTo44_DisplaySprite
                                                                          *
SSB_Init_return                                                           *return_34F26:
        rts                                                               *        rts
                                                                          *; ===========================================================================
SSB_InitShadow                                                            *loc_3529C:
        jsr   SSSingleObjLoad2                                            *    jsrto   (SSSingleObjLoad2).l, JmpTo_SSSingleObjLoad2
        bne   SSB_Init_return                                             *    bne.w   return_3532C
        stu   ss_parent,x                                                 *    move.l  a0,objoff_34(a1)
        stx   ss_parent,u                                                 
        lda   id,u                                                        
        sta   id,x                                                        *    move.b  id(a0),id(a1)
        lda   #$0205                                                      
        sta   routine,x                                                   *    move.b  #4,routine(a1)
                                                                          *    move.l  #Obj63_MapUnc_34492,mappings(a1)
                                                                          *    move.w  #make_art_tile(ArtTile_ArtNem_SpecialFlatShadow,3,0),art_tile(a1)
                                                                          *    move.b  #4,render_flags(a1)
        stb   priority,x                                                  *    move.b  #5,priority(a1)
        lda   angle,u                                                     *    move.b  angle(a0),d0
        cmpa  #$10                                                        *    cmpi.b  #$10,d0
        bgt   loc_352E6                                                   *    bgt.s   loc_352E6
        lda   render_flags,x                                              
        ora   #render_xmirror_mask                                        *    bset    #0,render_flags(a1)
        lda   #2                                                          
        sta   ss_shadow_tilt,x                                            *    move.b  #2,objoff_2B(a1)
                                                                          *    move.l  a1,objoff_34(a0)
        rts                                                               *    rts
                                                                          *; ===========================================================================
                                                                          *
loc_352E6                                                                 *loc_352E6:
        cmpa  #$30                                                        *    cmpi.b  #$30,d0
        bgt   loc_352FE                                                   *    bgt.s   loc_352FE
        lda   render_flags,x                                              
        ora   #render_xmirror_mask                                        *    bset    #0,render_flags(a1)
        lda   #1                                                          
        sta   ss_shadow_tilt,x                                            *    move.b  #1,objoff_2B(a1)
                                                                          *    move.l  a1,objoff_34(a0)
        rts                                                               *    rts
                                                                          *; ===========================================================================
                                                                          *
loc_352FE                                                                 *loc_352FE:
        cmpa  #$50                                                        *    cmpi.b  #$50,d0
        bgt   loc_35310                                                   *    bgt.s   loc_35310
        lda   #0                                                          
        sta   ss_shadow_tilt,x                                            *    move.b  #0,objoff_2B(a1)
                                                                          *    move.l  a1,objoff_34(a0)
        rts                                                               *    rts
                                                                          *; ===========================================================================
                                                                          *
loc_35310                                                                 *loc_35310:
        cmpa  #$70                                                        *    cmpi.b  #$70,d0
        bgt   loc_35322                                                   *    bgt.s   loc_35322
        lda   #1                                                          
        sta   ss_shadow_tilt,x                                            *    move.b  #1,objoff_2B(a1)
                                                                          *    move.l  a1,objoff_34(a0)
        rts                                                               *    rts
                                                                          *; ===========================================================================
                                                                          *
loc_35322                                                                 *loc_35322:
        lda   #2                                                          
        sta   ss_shadow_tilt,x                                            *    move.b  #2,objoff_2B(a1)
                                                                          *    move.l  a1,objoff_34(a0)
                                                                          *
                                                                          *return_3532C:
        rts                                                               *    rts
                                                                          
SSB_ScaleAnim                                                             *loc_35150:
        ldd   anim,u                                                      *    cmpi.b  #$A,anim(a0)
        cmpd  #Ani_SSBomb_explode                                         
        beq   SSB_ScaleAnim_return                                        *    beq.s   return_3516A
        ldd   ss_z_pos,u                                                  *    move.w  objoff_30(a0),d0
        cmpa  #$1D                                                        *    cmpi.w  #$1D,d0
        ble   SSB_ScaleAnim_LoadAnim                                      *    ble.s   loc_35164
        lda   #$1E                                                        *    moveq   #$1E,d0
                                                                          *
SSB_ScaleAnim_LoadAnim                                                    *loc_35164:
        ldx   #Ani_SSBomb                                                 *    move.b  byte_35180(pc,d0.w),anim(a0)
        asla
        ldd   a,x
        std   anim,u
                                                                          *
SSB_ScaleAnim_return                                                      *return_3516A:
        rts                                                               *    rts                                                      
                                                                          *; ===========================================================================
SSB_CheckCollision                                                        *loc_34F28:
        ; collision width, now hardcoded in collision routine             *        move.w  #8,d6
        jsr   CheckCollision                                              *        bsr.w   loc_350A0
        bcc   return_34F68                                                *        bcc.s   return_34F68
        lda   #1
        sta   collision_property,x                                        *        move.b  #1,collision_property(a1)
                                                                          *        move.w  #SndID_SlowSmash,d0
                                                                          *        jsr     (PlaySoundStereo).l
        ldd   #$0300                                                          
        sta   routine,u                ; explode                          *        move.b  #6,routine(a0)
        stb   anim_frame,u                                                *        move.b  #0,anim_frame(a0)
        stb   anim_frame_duration,u                                       *        move.b  #0,anim_frame_duration(a0)
        ldx   ss_parent,u                                                 *        move.l  objoff_34(a0),d0
        beq   return_34F68                                                *        beq.s   return_34F68
        lda   #0
        std   ss_parent,u                                                 *        move.l  #0,objoff_34(a0)
                                                                          *        movea.l d0,a1 ; a1=object
        com   ss_self_delete,x         ; tell shadow to self delete       *        st      objoff_2A(a1)
                                                                          *
return_34F68                                                              *return_34F68:
        rts                                                               *        rts
                                                                          *; ===========================================================================
                                                                          *
SSB_Explode                                                               *loc_34F6A:
        ldd   #Ani_SSBomb_explode                                         *        move.b  #$A,anim(a0)
        std   anim,u                                                      
                                                                          *        move.w  #make_art_tile(ArtTile_ArtNem_SpecialExplosion,2,0),art_tile(a0)
        jsr   SSB_CheckIfForeground                                       *        bsr.w   loc_34F90
        jsr   SSB_ScaleAnim                                               *        bsr.w   loc_3512A
        jsr   SSB_ComputeCoordinates                                      *        bsr.w   loc_351A0
                                                                          *        lea     (Ani_obj61).l,a1
        jsr   AnimateSprite                                               *        jsrto   (AnimateSprite).l, JmpTo24_AnimateSprite
        jmp   DisplaySprite                                               *        bra.w   JmpTo44_DisplaySprite
                                                                          *; ===========================================================================
SSB_ComputeCoordinates                                                    *loc_351A0:
                                                                          *    move.w  d7,-(sp)
                                                                          *    moveq   #0,d2
                                                                          *    moveq   #0,d3
                                                                          *    moveq   #0,d4
                                                                          *    moveq   #0,d5
                                                                          *    moveq   #0,d6
                                                                          *    moveq   #0,d7
        ldx   #SS_CurrentPerspective                                      *    movea.l (SS_CurrentPerspective).w,a1
        ldd   ss_z_pos,u               ; load sprite z position           *    move.w  objoff_30(a0),d0
        beq   return_34F68             ; if z=0 sprite is behind camera   *    beq.w   loc_35258
        cmpd  ,x++                     ; read nb of ellipses for this img *    cmp.w   (a1)+,d0
        bgt   return_34F68             ; sprite is too far, no ellipse    *    bgt.w   loc_35258
        subd  #1                       ; each perspective data for an img *    subq.w  #1,d0
        aslb                           ; is stored in groups of 6 bytes
        rola                           ; one group defines an ellipse     *    add.w   d0,d0
        std   d1+1                     ; for a specific distance from     *    move.w  d0,d1
        aslb                           ; camera, first group is
        rola                           ; for ss_z_pos = 1                 *    add.w   d0,d0
d1      addd  #$0000                   ; (dynamic) d = (ss_z_pos-1)*6     *    add.w   d1,d0
        tfr   d,x
        tst   SSTrack_Orientation                                         *    tst.b   (SSTrack_Orientation).w
        bne   SSB_CC_Flipped           ; branch if image is h flipped     *    bne.w   loc_35260
        ldd   4,x                                                         *    move.b  4(a1,d0.w),d6
        sta   d6+1                                                        *    move.b  5(a1,d0.w),d7
        stb   d7+1                     ; branch if angle min
        beq   SSB_CC_VisibleArea       ; of visible area is 0             *    beq.s   loc_351E8
        lda   angle,u                  ; load sprite angle                *    move.b  angle(a0),d1
d6      cmpa  #$00                     ; (dynamic) angle max (incl.)      *    cmp.b   d6,d1
        blo   SSB_CC_VisibleArea       ; of visible area                  *    blo.s   loc_351E8
d7      cmpa  #$00                     ; (dynamic) angle min (excl.)      *    cmp.b   d7,d1
        blo   return_34F68             ; of visible area                  *    blo.s   loc_35258
                                                                          *
SSB_CC_VisibleArea                                                        *loc_351E8:
        clra
        ldb   ,x                                                          *    move.b  (a1,d0.w),d2
        std   xCenter+1
        std   sxCenter+1
                                                                          *    move.b  2(a1,d0.w),d4
                                                                          *    move.b  3(a1,d0.w),d5
                                                                          *    move.b  1(a1,d0.w),d3
                                                                          *
SSB_CC_ProcessYCenter                                                     *loc_351F8:
        clra
        ldb   1,x
        tstb
        bpl   @a                                                          *    bpl.s   loc_35202
        cmpb  #$48                                                        *    cmpi.b  #$48,d3
        blo   @a                                                          *    blo.s   loc_35202
        sex                                                               *    ext.w   d3
@a      std   yCenter+1
        std   syCenter+1
                                                                          *
                                                                          *loc_35202:
        ldb   angle,u                                                     *    move.b  angle(a0),d0

        ldy   #Sine_Data                                                  *CalcSine:
        lda   #$00                                                        *    andi.w  #$FF,d0
        aslb                                                              *    add.w   d0,d0
	    rola
	    leay  d,y
	    ldd   y
	    std   ysin+1
        leay  $80,y                                                       *    addi.w  #$80,d0
	    ldd   ,y                                                          *    move.w  Sine_Data(pc,d0.w),d1 ; cos
                                                                          *    subi.w  #$80,d0
                                                                          *    move.w  Sine_Data(pc,d0.w),d0 ; sin
                                                                          *; CalcSineEnd
                                                                          
                                                                          *    muls.w  d4,d1
                                                                          *    muls.w  d5,d0
                                                                          *    asr.l   #8,d0
                                                                          *    asr.l   #8,d1
                                                                          *    add.w   d2,d1
                                                                          *    add.w   d3,d0
                                                                          *    move.w  d1,x_pos(a0)
                                                                          *    move.w  d0,y_pos(a0)
        ; Compute X coordinate
        ; --------------------                                                                                                                                            
        ; signed mul of a value (range FF00-1000) with an non null unsigned byte (01-FF)
        ; next the value is divided by 256
        
        tsta
        beq   xpos  ; cas $0000 <= d <= $00FF
        bpl   xp256 ; cas d = $0100
        tstb
        bne   xneg  ; cas $FF01 >= d >= $FFFF    

xn256   ldb   2,x  ; cas d = $FF00
        negb
        bra   xEnd

xp256   clra
        ldb   2,x
        bra   xEnd

xpos    lda   2,x 
        mul
        tfr   a,b
        clra
        bra   xEnd

xneg    lda   2,x    
        negb
        mul
        nega
        negb
        sbca  #0
        tfr   a,b
        lda   #$FF
        
xEnd    std   sx+1
xCenter addd  #$0000                   ; (dynamic) add x center of ellipse
        std   x_pos,u
          
        ; Compute Y coordinate
        ; --------------------          
        ; signed mul of a value (range FF00-1000) with an non null unsigned byte (01-FF)
        ; next the value is divided by 256
        
ysin    ldd   #$0000                   ; (dynamic) get sin
        tsta
        beq   ypos  ; cas $0000 <= d <= $00FF
        bpl   yp256 ; cas d = $0100
        tstb
        bne   yneg  ; cas $FF01 >= d >= $FFFF    

yn256   ldb   3,x  ; cas d = $FF00
        negb
        bra   yEnd

yp256   clra
        ldb   3,x
        bra   yEnd

ypos    lda   3,x 
        mul
        tfr   a,b
        clra
        bra   yEnd

yneg    lda   3,x    
        negb
        mul
        nega
        negb
        sbca  #0
        tfr   a,b
        lda   #$FF
        
yEnd    std   sy+1
yCenter addd  #$0000                   ; (dynamic) add y center of ellipse
        std   y_pos,u

        ; Process shadow coordinates
        ; --------------------------

        ldy   ss_parent,u                                                 *    move.l  objoff_34(a0),d0
        beq   SSB_CC_NoShadow                                             *    beq.s   loc_3524E
                                                                          *    movea.l d0,a1 ; a1=object
                                                                          *    move.b  angle(a0),d0
                                                                          *
                                                                          *CalcSine:
                                                                          *    andi.w  #$FF,d0
                                                                          *    add.w   d0,d0
																          
																          
																          
																          
                                                                          *    addi.w  #$80,d0
	                                                                      *    move.w  Sine_Data(pc,d0.w),d1 ; cos
                                                                          *    subi.w  #$80,d0
                                                                          *    move.w  Sine_Data(pc,d0.w),d0 ; sin
                                                                          *; CalcSineEnd
        ; we will appy 1,25 factor on already calculated ellipse          *
        ; instead of process muls one more time                                                                  
sx      ldd   #$0000                   ; (dynamic)
        ldx   *-2
        lsra
        rorb
        lsra
        rorb        
        abx

         
sxCenter
        ldd   #$0000                   ; (dynamic) add x center of ellipse
        leax  d,x        
        stx   x_pos,y                                                                                  
                                                                          *    move.w  d4,d7
                                                                          *    lsr.w   #2,d7
                                                                          *    add.w   d7,d4
                                                                          *    muls.w  d4,d1
        ; we will appy 1,25 factor on already calculated ellipse          *
        ; instead of process muls one more time                                                                  
sy      ldd   #$0000                   ; (dynamic)
        ldx   *-2
        lsra
        rorb
        lsra
        rorb        
        abx

         
syCenter
        ldd   #$0000                   ; (dynamic) add y center of ellipse
        leax  d,x        
        stx   y_pos,y                                                                       
                                                                          *    move.w  d5,d7
                                                                          *    asr.w   #2,d7
                                                                          *    add.w   d7,d5
                                                                          *    muls.w  d5,d0
                                                                          
                                                                          *    asr.l   #8,d0
                                                                          *    asr.l   #8,d1
                                                                          *    add.w   d2,d1
                                                                          *    move.w  d1,x_pos(a1)                                                                                                                            
                                                                          *    add.w   d3,d0
                                                                          *    move.w  d0,y_pos(a1)
                                                                          *
SSB_CC_NoShadow                                                           *loc_3524E:
                                                                          *    ori.b   #$80,render_flags(a0)
                                                                          *
                                                                          *loc_35254:
                                                                          *    move.w  (sp)+,d7
        rts                                                               *    rts                                                      
                                                                          *; ===========================================================================
													                      
                                                                          *loc_35258:
                                                                          *    andi.b  #$7F,render_flags(a0)
                                                                          *    bra.s   loc_35254
                                                                          *; ===========================================================================  
        
SSB_CC_Flipped                                                            *loc_35260:
                                                                          *    move.b  #$80,d1
                                                                          *    move.b  4(a1,d0.w),d6
        ldb   5,x                      ; branch if angle min              *    move.b  5(a1,d0.w),d7
        beq   SSB_CC_FVisibleArea      ; of visible area is 0             *    beq.s   loc_35282
        clra
        subd  #$0080
        negb
        stb   fd7+1
        clra
        ldb   4,x
        subd  #$0080
        negb
        stb   fd6+1        
                                                                          *    sub.w   d1,d6
                                                                          *    sub.w   d1,d7
                                                                          *    neg.w   d6
                                                                          *    neg.w   d7
        lda   angle,u                  ; load sprite angle                *    move.b  angle(a0),d1
fd7     cmpa  #$00                     ; (dynamic) angle min (excl.)      *    cmp.b   d7,d1
        blo   SSB_CC_FVisibleArea                                         *    blo.s   loc_35282
fd6     cmpa  #$00                     ; (dynamic) angle max (incl.)      *    cmp.b   d6,d1
        blo   return_34F9E                                                *    blo.s   loc_35258
                                                                          *
SSB_CC_FVisibleArea                                                       *loc_35282:
        clra
        ldb   ,x                                                          *    move.b  (a1,d0.w),d2
                                                                          *    move.b  2(a1,d0.w),d4
                                                                          *    move.b  3(a1,d0.w),d5
        subd  #$100                                                       *    subi.w  #$100,d2
        nega                                                              *    neg.w   d2
        negb
        sbca  #0
        std   xCenter+1
        std   sxCenter+1
                                                                          *    move.b  1(a1,d0.w),d3
        bra   SSB_CC_ProcessYCenter                                       *    bra.w   loc_351F8
                                                                          *; ===========================================================================
                                                                          
SSB_CheckIfForeground                                                     *loc_34F90:
        ldd   ss_z_pos,u                                                  
        cmpd  #4                                                          *        cmpi.w  #4,objoff_30(a0)
        bhs   return_34F9E                                                *        bhs.s   return_34F9E
        lda   #1                                                          
        sta   priority,u                                                  *        move.b  #1,priority(a0)
                                                                          *
return_34F9E                                                              *return_34F9E:
        rts                                                               *        rts
                                                                          *; ===========================================================================
 
CheckCollision                                                            *loc_350A0:
        ldd   anim,u                                                      
        cmpd  #Ani_SSBomb_8                                               *    cmpi.b  #8,anim(a0)
        bne   loc_350DC                                                   *    bne.s   loc_350DC
        tst   collision_flags,u                                           *    tst.b   collision_flags(a0)
        beq   loc_350DC                                                   *    beq.s   loc_350DC
        ldx   #MainCharacter                                              *    lea (MainCharacter).w,a2 ; a2=object (special stage sonic)
                                                                          *    lea (Sidekick).w,a3 ; a3=object (special stage tails)
                                                                          *    move.w  objoff_34(a2),d0
                                                                          *    cmp.w   objoff_34(a3),d0
                                                                          *    blo.s   loc_350CE
                                                                          *    movea.l a3,a1
                                                                          *    bsr.w   loc_350E2
                                                                          *    bcs.s   return_350E0
                                                                          *    movea.l a2,a1
        bra   loc_350E2                                                   *    bra.w   loc_350E2
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
loc_350DC                                                                 *loc_350DC:
        andcc #$FE                                                        *    move    #0,ccr
                                                                          *
return_350E0                                                              *return_350E0:
        rts                                                               *    rts
                                                                          *; ===========================================================================
                                                                          
loc_350E2                                                                 *loc_350E2:
                                                                          *    tst.b   id(a1)
                                                                          *    beq.s   loc_3511A
        lda   routine,x
        cmpa  #$1                      ; sonic is in MdNormal             *    cmpi.b  #2,routine(a1)
        bne   loc_3511A                                                   *    bne.s   loc_3511A
        tst   routine_secondary,x                                         *    tst.b   routine_secondary(a1)
        bne   loc_3511A                ; branch if sonic in hurt state    *    bne.s   loc_3511A
                                                                          *    move.b  angle(a1),d0
        lda   angle,u                  ; bomb angle                       *    move.b  angle(a0),d1
        ldb   angle,u                                                                          
                                                                          *    move.b  d1,d2
        adda  #8                                                          *    add.b   d6,d1
        bcs   loc_35110                                                   *    bcs.s   loc_35110
        subb  #8                                                          *    sub.b   d6,d2
        bcs   loc_35112                                                   *    bcs.s   loc_35112
        cmpa  angle,x                                                     *    cmp.b   d1,d0
        blo   loc_3511A                                                   *    bhs.s   loc_3511A
        cmpb  angle,x                                                     *    cmp.b   d2,d0
        blo   loc_35120                                                   *    bhs.s   loc_35120
        bra   loc_3511A                                                   *    bra.s   loc_3511A
                                                                          *; ===========================================================================
                                                                          *
loc_35110                                                                 *loc_35110:
        subb  #8                                                          *    sub.b   d6,d2
                                                                          *
loc_35112                                                                 *loc_35112:
        cmpa  angle,x                                                     *    cmp.b   d1,d0
        bhs   loc_35120                                                   *    blo.s   loc_35120
        cmpb  angle,x                                                     *    cmp.b   d2,d0
        bhs   loc_35120                                                   *    bhs.s   loc_35120
                                                                          *
loc_3511A                                                                 *loc_3511A:
        andcc #$FE                                                        *    move    #0,ccr
        rts                                                               *    rts
                                                                          *; ===========================================================================
                                                                          *
loc_35120                                                                 *loc_35120:
        clr   collision_flags,u                                           *    clr.b   collision_flags(a0)
        orcc  #$01                                                        *    move    #1,ccr
        rts                                                               *    rts
                                                                          *; ===========================================================================
             
SSB_SetDeleteFlag
        lda   render_flags,u                                              
        ora   #render_todelete_mask                                       *    jmpto   (DeleteObject).l, JmpTo63_DeleteObject
        lda   render_flags,u                                              
        rts             
                                                                          
SSB_Shadow                                                                *loc_3533A:
        tst   ss_self_delete,u                                            *    tst.b   objoff_2A(a0)
        bne   SSB_SetDeleteFlag                                           *    bne.w   BranchTo_JmpTo63_DeleteObject
        ldx   ss_parent,u                                                 *    movea.l objoff_34(a0),a1 ; a1=object
        tst   rsv_render_flags,x                                          *    tst.b   render_flags(a1)
        bmi   loc_3534E                                                   *    bmi.s   loc_3534E
        rts                                                               *    rts
                                                                          *; ===========================================================================
                                                                          *
loc_3534E                                                                 *loc_3534E:
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
        lda   ss_shadow_tilt,u                                            *    move.b  objoff_2B(a0),d1
        beq   loc_3538A                                                   *    beq.s   loc_3538A
        cmpa  #1                                                          *    cmpi.b  #1,d1
        beq   loc_35380                                                   *    beq.s   loc_35380
                                                                          *    add.w   d1,d0
                                                                          *    move.w  #make_art_tile(ArtTile_ArtNem_SpecialSideShadow,3,0),art_tile(a0)
        ldx   image_set,x
        lda   -1,x
        ldx   #Tbl_SSShadow_Side
        ldd   a,x
        std   image_set,u
        jmp   DisplaySprite                                                                               
                                                                          *    bra.s   loc_35392
                                                                          *; ===========================================================================
                                                                          *
loc_35380                                                                 *loc_35380:
                                                                          *    add.w   d1,d0
                                                                          *    move.w  #make_art_tile(ArtTile_ArtNem_SpecialDiagShadow,3,0),art_tile(a0)
        ldx   image_set,x
        lda   -1,x
        ldx   #Tbl_SSShadow_Diag
        ldd   a,x
        std   image_set,u
        jmp   DisplaySprite                                                                                          
                                                                          *    bra.s   loc_35392
                                                                          *; ===========================================================================
                                                                          *
loc_3538A                                                                 *loc_3538A:
                                                                          *    add.w   d1,d0
                                                                          *    move.w  #make_art_tile(ArtTile_ArtNem_SpecialFlatShadow,3,0),art_tile(a0)
        ldx   image_set,x
        lda   -1,x
        ldx   #Tbl_SSShadow_Flat
        ldd   a,x
        std   image_set,u  
        jmp   DisplaySprite                                                                                        
                                                                          *
loc_35392                                                                 *loc_35392:
                                                                          *    move.b  d0,mapping_frame(a0)
                                                                          *    bra.w   JmpTo44_DisplaySprite
        
Tbl_SSShadow_Flat
        fdb   Img_SSShadow_000
        fdb   Img_SSShadow_003
        fdb   Img_SSShadow_006
        fdb   Img_SSShadow_009
        fdb   Img_SSShadow_012
        fdb   Img_SSShadow_015
        fdb   Img_SSShadow_018
        fdb   Img_SSShadow_021
        fdb   Img_SSShadow_024
        fdb   Img_SSShadow_027

Tbl_SSShadow_Diag
        fdb   Img_SSShadow_001
        fdb   Img_SSShadow_004
        fdb   Img_SSShadow_007
        fdb   Img_SSShadow_010
        fdb   Img_SSShadow_013
        fdb   Img_SSShadow_016
        fdb   Img_SSShadow_019
        fdb   Img_SSShadow_022
        fdb   Img_SSShadow_025
        fdb   Img_SSShadow_028

Tbl_SSShadow_Side
        fdb   Img_SSShadow_002
        fdb   Img_SSShadow_005
        fdb   Img_SSShadow_008
        fdb   Img_SSShadow_011
        fdb   Img_SSShadow_014
        fdb   Img_SSShadow_017
        fdb   Img_SSShadow_020
        fdb   Img_SSShadow_023
        fdb   Img_SSShadow_026
        fdb   Img_SSShadow_029        
        
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
													                      
Sine_Data                                                                 *Sine_Data:      BINCLUDE        "misc/sinewave.bin"
        INCLUDEBIN "./Engine/Math/sinewave.bin"                                 

        ; -------------------------------------------------------------------------------------------------------------        
        ; Sinus/Cosinus
        ; -------------------------------------------------------------------------------------------------------------             
        ;
        ; 0000 0006 000c ... 00ff 0100 00ff ... 0006 0000 fffa ... ff01 ff00 ff01 ... fffa 0000 0006 ... 00ff
        ; |______________________________________________________________________________|
        ;  sin values from index $0000 to index $01ff, value range: $ff00 (-256) to $0100 (256) 
        ;                         |_________________________________________________________________________|
        ;                          cos values from index $0080 to index $027f, value range: $ff00 (-256) to $0100 (256)
        ;
        ; -------------------------------------------------------------------------------------------------------------
        
SpecialPerspective
        INCLUDEBIN "./GameMode/SpecialStage/Special stage object perspective data.bin" 

        ; -------------------------------------------------------------------------------------------------------------
        ; Perspective data
        ; -------------------------------------------------------------------------------------------------------------
        ;        
        ; Index (words)
        ; -----
        ; Offset to each halfpipe image perspective data (56 word offsets for the 56 images)
        ;
        ; Image perspective data
        ; ----------------------      
        ;  1 word : n number of z_pos defined for this frame from 1 (camera front) to n (far away)
        ;  n groups of 6 bytes : 7b dd b8 e6 00 00   that defines an elipse arc
        ;                        |  |  |  |  |  |___ angle min (excl.) of visible area (0: no invisible area)
        ;                        |  |  |  |  |______ angle max (incl.) of visible area
        ;                        |  |  |  |_________ y radius
        ;                        |  |  |____________ x radius
        ;                        |  |_______________ y origin
        ;                        |__________________ x origin
        ;
        ; -------------------------------------------------------------------------------------------------------------    
