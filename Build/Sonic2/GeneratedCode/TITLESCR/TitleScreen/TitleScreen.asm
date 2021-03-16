; ---------------------------------------------------------------------------
; Object - TitleScreen
;
; input REG : [u] pointer to Object Status Table (OST)
; ---------
;
; Instructions for position-independent code
; ------------------------------------------
; - call to a Main Engine routine (6100 - 9FFF): use a jump (jmp, jsr, rts), do not use branch
; - call to internal object routine: use branch ((l)b__), do not use jump
; - use indexed addressing to access data table: first load table address by using "leax my_table,pcr"
;
; ---------------------------------------------------------------------------
;
; Sonic 2 - Notes
; ---------------
;
; Palettes
; --------
; 4x pal of 16 colors (first is transparent)
; init state:
;    Pal1 - LargeStar, Tails
;    Pal0,2,3 - Black
;
; sequence of TitleScreen :
;    Pal3 - fade in - Emblem
;    Pal0 - set - Sonic
;    Pal2 - set - White
;    Pal2 - fade in - Background
;
; Colors
; ------
; Genesis/Megadrive: 8 values for each component (BGR) 0, 2, 4, 6, 8, A, C, E
; RGB space values: 0, 0x24, 0x49, 0x6D, 0x92, 0xB6, 0xDB, 0xFF
;
; Display position
; ----------------
; Horizontal
; - the sprite H position is between 0 and 511 but the display area is from 128 to 383 in H32 mode and 128 to 447 in H40 mode
; Vertical Non-interlace
; - the sprite V position is between 0 and 511 but the display area is from 128 to 351 in V28 mode and 128 to 367 in V30 mode
;
; conversion :
; x=((x-128)/2)+48
; y=y-140+28-1
;
; center : #$807F
; top left : #$301C
; bottom right : #$CFE3
;
; Display priority (VDP)
; ----------------------
; Background
;  |  backdrop color => Blue
;  |  low priority plane B tiles => Island
;  |  low priority plane A tiles
;  |  low priority sprites  => from top to bottom : center of Emblem Top, Sky piece (4x 8x32) link 8, 9, 10, 11 xpos 4,0,4,0 ypos 240,240,272,272
;  |  high priority plane B tiles
;  |  high priority plane A tiles => Emblem
; \./ high priority sprites => from top to bottom: left and right of Emblem Top, Sonic, Tails
; Foreground
;
; TitleScreen_Loop (s2.asm) set "horizontal position" alternatively to 0 and 4
; on all VDP sprites that have : priority = 0, hflip = 0, vflip = 0 and tileart < $80
;
; One VDP funtion is that when a sprite is x = 0, all horizontal lines that are occupied by this sprite
; are no more refreshed with the content of lower priority sprites (Sprite_Table).
; This is used to mask Sonic and Tails behind the emblem.
; Another sprite is used to mask the upper part of the emblem (non linear shape.
; ---------------------------------------------------------------------------

(main)TITLESCR
        INCLUD GLOBALS
        INCLUD CONSTANT
        org   $A000

* ---------------------------------------------------------------------------
* Object Status Table index
* - objects with a dedicated adress (no dynamic allocation)
* ---------------------------------------------------------------------------
TitleScr_This           equ Object_RAM
Obj_Sonic               equ TitleScr_This
Obj_Tails               equ TitleScr_This+(object_size*1)
Obj_LargeStar           equ TitleScr_This+(object_size*2)
Obj_SmallStar           equ TitleScr_This+(object_size*3)
Obj_SonicHand           equ TitleScr_This+(object_size*4)
Obj_TailsHand           equ TitleScr_This+(object_size*5)
Obj_EmblemFront01       equ TitleScr_This+(object_size*6)
Obj_EmblemFront02       equ TitleScr_This+(object_size*7)
Obj_EmblemFront03       equ TitleScr_This+(object_size*8)
Obj_EmblemFront04       equ TitleScr_This+(object_size*9)
Obj_EmblemFront05       equ TitleScr_This+(object_size*10)
Obj_EmblemFront06       equ TitleScr_This+(object_size*11)
Obj_EmblemFront07       equ TitleScr_This+(object_size*12)
Obj_EmblemFront08       equ TitleScr_This+(object_size*13)
Obj_EmblemBack01        equ TitleScr_This+(object_size*14)
Obj_EmblemBack02        equ TitleScr_This+(object_size*15)
Obj_EmblemBack03        equ TitleScr_This+(object_size*16)
Obj_EmblemBack04        equ TitleScr_This+(object_size*17)
Obj_EmblemBack05        equ TitleScr_This+(object_size*18)
Obj_EmblemBack06        equ TitleScr_This+(object_size*19)
Obj_EmblemBack07        equ TitleScr_This+(object_size*20)
Obj_EmblemBack08        equ TitleScr_This+(object_size*21)
Obj_EmblemBack09        equ TitleScr_This+(object_size*22)
Obj_Island              equ TitleScr_This+(object_size*23)
Obj_PaletteHandler      equ TitleScr_This+(object_size*24)
Obj_PaletteHandler2     equ TitleScr_This+(object_size*25)
Obj_PaletteHandler3     equ TitleScr_This+(object_size*26)
TitleScr_Object_RAM_End equ TitleScr_This+(object_size*27)

* ---------------------------------------------------------------------------
* Object Status Table offsets
* - two variables can share same space if used by two different subtypes
* - take care of words and bytes and space them accordingly
* ---------------------------------------------------------------------------
w_TitleScr_time_frame_count     equ ext_variables
w_TitleScr_time_frame_countdown equ ext_variables+2
w_TitleScr_move_frame_count     equ ext_variables+2
w_TitleScr_xy_data_index        equ ext_variables+4
w_TitleScr_color_data_index     equ ext_variables+4
b_TitleScr_final_state          equ ext_variables+6
b_TitleScr_music_is_playing     equ ext_variables+7

* ---------------------------------------------------------------------------
* Subtypes
* ---------------------------------------------------------------------------
Sub_Init        equ 0
Sub_Sonic       equ 3
Sub_Tails       equ 6
Sub_EmblemFront equ 9
Sub_EmblemBack  equ 12
Sub_LargeStar   equ 15
Sub_SonicHand   equ 18
Sub_SmallStar   equ 21
Sub_TailsHand   equ 24
Sub_Island      equ 27

* ***************************************************************************
* TitleScreen
* ***************************************************************************

                                                 *; ----------------------------------------------------------------------------
                                                 *; Object 0E - Flashing stars from intro
                                                 *; ----------------------------------------------------------------------------
                                                 *; Sprite_12E18:
TitleScreen                                      *Obj0E:
                                                 *        moveq   #0,d0
        lda   routine,u                          *        move.b  routine(a0),d0
        sta   *+4,pcr                            *        move.w  Obj0E_Index(pc,d0.w),d1
        bra   TitleScreen_Routines               *        jmp     Obj0E_Index(pc,d1.w)
                                                 *; ===========================================================================
                                                 *; off_12E26: Obj0E_States:
TitleScreen_Routines                             *Obj0E_Index:    offsetTable
        lbra  Init                               *                offsetTableEntry.w Obj0E_Init   ;   0
        lbra  Sonic                              *                offsetTableEntry.w Obj0E_Sonic  ;   2
        lbra  Tails                              *                offsetTableEntry.w Obj0E_Tails  ;   4
        lbra  EmblemFront                        *                offsetTableEntry.w Obj0E_LogoTop        ;   6
        lbra  EmblemBack        
        lbra  LargeStar                          *                offsetTableEntry.w Obj0E_LargeStar      ;   8
        lbra  SonicHand                          *                offsetTableEntry.w Obj0E_SonicHand      ;  $A
        lbra  SmallStar                          *                offsetTableEntry.w Obj0E_SmallStar      ;  $C
                                                 *                offsetTableEntry.w Obj0E_SkyPiece       ;  $E
        lbra  TailsHand                          *                offsetTableEntry.w Obj0E_TailsHand      ; $10
        lbra  Island
                                                 *; ===========================================================================
                                                 *; loc_12E38:
Init                                             *Obj0E_Init:
        * vdp unused                             *        addq.b  #2,routine(a0)  ; useless, because it's overwritten with the subtype below
        * vdp unused                             *        move.l  #Obj0E_MapUnc_136A8,mappings(a0)
        * vdp unused                             *        move.w  #make_art_tile(ArtTile_ArtNem_TitleSprites,0,0),art_tile(a0)
        lda   #4                                 *        move.b  #4,priority(a0)
        sta   priority,u
        lda   subtype,u                          *        move.b  subtype(a0),routine(a0)
        sta   routine,u
        bra   TitleScreen                        *        bra.s   Obj0E
                                                 *; ===========================================================================

* ---------------------------------------------------------------------------
* Sonic
* ---------------------------------------------------------------------------

                                                 *
Sonic                                            *Obj0E_Sonic:
        ldd   w_TitleScr_time_frame_count,u
        addd  #1                                 *        addq.w  #1,objoff_34(a0)
        std   w_TitleScr_time_frame_count,u
        cmpd  #$120                              *        cmpi.w  #$120,objoff_34(a0)
        bhs   Sonic_NotFinalState                *        bhs.s   +
        lbsr  TitleScreen_SetFinalState
                                                 *        bsr.w   TitleScreen_SetFinalState
Sonic_NotFinalState                              *+
                                                 *        moveq   #0,d0
        lda   routine_secondary,u                *        move.b  routine_secondary(a0),d0
        sta   *+4,pcr                            *        move.w  off_12E76(pc,d0.w),d1
        bra   Sonic_Routines                     *        jmp     off_12E76(pc,d1.w)
                                                 *; ===========================================================================
Sonic_Routines                                   *off_12E76:      offsetTable
        lbra  Sonic_Init                         *                offsetTableEntry.w Obj0E_Sonic_Init     ;   0
        lbra  Sonic_PaletteFade                  *                offsetTableEntry.w loc_12EC2    ;   2
        lbra  Sonic_SetPal_TitleScreen           *                offsetTableEntry.w loc_12EE8    ;   4
        lbra  Sonic_Move                         *                offsetTableEntry.w loc_12F18    ;   6
        lbra  TitleScreen_Animate                *                offsetTableEntry.w loc_12F52    ;   8
        lbra  Sonic_CreateHand                   *                offsetTableEntry.w Obj0E_Sonic_LastFrame        ;  $A
        lbra  Sonic_CreateTails                  *                offsetTableEntry.w loc_12F7C    ;  $C
        lbra  Sonic_FadeInBackground             *                offsetTableEntry.w loc_12F9A    ;  $E
        lbra  Sonic_CreateSmallStar              *                offsetTableEntry.w loc_12FD6    ; $10
        lbra  CyclingPal                         *                offsetTableEntry.w loc_13014    ; $12
                                                 *; ===========================================================================
                                                 *; spawn more stars
Sonic_Init                                       *Obj0E_Sonic_Init:

        ldd   #Pal_TitleScreen *@IgnoreUndefined
		std   Cur_palette
        clr   Refresh_palette                    * will call refresh palette after next VBL

        ldd   #IrqPsg
        std   irq_routine
        lda   #132                               ; screen line to sync
        ldx   #irq_one_frame                     ; on every frame
        jsr   IrqSync
        jsr   IrqOn

        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        ldd   #Img_sonic_1
        std   image_set,u                        *        move.b  #5,mapping_frame(a0)
        ldd   #Ani_sonic                         ; in original code, anim is an index in offset table (1 byte) that is implicitly initialized to 0
        std   anim,u                             ; so added init code to anim address here because it is not an index anymore
        * sonic est invisible a cette position mais depasse en bas on le positionne donc hors cadre        
        ldd   #$0000
        std   xy_pixel,u                         *        move.w  #$110,x_pixel(a0)
                                                 *        move.w  #$E0,y_pixel(a0)
        ldx   #Obj_LargeStar                     *        lea     (IntroLargeStar).w,a1
        lda   #ObjID_TitleScreen
        sta   id,x                               *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E (flashing intro stars) at $FFFFB0C0
        ldb   #Sub_LargeStar
        stb   subtype,x                          *        move.b  #8,subtype(a1)                          ; large star
        
        * moved to Sonic_PaletteFadeAfterWait    *        lea     (IntroEmblemTop).w,a1
                                                 *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E (flashing intro stars) at $FFFFD140

                                                 *        move.b  #6,subtype(a1)                          ; logo top

        * sound unused                           *        moveq   #SndID_Sparkle,d0
        rts                                      *        jmpto   (PlaySound).l, JmpTo4_PlaySound
                                                 *; ===========================================================================
                                                 *
Sonic_PaletteFade                                *loc_12EC2:
        ldd   w_TitleScr_time_frame_count,u
        cmpd  #$38                               *        cmpi.w  #$38,objoff_34(a0)
        bhs   Sonic_PaletteFadeAfterWait         *        bhs.s   +
        rts                                      *        rts
                                                 *; ===========================================================================
Sonic_PaletteFadeAfterWait                       *+
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        
        * Create emblem tiles
        ldx   #Obj_EmblemFront01
        lda   #ObjID_TitleScreen
        ldb   #Sub_EmblemFront
        sta   id,x
        stb   subtype,x
        ldy   #Img_emblemFront01
		sty   image_set,x                    
        
        ldx   #Obj_EmblemFront02
        sta   id,x
        stb   subtype,x
        ldy   #Img_emblemFront02
		sty   image_set,x 
		
        ldx   #Obj_EmblemFront03
        sta   id,x
        stb   subtype,x
        ldy   #Img_emblemFront03
		sty   image_set,x 
		
        ldx   #Obj_EmblemFront04
        sta   id,x
        stb   subtype,x
        ldy   #Img_emblemFront04
		sty   image_set,x 	
		
		ldx   #Obj_EmblemFront05
        sta   id,x
        stb   subtype,x
        ldy   #Img_emblemFront05
		sty   image_set,x 	
		
        ldx   #Obj_EmblemFront06
        sta   id,x
        stb   subtype,x
        ldy   #Img_emblemFront06
		sty   image_set,x 		
		
        ldx   #Obj_EmblemFront07
        sta   id,x
        stb   subtype,x
        ldy   #Img_emblemFront07
		sty   image_set,x 	
		
        ldx   #Obj_EmblemFront08
        sta   id,x
        stb   subtype,x
        ldy   #Img_emblemFront08
		sty   image_set,x 			
		
        ldx   #Obj_EmblemBack01
        ldb   #Sub_EmblemBack
        sta   id,x
        stb   subtype,x
        ldy   #Img_emblemBack01
		sty   image_set,x 
		
        ldx   #Obj_EmblemBack02
        sta   id,x
        stb   subtype,x
        ldy   #Img_emblemBack02
		sty   image_set,x 
		
        ldx   #Obj_EmblemBack03
        sta   id,x
        stb   subtype,x
        ldy   #Img_emblemBack03
		sty   image_set,x 	
		
		ldx   #Obj_EmblemBack04
        sta   id,x
        stb   subtype,x
        ldy   #Img_emblemBack04
		sty   image_set,x 	
		
        ldx   #Obj_EmblemBack05
        sta   id,x
        stb   subtype,x
        ldy   #Img_emblemBack05
		sty   image_set,x 		
		
        ldx   #Obj_EmblemBack06
        sta   id,x
        stb   subtype,x
        ldy   #Img_emblemBack06
		sty   image_set,x 	
		
        ldx   #Obj_EmblemBack07
        sta   id,x
        stb   subtype,x
        ldy   #Img_emblemBack07
		sty   image_set,x 	        
		
        ldx   #Obj_EmblemBack08
        sta   id,x
        stb   subtype,x
        ldy   #Img_emblemBack08
		sty   image_set,x 
		
		ldx   #Obj_EmblemBack09
        sta   id,x
        stb   subtype,x
        ldy   #Img_emblemBack09
		sty   image_set,x 	
        
        ldx   #Obj_PaletteHandler3               *        lea     (TitleScreenPaletteChanger3).w,a1
        lda   #ObjID_PaletteHandler
        sta   id,x                               *        move.b  #ObjID_TtlScrPalChanger,id(a1) ; load objC9 (palette change)
        clr   subtype,x                          *        move.b  #0,subtype(a1)
        ldd   #Black_palette
        std   ext_variables,x
        ldd   #Pal_TitleScreen *@IgnoreUndefined
        std   ext_variables+2,x
        lda   #$FF  
        sta   b_TitleScr_music_is_playing        *        st.b    objoff_30(a0)
        ldx   #Psg_TitleScreen  *@IgnoreUndefined *        moveq   #MusID_Title,d0 ; title music
        jmp   PSGPlayNoRepeat                    *        jmpto   (PlayMusic).l, JmpTo4_PlayMusic
                                                 *; ===========================================================================
                                                 *
Sonic_SetPal_TitleScreen                         *loc_12EE8:
        ldd   w_TitleScr_time_frame_count,u
        cmpd  #$80                               *        cmpi.w  #$80,objoff_34(a0)
        bhs   Sonic_SetPal_TitleScreenAfterWait  *        bhs.s   +
        rts                                      *        rts
                                                 *; ===========================================================================
Sonic_SetPal_TitleScreenAfterWait                *+
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)

        *ldd   #Pal_TitleScreen                   *        lea     (Pal_133EC).l,a1
        *std   Cur_palette                        *        lea     (Normal_palette).w,a2
                                                 *
        * not implemented                        *        moveq   #$F,d6
        * switch pointer to                      *-       move.w  (a1)+,(a2)+
        * fixed palette instead of copying data  *        dbf     d6,-
                                                 *
                                                 *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                                 *
                                                 *
        * not implemented                        *sub_12F08:
        * not implemented                        *        lea     (IntroSmallStar1).w,a1
        * not implemented
        * not implemented                        *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E (flashing intro star) at $FFFFB180
        * not implemented
        * not implemented                        *        move.b  #$E,subtype(a1)                         ; piece of sky
        rts                                      *        rts
                                                 *; End of function sub_12F08
                                                 *
                                                 *; ===========================================================================
                                                 *
