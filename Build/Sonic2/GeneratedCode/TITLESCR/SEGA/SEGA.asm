; ---------------------------------------------------------------------------
; Object - SEGA
;
; Play SEGA Intro
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
(main)SEGA
        INCLUD GLOBALS
        INCLUD CONSTANT
        org   $A000

SegaScr_This            equ Object_RAM
Obj_SEGA                equ SegaScr_This
Obj_Trails1             equ SegaScr_This+(object_size*1)
Obj_Trails2             equ SegaScr_This+(object_size*2)
Obj_Trails3             equ SegaScr_This+(object_size*3)
Obj_Trails4             equ SegaScr_This+(object_size*4)
Obj_Sonic1              equ SegaScr_This+(object_size*5)
Obj_Sonic2              equ SegaScr_This+(object_size*6)
Obj_Sonic3              equ SegaScr_This+(object_size*7)
Obj_PaletteFade      equ SegaScr_This+(object_size*8)

* ---------------------------------------------------------------------------
* Object Status Table offsets
* - two variables can share same space if used by two different subtypes
* - take care of words and bytes and space them accordingly
* ---------------------------------------------------------------------------
b_nbFrames              equ ext_variables

* ---------------------------------------------------------------------------
* Subtypes
* ---------------------------------------------------------------------------
Sub_Init        equ 0
Sub_SEGA        equ 3
Sub_Trails      equ 6
Sub_Sonic       equ 9

SEGA_Main
        lda   routine,u
        sta   *+4,pcr
        bra   SEGA_Routines

SEGA_Routines
        lbra  SEGA_MainInit
        lbra  SEGA
        lbra  Trails
        lbra  Sonic

SEGA_MainInit
        lda   #2
        sta   priority,u
        lda   subtype,u
        sta   routine,u
        bra   SEGA_Main

Trails
        jmp   DisplaySprite

Sonic
        jsr   AnimateSprite
        jmp   DisplaySprite

SEGA
        lda   routine_secondary,u
        sta   *+4,pcr
        bra   SEGA_Routines

SEGA_SubRoutines
        lbra  SEGA_Init
        lbra  SEGA_RunLeft
        lbra  SEGA_MidWipe
        lbra  SEGA_MidWipeWaitPal
        lbra  SEGA_RunRight
        lbra  SEGA_EndWipe
        lbra  SEGA_EndWipeWaitPal
        lbra  SEGA_Wait
        lbra  SEGA_end
        rts

SEGA_Init

        lda   #$E
        sta   b_nbFrames,u

        * Init SEGA logo position
        ldd   #$807F
        std   xy_pixel,u

        * Disable background save
        lda   render_flags,u
        ora   #render_overlay_mask
        sta   render_flags,u

        * Init all sub objects
        stu   SEGA_Init_01+1,pcr
        ldd   #(ObjID_SEGA<+8)+Sub_Trails
        ldy   #$F080

        ldx   #Obj_Trails1
        std   ,x
        sty   xy_pixel,x
        ldu   #Img_SegaTrails_1
        stu   image_set,x

        ldx   #Obj_Trails2
        std   ,x
        sty   xy_pixel,x
        ldu   #Img_SegaTrails_2
        stu   image_set,x

        ldx   #Obj_Trails3
        std   ,x
        sty   xy_pixel,x
        ldu   #Img_SegaTrails_5
        stu   image_set,x

        ldx   #Obj_Trails4
        std   ,x
        sty   xy_pixel,x
        ldu   #Img_SegaTrails_6
        stu   image_set,x

        ldd   #(ObjID_SEGA<+8)+Sub_Sonic
        ldy   #$F87B

        ldx   #Obj_Sonic1
        std   ,x
        sty   xy_pixel,x
        ldu   #Ani_SegaSonic_1
        stu   anim,x

        ldx   #Obj_Sonic2
        std   ,x
        sty   xy_pixel,x
        ldu   #Ani_SegaSonic_2
        stu   anim,x

        ldx   #Obj_Sonic3
        std   ,x
        sty   xy_pixel,x
        ldu   #Ani_SegaSonic_3
        stu   anim,x

