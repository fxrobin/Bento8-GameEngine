********************************************************************************
* Boot loader / Routine de lecture disquette
* ------------------------------------------
* 6100-61B9 exomizer (186 octets)
* 6200-62FF espace bootloader (256 octets)
* après premier appel à l'exomizer :
* 6200-62FF espace bootloader (256 octets)
* 6264-62FF biba de l'exomizer (156 octets)
*
* Paramètres DK_lecture
* Registres:
*  X: lecteur (0 à 3), nombre de blocs de 256 octets a charger (A0:1, A1:2, ..., 9F:80)
*  Y: piste (0 à 79), secteur (1-16)
*
* Le numéro de piste est incrémenté a chaque changement de secteur de 16 à 1
* Il n'y a pas de changement de lecteur une fois arrivé à la fin de la piste 79
********************************************************************************
(main)BOOT
   setdp $60
   org $6200
   
exomizer equ $6100
main     equ $6300

********************************************************************************  
* desactivation des interruptions
********************************************************************************
   orcc #$50             * desactivation des interruptions
   bra init              * Appel du code d'init (joué une seule fois par le boot puis écrasé par le biba de l'exomizer)
DK_lecture               * Point d'entrée pour exécution de lecture disquette et exomizer
   ldu #$604D            * Chargement des données d'entrée DK.DRV, (poids fort) DK_dernier_bloc, (poids faible) DK.TRK, DK.SEC
   pshu x,y
   lda <$604A            * Chargement d'une donnée tmp depuis DK.TRK (poids fort)
   sta DK_dernier_bloc+2 * utilisation de cette valeur pour le nombre de blocs de 256 octets
   clr <$604A            * positionnement de l'octet fort de DK.TRK a zéro
   lda #$02              * A la fois code opération et code page tmp          
   sta <$6048            * DK.OPC $02 Operation - Lecture d'un secteur
DK_destinationPage
   ldb $E7E5             * identification de la page en espace données
   stb load_page+1       * Sauvegarde de la page
   sta $E7E5             * Selection de la page en RAM Donnees (A000-DFFF)
DK_destination
   ldd #$A000            * Debut de la zone memoire cible
   std <$604F            * DK.BUF Destination des donnees lues
DKCO
   jsr $E82A             * DKCO Appel 
   inc <$604C            * Secteur suivant
   lda <$604C            * Chargement de DK.SEC
   cmpa #$10
   bls DK_continue      
   lda #$01              * Si on depasse le secteur 16
   sta <$604C            * Positionnement du secteur a 1
   inc <$604B            * Increment de la piste
DK_continue 
   inc <$604F            * Increment de 256 octets de la zone a ecrire DK.BUF
   ldd <$604F            * Chargement de la zone a ecrire DK.BUF
DK_dernier_bloc          * Dernier bloc a ecrire
   cmpd #$A000           * test debut du dernier bloc de 256 octets a écrire
   bls DKCO
   bra load_exomize
dyn_exo
load_page
   lda #$00              * Numero de page
   sta $E7E5             * Recharge de la page d'appel
dyn_rts
   nop
load_exomize
   lda #$39
   sta dyn_rts           * Auto-modification de code positionne un rts
   lda #$BD              * Aux passages suivants, permet d'enchainer DKCO et EXO
   ldx #exomizer
   ldu dyn_exo
   pshu a,x              * Auto-modification de code positionne un appel à exomizer
   stx <$604F            * Emplacement d'écriture du code exomizer Renseignement DK.BUF
   jsr $E82A
   jsr exomizer
   rts

********************************************************************************
* Données d'initialisation des paramètres pour le chargement du MAIN
********************************************************************************	
data
   fcb 0                 * DK.DRV
   fcb $A0   * poids fort DK_dernier_bloc
   fcb 0                 * poids faible DK.TRK
   fcb 2                 * DK.SEC

********************************************************************************
* A partir de ce point le code sera effacé lors du premier appel à l'exomizer
* l'effacement à lieu à partir de la position $6264
********************************************************************************

init
********************************************************************************
* Initialisation de la commutation de page pour l'espace Données
********************************************************************************
   ldb $6081             * $6081 est l'image "lisible" de $E7E7
   orb #$10              * positionne le bit d4 a 1
   stb $6081             * maintient une image cohérente de $E7E7
   stb $E7E7             * bit d4 à 1 pour gestion de la page données en mode registre
   bra SETINITPALETTE       * saut par dessus la signature et la somme de contrôle

