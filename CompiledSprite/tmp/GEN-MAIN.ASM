********************************************************************************
* Demo - Outil de gestion d'animation de sprites (TO8 Thomson)                 *
********************************************************************************
* Auteur  : Benoit Rousseau                                                    *
* Date    : 11/08/2020                                                         *
* Licence :                                                                    *
********************************************************************************
*
********************************************************************************

(main)MAIN
	ORG $6300

********************************************************************************  
* Constantes et variables
********************************************************************************

DK_lecture               EQU $6205 * routine de lecture disquette
DK_piste                 EQU $620A * 2B numero de la piste de depart
DK_secteur               EQU $620F * 1B numero du secteur de depart
DK_destination           EQU $6213 * 2B debut de la zone memoire cible
DK_dernier_bloc_a_ecrire EQU $622C * 2B fin de la zone memoire cible (debut du dernier bloc de 256 octets)

DEBUTECRANA EQU $0014 * test pour fin stack blasting
FINECRANA   EQU $1F40 * fin de la RAM A video
DEBUTECRANB EQU $2014 * test pour fin stack blasting
FINECRANB   EQU $3F40 * fin de la RAM B video

JOY_BD EQU $05 * Bas Droite
JOY_HD EQU $06 * Haut Droite
JOY_D  EQU $07 * Droite
JOY_BG EQU $09 * Bas Gauche
JOY_HG EQU $0A * Haut Gauche
JOY_G  EQU $0B * Gauche
JOY_B  EQU $0D * Bas
JOY_H  EQU $0E * Haut
JOY_C  EQU $0F * Centre
JOY_A  EQU $40 * Bouton

HERO_POS EQU $9F00 * Emplacement memoire pour stockage HERO Position

********************************************************************************  
* Debut du programme
********************************************************************************
BEGIN
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
	STD DK_dernier_bloc_a_ecrire
	
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
*
* Piste d'optim pour changer plus de couleurs par raster :
* ne changer que la moditie des donnees d'une couleur par retour de ligne
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
* Copie Memoire de la zone donnee vers cartouche
* Cycles en fonction de l'implementation
* 256 octets (-128 a 127) x 64  boucles (80457 cy)
* 128 octets (-64  a 63)  x 128 boucles (81673 cy) Active
* 32  octets (-16  a 15)  x 512 boucles (87049 cy)
********************************************************************************
   
MEM_COPY_DATA_TO_CART
   STS MEM_COPY_DATA_TO_CART_S+2  * sauvegarde du pointeur de la pile systeme (auto-modification du code)
   LEAS ,U * remplacement de TFR U,S (Gain: 2c 0o)
MEM_COPY_DATA_TO_CART_LOOP
   PULS	D,X,U	
   STD	-64,Y
   STX	-62,Y
   STU	-60,Y
   PULS	D,X,U	
   STD	-58,Y
   STX	-56,Y
   STU	-54,Y
   PULS	D,X,U	
   STD	-52,Y
   STX	-50,Y
   STU	-48,Y
   PULS	D,X,U	
   STD	-46,Y
   STX	-44,Y
   STU	-42,Y
   PULS	D,X,U	
   STD	-40,Y
   STX	-38,Y
   STU	-36,Y
   PULS	D,X,U	
   STD	-34,Y
   STX	-32,Y
   STU	-30,Y
   PULS	D,X,U	
   STD	-28,Y
   STX	-26,Y
   STU	-24,Y
   PULS	D,X,U	
   STD	-22,Y
   STX	-20,Y
   STU	-18,Y
   PULS	D,X,U	
   STD	-16,Y
   STX	-14,Y
   STU	-12,Y
   PULS	D,X,U	
   STD	-10,Y
   STX	-8,Y
   STU	-6,Y
   PULS	D,X,U	
   STD	-4,Y
   STX	-2,Y
   STU	,Y
   PULS	D,X,U	
   STD	2,Y
   STX	4,Y
   STU	6,Y
   PULS	D,X,U	
   STD	8,Y
   STX	10,Y
   STU	12,Y
   PULS	D,X,U	
   STD	14,Y
   STX	16,Y
   STU	18,Y
   PULS	D,X,U	
   STD	20,Y
   STX	22,Y
   STU	24,Y
   PULS	D,X,U	
   STD	26,Y
   STX	28,Y
   STU	30,Y
   PULS	D,X,U	
   STD	32,Y
   STX	34,Y
   STU	36,Y
   PULS	D,X,U	
   STD	38,Y
   STX	40,Y
   STU	42,Y
   PULS	D,X,U	
   STD	44,Y
   STX	46,Y
   STU	48,Y
   PULS	D,X,U	
   STD	50,Y
   STX	52,Y
   STU	54,Y
   PULS	D,X,U	
   STD	56,Y
   STX	58,Y
   STU	60,Y
   PULS	D	
   STD	62,Y
   LEAY 128,Y
