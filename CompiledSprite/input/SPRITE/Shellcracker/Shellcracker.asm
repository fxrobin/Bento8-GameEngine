; ---------------------------------------------------------------------------
; Object - Shellcraker (crab badnik) from MTZ
;
; input REG : [x] pointeur sur l'objet 
; ---------------------------------------------------------------------------

(main)MAIN
	ORG $0000

	INCLUD Constant

ObjID_Shellcracker     equ $02
ObjID_ShellcrackerClaw equ $03

* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------
delay    equ $1A ; and $1B (nombre de frames+1)
parent   equ $1C ; and $1D (adresse OST de l'objet parent)
instance equ $1E (numéro d'instance du sous objet, w dans code 68k, b dans le code 6809)

                                       *; ===========================================================================
                                       *; ----------------------------------------------------------------------------
                                       *; Object 9F - Shellcraker (crab badnik) from MTZ
                                       *; ----------------------------------------------------------------------------
                                       *; Sprite_3800C:
Shellcracker                           *Obj9F:
                                       *    moveq   #0,d0
        lda   routine,x                *    move.b  routine(a0),d0
        ldy   Shellcracker_Routines    *    move.w  Obj9F_Index(pc,d0.w),d1
        jmp   [a,y]                    *    jmp Obj9F_Index(pc,d1.w)
                                       *; ===========================================================================
                                       *; off_3801A:
Shellcracker_Routines                  *Obj9F_Index:    offsetTable
        fdb   Shellcracker_Init        *        offsetTableEntry.w Obj9F_Init   ; 0
        fdb   Shellcracker_Walk        *        offsetTableEntry.w loc_3804E    ; 2
        fdb   Shellcracker_Pause       *        offsetTableEntry.w loc_380C4    ; 4
        fdb   Shellcracker_Punch       *        offsetTableEntry.w loc_380FC    ; 6
                                       *; ===========================================================================
                                       *; loc_38022:
Shellcracker_Init                      *Obj9F_Init:
        ldd   #$180A                   *    bsr.w   LoadSubObject ; insertion du code équivalent à LoadSubObject ici
        sta   width_pixels,x
        stb   collision_flags,x
        ldd   #$0405                   
        ora   render_flags,x
        sta   render_flags,x
        stb   priority,x
        inc   routine,x
        inc   routine,x                *    ; fin LoadSubObject
        bita  #render_xmirror_mask     *    btst    #0,render_flags(a0)
        beq   Shellcracker_Init_01     *    beq.s   +
        lda   status,x
        ora   #status_leftfacing_mask
        sta   status,x                 *    bset    #0,status(a0)
Shellcracker_Init_01                   *+
        ldd   #-$0040
        std   x_vel,x                  *    move.w  #-$40,x_vel(a0)
        ldd   #$0C18
        sta   y_radius,x               *    move.b  #$C,y_radius(a0)
        stb   x_radius,x               *    move.b  #$18,x_radius(a0)
        ldd   #$0140
        std   delay,x                  *    move.w  #$140,objoff_2A(a0)
        rts                            *    rts
                                       *; ===========================================================================
                                       *
Shellcracker_Walk                      *loc_3804E:
        lbsr   Obj_GetOrientationToPlayer
                                       *    bsr.w   Obj_GetOrientationToPlayer
        tst   gotp_player_is_left      *    tst.w   d0
        beq   Shellcracker_Walk_01     *    beq.s   loc_3805E
        lda   render_flags,x
        bita  #render_xmirror_mask     *    btst    #0,render_flags(a0)
        beq   Shellcracker_Walk_02     *    beq.s   loc_38068
                                       *
Shellcracker_Walk_01                   *loc_3805E:
        ldd   gotp_player_h_distance   
        addd  #$0060                   *    addi.w  #$60,d2
        cmpd  #$00C0                   *    cmpi.w  #$C0,d2
        blo   Shellcracker_Walk_05     *    blo.s   loc_380AE
                                       *
Shellcracker_Walk_02                   *loc_38068:
        jsr   ObjectMove               *    jsrto   (ObjectMove).l, JmpTo26_ObjectMove
        *                              *    jsr (ObjCheckFloorDist).l
        * Attente                      *    cmpi.w  #-8,d1
        * Implémentation               *    blt.s   loc_38096
        * Terrain                      *    cmpi.w  #$C,d1
        *                              *    bge.s   loc_38096
        *                              *    add.w   d1,y_pos(a0)
        ldd   delay,x
        subd  #$0001
        std   delay,x                  *    subq.w  #1,objoff_2A(a0)
        bmi   Shellcracker_Walk_04     *    bmi.s   loc_3809A
        ldy   Ani_Shellcracker         *    lea (Ani_obj9F).l,a1
        jsr   AnimateSprite            *    jsrto   (AnimateSprite).l, JmpTo25_AnimateSprite
        jmp   MarkObjGone              *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                       *; ===========================================================================
                                       *
Shellcracker_Walk_03                   *loc_38096:
        ldd   x_vel,x
        coma
        comb
        addd  #$0001
        std   x_vel,x                  *    neg.w   x_vel(a0)
                                       *
Shellcracker_Walk_04                   *loc_3809A:
        inc   routine,x
        inc   routine,x                *    addq.b  #2,routine(a0)
        ldd   #$003B
        sta   mapping_frame,x          *    move.b  #0,mapping_frame(a0)
        std   delay,x                  *    move.w  #$3B,objoff_2A(a0)
        jmp   MarkObjGone              *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                       *; ===========================================================================
                                       *
Shellcracker_Walk_05                   *loc_380AE:
        lda   #$06
        sta   routine,x                *    move.b  #6,routine(a0)
        ldd   #$0008
        sta   mapping_frame,x          *    move.b  #0,mapping_frame(a0)
        std   delay,x                  *    move.w  #8,objoff_2A(a0)
        jmp   MarkObjGone              *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                       *; ===========================================================================
                                       *
Shellcracker_Pause                     *loc_380C4:
        tst   render_flags,x           *    tst.b   render_flags(a0)
        bpl   Shellcracker_Pause_02    *    bpl.s   loc_380E4
        lbsr   Obj_GetOrientationToPlayer
                                       *    bsr.w   Obj_GetOrientationToPlayer
        tst   gotp_player_is_left      *    tst.w   d0
        beq   Shellcracker_Pause_01    *    beq.s   loc_380DA
        lda   render_flags,x
        bita  #render_xmirror_mask     *    btst    #0,render_flags(a0)
        beq   Shellcracker_Pause_02    *    beq.s   loc_380E4
                                       *
Shellcracker_Pause_01                  *loc_380DA:
        ldd   gotp_player_h_distance   
        addd  #$0060                   *    addi.w  #$60,d2
        cmpd  #$00C0                   *    cmpi.w  #$C0,d2
        blo   Shellcracker_Walk_05     *    blo.s   loc_380AE
                                       *
Shellcracker_Pause_02                  *loc_380E4:
        ldd   delay,x
        subd  #$0001
        std   delay,x                  *    subq.w  #1,objoff_2A(a0)
        bmi   Shellcracker_Pause_03    *    bmi.s   loc_380EE
        jmp   MarkObjGone              *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                       *; ===========================================================================
                                       *
Shellcracker_Pause_03                  *loc_380EE:
        dec   routine,x
        dec   routine,x                *    subq.b  #2,routine(a0)
        ldd   #$0140
        std   delay,x                  *    move.w  #$140,objoff_2A(a0)
        jmp   MarkObjGone              *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                       *; ===========================================================================
                                       *
Shellcracker_Punch                     *loc_380FC:
                                       *    moveq   #0,d0
        lda   routine_secondary,x      *    move.b  routine_secondary(a0),d0
        ldy   Shellcracker_SubRoutines *    move.w  off_3810E(pc,d0.w),d1
        jsr   [a,y]                    *    jsr off_3810E(pc,d1.w)
        jmp   MarkObjGone              *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                       *; ===========================================================================
Shellcracker_SubRoutines               *off_3810E:  offsetTable
        fdb   Shellcracker_Punch_Init  *        offsetTableEntry.w loc_38114    ; 0
        fdb   Shellcracker_Punch_Wait  *        offsetTableEntry.w loc_3812A    ; 2
        fdb   Shellcracker_Punch_End   *        offsetTableEntry.w loc_3813E    ; 4
                                       *; ===========================================================================
                                       *
Shellcracker_Punch_Init                *loc_38114:
        ldd   delay,x
        subd  #$01
        std   delay,x                  *    subq.w  #1,objoff_2A(a0)
        bmi                            *    bmi.s   loc_3811C
        rts                            *    rts
                                       *; ===========================================================================
                                       *
Shellcracker_Punch_Init_01             *loc_3811C:
        inc   routine_secondary,x
        inc   routine_secondary,x      *    addq.b  #2,routine_secondary(a0)
        lda   #$03
        sta   mapping_frame,x          *    move.b  #3,mapping_frame(a0)
        lbra   ShellcrackerClaw_instantiate
                                       *    bra.w   loc_38292
                                       *; ===========================================================================
                                       *
Shellcracker_Punch_Wait                *loc_3812A:
        tst   parent,x                 *    tst.b   objoff_2C(a0)
        bne   Shellcracker_Punch_Wait_01
                                       *    bne.s   loc_38132
        rts                            *    rts
                                       *; ===========================================================================
                                       *
Shellcracker_Punch_Wait_01             *loc_38132:
        inc   routine_secondary,x
        inc   routine_secondary,x      *    addq.b  #2,routine_secondary(a0)
        ldd   #$0020
        std   delay,x                  *    move.w  #$20,objoff_2A(a0)
        rts                            *    rts
                                       *; ===========================================================================
                                       *
Shellcracker_Punch_End                 *loc_3813E:
        ldd   delay,x
        subd  #$01
        std   delay,x                  *    subq.w  #1,objoff_2A(a0)
        bmi   Shellcracker_Punch_End_01
                                       *    bmi.s   loc_38146
        rts                            *    rts
                                       *; ===========================================================================
                                       *
Shellcracker_Punch_End_01              *loc_38146:
        lda   #$0002
        sta   routine_secondary,x      *    clr.b   routine_secondary(a0)
        sta   parent,x                 *    clr.b   objoff_2C(a0)
        stb   routine,x                *    move.b  #2,routine(a0)
        ldd   #$0140
        std   delay,x                  *    move.w  #$140,objoff_2A(a0)
        rts                            *    rts
                                       *; ===========================================================================
                                       *; ----------------------------------------------------------------------------
                                       *; Object A0 - Shellcracker's claw from MTZ
                                       *; ----------------------------------------------------------------------------
                                       *; Sprite_3815C:
ShellcrackerClaw                       *ObjA0:
                                       *    moveq   #0,d0
        lda   routine,x                *    move.b  routine(a0),d0
        ldy   ShellcrackerClaw_Routines
                                       *    move.w  ObjA0_Index(pc,d0.w),d1
        jmp   [a,y]                    *    jmp ObjA0_Index(pc,d1.w)
                                       *; ===========================================================================
                                       *; off_3816A:
ShellcrackerClaw_Routines              *ObjA0_Index:    offsetTable
        fdb   ShellcrackerClaw_Init    *        offsetTableEntry.w ObjA0_Init   ; 0
        fdb   ShellcrackerClaw_Type    *        offsetTableEntry.w loc_381AC    ; 2
        fdb   ShellcrackerClaw_Proj    *        offsetTableEntry.w loc_38280    ; 4
                                       *; ===========================================================================
                                       *; loc_38170:
ShellcrackerClaw_Init                  *ObjA0_Init:
        ldd   #$0C9A                   *    bsr.w   LoadSubObject ; insertion du code équivalent à LoadSubObject ici
        sta   width_pixels,x
        stb   collision_flags,x
        ldd   #$0404                   
        ora   render_flags,x
        sta   render_flags,x
        stb   priority,x
        inc   routine,x
        inc   routine,x                *    ; fin LoadSubObject
        ldy   parent,x                 *    movea.w objoff_2C(a0),a1 ; a1=object                               
        lda   render_flags,y           *    move.b  render_flags(a1),d0
        anda  #$01                     *    andi.b  #1,d0
        ora   render_flags,x           *    or.b    d0,render_flags(a0)
        sta   render_flags,x
        lda   instance,x               *    move.w  objoff_2E(a0),d0
        beq   ShellcrackerClaw_Init_01 *    beq.s   loc_38198
        lda   #$04
        sta   mapping_frame,x          *    move.b  #4,mapping_frame(a0)
        ldd   x_pos,x
        addd  #$0006
        std   x_pos,x                  *    addq.w  #6,x_pos(a0)
        ldd   y_pos,x
        addd  #$0006
        std   y_pos,x                  *    addq.w  #6,y_pos(a0)
        lda   instance,x               *
ShellcrackerClaw_Init_01               *loc_38198:
        lsra                           *    lsr.w   #1,d0
        ldy   Cal_ShellcrackerClaw_Extend
        ldb   [a,y]                    
        stb   delay,x                  *    move.b  byte_381A4(pc,d0.w),objoff_2A(a0)
        jmp   MarkObjGone              *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                       *; ===========================================================================
Cal_ShellcrackerClaw_Extend            *byte_381A4:
        fcb   $00                      *    dc.b   0    ; 0
        fcb   $03                      *    dc.b   3    ; 1
        fcb   $05                      *    dc.b   5    ; 2
        fcb   $07                      *    dc.b   7    ; 3
        fcb   $09                      *    dc.b   9    ; 4
        fcb   $0B                      *    dc.b  $B    ; 5
        fcb   $0D                      *    dc.b  $D    ; 6
        fcb   $0F                      *    dc.b  $F    ; 7
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_Type                  *loc_381AC:
        ldy   parent,x                 *    movea.w objoff_2C(a0),a1 ; a1=object
        lda   #ObjID_Shellcracker
        cmpa  id,y                     *    cmpi.b  #ObjID_Shellcracker,id(a1)
        bne   ShellcrackerClaw_Projectile
                                       *    bne.s   loc_381D0
                                       *    moveq   #0,d0
        lda   routine_secondary,x      *    move.b  routine_secondary(a0),d0
        ldy   ShellcrackerClaw_SubRoutines
                                       *    move.w  off_381C8(pc,d0.w),d1
        jsr   [a,y]                    *    jsr off_381C8(pc,d1.w)
        jmp   MarkObjGone              *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                       *; ===========================================================================
ShellcrackerClaw_SubRoutines           *off_381C8:  offsetTable
        fdb   ShellcrackerClaw_ExtInit *        offsetTableEntry.w loc_381E0    ; 0
        fdb   ShellcrackerClaw_Extend  *        offsetTableEntry.w loc_3822A    ; 2
        fdb   ShellcrackerClaw_RetInit *        offsetTableEntry.w loc_38244    ; 4
        fdb   ShellcrackerClaw_Retract *        offsetTableEntry.w loc_38258    ; 6
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_Projectile            *loc_381D0:
        lda   #$04
        sta   routine,x                *    move.b  #4,routine(a0)
        ldd   #$0040
        std   delay,x                  *    move.w  #$40,objoff_2A(a0)
        jmp   MarkObjGone              *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_ExtInit               *loc_381E0:
        dec   delay,x                  *    subq.b  #1,objoff_2A(a0)
        beq   ShellcrackerClaw_ExtInit_01
                                       *    beq.s   loc_381EA
                                       *    bmi.s   loc_381EA
        rts                            *    rts
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_ExtInit_01            *loc_381EA:
        inc   routine_secondary,x
        inc   routine_secondary,x      *    addq.b  #2,routine_secondary(a0)
        lda   instance,x               *    move.w  objoff_2E(a0),d0
        cmpa  #$0E                     *    cmpi.w  #$E,d0
        bhs   ShellcrackerClaw_ExtInit_03
                                       *    bhs.s   loc_3821A
        ldy   #-$0400                  *    move.w  #-$400,d2
        ldb   render_flags,x
        bitb  #render_xmirror_mask     *    btst    #0,render_flags(a0)
        beq   ShellcrackerClaw_ExtInit_02
                                       *    beq.s   loc_38206
        ldy   #$0400                   *    neg.w   d2
                                       *
ShellcrackerClaw_ExtInit_02            *loc_38206:
        sty   x_vel,x                  *    move.w  d2,x_vel(a0)
        lsra                           *    lsr.w   #1,d0
        ldy   Cal_ShellcrackerClaw_Retract
        ldb   [a,y]                    *    move.b  byte_38222(pc,d0.w),d1
        stb   delay                    *    move.b  d1,objoff_2A(a0)
        stb   delay+1                  *    move.b  d1,objoff_2B(a0)
        rts                            *    rts
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_ExtInit_03            *loc_3821A:
        ldd   #$000B
        std   delay,x                  *    move.w  #$B,objoff_2A(a0)
        rts                            *    rts
                                       *; ===========================================================================
Cal_ShellcrackerClaw_Retract           *byte_38222:
        fcb   $0D                      *    dc.b  $D    ; 0
        fcb   $0C                      *    dc.b  $C    ; 1
        fcb   $0A                      *    dc.b  $A    ; 2
        fcb   $08                      *    dc.b   8    ; 3
        fcb   $06                      *    dc.b   6    ; 4
        fcb   $04                      *    dc.b   4    ; 5
        fcb   $02                      *    dc.b   2    ; 6
        fcb   $00                      *    dc.b   0    ; 7
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_Extend                *loc_3822A:
        jsr   ObjectMove               *    jsrto   (ObjectMove).l, JmpTo26_ObjectMove
        dec   delay,x                  *    subq.b  #1,objoff_2A(a0)
        beq   ShellcrackerClaw_Extend_01
                                       *    beq.s   loc_38238
                                       *    bmi.s   loc_38238
        rts                            *    rts
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_Extend_01             *loc_38238:
        inc   routine_secondary,x
        inc   routine_secondary,x      *    addq.b  #2,routine_secondary(a0)
        lda   #$08
        sta   delay,x                  *    move.b  #8,objoff_2A(a0)
        rts                            *    rts
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_RetInit               *loc_38244:
        dec   delay,x                  *    subq.b  #1,objoff_2A(a0)
        beq   ShellcrackerClaw_RetInit_01
                                       *    beq.s   loc_3824E
                                       *    bmi.s   loc_3824E
        rts                            *    rts
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_RetInit_01            *loc_3824E:
        inc   routine_secondary,x
        inc   routine_secondary,x      *    addq.b  #2,routine_secondary(a0)
        ldd   x_vel,x
        coma
        comb
        addd  #$0001
        std   x_vel,x                  *    neg.w   x_vel(a0)
        rts                            *    rts
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_Retract               *loc_38258:
        jsr   ObjectMove               *    jsrto   (ObjectMove).l, JmpTo26_ObjectMove
        dec   delay+1,x                *    subq.b  #1,objoff_2B(a0)
        beq   ShellcrackerClaw_Retract_01
                                       *    beq.s   loc_38266
                                       *    bmi.s   loc_38266
        rts                            *    rts
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_Retract_01            *loc_38266:
        tst   instance,x               *    tst.w   objoff_2E(a0)
        bne   ShellcrackerClaw_Retract_02
                                       *    bne.s   loc_3827A
        ldy   parent,x                 *    movea.w objoff_2C(a0),a1 ; a1=object
        clr   mapping_frame,y          *    move.b  #0,mapping_frame(a1)
        lda   #$FF
        sta   parent,y                 *    st  objoff_2C(a1)
                                       *
ShellcrackerClaw_Retract_02            *loc_3827A:
        leas  2,s                      *    addq.w  #4,sp ; evite un double rts
        jmp   DeleteObject             *    bra.w   JmpTo65_DeleteObject
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_Proj                  *loc_38280:
        jsr   ObjectMove               *    jsrto   (ObjectMoveAndFall).l, JmpTo8_ObjectMoveAndFall
        ldd   y_vel,x                  ; ce code complète ObjectMove pour faire l'équivalent de ObjectMoveAndFall
        addd  gravity                  ; ...
        std   y_vel,x                  ; fin
        ldd   delay,x
        subd  #$0001
        std   delay,x                  *    subq.w  #1,objoff_2A(a0)
        jmp   DeleteObject             *    bmi.w   JmpTo65_DeleteObject
        jmp   MarkObjGone              *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                       *; ===========================================================================
                                       *  
ShellcrackerClaw_instantiate           *loc_38292:
        ldd   #$0007                   
        sta   am_ShellcrackerClaw_instantiate_01+2
                                       *    moveq   #0,d1
        stb   am_ShellcrackerClaw_instantiate_02+1
                                       *    moveq   #7,d6
                                       *
ShellcrackerClaw_instantiate_01        *loc_38296:
        jsr   SingleObjLoad2           *    jsrto   (SingleObjLoad2).l, JmpTo25_SingleObjLoad2
        bne   ShellcrackerClaw_instantiate_04
                                       *    bne.s   return_382EE       
        lda   #ObjID_ShellcrackerClaw
        sta   ,y                       *    _move.b #ObjID_ShellcrackerClaw,id(a1) ; load objA0
        ldd   #$2605
        sta   subtype,y                *    move.b  #$26,subtype(a1) ; <== ObjA0_SubObjData
        stb   mapping_frame,y          *    move.b  #5,mapping_frame(a1)
am_ShellcrackerClaw_instantiate_01        
        ldd   #$0400
        sta   priority,y               *    move.b  #4,priority(a1)
        stx   parent,y                 *    move.w  a0,objoff_2C(a1)
        stb   instance,y               *    move.w  d1,objoff_2E(a1)
                                       *    move.w  x_pos(a0),x_pos(a1)
                                       *    move.w  #-$14,d2
        lda   render_flags,x
        bita  #render_xmirror_mask     *    btst    #0,render_flags(a0)
        beq   ShellcrackerClaw_instantiate_02
                                       *    beq.s   loc_382D8
        ldd   x_pos,x
        addd  #$0014                   *    neg.w   d2
        tst   instance,y               *    tst.w   d1
        beq   ShellcrackerClaw_instantiate_03
                                       *    beq.s   loc_382D8
        subd  #$000C                   *    subi.w  #$C,d2
        bra   ShellcrackerClaw_instantiate_03
                                       *
ShellcrackerClaw_instantiate_02
        ldd   x_pos,x
        subd  #$0014                          

ShellcrackerClaw_instantiate_03        *loc_382D8: 
        std   x_pos,y                  *    add.w   d2,x_pos(a1)           
        ldd   y_pos,x
        subd  #$0008                   *    move.w  y_pos(a0),y_pos(a1)
        std   y_pos,y                  *    subi_.w #8,y_pos(a1)
        inc   am_ShellcrackerClaw_instantiate_01+2
        inc   am_ShellcrackerClaw_instantiate_01+2
                                       *    addq.w  #2,d1
am_ShellcrackerClaw_instantiate_02
        lda   #$00
        suba  #$01
        bpl   ShellcrackerClaw_instantiate_01
                                       *    dbf d6,loc_38296
                                       *
ShellcrackerClaw_instantiate_04        *return_382EE:
        rts                            *    rts
                                       *; ===========================================================================
                                       *; off_382F0:
                                       *Obj9F_SubObjData:
                                       *    subObjData Obj9F_MapUnc_38314,make_art_tile(ArtTile_ArtNem_Shellcracker,0,0),4,5,$18,$A ; (00000100) render_flags, priority, width_pixels, collision_flags
                                       *; off_382FA:
                                       *ObjA0_SubObjData:
                                       *    subObjData Obj9F_MapUnc_38314,make_art_tile(ArtTile_ArtNem_Shellcracker,0,0),4,4,$C,$9A ; (00000100) render_flags, priority, width_pixels, collision_flags
                                       *; animation script
                                       *; off_38304:
AniIDShellAni_Walk equ $00
Ani_Shellcracker                       *Ani_obj9F:  offsetTable
        fdb Ani_Shellcracker_Walk      *        offsetTableEntry.w byte_38308   ; 0
                                       *        offsetTableEntry.w byte_3830E   ; 1
Ani_Shellcracker_Walk fcb $0E,$00,$01,$02,$FF
                                       *byte_38308: dc.b  $E,  0,  1,  2,$FF,  0
                                       *byte_3830E: dc.b  $E,  0,  2,  1,$FF
                                       *        even
                                       *; ----------------------------------------------------------------------------
                                       *; sprite mappings
                                       *; ----------------------------------------------------------------------------
                                       *Obj9F_MapUnc_38314: BINCLUDE "mappings/sprite/objA0.bin"
                                       *; ===========================================================================           
                                       
(include)Constant
MainCharacter                 equ $0000
Sidekick                      equ $0000

* ---------------------------------------------------------------------------
* Physics Constants
* ---------------------------------------------------------------------------

gravity                       equ $38 ; Gravité: 56 sub-pixels par frame

* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------

object_size                   equ $1F ; the size of an object
next_object                   equ object_size
			                  
id                            equ $00 ; object ID (00: free slot, 01: Object1, ...)
render_flags                  equ $01 ; bitfield
x_pos                         equ $02 ; and $03 ... some objects use subpixel as well when extra precision is required (see ObjectMove)
x_sub                         equ $04 ; subpixel ; doit suivre x_pos, second octet supprimé car inutile en 6809
y_pos                         equ $05 ; and $06 ... some objects use subpixel as well when extra precision is required
y_sub                         equ $07 ; subpixel ; doit suivre y_pos, second octet supprimé car inutile en 6809
x_pixel                       equ x_pos
y_pixel                       equ x_pos+2
priority                      equ $08 ; 0 equ front
width_pixels                  equ $09
mapping_frame                 equ $0A
x_vel                         equ $0B ; and $0C ; horizontal velocity
y_vel                         equ $0D ; and $0E ; vertical velocity
y_radius                      equ $0F ; collision height / 2
x_radius                      equ $10 ; collision width / 2
anim_frame                    equ $11
anim                          equ $12
prev_anim                     equ $13
anim_frame_duration           equ $14 ; range: 00-7F (0-127)
status                        equ $15 ; note: exact meaning depends on the object...
routine                       equ $16
routine_secondary             equ $17
objoff_01                     equ $18 ; variables spécifiques aux objets
objoff_02                     equ $19
objoff_03                     equ $1A
objoff_04                     equ $1B
objoff_05                     equ $1C
collision_flags               equ $1D
subtype                       equ $1E

* ---------------------------------------------------------------------------
* render_flags bitfield variables
render_xmirror_mask           equ $01 ; bit 0
render_ymirror_mask           equ $02 ; bit 1
render_coordinate_mask        equ $04 ; bit 2
render_7_mask                 equ $08 : bit 3
render_ycheckonscreen_mask    equ $10 : bit 4
render_staticmappings_mask    equ $20 : bit 5
render_subobjects_mask        equ $40 ; bit 6
render_onscreen_mask          equ $80 ; bit 7

* ---------------------------------------------------------------------------
* status bitfield variables
status_leftfacing_mask        equ $01 ; bit 0
status_inair_mask             equ $02 ; bit 1
status_spinning_mask          equ $04 ; bit 2
status_onobject_mask          equ $08 ; bit 3
status_rolljumping_mask       equ $10 ; bit 4
status_pushing_mask           equ $20 ; bit 5
status_underwater_mask        equ $40 ; bit 6
status_7_mask                 equ $80 ; bit 7