********************************************************************************
* données pour le fondu de palette
* Au boot (sélection B ou C), les couleurs passent aux valeurs suivantes:
*    $00 $0000 Noir (Thomson)
*    $0C $F00F Turquoise (Bordure écran)
*    $0E $FF0F Blanc (TO8)
*    $10 $7707 Gris (Fond Bas)
*    $16 $AA03 Jaune (Intérieur case)
*    $18 $330A Mauve (Fond TO8)
********************************************************************************

PALETTEFROM
   fdb $0000
   fdb $F00F
   fdb $FF0F
   fdb $7707
   fdb $AA03
   fdb $330A

********************************************************************************
* Espace libre pour signature du boot et somme de contrôle
********************************************************************************
TMPBUFFER
   fcb 0,0,0,0,0,0,0,0 * espace réservé pour signature et somme de contrôle (BASIC2  )

********************************************************************************
* A partir de ce point le code doit commencer à l'adresse $6280
********************************************************************************

********************************************************************************  
* Transition de la palette de couleurs vers une nouvelle palette
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

PALETTECYCLES
   fcb $0F
   
PALETTEMASK
   fcb $0F

PALETTEINDEX
   fcb $00
   fcb $0C
   fcb $0E
   fcb $10
   fcb $16
   fcb $18
ENDPALETTEINDEX

PALETTETO
   fdb $FF0F

SETINITPALETTE
    LDX #PALETTEINDEX
	LDY #PALETTEFROM
	LDU #PALETTETO
SETPAL
	LDA ,Y			    * chargement de la composante rouge courante
	ANDA PALETTEMASK
	LDB ,U              * chargement de la composante rouge cible
	ANDB PALETTEMASK
	STB TMPBUFFER
	LDB #$11
	ANDB PALETTEMASK
	STB TMPBUFFER+1
	CMPA TMPBUFFER     * comparaison de la composante rouge courante et cible
    BEQ SETPALVERT
    BHI SETPALROUGEDEC
    LDA ,Y
    ADDA TMPBUFFER+1
    BRA SETPALSAVEROUGE
SETPALROUGEDEC
    LDA ,Y
    SUBA TMPBUFFER+1
SETPALSAVEROUGE
    STA ,Y              * sauvegarde de la nouvelle valeur rouge
       
SETPALVERT
    COM PALETTEMASK
    BMI SETPAL
	    
SETPALBLEU
	LDB 1,Y			    * chargement de la composante bleue courante
	CMPB 1,U            * comparaison de la composante bleue courante et cible
    BEQ SETPALNEXT
    BHI SETPALBLEUDEC
    INCB
    BRA SETPALSAVEBLEU
SETPALBLEUDEC
    DECB
SETPALSAVEBLEU
    STB 1,Y              * sauvegarde de la nouvelle valeur bleue
    
SETPALNEXT
	LDA ,X+				* Lecture index couleur
	STA $E7DB			* determine l'indice de couleur
	LDA ,Y++		    * chargement de la nouvelle couleur courante
	STA $E7DA			* set de la nouvelle couleur (Vert et Rouge)
	STB $E7DA           * set de la nouvelle couleur (Bleu)
	CMPX #ENDPALETTEINDEX * test fin de liste numéro de couleur
	BNE	SETPAL      * on reboucle si fin de liste pas atteinte
	
VSYNC_1
	TST	$E7E7   * le faisceau n'est pas dans l'écran
	BPL	VSYNC_1 * tant que le bit est à 0 on boucle
VSYNC_2
	TST	$E7E7   * le faisceau est dans l'écran
	BMI	VSYNC_2 * tant que le bit est à 1 on boucle
	
	DEC PALETTECYCLES
	BNE	SETINITPALETTE      * on reboucle si le nombre de cycles n'est pas réalisé
	
********************************************************************************
* Initialisation des paramètres pour le chargement du MAIN
********************************************************************************	
   ldd #main             * Emplacement du MAIN
   std ,s                * Enregistrement de l adresse qui sera appellee lors du premier RTS (lancement MAIN)
   ldu #data
   pulu x,y
   lbra DK_lecture        * Chargement des données d'initialisation  

(info)