MEM_COPY_DATA_TO_CART_E
   CMPY    #$00C0
   LBNE    MEM_COPY_DATA_TO_CART_LOOP
MEM_COPY_DATA_TO_CART_S
   LDS     #$0000    * Rechargement du pointeur de la pile systeme
   RTS

********************************************************************************
* Effacement memoire Cartouche (27000 cy)
********************************************************************************
CLR_CART
    PSHS U,DP
    STS CLR_CART_3+2
    LDS #$4000
    LDU #$0C0C
    LDY #$0C0C
    LDX #$0C0C
    LDD #$0C0C
    TFR A,DP
CLR_CART_2
    PSHS U,Y,X,DP,B,A
    PSHS U,Y,X,DP,B,A
    PSHS U,Y,X,DP,B,A
    PSHS U,Y,X,DP,B,A
    PSHS U,Y,X,DP,B,A
    PSHS U,Y,X,DP,B,A
    PSHS U,Y,X,DP,B,A
    PSHS U,Y,X,DP,B,A
    PSHS U,Y,X,DP,B,A
    PSHS U,Y,X,DP,B,A
    CMPS #$0004
    BNE CLR_CART_2
    PSHS U,Y
CLR_CART_3
    LDS #$0000
    PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)
	
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
* Palette de 16 couleurs
********************************************************************************



TABPALETTE
	FDB $0000	* index:1  R:0   V:0   B:0  
	FDB $0002	* index:2  R:139 V:27  B:0  
	FDB $024c	* index:3  R:236 V:170 B:135
	FDB $0016	* index:4  R:189 V:99  B:37 
	FDB $0048	* index:5  R:206 V:159 B:0  
	FDB $0084	* index:6  R:167 V:208 B:66 
	FDB $0040	* index:7  R:75  V:165 B:4  
	FDB $0010	* index:8  R:16  V:94  B:4  
	FDB $0000	* index:9  R:0   V:47  B:15 
	FDB $0110	* index:10 R:22  V:87  B:103
	FDB $0a61	* index:11 R:103 V:183 B:223
	FDB $0ddc	* index:12 R:239 V:240 B:241
	FDB $0c10	* index:13 R:9   V:114 B:239
	FDB $0500	* index:14 R:12  V:32  B:175
	FDB $0000	* index:15 R:53  V:7   B:9  
	FDB $000a	* index:16 R:225 V:0   B:1  
FINTABPALETTE

********************************************************************************
* Get joystick parameters
********************************************************************************
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
* Subroutine to	make HERO walk/run
********************************************************************************
Hero_Move
* si bouton jump: Maj ysp Jump start & charge anim & jump en cours
	LDD JOY_BTN_STATUS
	CMPD #$4000
	BNE Hero_alreadyJumping	* si saut deja en cours on passe le code de demarrage de saut
	LDB HERO_ISJUMPING
	BNE Hero_alreadyJumping		* si un saut n'est pas en cours: on est au sol
	INC HERO_ISJUMPING		* set flag is jumping a 1
	LDD HERO_G_SPEED		* charge la vitesse (negative ou positive)
	BLT Hero_JumpLeft      * si vitesse negative on branche pour animation gauche
	LDX #HERO_JUMP_R        * Charge animation Saut Droite
	BRA Hero_Jump
Hero_JumpLeft	
	LDX #HERO_JUMP_L        * Charge animation Saut Gauche
Hero_Jump
	STX HERO_ANIMATION_ADR	* Sauvegarde animation
	STD HERO_X_SPEED		* Initialisation de la vitesse X
	LDD HERO_AIR_JUMP_VEL	* Initialisation de la vitesse Y
	STD HERO_Y_SPEED
	LDD #$0000
	STD HERO_X_SPS
	STD HERO_Y_SPS

Hero_alreadyJumping
* Maj xsp en fonction de G ou D joystick
	LDB HERO_ISJUMPING
	LBEQ Hero_OnGround		* si un saut n'est pas en cours: on est au sol
	LDA JOY_DIR_STATUS
	CMPA #JOY_D
	BEQ Hero_JumpAccelD
	CMPA #JOY_G
	BEQ Hero_JumpAccelG
	LDD HERO_X_SPEED
	BRA Hero_JumpCapTopXSpeed
Hero_JumpAccelD
	LDD HERO_X_SPEED
	ADDD HERO_AIR_X_ACCELERATION
	BRA Hero_JumpCapTopXSpeed
Hero_JumpAccelG
	LDD HERO_X_SPEED
	SUBD HERO_AIR_X_ACCELERATION

Hero_JumpCapTopXSpeed
* Top xsp
	CMPD HERO_X_TOP_SPEED
	BLE Hero_JumpAirDrag
	LDD HERO_X_TOP_SPEED
	
Hero_JumpAirDrag	
* Maj xsp Air drag
	STD HERO_X_SPEED
	LDD HERO_Y_SPEED	* si ysp (ysp < 0 && ysp > -$0400) on applique le air drag
	BGE Hero_JumpCut
	CMPD #$FC00
	BLE Hero_JumpCut
	LDD HERO_X_SPEED
	BGE Hero_JumpAirDragPositive
	LDB #$C3				* ADD
	STB Hero_AirDragSUB
	LDD #$0000
	SUBD HERO_X_SPEED
	BRA Hero_JumpAirDragCommon
Hero_JumpAirDragPositive
	LDB #$83				* SUB
	STB Hero_AirDragSUB
	LDD HERO_X_SPEED
Hero_JumpAirDragCommon	
	LSRA	* Division par 32 du registre D (vitesse X)
	RORB
	LSRA
	RORB
	LSRA
	RORB
	LSRA
	RORB
	LSRA
	RORB
	STB Hero_AirDragSUB+2	* STB suffisant tant que la vitesse max est <= #$2000 sinon utiliser STD Hero_AirDragSUB+1
	LDD HERO_X_SPEED
Hero_AirDragSUB
	SUBD #$0000
	STD HERO_X_SPEED

Hero_JumpCut
* Maj ysp Jump cut
	LDD HERO_Y_SPEED
	TST JOY_BTN_STATUS	* si le bouton n'est plus appuye
	BNE Hero_JumpGravity
	CMPD HERO_AIR_JUMP_CUT	* et si ysp < HERO_AIR_JUMP_CUT
	BGE Hero_JumpGravity
	LDD HERO_AIR_JUMP_CUT	* ysp est limite a HERO_AIR_JUMP_CUT

Hero_JumpGravity
* Maj ysp with gravity
	ADDD HERO_AIR_Y_GRAVITY	* ajout de la gravite a la vitesse ysp (ce qui fait retomber le hero)

Hero_JumpCapTopYSpeed
* Top ysp
	CMPD HERO_Y_TOP_SPEED	* si la vitesse positive Y (en chute) d�passe la limite
	BLE Hero_JumpPosUpdate
	LDD HERO_Y_TOP_SPEED	* on repositionne la vitesse Y a la limite

Hero_JumpPosUpdate
	STD HERO_Y_SPEED
	
* Maj X et Y pos
	JMP Hero_MoveUpdatePosJump * remplacement de JSR RTS par JMP (Gain: 9c 1o)

* Gestion a Terre
********************************

Hero_OnGround
	LDA JOY_DIR_STATUS
	CMPA #JOY_G
	BNE Hero_NotLeft
	BRA Hero_MoveLeft

Hero_NotLeft                   * XREF: Hero_Move
	CMPA #JOY_D
	BNE Hero_NotLeftOrRight
	JMP Hero_MoveRight

