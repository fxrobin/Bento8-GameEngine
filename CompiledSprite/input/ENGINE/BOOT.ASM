********************************************************************************
* Boot loader - Benoit Rousseau 07/10/2020
* ------------------------------------------------------------------------------
* 
* Description
* -----------
* Initialisation de la commutation de page pour l'espace Données (Mode registre)
* Animation de la palette: fondu vers une couleur cible PAL_TO
* Chargement du code de l'exomizer en mémoire
* Chargement du Main en mémoire
* Exécution de l'exomizer pour décompression du Main
* Appel du Main
*
* Empreinte mémoire
* -----------------
* 6100-61BE code exomizer           (191 octets)
* 61BF-61DD code swap page          (31 octets)
* 61DE-61FF données non utilisées   (34 octets)
* 6200-62FF code bootloader         (256 octets)
*
* Après un premier appel à l'exomizer :
* 6100-61BE code exomizer           (191 octets)
* 61BF-61DD code swap page          (31 octets)
* 61DE-61FF données non utilisées   (34 octets)
* 6200-6246 code lecture disquette  (71 octets)
* 6247-6263 données non utilisées   (29 octets)
* 6264-62FF données tampon exomizer (156 octets)
*
* Fonction
* --------
* Lecture des données depuis la disquette et décompression par exomizer
* Entrée:      DK_lecture
* Description: Réalise le chargement de données depuis la disquette dans une
*              zone temporaire (page 2), appelle l'exomizer pour décompresser
*              les données dans une zone mémoire cible (pages 0-31).
*              Le numéro de piste est incrémenté a chaque changement de secteur
*              de 16 à 1. Il n'y a pas de changement de lecteur une fois arrivé
*              à la fin de la piste 79.
* Registres:   IN  [A] nb. octets x256 a charger (A0-9F) pour 1 à 80
*              IN  [X] lecteur (0-3), 0
*              IN  [Y] piste (0-79), secteur (1-16)
*              RST [D] [X] [Y] [U]
*              OUT [Y] pointeur sur début données décompressées 
********************************************************************************
(main)BOOT
   ORG    $6200

EXOMIZER  EQU    $6100
MAIN      EQU    $6300

   ORCC   #$50              * désactive les interruptions
   BRA    INIT              * appelle le code d'init
   
********************************************************************************
* Lecture des données depuis la disquette et décompression par exomizer
********************************************************************************
DK_LECTURE                  * point d'entrée
   SETDP  $60
   LDB    #$60
   TFR    B,DP              * positionne la direct page à 60
   LDU    #$604D            * positionne la pile U sur les registres Moniteur
   PSHU   X,Y               * écrit DK.DRV, DK_DERNIER_BLOC, DK.TRK, DK.SEC
   STA    DK_DERNIER_BLOC+2 * auto-modif de code: positionne butée d'écriture
   LDA    #$02              * DK.OPC $02 Operation - lecture d'un secteur
   STA    <$6048            * valorise le registre Moniteur DK.OPC
   LDB    $E7E5             * identie la page courante en espace données
   STB    DK_RESTORE_PAGE+1 * sauvegarde la page
   STA    $E7E5             * selection de la page 02 en RAM Donnees (A000-DFFF)
   LDD    #$A000            * DK.BUF Destination des donnees lues
   STD    <$604F            * valorise le registre Moniteur DK.BUF
DKCO
   JSR    $E82A             * DKCO Appel Moniteur - lecture d'un secteur
   INC    <$604C            * incrément du registre Moniteur DK.SEC
   LDA    <$604C            * chargement de DK.SEC
   CMPA   #$10              * si DK.SEC est inférieur ou égal à 16
   BLS    DK_CONTINUE       * on continue le traitement
   LDA    #$01              * sinon on a depassé le secteur 16
   STA    <$604C            * positionnement du secteur a 1
   INC    <$604B            * incrément du registre Moniteur DK.TRK
DK_CONTINUE 
   INC    <$604F            * increment de 256 octets de la zone a ecrire DK.BUF
   LDD    <$604F            * chargement de la zone a ecrire DK.BUF
DK_DERNIER_BLOC
   CMPD   #$A000            * test debut du dernier bloc de 256 octets a écrire
   BLS    DKCO              * si DK.BUF inférieur ou égal à la limite alors DKCO
DYN_JSR_EXO 
   JSR    LOAD_EXOMIZE      * fin chargement disquette Main, chargement exomizer
DK_RESTORE_PAGE
   LDA    #$00              * numéro de page courante avant appel à DK_LECTURE
   STA    $E7E5             * restauration de la page appelante
   RTS
