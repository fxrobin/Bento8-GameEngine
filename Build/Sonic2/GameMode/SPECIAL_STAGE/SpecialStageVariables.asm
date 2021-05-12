; RAM variables - Special stage

Object_RAM
SS_Object_RAM
MainCharacter             fill  0,object_size
Sidekick                  fill  0,object_size
SpecialStageHUD           fill  0,object_size
SpecialStageStartBanner   fill  0,object_size
SpecialStageNumberOfRings fill  0,object_size
SpecialStageShadow_Sonic  fill  0,object_size
SpecialStageShadow_Tails  fill  0,object_size
SpecialStageTails_Tails   fill  0,object_size
SS_Dynamic_Object_RAM     fill  0,$18*object_size
SpecialStageResults       fill  0,object_size
                          ; fill  0,$C*object_size
SpecialStageResults2      fill  0,object_size
                          ; fill  0,$51*object_size
SS_Dynamic_Object_RAM_End fill  0,object_size
SS_Object_RAM_End
Object_RAM_End

				; The special stage mode also uses the rest of the RAM for
				; different purposes.
SS_Misc_Variables:
PNT_Buffer:			ds.b	$700
PNT_Buffer_End:
SS_Horiz_Scroll_Buf_2:		ds.b	$400

SSTrack_mappings_bitflags:				ds.l	1
SSTrack_mappings_uncompressed:			ds.l	1
SSTrack_anim:							ds.b	1
SSTrack_last_anim_frame:				ds.b	1
SpecialStage_CurrentSegment:			ds.b	1
SSTrack_anim_frame:						ds.b	1
SS_Alternate_PNT:						ds.b	1
SSTrack_drawing_index:					ds.b	1
SSTrack_Orientation:					ds.b	1
SS_Alternate_HorizScroll_Buf:			ds.b	1
SSTrack_mapping_frame:					ds.b	1
SS_Last_Alternate_HorizScroll_Buf:		ds.b	1
SS_New_Speed_Factor:					ds.l	1
SS_Cur_Speed_Factor:					ds.l	1
		ds.b	5
SSTrack_duration_timer:					ds.b	1
		ds.b	1
SS_player_anim_frame_timer:				ds.b	1
SpecialStage_LastSegment:				ds.b	1
SpecialStage_Started:					ds.b	1
		ds.b	4
SSTrack_last_mappings_copy:				ds.l	1
SSTrack_last_mappings:					ds.l	1
		ds.b	4
SSTrack_LastVScroll:					ds.w	1
		ds.b	3
SSTrack_last_mapping_frame:				ds.b	1
SSTrack_mappings_RLE:					ds.l	1
SSDrawRegBuffer:						ds.w	6
SSDrawRegBuffer_End
		ds.b	2
SpecialStage_LastSegment2:	ds.b	1
SS_unk_DB4D:	ds.b	1
		ds.b	$14
SS_Ctrl_Record_Buf:
				ds.w	$F
SS_Last_Ctrl_Record:
				ds.w	1
SS_Ctrl_Record_Buf_End
SS_CurrentPerspective:	ds.l	1
SS_Check_Rings_flag:		ds.b	1
SS_Pause_Only_flag:		ds.b	1
SS_CurrentLevelObjectLocations:	ds.l	1
SS_Ring_Requirement:	ds.w	1
SS_CurrentLevelLayout:	ds.l	1
		ds.b	1
SS_2P_BCD_Score:	ds.b	1
		ds.b	1
SS_NoCheckpoint_flag:	ds.b	1
		ds.b	2
SS_Checkpoint_Rainbow_flag:	ds.b	1
SS_Rainbow_palette:	ds.b	1
SS_Perfect_rings_left:	ds.w	1
		ds.b	2
SS_Star_color_1:	ds.b	1
SS_Star_color_2:	ds.b	1
SS_NoCheckpointMsg_flag:	ds.b	1
		ds.b	1
SS_NoRingsTogoLifetime:	ds.w	1
SS_RingsToGoBCD:		ds.w	1
SS_HideRingsToGo:	ds.b	1
SS_TriggerRingsToGo:	ds.b	1
			ds.b	$58	; unused
SS_Misc_Variables_End:

	phase	ramaddr(Horiz_Scroll_Buf)	; Still in SS RAM
SS_Horiz_Scroll_Buf_1:		ds.b	$400
SS_Horiz_Scroll_Buf_1_End:

	phase	ramaddr($FFFFF73E)	; Still in SS RAM
SS_Offset_X:			ds.w	1
SS_Offset_Y:			ds.w	1
SS_Swap_Positions_Flag:	ds.b	1

	phase	ramaddr(Sprite_Table)	; Still in SS RAM
SS_Sprite_Table:			ds.b	$280	; Sprite attribute table buffer
SS_Sprite_Table_End:
				ds.b	$80	; unused, but SAT buffer can spill over into this area when there are too many sprites on-screen