SEGA_Init_01
        ldu   #$0000

        * Disable backround save on Trails and set x mirror
        ldx   #Obj_Trails1
        lda   render_flags,x
        ora   #render_overlay_mask!render_xmirror_mask
        sta   render_flags,x
        ldb   #3
        stb   priority,x

        ldx   #Obj_Trails2
        sta   render_flags,x
        stb   priority,x

        ldx   #Obj_Trails3
        sta   render_flags,x
        stb   priority,x

        ldx   #Obj_Trails4
        sta   render_flags,x
        stb   priority,x

        * Set x mirror on Sonic
        ldx   #Obj_Sonic1
        lda   status,x
        ora   #status_x_orientation
        sta   status,x
        ldb   #1
        stb   priority,x

        ldx   #Obj_Sonic2
        sta   status,x
        stb   priority,x

        ldx   #Obj_Sonic3
        sta   status,x
        stb   priority,x

        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u
        rts

SEGA_RunLeft

        dec   b_nbFrames,u
        bmi   SEGA_RunLeft_continue

        ldx   #Obj_Trails1
        lda   x_pixel,x
        suba  #$10
        sta   x_pixel,x
        ldx   #Obj_Trails2
        sta   x_pixel,x
        ldx   #Obj_Trails3
        sta   x_pixel,x
        ldx   #Obj_Trails4
        sta   x_pixel,x

        ldx   #Obj_Sonic1
        lda   x_pixel,x
        suba  #$10
        sta   x_pixel,x
        ldx   #Obj_Sonic2
        sta   x_pixel,x
        ldx   #Obj_Sonic3
        sta   x_pixel,x
        rts

SEGA_RunLeft_continue
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u

        lda   #$E
        sta   b_nbFrames,u
        rts

SEGA_MidWipe

        * Unset x mirror on Trails
        ldx   #Obj_Trails1
        lda   render_flags,x
        anda   #:render_xmirror_mask
        sta   render_flags,x
        ldb   y_pixel,x
        decb
        stb   y_pixel,x

        ldx   #Obj_Trails2
        sta   render_flags,x
        stb   y_pixel,x

        ldx   #Obj_Trails3
        sta   render_flags,x
        stb   y_pixel,x
        ldy   #Img_SegaTrails_3
        sty   image_set,x

        ldx   #Obj_Trails4
        sta   render_flags,x
        stb   y_pixel,x
        ldy   #Img_SegaTrails_4
        sty   image_set,x

        * Unset x mirror on Sonic
        ldx   #Obj_Sonic1
        lda   status,x
        anda   #:status_x_orientation
        sta   status,x
        ldb   x_pixel,x
        subb  #$10
        stb   x_pixel,x

        ldx   #Obj_Sonic2
        sta   status,x
        stb   x_pixel,x

        ldx   #Obj_Sonic3
        sta   status,x
        stb   x_pixel,x

        * Set Sega Logo
        ldd   #Img_SegaLogo_1
        std   image_set,u

        * Fade out Trails
        ldx   #Obj_PaletteFade
        lda   #ObjID_PaletteFade
        sta   id,x
        ldd   #Pal_SEGA *@IgnoreUndefined
        std   ext_variables,x
        ldd   #Pal_SEGAMid *@IgnoreUndefined
        std   ext_variables+2,x
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u

        jmp   DisplaySprite

SEGA_MidWipeWaitPal
        ldx   #Obj_PaletteFade
        tst   ,x
        beq   SEGA_MidWipeWaitPal_continue
        jmp   DisplaySprite

SEGA_MidWipeWaitPal_continue
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u
        rts

SEGA_RunRight
        dec   b_nbFrames,u
        bmi   SEGA_RunRight_continue

        ldx   #Obj_Trails1
        lda   x_pixel,x
        adda  #$10
        sta   x_pixel,x
        ldx   #Obj_Trails2
        sta   x_pixel,x
        ldx   #Obj_Trails3
        sta   x_pixel,x
        ldx   #Obj_Trails4
        sta   x_pixel,x

        ldx   #Obj_Sonic1
        lda   x_pixel,x
        adda  #$10
        sta   x_pixel,x
        ldx   #Obj_Sonic2
        sta   x_pixel,x
        ldx   #Obj_Sonic3
        sta   x_pixel,x
        rts

SEGA_RunRight_continue
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u
        rts

