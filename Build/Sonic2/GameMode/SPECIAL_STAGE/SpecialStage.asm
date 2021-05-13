                                                      *; ===========================================================================
                                                      *; loc_4F64:
SpecialStage                                          *SpecialStage:
        lda   Current_Special_Stage                                              
        cmpa  #7                                      *    cmpi.b  #7,(Current_Special_Stage).w
        blo   @a                                      *    blo.s   +
        clr   Current_Special_Stage                   *    move.b  #0,(Current_Special_Stage).w
@a                                                    *+
                                                      *    move.w  #SndID_SpecStageEntry,d0 ; play that funky special stage entry sound
                                                      *    bsr.w   PlaySound
                                                      *    move.b  #MusID_FadeOut,d0 ; fade out the music
                                                      *    bsr.w   PlayMusic
                                                      *    bsr.w   Pal_FadeToWhite
                                                      *    tst.w   (Two_player_mode).w
                                                      *    beq.s   +
                                                      *    move.w  #0,(Two_player_mode).w
                                                      *    st.b    (SS_2p_Flag).w ; set to -1
                                                      *    bra.s   ++
                                                      *; ===========================================================================
                                                      *+
                                                      *    sf.b    (SS_2p_Flag).w ; set to 0
                                                      *; (!)
                                                      *+
                                                      *    move    #$2700,sr       ; Mask all interrupts
                                                      *    lea (VDP_control_port).l,a6
                                                      *    move.w  #$8B03,(a6)     ; EXT-INT disabled, V scroll by screen, H scroll by line
                                                      *    move.w  #$8004,(a6)     ; H-INT disabled
                                                      *    move.w  #$8ADF,(Hint_counter_reserve).w ; H-INT every 224th scanline
                                                      *    move.w  #$8200|(VRAM_SS_Plane_A_Name_Table1/$400),(a6)  ; PNT A base: $C000
                                                      *    move.w  #$8400|(VRAM_SS_Plane_B_Name_Table/$2000),(a6)  ; PNT B base: $A000
                                                      *    move.w  #$8C08,(a6)     ; H res 32 cells, no interlace, S/H enabled
                                                      *    move.w  #$9003,(a6)     ; Scroll table size: 128x32
                                                      *    move.w  #$8700,(a6)     ; Background palette/color: 0/0
                                                      *    move.w  #$8D00|(VRAM_SS_Horiz_Scroll_Table/$400),(a6)       ; H scroll table base: $FC00
                                                      *    move.w  #$8500|(VRAM_SS_Sprite_Attribute_Table/$200),(a6)   ; Sprite attribute table base: $F800
                                                      *    move.w  (VDP_Reg1_val).w,d0
                                                      *    andi.b  #$BF,d0
                                                      *    move.w  d0,(VDP_control_port).l
                                                      *
                                                      *; /------------------------------------------------------------------------\
                                                      *; | We're gonna zero-fill a bunch of VRAM regions. This was done by macro, |
                                                      *; | so there's gonna be a lot of wasted cycles.                            |
                                                      *; \------------------------------------------------------------------------/
                                                      *
                                                      *    dmaFillVRAM 0,VRAM_SS_Plane_A_Name_Table2,VRAM_SS_Plane_Table_Size ; clear Plane A pattern name table 1
                                                      *    dmaFillVRAM 0,VRAM_SS_Plane_A_Name_Table1,VRAM_SS_Plane_Table_Size ; clear Plane A pattern name table 2
                                                      *    dmaFillVRAM 0,VRAM_SS_Plane_B_Name_Table,VRAM_SS_Plane_Table_Size ; clear Plane B pattern name table
                                                      *    dmaFillVRAM 0,VRAM_SS_Horiz_Scroll_Table,VRAM_SS_Horiz_Scroll_Table_Size  ; clear Horizontal scroll table
                                                      *
                                                      *    clr.l   (Vscroll_Factor).w
                                                      *    clr.l   (unk_F61A).w
                                                      *    clr.b   (SpecialStage_Started).w
                                                      *
                                                      *; /------------------------------------------------------------------------\
                                                      *; | Now we clear out some regions in main RAM where we want to store some  |
                                                      *; | of our data structures.                                                |
                                                      *; \------------------------------------------------------------------------/
                                                      *    ; Bug: These '+4's shouldn't be here; clearRAM accidentally clears an additional 4 bytes
                                                      *    clearRAM SS_Sprite_Table,SS_Sprite_Table_End+4
                                                      *    clearRAM SS_Horiz_Scroll_Buf_1,SS_Horiz_Scroll_Buf_1_End+4
                                                      *    clearRAM SS_Misc_Variables,SS_Misc_Variables_End+4
                                                      *    clearRAM SS_Sprite_Table_Input,SS_Sprite_Table_Input_End
                                                      *    clearRAM SS_Object_RAM,SS_Object_RAM_End
                                                      *
                                                      *    ; However, the '+4' after SS_Misc_Variables_End is very useful. It resets the
                                                      *    ; VDP_Command_Buffer queue, avoiding graphical glitches in the Special Stage.
                                                      *    ; In fact, without reset of the VDP_Command_Buffer queue, Tails sprite DPLCs and other
                                                      *    ; level DPLCs that are still in the queue erase the Special Stage graphics the next
                                                      *    ; time ProcessDMAQueue is called.
                                                      *    ; This '+4' doesn't seem to be intentional, because of the other useless '+4' above,
                                                      *    ; and because a '+2' is enough to reset the VDP_Command_Buffer queue and fix this bug.
                                                      *    ; This is a fortunate accident!
                                                      *    ; Note that this is not a clean way to reset the VDP_Command_Buffer queue because the
                                                      *    ; VDP_Command_Buffer_Slot address shall be updated as well. They tried to do that in a
                                                      *    ; clean way after branching to ClearScreen (see below). But they messed up by doing it
                                                      *    ; after several WaitForVint calls.
                                                      *    ; You can uncomment the two lines below to clear the VDP_Command_Buffer queue intentionally.
                                                      *    ;clr.w  (VDP_Command_Buffer).w
                                                      *    ;move.l #VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w
                                                      *
                                                      *    move    #$2300,sr
                                                      *    lea (VDP_control_port).l,a6
                                                      *    move.w  #$8F02,(a6)     ; VRAM pointer increment: $0002
                                                      *    bsr.w   ssInitTableBuffers
                                                      *    bsr.w   ssLdComprsdData
                                                      *    move.w  #0,(SpecialStage_CurrentSegment).w
                                                      *    moveq   #PLCID_SpecialStage,d0
                                                      *    bsr.w   RunPLC_ROM
                                                      *    clr.b   (Level_started_flag).w
                                                      *    move.l  #0,(Camera_X_pos).w ; probably means something else in this context
                                                      *    move.l  #0,(Camera_Y_pos).w
                                                      *    move.l  #0,(Camera_X_pos_copy).w
                                                      *    move.l  #0,(Camera_Y_pos_copy).w
                                                      *    cmpi.w  #1,(Player_mode).w  ; is this a Tails alone game?
                                                      *    bgt.s   +           ; if yes, branch
        ldu   #MainCharacter
        lda   #ObjID_SonicSS
        sta   id,u                                    *    move.b  #ObjID_SonicSS,(MainCharacter+id).w ; load Obj09 (special stage Sonic)
                                                      *    tst.w   (Player_mode).w     ; is this a Sonic and Tails game?
                                                      *    bne.s   ++          ; if not, branch
                                                      *+   move.b  #ObjID_TailsSS,(Sidekick+id).w ; load Obj10 (special stage Tails)
        ldu   #SpecialStageHUD
        lda   #ObjID_SSHUD
        sta   id,u                                    *+   move.b  #ObjID_SSHUD,(SpecialStageHUD+id).w ; load Obj5E (special stage HUD)
        ldu   #SpecialStageStartBanner
        lda   #ObjID_StartBanner
        sta   id,u                                    *    move.b  #ObjID_StartBanner,(SpecialStageStartBanner+id).w ; load Obj5F (special stage banner)
        ldu   #SpecialStageNumberOfRings
        lda   #ObjID_SSNumberOfRings
        sta   id,u                                    *    move.b  #ObjID_SSNumberOfRings,(SpecialStageNumberOfRings+id).w ; load Obj87 (special stage ring count)
        ldd   #$80
        std   SS_Offset_X                             *    move.w  #$80,(SS_Offset_X).w
        ldd   #$36
        std   SS_Offset_Y                             *    move.w  #$36,(SS_Offset_Y).w
                                                      *    bsr.w   SSPlaneB_Background
                                                      *    bsr.w   SSDecompressPlayerArt
        jsr   SSInitPalAndData                        *    bsr.w   SSInitPalAndData
                                                      *    move.l  #$C0000,(SS_New_Speed_Factor).w
                                                      *    clr.w   (Ctrl_1_Logical).w
                                                      *    clr.w   (Ctrl_2_Logical).w
                                                      *
                                                      *-   move.b  #VintID_S2SS,(Vint_routine).w
                                                      *    bsr.w   WaitForVint
                                                      *    move.b  (SSTrack_drawing_index).w,d0
                                                      *    bne.s   -
                                                      *
                                                      *    bsr.w   SSTrack_Draw
                                                      
 ; here load first track frame ?                                                      
                              fcb   ObjID_HalfPipe
                              fcb   $00
                              fill  0,object_size-2
                              fcb   ObjID_HalfPipe
                              fcb   $01
                              fill  0,object_size-2
                              fill  0,(nb_dynamic_objects-2)*object_size                                                      
                                                      *
                                                      *-   move.b  #VintID_S2SS,(Vint_routine).w
        jsr   WaitVBL                                 *    bsr.w   WaitForVint
                                                      *    bsr.w   SSTrack_Draw
        jsr   SSLoadCurrentPerspective                *    bsr.w   SSLoadCurrentPerspective
        jsr   SSObjectsManager                        *    bsr.w   SSObjectsManager
                                                      *    move.b  (SSTrack_duration_timer).w,d0
                                                      *    subq.w  #1,d0
                                                      *    bne.s   -
                                                      *
                                                      *    jsr (Obj5A_CreateRingsToGoText).l
                                                      *    bsr.w   SS_ScrollBG
                                                      *    jsr (RunObjects).l
                                                      *    jsr (BuildSprites).l
                                                      *    bsr.w   RunPLC_RAM
                                                      *    move.b  #VintID_CtrlDMA,(Vint_routine).w
        jsr   WaitVBL                                 *    bsr.w   WaitForVint
                                                      *    move.w  #MusID_SpecStage,d0
                                                      *    bsr.w   PlayMusic
                                                      *    move.w  (VDP_Reg1_val).w,d0
                                                      *    ori.b   #$40,d0
                                                      *    move.w  d0,(VDP_control_port).l
                                                      *    bsr.w   Pal_FadeFromWhite
                                                      *
                                                      *-   bsr.w   PauseGame
                                                      *    move.w  (Ctrl_1).w,(Ctrl_1_Logical).w
        jsr   ReadJoypads                             *    move.w  (Ctrl_2).w,(Ctrl_2_Logical).w
                                                      *    cmpi.b  #GameModeID_SpecialStage,(Game_Mode).w ; special stage mode?
        jsr   LoadGameMode                            *    bne.w   SpecialStage_Unpause        ; if not, branch
                                                      *    move.b  #VintID_S2SS,(Vint_routine).w
        jsr   WaitVBL                                 *    bsr.w   WaitForVint
                                                      *    bsr.w   SSTrack_Draw
                                                      *    bsr.w   SSSetGeometryOffsets
        jsr   SSLoadCurrentPerspective                *    bsr.w   SSLoadCurrentPerspective
        jsr   SSObjectsManager                        *    bsr.w   SSObjectsManager
                                                      *    bsr.w   SS_ScrollBG
        jsr   RunObjects                              *    jsr (RunObjects).l
        jsr   CheckSpritesRefresh                     *    jsr (BuildSprites).l
        jsr   EraseSprites
        jsr   UnsetDisplayPriority
        jsr   DrawSprites                                                         
                                                      *    bsr.w   RunPLC_RAM
                                                      *    tst.b   (SpecialStage_Started).w
                                                      *    beq.s   -
                                                      *
                                                      *    moveq   #PLCID_SpecStageBombs,d0
                                                      *    bsr.w   LoadPLC
                                                      *
                                                      *-   bsr.w   PauseGame
                                                      *    cmpi.b  #GameModeID_SpecialStage,(Game_Mode).w ; special stage mode?
                                                      *    bne.w   SpecialStage_Unpause        ; if not, branch
                                                      *    move.b  #VintID_S2SS,(Vint_routine).w
        jsr   WaitVBL                                 *    bsr.w   WaitForVint
                                                      *    bsr.w   SSTrack_Draw
                                                      *    bsr.w   SSSetGeometryOffsets
                                                      *    bsr.w   SSLoadCurrentPerspective
                                                      *    bsr.w   SSObjectsManager
                                                      *    bsr.w   SS_ScrollBG
                                                      *    bsr.w   PalCycle_SS
                                                      *    tst.b   (SS_Pause_Only_flag).w
                                                      *    beq.s   +
                                                      *    move.w  (Ctrl_1).w,d0
                                                      *    andi.w  #(button_start_mask<<8)|button_start_mask,d0
                                                      *    move.w  d0,(Ctrl_1_Logical).w
                                                      *    move.w  (Ctrl_2).w,d0
                                                      *    andi.w  #(button_start_mask<<8)|button_start_mask,d0
                                                      *    move.w  d0,(Ctrl_2_Logical).w
                                                      *    bra.s   ++
                                                      *; ===========================================================================
                                                      *+
                                                      *    move.w  (Ctrl_1).w,(Ctrl_1_Logical).w
                                                      *    move.w  (Ctrl_2).w,(Ctrl_2_Logical).w
                                                      *+
                                                      *    jsr (RunObjects).l
                                                      *    tst.b   (SS_Check_Rings_flag).w
                                                      *    bne.s   +
                                                      *    jsr (BuildSprites).l
                                                      *    bsr.w   RunPLC_RAM
                                                      *    bra.s   -
                                                      *; ===========================================================================
                                                      *+
                                                      *    andi.b  #7,(Emerald_count).w
                                                      *    tst.b   (SS_2p_Flag).w
                                                      *    beq.s   +
                                                      *    lea (SS2p_RingBuffer).w,a0
                                                      *    move.w  (a0)+,d0
                                                      *    add.w   (a0)+,d0
                                                      *    add.w   (a0)+,d0
                                                      *    add.w   (a0)+,d0
                                                      *    add.w   (a0)+,d0
                                                      *    add.w   (a0)+,d0
                                                      *    bra.s   ++
                                                      *; ===========================================================================
                                                      *+
                                                      *    move.w  (Ring_count).w,d0
                                                      *    add.w   (Ring_count_2P).w,d0
                                                      *+
                                                      *    cmp.w   (SS_Perfect_rings_left).w,d0
                                                      *    bne.s   +
                                                      *    st.b    (Perfect_rings_flag).w
                                                      *+
                                                      *    bsr.w   Pal_FadeToWhite
                                                      *    tst.w   (Two_player_mode_copy).w
                                                      *    bne.w   loc_540C
                                                      *    move    #$2700,sr
                                                      *    lea (VDP_control_port).l,a6
                                                      *    move.w  #$8200|(VRAM_Menu_Plane_A_Name_Table/$400),(a6)     ; PNT A base: $C000
                                                      *    move.w  #$8400|(VRAM_Menu_Plane_B_Name_Table/$2000),(a6)    ; PNT B base: $E000
                                                      *    move.w  #$9001,(a6)     ; Scroll table size: 64x32
                                                      *    move.w  #$8C81,(a6)     ; H res 40 cells, no interlace, S/H disabled
                                                      *    bsr.w   ClearScreen
                                                      *    jsrto   (Hud_Base).l, JmpTo_Hud_Base
                                                      *    clr.w   (VDP_Command_Buffer).w
                                                      *    move.l  #VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w
                                                      *    move    #$2300,sr
                                                      *    moveq   #PalID_Result,d0
                                                      *    bsr.w   PalLoad_Now
                                                      *    moveq   #PLCID_Std1,d0
                                                      *    bsr.w   LoadPLC2
                                                      *    move.l  #vdpComm(tiles_to_bytes(ArtTile_VRAM_Start+2),VRAM,WRITE),d0
                                                      *    lea SpecialStage_ResultsLetters(pc),a0
                                                      *    jsrto   (LoadTitleCardSS).l, JmpTo_LoadTitleCardSS
                                                      *    move.l  #vdpComm(tiles_to_bytes(ArtTile_ArtNem_SpecialStageResults),VRAM,WRITE),(VDP_control_port).l
                                                      *    lea (ArtNem_SpecialStageResults).l,a0
                                                      *    bsr.w   NemDec
                                                      *    move.w  (Player_mode).w,d0
                                                      *    beq.s   ++
                                                      *    subq.w  #1,d0
                                                      *    beq.s   +
                                                      *    clr.w   (Ring_count).w
                                                      *    bra.s   ++
                                                      *; ===========================================================================
                                                      *+
                                                      *    clr.w   (Ring_count_2P).w
                                                      *+
                                                      *    move.w  (Ring_count).w,(Bonus_Countdown_1).w
                                                      *    move.w  (Ring_count_2P).w,(Bonus_Countdown_2).w
                                                      *    clr.w   (Total_Bonus_Countdown).w
                                                      *    tst.b   (Got_Emerald).w
                                                      *    beq.s   +
                                                      *    move.w  #1000,(Total_Bonus_Countdown).w
                                                      *+
                                                      *    move.b  #1,(Update_HUD_score).w
                                                      *    move.b  #1,(Update_Bonus_score).w
                                                      *    move.w  #MusID_EndLevel,d0
                                                      *    jsr (PlaySound).l
                                                      *
                                                      *    clearRAM SS_Sprite_Table_Input,SS_Sprite_Table_Input_End
                                                      *    clearRAM SS_Object_RAM,SS_Object_RAM_End
                                                      *
                                                      *    move.b  #ObjID_SSResults,(SpecialStageResults+id).w ; load Obj6F (special stage results) at $FFFFB800
                                                      *-
                                                      *    move.b  #VintID_Level,(Vint_routine).w
        jsr   WaitVBL                                 *    bsr.w   WaitForVint
                                                      *    jsr (RunObjects).l
                                                      *    jsr (BuildSprites).l
                                                      *    bsr.w   RunPLC_RAM
                                                      *    tst.w   (Level_Inactive_flag).w
                                                      *    beq.s   -
                                                      *    tst.l   (Plc_Buffer).w
                                                      *    bne.s   -
                                                      *    move.w  #SndID_SpecStageEntry,d0
                                                      *    bsr.w   PlaySound
                                                      *    bsr.w   Pal_FadeToWhite
                                                      *    tst.w   (Two_player_mode_copy).w
                                                      *    bne.s   loc_540C
                                                      *    move.b  #GameModeID_Level,(Game_Mode).w ; => Level (Zone play mode)
        rts                                           *    rts
                                                      *; ===========================================================================
                                                      *
                                                      *loc_540C:
                                                      *    move.w  #VsRSID_SS,(Results_Screen_2P).w
                                                      *    move.b  #GameModeID_2PResults,(Game_Mode).w ; => TwoPlayerResults
        rts                                           *    rts
                                                      *; ===========================================================================
                                                      *
                                                      *; loc_541A:
                                                      *SpecialStage_Unpause:
                                                      *    move.b  #MusID_Unpause,(Music_to_play).w
                                                      *    move.b  #VintID_Level,(Vint_routine).w
        jmp   WaitVBL                                 *    bra.w   WaitForVint

                                                      *;|||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                                      *
                                                      *
                                                      *;sub_5514