Sonic_Move                                       *loc_12F18:
        ldx   #Sonic_xy_data_end-Sonic_xy_data+2
        stx   dyn_01+2,pcr                       *        moveq   #word_13046_end-word_13046+4,d2
        leax  Sonic_xy_data-2,pcr                *        lea     (word_13046).l,a1
                                                 *
TitleScreen_MoveObjects                          *loc_12F20:
        ldd   w_TitleScr_move_frame_count,u      *        move.w  objoff_2A(a0),d0
        addd  #1                                 *        addq.w  #1,d0
        std   w_TitleScr_move_frame_count,u      *        move.w  d0,objoff_2A(a0)
        *andb  #3 * means one frame on four       *        andi.w  #3,d0
        *bne   MoveObjects_KeepPosition           *        bne.s   +
        ldd   w_TitleScr_xy_data_index,u         *        move.w  objoff_2C(a0),d1
        addd  #2                                 *        addq.w  #4,d1
dyn_01
        cmpd  #$0000                             *        cmp.w   d2,d1
        lbhs  TitleScreen_NextSubRoutineAndDisplay
                                                 *        bhs.w   loc_1310A
        std   w_TitleScr_xy_data_index,u         *        move.w  d1,objoff_2C(a0)
        leax  d,x                                *        move.l  -4(a1,d1.w),d0
        ldd   ,x                                 *        move.w  d0,y_pixel(a0)
        std   xy_pixel,u
                                                 *        swap    d0
                                                 *        move.w  d0,x_pixel(a0)
           
