********************************************************************************
*                               CompiledSprite                                 *
********************************************************************************
* Auteur  :                                                                    *
* Date    :                                                                    *
* Licence :                                                                    *
********************************************************************************
*
********************************************************************************

(main)TEST1X10.asm
	ORG $8000

********************************************************************************  
* Constantes et variables
********************************************************************************
DEBUTECRANA EQU $0014 * test pour fin stack blasting
FINECRANA EQU $1F40   * fin de la RAM A video
DEBUTECRANB EQU $2014 * test pour fin stack blasting
FINECRANB EQU $3F40   * fin de la RAM B video
JOY_BD EQU #$05        * Bas Droite
JOY_HD EQU #$06        * Haut Droite
JOY_D  EQU #$07        * Droite
JOY_BG EQU #$09        * Bas Gauche
JOY_HG EQU #$0A        * Haut Gauche
JOY_G  EQU #$0B        * Gauche
JOY_B  EQU #$0D        * Bas
JOY_H  EQU #$0E        * Haut
JOY_C  EQU #$0F        * Centre

SSAVE FDB $0000

********************************************************************************  
* Debut du programme
********************************************************************************
	ORCC #$50	* a documenter (interruption)
	
	LDA #$7B	* passage en mode 160x200x16c
	STA $E7DC	

********************************************************************************  
* Initialisation de la palette de couleurs
********************************************************************************
	LDY #TABPALETTE
	CLRA
SETPALETTE
	PSHS A
	ASLA
	STA $E7DB
	LDD ,Y++
	STB $E7DA
	STA $E7DA
	PULS A
	INCA
	CMPY #FINTABPALETTE
	BNE	SETPALETTE
	
********************************************************************************
* Initialisation de la routine de commutation de page video
********************************************************************************
	LDB $6081 * A documenter
	ORB #$10  * mettre le bit d4 a 1
	STB $6081
	STB $E7E7
	JSR SCRC * page 2 en RAM Cartouche (0000-3FFF) - page 0 en RAM Ecran (4000-5FFF)
	
*-------------------------------------------------------------------------------
* Initialisation des deux pages videos avec Fond et sprites
*-------------------------------------------------------------------------------
	LDB #$03  * On monte la page 3
	STB $E7E5 * en RAM Donnees (A000-DFFF)
	
	JSR DRAW_RAM_DATA_TO_CART_160x200
	JSR DRAW_TEST1X100000               * TODO Boucle sur tous les sprites visibles
	JSR SCRC                            * page 0 en RAM Cartouche (0000-3FFF) - page 2 en RAM Ecran (4000-5FFF)
	JSR DRAW_RAM_DATA_TO_CART_160x200
	JSR DRAW_TEST1X100000               * TODO Boucle sur tous les sprites visibles
	JSR SCRC                            * page 2 en RAM Cartouche (0000-3FFF) - page 0 en RAM Ecran (4000-5FFF)
	
*-------------------------------------------------------------------------------
* Boucle principale
*-------------------------------------------------------------------------------
MAIN
	* Effacement et affichage des sprites
	JSR [DRAW_EREF_TEST1X100000_1] * TODO boucler sur tous les effacements de sprite visibles dans le bon ordre
	JSR DRAW_TEST1X100000 * TODO boulcuer sur tous les sprites visibles dans le bon ordre
	
	* Gestion des deplacements
	JSR JOY_READ
	JSR Hero_Move

	JSR SCRC        * changement de page ecran
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
	JSR VSYNC
	
	LDX DRAW_EREF_TEST1X100000_1	* permute les routines
	LDY DRAW_EREF_TEST1X100000_1+2  * d effacement
	STY DRAW_EREF_TEST1X100000_1    * des sprites
	STX DRAW_EREF_TEST1X100000_1+2  * TODO faire boucle sur tous les sprites VISIBLES
	
	LDB SCRC0+1	* charge la valeur du LDB suivant SCRC0 en lisant directement dans le code
	ANDB #$80	* permute #$00 ou #$80 (suivant la valeur B #$00 ou #$FF) / fond couleur 0
	ORB #$0F	* recharger la couleur de cadre si diff de 0 car effacee juste au dessus (couleur F)
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