Hero_NotLeftOrRight            * XREF: Hero_NotLeft
	LDD HERO_G_SPEED
	CMPD #$0000
	LBEQ Hero_MoveUpdatePos  * Si la vitesse est deja nulle on passe
	BLT Hero_NotLeftOrRight_00 * se deplace a gauche
	SUBD HERO_FRICTION     * se deplace a droite on soustrait la friction a la vitesse
	CMPD #$0000	
	BGT Hero_NotLeftOrRight_01 * si on passe en dessous de 0 on repositionne a 0
	LDD #$0000
	STD HERO_G_SPEED
	STD HERO_X_SPS
	LDX #HERO_IDLE_R        * Charge animation IDLE R
	STX HERO_ANIMATION_ADR	* Sauvegarde animation

	JMP Hero_MoveUpdatePos
Hero_NotLeftOrRight_01	       
	CMPD #HERO_JOG_SPD_LIMIT
	BGE Hero_NotLeftOrRight_02
	STD HERO_G_SPEED
	LDX #HERO_WALK_R        * Charge animation WALK R
	STX HERO_ANIMATION_ADR	* Sauvegarde animation

	BRA Hero_NotLeftOrRight_03
Hero_NotLeftOrRight_02	
	STD HERO_G_SPEED
Hero_NotLeftOrRight_03
	JMP Hero_MoveUpdatePos
Hero_NotLeftOrRight_00	
	ADDD HERO_FRICTION     * se deplace a gauche on ajoute la friction a la vitesse negative
	BCC Hero_NotLeftOrRight_11 * si on passe au dessus de 0 on repositionne a 0. Remarque le passage de FFFF a 0000 declenche un depassement contrairement au passage de 0001 a 1 (cas droite)
	LDD #$0000
	STD HERO_G_SPEED
	LDX #HERO_IDLE_L        * Charge animation IDLE L
	STX HERO_ANIMATION_ADR	* Sauvegarde animation

	JMP Hero_MoveUpdatePos
Hero_NotLeftOrRight_11	       
	CMPD #HERO_JOG_NEG_SPD_LIMIT
	BLE Hero_NotLeftOrRight_12
	STD HERO_G_SPEED
	LDX #HERO_WALK_L        * Charge animation WALK L
	STX HERO_ANIMATION_ADR	* Sauvegarde animation

	BRA Hero_NotLeftOrRight_13
Hero_NotLeftOrRight_12	
	STD HERO_G_SPEED
Hero_NotLeftOrRight_13
	JMP Hero_MoveUpdatePos

Hero_MoveLeft                  	* XREF: Hero_Move
	LDD HERO_G_SPEED       	* Chargement de la vitesse au sol
	CMPD #$0000                	* Test orientation
	BLE Hero_MoveLeft_00       	* BRANCH si orientation a GAUCHE
	SUBD HERO_DECELERATION 	* orientation a DROITE on reduit la vitesse
	BCC Hero_MoveLeft_03       	* BRANCH si orientation toujours a DROITE
	LDD #$0000				   	
	SUBD HERO_DECELERATION 	* si la vitesse est devenue negative on la force a la valeur de -DECELERATION
Hero_MoveLeft_03	           	
	STD HERO_G_SPEED       	* On stocke la vitesse
	JMP Hero_MoveUpdatePos	   	* Mise a jour des coordonnees
Hero_MoveLeft_00		       	* Orientation a GAUCHE 
	CMPD HERO_X_NEG_TOP_SPEED	* Comparaison avec la vitesse maximum
	BEQ Hero_MoveUpdatePos     	* vitesse au sol deja au maximum - Mise a jour des coordonnees
	SUBD HERO_ACCELERATION 	* acceleration
	CMPD HERO_X_NEG_TOP_SPEED	* Comparaison avec la vitesse maximum
	BGT Hero_MoveLeft_01       	* BRANCH si vitesse inferieur au maximum
	LDX #HERO_RUN_L        * Charge animation RUN L
	STX HERO_ANIMATION_ADR	* Sauvegarde animation

	LDD HERO_X_NEG_TOP_SPEED 	* Limitation de la vitesse au maximum
	STD HERO_G_SPEED       	* Enregistrement de la vitesse
	JMP Hero_MoveUpdatePos    	* Mise a jour des coordonnees
Hero_MoveLeft_01               	
	STD HERO_G_SPEED       	* Enregistrement de la vitesse
	LDX #HERO_WALK_L        * Charge animation WALK L
	STX HERO_ANIMATION_ADR	* Sauvegarde animation

	JMP Hero_MoveUpdatePos