MoveObjects_KeepPosition                         *+
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *
TitleScreen_Animate                              *loc_12F52:
        * no more offset table                   *        lea     (Ani_obj0E).l,a1
        jsr   AnimateSprite                      *        bsr.w   AnimateSprite
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *
Sonic_CreateHand                                 *Obj0E_Sonic_LastFrame:
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        ldd   #Img_sonic_4
        std   image_set,u                        *        move.b  #$12,mapping_frame(a0)
        ldx   #Obj_SonicHand                     *        lea     (IntroSonicHand).w,a1
        lda   #ObjID_TitleScreen
        sta   id,x                               *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E (flashing intro star) at $FFFFB1C0
        lda   #Sub_SonicHand
        sta   subtype,x                          *        move.b  #$A,subtype(a1)                         ; Sonic's hand
        
        * Change sprite to overlay
        lda   render_flags,u
        ora   #render_overlay_mask!render_motionless_mask
        sta   render_flags,u
                
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *
Sonic_CreateTails                                *loc_12F7C:
        ldd   w_TitleScr_time_frame_count,u
        cmpd  #$C0                               *        cmpi.w  #$C0,objoff_34(a0)
        blo   Sonic_CreateTails_BeforeWait       *        blo.s   +
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        ldx   #Obj_Tails                         *        lea     (IntroTails).w,a1
        lda   #ObjID_TitleScreen
        sta   id,x                               *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E (flashing intro star) at $FFFFB080
        lda   #Sub_Tails
        sta   subtype,x                          *        move.b  #4,subtype(a1)                          ; Tails
Sonic_CreateTails_BeforeWait                     *+
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *
Sonic_FadeInBackground                           *loc_12F9A:
        ldd   w_TitleScr_time_frame_count,u
        cmpd  #$120                              *        cmpi.w  #$120,objoff_34(a0)
        blo   Sonic_FadeInBackground_NotYet      *        blo.s   +
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        ldd   #$0000
        std   w_TitleScr_xy_data_index,u         *        clr.w   objoff_2C(a0)
        ldd   #$FF
        std   b_TitleScr_final_state,u            *        st      objoff_2F(a0)
        
        lda   $E7E5
        sta   Irq_Raster_Page
        ldd   #Pal_TitleScreenRaster
        std   Irq_Raster_Start
        ldd   #Pal_TitleScreenRaster_end
        std   Irq_Raster_End        
        ldd   #IrqPsgRaster
        std   irq_routine
        
        ldx   #Obj_Island
        lda   #ObjID_TitleScreen
        sta   id,x
        lda   #Sub_Island
        sta   subtype,x
        
        *ldd   #White_palette                     *        lea     (Normal_palette_line3).w,a1
        *std   cur_palette                        *        move.w  #$EEE,d0
                                                 *
        * not implemented                        *        moveq   #$F,d6
        * switch pointer to                      *-       move.w  d0,(a1)+
        * fixed palette instead of copying data  *        dbf     d6,-
                                                 *
        *ldx   #Obj_PaletteHandler2               *        lea     (TitleScreenPaletteChanger2).w,a1
        *lda   #ObjID_TtlScrPalChanger
        *sta   id,x                               *        move.b  #ObjID_TtlScrPalChanger,id(a1) ; load objC9 (palette change handler) at $FFFFB240
        *lda   #2
        *sta   subtype,x                          *        move.b  #2,subtype(a1)
        * not implemented                        *        move.b  #ObjID_TitleMenu,(TitleScreenMenu+id).w ; load Obj0F (title screen menu) at $FFFFB400
Sonic_FadeInBackground_NotYet                    *+
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *
Sonic_CreateSmallStar                            *loc_12FD6:
        * not implemented                        *        btst    #6,(Graphics_Flags).w ; is Megadrive PAL?
        * not implemented                        *        beq.s   + ; if not, branch
        ldd   w_TitleScr_time_frame_count,u
        cmpd  #$190                              *        cmpi.w  #$190,objoff_34(a0)
        beq   Sonic_CreateSmallStar_AfterWait    *        beq.s   ++
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *+
        * not implemented                        *        cmpi.w  #$1D0,objoff_34(a0)
        * not implemented                        *        beq.s   +
        * not implemented                        *        bra.w   DisplaySprite
                                                 *; ===========================================================================
Sonic_CreateSmallStar_AfterWait                  *+
        ldx   #Obj_SmallStar                     *        lea     (IntroSmallStar2).w,a1
        lda   #ObjID_TitleScreen
        sta   id,x                               *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E (flashing intro star) at $FFFFB440
        lda   #Sub_SmallStar
        sta   subtype,x                          *        move.b  #$C,subtype(a1)                         ; small star
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        * not implemented                        *        lea     (IntroSmallStar1).w,a1
        * not implemented                        *        bsr.w   DeleteObject2 ; delete object at $FFFFB180
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *
CyclingPal                                       *loc_13014:
       *lda   Vint_runcount+1                    *        move.b  (Vint_runcount+3).w,d0
       *anda  #7 * every 8 frames                *        andi.b  #7,d0
       *bne   CyclingPal_NotYet                  *        bne.s   ++
       *ldx   w_TitleScr_color_data_index,u      *        move.w  objoff_2C(a0),d0
       *leax  2,x                                *        addq.w  #2,d0
       *cmpx  #CyclingPal_TitleScreen_end-CyclingPal_TitleScreen
                                                 *        cmpi.w  #CyclingPal_TitleStar_End-CyclingPal_TitleStar,d0
       *blo   CyclingPal_Continue                *        blo.s   +
       *ldx   #0                                 *        moveq   #0,d0
CyclingPal_Continue                              *+
       *stx   w_TitleScr_color_data_index,u      *        move.w  d0,objoff_2C(a0)
       *leax  <CyclingPal_TitleScreen-2,pcr      *        move.w  CyclingPal_TitleStar(pc,d0.w),(Normal_palette_line3+$A).w
       *ldd   ,x
       *std   Normal_palette+$E
CyclingPal_NotYet                                *+
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *; word_1303A:
CyclingPal_TitleScreen                           *CyclingPal_TitleStar:
                                                 *        binclude "art/palettes/Title Star Cycle.bin"
        *fdb   $0F11                             * ;$0E64
        *fdb   $0E31                             * ;$0E86
        *fdb   $0F11                             * ;$0E64
        *fdb   $0E63                             * ;$0EA8
        *fdb   $0F11                             * ;$0E64
        *fdb   $0E96                             * ;$0ECA
CyclingPal_TitleScreen_end                       *CyclingPal_TitleStar_End
                                                 *
Sonic_xy_data                                    *word_13046:
        fcb   $74,$5F                            *        dc.w  $108, $D0
        fcb   $70,$4F                            *        dc.w  $100, $C0 ; 2
        fcb   $6C,$3F                            *        dc.w   $F8, $B0 ; 4
        fcb   $6B,$35                            *        dc.w   $F6, $A6 ; 6
        fcb   $6D,$2D                            *        dc.w   $FA, $9E ; 8
        fcb   $70,$29                            *        dc.w  $100, $9A ; $A
        fcb   $72,$28                            *        dc.w  $104, $99 ; $C
        fcb   $74,$27                            *        dc.w  $108, $98 ; $E
Sonic_xy_data_end                                *word_13046_end
                                                 *; ===========================================================================

* ---------------------------------------------------------------------------
* Tails
* ---------------------------------------------------------------------------

                                                 *
Tails                                            *Obj0E_Tails:
                                                 *        moveq   #0,d0
        lda   routine_secondary,u                *        move.b  routine_secondary(a0),d0
        sta   *+4,pcr                            *        move.w  off_13074(pc,d0.w),d1
        bra   Tails_Routines                     *        jmp     off_13074(pc,d1.w)
                                                 *; ===========================================================================
Tails_Routines                                   *off_13074:      offsetTable
        lbra  Tails_Init                         *                offsetTableEntry.w Obj0E_Tails_Init                     ; 0
        lbra  Tails_Move                         *                offsetTableEntry.w loc_13096                    ; 2
        lbra  TitleScreen_Animate                *                offsetTableEntry.w loc_12F52                    ; 4
        lbra  Tails_CreateHand                   *                offsetTableEntry.w loc_130A2                    ; 6
        lbra  Tails_DisplaySprite                *                offsetTableEntry.w BranchTo10_DisplaySprite     ; 8
                                                 *; ===========================================================================
                                                 *
Tails_Init                                       *Obj0E_Tails_Init:
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        ldd   #$5C67
        std   xy_pixel,u                         *        move.w  #$D8,x_pixel(a0)
                                                 *        move.w  #$D8,y_pixel(a0)
        ldb   #$05
        stb   priority,u                                                 
        ldd   #Ani_tails
        std   anim,u                             *        move.b  #1,anim(a0)
        ldd   #Img_tails_1                       ; in original code, mapping_frame is an index in offset table (1 byte) that is implicitly initialized to 0
        std   image_set,u                     ; so added init code to mapping_frame address here because it is not an index anymore
        rts                                      *        rts
                                                 *; ===========================================================================
                                                 *
Tails_Move                                       *loc_13096:
        ldx   #Tails_xy_data_end-Tails_xy_data+2
        stx   dyn_01+2,pcr                       *        moveq   #word_130B8_end-word_130B8+4,d2
        leax  <Tails_xy_data-2,pcr               *        lea     (word_130B8).l,a1
        lbra  TitleScreen_MoveObjects            *        bra.w   loc_12F20
                                                 *; ===========================================================================
                                                 *
Tails_CreateHand                                 *loc_130A2:
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        ldx   #Obj_TailsHand                     *        lea     (IntroTailsHand).w,a1
        lda   #ObjID_TitleScreen                 *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E (flashing intro star) at $FFFFB200
        sta   id,x
        lda   #Sub_TailsHand
        sta   subtype,x                          *        move.b  #$10,subtype(a1)                        ; Tails' hand
        
        * Change sprite to overlay
        lda   render_flags,u
        ora   #render_overlay_mask!render_motionless_mask
        sta   render_flags,u
        
                                                 *
Tails_DisplaySprite                              *BranchTo10_DisplaySprite
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
Tails_xy_data                                    *word_130B8:
        fcb   $5B,$57                            *        dc.w   $D7,$C8
        fcb   $59,$47                            *        dc.w   $D3,$B8  ; 2
        fcb   $57,$3B                            *        dc.w   $CE,$AC  ; 4
        fcb   $56,$35                            *        dc.w   $CC,$A6  ; 6
        fcb   $55,$31                            *        dc.w   $CA,$A2  ; 8
        fcb   $54,$30                            *        dc.w   $C9,$A1  ; $A
        fcb   $54,$2F                            *        dc.w   $C8,$A0  ; $C
Tails_xy_data_end                                *word_130B8_end
                                                 *; ===========================================================================

* ---------------------------------------------------------------------------
* EmblemFront
* ---------------------------------------------------------------------------

                                                 *
EmblemFront                                      *Obj0E_LogoTop:
                                                 *        moveq   #0,d0
        lda   routine_secondary,u                *        move.b  routine_secondary(a0),d0
        sta   *+4,pcr                            *        move.w  off_130E2(pc,d0.w),d1
        bra   EmblemFront_Routines               *        jmp     off_130E2(pc,d1.w)
                                                 *; ===========================================================================
EmblemFront_Routines                             *off_130E2:      offsetTable
        lbra  EmblemFront_Init                   *                offsetTableEntry.w Obj0E_LogoTop_Init                   ; 0
        lbra  TitleScreen_NextSubRoutineAndDisplay        
        lbra  EmblemFront_DisplaySprite          *                offsetTableEntry.w BranchTo11_DisplaySprite     ; 2
                                                 *; ===========================================================================
                                                 *
EmblemFront_Init                                 *Obj0E_LogoTop_Init:
        * not implemented                        *        move.b  #$B,mapping_frame(a0)
        * trademark logo for PAL                 *        tst.b   (Graphics_Flags).w
        * game version                           *        bmi.s   +
        lda   render_flags,u
        ora   #render_overlay_mask!render_motionless_mask
        sta   render_flags,u
        * initialized in object creation         *        move.b  #$A,mapping_frame(a0)
                                                 *+
        ldb   #$02
        stb   priority,u                         *        move.b  #2,priority(a0)
        ldd   #$807F
        std   xy_pixel,u                         *        move.w  #$120,x_pixel(a0)
                                                 *        move.w  #$E8,y_pixel(a0)
                                                 *
TitleScreen_NextSubRoutineAndDisplay             *loc_1310A:
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
                                                 *
                                                 *BranchTo11_DisplaySprite
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
        
EmblemFront_DisplaySprite
        * Overlay sprite will never change priority, this code is faster than calling DisplaySprite
        * We just need to call DisplaySprite two times (one for each buffer)
        lda   render_flags,u
        anda  #:render_hide_mask
        sta   render_flags,u
        rts        
                                                 *; ===========================================================================

* ---------------------------------------------------------------------------
* EmblemBack
* ---------------------------------------------------------------------------

EmblemBack
        lda   routine_secondary,u
        sta   *+4,pcr
        bra   EmblemBack_Routines

EmblemBack_Routines
        lbra  EmblemBack_Init    
        lbra  TitleScreen_NextSubRoutineAndDisplay        
        lbra  EmblemFront_DisplaySprite 

EmblemBack_Init
        lda   render_flags,u
        ora   #render_overlay_mask!render_motionless_mask
        sta   render_flags,u
        ldb   #$06
        stb   priority,u
        ldd   #$807F
        std   xy_pixel,u
        bra   TitleScreen_NextSubRoutineAndDisplay

* ---------------------------------------------------------------------------
* Sky Piece
* - use a VDP functionality that hide lines of lower priority
*   sprites, when a higher priority sprite is at x=0 position
* ---------------------------------------------------------------------------

                                                 *
        * not implemented                        *Obj0E_SkyPiece:
        * not implemented                        *        moveq   #0,d0
        * not implemented                        *        move.b  routine_secondary(a0),d0
        * not implemented                        *        move.w  off_13120(pc,d0.w),d1
        * not implemented                        *        jmp     off_13120(pc,d1.w)
        * not implemented                        *; ===========================================================================
        * not implemented                        *off_13120:      offsetTable
        * not implemented                        *                offsetTableEntry.w Obj0E_SkyPiece_Init                  ; 0
        * not implemented                        *                offsetTableEntry.w BranchTo12_DisplaySprite     ; 2
        * not implemented                        *; ===========================================================================
        * not implemented                        *
        * not implemented                        *Obj0E_SkyPiece_Init:
        * not implemented
        * not implemented                        *        addq.b  #2,routine_secondary(a0)
        * not implemented                        *        move.w  #make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0)
        * not implemented
        * not implemented                        *        move.b  #$11,mapping_frame(a0)
        * not implemented                        *        move.b  #2,priority(a0)
        * not implemented                        *        move.w  #$100,x_pixel(a0)
        * not implemented                        *        move.w  #$F0,y_pixel(a0)
        * not implemented                        *
        * not implemented                        *BranchTo12_DisplaySprite
        * not implemented                        *        bra.w   DisplaySprite
        * not implemented                        *; ===========================================================================

* ---------------------------------------------------------------------------
* Large Star
* ---------------------------------------------------------------------------

                                                 *
LargeStar                                        *Obj0E_LargeStar:
                                                 *        moveq   #0,d0
        lda   routine_secondary,u                *        move.b  routine_secondary(a0),d0
        sta   *+4,pcr                            *        move.w  off_13158(pc,d0.w),d1
        bra   LargeStar_Routines                 *        jmp     off_13158(pc,d1.w)
                                                 *; ===========================================================================
LargeStar_Routines                               *off_13158:      offsetTable
        lbra  LargeStar_Init                     *                offsetTableEntry.w Obj0E_LargeStar_Init ; 0
        lbra  TitleScreen_Animate                *                offsetTableEntry.w loc_12F52    ; 2
        lbra  LargeStar_Wait                     *                offsetTableEntry.w loc_13190    ; 4
        lbra  LargeStar_Move                     *                offsetTableEntry.w loc_1319E    ; 6
                                                 *; ===========================================================================
                                                 *
LargeStar_Init                                   *Obj0E_LargeStar_Init:
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        ldd   #Img_star_2
        std   image_set,u                        *        move.b  #$C,mapping_frame(a0)
        * not implemented                        *        ori.w   #high_priority,art_tile(a0)
        ldd   #Ani_largeStar
        std   anim,u                             *        move.b  #2,anim(a0)
        ldb   #$01
        stb   priority,u                         *        move.b  #1,priority(a0)
        ldd   #$7037
        std   xy_pixel,u                         *        move.w  #$100,x_pixel(a0)
                                                 *        move.w  #$A8,y_pixel(a0)
        ldd   #4
        std   w_TitleScr_move_frame_count,u      *        move.w  #4,objoff_2A(a0)
        rts                                      *        rts
                                                 *; ===========================================================================
                                                 *
LargeStar_Wait                                   *loc_13190:
        ldd   w_TitleScr_move_frame_count,u
        subd  #1                                 *        subq.w  #1,objoff_2A(a0)
        std   w_TitleScr_move_frame_count,u
        bmi   LargeStar_AfterWait                *        bmi.s   +
        rts                                      *        rts
                                                 *; ===========================================================================
LargeStar_AfterWait                              *+
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        rts                                      *        rts
                                                 *; ===========================================================================
                                                 *
LargeStar_Move                                   *loc_1319E:
        ldd   #$0300
        sta   routine_secondary,u                *        move.b  #2,routine_secondary(a0)
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
        fcb   $5D,$81                            *        dc.w   $DA, $F2
        fcb   $A8,$87                            *        dc.w  $170, $F8 ; 2
        fcb   $89,$C0                            *        dc.w  $132,$131 ; 4
        fcb   $BF,$31                            *        dc.w  $19E, $A2 ; 6
        fcb   $50,$72                            *        dc.w   $C0, $E3 ; 8
        fcb   $B0,$6F                            *        dc.w  $180, $E0 ; $A
        fcb   $76,$CA                            *        dc.w  $10D,$13B ; $C
        fcb   $50,$3A                            *        dc.w   $C0, $AB ; $E
        fcb   $A2,$96                            *        dc.w  $165, $107        ; $10
LargeStar_xy_data_end                            *word_131DC_end
                                                 *; ===========================================================================

* ---------------------------------------------------------------------------
* Sonic Hand
* ---------------------------------------------------------------------------

                                                 *
SonicHand                                        *Obj0E_SonicHand:
                                                 *        moveq   #0,d0
        lda   routine_secondary,u                *        move.b  routine_secondary(a0),d0
        sta   *+4,pcr                            *        move.w  off_1320E(pc,d0.w),d1
        bra   SonicHand_Routines                 *        jmp     off_1320E(pc,d1.w)
                                                 *; ===========================================================================
SonicHand_Routines                               *off_1320E:      offsetTable
        lbra  SonicHand_Init                     *                offsetTableEntry.w Obj0E_SonicHand_Init                 ; 0
        lbra  SonicHand_Move                     *                offsetTableEntry.w loc_13234                    ; 2
        lbra  SonicHand_DisplaySprite            *                offsetTableEntry.w BranchTo13_DisplaySprite     ; 4
                                                 *; ===========================================================================
                                                 *
SonicHand_Init                                   *Obj0E_SonicHand_Init:
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        ldd   #Img_sonicHand
        std   image_set,u                        *        move.b  #9,mapping_frame(a0)
        lda   #3
        sta   priority,u                         *        move.b  #3,priority(a0)
        ldd   #$924E
        std   xy_pixel,u                         *        move.w  #$145,x_pixel(a0)
                                                 *        move.w  #$BF,y_pixel(a0)
                                                 *
        jmp   DisplaySprite
                                                 
SonicHand_DisplaySprite                          *BranchTo13_DisplaySprite
        * Change sprite to overlay
        lda   render_flags,u
        ora   #render_overlay_mask!render_motionless_mask
        sta   render_flags,u
        
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *
SonicHand_Move                                   *loc_13234:
        ldx   #SonicHand_xy_data_end-SonicHand_xy_data+2
        stx   dyn_01+2,pcr                       *        moveq   #word_13240_end-word_13240+4,d2
        leax  <SonicHand_xy_data-2,pcr           *        lea     (word_13240).l,a1
        lbra  TitleScreen_MoveObjects            *        bra.w   loc_12F20
                                                 *; ===========================================================================
SonicHand_xy_data                                *word_13240:
        fcb   $91,$50                            *        dc.w  $143, $C1
        fcb   $90,$51                            *        dc.w  $140, $C2 ; 2
        fcb   $90,$50                            *        dc.w  $141, $C1 ; 4
SonicHand_xy_data_end                            *word_13240_end
                                                 *; ===========================================================================

* ---------------------------------------------------------------------------
* Tails Hand
* ---------------------------------------------------------------------------

                                                 *
TailsHand                                        *Obj0E_TailsHand:
                                                 *        moveq   #0,d0
        lda   routine_secondary,u                *        move.b  routine_secondary(a0),d0
        sta   *+4,pcr                            *        move.w  off_1325A(pc,d0.w),d1
        bra   TailsHand_Routines                 *        jmp     off_1325A(pc,d1.w)
                                                 *; ===========================================================================
TailsHand_Routines                               *off_1325A:      offsetTable
        lbra  TailsHand_Init                     *                offsetTableEntry.w Obj0E_TailsHand_Init                 ; 0
        lbra  TailsHand_Move                     *                offsetTableEntry.w loc_13280                    ; 2
        lbra  TailsHand_DisplaySprite            *                offsetTableEntry.w BranchTo14_DisplaySprite     ; 4
                                                 *; ===========================================================================
                                                 *
TailsHand_Init                                   *Obj0E_TailsHand_Init:
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        ldd   #Img_tailsHand
        std   image_set,u                        *        move.b  #$13,mapping_frame(a0)
        lda   #3
        sta   priority,u                         *        move.b  #3,priority(a0)
        ldd   #$7764
        std   xy_pixel,u                         *        move.w  #$10F,x_pixel(a0)
                                                 *        move.w  #$D5,y_pixel(a0)
                                                 *
        jmp   DisplaySprite
                                                         
TailsHand_DisplaySprite                          *BranchTo14_DisplaySprite
        * Change sprite to overlay
        lda   render_flags,u
        ora   #render_overlay_mask!render_motionless_mask
        sta   render_flags,u
        
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *
TailsHand_Move                                   *loc_13280:
        ldx   #TailsHand_xy_data_end-TailsHand_xy_data+2
        stx   dyn_01+2,pcr                       *        moveq   #word_1328C_end-word_1328C+4,d2
        leax  <TailsHand_xy_data-2,pcr           *        lea     (word_1328C).l,a1
        lbra  TitleScreen_MoveObjects            *        bra.w   loc_12F20
                                                 *; ===========================================================================
TailsHand_xy_data                                *word_1328C:
        fcb   $76,$5F                            *        dc.w  $10C, $D0
        fcb   $76,$60                            *        dc.w  $10D, $D1 ; 2
TailsHand_xy_data_end                            *word_1328C_end
                                                 *; ===========================================================================

* ---------------------------------------------------------------------------
* Small Star
* ---------------------------------------------------------------------------

                                                 *
SmallStar                                        *Obj0E_SmallStar:
                                                 *        moveq   #0,d0
        lda   routine_secondary,u                *        move.b  routine_secondary(a0),d0
        sta   *+4,pcr                            *        move.w  off_132A2(pc,d0.w),d1
        bra   SmallStar_Routines                 *        jmp     off_132A2(pc,d1.w)
                                                 *; ===========================================================================
SmallStar_Routines                               *off_132A2:      offsetTable
        lbra  SmallStar_Init                     *                offsetTableEntry.w Obj0E_SmallStar_Init ; 0
        lbra  SmallStar_Move                     *                offsetTableEntry.w loc_132D2    ; 2
                                                 *; ===========================================================================
                                                 *
SmallStar_Init                                   *Obj0E_SmallStar_Init:
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        ldd   #Img_star_2
        std   image_set,u                        *        move.b  #$C,mapping_frame(a0)
        lda   #7
        sta   priority,u                         *        move.b  #5,priority(a0)
        ldd   #$A80F
        std   xy_pixel,u                         *        move.w  #$170,x_pixel(a0)
                                                 *        move.w  #$80,y_pixel(a0)
        ldd   #Ani_smallStar
        std   anim,u                             *        move.b  #3,anim(a0)
        ldd   #$71
        std   w_TitleScr_time_frame_countdown,u  *        move.w  #$8C,objoff_2A(a0)
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *
SmallStar_Move                                   *loc_132D2:
        ldd   w_TitleScr_time_frame_countdown,u
        subd  #1                                 *        subq.w  #1,objoff_2A(a0)
        std   w_TitleScr_time_frame_countdown,u
        bpl   SmallStar_MoveContinue
        jmp   DeleteObject                       *        bmi.w   DeleteObject
SmallStar_MoveContinue
        dec   x_pixel,u                          *        subq.w  #2,x_pixel(a0)
        inc   y_pixel,u                          *        addq.w  #1,y_pixel(a0)
        * no more offset table                   *        lea     (Ani_obj0E).l,a1
        jsr   AnimateSprite                      *        bsr.w   AnimateSprite
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================

* ---------------------------------------------------------------------------
* Island
* ---------------------------------------------------------------------------

Island

        lda   routine_secondary,u
        sta   *+4,pcr
        bra   Island_Routines

Island_Routines
        lbra  Island_Init
        lbra  Island_Move
        lbra  Island_Display

Island_Init
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u
        ldd   #Img_island
        std   image_set,u
        lda   #7
        sta   priority,u
        ldd   #$97BB
        std   xy_pixel,u

        ldd   #$30
        std   w_TitleScr_time_frame_countdown,u
        jmp   DisplaySprite

Island_Move
        ldd   w_TitleScr_time_frame_countdown,u
        subd  #1
        std   w_TitleScr_time_frame_countdown,u
        bpl   Island_MoveContinue
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u

Island_MoveContinue
        dec   x_pixel,u
Island_Display              
        jmp   DisplaySprite

* ---------------------------------------------------------------------------
* Subroutines
* ---------------------------------------------------------------------------

                                                 *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
TitleScreen_SetFinalState_rts                    *
        rts                                      *
TitleScreen_SetFinalState                        *TitleScreen_SetFinalState:
        tst   b_TitleScr_final_state,u           *        tst.b   objoff_2F(a0)
        bne  TitleScreen_SetFinalState_rts       *        bne.w   +       ; rts
        lda   Fire_Press                         *        move.b  (Ctrl_1_Press).w,d0
                                                 *        or.b    (Ctrl_2_Press).w,d0
        anda  #c1_button_A_mask!c2_button_A_mask *        andi.b  #button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_B_mask|button_C_mask|button_A_mask,(Ctrl_1_Press).w
                                                 *        andi.b  #button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_B_mask|button_C_mask|button_A_mask,(Ctrl_2_Press).w
                                                 *        andi.b  #button_start_mask,d0
        beq  TitleScreen_SetFinalState_rts       *        beq.w   +       ; rts
        ldd   #$FF
        std   b_TitleScr_final_state,u           *        st.b    objoff_2F(a0)
        lda   #24
        sta   routine_secondary,u                *        move.b  #$10,routine_secondary(a0)
        ldd   #Img_sonic_4
        std   image_set,u                        *        move.b  #$12,mapping_frame(a0)
        ldd   #$7427
        std   xy_pixel,u                         *        move.w  #$108,x_pixel(a0)
                                                 *        move.w  #$98,y_pixel(a0)
        ldx   #Obj_SonicHand                     *        lea     (IntroSonicHand).w,a1
        * not implemented                        *        bsr.w   TitleScreen_InitSprite
        lda   #ObjID_TitleScreen                 *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E (flashing intro star) at $FFFFB1C0
        sta   id,x
        lda   #Sub_SonicHand
        sta   routine,x                          *        move.b  #$A,routine(a1)                         ; Sonic's hand
        lda   #2
        sta   priority,x                         *        move.b  #2,priority(a1)
        ldd   #Img_sonicHand
        std   image_set,x                        *        move.b  #9,mapping_frame(a1)
        lda   #6
        sta   routine_secondary,x                *        move.b  #4,routine_secondary(a1)
        ldd   #$9050
        std   xy_pixel,x                         *        move.w  #$141,x_pixel(a1)
                                                 *        move.w  #$C1,y_pixel(a1)
        ldx   #Obj_Tails                         *        lea     (IntroTails).w,a1
        * not implemented                        *        bsr.w   TitleScreen_InitSprite
        lda   #ObjID_TitleScreen        
        sta   id,x                               *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E
        lda   #Sub_Tails
        sta   routine,x                          *        move.b  #4,routine(a1)                          ; Tails
        ldd   #Img_tails_5
        std   image_set,x                        *        move.b  #4,mapping_frame(a1)
        lda   #9
        sta   routine_secondary,x                *        move.b  #6,routine_secondary(a1)
        lda   #5
        sta   priority,x                         *        move.b  #3,priority(a1)
        ldd   #$542F
        std   xy_pixel,x                         *        move.w  #$C8,x_pixel(a1)
                                                 *        move.w  #$A0,y_pixel(a1)
        ldx   #Obj_TailsHand                     *        lea     (IntroTailsHand).w,a1
        * not implemented                        *        bsr.w   TitleScreen_InitSprite
        lda   #ObjID_TitleScreen        
        sta   id,x                               *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E
        ldd   #Sub_TailsHand
        sta   routine,x                          *        move.b  #$10,routine(a1)                        ; Tails' hand
        ldb   #$02        
        stb   priority,x                         *        move.b  #2,priority(a1)
        ldd   #Img_tailsHand
        std   image_set,x                        *        move.b  #$13,mapping_frame(a1)
        lda   #6
        sta   routine_secondary,x                *        move.b  #4,routine_secondary(a1)
        ldd   #$7660
        std   xy_pixel,x                         *        move.w  #$10D,x_pixel(a1)
                                                 *        move.w  #$D1,y_pixel(a1)
        *ldx   Obj_EmblemFront                   *        lea     (IntroEmblemTop).w,a1
        *lda   #ObjID_TitleScreen        
        *sta   id,x                              *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E
        *lda   #Sub_EmblemFront
        *sta   subtype,x                         *        move.b  #6,subtype(a1)                          ; logo top
        * not implemented                        *        bsr.w   sub_12F08
        * not implemented                        *        move.b  #ObjID_TitleMenu,(TitleScreenMenu+id).w ; load Obj0F (title screen menu) at $FFFFB400
        *ldx   #Obj_PaletteHandler               *        lea     (TitleScreenPaletteChanger).w,a1
        *jsr   DeleteObject2                     *        bsr.w   DeleteObject2
                                                 *        lea_    Pal_1342C,a1
                                                 *        lea     (Normal_palette_line4).w,a2
                                                 *
                                                 *        moveq   #7,d6
                                                 *-       move.l  (a1)+,(a2)+
                                                 *        dbf     d6,-
                                                 *
                                                 *        lea_    Pal_1340C,a1
                                                 *        lea     (Normal_palette_line3).w,a2
                                                 *
                                                 *        moveq   #7,d6
                                                 *-       move.l  (a1)+,(a2)+
                                                 *        dbf     d6,-
                                                 *
                                                 *        lea_    Pal_133EC,a1
                                                 *        lea     (Normal_palette).w,a2
                                                 *
                                                 *        moveq   #7,d6
                                                 *-       move.l  (a1)+,(a2)+
                                                 *        dbf     d6,-
        *clr   Obj_PaletteHandler3+paletteHander_fadein_amount
                                                 *        sf.b    (TitleScreenPaletteChanger+paletteHander_fadein_amount).w ; MJ: set fade counter to 00 (finish)
                                                 *
        tst   b_TitleScr_music_is_playing        *        tst.b   objoff_30(a0)
        bne   TitleScreen_SetFinalState_end      *        bne.s   +       ; rts
        ldx   #Psg_TitleScreen *@IgnoreUndefined *        moveq   #MusID_Title,d0 ; title music
        jmp   PSGPlayNoRepeat                    *        jsrto   (PlayMusic).l, JmpTo4_PlayMusic
