; ---------------------------------------------------------------------------
; Object - ShellcrakerClaw (crab badnik) from MTZ
;
; input REG : [u] pointeur sur l'objet (SST)
; ---------------------------------------------------------------------------

* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------
delay    equ $1A ; and $1B (nombre de frames+1)
parent   equ $1C ; and $1D (adresse OST de l'objet parent)
instance equ $1E (numero d'instance du sous objet, w dans code 68k, b dans le code 6809)

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
        lda   #ObjID_Shellcracker
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
        lda   #ObjID_ShellcrackerClaw
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