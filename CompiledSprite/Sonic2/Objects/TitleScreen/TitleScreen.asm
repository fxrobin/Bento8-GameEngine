; ---------------------------------------------------------------------------
; Object - TitleScreen
;
; input REG : [u] pointeur sur l'objet (SST)
;
; --------------------------------------
;
; Commentaires sur le code original de Sonic 2
; Palettes
; --------
; 4 palettes de 16 couleurs
; Avant execution de l'objet : palettes 0 a 3 a noir
; Dans l'ordre d'apparition des palettes :
; Pal1 - fade in - Etoiles et Tails
; Pal3 - fade in - Embleme
; Pal0 - set - Sonic
; Pal2 - set white - fade in - Background
; valeurs Megadrive: 0, 2, 4, 6, 8, A, C, E
; valeurs traduites RGB: 0, 0x24, 0x49, 0x6D, 0x92, 0xB6, 0xDB, 0xFF 
;                        0, 36, 73, 109, 146, 182, 219, 255
; les correspondances avec TO8 sont faites dans le domaine CIE-LAB
;
; Priorite d'affichage (VDP) 
; --------------------------
; Arriere-plan
;  |  backdrop color => Blue
;  |  low priority plane B tiles => Island
;  |  low priority plane A tiles
;  |  low priority sprites  => from top to bottom : center of Emblem Top, Sky piece (4x 8x32) link 8, 9, 10, 11 xpos 4,0,4,0 ypos 240,240,272,272
;  |  high priority plane B tiles
;  |  high priority plane A tiles => Emblem
; \./ high priority sprites => from top to bottom: left and right of Emblem Top, Sonic, Tails
; Avant plan
; 
; Dans TitleScreen_Loop (code non repris ici) un boucle positionne "horizontal position" a des valeurs 0 ou 4
; par alternance sur tous les sprites (Sprite_Table structure de donnees du VDP) qui ont :
; priority = 0, hflip = 0, vflip = 0 et tileart < $80
;
; Une fonctionnalite du VDP est que lorsqu'un sprite a une position x = 0, toutes les lignes horizontales
; occuppees par ce sprite ne sont plus rafraichies avec le contenu des sprites suivants dans la liste (Sprite_Table).
; cette fontionnalite est utilisee pour masquer Sonic et Tails derriere l'embleme.
; Un sprite suplementaire gere la partie arrondie de l'embleme pour le masquage, il est simplement affiche par dessus.
; ---------------------------------------------------------------------------

(main)MAIN
        INCLUD GLOBALS
        INCLUD CONSTANT
        org   $0000     

* ---------------------------------------------------------------------------
* Object Status Table index
* ---------------------------------------------------------------------------
TtlScr_Object_RAM          equ Object_RAM+(object_size*1)
IntroSonic                 equ Object_RAM+(object_size*2)
IntroTails                 equ Object_RAM+(object_size*3)
IntroLargeStar             equ Object_RAM+(object_size*4)
TitleScreenPaletteChanger  equ Object_RAM+(object_size*5)
TitleScreenPaletteChanger3 equ Object_RAM+(object_size*6)
IntroEmblemTop             equ Object_RAM+(object_size*7)
IntroSmallStar1            equ Object_RAM+(object_size*8)
IntroSonicHand             equ Object_RAM+(object_size*9)
IntroTailsHand             equ Object_RAM+(object_size*10)
TitleScreenPaletteChanger2 equ Object_RAM+(object_size*11)
IntroSmallStar2            equ Object_RAM+(object_size*12)

* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------
* forcer l'initialisation a 0 des variables objet: routine, frame_count, routine_secondary
frame_count equ $34 ; and $35
position_frame_count equ $2A ; and $2B
xy_data_index equ $2C ; and $2D
color_data_index equ $2C ; and $2D
final_state equ $2F

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
        ldx   TitleScreen_Routines,pcr           *        move.w  Obj0E_Index(pc,d0.w),d1
        jmp   [a,x]                              *        jmp     Obj0E_Index(pc,d1.w)
                                                 *; ===========================================================================
                                                 *; off_12E26: Obj0E_States:
TitleScreen_Routines                             *Obj0E_Index:    offsetTable
        fdb   Init                               *                offsetTableEntry.w Obj0E_Init   ;   0
        fdb   Sonic                              *                offsetTableEntry.w Obj0E_Sonic  ;   2
        fdb   Tails                              *                offsetTableEntry.w Obj0E_Tails  ;   4
        fdb   TitleScreen_LogoTop                *                offsetTableEntry.w Obj0E_LogoTop        ;   6
        fdb   TitleScreen_LargeStar              *                offsetTableEntry.w Obj0E_LargeStar      ;   8
        fdb   TitleScreen_SonicHand              *                offsetTableEntry.w Obj0E_SonicHand      ;  $A
        fdb   TitleScreen_SmallStar              *                offsetTableEntry.w Obj0E_SmallStar      ;  $C
        fdb   TitleScreen_SkyPiece               *                offsetTableEntry.w Obj0E_SkyPiece       ;  $E
        fdb   TailsHand                          *                offsetTableEntry.w Obj0E_TailsHand      ; $10
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
        ldd   frame_count,u                      
        addd  #1                                 *        addq.w  #1,objoff_34(a0)
        std   frame_count,u                      
        cmpd  #$120                              *        cmpi.w  #$120,objoff_34(a0)
        bhs   Sonic_NotFinalState                *        bhs.s   +
        bsr   TitleScreen_SetFinalState          
                                                 *        bsr.w   TitleScreen_SetFinalState
Sonic_NotFinalState                              *+
                                                 *        moveq   #0,d0
        lda   routine_secondary,u                *        move.b  routine_secondary(a0),d0
        ldx   Sonic_Routines,pcr                 *        move.w  off_12E76(pc,d0.w),d1
        jmp   [a,x]                              *        jmp     off_12E76(pc,d1.w)
                                                 *; ===========================================================================
Sonic_Routines                                   *off_12E76:      offsetTable
        fdb   Sonic_Init                         *                offsetTableEntry.w Obj0E_Sonic_Init     ;   0
        fdb   Sonic_PaletteFade                  *                offsetTableEntry.w loc_12EC2    ;   2
        fdb   Sonic_SetPal_TitleScreen           *                offsetTableEntry.w loc_12EE8    ;   4
        fdb   Sonic_Move                         *                offsetTableEntry.w loc_12F18    ;   6
        fdb   TitleScreen_Animate                *                offsetTableEntry.w loc_12F52    ;   8
        fdb   Sonic_CreateHand                   *                offsetTableEntry.w Obj0E_Sonic_LastFrame        ;  $A
        fdb   Sonic_CreateTails                  *                offsetTableEntry.w loc_12F7C    ;  $C
        fdb   Sonic_FadeInBackground             *                offsetTableEntry.w loc_12F9A    ;  $E
        fdb   Sonic_CreateSmallStar              *                offsetTableEntry.w loc_12FD6    ; $10
        fdb   CyclingPal                         *                offsetTableEntry.w loc_13014    ; $12
                                                 *; ===========================================================================
                                                 *; spawn more stars
Sonic_Init                                       *Obj0E_Sonic_Init:
        inc   routine_secondary,u                
        inc   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        lda   #Imgref_sonic_1                    
        sta   mapping_frame,u                    *        move.b  #5,mapping_frame(a0)
        ldd   #$0110                             
        std   x_pixel,u                          *        move.w  #$110,x_pixel(a0)
        ldd   #$00E0                             
        std   y_pixel,u                          *        move.w  #$E0,y_pixel(a0)
        ldx   #IntroLargeStar                    *        lea     (IntroLargeStar).w,a1
        lda   #ObjID_TitleScreen                 
        sta   id,x                               *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E (flashing intro stars) at $FFFFB0C0
        ldb   #8                                 
        stb   subtype,x                          *        move.b  #8,subtype(a1)                          ; large star
        ldx   #IntroEmblemTop                    *        lea     (IntroEmblemTop).w,a1
        sta   id,x                               *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E (flashing intro stars) at $FFFFD140
        ldb   #6                                 
        stb   subtype,x                          *        move.b  #6,subtype(a1)                          ; logo top
        * sound unused                           *        moveq   #SndID_Sparkle,d0
        rts                                      *        jmpto   (PlaySound).l, JmpTo4_PlaySound
                                                 *; ===========================================================================
                                                 *
Sonic_PaletteFade                                    *loc_12EC2:
        ldd   frame_count,u                      
        cmpd  #$38                               *        cmpi.w  #$38,objoff_34(a0)
        bhs   Sonic_PaletteAfterWait             *        bhs.s   +
        rts                                      *        rts
                                                 *; ===========================================================================
Sonic_PaletteFadeAfterWait                       *+
        inc   routine_secondary,u                
        inc   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        ldx   #TitleScreenPaletteChanger3        *        lea     (TitleScreenPaletteChanger3).w,a1
        lda   #ObjID_TtlScrPalChanger
        sta   id,x                               *        move.b  #ObjID_TtlScrPalChanger,id(a1) ; load objC9 (palette change)
        clr   subtype,x                          *        move.b  #0,subtype(a1)
        * music unused (flag)                    *        st.b    objoff_30(a0)
        * music unused                           *        moveq   #MusID_Title,d0 ; title music
        rts                                      *        jmpto   (PlayMusic).l, JmpTo4_PlayMusic
                                                 *; ===========================================================================
                                                 *
Sonic_SetPal_TitleScreen                         *loc_12EE8:
        ldd   frame_count,u                      
        cmpd  #$80                               *        cmpi.w  #$80,objoff_34(a0)
        bhs   Sonic_SetPal_TitleScreenAfterWait  *        bhs.s   +
        rts                                      *        rts
                                                 *; ===========================================================================
Sonic_SetPal_TitleScreenAfterWait                *+
        inc   routine_secondary,u                
        inc   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        sts   dyn_00+2
        stu   dyn_00+6
        ldd   #Pal_TitleScreen                   *        lea     (Pal_133EC).l,a1
        std   Ptr_palette                        *        lea     (Normal_palette).w,a2
                                                 *
                                                 *        moveq   #$F,d6
                                                 *-       move.w  (a1)+,(a2)+
                                                 *        dbf     d6,-
                                                 *
                                                 *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                                 *
                                                 *
EmblemOverlay                                    *sub_12F08:
        ldx   #IntroSmallStar1                   *        lea     (IntroSmallStar1).w,a1
        lda   #ObjID_TitleScreen
        sta   id,x                               *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E (flashing intro star) at $FFFFB180
        ldb   #$E                                
        stb   subtype,x                          *        move.b  #$E,subtype(a1)                         ; piece of sky
        rts                                      *        rts
                                                 *; End of function sub_12F08
                                                 *
                                                 *; ===========================================================================
                                                 *
Sonic_Move                                       *loc_12F18:
        ldx   Sonic_xy_data_end-Sonic_xy_data+4
        stx   dyn_01+1                           *        moveq   #word_13046_end-word_13046+4,d2
        ldx   #Sonic_xy_data,pcr                 *        lea     (word_13046).l,a1
                                                 *
TitleScreen_MoveObjects                          *loc_12F20:
        ldd   position_frame_count               *        move.w  objoff_2A(a0),d0
        addd  #1                                 *        addq.w  #1,d0
        std   position_frame_count               *        move.w  d0,objoff_2A(a0)
        andb  #3 * one frame on four             *        andi.w  #3,d0
        bne   MoveObjects_KeepPosition           *        bne.s   +
        ldd   xy_data_index,u                    *        move.w  objoff_2C(a0),d1
        addd  #4                                 *        addq.w  #4,d1
dyn_01                                           
        cmpd  #$0000                             *        cmp.w   d2,d1
        bhs   TitleScreen_NxSRoutineAndDisplay   *        bhs.w   loc_1310A
        std   xy_data_index,u                    *        move.w  d1,objoff_2C(a0)
        leax  d,x                                *        move.l  -4(a1,d1.w),d0
        ldd   -2,x                               *        move.w  d0,y_pixel(a0)
        std   y_pixel,u                          
        ldd   -4,x                               *        swap    d0
        std   x_pixel,u                          *        move.w  d0,x_pixel(a0)
MoveObjects_KeepPosition                         *+
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *
TitleScreen_Animate                              *loc_12F52:
        ldx   #Ani_TitleScreen                   *        lea     (Ani_obj0E).l,a1
        bsr   AnimateSprite                      *        bsr.w   AnimateSprite
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *
Sonic_CreateHand                                 *Obj0E_Sonic_LastFrame:
        inc   routine_secondary,u                
        inc   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        lda   #Imgref_sonic_5                    
        sta   mapping_frame,u                    *        move.b  #$12,mapping_frame(a0)
        ldx   #IntroSonicHand                    *        lea     (IntroSonicHand).w,a1
        lda   #ObjID_TitleScreen
        sta   id,x                               *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E (flashing intro star) at $FFFFB1C0
        lda   #$A                                
        sta   subtype,x                          *        move.b  #$A,subtype(a1)                         ; Sonic's hand
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *
Sonic_CreateTails                                *loc_12F7C:
        ldd   frame_count,u     
        cmpd  #$C0                               *        cmpi.w  #$C0,objoff_34(a0)
        blo   Sonic_CreateTails_BeforeWait       *        blo.s   +
        inc   routine_secondary,u                
        inc   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        ldx   #IntroTails                        *        lea     (IntroTails).w,a1
        lda   #ObjID_TitleScreen
        sta   id,x                               *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E (flashing intro star) at $FFFFB080
        lda   #4        
        sta   subtype,x                          *        move.b  #4,subtype(a1)                          ; Tails
Sonic_CreateTails_BeforeWait                     *+
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *
Sonic_FadeInBackground                           *loc_12F9A:
        ldd   frame_count,u     
        cmpd  #$120                              *        cmpi.w  #$120,objoff_34(a0)
        blo   Sonic_FadeInBackground_NotYet      *        blo.s   +
        inc   routine_secondary,u                
        inc   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        ldd   #$0000
        std   xy_data_index,u                    *        clr.w   objoff_2C(a0)
        ldd   #$FF
        std   final_state                        *        st      objoff_2F(a0)
        ldd   #White_palette                     *        lea     (Normal_palette_line3).w,a1
        std   Ptr_palette                        *        move.w  #$EEE,d0
                                                 *
                                                 *        moveq   #$F,d6
                                                 *-       move.w  d0,(a1)+
                                                 *        dbf     d6,-
                                                 *
                            
                            
                            
                            

        ldx   #TitleScreenPaletteChanger2        *        lea     (TitleScreenPaletteChanger2).w,a1
        lda   #ObjID_TtlScrPalChanger
        sta   id,x                               *        move.b  #ObjID_TtlScrPalChanger,id(a1) ; load objC9 (palette change handler) at $FFFFB240
        lda   #2
        sta   subtype,x                          *        move.b  #2,subtype(a1)
        * not implemented                        *        move.b  #ObjID_TitleMenu,(TitleScreenMenu+id).w ; load Obj0F (title screen menu) at $FFFFB400
Sonic_FadeInBackground_NotYet                    *+
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *
Sonic_CreateSmallStar                            *loc_12FD6:
        * not implemented                        *        btst    #6,(Graphics_Flags).w ; is Megadrive PAL?
        * not implemented                        *        beq.s   + ; if not, branch
        ldd   frame_count,u     
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
        ldx   #IntroSmallStar2                   *        lea     (IntroSmallStar2).w,a1
        lda   #ObjID_IntroStars
        sta   id,x                               *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E (flashing intro star) at $FFFFB440
        lda   #$C
        sta   subtype,x                          *        move.b  #$C,subtype(a1)                         ; small star
        inc   routine_secondary,u                
        inc   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        ldx   #IntroSmallStar1                   *        lea     (IntroSmallStar1).w,a1
        bsr   DeleteObject2                      *        bsr.w   DeleteObject2 ; delete object at $FFFFB180
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *
CyclingPal                                       *loc_13014:
        lda   Vint_runcount+1                    *        move.b  (Vint_runcount+3).w,d0
        anda  #7 * every 8 frames                *        andi.b  #7,d0
        bne   CyclingPal_NotYet                  *        bne.s   ++
        ldx   color_data_index                   *        move.w  objoff_2C(a0),d0
        leax  #2,x                               *        addq.w  #2,d0
        cmpx  #CyclingPal_TitleScreen_end-CyclingPal_TitleScreen
                                                 *        cmpi.w  #CyclingPal_TitleStar_End-CyclingPal_TitleStar,d0
        blo   CyclingPal_Continue                *        blo.s   +
        ldx   #0                                 *        moveq   #0,d0
CyclingPal_Continue                              *+
        stx   color_data_index,u                 *        move.w  d0,objoff_2C(a0)
        leax  CyclingPal_TitleScreen,pcr         *        move.w  CyclingPal_TitleStar(pc,d0.w),(Normal_palette_line3+$A).w
        ldd   ,x
        std   Normal_palette+$E
CyclingPal_NotYet                                *+
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *; word_1303A:
CyclingPal_TitleScreen                           *CyclingPal_TitleStar:
                                                 *        binclude "art/palettes/Title Star Cycle.bin"
        fdb   $0F11                              * ;$0E64
        fdb   $0E31                              * ;$0E86
        fdb   $0F11                              * ;$0E64
        fdb   $0E63                              * ;$0EA8
        fdb   $0F11                              * ;$0E64
        fdb   $0E96                              * ;$0ECA
CyclingPal_TitleScreen_end                       *CyclingPal_TitleStar_End
                                                 *
Sonic_xy_data                                    *word_13046:
        fdb   $108,$D0                           *        dc.w  $108, $D0
        fdb   $100,$C0                           *        dc.w  $100, $C0 ; 2
        fdb   $F8,$B0                            *        dc.w   $F8, $B0 ; 4
        fdb   $F6,$A6                            *        dc.w   $F6, $A6 ; 6
        fdb   $FA,$9E                            *        dc.w   $FA, $9E ; 8
        fdb   $100,$9A                           *        dc.w  $100, $9A ; $A
        fdb   $104,$99                           *        dc.w  $104, $99 ; $C
        fdb   $108,$98                           *        dc.w  $108, $98 ; $E
Sonic_xy_data_end                                *word_13046_end
                                                 *; ===========================================================================
                                                 
* ---------------------------------------------------------------------------
* Tails
* ---------------------------------------------------------------------------                                            
                                                 
                                                 *
Tails                                            *Obj0E_Tails:
                                                 *        moveq   #0,d0
        inc   routine_secondary,u                
        inc   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        lda   routine_secondary,u                          
        ldx   Tails_Routines,pcr                 *        move.w  off_13074(pc,d0.w),d1
        jmp   [a,x]                              *        jmp     off_13074(pc,d1.w)                            
                                                 *; ===========================================================================
Tails_Routines                                   *off_13074:      offsetTable
        fdb   Tails_Init                         *                offsetTableEntry.w Obj0E_Tails_Init                     ; 0
        fdb                                      *                offsetTableEntry.w loc_13096                    ; 2
        fdb   TitleScreen_Animate                *                offsetTableEntry.w loc_12F52                    ; 4
        fdb                                      *                offsetTableEntry.w loc_130A2                    ; 6
        fdb   Tails_DisplaySprite                *                offsetTableEntry.w BranchTo10_DisplaySprite     ; 8
                                                 *; ===========================================================================
                                                 *
Tails_Init                                       *Obj0E_Tails_Init:
        inc   routine_secondary,u                
        inc   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        ldd   #$D8
        std   x_pixel,u                          *        move.w  #$D8,x_pixel(a0)
        std   y_pixel,u                          *        move.w  #$D8,y_pixel(a0)
        lda   #1
        sta   anim,u                             *        move.b  #1,anim(a0)
        rts                                      *        rts
                                                 *; ===========================================================================
                                                 *
Tails_Move                                       *loc_13096:
        ldy   #Tails_xy_data_end-Tails_xy_data+4                                                 
                                                 *        moveq   #word_130B8_end-word_130B8+4,d2
        ldx   #Tails_xy_data,pcr                 *        lea     (word_130B8).l,a1
        lbra  TitleScreen_MoveObjects            *        bra.w   loc_12F20
                                                 *; ===========================================================================
                                                 *
Tails_CreateHand                                 *loc_130A2:
        inc   routine_secondary,u                
        inc   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        ldx   #IntroTailsHand                    *        lea     (IntroTailsHand).w,a1
                                                 *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E (flashing intro star) at $FFFFB200
                                                 *        move.b  #$10,subtype(a1)                        ; Tails' hand
                                                 *
Tails_DisplaySprite                              *BranchTo10_DisplaySprite
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
Tails_xy_data                                    *word_130B8:
        fdb   $D7,$C8                            *        dc.w   $D7,$C8
        fdb   $D3,$B8                            *        dc.w   $D3,$B8  ; 2
        fdb   $CE,$AC                            *        dc.w   $CE,$AC  ; 4
        fdb   $CC,$A6                            *        dc.w   $CC,$A6  ; 6
        fdb   $CA,$A2                            *        dc.w   $CA,$A2  ; 8
        fdb   $C9,$A1                            *        dc.w   $C9,$A1  ; $A
        fdb   $C8,$A0                            *        dc.w   $C8,$A0  ; $C
Tails_xy_data_end                                *word_130B8_end
                                                 *; ===========================================================================
                                                 
* ---------------------------------------------------------------------------
* LogoTop
* ---------------------------------------------------------------------------                                            
                                                 
                                                 *
TitleScreen_LogoTop                              *Obj0E_LogoTop:
                                                 *        moveq   #0,d0
        inc   routine_secondary,u                
        inc   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
                                                 *        move.w  off_130E2(pc,d0.w),d1
                                                 *        jmp     off_130E2(pc,d1.w)
                                                 *; ===========================================================================
                                                 *off_130E2:      offsetTable
                                                 *                offsetTableEntry.w Obj0E_LogoTop_Init                   ; 0
                                                 *                offsetTableEntry.w BranchTo11_DisplaySprite     ; 2
                                                 *; ===========================================================================
                                                 *
                                                 *Obj0E_LogoTop_Init:
        lda   #$B ;emblem-front.png               
        sta   mapping_frame,u                    *        move.b  #$B,mapping_frame(a0)
                                                 *        tst.b   (Graphics_Flags).w
                                                 *        bmi.s   +
        lda   #$A ;emblem-front.png               
        sta   mapping_frame,u                    *        move.b  #$A,mapping_frame(a0)
                                                 *+
                                                 *        move.b  #2,priority(a0)
                                                 *        move.w  #$120,x_pixel(a0)
                                                 *        move.w  #$E8,y_pixel(a0)
                                                 *
TitleScreen_NxSRoutineAndDisplay                 *loc_1310A:
        inc   routine_secondary,u                
        inc   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
                                                 *
                                                 *BranchTo11_DisplaySprite
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 
* ---------------------------------------------------------------------------
* Sky Piece
* ---------------------------------------------------------------------------                                            
                                                 
                                                 *
TitleScreen_SkyPiece                             *Obj0E_SkyPiece:
                                                 *        moveq   #0,d0
                                                 *        move.b  routine_secondary(a0),d0
                                                 *        move.w  off_13120(pc,d0.w),d1
                                                 *        jmp     off_13120(pc,d1.w)
                                                 *; ===========================================================================
                                                 *off_13120:      offsetTable
                                                 *                offsetTableEntry.w Obj0E_SkyPiece_Init                  ; 0
                                                 *                offsetTableEntry.w BranchTo12_DisplaySprite     ; 2
                                                 *; ===========================================================================
                                                 *
                                                 *Obj0E_SkyPiece_Init:
        inc   routine_secondary,u                
        inc   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
                                                 *        move.w  #make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0)
        lda   #$11!!!!!!!!!!!!!!!                 
        sta   mapping_frame,u                    *        move.b  #$11,mapping_frame(a0)
                                                 *        move.b  #2,priority(a0)
                                                 *        move.w  #$100,x_pixel(a0)
                                                 *        move.w  #$F0,y_pixel(a0)
                                                 *
                                                 *BranchTo12_DisplaySprite
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 
* ---------------------------------------------------------------------------
* Large Star
* ---------------------------------------------------------------------------                                            
                                                 
                                                 *
TitleScreen_LargeStar                            *Obj0E_LargeStar:
                                                 *        moveq   #0,d0
                                                 *        move.b  routine_secondary(a0),d0
                                                 *        move.w  off_13158(pc,d0.w),d1
                                                 *        jmp     off_13158(pc,d1.w)
                                                 *; ===========================================================================
                                                 *off_13158:      offsetTable
                                                 *                offsetTableEntry.w Obj0E_LargeStar_Init ; 0
        fdb   TitleScreen_Animate                *                offsetTableEntry.w loc_12F52    ; 2
                                                 *                offsetTableEntry.w loc_13190    ; 4
                                                 *                offsetTableEntry.w loc_1319E    ; 6
                                                 *; ===========================================================================
                                                 *
                                                 *Obj0E_LargeStar_Init:
        inc   routine_secondary,u                
        inc   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        lda   #$C ;star.png (1)                  
        sta   mapping_frame,u                    *        move.b  #$C,mapping_frame(a0)
                                                 *        ori.w   #high_priority,art_tile(a0)
                                                 *        move.b  #2,anim(a0)
                                                 *        move.b  #1,priority(a0)
                                                 *        move.w  #$100,x_pixel(a0)
                                                 *        move.w  #$A8,y_pixel(a0)
                                                 *        move.w  #4,objoff_2A(a0)
        rts                                      *        rts
                                                 *; ===========================================================================
                                                 *
                                                 *loc_13190:
                                                 *        subq.w  #1,objoff_2A(a0)
                                                 *        bmi.s   +
        rts                                      *        rts
                                                 *; ===========================================================================
                                                 *+
        inc   routine_secondary,u                
        inc   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        rts                                      *        rts
                                                 *; ===========================================================================
                                                 *
                                                 *loc_1319E:
                                                 *        move.b  #2,routine_secondary(a0)
                                                 *        move.b  #0,anim_frame(a0)
                                                 *        move.b  #0,anim_frame_duration(a0)
                                                 *        move.w  #6,objoff_2A(a0)
                                                 *        move.w  objoff_2C(a0),d0
                                                 *        addq.w  #4,d0
                                                 *        cmpi.w  #word_131DC_end-word_131DC+4,d0
                                                 *        bhs.w   DeleteObject
                                                 *        move.w  d0,objoff_2C(a0)
                                                 *        move.l  word_131DC-4(pc,d0.w),d0
                                                 *        move.w  d0,y_pixel(a0)
                                                 *        swap    d0
                                                 *        move.w  d0,x_pixel(a0)
                                                 *        moveq   #SndID_Sparkle,d0 ; play intro sparkle sound
        rts                                      *        jmpto   (PlaySound).l, JmpTo4_PlaySound
                                                 *; ===========================================================================
                                                 *; unknown
LargeStar_xy_data                                *word_131DC:
        fdb   $DA,$F2                            *        dc.w   $DA, $F2
        fdb   $170,$F8                           *        dc.w  $170, $F8 ; 2
        fdb   $132,$131                          *        dc.w  $132,$131 ; 4
        fdb   $19E,$A2                           *        dc.w  $19E, $A2 ; 6
        fdb   $C0,$E3                            *        dc.w   $C0, $E3 ; 8
        fdb   $180,$E0                           *        dc.w  $180, $E0 ; $A
        fdb   $10D,$13B                          *        dc.w  $10D,$13B ; $C
        fdb   $C0,$AB                            *        dc.w   $C0, $AB ; $E
        fdb   $165,$107                          *        dc.w  $165, $107        ; $10
LargeStar_xy_data_end                            *word_131DC_end
                                                 *; ===========================================================================
                                                 
* ---------------------------------------------------------------------------
* Sonic Hand
* ---------------------------------------------------------------------------                                            
                                                                                                 
                                                 *
TitleScreen_SonicHand                            *Obj0E_SonicHand:
                                                 *        moveq   #0,d0
                                                 *        move.b  routine_secondary(a0),d0
                                                 *        move.w  off_1320E(pc,d0.w),d1
                                                 *        jmp     off_1320E(pc,d1.w)
                                                 *; ===========================================================================
                                                 *off_1320E:      offsetTable
                                                 *                offsetTableEntry.w Obj0E_SonicHand_Init                 ; 0
                                                 *                offsetTableEntry.w loc_13234                    ; 2
                                                 *                offsetTableEntry.w BranchTo13_DisplaySprite     ; 4
                                                 *; ===========================================================================
                                                 *
                                                 *Obj0E_SonicHand_Init:
        inc   routine_secondary,u                
        inc   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        lda   #9 ;sonic-6.png                    
        sta   mapping_frame,u                    *        move.b  #9,mapping_frame(a0) ;sonic-6.png
                                                 *        move.b  #3,priority(a0)
                                                 *        move.w  #$145,x_pixel(a0)
                                                 *        move.w  #$BF,y_pixel(a0)
                                                 *
                                                 *BranchTo13_DisplaySprite
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *
                                                 *loc_13234:
                                                 *        moveq   #word_13240_end-word_13240+4,d2
                                                 *        lea     (word_13240).l,a1
        lbra  TitleScreen_MoveObjects            *        bra.w   loc_12F20
                                                 *; ===========================================================================