TitleScreen_SetFinalState_end                    *+
        rts                                      *        rts
                                                 *; End of function sub_134BC
                                                 *
                                                 *
                                                 *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                                 *
                                                 *
                                                 *;sub_135EA:
                                                 *TitleScreen_InitSprite:
                                                 *
        * vdp unused                             *        move.l  #Obj0E_MapUnc_136A8,mappings(a1)
        * vdp unused                             *        move.w  #make_art_tile(ArtTile_ArtNem_TitleSprites,0,0),art_tile(a1)
        * not implemented is override later      *        move.b  #4,priority(a1)
        * rts                                    *        rts
                                                 *; End of function TitleScreen_InitSprite
                                                 *
                                                 *; ===========================================================================

Pal_TitleScreenRaster
        fdb   $0e00 * 132-147
        fdb   $0c00	* 181-131
        fdb   $0c00	* 181-131
        fdb   $0e00 * 132-147
        fdb   $0c00	* 181-131
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0b10	* 148-154
        fdb   $0e00 * 132-147
        fdb   $0b10	* 148-154
        fdb   $0b10	* 148-154
        fdb   $0e00 * 132-147
        fdb   $0b10	* 148-154
        fdb   $0b10	* 148-154
        fdb   $0b10	* 148-154
        fdb   $0b10	* 148-154
        fdb   $0b10	* 148-154
        fdb   $0c10	* 155-157
        fdb   $0b10	* 148-154
        fdb   $0c10	* 155-157
        fdb   $0a21	* 158-161
        fdb   $0c10	* 155-157
        fdb   $0a21	* 158-161
        fdb   $0a21	* 158-161
        fdb   $0b41	* 162-164
		fdb   $0a21	* 158-161
        fdb   $0b41	* 162-164
        fdb   $0a52	* 165-167
		fdb   $0b41	* 162-164
        fdb   $0a52	* 165-167
        fdb   $0b74	* 168-171
		fdb   $0a52	* 165-167
        fdb   $0b74	* 168-171
		fdb   $0b74	* 168-171
        fdb   $0b97	* 172-174
		fdb   $0b74	* 168-171
        fdb   $0b97	* 172-174
        fdb   $0bbb	* 175-180
		fdb   $0b97	* 172-174
        fdb   $0bbb	* 175-180
		fdb   $0bbb	* 175-180
		fdb   $0bbb	* 175-180
		fdb   $0bbb	* 175-180
		fdb   $0bbb	* 175-180
		fdb   $0bbb	* 175-180
        fdb   $0c00	* 181-131
Pal_TitleScreenRaster_end        

* ---------------------------------------------------------------------------
* Animation script is generated - for reference only
* ---------------------------------------------------------------------------

                                                 *; animation script
                                                 *; off_13686:
                                                 *Ani_obj0E:      offsetTable
                                                 *                offsetTableEntry.w byte_1368E   ; 0
                                                 *                offsetTableEntry.w byte_13694   ; 1
                                                 *                offsetTableEntry.w byte_1369C   ; 2
                                                 *                offsetTableEntry.w byte_136A4   ; 3
                                                 *byte_1368E:
                                                 *        dc.b   1
                                                 *        dc.b   5        ; 1
                                                 *        dc.b   6        ; 2
                                                 *        dc.b   7        ; 3
                                                 *        dc.b   8        ; 4
                                                 *        dc.b $FA        ; 5
                                                 *        even
                                                 *byte_13694:
                                                 *        dc.b   1
                                                 *        dc.b   0        ; 1
                                                 *        dc.b   1        ; 2
                                                 *        dc.b   2        ; 3
                                                 *        dc.b   3        ; 4
                                                 *        dc.b   4        ; 5
                                                 *        dc.b $FA        ; 6
                                                 *        even
                                                 *byte_1369C:
                                                 *        dc.b   1
                                                 *        dc.b  $C        ; 1
                                                 *        dc.b  $D        ; 2
                                                 *        dc.b  $E        ; 3
                                                 *        dc.b  $D        ; 4
                                                 *        dc.b  $C        ; 5
                                                 *        dc.b $FA        ; 6
                                                 *        even
                                                 *byte_136A4:
                                                 *        dc.b   3
                                                 *        dc.b  $C        ; 1
                                                 *        dc.b  $F        ; 2
                                                 *        dc.b $FF        ; 3
                                                 *        even
                                                 *; -----------------------------------------------------------------------------
                                                 *; Sprite Mappings - Flashing stars from intro (Obj0E)
                                                 *; -----------------------------------------------------------------------------
                                                 *Obj0E_MapUnc_136A8:     BINCLUDE "mappings/sprite/obj0E.bin"
                                                 *; -----------------------------------------------------------------------------
                                                 *; sprite mappings
                                                 *; -----------------------------------------------------------------------------
                                                 *Obj0F_MapUnc_13B70:     BINCLUDE "mappings/sprite/obj0F.bin"
                                                 *
                                                 *    if ~~removeJmpTos
                                                 *JmpTo4_PlaySound ; JmpTo
                                                 *        jmp     (PlaySound).l
                                                 *JmpTo4_PlayMusic ; JmpTo
                                                 *        jmp     (PlayMusic).l
                                                 *
                                                 *        align 4
                                                 *    endif
                                                         

(include)GLOBALS
* Generated Code

