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
instance equ $1E (numero d'instance du sous objet, w dans code 68k, b dans le code 6809)

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
        lda   #3
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