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

PaletteHandler

        lda   routine,u
        sta   *+4,pcr
        bra   PaletteHandler_Routines
 
PaletteHandler_Routines
        lbra  PaletteHandler_Init
        lbra  PaletteHandler_Main
 
PaletteHandler_Init
        sts   PHI_Rts+1,pcr            * Bug c6809 devrait etre +2
        lda   routine,u
        adda  #$03
        sta   routine,u
        lda   #$10    
        sta   pal_cycles,pcr    
        ldx   pal_dst,u
        ldy   pal_src,u
        leas  pal_cur,pcr
        clr   pal_idx,pcr                        
PHI_Loop
        lda   ,y	                   * chargement de la composante verte et rouge
        anda  pal_mask,pcr             * on efface la valeur vert ou rouge par masque
        ldb   ,x                       * composante verte et rouge couleur cible
        andb  pal_mask,pcr             * on efface la valeur vert ou rouge par masque
        stb   pal_buffer,pcr           * on stocke la valeur cible pour comparaison
        ldb   #$11                     * preparation de la valeur d'increment de couleur
        andb  pal_mask,pcr             * on efface la valeur non utile par masque
        stb   pal_buffer+1,pcr         * on stocke la valeur pour ADD ou SUB ulterieur
        cmpa  pal_buffer,pcr           * comparaison de la composante courante et cible
        beq   PHI_VRSuivante           * si composante est egale a la cible on passe
        bhi   PHI_VRDec                * si la composante est superieure on branche
        lda   ,y                       * on recharge la valeur avec vert et rouge
        adda  pal_buffer+1,pcr         * on incremente la composante verte ou rouge
        bra   PHI_VRSave               * on branche pour sauvegarder
PHI_VRDec
        lda   ,y                       * on recharge la valeur avec vert et rouge
        suba  pal_buffer+1,pcr         * on decremente la composante verte ou rouge
PHI_VRSave                             
        sta   ,s                       * sauvegarde de la nouvelle valeur vert ou rouge
PHI_VRSuivante                         
        com   pal_mask,pcr             * inversion du masque pour traiter l'autre semioctet
        bmi   PHI_Loop                 * si on traite $F0 on branche sinon on continue
	    
PHI_SetPalBleu
        ldb   1,y                      * chargement composante bleue courante
        cmpb  1,x                      * comparaison composante courante et cible
        beq   PHI_SetPalNext           * si composante est egale a la cible on passe
        bhi   PHI_SetPalBleudec        * si la composante est superieure on branche
        incb                           * on incremente la composante bleue
        bra   PHI_SetPalSaveBleu       * on branche pour sauvegarder
PHI_SetPalBleudec                       
        decb                           * on decremente la composante bleue
PHI_SetPalSaveBleu                         
        stb   1,s                      * sauvegarde de la nouvelle valeur bleue
								       
PHI_SetPalNext                             
        lda   pal_idx,pcr              * Lecture index couleur
        asla
        sta   $E7DB                    * selectionne l'indice de couleur a ecrire
        lda   ,s                       * chargement de la nouvelle couleur courante
        sta   $E7DA                    * positionne la nouvelle couleur (Vert et Rouge)
        stb   $E7DA                    * positionne la nouvelle couleur (Bleu)
        leay  2,y                      * on avance le pointeur vers la nouvelle couleur source
        leax  2,x                      * on avance le pointeur vers la nouvelle couleur dest
        leas  2,s                      * on avance le pointeur vers la couleur intermediaire
        inc   pal_idx,pcr
        lda   pal_idx,pcr
        cmpa  #$10  
        bne   PHI_Loop                 * on reboucle si fin de liste pas atteinte

PHI_Rts
        lds   #$0000
        rts
                                                 
PaletteHandler_Main
        sts   PHI_Rts+1,pcr            * Bug c6809 devrait etre +2
        ldx   pal_dst,u
        leay  pal_cur,pcr
        leas  pal_cur,pcr
        clr   pal_idx,pcr   
        dec   pal_cycles,pcr           * decremente le compteur du nombre de frame
        lbne  PHI_Loop                 * on reboucle si nombre de frame n'est pas realise
        clr   ,u                       * auto-destruction de l'objet
        bra   PHI_Rts

* ---------------------------------------------------------------------------
* Local data
* ---------------------------------------------------------------------------
        
pal_cur      rmb 32,0
pal_mask     fcb $0F                   * masque pour l'aternance du traitemet vert/rouge
pal_cycles   fcb $00
pal_buffer   fdb $00                   * buffer de comparaison
pal_idx      fcb $00                   * index de la couleur courante dans le traitement        