LOAD_EXOMIZE
   LDX    #EXOMIZER         * adresse d'implantation EXOMIZER
   STX    DYN_JSR_EXO+1     * auto-modif de code: positionne un JSR EXOMIZER
   STX    <$604F            * chargement de la zone a ecrire DK.BUF
   JSR    $E82A             * DKCO Appel Moniteur - lecture d'un secteur
   JSR    EXOMIZER          * Appel de l'exomizer sur le Main
   RTS

*-------------------------------------------------------------------------------
* A partir de ce point le code sera effacé lors du premier appel à l'exomizer
* l'effacement à lieu à partir de la position $6264
*-------------------------------------------------------------------------------

********************************************************************************
* Initialisation de la commutation de page pour l'espace Données (Mode registre)
********************************************************************************
INIT
   LDB    $6081             * $6081 est l'image "lisible" de $E7E7
   ORB    #$10              * positionne le bit d4 a 1
   STB    $6081             * maintient une image cohérente de $E7E7
   STB    $E7E7             * bit d4 à 1 pour pages données en mode registre
   SETDP  $62
   TFR    PC,D
   TFR    A,DP              * positionne la direct page à 62
   BRA    PAL_INIT          * saut par dessus signature et somme de contrôle

* données pour le fondu de palette
********************************************************************************

PAL_FROM
   FDB    $0000             * couleur $00 Noir (Thomson) => 06 change bordure
   FDB    $F00F             * couleur $0C Turquoise (Bordure écran)
   FDB    $FF0F             * couleur $0E Blanc (TO8)
   FDB    $7707             * couleur $10 Gris (Fond Bas)
   FDB    $AA03             * couleur $16 Jaune (Intérieur case)
   FDB    $330A             * couleur $18 Mauve (Fond TO8)
   
PAL_LEN
   FCB    $0C               * pour chaque couleur on défini un index limite
   FCB    $0E               * (exclu) de chargement. ex: 0C, 0E, ... 
   FCB    $10               * la première couleur de PAL_FROM est chargée
   FCB    $16               * pour les couleurs 0(00) à 5(0A)
   FCB    $18               * la seconde couleur de PAL_FORM  est chargée
   FCB    $20               * pour la couleur 6(0C)
END_PAL_LEN
   
PAL_CYCLES
   FCB    $0F               * nombre de frames de la transition (VSYNC)
   
PAL_MASK
   FCB    $0F               * masque pour l'aternance du traitemet vert/rouge
   
PAL_BUFFER
   FCB    $42               * B et buffer de comparaison
   FCB    $41               * A et buffer de comparaison
   FCB    $53               * S
   FCB    $49               * I
   FCB    $43               * C
   FCB    $32               * 2

PAL_IDX
   FCB    $00               * index de la couleur courante dans le traitement
   FCB    $00               * espace réservé pour somme de contrôle

*-------------------------------------------------------------------------------
* A partir de ce point le code doit commencer à l'adresse $6280
*-------------------------------------------------------------------------------

********************************************************************************
* Animation de la palette: fondu vers une couleur cible PAL_TO
********************************************************************************
* Ecriture en $E7DB de l'adresse ou sera stockee la couleur.
*
* les adresses vont de deux en deux car il y a deux octets a stocker par couleur.
* couleur: 0, adresse: 00
* couleur: 1, adresse: 02
* couleur: 2, adresse: 04
* ...
*
* Deux ecritures en $E7DA (auto-increment a partir de l'adresse couleur
*                          positionnee en $E7DB) pour la valeur de couleur.
*
*                             V V V V                 R R R R
* Premiere adresse        fondamentale V          fondamentale R
*
* Deuxieme adresse            X X X M                 B B B B
* auto-incrementee        bit de marquage         fondamentale B
*                       (incrustation video)
*
* Attention: les instructions suivantes effectuent une lecture avant l'écriture
* ASL, ASR, CLR, COM, DEL, INC, LSL, LSR, NEG, ROL, RDR
* un seul appel sur $E7DA va lire $E7DA puis écrire sur la seconde adresse $E7DA 
* Sur $E7DA il faut donc utiliser l'instruction ST pour écrire
********************************************************************************   

PAL_INIT
   LDX    #PAL_LEN          * index limite de chargement pour couleur courante 
   LDY    #PAL_FROM         * chargement pointeur valeur des couleurs actuelles