Hero_MoveRight                  * XREF: Hero_NotLeft
	LDD HERO_G_SPEED        * Chargement de la vitesse au sol
	CMPD #$0000                 * Test orientation
	BGE Hero_MoveRight_00       * BRANCH si orientation a DROITE
	ADDD HERO_DECELERATION 	* orientation a GAUCHE on reduit la vitesse
	BCC Hero_MoveRight_03       * BRANCH si orientation toujours a GAUCHE
	LDD HERO_DECELERATION   * si la vitesse est devenue positive on la force a la valeur de DECELERATION
Hero_MoveRight_03	
	STD HERO_G_SPEED        * On stocke la vitesse
	JMP Hero_MoveUpdatePos		* Mise a jour des coordonnees
Hero_MoveRight_00		      	* Orientation a DROITE 
	CMPD HERO_X_TOP_SPEED		* Comparaison avec la vitesse maximum
	BEQ Hero_MoveUpdatePos      * vitesse au sol deja au maximum - Mise a jour des coordonnees
	ADDD HERO_ACCELERATION 	* acceleration
	CMPD HERO_X_TOP_SPEED		* Comparaison avec la vitesse maximum
	BLT Hero_MoveRight_01       * BRANCH si vitesse inferieur au maximum
	LDX #HERO_RUN_R			* Charge animation RUN R
	STX HERO_ANIMATION_ADR	* Sauvegarde animation

	LDD HERO_X_TOP_SPEED		* Limitation de la vitesse au maximum
	STD HERO_G_SPEED		* Enregistrement de la vitesse
	JMP Hero_MoveUpdatePos		* Mise a jour des coordonnees
Hero_MoveRight_01
	STD HERO_G_SPEED				* Enregistrement de la vitesse
	LDX #HERO_WALK_R        		* Charge animation WALK R
	STX HERO_ANIMATION_ADR			* Sauvegarde animation

*******************************************************************
* Mise a jour de la vitesse X et Y a partir de la vitesse au sol  *
*******************************************************************

Hero_MoveUpdatePos
	LDD HERO_G_SPEED				* Chargement de la vitesse au sol
* TODO MAJ HERO_X_SPEED : xsp = gsp*cos(angle)
* TODO MAJ HERO_Y_SPEED : ysp = gsp*-sin(angle)
	STD HERO_X_SPEED
	CLR HERO_Y_SPEED

*******************************************************************
* Mise a jour de la position X et Y a partir de la vitesse X et Y *
*******************************************************************

* Coordonnees X
***************

Hero_MoveUpdatePosJump
	LDD HERO_X_SPEED
	BGE Hero_MoveUpdateXPos_00   	* BRANCH si orientation vers la DROITE
	LDA #$C0						* code de l'instruction SUBB
	STA Hero_MoveUpdateXPos_00C		* Auto-modification de code on positionne SUBB
	LDD #$0000
	SUBD HERO_X_SPEED				* La vitesse negative est convertie en positive 
	BRA Hero_MoveUpdateXPos_00A
Hero_MoveUpdateXPos_00
	LDA #$CB						* code de l'instruction ADDB
	STA Hero_MoveUpdateXPos_00C		* Auto-modification de code on positionne ADDB
	LDD HERO_X_SPEED
Hero_MoveUpdateXPos_00A	
	ADDD HERO_X_SPS         		* Ajout du reste subpixel
	STA Hero_MoveUpdateXPos_00B+1 	* Sauvegarde par auto-modification de code
	ANDA #$03               		* on garde le reliquat de la division par 4 frames
	STD HERO_X_SPS					* sauvegarde du nouveau reste subpixel
Hero_MoveUpdateXPos_00B
	LDB #$00						* restauration du calcul de frame
	LSRB							* gestion pixel aspect ratio 2:1
	LSRB							* gestion pixel block 2x
	STB Hero_MoveUpdateXPos_00C+1 	* auto-modification de code
	LDB HERO_X_POS
Hero_MoveUpdateXPos_00C
	ADDB #$00						* Mise a jour de la position
