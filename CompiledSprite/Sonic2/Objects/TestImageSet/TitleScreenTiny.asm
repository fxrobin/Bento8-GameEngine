(main)TITLESCR
        INCLUD GLOBALS
        INCLUD CONSTANT
        org   $A000

* ---------------------------------------------------------------------------
* Object Status Table offsets
* - two variables can share same space if used by two different subtypes
* - take care of words and bytes and space them accordingly
* ---------------------------------------------------------------------------
w_TitleScr_move_frame_count     equ ext_variables+2
w_TitleScr_xy_data_index        equ ext_variables+4

LargeStar                                        *Obj0E_LargeStar:
                                                 *        moveq   #0,d0
        lda   routine,u                          *        move.b  routine_secondary(a0),d0
        leax  <LargeStar_Routines,pcr            *        move.w  off_13158(pc,d0.w),d1
        jmp   [a,x]                              *        jmp     off_13158(pc,d1.w)
                                                 *; ===========================================================================
LargeStar_Routines                               *off_13158:      offsetTable
        fdb   LargeStar_Init                     *                offsetTableEntry.w Obj0E_LargeStar_Init ; 0
        fdb   TitleScreen_Animate                *                offsetTableEntry.w loc_12F52    ; 2   
        fdb   LargeStar_Wait                     *                offsetTableEntry.w loc_13190    ; 4
        fdb   LargeStar_Move                     *                offsetTableEntry.w loc_1319E    ; 6
                                                 *; ===========================================================================
                                                 *
LargeStar_Init                                   *Obj0E_LargeStar_Init:
        inc   routine,u
        inc   routine,u                          *        addq.b  #2,routine_secondary(a0)
        ldd   #Img_star_2
        std   mapping_frame,u                    *        move.b  #$C,mapping_frame(a0)
        * not implemented                        *        ori.w   #high_priority,art_tile(a0)
        ldd   #Ani_largeStar
        std   anim,u                             *        move.b  #2,anim(a0)
        ldb   #$01
        stb   priority,u                         *        move.b  #1,priority(a0)
        ldd   #$4014
        std   x_pixel,u                          *        move.w  #$100,x_pixel(a0)
                                                 *        move.w  #$A8,y_pixel(a0)
        ldd   #4
        std   w_TitleScr_move_frame_count,u      *        move.w  #4,objoff_2A(a0)
                                                 *        rts
                                                 *; ===========================================================================

TitleScreen_Animate                              *loc_12F52:
        * no more offset table                   *        lea     (Ani_obj0E).l,a1
        jsr   AnimateSprite                      *        bsr.w   AnimateSprite
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================      
        
LargeStar_Wait                                   *loc_13190:
        ldd   w_TitleScr_move_frame_count,u
        subd  #1                                 *        subq.w  #1,objoff_2A(a0)
        std   w_TitleScr_move_frame_count,u
        bmi   LargeStar_AfterWait                *        bmi.s   +
        rts                                      *        rts
                                                 *; ===========================================================================
LargeStar_AfterWait                              *+
        inc   routine,u
        inc   routine,u                          *        addq.b  #2,routine_secondary(a0)
        rts                                      *        rts
                                                 *; ===========================================================================
                                                 *
LargeStar_Move                                   *loc_1319E:
        ldd   #$0200
        sta   routine,u                          *        move.b  #2,routine_secondary(a0)
        stb   anim_frame,u                       *        move.b  #0,anim_frame(a0)
        stb   anim_frame_duration,u              *        move.b  #0,anim_frame_duration(a0)
        ldd   #6
        std   w_TitleScr_move_frame_count,u      *        move.w  #6,objoff_2A(a0)
        ldd   w_TitleScr_xy_data_index,u         *        move.w  objoff_2C(a0),d0
        addd  #2                                 *        addq.w  #4,d0
        cmpd  #LargeStar_xy_data_end-LargeStar_xy_data
                                                 *        cmpi.w  #word_131DC_end-word_131DC+4,d0
        blo   LargeStar_MoveContinue
        jmp   DeleteObject                       *        bhs.w   DeleteObject
LargeStar_MoveContinue
        std   w_TitleScr_xy_data_index,u                    *        move.w  d0,objoff_2C(a0)
        leax  <LargeStar_xy_data-2,pcr
        leax  d,x                                *        move.l  word_131DC-4(pc,d0.w),d0
        ldd   ,x
        std   xy_pixel,u                         *        move.w  d0,y_pixel(a0)
                                                 *        swap    d0
                                                 *        move.w  d0,x_pixel(a0)
        * sound unused                           *        moveq   #SndID_Sparkle,d0 ; play intro sparkle sound
        rts                                      *        jmpto   (PlaySound).l, JmpTo4_PlaySound
                                                 *; ===========================================================================
                                                 *; unknown
LargeStar_xy_data                                *word_131DC:
        fcb   $2D,$66                            *        dc.w   $DA, $F2
        fcb   $78,$6C                            *        dc.w  $170, $F8 ; 2
        fcb   $59,$A5                            *        dc.w  $132,$131 ; 4
        fcb   $8F,$16                            *        dc.w  $19E, $A2 ; 6
        fcb   $20,$57                            *        dc.w   $C0, $E3 ; 8
        fcb   $80,$54                            *        dc.w  $180, $E0 ; $A
        fcb   $46,$AF                            *        dc.w  $10D,$13B ; $C
        fcb   $20,$1F                            *        dc.w   $C0, $AB ; $E
        fcb   $72,$7B                            *        dc.w  $165, $107        ; $10
LargeStar_xy_data_end                            *word_131DC_end
                                                 *; ===========================================================================

                                           
