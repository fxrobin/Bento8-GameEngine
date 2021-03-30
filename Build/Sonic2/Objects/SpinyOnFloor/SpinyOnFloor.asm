; ---------------------------------------------------------------------------
; Object - Spiny on floor
;
; input REG : [u] pointer to Object Status Table (OST)
; ---------
;
; ---------------------------------------------------------------------------
        
                                                      *; ===========================================================================
                                                      *; ----------------------------------------------------------------------------
                                                      *; Object A5 - Spiny (crawling badnik) from CPZ
                                                      *; ----------------------------------------------------------------------------
                                                      *; Sprite_38AEA:
                                                      *ObjA5:
                                                      *    moveq   #0,d0
                                                      *    move.b  routine(a0),d0
                                                      *    move.w  ObjA5_Index(pc,d0.w),d1
                                                      *    jmp ObjA5_Index(pc,d1.w)
                                                      *; ===========================================================================
                                                      *; off_38AF8:
                                                      *ObjA5_Index:    offsetTable
                                                      *        offsetTableEntry.w ObjA5_Init   ; 0
                                                      *        offsetTableEntry.w loc_38B10    ; 2
                                                      *        offsetTableEntry.w loc_38B62    ; 4
                                                      *; ===========================================================================
                                                      *; loc_38AFE:
                                                      *ObjA5_Init:
                                                      *    bsr.w   LoadSubObject
                                                      *    move.w  #-$40,x_vel(a0)
                                                      *    move.w  #$80,objoff_2A(a0)
                                                      *    rts
                                                      *; ===========================================================================
                                                      *
                                                      *loc_38B10:
                                                      *    tst.b   objoff_2B(a0)
                                                      *    beq.s   loc_38B1E
                                                      *    subq.b  #1,objoff_2B(a0)
                                                      *    bra.w   loc_38B2C
                                                      *; ===========================================================================
                                                      *
                                                      *loc_38B1E:
                                                      *    bsr.w   Obj_GetOrientationToPlayer
                                                      *    addi.w  #$60,d2
                                                      *    cmpi.w  #$C0,d2
                                                      *    blo.s   loc_38B4E
                                                      *
                                                      *loc_38B2C:
                                                      *    subq.b  #1,objoff_2A(a0)
                                                      *    bne.s   loc_38B3C
                                                      *    move.w  #$80,objoff_2A(a0)
                                                      *    neg.w   x_vel(a0)
                                                      *
                                                      *loc_38B3C:
                                                      *    jsrto   (ObjectMove).l, JmpTo26_ObjectMove
                                                      *    lea (Ani_objA5).l,a1
                                                      *    jsrto   (AnimateSprite).l, JmpTo25_AnimateSprite
                                                      *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                                      *; ===========================================================================
                                                      *
                                                      *loc_38B4E:
                                                      *    addq.b  #2,routine(a0)
                                                      *    move.b  #$28,objoff_2B(a0)
                                                      *    move.b  #2,mapping_frame(a0)
                                                      *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                                      *; ===========================================================================
                                                      *
                                                      *loc_38B62:
                                                      *    subq.b  #1,objoff_2B(a0)
                                                      *    bmi.s   loc_38B78
                                                      *    cmpi.b  #$14,objoff_2B(a0)
                                                      *    bne.s   +
                                                      *    bsr.w   loc_38C22
                                                      *+
                                                      *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                                      *; ===========================================================================
                                                      *
                                                      *loc_38B78:
                                                      *    subq.b  #2,routine(a0)
                                                      *    move.b  #$40,objoff_2B(a0)
                                                      *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone