; ---------------------------------------------------------------------------
; Object - PaletteHandler
;
; input REG : [u] pointeur sur l'objet (SST)
;
; --------------------------------------
;
; Implantation memoire
; --------------------
; Appel a une routine du main (6100 - 9FFF) : utiliser un saut (jmp, jsr, rts), ne pas utiliser les branchements.
; Appel a une routine interne de l'objet : utiliser les branchements ((l)b__), ne pas utiliser les sauts.
; Utilisation de l'adressage indexe pour acceder a des donnees internes de l'objet : utilisation de "mon_tableau,pcr" pour charger l'adresse du tableau dans un registre
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
; ---------------------------------------------------------------------------

;*******************************************************************************
; Animation de la palette: fondu vers une couleur cible PAL_TO
;*******************************************************************************
; Ecriture en $E7DB de l'adresse ou sera stockee la couleur.
;
; les adresses vont de deux en deux car il y a deux octets a stocker par couleur.
; couleur: 0, adresse: 00
; couleur: 1, adresse: 02
; couleur: 2, adresse: 04
; ...
;
; Deux ecritures en $E7DA (auto-increment a partir de l'adresse couleur
;                          positionnee en $E7DB) pour la valeur de couleur.
;
;                             V V V V                 R R R R
; Premiere adresse        fondamentale V          fondamentale R
;
; Deuxieme adresse            X X X M                 B B B B
; auto-incrementee        bit de marquage         fondamentale B
;                       (incrustation video)
;
; Attention: les instructions suivantes effectuent une lecture avant l'ecriture
; ASL, ASR, CLR, COM, DEL, INC, LSL, LSR, NEG, ROL, RDR
; un seul appel sur $E7DA va lire $E7DA puis ecrire sur la seconde adresse $E7DA 
; Sur $E7DA il faut donc utiliser l'instruction ST pour ecrire
;*******************************************************************************   
								       
(main)MAIN
        INCLUD GLOBALS
        INCLUD CONSTANT
        org   $A000     

* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------
pal_src      equ ext_variables         * pointeur vers palette source
pal_dst      equ ext_variables+2       * pointeur vers palette destination
pal_cycles   equ ext_variables+4       * nombre de frames de la transition (VSYNC)
curpal       rmb 32,0

pal_mask     fcb $0F                   * masque pour l'aternance du traitemet vert/rouge
pal_buffer   fdb $00                   * buffer de comparaison
pal_idx      fcb $00                   * index de la couleur courante dans le traitement
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
PaletteHandler                                   *ObjC9:
                                                 *        moveq   #0,d0
        lda   routine,u                          *        move.b  routine(a0),d0
        leax  <PaletteHandler_Routines,pcr       *        move.w  ObjC9_Index(pc,d0.w),d1
        jmp   [a,x]                              *        jmp     ObjC9_Index(pc,d1.w)
                                                 *; ===========================================================================
PaletteHandler_Routines                          *ObjC9_Index:    offsetTable
        fdb   PaletteHandler_Init                *                offsetTableEntry.w ObjC9_Init   ; 0
        fdb   PaletteHandler_Main                *                offsetTableEntry.w ObjC9_Main   ; 2
                                                 *; ===========================================================================
                                                 *
PaletteHandler_Init                              *ObjC9_Init:
        ldy   pal_src                  * chargement pointeur valeur des couleurs actuelles
        ldx   pal_dst
        clr   pal_idx
PalRun
        lda   ,y			           * chargement de la composante verte et rouge
        anda  pal_mask                 * on efface la valeur vert ou rouge par masque
        ldb   ,x                       * composante verte et rouge couleur cible
        andb  pal_mask                 * on efface la valeur vert ou rouge par masque
        stb   pal_buffer               * on stocke la valeur cible pour comparaison
        ldb   #$11                     * preparation de la valeur d'increment de couleur
        andb  pal_mask                 * on efface la valeur non utile par masque
        stb   pal_buffer+1             * on stocke la valeur pour ADD ou SUB ulterieur
        cmpa  pal_buffer               * comparaison de la composante courante et cible
        beq   PalVRSuivante            * si composante est egale a la cible on passe
        bhi   PalVRDec                 * si la composante est superieure on branche
        lda   ,y                       * on recharge la valeur avec vert et rouge
        adda  pal_buffer+1             * on incremente la composante verte ou rouge
        bra   PalVRSave                * on branche pour sauvegarder