SSLoadCurrentPerspective                              *SSLoadCurrentPerspective:
        lda   SSTrack_drawing_index                   *    cmpi.b  #4,(SSTrack_drawing_index).w
        bne   @a                                      *    bne.s   +   ; rts
        ldx   #SpecialPerspective                     *    movea.l #SSRAM_MiscKoz_SpecialPerspective,a0
                                                      *    moveq   #0,d0
        ldb   SSTrack_mapping_frame                   *    move.b  (SSTrack_mapping_frame).w,d0
        aslb                                          *    add.w   d0,d0
        abx                                           *    adda.w  (a0,d0.w),a0
        stx   SS_CurrentPerspective                   *    move.l  a0,(SS_CurrentPerspective).w
@a      rts                                           *+   rts
                                                      *; End of function SSLoadCurrentPerspective
                                                      *
                                                      *
                                                      *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                                      *
                                                      *
                                                      *;sub_5534
SSObjectsManager                                      *SSObjectsManager:
                                                      *    cmpi.b  #4,(SSTrack_drawing_index).w
                                                      *    bne.w   return_55DC
                                                      *    moveq   #0,d0
                                                      *    move.b  (SpecialStage_CurrentSegment).w,d0
                                                      *    cmp.b   (SpecialStage_LastSegment2).w,d0
                                                      *    beq.w   return_55DC
                                                      *    move.b  d0,(SpecialStage_LastSegment2).w
                                                      *    movea.l (SS_CurrentLevelLayout).w,a1
                                                      *    move.b  (a1,d0.w),d3
                                                      *    andi.w  #$7F,d3
                                                      *    lea (Ani_SSTrack_Len).l,a0
                                                      *    move.b  (a0,d3.w),d3
                                                      *    add.w   d3,d3
                                                      *    add.w   d3,d3
                                                      *    movea.l (SS_CurrentLevelObjectLocations).w,a0
                                                      *-
                                                      *    bsr.w   SSSingleObjLoad
                                                      *    bne.s   return_55DC
                                                      *    moveq   #0,d0
                                                      *    move.b  (a0)+,d0
                                                      *    bmi.s   ++
                                                      *    move.b  d0,d1
                                                      *    andi.b  #$40,d1
                                                      *    bne.s   +
                                                      *    addq.w  #1,(SS_Perfect_rings_left).w
                                                      *    move.b  #ObjID_SSRing,id(a1)
                                                      *    add.w   d0,d0
                                                      *    add.w   d0,d0
                                                      *    add.w   d3,d0
                                                      *    move.w  d0,objoff_30(a1)
                                                      *    move.b  (a0)+,angle(a1)
                                                      *    bra.s   -
                                                      *; ===========================================================================
                                                      *+
                                                      *    andi.w  #$3F,d0
                                                      *    move.b  #ObjID_SSBomb,id(a1)
                                                      *    add.w   d0,d0
                                                      *    add.w   d0,d0
                                                      *    add.w   d3,d0
                                                      *    move.w  d0,objoff_30(a1)
                                                      *    move.b  (a0)+,angle(a1)
                                                      *    bra.s   -
                                                      *; ===========================================================================
                                                      *+
                                                      *    move.l  a0,(SS_CurrentLevelObjectLocations).w
                                                      *    addq.b  #1,d0
                                                      *    beq.s   return_55DC
                                                      *    addq.b  #1,d0
                                                      *    beq.s   ++
                                                      *    addq.b  #1,d0
                                                      *    beq.s   +
                                                      *    st.b    (SS_NoCheckpoint_flag).w
                                                      *    sf.b    (SS_NoCheckpointMsg_flag).w
                                                      *    bra.s   ++
                                                      *; ===========================================================================
                                                      *+
                                                      *    tst.b   (SS_2p_Flag).w
                                                      *    bne.s   +
                                                      *    move.b  #ObjID_SSEmerald,id(a1)
                                                      *    rts
                                                      *; ===========================================================================
                                                      *+
                                                      *    move.b  #ObjID_SSMessage,id(a1)
                                                      *
                                                      *return_55DC:
        rts                                           *    rts
                                                      *; End of function SSObjectsManager
                                                      
                                                      *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||                                                      
                                                      
                                                      *;sub_77A2
