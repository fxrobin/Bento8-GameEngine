; ---------------------------------------------------------------------------
; Object - Shellcraker (crab badnik) from MTZ
;
; input REG : [u] pointeur sur l'objet (SST)
; ---------------------------------------------------------------------------

* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------
delay    equ $1A ; and $1B (nombre de frames+1)
parent   equ $1C ; and $1D (adresse OST de l'objet parent)
instance equ $1E (num�ro d'instance du sous objet, w dans code 68k, b dans le code 6809)

                                       *; ===========================================================================
                                       *; ----------------------------------------------------------------------------
                                       *; Object 9F - Shellcraker (crab badnik) from MTZ
                                       *; ----------------------------------------------------------------------------
                                       *; Sprite_3800C:
Shellcracker                           *Obj9F:
                                       *    moveq   #0,d0
        lda   routine,u                *    move.b  routine(a0),d0
        ldx   Shellcracker_Routines    *    move.w  Obj9F_Index(pc,d0.w),d1
        jmp   [a,x]                    *    jmp Obj9F_Index(pc,d1.w)
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
        ldd   #$180A                   *    bsr.w   LoadSubObject ; insertion du code �quivalent � LoadSubObject ici
        sta   width_pixels,u
        stb   collision_flags,u
        lda   #$04                   
        ora   render_flags,u
        sta   render_flags,u
        ldd   #priority_5
        std   priority,u
        inc   routine,u
        inc   routine,u                *    ; fin LoadSubObject
        bita  #render_xmirror_mask     *    btst    #0,render_flags(a0)
        beq   Shellcracker_Init_01     *    beq.s   +
        lda   status,u
        ora   #status_leftfacing_mask
        sta   status,u                 *    bset    #0,status(a0)
Shellcracker_Init_01                   *+
        ldd   #-$0040
        std   x_vel,u                  *    move.w  #-$40,u_vel(a0)
        ldd   #$0C18
        sta   y_radius,u               *    move.b  #$C,x_radius(a0)
        stb   x_radius,u               *    move.b  #$18,u_radius(a0)
        ldd   #$0140
        std   delay,u                  *    move.w  #$140,objoff_2A(a0)
        rts                            *    rts
                                       *; ===========================================================================
                                       *
Shellcracker_Walk                      *loc_3804E:
        lbsr   Obj_GetOrientationToPlayer
                                       *    bsr.w   Obj_GetOrientationToPlayer
        tst   gotp_player_is_left      *    tst.w   d0
        beq   Shellcracker_Walk_01     *    beq.s   loc_3805E
        lda   render_flags,u
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
        * Impl�mentation               *    blt.s   loc_38096
        * Terrain                      *    cmpi.w  #$C,d1
        *                              *    bge.s   loc_38096
        *                              *    add.w   d1,x_pos(a0)
        ldd   delay,u
        subd  #$0001
        std   delay,u                  *    subq.w  #1,objoff_2A(a0)
        bmi   Shellcracker_Walk_04     *    bmi.s   loc_3809A
        ldx   Ani_Shellcracker         *    lea (Ani_obj9F).l,a1
        jsr   AnimateSprite            *    jsrto   (AnimateSprite).l, JmpTo25_AnimateSprite
        jmp   MarkObjGone              *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                       *; ===========================================================================
                                       *
Shellcracker_Walk_03                   *loc_38096:
        ldd   x_vel,u
        coma
        comb
        addd  #$0001
        std   x_vel,u                  *    neg.w   x_vel(a0)
                                       *
Shellcracker_Walk_04                   *loc_3809A:
        inc   routine,u
        inc   routine,u                *    addq.b  #2,routine(a0)
        ldd   #$003B
        sta   mapping_frame,u          *    move.b  #0,mapping_frame(a0)
        std   delay,u                  *    move.w  #$3B,objoff_2A(a0)
        jmp   MarkObjGone              *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                       *; ===========================================================================
                                       *
Shellcracker_Walk_05                   *loc_380AE:
        lda   #$06
        sta   routine,u                *    move.b  #6,routine(a0)
        ldd   #$0008
        sta   mapping_frame,u          *    move.b  #0,mapping_frame(a0)
        std   delay,u                  *    move.w  #8,objoff_2A(a0)
        jmp   MarkObjGone              *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                       *; ===========================================================================
                                       *
Shellcracker_Pause                     *loc_380C4:
        tst   render_flags,u           *    tst.b   render_flags(a0)
        bpl   Shellcracker_Pause_02    *    bpl.s   loc_380E4
        lbsr   Obj_GetOrientationToPlayer
                                       *    bsr.w   Obj_GetOrientationToPlayer
        tst   gotp_player_is_left      *    tst.w   d0
        beq   Shellcracker_Pause_01    *    beq.s   loc_380DA
        lda   render_flags,u
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
        ldd   delay,u
        subd  #$0001
        std   delay,u                  *    subq.w  #1,objoff_2A(a0)
        bmi   Shellcracker_Pause_03    *    bmi.s   loc_380EE
        jmp   MarkObjGone              *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                       *; ===========================================================================
                                       *
Shellcracker_Pause_03                  *loc_380EE:
        dec   routine,u
        dec   routine,u                *    subq.b  #2,routine(a0)
        ldd   #$0140
        std   delay,u                  *    move.w  #$140,objoff_2A(a0)
        jmp   MarkObjGone              *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                       *; ===========================================================================
                                       *
Shellcracker_Punch                     *loc_380FC:
                                       *    moveq   #0,d0
        lda   routine_secondary,u      *    move.b  routine_secondary(a0),d0
        ldx   Shellcracker_SubRoutines *    move.w  off_3810E(pc,d0.w),d1
        jsr   [a,x]                    *    jsr off_3810E(pc,d1.w)
        jmp   MarkObjGone              *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                       *; ===========================================================================
Shellcracker_SubRoutines               *off_3810E:  offsetTable
        fdb   Shellcracker_Punch_Init  *        offsetTableEntry.w loc_38114    ; 0
        fdb   Shellcracker_Punch_Wait  *        offsetTableEntry.w loc_3812A    ; 2
        fdb   Shellcracker_Punch_End   *        offsetTableEntry.w loc_3813E    ; 4
                                       *; ===========================================================================
                                       *
Shellcracker_Punch_Init                *loc_38114:
        ldd   delay,u
        subd  #$01
        std   delay,u                  *    subq.w  #1,objoff_2A(a0)
        bmi                            *    bmi.s   loc_3811C
        rts                            *    rts
                                       *; ===========================================================================
                                       *
Shellcracker_Punch_Init_01             *loc_3811C:
        inc   routine_secondary,u
        inc   routine_secondary,u      *    addq.b  #2,routine_secondary(a0)
        lda   #$03
        sta   mapping_frame,u          *    move.b  #3,mapping_frame(a0)
        lbra   ShellcrackerClaw_instantiate
                                       *    bra.w   loc_38292
                                       *; ===========================================================================
                                       *
Shellcracker_Punch_Wait                *loc_3812A:
        tst   parent,u                 *    tst.b   objoff_2C(a0)
        bne   Shellcracker_Punch_Wait_01
                                       *    bne.s   loc_38132
        rts                            *    rts
                                       *; ===========================================================================
                                       *
Shellcracker_Punch_Wait_01             *loc_38132:
        inc   routine_secondary,u
        inc   routine_secondary,u      *    addq.b  #2,routine_secondary(a0)
        ldd   #$0020
        std   delay,u                  *    move.w  #$20,objoff_2A(a0)
        rts                            *    rts
                                       *; ===========================================================================
                                       *
Shellcracker_Punch_End                 *loc_3813E:
        ldd   delay,u
        subd  #$01
        std   delay,u                  *    subq.w  #1,objoff_2A(a0)
        bmi   Shellcracker_Punch_End_01
                                       *    bmi.s   loc_38146
        rts                            *    rts
                                       *; ===========================================================================
                                       *
Shellcracker_Punch_End_01              *loc_38146:
        lda   #$0002
        sta   routine_secondary,u      *    clr.b   routine_secondary(a0)
        sta   parent,u                 *    clr.b   objoff_2C(a0)
        stb   routine,u                *    move.b  #2,routine(a0)
        ldd   #$0140
        std   delay,u                  *    move.w  #$140,objoff_2A(a0)
        rts                            *    rts
                                       *; ===========================================================================
                                       *; ----------------------------------------------------------------------------
                                       *; Object A0 - Shellcracker's claw from MTZ
                                       *; ----------------------------------------------------------------------------
                                       *; Sprite_3815C:
ShellcrackerClaw                       *ObjA0:
                                       *    moveq   #0,d0
        lda   routine,u                *    move.b  routine(a0),d0
        ldx   ShellcrackerClaw_Routines
                                       *    move.w  ObjA0_Index(pc,d0.w),d1
        jmp   [a,x]                    *    jmp ObjA0_Index(pc,d1.w)
                                       *; ===========================================================================
                                       *; off_3816A:
ShellcrackerClaw_Routines              *ObjA0_Index:    offsetTable
        fdb   ShellcrackerClaw_Init    *        offsetTableEntry.w ObjA0_Init   ; 0
        fdb   ShellcrackerClaw_Type    *        offsetTableEntry.w loc_381AC    ; 2
        fdb   ShellcrackerClaw_Proj    *        offsetTableEntry.w loc_38280    ; 4
                                       *; ===========================================================================
                                       *; loc_38170:
ShellcrackerClaw_Init                  *ObjA0_Init:
        ldd   #$0C9A                   *    bsr.w   LoadSubObject ; insertion du code �quivalent � LoadSubObject ici
        sta   width_pixels,u
        stb   collision_flags,u
        lda   #$04                   
        ora   render_flags,u
        sta   render_flags,u
        ldd   #priority_4
        std   priority,u
        inc   routine,u
        inc   routine,u                *    ; fin LoadSubObject
        ldx   parent,u                 *    movea.w objoff_2C(a0),a1 ; a1=object                               
        lda   render_flags,x           *    move.b  render_flags(a1),d0
        anda  #$01                     *    andi.b  #1,d0
        ora   render_flags,u           *    or.b    d0,render_flags(a0)
        sta   render_flags,u
        lda   instance,u               *    move.w  objoff_2E(a0),d0
        beq   ShellcrackerClaw_Init_01 *    beq.s   loc_38198
        lda   #$04
        sta   mapping_frame,u          *    move.b  #4,mapping_frame(a0)
        ldd   x_pos,u
        addd  #$0006
        std   x_pos,u                  *    addq.w  #6,u_pos(a0)
        ldd   y_pos,u
        addd  #$0006
        std   y_pos,u                  *    addq.w  #6,x_pos(a0)
        lda   instance,u               *
ShellcrackerClaw_Init_01               *loc_38198:
        lsra                           *    lsr.w   #1,d0
        ldx   Cal_ShellcrackerClaw_Extend
        ldb   a,x                    
        stb   delay,u                  *    move.b  byte_381A4(pc,d0.w),objoff_2A(a0)
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
        ldx   parent,u                 *    movea.w objoff_2C(a0),a1 ; a1=object
        lda   #Shellcracker_id
        cmpa  id,x                     *    cmpi.b  #ObjID_Shellcracker,id(a1)
        bne   ShellcrackerClaw_Projectile
                                       *    bne.s   loc_381D0
                                       *    moveq   #0,d0
        lda   routine_secondary,u      *    move.b  routine_secondary(a0),d0
        ldx   ShellcrackerClaw_SubRoutines
                                       *    move.w  off_381C8(pc,d0.w),d1
        jsr   [a,x]                    *    jsr off_381C8(pc,d1.w)
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
        sta   routine,u                *    move.b  #4,routine(a0)
        ldd   #$0040
        std   delay,u                  *    move.w  #$40,objoff_2A(a0)
        jmp   MarkObjGone              *    jmpto   (MarkObjGone).l, JmpTo39_MarkObjGone
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_ExtInit               *loc_381E0:
        dec   delay,u                  *    subq.b  #1,objoff_2A(a0)
        beq   ShellcrackerClaw_ExtInit_01
                                       *    beq.s   loc_381EA
                                       *    bmi.s   loc_381EA
        rts                            *    rts
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_ExtInit_01            *loc_381EA:
        inc   routine_secondary,u
        inc   routine_secondary,u      *    addq.b  #2,routine_secondary(a0)
        lda   instance,u               *    move.w  objoff_2E(a0),d0
        cmpa  #$0E                     *    cmpi.w  #$E,d0
        bhs   ShellcrackerClaw_ExtInit_03
                                       *    bhs.s   loc_3821A
        ldx   #-$0400                  *    move.w  #-$400,d2
        ldb   render_flags,u
        bitb  #render_xmirror_mask     *    btst    #0,render_flags(a0)
        beq   ShellcrackerClaw_ExtInit_02
                                       *    beq.s   loc_38206
        ldx   #$0400                   *    neg.w   d2
                                       *
ShellcrackerClaw_ExtInit_02            *loc_38206:
        stx   x_vel,u                  *    move.w  d2,u_vel(a0)
        lsra                           *    lsr.w   #1,d0
        ldx   Cal_ShellcrackerClaw_Retract
        ldb   a,x                      *    move.b  byte_38222(pc,d0.w),d1
        stb   delay                    *    move.b  d1,objoff_2A(a0)
        stb   delay+1                  *    move.b  d1,objoff_2B(a0)
        rts                            *    rts
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_ExtInit_03            *loc_3821A:
        ldd   #$000B
        std   delay,u                  *    move.w  #$B,objoff_2A(a0)
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
        dec   delay,u                  *    subq.b  #1,objoff_2A(a0)
        beq   ShellcrackerClaw_Extend_01
                                       *    beq.s   loc_38238
                                       *    bmi.s   loc_38238
        rts                            *    rts
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_Extend_01             *loc_38238:
        inc   routine_secondary,u
        inc   routine_secondary,u      *    addq.b  #2,routine_secondary(a0)
        lda   #$08
        sta   delay,u                  *    move.b  #8,objoff_2A(a0)
        rts                            *    rts
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_RetInit               *loc_38244:
        dec   delay,u                  *    subq.b  #1,objoff_2A(a0)
        beq   ShellcrackerClaw_RetInit_01
                                       *    beq.s   loc_3824E
                                       *    bmi.s   loc_3824E
        rts                            *    rts
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_RetInit_01            *loc_3824E:
        inc   routine_secondary,u
        inc   routine_secondary,u      *    addq.b  #2,routine_secondary(a0)
        ldd   x_vel,u
        coma
        comb
        addd  #$0001
        std   x_vel,u                  *    neg.w   x_vel(a0)
        rts                            *    rts
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_Retract               *loc_38258:
        jsr   ObjectMove               *    jsrto   (ObjectMove).l, JmpTo26_ObjectMove
        dec   delay+1,u                *    subq.b  #1,objoff_2B(a0)
        beq   ShellcrackerClaw_Retract_01
                                       *    beq.s   loc_38266
                                       *    bmi.s   loc_38266
        rts                            *    rts
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_Retract_01            *loc_38266:
        tst   instance,u               *    tst.w   objoff_2E(a0)
        bne   ShellcrackerClaw_Retract_02
                                       *    bne.s   loc_3827A
        ldx   parent,u                 *    movea.w objoff_2C(a0),a1 ; a1=object
        clr   mapping_frame,x          *    move.b  #0,mapping_frame(a1)
        lda   #$FF
        sta   parent,x                 *    st  objoff_2C(a1)
                                       *
ShellcrackerClaw_Retract_02            *loc_3827A:
        leas  2,s                      *    addq.w  #4,sp ; evite un double rts
        jmp   MarkObjToBeDeleted       *    bra.w   JmpTo65_DeleteObject
                                       *; ===========================================================================
                                       *
ShellcrackerClaw_Proj                  *loc_38280:
        jsr   ObjectMove               *    jsrto   (ObjectMoveAndFall).l, JmpTo8_ObjectMoveAndFall
        ldd   y_vel,u                  ; ce code compl�te ObjectMove pour faire l'�quivalent de ObjectMoveAndFall
        addd  gravity                  ; ...
        std   y_vel,u                  ; fin
        ldd   delay,u
        subd  #$0001
        std   delay,u                  *    subq.w  #1,objoff_2A(a0)
        bmi   MarkObjToBeDeleted       *    bmi.w   JmpTo65_DeleteObject
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
        lbeq  ShellcrackerClaw_instantiate_04
                                       *    bne.s   return_382EE       
        lda   #ShellcrackerClaw_id
        sta   ,x                       *    _move.b #ObjID_ShellcrackerClaw,id(a1) ; load objA0
        ldd   #$2605
        sta   subtype,x                *    move.b  #$26,subtype(a1) ; <== ObjA0_SubObjData
        stb   mapping_frame,x          *    move.b  #5,mapping_frame(a1)
am_ShellcrackerClaw_instantiate_01        
        ldd   #$0400
        sta   priority,x               *    move.b  #4,priority(a1)
        stx   parent,x                 *    move.w  a0,objoff_2C(a1)
        stb   instance,x               *    move.w  d1,objoff_2E(a1)
                                       *    move.w  x_pos(a0),u_pos(a1)
                                       *    move.w  #-$14,d2
        lda   render_flags,u
        bita  #render_xmirror_mask     *    btst    #0,render_flags(a0)
        beq   ShellcrackerClaw_instantiate_02
                                       *    beq.s   loc_382D8
        ldd   x_pos,u
        addd  #$0014                   *    neg.w   d2
        tst   instance,x               *    tst.w   d1
        beq   ShellcrackerClaw_instantiate_03
                                       *    beq.s   loc_382D8
        subd  #$000C                   *    subi.w  #$C,d2
        bra   ShellcrackerClaw_instantiate_03
                                       *
ShellcrackerClaw_instantiate_02
        ldd   x_pos,u
        subd  #$0014                          

ShellcrackerClaw_instantiate_03        *loc_382D8: 
        std   x_pos,x                  *    add.w   d2,u_pos(a1)           
        ldd   y_pos,u
        subd  #$0008                   *    move.w  y_pos(a0),x_pos(a1)
        std   y_pos,x                  *    subi_.w #8,x_pos(a1)
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