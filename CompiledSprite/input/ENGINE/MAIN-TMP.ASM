********************************************************************************
* Demo - Outil de gestion d'animation de sprites (TO8 Thomson)                 *
********************************************************************************
* Auteur  : Benoit Rousseau                                                    *
* Date    : 29/09/2020                                                         *
* Licence :                                                                    *
********************************************************************************
*
********************************************************************************

(main)MAIN
	ORG $6300

********************************************************************************  
* Constantes et variables
********************************************************************************

DK_lecture		EQU $6205 * routine de lecture disquette
DK_piste		EQU $620A * 2B numero de la piste de depart
DK_secteur		EQU $620F * 1B numero du secteur de depart
DK_destination	EQU $6213 * 2B debut de la zone memoire cible
DK_dernier_bloc	EQU $622C * 2B fin de la zone memoire cible (debut du dernier bloc de 256 octets)

DEBUTECRANA 	EQU $0014 * test pour fin stack blasting
FINECRANA   	EQU $1F40 * fin de la RAM A video
DEBUTECRANB 	EQU $2014 * test pour fin stack blasting
FINECRANB   	EQU $3F40 * fin de la RAM B video

JOY_BD 			EQU $05 * Bas Droite
JOY_HD 			EQU $06 * Haut Droite
JOY_D  			EQU $07 * Droite
JOY_BG 			EQU $09 * Bas Gauche
JOY_HG 			EQU $0A * Haut Gauche
JOY_G  			EQU $0B * Gauche
JOY_B  			EQU $0D * Bas
JOY_H  			EQU $0E * Haut
JOY_C  			EQU $0F * Centre
JOY_A  			EQU $40 * Bouton

********************************************************************************  
* Debut du programme
********************************************************************************
MAIN:
	ORCC #$50	* desactive les interruptions	
	
********************************************************************************  
* Initialisation du mode video
********************************************************************************
	LDA #$7B	* passage en mode 160x200x16c
	STA $E7DC
	
********************************************************************************  
* Initialisation de la palette en noir
********************************************************************************

	LDD #$0000
SETBLACKPALETTE
	STA $E7DB	* determine l'indice de couleur
	STB $E7DA	* set de la couleur Vert et Rouge
	STB $E7DA   * set de la couleur Bleu
	ADDA #$02	* increment de l'indice de couleur (x2)
	CMPA #$20	* si on atteint 32 sortie
	BNE	SETBLACKPALETTE
	
	* Bordure initialisee avec couleur 0
	************************************
	
    LDB $E7DD
	ANDB #$F0
	STB $E7DD

********************************************************************************
* Chargement des pages memoire
********************************************************************************
	* Chargement des pages depuis la dsk
	***************************************
	
	LDD #$0004
	STD DK_piste
	LDA #$01
	STA DK_secteur
	LDD #$DF00
	STD DK_dernier_bloc
	
LDPAGE_LOOP
	LDB #$00
	STB $E7E5 * Selection de la page en RAM Donnees (A000-DFFF)
	
	LDA #$01
	STA DK_secteur
	LDD #$A000
	STD DK_destination
	JSR DK_lecture
	
	* Duplication de la page p en p+1
	*********************************
CPPAGE_LOOP	
	LDB #$62                       * On monte la page
	STB $E7E6                      * en RAM Cartouche (0000-3FFF)

    LDU #$A000                     * Source
    LDY #$4000+64                  * Destination Fin +64
	STY MEM_COPY_DATA_TO_CART_E+2
    LDY #$2000+64                  * Destination Debut +64 on commence a -64,Y
    JSR MEM_COPY_DATA_TO_CART      * Copie memoire
	
    LDU #$C000                     * Source
    LDY #$2000+64                  * Destination Fin +64
	STY MEM_COPY_DATA_TO_CART_E+2
    LDY #$0000+64                  * Destination Debut +64 on commence a -64,Y
    JSR MEM_COPY_DATA_TO_CART      * Copie memoire

PAGEINITNEXT    
    BRA PAGEINIT