SEGA_EndWipe

        * Set Sega Logo
        ldd   #Img_SegaLogo_2
        std   image_set,u

        * Delete Trails and Sonic Sprites
        ldx   #Obj_Trails1
        jsr   DeleteObject_x
        ldx   #Obj_Trails2
        jsr   DeleteObject_x
        ldx   #Obj_Trails3
        jsr   DeleteObject_x
        ldx   #Obj_Trails4
        jsr   DeleteObject_x
        ldx   #Obj_Sonic1
        jsr   DeleteObject_x
        ldx   #Obj_Sonic2
        jsr   DeleteObject_x
        ldx   #Obj_Sonic3
        jsr   DeleteObject_x

        * Fade out Trails
        ldx   #Obj_PaletteFade
        lda   #ObjID_PaletteFade
        sta   id,x
        ldd   Cur_palette *@IgnoreUndefined
        std   ext_variables,x
        ldd   #Pal_SEGAEnd *@IgnoreUndefined
        std   ext_variables+2,x
        
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u        

        jmp   DisplaySprite

SEGA_EndWipeWaitPal
        ldx   #Obj_PaletteFade
        tst   ,x
        beq   SEGA_PlaySample
        jmp   DisplaySprite

SEGA_PlaySample
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u

        ldy   #Pcm_SEGA *@IgnoreUndefined
        jsr   PlayPCM

        ldd   #$0000
        std   Vint_runcount
        rts

SEGA_Wait
        ldd   Vint_runcount
        cmpd  #3*50 ; 3 seconds
        beq   SEGA_fadeOut
        rts

SEGA_fadeOut
        ldx   #Obj_PaletteFade
        lda   #ObjID_PaletteFade
        sta   id,x
        ldd   Cur_palette *@IgnoreUndefined
        std   ext_variables,x
        ldd   #Black_palette *@IgnoreUndefined
        std   ext_variables+2,x
        lda   routine_secondary,u
        adda  #$03
        sta   routine_secondary,u
        rts

SEGA_end
        ldx   #Obj_PaletteFade
        tst   ,x
        beq   SEGA_return
        rts

SEGA_return
        jsr   DeleteObject  
        ldd   #(ObjID_SonicAndTailsIn<+8)+$00         ; Replace this object with Title Screen Object subtype 3
        std   ,u

        ldu   #Obj_PaletteFade
        jsr   ClearObj
        rts


(include)GLOBALS
* Generated Code