*---------------------------------------
* Get joystick parameters
*---------------------------------------
JOY_READ
	ldx    #$e7cf
	ldy    #$e7cd
	ldd    #$400f 
	andb   >$e7cc     * Read position
	stb    JOY_STATUS
	anda   ,y         * Read button
	eora   #$40
	sta    JOY_BTN_STATUS
	RTS
JOY_DIR_STATUS
	FCB $00 * Position Pad
JOY_BTN_STATUS
	FCB $00 * 40 Bouton A enfonce

*---------------------------------------------------------------------------
* Subroutine to	make hero walk/run
*---------------------------------------------------------------------------

Hero_Move
	LDA JOY_G
	CMPA JOY_DIR_STATUS
	BNE Hero_NotLeft
	BSR Hero_MoveLeft

Hero_NotLeft                   * XREF: Hero_Move
	LDA JOY_D
	CMPA JOY_DIR_STATUS
	BNE Hero_NotRight
	BSR Hero_MoveRight

Hero_NotRight                  * XREF: Hero_NotLeft
	LDD TEST1X10_G_SPEED
	CMPD #$0000
	BLO Hero_NotRight_00
	SUBD TEST1X10_ACCELERATION * If you are not pressing Left or Right, friction (frc) kicks in. In any step in which the game recieves no horizontal input,
	BCC Hero_NotRight_01       * frc is subtracted from gsp (depending on the sign of gsp), where if it then passes over 0, it's set back to 0.
	LDA #$01                   * Charge animation STOP R
Hero_NotRight_02
	STA TEST1X10_ANIMATION
	LDD	#$0000
Hero_NotRight_01
	STD TEST1X10_G_SPEED
	RTS
Hero_NotRight_00
	ADDD TEST1X10_ACCELERATION 
	BCC Hero_NotRight_01      
	LDA #$02                   * Charge animation STOP L     
    BRA Hero_NotRight_02	
	
Hero_MoveLeft                  * XREF: Hero_Move
	LDD TEST1X10_G_SPEED
	CMPD #$0000
	BLT Hero_MoveLeft_00       * BRANCH si la vitesse actuelle est negative
	SUBD TEST1X10_DECELERATION * gsp decrease by deceleration
	BCC Hero_MoveLeft_03       * BRANCH si la vitesse actuelle est positive
    LDD TEST1X10_DECELERATION  * si la vitesse est devenue negative on la force a la va leur de DECELERATION
Hero_MoveLeft_03	
	STD TEST1X10_G_SPEED       * la vitesse actuelle est negative, Hero va a gauche
	BRA Hero_MoveLeft_02	
Hero_MoveLeft_00		
	CMPD TEST1X10_NEG_TOP_SPEED
	BEQ Hero_MoveLeft_02       * gsp est deja au maximum
	SUBD TEST1X10_ACCELERATION * gsp increases by acc every step
	CMPD TEST1X10_NEG_TOP_SPEED
	BLE Hero_MoveLeft_01       * if gsp exceeds top it's set to top
	LDA #$06                   * Charge animation RUN L
	STA TEST1X10_ANIMATION
	LDD TEST1X10_NEG_TOP_SPEED
	STD TEST1X10_G_SPEED
	BRA Hero_MoveLeft_02
Hero_MoveLeft_01
	STD TEST1X10_G_SPEED
	LDA #$04                   * Charge animation WALK L
	STA TEST1X10_ANIMATION
	LDD TEST1X10_G_SPEED
Hero_MoveLeft_02
	STD TEST1X10_X_SPEED       * TODO xsp = gsp*cos(angle)
	ADDD TEST1X10_X_POS
	STD TEST1X10_X_POS
	LDD #$0000                 * TODO ysp = gsp*-sin(angle)
	STD TEST1X10_Y_SPEED
	ADDD TEST1X10_Y_POS
	STD TEST1X10_Y_POS
	RTS
	
Hero_MoveRight                  * XREF: Hero_NotLeft
	LDD TEST1X10_G_SPEED
	CMPD #$0000
	BGE Hero_MoveRight_00       * BRANCH si la vitesse actuelle est nulle ou positive
	ADDD TEST1X10_DECELERATION 	* gsp decrease by deceleration
	BCC Hero_MoveRight_03       * BRANCH si la vitesse actuelle est negative
    LDD TEST1X10_DECELERATION   * si la vitesse est devenue positive on la force a la va leur de DECELERATION