SSInitPalAndData                                      *SSInitPalAndData:
                                                      *    clr.b   (Current_Special_Act).w
        lda   #-1
        sta   SpecialStage_LastSegment2               *    move.b  #-1,(SpecialStage_LastSegment2).w
        ldd   #0
        std   Ring_count                              *    move.w  #0,(Ring_count).w
                                                      *    move.w  #0,(Ring_count_2P).w
                                                      *    move.b  #0,(Perfect_rings_flag).w
                                                      *    move.b  #0,(Got_Emerald).w
                                                      *    move.b  #4,(SS_Star_color_2).w
                                                      *    lea (SS2p_RingBuffer).w,a2
                                                      *    moveq   #0,d0
                                                      *    move.w  d0,(a2)+
                                                      *    move.w  d0,(a2)+
                                                      *    move.w  d0,(a2)+
                                                      *    move.w  d0,(a2)+
                                                      *    move.w  d0,(a2)+
                                                      *    move.w  d0,(a2)+
                                                      *    moveq   #PalID_SS,d0
                                                      *    bsr.w   PalLoad_ForFade
                                                      *    lea_    SpecialStage_Palettes,a1
                                                      *    moveq   #0,d0
        ldb   Current_Special_Stage                   *    move.b  (Current_Special_Stage).w,d0
        aslb                                          *    add.w   d0,d0
                                                      *    move.w  d0,d1
                                                      *    tst.b   (SS_2p_Flag).w
                                                      *    beq.s   +
                                                      *    cmpi.b  #4,d0
                                                      *    blo.s   +
                                                      *    addi_.w #6,d0
                                                      *+
                                                      *    move.w  (a1,d0.w),d0
                                                      *    bsr.w   PalLoad_ForFade
        ldx   #SpecialLevelLayout                     *    lea (SSRAM_MiscKoz_SpecialObjectLocations).w,a0
        abx                                           *    adda.w  (a0,d1.w),a0
        stx   SS_CurrentLevelObjectLocations          *    move.l  a0,(SS_CurrentLevelObjectLocations).w
        ldx   #SpecialLevelLayout                     *    lea (SSRAM_MiscNem_SpecialLevelLayout).w,a0
        abx                                           *    adda.w  (a0,d1.w),a0
        stx   SS_CurrentLevelLayout                   *    move.l  a0,(SS_CurrentLevelLayout).w
        rts                                           *    rts
                                                      *; End of function SSInitPalAndData     
                                                      
                                                         
                                                      
SpecialLevelLayout
        INCLUDEBIN "./GameMode/SPECIAL_STAGE/Special stage level layouts.bin"
        
SpecialObjectLocations
        INCLUDEBIN "./GameMode/SPECIAL_STAGE/Special stage object location lists.bin"
        
SpecialPerspective
        INCLUDEBIN "./GameMode/SPECIAL_STAGE/Special stage object perspective data.bin"                