GameModeLoader equ $414F
current_game_mode_data equ $41C7
ObjID_SonicAndTailsIn equ 1
ObjID_SEGA equ 2
ObjID_PaletteHandler equ 3
ObjID_TitleScreen equ 4
Glb_Sprite_Screen_Pos_Part1 equ $6122
Glb_Sprite_Screen_Pos_Part2 equ $6124
Object_RAM equ $6610
screen_border_color equ $7162
Vint_runcount equ $7188
c1_button_up_mask equ $0001
c1_button_down_mask equ $0002
c1_button_left_mask equ $0004
c1_button_right_mask equ $0008
c2_button_up_mask equ $0010
c2_button_down_mask equ $0020
c2_button_left_mask equ $0040
c2_button_right_mask equ $0080
c1_button_A_mask equ $0040
c2_button_A_mask equ $0080
Joypads_Held equ $718C
Dpad_Held equ $718C
Fire_Held equ $718D
Joypads_Press equ $718E
Dpad_Press equ $718E
Fire_Press equ $718F
MarkObjGone equ $71F9
DisplaySprite_x equ $71FB
DisplaySprite equ $7201
AnimateSprite equ $727A
DeleteObject_x equ $733F
DeleteObject equ $7345
ClearObj equ $7407
ClearCartMem equ $7CB7
Refresh_palette equ $7CF1
Cur_palette equ $7CF2
Dyn_palette equ $7CF4
Black_palette equ $7D14
White_palette equ $7D34
UpdatePalette equ $7D54
PlayPCM equ $7D7C
PSGInit equ $7DD3
PSGPlayNoRepeat equ $7DE5
PSGStop equ $7E13
PSGResume equ $7E3C
PSGCancelLoop equ $7E87
PSGGetStatus equ $7E8B
PSGSetMusicVolumeAttenuation equ $7E8F
PSGSilenceChannels equ $7EEE
PSGRestoreVolumes equ $7F03
PSGSFXPlayLoop equ $7F77
PSGSFXStop equ $7FC3
PSGSFXCancelLoop equ $8039
PSGSFXGetStatus equ $803D
PSGFrame equ $8041
_sendVolume2PSG equ $80FB
PSGSFXFrame equ $814E
_SFXsetLoopPoint equ $81AB
irq_routine equ $6027
irq_timer_ctrl equ $E7C5
irq_timer equ $E7C6
irq_one_frame equ $4DFF
Irq_Raster_Page equ $81F7
Irq_Raster_Start equ $81F9
Irq_Raster_End equ $81FB
IrqOn equ $81FD
IrqOff equ $8208
IrqSync equ $8213
IrqPsg equ $8232
IrqPsgRaster equ $8241
Img_SonicAndTailsIn equ $8278
Img_SegaLogo_2 equ $8288
Img_SegaLogo_1 equ $8298
Img_SegaTrails_1 equ $82A8
Img_SegaSonic_12 equ $82C1
Img_SegaSonic_23 equ $82E2
Img_SegaSonic_13 equ $8303
Img_SegaSonic_32 equ $8324
Img_SegaSonic_21 equ $8345
Img_SegaSonic_43 equ $8366
Img_SegaSonic_11 equ $8387
Img_SegaSonic_33 equ $83A8
Img_SegaSonic_22 equ $83C9
Img_SegaSonic_41 equ $83EA
Img_SegaSonic_31 equ $840B
Img_SegaSonic_42 equ $842C
Img_SegaTrails_6 equ $844D
Img_SegaTrails_5 equ $845D
Img_SegaTrails_4 equ $846D
Img_SegaTrails_3 equ $847D
Img_SegaTrails_2 equ $848D
Img_star_4 equ $84A6
Img_star_3 equ $84BA
Img_sonicHand equ $84CE
Img_star_2 equ $84E5
Img_star_1 equ $8500
Img_emblemBack08 equ $851B
Img_emblemBack07 equ $852B
Img_emblemBack09 equ $853B
Img_emblemBack04 equ $854B
Img_emblemBack03 equ $855B
Img_emblemBack06 equ $856B
Img_emblemBack05 equ $857B
Img_tails_5 equ $858B
Img_tails_4 equ $85A2
Img_tails_3 equ $85B6
Img_tails_2 equ $85CA
Img_tails_1 equ $85DE
Img_tailsHand equ $85F2
Img_island equ $8609
Img_sonic_1 equ $861D
Img_sonic_2 equ $8631
Img_emblemBack02 equ $8645
Img_emblemBack01 equ $8655
Img_sonic_3 equ $8665
Img_sonic_4 equ $8679
Img_emblemFront07 equ $8690
Img_emblemFront08 equ $86A0
Img_emblemFront05 equ $86B0
Img_emblemFront06 equ $86C0
Img_emblemFront03 equ $86D0
Img_emblemFront04 equ $86E0
Img_emblemFront01 equ $86F0
Img_emblemFront02 equ $8700
Ani_SegaSonic_3 equ $8711
Ani_SegaSonic_2 equ $871B
Ani_SegaSonic_1 equ $8725
Ani_smallStar equ $872F
Ani_largeStar equ $8735
Ani_tails equ $8741
Ani_sonic equ $874D
Glb_Sprite_Screen_Pos_Part1 equ $6122
Glb_Sprite_Screen_Pos_Part2 equ $6124
Object_RAM equ $6610
screen_border_color equ $7162
Vint_runcount equ $7188
c1_button_up_mask equ $0001
c1_button_down_mask equ $0002
c1_button_left_mask equ $0004
c1_button_right_mask equ $0008
c2_button_up_mask equ $0010
c2_button_down_mask equ $0020
c2_button_left_mask equ $0040
c2_button_right_mask equ $0080
c1_button_A_mask equ $0040
c2_button_A_mask equ $0080
Joypads_Held equ $718C
Dpad_Held equ $718C
Fire_Held equ $718D
Joypads_Press equ $718E
Dpad_Press equ $718E
Fire_Press equ $718F
MarkObjGone equ $71F9
DisplaySprite_x equ $71FB
DisplaySprite equ $7201
AnimateSprite equ $727A
DeleteObject_x equ $733F
DeleteObject equ $7345
ClearObj equ $7407
ClearCartMem equ $7CB7
Refresh_palette equ $7CF1
Cur_palette equ $7CF2
Dyn_palette equ $7CF4
Black_palette equ $7D14
White_palette equ $7D34
UpdatePalette equ $7D54
PlayPCM equ $7D7C
PSGInit equ $7DD3
PSGPlayNoRepeat equ $7DE5
PSGStop equ $7E13
PSGResume equ $7E3C
PSGCancelLoop equ $7E87
PSGGetStatus equ $7E8B
PSGSetMusicVolumeAttenuation equ $7E8F
PSGSilenceChannels equ $7EEE
PSGRestoreVolumes equ $7F03
PSGSFXPlayLoop equ $7F77
PSGSFXStop equ $7FC3
PSGSFXCancelLoop equ $8039
PSGSFXGetStatus equ $803D
PSGFrame equ $8041
_sendVolume2PSG equ $80FB
PSGSFXFrame equ $814E
_SFXsetLoopPoint equ $81AB
irq_routine equ $6027
irq_timer_ctrl equ $E7C5
irq_timer equ $E7C6
irq_one_frame equ $4DFF
Irq_Raster_Page equ $81F7
Irq_Raster_Start equ $81F9
Irq_Raster_End equ $81FB
IrqOn equ $81FD
IrqOff equ $8208
IrqSync equ $8213
IrqPsg equ $8232
IrqPsgRaster equ $8241
Img_SonicAndTailsIn equ $8278
Img_SegaLogo_2 equ $8288
Img_SegaLogo_1 equ $8298
Img_SegaTrails_1 equ $82A8
Img_SegaSonic_12 equ $82C1
Img_SegaSonic_23 equ $82E2
Img_SegaSonic_13 equ $8303
Img_SegaSonic_32 equ $8324
Img_SegaSonic_21 equ $8345
Img_SegaSonic_43 equ $8366
Img_SegaSonic_11 equ $8387
Img_SegaSonic_33 equ $83A8
Img_SegaSonic_22 equ $83C9
Img_SegaSonic_41 equ $83EA
Img_SegaSonic_31 equ $840B
Img_SegaSonic_42 equ $842C
Img_SegaTrails_6 equ $844D
Img_SegaTrails_5 equ $845D
Img_SegaTrails_4 equ $846D
Img_SegaTrails_3 equ $847D
Img_SegaTrails_2 equ $848D
Img_star_4 equ $84A6
Img_star_3 equ $84BA
Img_sonicHand equ $84CE
Img_star_2 equ $84E5
Img_star_1 equ $8500
Img_emblemBack08 equ $851B
Img_emblemBack07 equ $852B
Img_emblemBack09 equ $853B
Img_emblemBack04 equ $854B
Img_emblemBack03 equ $855B
Img_emblemBack06 equ $856B
Img_emblemBack05 equ $857B
Img_tails_5 equ $858B
Img_tails_4 equ $85A2
Img_tails_3 equ $85B6
Img_tails_2 equ $85CA
Img_tails_1 equ $85DE
Img_tailsHand equ $85F2
Img_island equ $8609
Img_sonic_1 equ $861D
Img_sonic_2 equ $8631
Img_emblemBack02 equ $8645
Img_emblemBack01 equ $8655
Img_sonic_3 equ $8665
Img_sonic_4 equ $8679
Img_emblemFront07 equ $8690
Img_emblemFront08 equ $86A0
Img_emblemFront05 equ $86B0
Img_emblemFront06 equ $86C0
Img_emblemFront03 equ $86D0
Img_emblemFront04 equ $86E0
Img_emblemFront01 equ $86F0
Img_emblemFront02 equ $8700
Ani_SegaSonic_3 equ $8711
Ani_SegaSonic_2 equ $871B
Ani_SegaSonic_1 equ $8725
Ani_smallStar equ $872F
Ani_largeStar equ $8735
Ani_tails equ $8741
Ani_sonic equ $874D
Pcm_SEGA equ $8A56
Psg_TitleScreen equ $8A61
Pal_SEGA equ $8A9B
Pal_TitleScreen equ $8ABB
Pal_SEGAMid equ $8ADB
Pal_SonicAndTailsIn equ $8AFB
Pal_SEGAEnd equ $8B1B

(include)CONSTANT
* ---------------------------------------------------------------------------
* Constants
*
* Naming convention
* -----------------
* - lower case
* - underscore-separated names
*
* ---------------------------------------------------------------------------

* ===========================================================================
* TO8 Registers
* ===========================================================================

dk_lecteur                    equ $6049
dk_piste                      equ $604A
dk_pisteL                     equ $604B
dk_secteur                    equ $604C
dk_destination                equ $604F

* ===========================================================================
* Display Constants
* ===========================================================================

screen_width                  equ 160 ; screen width in pixel
screen_top                    equ 28 ; in pixel
screen_bottom                 equ 28+199 ; in pixel
screen_left                   equ 48 ; in pixel
screen_right                  equ 48+159 ; in pixel
nb_priority_levels            equ 8   ; number of priority levels (need code change if modified)

* ===========================================================================
* Physics Constants
* ===========================================================================

gravity                       equ $38 ; Gravite: 56 sub-pixels par frame

* ===========================================================================
* Animation Constants
* ===========================================================================

_resetAnim                    equ $FF
_goBackNFrames                equ $FE
_goToAnimation                equ $FD
_nextRoutine                  equ $FC
_resetAnimAndSubRoutine       equ $FB
_nextSubRoutine               equ $FA

* ===========================================================================
* Images Constants
* ===========================================================================

image_x_size                  equ 4
image_y_size                  equ 5
image_center_offset           equ 6

image_subset_x1_offset        equ 4
image_subset_y1_offset        equ 5

page_draw_routine             equ 0
draw_routine                  equ 1
page_erase_routine            equ 3
erase_routine                 equ 4
erase_nb_cell                 equ 6

* ===========================================================================
* Sound Constants
* ===========================================================================

pcm_page        equ 0
pcm_start_addr  equ 1
pcm_end_addr    equ 3
pcm_meta_size   equ 5

* ===========================================================================
* Object Constants
* ===========================================================================

nb_reserved_objects           equ 2
nb_dynamic_objects            equ 27
nb_level_objects              equ 3
nb_objects                    equ 32 * max 64 total

* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------

object_size                   equ 90 ; the size of an object - DEPENDENCY ClearObj routine
next_object                   equ object_size

id                            equ 0           ; reference to object model id (ObjID_) (0: free slot)
subtype                       equ 1           ; reference to object subtype (Sub_)
render_flags                  equ 2