Hero_MoveUpdateXPos_01
	CMPB #$47					* Test de butee ecran a droite
	BLE Hero_MoveUpdateXPos_02	* Butee non atteinte
	LDB #$47					* Butee atteinte on limite a la butee
Hero_MoveUpdateXPos_02
    CMPB #$00					* Test de la butee ecran a gauche
	BGE Hero_MoveUpdateXPos_03	* Butee non atteinte
	LDB #$00					* Butee atteinte on limite a la butee
Hero_MoveUpdateXPos_03
	STB HERO_X_POS

* Coordonnees Y
***************

	LDD HERO_Y_SPEED				* TODO voir si gain de cycles si on utilise une autre methode que l'automodif
	BGE Hero_MoveUpdateYPos_00   	* BRANCH si orientation vers le HAUT
	LDA #$C0						* code de l'instruction SUBB
	STA Hero_MoveUpdateYPos_00C		* Auto-modification de code on positionne SUBB
	LDD #$0000
	SUBD HERO_Y_SPEED				* La vitesse negative est convertie en positive 
	BRA Hero_MoveUpdateYPos_00A
Hero_MoveUpdateYPos_00
	LDA #$CB						* code de l'instruction ADDB
	STA Hero_MoveUpdateYPos_00C		* Auto-modification de code on positionne ADDB
	LDD HERO_Y_SPEED
Hero_MoveUpdateYPos_00A	
	ADDD HERO_Y_SPS         		* Ajout du reste subpixel
	STB HERO_Y_SPS+1				* sauvegarde du nouveau reste subpixel
	STA Hero_MoveUpdateYPos_00C+1 	* auto-modification de code
	LDB HERO_Y_POS
Hero_MoveUpdateYPos_00C
	ADDB #$00						* Mise a jour de la position
Hero_MoveUpdateYPos_01
	CMPB #$98						* Test de butee ecran en BAS
	BLS Hero_MoveUpdateYPos_03		* Butee non atteinte
	LDB #$98						* Butee atteinte on limite a la butee
	TST HERO_ISJUMPING
	BEQ Hero_MoveUpdateYPos_03	* pas de saut en cours
	STB HERO_Y_POS
* si retombe au sol on repositionne animation idle walk ou jog puis flag jump off et maj gsp
	CLR HERO_ISJUMPING
	LDD HERO_X_SPEED
	STD HERO_G_SPEED
	LDX #HERO_IDLE_R        		* Charge animation WALK R
	STX HERO_ANIMATION_ADR			* Sauvegarde animation
	RTS
Hero_MoveUpdateYPos_03
	STB HERO_Y_POS
	RTS

* TODO : Braking Animation
* Sonic enters his braking animation when you turn around only if his absolute gsp is equal to or more than 4.
* In Sonic 1 and Sonic CD, he then stays in the braking animation until gsp reaches zero or changes sign.
* In the other 3 games, Sonic returns to his walking animation after the braking animation finishes displaying all of its frames.

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
	
*   SAMPLE CODE ANIMATION
*	---------------------
*	FDB $0018		* 00 Absolute (Different from $00 means NbFrames relative to GSP) 18 Nb frames par image
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
*	LDX #HERO_IDLE_R
*	JSR HERO_ANIMATION_LOAD
*
*	JSR HERO_ANIMATION_NEXT

********************************************************************************
* ANIMATION Scripts
********************************************************************************



	FDB $0018
HERO_WALK_R
	FCB $04
	FDB $A000
	FDB $A4AF
	FCB $FF
	FDB HERO_WALK_R
	FDB $0000

	FDB $0018
HERO_IDLE_R
	FCB $04
	FDB $A000
	FDB $A4AF
	FCB $FF
	FDB HERO_IDLE_R
	FDB $0000

	FDB $0018
HERO_RUN_R
	FCB $04
	FDB $A000
	FDB $A4AF
	FCB $FF
	FDB HERO_RUN_R
	FDB $0000

	FDB $0018
HERO_WALK_L
	FCB $04
	FDB $A000
	FDB $A4AF
	FCB $FF
	FDB HERO_WALK_L
	FDB $0000

	FDB $0018
HERO_JUMP_R
	FCB $04
	FDB $A000
	FDB $A4AF
	FCB $FF
	FDB HERO_JUMP_R
	FDB $0000

	FDB $0018