SonicHand_xy_data                                *word_13240:
        fdb   $143,$C1                           *        dc.w  $143, $C1
        fdb   $140,$C2                           *        dc.w  $140, $C2 ; 2
        fdb   $141,$C1                           *        dc.w  $141, $C1 ; 4
SonicHand_xy_data_end                            *word_13240_end
                                                 *; ===========================================================================
                                                 
* ---------------------------------------------------------------------------
* Tails Hand                                     
* ---------------------------------------------------------------------------
                                                 
                                                 *
TailsHand                                        *Obj0E_TailsHand:
                                                 *        moveq   #0,d0
        lda   routine_secondary,u                *        move.b  routine_secondary(a0),d0
        ldx   TailsHand_Routines
                                                 *        move.w  off_1325A(pc,d0.w),d1
        jmp   [a,x]                              *        jmp     off_1325A(pc,d1.w)
                                                 *; ===========================================================================
TailsHand_Routines                               *off_1325A:      offsetTable
        fdb   TailsHand_Init                     *                offsetTableEntry.w Obj0E_TailsHand_Init                 ; 0
        fdb   TailsHand_Move                     *                offsetTableEntry.w loc_13280                    ; 2
        fdb   TailsHand_DisplaySprite                          
                                                 *                offsetTableEntry.w BranchTo14_DisplaySprite     ; 4
                                                 *; ===========================================================================
                                                 *
TailsHand_Init                                   *Obj0E_TailsHand_Init:
        inc   routine_secondary,u                
        inc   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        ldd   #Imgref_tailsHand                  
        std   mapping_frame,u                    *        move.b  #$13,mapping_frame(a0)
        lda   #3                                 
        sta   priority,u                         *        move.b  #3,priority(a0)
        ldd   #$10F                              
        std   x_pixel                            *        move.w  #$10F,x_pixel(a0)
        ldd   #$D5                               
        std   y_pixel                            *        move.w  #$D5,y_pixel(a0)
                                                 *
TailsHand_DisplaySprite                          *BranchTo14_DisplaySprite
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *
TailsHand_Move                                   *loc_13280:
        ldy   #TailsHand_xy_data_end-TailsHand_xy_data+4
                                                 *        moveq   #word_1328C_end-word_1328C+4,d2
        ldx   #TailsHand_xy_data,pcr             *        lea     (word_1328C).l,a1
        lbra  TitleScreen_MoveObjects            *        bra.w   loc_12F20
                                                 *; ===========================================================================
TailsHand_xy_data                                *word_1328C:
        fdb   $10C,$D0                           *        dc.w  $10C, $D0
        fdb   $10D,$D1                           *        dc.w  $10D, $D1 ; 2
TailsHand_xy_data_end                            *word_1328C_end
                                                 *; ===========================================================================
                                                 
* ---------------------------------------------------------------------------
* Small Star                                     
* ---------------------------------------------------------------------------
                                                                                       
                                                 *
SmallStar                                        *Obj0E_SmallStar:
                                                 *        moveq   #0,d0
                                                 *        move.b  routine_secondary(a0),d0
                                                 *        move.w  off_132A2(pc,d0.w),d1
                                                 *        jmp     off_132A2(pc,d1.w)
                                                 *; ===========================================================================
                                                 *off_132A2:      offsetTable
                                                 *                offsetTableEntry.w Obj0E_SmallStar_Init ; 0
                                                 *                offsetTableEntry.w loc_132D2    ; 2
                                                 *; ===========================================================================
                                                 *
SmallStar_Init                                   *Obj0E_SmallStar_Init:
        inc   routine_secondary,u                
        inc   routine_secondary,u                *        addq.b  #2,routine_secondary(a0)
        lda   #$C ;star.png (1)                  
        sta   mapping_frame,u                    *        move.b  #$C,mapping_frame(a0)
                                                 *        move.b  #5,priority(a0)
                                                 *        move.w  #$170,x_pixel(a0)
                                                 *        move.w  #$80,y_pixel(a0)
                                                 *        move.b  #3,anim(a0)
                                                 *        move.w  #$8C,objoff_2A(a0)
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                 *
                                                 *loc_132D2:
                                                 *        subq.w  #1,objoff_2A(a0)
                                                 *        bmi.w   DeleteObject
                                                 *        subq.w  #2,x_pixel(a0)
                                                 *        addq.w  #1,y_pixel(a0)
                                                 *        lea     (Ani_obj0E).l,a1
        bsr   AnimateSprite                      *        bsr.w   AnimateSprite
        jmp   DisplaySprite                      *        bra.w   DisplaySprite
                                                 *; ===========================================================================
                                                                                 