Hero_MoveRight_03	
	STD TEST1X10_G_SPEED        * la vitesse actuelle est negative, Hero va a gauche
	BRA Hero_MoveRight_02	
Hero_MoveRight_00		
	CMPD TEST1X10_TOP_SPEED
	BEQ Hero_MoveRight_02       * gsp est deja au maximum
	ADDD TEST1X10_ACCELERATION 	* gsp increases by acc every step
	CMPD TEST1X10_TOP_SPEED
	BLE Hero_MoveRight_01       * if gsp exceeds top it's set to top
	LDA #$05                    * Charge animation RUN R
	STA TEST1X10_ANIMATION
	LDD TEST1X10_TOP_SPEED
	STD TEST1X10_G_SPEED
	BRA Hero_MoveRight_02
Hero_MoveRight_01
	STD TEST1X10_G_SPEED
	LDA #$03                    * Charge animation WALK R
	STA TEST1X10_ANIMATION
	LDD TEST1X10_G_SPEED
Hero_MoveRight_02
	STD TEST1X10_X_SPEED        * TODO xsp = gsp*cos(angle)
	ADDD TEST1X10_X_POS
	STD TEST1X10_X_POS
	LDD #$0000                  * TODO ysp = gsp*-sin(angle)
	STD TEST1X10_Y_SPEED
	ADDD TEST1X10_Y_POS
	STD TEST1X10_Y_POS
	RTS

* TODO : Braking Animation
* Sonic enters his braking animation when you turn around only if his absolute gsp is equal to or more than 4.
* In Sonic 1 and Sonic CD, he then stays in the braking animation until gsp reaches zero or changes sign.
* In the other 3 games, Sonic returns to his walking animation after the braking animation finishes displaying all of its frames.

Compute_Position
* Doit calculer ici les deux positions POS_TEST1X100000 pour RAMA et RAMB en fonction de TEST1X10_X_POS et TEST1X10_Y_POS
	*LDX POS_TEST1X100000	* avance de 2 px a gauche
	*LDD POS_TEST1X100000+2
	*STX POS_TEST1X100000+2
	*SUBD JOY_STATUS
	*STD POS_TEST1X100000
	RTS

********************************************************************************
* Affiche un computed sprite en xxx cycles
********************************************************************************
TEST1X10_X_POS
	FDB $0000        * position horizontale
TEST1X10_Y_POS
	FDB $0000        * position verticale
TEST1X10_G_SPEED
	FDB $0000        * vitesse au sol
TEST1X10_X_SPEED
	FDB $0000        * vitesse horizontale
TEST1X10_Y_SPEED
	FDB $0000        * vitesse verticale
TEST1X10_TOP_SPEED
	FDB $0600        * vitesse maximum autorisee 6 = 1536/256
TEST1X10_NEG_TOP_SPEED
	FDB $FA00        * vitesse maximum autorisee -6 = -1536/256
TEST1X10_ACCELERATION
	FDB $000C        * constante acceleration 0.046875 = 12/256
TEST1X10_DECELERATION
	FDB $0080        * constante deceleration 0.5 = 128/256
TEST1X10_FRICTION
	FDB $000C        * constante de friction 0.046875 = 12/256
TEST1X10_ANIMATION
	FCB $00          * Animation courante
TEST1X10_REF_ANIMATIONS
	FDB DRAW_TEST1X10_NULL * sprite invisible
	FDB DRAW_TEST1X10_STOP_R * sprite immobile Droite
	FDB DRAW_TEST1X10_STOP_L * sprite immobile Gauche
	FDB DRAW_TEST1X10_WALK_R * sprite marche Droite
	FDB DRAW_TEST1X10_WALK_L * sprite marche Gauche
	FDB DRAW_TEST1X10_RUN_R * sprite cours Droite
	FDB DRAW_TEST1X10_RUN_L * sprite cours Gauche