GameModeLoader equ $414F
current_game_mode_data equ $41C7
ObjID_PaletteFade equ 1
ObjID_RasterFade equ 2
ObjID_SonicAndTailsIn equ 3
ObjID_SEGA equ 4
ObjID_TitleScreen equ 5
Glb_Sprite_Screen_Pos_Part1 equ $6122
Glb_Sprite_Screen_Pos_Part2 equ $6124
Object_RAM equ $6660
screen_border_color equ $7536
Vint_runcount equ $755C
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
Joypads_Held equ $7560
Dpad_Held equ $7560
Fire_Held equ $7561
Joypads_Press equ $7562
Dpad_Press equ $7562
Fire_Press equ $7563
MarkObjGone equ $75CD
DisplaySprite_x equ $75CF
DisplaySprite equ $75D5
AnimateSprite equ $764E
DeleteObject_x equ $7713
DeleteObject equ $7719
ClearObj equ $77DB
ClearCartMem equ $808B
Refresh_palette equ $80C5
Cur_palette equ $80C6
Dyn_palette equ $80C8
Black_palette equ $80E8
White_palette equ $8108
UpdatePalette equ $8128
PlayPCM equ $8150
PSGInit equ $81A7
PSGPlayNoRepeat equ $81B9
PSGStop equ $81E7
PSGResume equ $8210
PSGCancelLoop equ $825B
PSGGetStatus equ $825F
PSGSetMusicVolumeAttenuation equ $8263
PSGSilenceChannels equ $82C2
PSGRestoreVolumes equ $82D7
PSGSFXPlayLoop equ $834B
PSGSFXStop equ $8397
PSGSFXCancelLoop equ $840D
PSGSFXGetStatus equ $8411
PSGFrame equ $8415
_sendVolume2PSG equ $84CF
PSGSFXFrame equ $8522
_SFXsetLoopPoint equ $857F
irq_routine equ $6027
irq_timer_ctrl equ $E7C5
irq_timer equ $E7C6
irq_one_frame equ $4DFF
Irq_Raster_Page equ $85CB
Irq_Raster_Start equ $85CD
Irq_Raster_End equ $85CF
IrqOn equ $85D1
IrqOff equ $85DC
IrqSync equ $85E7
IrqPsg equ $8606
IrqPsgRaster equ $8615
Img_SonicAndTailsIn equ $8656
Img_SegaLogo_2 equ $8666
Img_SegaLogo_1 equ $8676
Img_SegaTrails_1 equ $8686
Img_SegaSonic_12 equ $869F
Img_SegaSonic_23 equ $86C0
Img_SegaSonic_13 equ $86E1
Img_SegaSonic_32 equ $8702
Img_SegaSonic_21 equ $8723
Img_SegaSonic_43 equ $8744
Img_SegaSonic_11 equ $8765
Img_SegaSonic_33 equ $8786
Img_SegaSonic_22 equ $87A7
Img_SegaSonic_41 equ $87C8
Img_SegaSonic_31 equ $87E9
Img_SegaSonic_42 equ $880A
Img_SegaTrails_6 equ $882B
Img_SegaTrails_5 equ $883B
Img_SegaTrails_4 equ $884B
Img_SegaTrails_3 equ $885B
Img_SegaTrails_2 equ $886B
Img_tails_5 equ $8884
Img_tails_4 equ $889B
Img_tails_3 equ $88AF
Img_tails_2 equ $88C3
Img_tails_1 equ $88D7
Img_islandWater15 equ $88EB
Img_islandWater14 equ $8906
Img_islandWater13 equ $8921
Img_islandWater12 equ $893C
Img_islandWater11 equ $8957
Img_islandMask_1 equ $8972
Img_islandWater10 equ $8982
Img_emblemBack02 equ $899D
Img_emblemBack01 equ $89AD
Img_islandMask_2 equ $89BD
Img_islandWater09 equ $89CD
Img_islandWater08 equ $89E8
Img_islandWater07 equ $8A03
Img_islandWater06 equ $8A1E
Img_islandWater05 equ $8A39
Img_islandWater04 equ $8A54
Img_islandWater03 equ $8A6F
Img_islandWater02 equ $8A8A
Img_star_4 equ $8AA5
Img_islandWater01 equ $8AB9
Img_star_3 equ $8AD4
Img_sonicHand equ $8AE8
Img_star_2 equ $8AFF
Img_star_1 equ $8B1A
Img_emblemBack08 equ $8B35
Img_emblemBack07 equ $8B45
Img_emblemBack09 equ $8B55
Img_emblemBack04 equ $8B65
Img_emblemBack03 equ $8B75
Img_emblemBack06 equ $8B85
Img_emblemBack05 equ $8B95
Img_tailsHand equ $8BA5
Img_island equ $8BBC
Img_sonic_1 equ $8BD7
Img_sonic_2 equ $8BEB
Img_sonic_5 equ $8BFF
Img_sonic_3 equ $8C16
Img_emblemFront07 equ $8C2A
Img_emblemFront08 equ $8C3A
Img_emblemFront05 equ $8C4A
Img_emblemFront06 equ $8C5A
Img_emblemFront03 equ $8C6A
Img_emblemFront04 equ $8C7A
Img_emblemFront01 equ $8C8A
Img_emblemFront02 equ $8C9A
Ani_SegaSonic_3 equ $8CAB
Ani_SegaSonic_2 equ $8CB5
Ani_SegaSonic_1 equ $8CBF
Ani_smallStar equ $8CC9
Ani_largeStar equ $8CCF
Ani_tails equ $8CDB
Ani_sonic equ $8CE7
Glb_Sprite_Screen_Pos_Part1 equ $6122
Glb_Sprite_Screen_Pos_Part2 equ $6124
Object_RAM equ $6660
screen_border_color equ $7536
Vint_runcount equ $755C
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
Joypads_Held equ $7560
Dpad_Held equ $7560
Fire_Held equ $7561
Joypads_Press equ $7562
Dpad_Press equ $7562
Fire_Press equ $7563
MarkObjGone equ $75CD
DisplaySprite_x equ $75CF
DisplaySprite equ $75D5
AnimateSprite equ $764E
DeleteObject_x equ $7713
DeleteObject equ $7719
ClearObj equ $77DB
ClearCartMem equ $808B
Refresh_palette equ $80C5
Cur_palette equ $80C6
Dyn_palette equ $80C8
Black_palette equ $80E8
White_palette equ $8108
UpdatePalette equ $8128
PlayPCM equ $8150
PSGInit equ $81A7
PSGPlayNoRepeat equ $81B9
PSGStop equ $81E7
PSGResume equ $8210
PSGCancelLoop equ $825B
PSGGetStatus equ $825F
PSGSetMusicVolumeAttenuation equ $8263
PSGSilenceChannels equ $82C2
PSGRestoreVolumes equ $82D7
PSGSFXPlayLoop equ $834B
PSGSFXStop equ $8397
PSGSFXCancelLoop equ $840D
PSGSFXGetStatus equ $8411
PSGFrame equ $8415
_sendVolume2PSG equ $84CF
PSGSFXFrame equ $8522
_SFXsetLoopPoint equ $857F
irq_routine equ $6027
irq_timer_ctrl equ $E7C5
irq_timer equ $E7C6
irq_one_frame equ $4DFF
Irq_Raster_Page equ $85CB
Irq_Raster_Start equ $85CD
Irq_Raster_End equ $85CF
IrqOn equ $85D1
IrqOff equ $85DC
IrqSync equ $85E7
IrqPsg equ $8606
IrqPsgRaster equ $8615
Img_SonicAndTailsIn equ $8656
Img_SegaLogo_2 equ $8666
Img_SegaLogo_1 equ $8676
Img_SegaTrails_1 equ $8686
Img_SegaSonic_12 equ $869F
Img_SegaSonic_23 equ $86C0
Img_SegaSonic_13 equ $86E1
Img_SegaSonic_32 equ $8702
Img_SegaSonic_21 equ $8723
Img_SegaSonic_43 equ $8744
Img_SegaSonic_11 equ $8765
Img_SegaSonic_33 equ $8786
Img_SegaSonic_22 equ $87A7
Img_SegaSonic_41 equ $87C8
Img_SegaSonic_31 equ $87E9
Img_SegaSonic_42 equ $880A
Img_SegaTrails_6 equ $882B
Img_SegaTrails_5 equ $883B
Img_SegaTrails_4 equ $884B
Img_SegaTrails_3 equ $885B
Img_SegaTrails_2 equ $886B
Img_tails_5 equ $8884
Img_tails_4 equ $889B
Img_tails_3 equ $88AF
Img_tails_2 equ $88C3
Img_tails_1 equ $88D7
Img_islandWater15 equ $88EB
Img_islandWater14 equ $8906
Img_islandWater13 equ $8921
Img_islandWater12 equ $893C
Img_islandWater11 equ $8957
Img_islandMask_1 equ $8972
Img_islandWater10 equ $8982
Img_emblemBack02 equ $899D
Img_emblemBack01 equ $89AD
Img_islandMask_2 equ $89BD
Img_islandWater09 equ $89CD
Img_islandWater08 equ $89E8
Img_islandWater07 equ $8A03
Img_islandWater06 equ $8A1E
Img_islandWater05 equ $8A39
Img_islandWater04 equ $8A54
Img_islandWater03 equ $8A6F
Img_islandWater02 equ $8A8A
Img_star_4 equ $8AA5
Img_islandWater01 equ $8AB9
Img_star_3 equ $8AD4
Img_sonicHand equ $8AE8
Img_star_2 equ $8AFF
Img_star_1 equ $8B1A
Img_emblemBack08 equ $8B35
Img_emblemBack07 equ $8B45
Img_emblemBack09 equ $8B55
Img_emblemBack04 equ $8B65
Img_emblemBack03 equ $8B75
Img_emblemBack06 equ $8B85
Img_emblemBack05 equ $8B95
Img_tailsHand equ $8BA5
Img_island equ $8BBC
Img_sonic_1 equ $8BD7
Img_sonic_2 equ $8BEB
Img_sonic_5 equ $8BFF
Img_sonic_3 equ $8C16
Img_emblemFront07 equ $8C2A
Img_emblemFront08 equ $8C3A
Img_emblemFront05 equ $8C4A
Img_emblemFront06 equ $8C5A
Img_emblemFront03 equ $8C6A
Img_emblemFront04 equ $8C7A
Img_emblemFront01 equ $8C8A
Img_emblemFront02 equ $8C9A
Ani_SegaSonic_3 equ $8CAB
Ani_SegaSonic_2 equ $8CB5
Ani_SegaSonic_1 equ $8CBF
Ani_smallStar equ $8CC9
Ani_largeStar equ $8CCF
Ani_tails equ $8CDB
Ani_sonic equ $8CE7
Pcm_SEGA equ $8FF0
Psg_TitleScreen equ $8FFB
Pal_Island equ $9035
Pal_SEGA equ $9055
Pal_TitleScreen equ $9075
Pal_SEGAMid equ $9095
Pal_SonicAndTailsIn equ $90B5
Pal_SEGAEnd equ $90D5

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
nb_dynamic_objects            equ 37
nb_level_objects              equ 3
nb_objects                    equ 42 * max 64 total

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

* TODO Doit etre gere dynamiquement par le builder en fonction du properties
PalID_TitleScreenRaster       equ 0