PalVRDec
        lda   ,y                       * on recharge la valeur avec vert et rouge
        suba  pal_buffer+1             * on decremente la composante verte ou rouge
PalVRSave                             
        sta   ,y                       * sauvegarde de la nouvelle valeur vert ou rouge
PalVRSuivante                         
        com   pal_mask                 * inversion du masque pour traiter l'autre semioctet
        bmi   PalRun                   * si on traite $F0 on branche sinon on continue
	    
SetPalBleu
        ldb   1,y			           * chargement composante bleue courante
        cmpb  1,x                      * comparaison composante courante et cible
        beq   SetPalNext               * si composante est egale a la cible on passe
        bhi   SetPalBleudec            * si la composante est superieure on branche
        incb                           * on incremente la composante bleue
        bra   SetPalSaveBleu           * on branche pour sauvegarder
SetPalBleudec                       
        decb                           * on decremente la composante bleue
SetPalSaveBleu                         
        stb   1,y                      * sauvegarde de la nouvelle valeur bleue
								       
SetPalNext                             
        lda   pal_idx                  * Lecture index couleur
        asla
        sta   $E7DB                    * selectionne l'indice de couleur a ecrire
        lda   ,y                       * chargement de la nouvelle couleur courante
        sta   $E7DA                    * positionne la nouvelle couleur (Vert et Rouge)
        stb   $E7DA                    * positionne la nouvelle couleur (Bleu)
        leay  2,y                      * on avance le pointeur vers la nouvelle couleur source
        leax  2,x                      * on avance le pointeur vers la nouvelle couleur dest
        inc   pal_idx
        lda   pal_idx
        cmpa  #$10  
        beq   PalRun                   * on reboucle si fin de liste pas atteinte
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
PaletteHandler_Main                              *ObjC9_Main:
        dec   pal_cycles               * decremente le compteur du nombre de frame
        bne   PaletteHandler_Init      * on reboucle si nombre de frame n'est pas realise
        clr   ,u                       * auto-destruction de l'objet
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
                                                 *        rts
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
                                                 *        rts

(include)GLOBALS
* Generated Code

GameModeLoader equ $414F
current_game_mode_data equ $41C7
ObjID_PaletteHandler equ 1
ObjID_TitleScreen equ 2
Object_RAM equ $65C5
screen_border_color equ $6D3C
Vint_runcount equ $6D59
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
Dpad_Held equ $6D5B
Fire_Held equ $6D5C
Dpad_Press equ $6D5D
Fire_Press equ $6D5E
MarkObjGone equ $6DBF
DisplaySprite_x equ $6DC1
DisplaySprite equ $6DC7
AnimateSprite equ $6E40
DeleteObject_x equ $6F01
DeleteObject equ $6F07
ClearObj equ $6FC9
Img_star_4 equ $77CB
Img_star_3 equ $77D9
Img_sonicHand equ $77E7
Img_star_2 equ $77F5
Img_star_1 equ $7803
Img_emblemBack08 equ $7811
Img_emblemBack07 equ $781F
Img_emblemBack09 equ $782D
Img_emblemBack04 equ $783B
Img_emblemBack03 equ $7849
Img_emblemBack06 equ $7857
Img_emblemBack05 equ $7865
Img_tails_5 equ $7873
Img_tails_4 equ $7881
Img_tails_3 equ $788F
Img_tails_2 equ $789D
Img_tails_1 equ $78AB
Img_tailsHand equ $78B9
Img_sonic_1 equ $78C7
Img_sonic_2 equ $78D5
Img_emblemBack02 equ $78E3
Img_emblemBack01 equ $78F1
Img_sonic_5 equ $78FF
Img_sonic_3 equ $790D
Img_sonic_4 equ $791B
Img_emblemFront07 equ $7929
Img_emblemFront08 equ $7937
Img_emblemFront05 equ $7945
Img_emblemFront06 equ $7953
Img_emblemFront03 equ $7961
Img_emblemFront04 equ $796F
Img_emblemFront01 equ $797D
Img_emblemFront02 equ $798B
Ani_smallStar equ $799A
Ani_largeStar equ $79A0
Ani_tails equ $79AC
Ani_sonic equ $79B8

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
screen_bottom                 equ 200+28 ; in pixel
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