* ***************************************************************************
* Palette changing handler
* ***************************************************************************                                            
                                                 
                                                 *; ----------------------------------------------------------------------------
                                                 *; Object C9 - "Palette changing handler" from title screen
                                                 *; ----------------------------------------------------------------------------
                                                 *ttlscrpalchanger_fadein_time_left = objoff_30
                                                 *ttlscrpalchanger_fadein_time = objoff_31
                                                 *ttlscrpalchanger_fadein_amount = objoff_32
                                                 *ttlscrpalchanger_start_offset = objoff_34
                                                 *ttlscrpalchanger_length = objoff_36
                                                 *ttlscrpalchanger_codeptr = objoff_3A
                                                 *
                                                 *; Sprite_132F0:
                                                 *ObjC9:
                                                 *        moveq   #0,d0
                                                 *        move.b  routine(a0),d0
                                                 *        move.w  ObjC9_Index(pc,d0.w),d1
                                                 *        jmp     ObjC9_Index(pc,d1.w)
                                                 *; ===========================================================================
                                                 *ObjC9_Index:    offsetTable
                                                 *                offsetTableEntry.w ObjC9_Init   ; 0
                                                 *                offsetTableEntry.w ObjC9_Main   ; 2
                                                 *; ===========================================================================
                                                 *
                                                 *ObjC9_Init:
                                                 *        addq.b  #2,routine(a0)
                                                 *        moveq   #0,d0
                                                 *        move.b  subtype(a0),d0
                                                 *        lea     (PaletteChangerDataIndex).l,a1
                                                 *        adda.w  (a1,d0.w),a1
                                                 *        move.l  (a1)+,ttlscrpalchanger_codeptr(a0)
                                                 *        movea.l (a1)+,a2
                                                 *        move.b  (a1)+,d0
                                                 *        move.w  d0,ttlscrpalchanger_start_offset(a0)
                                                 *        lea     (Target_palette).w,a3
                                                 *        adda.w  d0,a3
                                                 *        move.b  (a1)+,d0
                                                 *        move.w  d0,ttlscrpalchanger_length(a0)
                                                 *
                                                 *-       move.w  (a2)+,(a3)+
                                                 *        dbf     d0,-
                                                 *
                                                 *        move.b  (a1)+,d0
                                                 *        move.b  d0,ttlscrpalchanger_fadein_time_left(a0)
                                                 *        move.b  d0,ttlscrpalchanger_fadein_time(a0)
                                                 *        move.b  (a1)+,ttlscrpalchanger_fadein_amount(a0)
        rts                                      *        rts
                                                 *; ===========================================================================
                                                 *
                                                 *ObjC9_Main:
                                                 *        subq.b  #1,ttlscrpalchanger_fadein_time_left(a0)
                                                 *        bpl.s   +
                                                 *        move.b  ttlscrpalchanger_fadein_time(a0),ttlscrpalchanger_fadein_time_left(a0)
                                                 *        subq.b  #1,ttlscrpalchanger_fadein_amount(a0)
                                                 *        bmi.w   DeleteObject
                                                 *        movea.l ttlscrpalchanger_codeptr(a0),a2
                                                 *        movea.l a0,a3
                                                 *        move.w  ttlscrpalchanger_length(a0),d0
                                                 *        move.w  ttlscrpalchanger_start_offset(a0),d1
                                                 *        lea     (Normal_palette).w,a0
                                                 *        adda.w  d1,a0
                                                 *        lea     (Target_palette).w,a1
                                                 *        adda.w  d1,a1
                                                 *
                                                 *-       jsr     (a2)    ; dynamic call! to Pal_FadeFromBlack.UpdateColour, loc_1344C, or loc_1348A, assuming the PaletteChangerData pointers haven't been changed
                                                 *        dbf     d0,-
                                                 *
                                                 *        movea.l a3,a0
                                                 *+
        rts                                      *        rts
                                                 *; ===========================================================================
                                                 *; off_1337C:
                                                 *PaletteChangerDataIndex: offsetTable
                                                 *        offsetTableEntry.w off_1338C    ;  0
                                                 *        offsetTableEntry.w off_13398    ;  2
                                                 *        offsetTableEntry.w off_133A4    ;  4
                                                 *        offsetTableEntry.w off_133B0    ;  6
                                                 *        offsetTableEntry.w off_133BC    ;  8
                                                 *        offsetTableEntry.w off_133C8    ; $A
                                                 *        offsetTableEntry.w off_133D4    ; $C
                                                 *        offsetTableEntry.w off_133E0    ; $E
                                                 *
                                                 *C9PalInfo macro codeptr,dataptr,loadtoOffset,length,fadeinTime,fadeinAmount
                                                 *        dc.l codeptr, dataptr
                                                 *        dc.b loadtoOffset, length, fadeinTime, fadeinAmount
                                                 *    endm
                                                 *
                                                 *off_1338C:      C9PalInfo Pal_FadeFromBlack.UpdateColour, Pal_1342C, $60, $F,2,$15
                                                 *off_13398:      C9PalInfo                      loc_1344C, Pal_1340C, $40, $F,4,7
                                                 *off_133A4:      C9PalInfo                      loc_1344C,  Pal_AD1E,   0, $F,8,7
                                                 *off_133B0:      C9PalInfo                      loc_1348A,  Pal_AD1E,   0, $F,8,7
                                                 *off_133BC:      C9PalInfo                      loc_1344C,  Pal_AC7E,   0,$1F,4,7
                                                 *off_133C8:      C9PalInfo                      loc_1344C,  Pal_ACDE, $40,$1F,4,7
                                                 *off_133D4:      C9PalInfo                      loc_1344C,  Pal_AD3E,   0, $F,4,7
                                                 *off_133E0:      C9PalInfo                      loc_1344C,  Pal_AC9E,   0,$1F,4,7
                                                 *
                                                 *Pal_133EC:      BINCLUDE "art/palettes/Title Sonic.bin"
                                                 *Pal_1340C:      BINCLUDE "art/palettes/Title Background.bin"
                                                 *Pal_1342C:      BINCLUDE "art/palettes/Title Emblem.bin"
                                                 *
                                                 *; ===========================================================================
                                                 *
                                                 *loc_1344C:
                                                 *
                                                 *        move.b  (a1)+,d2
                                                 *        andi.b  #$E,d2
                                                 *        move.b  (a0),d3
                                                 *        cmp.b   d2,d3
                                                 *        bls.s   loc_1345C
                                                 *        subq.b  #2,d3
                                                 *        move.b  d3,(a0)
                                                 *
                                                 *loc_1345C:
                                                 *        addq.w  #1,a0
                                                 *        move.b  (a1)+,d2
                                                 *        move.b  d2,d3
                                                 *        andi.b  #$E0,d2
                                                 *        andi.b  #$E,d3
                                                 *        move.b  (a0),d4
                                                 *        move.b  d4,d5
                                                 *        andi.b  #$E0,d4
                                                 *        andi.b  #$E,d5
                                                 *        cmp.b   d2,d4
                                                 *        bls.s   loc_1347E
                                                 *        subi.b  #$20,d4
                                                 *
                                                 *loc_1347E:
                                                 *        cmp.b   d3,d5
                                                 *        bls.s   loc_13484
                                                 *        subq.b  #2,d5
                                                 *
                                                 *loc_13484:
                                                 *        or.b    d4,d5
                                                 *        move.b  d5,(a0)+
        rts                                      *        rts
                                                 *; ===========================================================================
                                                 *
                                                 *loc_1348A:
                                                 *        moveq   #$E,d2
                                                 *        move.b  (a0),d3
                                                 *        and.b   d2,d3
                                                 *        cmp.b   d2,d3
                                                 *        bhs.s   loc_13498
                                                 *        addq.b  #2,d3
                                                 *        move.b  d3,(a0)
                                                 *
                                                 *loc_13498:
                                                 *        addq.w  #1,a0
                                                 *        move.b  (a0),d3
                                                 *        move.b  d3,d4
                                                 *        andi.b  #$E0,d3
                                                 *        andi.b  #$E,d4
                                                 *        cmpi.b  #-$20,d3
                                                 *        bhs.s   loc_134B0
                                                 *        addi.b  #$20,d3
                                                 *
                                                 *loc_134B0:
                                                 *        cmp.b   d2,d4
                                                 *        bhs.s   loc_134B6
                                                 *        addq.b  #2,d4
                                                 *
                                                 *loc_134B6:
                                                 *        or.b    d3,d4
                                                 *        move.b  d4,(a0)+
        rts                                      *        rts
                                                 *
                                                 