* --- render_flags bitfield variables ---
render_xmirror_mask           equ $01 ; (bit 0) DEPENDENCY should be bit 0 - tell display engine to mirror sprite on horizontal axis
render_ymirror_mask           equ $02 ; (bit 1) DEPENDENCY should be bit 1 - tell display engine to mirror sprite on vertical axis
render_overlay_mask           equ $04 ; (bit 2) DEPENDENCY should be bit 2 - compilated sprite with no background save
render_motionless_mask        equ $08 ; (bit 3) tell display engine to compute sub image and position check only once until the flag is removed  
render_playfieldcoord_mask    equ $10 ; (bit 4) tell display engine to use playfield (1) or screen (0) coordinates
render_hide_mask              equ $20 ; (bit 5) tell display engine to hide sprite (keep priority and mapping_frame)
render_todelete_mask          equ $40 ; (bit 6) tell display engine to delete sprite and clear OST for this object
render_xloop_mask             equ $80 ; (bit 7) (screen coordinate) tell display engine to hide sprite when x is out of screen (0) or to display (1)  
 
priority                      equ 3           ; display priority (0: nothing to display, 1:front, ..., 8:back)
anim                          equ 4  ; and 5  ; reference to current animation (Ani_)
prev_anim                     equ 6  ; and 7  ; reference to previous animation (Ani_)
anim_frame                    equ 8           ; index of current frame in animation
anim_frame_duration           equ 9           ; number of frames for each image in animation, range: 00-7F (0-127), 0 means display only during one frame
image_set                     equ 10 ; and 11 ;reference to current image (Img_) (0000 if no image)
x_pos                         equ 12 ; and 13 ; x playfield coordinate
x_sub                         equ 14          ; x subpixel (1/256 of a pixel), must follow x_pos in data structure
y_pos                         equ 15 ; and 16 ; y playfield coordinate
y_sub                         equ 17          ; y subpixel (1/256 of a pixel), must follow y_pos in data structure
xy_pixel                      equ 18          ; x and y screen coordinate
x_pixel                       equ 18          ; x screen coordinate
y_pixel                       equ 19          ; y screen coordinate, must follow x_pixel
x_vel                         equ 20 ; and 21 ; horizontal velocity
y_vel                         equ 22 ; and 23 ; vertical velocity
routine                       equ 24          ; index of current object routine
routine_secondary             equ 25          ; index of current secondary routine
status                        equ 26 

* --- status bitfield variables for objects ---
status_x_orientation          equ   $01 ; (bit 0) X Orientation. Clear is left and set is right
status_y_orientation          equ   $02 ; (bit 1) Y Orientation. Clear is right-side up, and set is upside-down
status_bit2                   equ   $04 ; (bit 2) Unused
status_mainchar_standing      equ   $08 ; (bit 3) Set if Main character is standing on this object
status_sidekick_standing      equ   $10 ; (bit 4) Set if Sidekick is standing on this object
status_mainchar_pushing       equ   $20 ; (bit 5) Set if Main character is pushing on this object
status_sidekick_pushing       equ   $40 ; (bit 6) Set if Sidekick is pushing on this object
status_bit7                   equ   $80 ; (bit 7) Unused

* --- status bitfield variables for Main characters ---
status_inair                  equ   $02 ; (bit 1) Set if in the air (jump counts)
status_jumporroll             equ   $04 ; (bit 2) Set if jumping or rolling
status_norgroundnorfall       equ   $08 ; (bit 3) Set if isn't on the ground but shouldn't fall. (Usually when he is on a object that should stop him falling, like a platform or a bridge.)
status_jumpingafterrolling    equ   $10 ; (bit 4) Set if jumping after rolling
status_pushing                equ   $20 ; (bit 5) Set if pushing something
status_underwater             equ   $40 ; (bit 6) Set if underwater

ext_variables                 equ 27 ; to 40  ; reserved space for additionnal variables

* ---------------------------------------------------------------------------
* reserved variables (engine)

rsv_render_flags              equ 41

* --- rsv_render_flags bitfield variables ---
rsv_render_checkrefresh_mask  equ $01 ; (bit 0) if erasesprite and display sprite flag are processed for this frame
rsv_render_erasesprite_mask   equ $02 ; (bit 1) if a sprite need to be cleared on screen
rsv_render_displaysprite_mask equ $04 ; (bit 2) if a sprite need to be rendered on screen
rsv_render_outofrange_mask    equ $08 ; (bit 3) if a sprite is out of range for full rendering in screen

rsv_prev_anim                 equ 42 ; and 43 ; reference to previous animation (Ani_) w
rsv_image_center_offset       equ 44 ; 0 or 1 offset that indicate if image center is even or odd (DRS_XYToAddress)
* ne sert plus                       ; and 45 ; reference to current image set w
rsv_image_subset              equ 46 ; and 47 ; reference to current image regarding mirror flags w
rsv_mapping_frame             equ 48 ; and 49 ; reference to current image regarding mirror flags, overlay flag and x precision w
rsv_xy1_pixel                 equ 50          ;
rsv_x1_pixel                  equ 50          ; x+x_offset-(x_size/2) screen coordinate
rsv_y1_pixel                  equ 51          ; y+y_offset-(y_size/2) screen coordinate, must follow rsv_x1_pixel
rsv_xy2_pixel                 equ 52          ;
rsv_x2_pixel                  equ 52          ; x+x_offset+(x_size/2) screen coordinate
rsv_y2_pixel                  equ 53          ; y+y_offset+(y_size/2) screen coordinate, must follow rsv_x2_pixel

* ---------------------------------------------------------------------------
* reserved variables (engine) - buffer specific

rsv_buffer_0                  equ 54 ; Start index of buffer 0 variables
rsv_priority_0                equ 54 ; internal value that hold priority in video buffer 0
rsv_priority_prev_obj_0       equ 55 ; and 56 ; previous object (OST address) in display priority list for video buffer 0 (0000 if none) w
rsv_priority_next_obj_0       equ 57 ; and 58 ; next object (OST address) in display priority list for video buffer 0 (0000 if none) w
*rsv_prev_image_subset_0       equ 59 ; and 60 ; reference to previous image subset in video buffer 0 w
rsv_prev_mapping_frame_0      equ 61 ; and 62 ; reference to previous image in video buffer 0 w
rsv_bgdata_0                  equ 63 ; and 64 ; address of background data in screen 0 w
rsv_prev_xy_pixel_0           equ 65 ;
rsv_prev_x_pixel_0            equ 65 ; previous x screen coordinate b
rsv_prev_y_pixel_0            equ 66 ; previous y screen coordinate b, must follow x_pixel
rsv_prev_xy1_pixel_0          equ 67 ;
rsv_prev_x1_pixel_0           equ 67 ; previous x+x_offset-(x_size/2) screen coordinate b
rsv_prev_y1_pixel_0           equ 68 ; previous y+y_offset-(y_size/2) screen coordinate b, must follow x1_pixel
rsv_prev_xy2_pixel_0          equ 69 ;
rsv_prev_x2_pixel_0           equ 69 ; previous x+x_offset+(x_size/2) screen coordinate b
rsv_prev_y2_pixel_0           equ 70 ; previous y+y_offset+(y_size/2) screen coordinate b, must follow x2_pixel
rsv_prev_render_flags_0       equ 71 ;
* --- rsv_prev_render_flags_0 bitfield variables ---
rsv_prev_render_overlay_mask  equ $01 ; (bit 0) if a sprite has been rendered with compilated sprite and no background save on screen buffer 0/1
rsv_prev_render_onscreen_mask equ $80 ; (bit 7) DEPENDENCY should be bit 7 - has been rendered on screen buffer 0/1

rsv_buffer_1                  equ 72 ; Start index of buffer 1 variables
rsv_priority_1                equ 72 ; internal value that hold priority in video buffer 1
rsv_priority_prev_obj_1       equ 73 ; and 74 ; previous object (OST address) in display priority list for video buffer 1 (0000 if none) w
rsv_priority_next_obj_1       equ 75 ; and 76 ; next object (OST address) in display priority list for video buffer 1 (0000 if none) w
*rsv_prev_image_subset_1       equ 77 ; and 78 ; reference to previous image subset in video buffer 1 w
rsv_prev_mapping_frame_1      equ 79 ; and 80 ; reference to previous image in video buffer 1 w
rsv_bgdata_1                  equ 81 ; and 82 ; address of background data in screen 1 w
rsv_prev_xy_pixel_1           equ 83 ;
rsv_prev_x_pixel_1            equ 83 ; previous x screen coordinate b
rsv_prev_y_pixel_1            equ 84 ; previous y screen coordinate b, must follow x_pixel
rsv_prev_xy1_pixel_1          equ 85 ;
rsv_prev_x1_pixel_1           equ 85 ; previous x+x_size screen coordinate b
rsv_prev_y1_pixel_1           equ 86 ; previous y+y_size screen coordinate b, must follow x_pixel
rsv_prev_xy2_pixel_1          equ 87 ;
rsv_prev_x2_pixel_1           equ 87 ; previous x+x_size screen coordinate b
rsv_prev_y2_pixel_1           equ 88 ; previous y+y_size screen coordinate b, must follow x_pixel
rsv_prev_render_flags_1       equ 89 ;

buf_priority                  equ 0  ; offset for each rsv_buffer variables
buf_priority_prev_obj         equ 1  ;
buf_priority_next_obj         equ 3  ;
*buf_prev_image_subset         equ 5  ;
buf_prev_mapping_frame        equ 7  ;
buf_bgdata                    equ 9  ;
buf_prev_xy_pixel             equ 11 ;
buf_prev_x_pixel              equ 11 ;
buf_prev_y_pixel              equ 12 ;
buf_prev_xy1_pixel            equ 13 ;
buf_prev_x1_pixel             equ 13 ;
buf_prev_y1_pixel             equ 14 ;
buf_prev_xy2_pixel            equ 15 ;
buf_prev_x2_pixel             equ 15 ;
buf_prev_y2_pixel             equ 16 ;
buf_prev_render_flags         equ 17 ;