PAGEINIT
	LDA #$04
	STA LDPAGE_LOOP+1
    LDA #$65
    STA CPPAGE_LOOP+1
    LDA #$11
	STA PAGEINITNEXT+1
    BRA LDPAGE_LOOP    

PAGENEXT
    INC CPPAGE_LOOP+1
	INC CPPAGE_LOOP+1	
	INC LDPAGE_LOOP+1
	INC LDPAGE_LOOP+1
	LDB LDPAGE_LOOP+1
	CMPB #$16
	BLS LDPAGE_LOOP

********************************************************************************
* Initialisation de la routine de commutation de page video
********************************************************************************
INIT_VID
	LDB $6081 * A documenter
	ORB #$10  * mettre le bit d4 a 1
	STB $6081
	STB $E7E7
	JSR SCRC     * page 2 en RAM Cartouche (0000-3FFF) - page 0 en RAM Ecran (4000-5FFF)

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
********************************************************************************

	LDY #TABPALETTE
	CLRA				* registre A a 0
SETPALETTE
	PSHS A				* sauvegarde A
	ASLA				* multiplication par deux de A 
	STA $E7DB			* determine l'indice de couleur (x2): 0=0, 1=2, 2=4, .. 15=30
	LDD ,Y++			* chargement de la couleur et increment du poiteur Y
	STB $E7DA			* set de la couleur Vert et Rouge
	STA $E7DA           * set de la couleur Bleu
	PULS A				* rechargement de A
	INCA				* et increment de A
	CMPY #FINTABPALETTE * test fin de liste
	BNE	SETPALETTE      * on reboucle si fin de liste pas atteinte

********************************************************************************
* Initialisation des sprites
********************************************************************************
	LDX #HERO_IDLE_R
	STX HERO_ANIMATION_ADR_OLD
	JSR HERO_ANIMATION_LOAD

********************************************************************************
* Boucle principale
********************************************************************************

	* Init routine effacement sprite
	JSR Compute_Position
	LDB HERO_ANIMATION_PAG				* On monte la page 
	STB HERO_ANIMATION_PAG_DEL
	STB $E7E5							* en RAM Donnees (A000-DFFF)
	JSR [HERO_ANIMATION_DRW]			* Sauve arriere plan et affiche le sprite
	JSR SCRC
	BRA MAIN_0
	
MAIN
	* Effacement et affichage des sprites
	LDD HERO_ANIMATION_PAG_DEL			* On monte la page 
	STB HERO_ANIMATION_PAG_DEL
	STA $E7E5							* en RAM Donnees (A000-DFFF)
	JSR [HERO_ANIMATION_DEL]			* Efface le sprite
MAIN_0
	LDD HERO_ANIMATION_DEL+2			* On monte la page 
	STD HERO_ANIMATION_DEL

	* Gestion des deplacements
	JSR JOY_READ
	JSR Hero_Move
	JSR Compute_Position
	LDX HERO_ANIMATION_ADR
	CMPX HERO_ANIMATION_ADR_OLD
	BNE MAIN_1
	JSR HERO_ANIMATION_NEXT
	BRA MAIN_2
MAIN_1
	STX HERO_ANIMATION_ADR_OLD
	JSR HERO_ANIMATION_LOAD
MAIN_2
	
	LDB HERO_ANIMATION_PAG				* On monte la page 
	STB HERO_ANIMATION_PAG_DEL+1
	STB $E7E5							* en RAM Donnees (A000-DFFF)
	JSR [HERO_ANIMATION_DRW]			* Sauve arriere plan et affiche le sprite
	
	JSR SCRC        					* changement de page ecran
	BRA MAIN