page_bckdraw_routine          equ 0
bckdraw_routine               equ 1
page_draw_routine             equ 3
draw_routine                  equ 4
page_erase_routine            equ 6
erase_routine                 equ 7
erase_nb_cell                 equ 9
image_x1_offset_l             equ 10
image_y1_offset_l             equ 11
image_x_size_l                equ 12
image_y_size_l                equ 13
image_meta_size               equ 14 ; number of bytes for each image reference

* ===========================================================================
* Object Constants
* ===========================================================================

nb_reserved_objects           equ 2
nb_dynamic_objects            equ 18
nb_level_objects              equ 3
nb_objects                    equ 23 * max 64 total

* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------

object_size                   equ 82 ; the size of an object - DEPENDENCY ClearObj routine
next_object                   equ object_size

id                            equ 0           ; reference to object model id (ObjID_) (0: free slot)
subtype                       equ 1           ; reference to object subtype (Sub_)
render_flags                  equ 2

* --- render_flags bitfield variables ---
render_xmirror_mask           equ $01 ; (bit 0) tell display engine to mirror sprite on horizontal axis
render_ymirror_mask           equ $02 ; (bit 1) tell display engine to mirror sprite on vertical axis
render_playfieldcoord_mask    equ $04 ; (bit 2) tell display engine to use playfield (1) or screen (0) coordinates
render_hide_mask              equ $08 ; (bit 3) tell display engine to hide sprite (keep priority and mapping_frame)
render_fixedoverlay_mask      equ $10 ; (bit 4) non moving sprite on top of the others (you should also set priority=1, playfieldcoord=0)
render_todelete_mask          equ $20 ; (bit 5) tell display engine to delete sprite and clear OST for this object
render_free2_mask             equ $40 ; (bit 6) free
render_free3_mask             equ $80 ; (bit 7) free
 
priority                      equ 3           ; display priority (0: nothing to display, 1:front, ..., 8:back)
anim                          equ 4  ; and 5  ; reference to current animation (Ani_)
prev_anim                     equ 6  ; and 7  ; reference to previous animation (Ani_)
anim_frame                    equ 8           ; index of current frame in animation
anim_frame_duration           equ 9           ; number of frames for each image in animation, range: 00-7F (0-127), 0 means display only during one frame
mapping_frame                 equ 10 ; and 11 ;reference to current image (Img_) (0000 if no image)
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
rsv_render_erasesprite_mask   equ $02 ; (bit 1) if a sprite need to be cleared on screen - DEPENDENCY adapt CSR_SetDrawTrue routine
rsv_render_displaysprite_mask equ $04 ; (bit 2) if a sprite need to be rendered on screen
rsv_render_outofrange_mask    equ $08 ; (bit 3) if a sprite is out of range for full rendering in screen

rsv_prev_anim                 equ 42 ; and 43 ; reference to previous animation (Ani_) w
rsv_curr_mapping_frame        equ 44 ; and 45 ; reference to current image regarding mirror flags (0000 if no image) w
rsv_xy1_pixel                 equ 46          ;
rsv_x1_pixel                  equ 46          ; x+x_offset-(x_size/2) screen coordinate
rsv_y1_pixel                  equ 47          ; y+y_offset-(y_size/2) screen coordinate, must follow rsv_x1_pixel
rsv_xy2_pixel                 equ 48          ;
rsv_x2_pixel                  equ 48          ; x+x_offset+(x_size/2) screen coordinate
rsv_y2_pixel                  equ 49          ; y+y_offset+(y_size/2) screen coordinate, must follow rsv_x2_pixel