HERO_RUN_L
	FCB $04
	FDB $A000
	FDB $A4AF
	FCB $FF
	FDB HERO_RUN_L
	FDB $0000

	FDB $0018
HERO_JUMP_L
	FCB $04
	FDB $A000
	FDB $A4AF
	FCB $FF
	FDB HERO_JUMP_L
	FDB $0000

	FDB $0018
HERO_IDLE_L
	FCB $04
	FDB $A000
	FDB $A4AF
	FCB $FF
	FDB HERO_IDLE_L
	FDB $0000
	
********************************************************************************
* HERO Variables
********************************************************************************

HERO_X_TOP_SPEED
	FDB $0600        * 0600 vitesse X maximum autorisee 6 = 1536/256
HERO_X_NEG_TOP_SPEED
	FDB $FA00        * FA00 vitesse X maximum autorisee -6 = -1536/256
HERO_Y_TOP_SPEED
	FDB $1000        * 0010 vitesse Y maximum autorisee 16 = 4096/256
HERO_ACCELERATION
	FDB $000C        * 000C constante acceleration 0.046875 = 12/256
HERO_DECELERATION
	FDB $0080        * 0080 constante deceleration 0.5 = 128/256
HERO_FRICTION
	FDB $000C        * 000C constante de friction 0.046875 = 12/256
HERO_AIR_X_ACCELERATION
	FDB $0018        * 0018 constate air acceleration 0.09375 = 24/256
HERO_AIR_Y_GRAVITY
	FDB $0038        * 0038 constante gravite 0.21875 = 56/256
HERO_AIR_X_DRAG
	FDB $00F8        * 00F8 constante air drag 0.96875 = 248/256
HERO_AIR_JUMP_VEL
	FDB $F980		 * F980 constante air jump start velocity -6.5 = -1664/256
HERO_AIR_JUMP_CUT
	FDB $FC00		 * FC constante air jump cut -4 = -1024/256
	
*HERO_WALK_SPD_LIMIT EQU $0400		* 0400
*HERO_WALK_NEG_SPD_LIMIT EQU $FC00  * FC00
HERO_JOG_SPD_LIMIT EQU $0600        * 0600
HERO_JOG_NEG_SPD_LIMIT EQU $FA00    * FA00

HERO_X_POS
	FCB $00			* Horizontal Position
HERO_Y_POS
	FCB $98			* Vertical Position (TODO Bug si position Y=00)
HERO_G_SPEED
	FDB $0000		* Ground Speed First byte : Frame, Second byte : 1/256 Frame
HERO_X_SPEED
	FDB $0000		* Horizontal Speed
HERO_X_SPS
	FDB $0000		* Subpixel X speed (reliquat entre deux frames)
HERO_Y_SPEED
	FDB $0000		* Vertical Speed
HERO_Y_SPS
	FDB $0000		* Subpixel Y speed (reliquat entre deux frames)
	
HERO_ANIMATION_ADR
	FDB $0000        * Animation courante - Pointeurs Adresse
HERO_ANIMATION_ADR_OLD
	FDB $0000        * Sauvegarde ancienne animation
HERO_ANIMATION_RTN_ADR
	FDB $0000        * Animation courante - Pointeur Adresse Retour Animation apellante
HERO_ANIMATION_PAG
	FCB $00          * Animation courante - Pointeur Page actif
HERO_ANIMATION_PAG_REF
	FCB $00          * Animation courante - Pointeur Page de reference
HERO_ANIMATION_PAG_DEL
	FCB $00        * Animation courante - Pointeur Page Effacement img-1
	FCB $00        * Animation courante - Pointeur Page Effacement
HERO_ANIMATION_DEL
	FDB $0000        * Animation courante - Pointeur Effacement img-1
	FDB $0000        * Animation courante - Pointeur Effacement
HERO_ANIMATION_DRW
	FDB $0000        * Animation courante - Pointeur Dessin
HERO_ANIMATION_IMC
	FCB $00          * Animation courante - Image courante (doit etre suivi de RTN_IMC)
HERO_ANIMATION_RTN_IMC
	FCB $00          * Animation courante - Image courante Retourn Animation apellante (doit etre precede de IMC)
HERO_ANIMATION_FRR
	FCB $00          * Animation courante - Frames restante