* ---------------------------------------------------------------------------
* Subroutines
* ---------------------------------------------------------------------------                                            
                                                                                                 
                                                 *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                                 *
                                                 *
TitleScreen_SetFinalState                        *TitleScreen_SetFinalState:
                                                 *        tst.b   objoff_2F(a0)
                                                 *        bne.w   +       ; rts
                                                 *        move.b  (Ctrl_1_Press).w,d0
                                                 *        or.b    (Ctrl_2_Press).w,d0
                                                 *        andi.b  #button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_B_mask|button_C_mask|button_A_mask,(Ctrl_1_Press).w
                                                 *        andi.b  #button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_B_mask|button_C_mask|button_A_mask,(Ctrl_2_Press).w
                                                 *        andi.b  #button_start_mask,d0
                                                 *        beq.w   +       ; rts
                                                 *        st.b    objoff_2F(a0)
                                                 *        move.b  #$10,routine_secondary(a0)
        lda   #Imgref_sonic_5                   
        sta   mapping_frame,u                    *        move.b  #$12,mapping_frame(a0)
                                                 *        move.w  #$108,x_pixel(a0)
                                                 *        move.w  #$98,y_pixel(a0)
                                                 *        lea     (IntroSonicHand).w,a1
                                                 *        bsr.w   TitleScreen_InitSprite
                                                 *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E (flashing intro star) at $FFFFB1C0
                                                 *        move.b  #$A,routine(a1)                         ; Sonic's hand
                                                 *        move.b  #2,priority(a1)
        lda   #Imgref_sonicHand                  
        sta   mapping_frame,x                    *        move.b  #9,mapping_frame(a1)
                                                 *        move.b  #4,routine_secondary(a1)
                                                 *        move.w  #$141,x_pixel(a1)
                                                 *        move.w  #$C1,y_pixel(a1)
                                                 *        lea     (IntroTails).w,a1
                                                 *        bsr.w   TitleScreen_InitSprite
                                                 *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E
                                                 *        move.b  #4,routine(a1)                          ; Tails
        lda   #Imgref_tails_5                    
        sta   mapping_frame,x                    *        move.b  #4,mapping_frame(a1)
                                                 *        move.b  #6,routine_secondary(a1)
                                                 *        move.b  #3,priority(a1)
                                                 *        move.w  #$C8,x_pixel(a1)
                                                 *        move.w  #$A0,y_pixel(a1)
                                                 *        lea     (IntroTailsHand).w,a1
                                                 *        bsr.w   TitleScreen_InitSprite
                                                 *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E
                                                 *        move.b  #$10,routine(a1)                        ; Tails' hand
                                                 *        move.b  #2,priority(a1)
        lda   #Imgref_tailsHand                  
        sta   mapping_frame,x                    *        move.b  #$13,mapping_frame(a1)
                                                 *        move.b  #4,routine_secondary(a1)
                                                 *        move.w  #$10D,x_pixel(a1)
                                                 *        move.w  #$D1,y_pixel(a1)
                                                 *        lea     (IntroEmblemTop).w,a1
                                                 *        move.b  #ObjID_IntroStars,id(a1) ; load obj0E
                                                 *        move.b  #6,subtype(a1)                          ; logo top
        bsr   EmblemOverlay                      *        bsr.w   sub_12F08
                                                 *        move.b  #ObjID_TitleMenu,(TitleScreenMenu+id).w ; load Obj0F (title screen menu) at $FFFFB400
                                                 *        lea     (TitleScreenPaletteChanger).w,a1
                                                 *        bsr.w   DeleteObject2
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
                                                 *
        * music unused                           *        tst.b   objoff_30(a0)
        * music unused                           *        bne.s   +       ; rts
        * music unused                           *        moveq   #MusID_Title,d0 ; title music
        * music unused                           *        jsrto   (PlayMusic).l, JmpTo4_PlayMusic
        * music unused                           *+
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
                                                 *        move.l  #Obj0E_MapUnc_136A8,mappings(a1)
                                                 *        move.w  #make_art_tile(ArtTile_ArtNem_TitleSprites,0,0),art_tile(a1)
                                                 *        move.b  #4,priority(a1)
        rts                                      *        rts
                                                 *; End of function TitleScreen_InitSprite
                                                 *
                                                 *; ===========================================================================
                                                 
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