DRAW_TEST1X100000
	PSHS U,DP
	STS >SSAVE

	LDS POS_TEST1X100000
	LDU #DATA_TEST1X100000_1

	LDA -1,S
	LDX DRAW_EREF_TEST1X100000_1
	STA 14,X
	LDA #$98
	STA -1,S
	LDA -41,S
	LDX DRAW_EREF_TEST1X100000_1
	STA 18,X
	LDA #$89
	STA -41,S

	LDS POS_TEST1X100000+2
	LDU #DATA_TEST1X100000_2

	LDA -1,S
	LDX DRAW_EREF_TEST1X100000_1
	STA 30,X
	LDA #$89
	STA -1,S
	LDA -41,S
	LDX DRAW_EREF_TEST1X100000_1
	STA 34,X
	LDA #$98
	STA -41,S

	LDX POS_TEST1X100000	* save des positions pour effacement
	LDY DRAW_EREF_TEST1X100000_1
	STX 45,Y
	LDX POS_TEST1X100000+2
	LDY DRAW_EREF_TEST1X100000_1
	STX 47,Y

	LDS  >SSAVE
	PULS U,DP
	RTS

DATA_TEST1X100000_1
DATA_TEST1X100000_2
POS_TEST1X100000
	FDB $1F40
	FDB $3F40
DRAW_EREF_TEST1X100000_1
	FDB E1DRAW_TEST1X100000
	FDB E2DRAW_TEST1X100000

E1DRAW_TEST1X100000
	PSHS U,DP
	STS >SSAVE

	LDS E1POS_TEST1X100000
	LDU #E1DATA_TEST1X100000_1

	LDA #$98
	STA -1,S
	LDA #$89
	STA -41,S

	LDS E1POS_TEST1X100000+2
	LDU #E1DATA_TEST1X100000_2

	LDA #$89
	STA -1,S
	LDA #$98
	STA -41,S

	LDS  >SSAVE
	PULS U,DP
	RTS

E1DATA_TEST1X100000_1
E1DATA_TEST1X100000_2
E1POS_TEST1X100000
	FDB $1F40
	FDB $3F40

E2DRAW_TEST1X100000
	PSHS U,DP
	STS >SSAVE

	LDS E2POS_TEST1X100000
	LDU #E2DATA_TEST1X100000_1

	LDA #$98
	STA -1,S
	LDA #$89
	STA -41,S

	LDS E2POS_TEST1X100000+2
	LDU #E2DATA_TEST1X100000_2

	LDA #$89
	STA -1,S
	LDA #$98
	STA -41,S

	LDS  >SSAVE
	PULS U,DP
	RTS

E2DATA_TEST1X100000_1
E2DATA_TEST1X100000_2
E2POS_TEST1X100000
	FDB $1F40
	FDB $3F40

********************************************************************************  
* Affichage de l arriere plan xxx cycles
********************************************************************************	
DRAW_RAM_DATA_TO_CART_160x200
	PSHS U,DP		* sauvegarde des registres pour utilisation du stack blast
	STS >SSAVE
	
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

	LDS  >SSAVE		* rechargement des registres
	PULS U,DP
	RTS

TABPALETTE
	FDB $0111	* index:0  R:51  V:51  B:51 
	FDB $0143	* index:1  R:108 V:126 B:60 
	FDB $0113	* index:2  R:107 V:55  B:65 
	FDB $0484	* index:3  R:132 V:182 B:124
	FDB $0112	* index:4  R:92  V:66  B:60 
	FDB $0247	* index:5  R:180 V:138 B:84 
	FDB $0233	* index:6  R:116 V:106 B:84 
	FDB $0177	* index:7  R:172 V:178 B:60 
	FDB $0111	* index:8  R:60  V:50  B:60 
	FDB $0016	* index:9  R:164 V:66  B:44 
	FDB $0698	* index:10 R:187 V:197 B:163
	FDB $0344	* index:11 R:132 V:126 B:108
	FDB $0221	* index:12 R:68  V:94  B:92 
	FDB $0452	* index:13 R:92  V:142 B:124
	FDB $0356	* index:14 R:164 V:154 B:116
	FDB $0125	* index:15 R:140 V:102 B:76 
FINTABPALETTE