********************************************************************************
* Changement de page ESPACE ECRAN (affichage du buffer visible)
*	$E7DD determine la page affichee dans ESPACE ECRAN (4000 a 5FFF)
*	D7=0 D6=0 D5=0 D4=0 (#$0_) : page 0
*	D7=0 D6=1 D5=0 D4=0 (#$4_) : page 1
*	D7=1 D6=0 D5=0 D4=0 (#$8_) : page 2
*	D7=1 D6=1 D5=0 D4=0 (#$C_) : page 3
*   D3 D2 D1 D0  (#$_0 a #$_F) : couleur du cadre
*   Remarque : D5 et D4 utilisable uniquement en mode MO
*
* Changement de page ESPACE CARTOUCHE (ecriture dans buffer invisible)
*	$E7E6 determine la page affichee dans ESPACE CARTOUCHE (0000 a 3FFF)
*   D5 : 1 = espace cartouche recouvert par de la RAM
*   D4 : 0 = CAS1N valide : banques 0-15 / 1 = CAS2N valide : banques 16-31
*	D5=1 D4=0 D3=0 D2=0 D1=0 D0=0 (#$60) : page 0
*   ...
*	D5=1 D4=0 D3=1 D2=1 D1=1 D0=1 (#$6F) : page 15
*	D5=1 D4=1 D3=0 D2=0 D1=0 D0=0 (#$70) : page 16
*   ...
*	D5=1 D4=1 D3=1 D2=1 D1=1 D0=1 (#$7F) : page 31
********************************************************************************
SCRC
	BSR VSYNC

	LDB SCRC0+1
	ANDB #$01
	ADDB HERO_ANIMATION_PAG_REF
	STB HERO_ANIMATION_PAG
	
	LDB SCRC0+1	* charge la valeur du LDB suivant SCRC0 en lisant directement dans le code
	ANDB #$80	* permute #$00 ou #$80 (suivant la valeur B #$00 ou #$FF) / fond couleur 0
	ORB #$00	* recharger la couleur de cadre si diff de 0 car effacee juste au dessus (couleur 0)
	STB $E7DD	* changement page dans ESPACE ECRAN
	COM SCRC0+1	* modification du code alterne 00 et FF sur le LDB suivant SCRC0
SCRC0
	LDB #$00
	ANDB #$02	* permute #$60 ou #$62 (suivant la valeur B #$00 ou #$FF)
	ORB #$60	* espace cartouche recouvert par RAM / ecriture autorisee
	STB $E7E6	* changement page dans ESPACE CARTOUCHE permute 60/62 dans E7E6 pour demander affectation banque 0 ou 2 dans espace cartouche
	RTS			* E7E6 D5=1 pour autoriser affectation banque
				* CAS1N : banques 0-15 CAS2N : banques 16-31

********************************************************************************
* Attente VBL
********************************************************************************
VSYNC
VSYNC_1
	TST	$E7E7
	BPL	VSYNC_1
VSYNC_2
	TST	$E7E7
	BMI	VSYNC_2
	RTS
	
********************************************************************************  
* Affichage de l arriere plan 57900 cycles
********************************************************************************	
DRAW_RAM_DATA_TO_CART_160x200
	PSHS U,DP		* sauvegarde des registres pour utilisation du stack blast
	STS DRAW_RAM_DATA_TO_CART_160x200A_E+2
	
	LDS #FINECRANA	* init pointeur au bout de la RAM A video (ecriture remontante)
	LDU #$A000

DRAW_RAM_DATA_TO_CART_160x200A
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	CMPS #DEBUTECRANA
	BNE DRAW_RAM_DATA_TO_CART_160x200A
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU B,DP,X,Y
	PSHS Y,X,DP,B

	LDS #FINECRANB	* init pointeur au bout de la RAM B video (ecriture remontante)
	LDU #$C000

DRAW_RAM_DATA_TO_CART_160x200B
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	CMPS #DEBUTECRANB
	BNE DRAW_RAM_DATA_TO_CART_160x200B
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU B,DP,X,Y
	PSHS Y,X,DP,B
DRAW_RAM_DATA_TO_CART_160x200A_E
	LDS  #$0000 * rechargement des registres
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

********************************************************************************
* Exomizer
********************************************************************************

	INCLUD EXOMIZER

********************************************************************************
* Palette de 16 couleurs
********************************************************************************

	INCLUD PALETTE

********************************************************************************
* Get joystick parameters
********************************************************************************

* TODO Ajout lecture joystick 2

JOY_READ
	LDA	JOY_BTN_STATUS
	STA JOY_BTN_STATUS_OLD
	ldx    #$e7cf
	ldy    #$e7cd
	ldd    #$400f 
	andb   >$e7cc     * Read position
	stb    JOY_DIR_STATUS
	anda   ,y         * Read button
	eora   #$40
	sta    JOY_BTN_STATUS
	RTS
JOY_DIR_STATUS
	FCB $00 * Position Pad
JOY_BTN_STATUS
	FCB $00 * 40 Bouton A enfonce
JOY_BTN_STATUS_OLD
	FCB $00 * 40 Bouton A enfonce
HERO_ISJUMPING
	FCB $00	* flag is jumping $00:Faux $01:Vrai

********************************************************************************
* Compute Sprite Position
********************************************************************************

* TODO rendre générique pour n objets

Compute_Position
	LDA HERO_X_POS
	LSRA
	BCS Compute_Position_01
	STA Compute_Position_02+1
	LDA #$28
	LDB HERO_Y_POS
	DECB
	MUL
	ADDD Compute_Position_02
	STD HERO_POS
	ADDD #$2000					* position dans la seconde page
	STD HERO_POS+2
	RTS
Compute_Position_01
	STA Compute_Position_02+1
	LDA #$28
	LDB HERO_Y_POS
	DECB
	MUL
	ADDD Compute_Position_02
	ADDD #$2000
	STD HERO_POS
	SUBD #$1FFF
	STD HERO_POS+2
	RTS
Compute_Position_02
	FDB $0000

********************************************************************************
* HERO Animations nb Cycles
* -------------------------
* Note: Speed abs +0, rel +8, rel cap +10
*
* Chargement nouvelle animation
*    nouvelle frame = 109 a 119
*
* Chargement frame suivante
*    frame identique = 15
* ou frame suivante  = 116 a 126
*
* Chargement frame suivante avec branchement sur une autre animation
*    nouvelle frame = 165 a 175
* ou frame suivante = 172 a 182
*
* Chargement frame suivante avec retour sur animation apellante
*    nouvelle frame = 167 a 177
* ou frame suivante = 174 a 184
********************************************************************************

* TODO Rendre générique pour n objets

HERO_ANIMATION_LOAD				  * Input X : Animation Adress
	STX HERO_ANIMATION_ADR
	STX HERO_ANIMATION_RTN_ADR
	CLR HERO_ANIMATION_IMC		  * Set first image to $00
HERO_ANIMATION_LOAD_00
	LDD -2,X					  * Load Frames informations
	CMPA #$00					  * Different from $00 means NbFrames relative to GSP
	BEQ HERO_ANIMATION_LOAD_01
	LDA HERO_G_SPEED              * G_SPEED First byte : Frame (A reg), Second byte : 1/256 Frame (B Reg)
	BGE HERO_ANIMATION_LOAD_01A
	LDD #$0000
	SUBD HERO_G_SPEED			  * La vitesse negative est convertie en positive 
	LDB -1,X					  * Load Remaining Frames informations 
HERO_ANIMATION_LOAD_01A
	STA HERO_ANIMATION_LOAD_01B+1 * Auto modification du SUBB ci dessous
HERO_ANIMATION_LOAD_01B
	SUBB #$00			          * substract animation frames with speed 
	BCC HERO_ANIMATION_LOAD_01
	LDB #$01					  * Minimun 1 frame/image
	
HERO_ANIMATION_LOAD_01
	STB HERO_ANIMATION_FRR		  * Store remaining Frames for this loaded image
	LDA HERO_ANIMATION_IMC
	LDB #$05
	MUL
	ADDD HERO_ANIMATION_ADR
	TFR D,Y
	LDB ,Y
	CMPB #$1F					  * Si > 31 on est plus sur une page (0-31)
	BHI HERO_ANIMATION_LOAD_NOPAGE
	LDA HERO_ANIMATION_PAG      
	STB HERO_ANIMATION_PAG
	CMPA HERO_ANIMATION_PAG_REF
	BEQ HERO_ANIMATION_LOAD_02
	INC HERO_ANIMATION_PAG        * si la page precedente etait diff de la REF on recale a nouvelle page en +1
HERO_ANIMATION_LOAD_02
	STB HERO_ANIMATION_PAG_REF    * on sauvegarde la PAGE comme REF
	LDX 1,Y
	STX HERO_ANIMATION_DRW
	LDX 3,Y
	STX HERO_ANIMATION_DEL+2
	RTS
HERO_ANIMATION_LOAD_NOPAGE
	CMPB #$FF
	BNE HERO_ANIMATION_LOAD_FE
	LDX 3,Y
	STX HERO_ANIMATION_IMC		  * Save IMC and RTN_IMC
	LDX 1,Y
	STX HERO_ANIMATION_ADR
	BRA HERO_ANIMATION_LOAD_00	* Output X : Animation Adress
HERO_ANIMATION_LOAD_FE
	LDX HERO_ANIMATION_RTN_ADR	* RETURN to Calling Animation
	STX HERO_ANIMATION_ADR
	LDB HERO_ANIMATION_RTN_IMC
	STB HERO_ANIMATION_IMC
	BRA HERO_ANIMATION_LOAD_00	* Output X : Animation Adress

HERO_ANIMATION_NEXT
	DEC HERO_ANIMATION_FRR
	BLE HERO_ANIMATION_NEXT_00	* BRANCH if no more frame to wait
	RTS
HERO_ANIMATION_NEXT_00
	INC HERO_ANIMATION_IMC
	LDX HERO_ANIMATION_ADR	
	BRA HERO_ANIMATION_LOAD_00	* Output X : Animation Adress
	
********************************************************************************
*   ANIMATION Scripts
*	---------------------
*
*	Structure de données:
*	FDB $0018		* 00 : Absolute - !=00 : NbFrames relative to GSP
*					* 18 : Nb frames par image
*HERO_IDLE_L
*	FCB $01			* Page associee a l adresse drw img 00
*	FDB $A000		* Adresse drw img 00
*	FDB $A000		* Adresse del img 00
*
*	FCB $FF			* FF SET return Anim et Image BRANCH Anim et Image
*	FDB HERO_IDLE-C * adresse animation cible
*	FDB $0301		* 03 image cible 01 image retour
*	
*	FCB $FE			* FE RETURN
*
*	Appel d'une animation :
*	LDX #HERO_IDLE_R
*	JSR HERO_ANIMATION_LOAD
*
*	Passage à l'animation suivante :
*	JSR HERO_ANIMATION_NEXT
*
********************************************************************************

	INCLUD ANIMATION_SCRIPT
	
********************************************************************************
* OBJECT Variables
********************************************************************************

* TODO mettre ces données en tableau générique pour la position des objets

HERO_POS EQU $9F00 * Emplacement memoire pour stockage HERO Position
HERO_X_POS	FCB $0f	* Horizontal Position
HERO_Y_POS	FCB $72	* Vertical Position (TODO Bug si position Y=00)
	
HERO_ANIMATION_ADR		FDB $0000	* Animation courante - Pointeurs Adresse
HERO_ANIMATION_ADR_OLD	FDB $0000	* Sauvegarde ancienne animation
HERO_ANIMATION_RTN_ADR	FDB $0000	* Animation courante - Pointeur Adresse Retour Animation apellante
HERO_ANIMATION_PAG		FCB $00		* Animation courante - Pointeur Page actif
HERO_ANIMATION_PAG_REF	FCB $00		* Animation courante - Pointeur Page de reference
HERO_ANIMATION_PAG_DEL	FCB $00		* Animation courante - Pointeur Page Effacement img-1
						FCB $00		* Animation courante - Pointeur Page Effacement
HERO_ANIMATION_DEL		FDB $0000	* Animation courante - Pointeur Effacement img-1
						FDB $0000	* Animation courante - Pointeur Effacement
HERO_ANIMATION_DRW		FDB $0000	* Animation courante - Pointeur Dessin
HERO_ANIMATION_IMC		FCB $00		* Animation courante - Image courante (doit etre suivi de RTN_IMC)
HERO_ANIMATION_RTN_IMC	FCB $00		* Animation courante - Image courante Retourn Animation apellante (doit etre precede de IMC)
HERO_ANIMATION_FRR		FCB $00		* Animation courante - Frames restante
	
	end MAIN