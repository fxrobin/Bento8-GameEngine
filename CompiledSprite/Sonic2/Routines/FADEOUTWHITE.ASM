********************************************************************************  
* Initialisation de la palette de couleurs
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
*
* A la sélection B ou C, les couleurs passent aux valeurs suivantes:
* Code couleur :
*    $00 $0000 Noir (Thomson)
*    $0C $F00F Turquoise (Bordure écran)
*    $0E $FF0F Blanc (TO8)
*    $10 $7707 Gris (Fond Bas)
*    $16 $AA03 Jaune (Intérieur case)
*    $18 $330A Mauve (Fond TO8)
*
********************************************************************************
SETINITPALETTE
	LDY #TABPALETTE
    LDX #COLINDEX
SETPALETTE
	LDA ,X+				* Lecture index couleur
	STA $E7DB			* determine l'indice de couleur (x2): 0=0, 1=2, 2=4, .. 15=30
	LDD ,Y			* chargement de la couleur et increment du poiteur Y
	INCA
	ANDA #$0F
	BEQ SETPALETTE0
	LDD ,Y
	INCA
	BRA SETPALETTE1
SETPALETTE0
	LDD ,Y
SETPALETTE1
	ADDA #$10
	BCC SETPALETTE2
	SUBA #$10
SETPALETTE2
	INCB
	CMPB #$0F
	BLS SETPALETTE3
	DECB
SETPALETTE3
	STD ,Y++
	STA $E7DA			* set de la couleur Vert et Rouge
	STB $E7DA           * set de la couleur Bleu
	CMPX #FINCOLINDEX * test fin de liste numéro de couleur
	BNE	SETPALETTE      * on reboucle si fin de liste pas atteinte
	
VSYNC_1
	TST	$E7E7   * le faisceau n'est pas dans l'écran
	BPL	VSYNC_1 * tant que le bit est à 0 on boucle
VSYNC_2
	TST	$E7E7   * le faisceau est dans l'écran
	BMI	VSYNC_2 * tant que le bit est à 1 on boucle
	
	LDX TABPALETTE
	CMPX #$FF0F * test fin de liste valeur de couleur
	BNE	SETINITPALETTE      * on reboucle si fin de liste pas atteinte
	
	* Bordure initialisee avec couleur 0
	************************************
	
    LDB $E7DD
	ANDB #$F0
	STB $E7DD
	
COLINDEX
   fcb $00
   fcb $0C
   fcb $0E
   fcb $10
   fcb $16
   fcb $18
FINCOLINDEX   
   
TABPALETTE
   fdb $0000
   fdb $F00F
   fdb $FF0F
   fdb $7707
   fdb $AA03
   fdb $330A
FINTABPALETTE