* ---------------------------------------------------------------------------
* reserved variables (engine) - buffer specific

rsv_buffer_0                  equ 50 ; Start index of buffer 0 variables
rsv_priority_0                equ 50 ; internal value that hold priority in video buffer 0
rsv_priority_prev_obj_0       equ 51 ; and 52 ; previous object (OST address) in display priority list for video buffer 0 (0000 if none) w
rsv_priority_next_obj_0       equ 53 ; and 54 ; next object (OST address) in display priority list for video buffer 0 (0000 if none) w
rsv_prev_mapping_frame_0      equ 55 ; and 56 ; reference to previous image in video buffer 0 (Img_) (0000 if no image) w
rsv_bgdata_0                  equ 57 ; and 58 ; address of background data in screen 0 w
rsv_prev_xy_pixel_0           equ 59 ;
rsv_prev_x_pixel_0            equ 59 ; previous x screen coordinate b
rsv_prev_y_pixel_0            equ 60 ; previous y screen coordinate b, must follow x_pixel
rsv_prev_xy1_pixel_0          equ 61 ;
rsv_prev_x1_pixel_0           equ 61 ; previous x+x_offset-(x_size/2) screen coordinate b
rsv_prev_y1_pixel_0           equ 62 ; previous y+y_offset-(y_size/2) screen coordinate b, must follow x1_pixel
rsv_prev_xy2_pixel_0          equ 63 ;
rsv_prev_x2_pixel_0           equ 63 ; previous x+x_offset+(x_size/2) screen coordinate b
rsv_prev_y2_pixel_0           equ 64 ; previous y+y_offset+(y_size/2) screen coordinate b, must follow x2_pixel
rsv_onscreen_0                equ 65 ; has been rendered on screen buffer 0

rsv_buffer_1                  equ 66 ; Start index of buffer 1 variables
rsv_priority_1                equ 66 ; internal value that hold priority in video buffer 1
rsv_priority_prev_obj_1       equ 67 ; and 68 ; previous object (OST address) in display priority list for video buffer 1 (0000 if none) w
rsv_priority_next_obj_1       equ 69 ; and 70 ; next object (OST address) in display priority list for video buffer 1 (0000 if none) w
rsv_prev_mapping_frame_1      equ 71 ; and 72 ; reference to previous image in video buffer 1 (Img_) (0000 if no image) w
rsv_bgdata_1                  equ 73 ; and 74 ; address of background data in screen 1 w
rsv_prev_xy_pixel_1           equ 75 ;
rsv_prev_x_pixel_1            equ 75 ; previous x screen coordinate b
rsv_prev_y_pixel_1            equ 76 ; previous y screen coordinate b, must follow x_pixel
rsv_prev_xy1_pixel_1          equ 77 ;
rsv_prev_x1_pixel_1           equ 77 ; previous x+x_size screen coordinate b
rsv_prev_y1_pixel_1           equ 78 ; previous y+y_size screen coordinate b, must follow x_pixel
rsv_prev_xy2_pixel_1          equ 79 ;
rsv_prev_x2_pixel_1           equ 79 ; previous x+x_size screen coordinate b
rsv_prev_y2_pixel_1           equ 80 ; previous y+y_size screen coordinate b, must follow x_pixel
rsv_onscreen_1                equ 81 ; has been rendered on screen buffer 1

buf_priority                  equ 0  ; offset for each rsv_buffer variables
buf_priority_prev_obj         equ 1  ;
buf_priority_next_obj         equ 3  ;
buf_prev_mapping_frame        equ 5  ;
buf_bgdata                    equ 7  ;
buf_prev_xy_pixel             equ 9  ;
buf_prev_x_pixel              equ 9  ;
buf_prev_y_pixel              equ 10 ;
buf_prev_xy1_pixel            equ 11 ;
buf_prev_x1_pixel             equ 11 ;
buf_prev_y1_pixel             equ 12 ;
buf_prev_xy2_pixel            equ 13 ;
buf_prev_x2_pixel             equ 13 ;
buf_prev_y2_pixel             equ 14 ;
buf_onscreen                  equ 15 ;