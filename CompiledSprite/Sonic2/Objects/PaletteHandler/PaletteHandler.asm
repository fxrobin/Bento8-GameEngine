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
pal_cur      rmb 32,0

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
        ldy   pal_src
        ldx   pal_cur
        leay  16,y
        leax  16,x
        ldd   -16,y
        std   -16,x
        ldd   -14,y
        std   -14,x
        ldd   -12,y
        std   -12,x
        ldd   -10,y
        std   -10,x
        ldd   -8,y
        std   -8,x
        ldd   -6,y
        std   -6,x
        ldd   -4,y
        std   -4,x
        ldd   -2,y
        std   -2,x
        ldd   ,y
        std   ,x
        ldd   2,y
        std   2,x
        ldd   4,y
        std   4,x
        ldd   6,y
        std   6,x
        ldd   8,y
        std   8,x
        ldd   10,y
        std   10,x
        ldd   12,y
        std   12,x
        ldd   14,y
        std   14,x
                        
PaletteHandler_Run
        ldy   pal_cur                  * chargement pointeur valeur des couleurs actuelles
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
        bne   PaletteHandler_Run       * on reboucle si nombre de frame n'est pas realise
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