PAL_RUN
   LDA    ,Y			    * chargement de la composante verte et rouge
   ANDA   PAL_MASK          * on efface la valeur vert ou rouge par masque
   LDB    #$FF              * composante verte et rouge couleur cible
   ANDB   PAL_MASK          * on efface la valeur vert ou rouge par masque
   STB    PAL_BUFFER        * on stocke la valeur cible pour comparaison
   LDB    #$11              * préparation de la valeur d'incrément de couleur
   ANDB   PAL_MASK          * on efface la valeur non utile par masque
   STB    PAL_BUFFER+1      * on stocke la valeur pour ADD ou SUB ultérieur
   CMPA   PAL_BUFFER        * comparaison de la composante courante et cible
   BEQ    PAL_VR_SUIVANTE   * si composante est égale à la cible on passe
   BHI    PAL_VR_DEC        * si la composante est supérieure on branche
   LDA    ,Y                * on recharge la valeur avec vert et rouge
   ADDA   PAL_BUFFER+1      * on incrémente la composante verte ou rouge
   BRA    PAL_VR_SAVE       * on branche pour sauvegarder
PAL_VR_DEC
   LDA    ,Y                * on recharge la valeur avec vert et rouge
   SUBA   PAL_BUFFER+1      * on décrémente la composante verte ou rouge
PAL_VR_SAVE
   STA    ,Y                * sauvegarde de la nouvelle valeur vert ou rouge
PAL_VR_SUIVANTE
   COM    PAL_MASK          * inversion du masque pour traiter l'autre semioctet
   BMI    PAL_RUN           * si on traite $F0 on branche sinon on continue
	    
SETPALBLEU
   LDB    1,Y			    * chargement composante bleue courante
   CMPB   #$0F              * comparaison composante courante et cible
   BEQ    SETPALNEXT        * si composante est égale à la cible on passe
   BHI    SETPALBLEUDEC     * si la composante est supérieure on branche
   INCB                     * on incrémente la composante bleue
   BRA    SETPALSAVEBLEU    * on branche pour sauvegarder
SETPALBLEUDEC
   DECB                     * on décrémente la composante bleue
SETPALSAVEBLEU
   STB    1,Y               * sauvegarde de la nouvelle valeur bleue
    
SETPALNEXT
   LDA    PAL_IDX           * Lecture index couleur
   STA    $E7DB             * sélectionne l'indice de couleur à écrire
   ADDA   #$02              * increment de l'indice de couleur (x2)
   STA    PAL_IDX           * stockage du nouvel index
   LDA    ,Y                * chargement de la nouvelle couleur courante
   STA    $E7DA             * positionne la nouvelle couleur (Vert et Rouge)
   STB    $E7DA             * positionne la nouvelle couleur (Bleu)
   LDA    PAL_IDX           * rechargement de l'index couleur
   CMPA   ,X                * comparaison avec l'index limite pour cette couleur
   BNE    SETPALNEXT        * si inferieur on continue avec la même couleur
   LEAY   2,Y               * on avance le pointeur vers la nouvelle couleur
   LEAX   1,X               * on avance le pointeur vers la nouvelle limite
   CMPX   #END_PAL_LEN      * test de fin de liste
   BNE    PAL_RUN           * on reboucle si fin de liste pas atteinte
	
VSYNC_1
   TST    $E7E7             * le faisceau n'est pas dans l'écran
   BPL    VSYNC_1           * tant que le bit est à 0 on boucle
VSYNC_2
   TST    $E7E7             * le faisceau est dans l'écran
   BMI    VSYNC_2           * tant que le bit est à 1 on boucle

   DEC    PAL_CYCLES        * décrémente le compteur du nombre de frame
   BNE    PAL_INIT          * on reboucle si nombre de frame n'est pas réalisé
   
********************************************************************************  
* Initialisation du mode video
********************************************************************************
   LDA    #$7B              * passage en mode 160x200x16c
   STA    $E7DC
	
********************************************************************************
* Initialisation des paramètres pour le chargement du MAIN
********************************************************************************	
   LDD    #MAIN             * adresse d'implantation du MAIN
   STD    ,S                * ajoute l'adresse dans la pile, utilisé lors du RTS
   LDU    #DK_DATA          * chargement des données pour lecture
   PULU   A,X,Y             * du code principal (MAIN)
   LBRA   DK_LECTURE        * lecture disquette et chargement en mémoire du MAIN

* Données d'initialisation des paramètres pour le chargement du MAIN
********************************************************************************	
DK_DATA
   FCB    $<DERNIER_BLOC>   * adresse poids fort du dernier bloc de 256 octets
   FCB    $00               * DK.DRV
   FDB    $0000             * DK.TRK
   FCB    $02               * DK.SEC
(info)
