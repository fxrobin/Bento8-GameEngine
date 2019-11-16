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
DEBUTECRANA EQU $0014	* test pour fin stack blasting
FINECRANA   EQU $1F40	* fin de la RAM A video
DEBUTECRANB EQU $2014	* test pour fin stack blasting
FINECRANB   EQU $3F40	* fin de la RAM B video
JOY_BD EQU $05       * Bas Droite
JOY_HD EQU $06       * Haut Droite
JOY_D  EQU $07       * Droite
JOY_BG EQU $09       * Bas Gauche
JOY_HG EQU $0A       * Haut Gauche
JOY_G  EQU $0B       * Gauche
JOY_B  EQU $0D       * Bas
JOY_H  EQU $0E       * Haut
JOY_C  EQU $0F       * Centre

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
	*JSR [DRAW_EREF_TEST1X100000] * TODO boucler sur tous les effacements de sprite visibles dans le bon ordre
	JSR DRAW_RAM_DATA_TO_CART
	JSR DRAW_TEST1X100000 * TODO boulcuer sur tous les sprites visibles dans le bon ordre

	* Gestion des deplacements
	JSR JOY_READ
	JSR Hero_Move
	JSR Compute_Position

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

	LDX DRAW_EREF_TEST1X100000	* permute les routines
	LDY DRAW_EREF_TEST1X100000+2  * d effacement
	STY DRAW_EREF_TEST1X100000    * des sprites
	STX DRAW_EREF_TEST1X100000+2  * TODO faire boucle sur tous les sprites VISIBLES

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
	stb    JOY_DIR_STATUS
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
	LDA JOY_DIR_STATUS
	CMPA #JOY_G
	BNE Hero_NotLeft
	BRA Hero_MoveLeft

Hero_NotLeft                   * XREF: Hero_Move
	CMPA #JOY_D
	BNE Hero_NotLeftOrRight
	LBRA Hero_MoveRight

Hero_NotLeftOrRight            * XREF: Hero_NotLeft
	LDD TEST1X10_G_SPEED
	CMPD #$0000
	BLT Hero_NotLeftOrRight_00 * se deplace a gauche
	SUBD TEST1X10_FRICTION     * se deplace a droite on soustrait la friction a la vitesse
	BCC Hero_NotLeftOrRight_01 * si on passe en dessous de 0 on repositionne a 0
	LDD #$0000
	STD TEST1X10_G_SPEED
	LDA #$01                  * Charge animation IDLE R
	STA TEST1X10_ANIMATION
	LBRA Hero_MoveUpdatePos
Hero_NotLeftOrRight_01	       
	CMPD #TEST1X10_JOG_SPD_LIMIT
	BGE Hero_NotLeftOrRight_02
	STD TEST1X10_G_SPEED
	LDA #$03                  * Charge animation WALK R
	STA TEST1X10_ANIMATION
	BRA Hero_NotLeftOrRight_03
Hero_NotLeftOrRight_02	
	STD TEST1X10_G_SPEED
Hero_NotLeftOrRight_03
	LBRA Hero_MoveUpdatePos
Hero_NotLeftOrRight_00	
	ADDD TEST1X10_FRICTION     * se deplace a gauche on ajoute la friction a la vitesse negative
	BCC Hero_NotLeftOrRight_11 * si on passe au dessus de 0 on repositionne a 0
	LDD #$0000
	STD TEST1X10_G_SPEED
	LDA #$02                  * Charge animation IDLE L
	STA TEST1X10_ANIMATION
	LBRA Hero_MoveUpdatePos
Hero_NotLeftOrRight_11	       
	CMPD #TEST1X10_JOG_SPD_LIMIT
	BLE Hero_NotLeftOrRight_12
	STD TEST1X10_G_SPEED
	LDA #$04                  * Charge animation WALK L
	STA TEST1X10_ANIMATION
	BRA Hero_NotLeftOrRight_13
Hero_NotLeftOrRight_12	
	STD TEST1X10_G_SPEED
Hero_NotLeftOrRight_13
	LBRA Hero_MoveUpdatePos

Hero_MoveLeft                  	* XREF: Hero_Move
	LDD TEST1X10_G_SPEED       	* Chargement de la vitesse au sol
	CMPD #$0000                	* Test orientation
	BLE Hero_MoveLeft_00       	* BRANCH si orientation a GAUCHE
	SUBD TEST1X10_DECELERATION 	* orientation a DROITE on reduit la vitesse
	BCC Hero_MoveLeft_03       	* BRANCH si orientation toujours a DROITE
	LDD #$0000				   	
	SUBD TEST1X10_DECELERATION 	* si la vitesse est devenue negative on la force a la valeur de -DECELERATION
Hero_MoveLeft_03	           	
	STD TEST1X10_G_SPEED       	* On stocke la vitesse
	LBRA Hero_MoveUpdatePos	   	* Mise a jour des coordonnees
Hero_MoveLeft_00		       	* Orientation a GAUCHE 
	CMPD TEST1X10_NEG_TOP_SPEED	* Comparaison avec la vitesse maximum
	BEQ Hero_MoveUpdatePos     	* vitesse au sol deja au maximum - Mise a jour des coordonnees
	SUBD TEST1X10_ACCELERATION 	* acceleration
	CMPD TEST1X10_NEG_TOP_SPEED	* Comparaison avec la vitesse maximum
	BGT Hero_MoveLeft_01       	* BRANCH si vitesse inferieur au maximum
	LDA #$06                   	* Charge animation RUN L
	STA TEST1X10_ANIMATION     	* Sauvegarde animation
	LDD TEST1X10_NEG_TOP_SPEED 	* Limitation de la vitesse au maximum
	STD TEST1X10_G_SPEED       	* Enregistrement de la vitesse
	LBRA Hero_MoveUpdatePos    	* Mise a jour des coordonnees
Hero_MoveLeft_01               	
	STD TEST1X10_G_SPEED       	* Enregistrement de la vitesse
	LDA #$04                   	* Charge animation WALK L
	STA TEST1X10_ANIMATION     	* Sauvegarde animation
	LBRA Hero_MoveUpdatePos

Hero_MoveRight                  * XREF: Hero_NotLeft
	LDD TEST1X10_G_SPEED        * Chargement de la vitesse au sol
	CMPD #$0000                 * Test orientation
	BGE Hero_MoveRight_00       * BRANCH si orientation a DROITE
	ADDD TEST1X10_DECELERATION 	* orientation a GAUCHE on reduit la vitesse
	BCC Hero_MoveRight_03       * BRANCH si orientation toujours a GAUCHE
	LDD TEST1X10_DECELERATION   * si la vitesse est devenue positive on la force a la valeur de DECELERATION
Hero_MoveRight_03	
	STD TEST1X10_G_SPEED        * On stocke la vitesse
	LBRA Hero_MoveUpdatePos		* Mise a jour des coordonnees
Hero_MoveRight_00		      	* Orientation a DROITE 
	CMPD TEST1X10_TOP_SPEED		* Comparaison avec la vitesse maximum
	BEQ Hero_MoveUpdatePos      * vitesse au sol deja au maximum - Mise a jour des coordonnees
	ADDD TEST1X10_ACCELERATION 	* acceleration
	CMPD TEST1X10_TOP_SPEED		* Comparaison avec la vitesse maximum
	BLT Hero_MoveRight_01       * BRANCH si vitesse inferieur au maximum
	LDA #$05                    * Charge animation RUN R
	STA TEST1X10_ANIMATION		* Sauvegarde animation
	LDD TEST1X10_TOP_SPEED		* Limitation de la vitesse au maximum
	STD TEST1X10_G_SPEED		* Enregistrement de la vitesse
	LBRA Hero_MoveUpdatePos		* Mise a jour des coordonnees
Hero_MoveRight_01
	STD TEST1X10_G_SPEED		* Enregistrement de la vitesse
	LDA #$03                    * Charge animation WALK R
	STA TEST1X10_ANIMATION		* Sauvegarde animation

Hero_MoveUpdatePos
	LDD TEST1X10_G_SPEED		* Chargement de la vitesse au sol
	STD TEST1X10_X_SPEED        * Stockage vitesse X TODO xsp = gsp*cos(angle)
	CMPD #$0000                 * Test orientation
	BLT Hero_MoveUpdatePos_00   * BRANCH si orientation a GAUCHE
	TFR A,B                     * Division par 256
	ADDB TEST1X10_X_POS			* Ajout de la vitesse a la position
	BRA Hero_MoveUpdatePos_01
Hero_MoveUpdatePos_V00
	FCB $00
Hero_MoveUpdatePos_00
	LDD #$0000
	SUBD TEST1X10_X_SPEED		* La vitesse negative est convertie en positive
	TFR A,B                     * Division par 256
	STB Hero_MoveUpdatePos_V00
	LDB TEST1X10_X_POS
	SUBB Hero_MoveUpdatePos_V00 * Ajout de la vitesse a la position
Hero_MoveUpdatePos_01
	CMPB #$50					* Test de butee ecran a droite
	BLE Hero_MoveUpdatePos_02	* Butee non atteinte
	LDB #$50					* Butee atteinte on limite a la butee
Hero_MoveUpdatePos_02
    CMPB #$0C					* Test de la butee ecran a gauche
	BGE Hero_MoveUpdatePos_03	* Butee non atteinte
	LDB #$0C					* Butee atteinte on limite a la butee
Hero_MoveUpdatePos_03
	STB TEST1X10_X_POS			
	LDD #$0000                  * TODO ysp = gsp*-sin(angle)
	STD TEST1X10_Y_SPEED
	TFR A,B                     * division par 256
	ADDB TEST1X10_Y_POS
	STB TEST1X10_Y_POS
	RTS

* TODO : Braking Animation
* Sonic enters his braking animation when you turn around only if his absolute gsp is equal to or more than 4.
* In Sonic 1 and Sonic CD, he then stays in the braking animation until gsp reaches zero or changes sign.
* In the other 3 games, Sonic returns to his walking animation after the braking animation finishes displaying all of its frames.

Compute_Position
	LDA TEST1X10_X_POS
	LSRA
	BCS Compute_Position_01
	STA Compute_Position_02+1
	LDA #$28
	LDB TEST1X10_Y_POS
	DECB
	MUL
	ADDD Compute_Position_02
	STD POS_TEST1X100000
	ADDD #$2000
	STD POS_TEST1X100000+2
	RTS
Compute_Position_01
	STA Compute_Position_02+1
	LDA #$28
	LDB TEST1X10_Y_POS
	DECB
	MUL
	ADDD Compute_Position_02
	ADDD #$2000
	STD POS_TEST1X100000
	SUBD #$1FFF
	STD POS_TEST1X100000+2
	RTS
Compute_Position_02
	FDB $0000
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

DRAW_RAM_DATA_TO_CART
	PSHS U,DP		* sauvegarde des registres pour utilisation du stack blast
	STS >SSAVE
	
	LDS #FINECRANA	* init pointeur au bout de la RAM A video (ecriture remontante)
	LDU #$A000

DRAW_RAM_DATA_TO_CARTA
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
	CMPS #$18DA
	BNE DRAW_RAM_DATA_TO_CARTA
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU B,DP,X,Y
	PSHS Y,X,DP,B

	LDS #FINECRANB	* init pointeur au bout de la RAM B video (ecriture remontante)
	LDU #$C000

DRAW_RAM_DATA_TO_CARTB
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
	CMPS #$38DA
	BNE DRAW_RAM_DATA_TO_CARTB
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU B,DP,X,Y
	PSHS Y,X,DP,B

	LDS  >SSAVE		* rechargement des registres
	PULS U,DP
	RTS
********************************************************************************
* Affiche un computed sprite en xxx cycles
********************************************************************************
TEST1X10_WALK_SPD_LIMIT EQU $0400
TEST1X10_JOG_SPD_LIMIT  EQU $0600
TEST1X10_X_POS
	FCB $50          * position horizontale
TEST1X10_Y_POS
	FCB $C8          * position verticale
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

DRAW_TEST1X100000
	PSHS U,DP
	STS >SSAVE

	LDS POS_TEST1X100000
	LDU #DATA_TEST1X100000_1
	LDY DRAW_EREF_TEST1X100000
	LEAS -2,S
	LDX #$fff0
	STX 17,Y
	STX -2,S
	LDX #$c996
	STX 22,Y
	STX -42,S
	LDX #$f026
	STX 28,Y
	STX -82,S
	LDX #$2b2c
	STX 34,Y
	STX -122,S
	LEAS -160,S
	LDA #$c2
	STA 43,Y
	STA -1,S
	LDA  #$F0
	ANDA -2,S
	ADDA #$0c
	STA -2,S
	LDA #$26
	STA 55,Y
	STA -41,S
	LDA  #$F0
	ANDA -42,S
	ADDA #$02
	STA -42,S
	LDA #$11
	STA 70,Y
	STA -81,S
	LDA  #$F0
	ANDA -82,S
	ADDA #$02
	STA -82,S
	LDA  #$F0
	ANDA -121,S
	ADDA #$0e
	STA -121,S
	LEAS -161,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0e
	STA ,S
	LDA #$db
	STA 107,Y
	STA -40,S
	LDA  #$F0
	ANDA -41,S
	ADDA #$0b
	STA -41,S
	LDA #$d6
	STA 122,Y
	STA -80,S
	LDA  #$F0
	ANDA -81,S
	ADDA #$0b
	STA -81,S
	LDA  #$0F
	ANDA -119,S
	ADDA #$e0
	STA -119,S
	LDX #$b662
	STX 148,Y
	STX -121,S
	LEAS -159,S
	LDA  #$0F
	ANDA ,S
	ADDA #$e0
	STA ,S
	LDX #$6b21
	STX 166,Y
	STX -2,S
	LDA  #$0F
	ANDA -40,S
	ADDA #$d0
	STA -40,S
	LDX #$2b11
	STX 181,Y
	STX -42,S
	LDA  #$0F
	ANDA -80,S
	ADDA #$a0
	STA -80,S
	LDA #$11
	STA 196,Y
	STA -81,S
	LDA  #$F0
	ANDA -82,S
	ADDA #$00
	STA -82,S
	LDA #$d2
	STA 211,Y
	STA -121,S
	LDA  #$F0
	ANDA -122,S
	ADDA #$08
	STA -122,S
	LEAS -160,S
	LDA #$d0
	STA 230,Y
	STA -1,S
	LDA  #$F0
	ANDA -2,S
	ADDA #$05
	STA -2,S
	LDA #$ec
	STA 242,Y
	STA -41,S
	LDA  #$F0
	ANDA -42,S
	ADDA #$08
	STA -42,S
	LDA #$c3
	STA 257,Y
	STA -81,S
	LDA  #$F0
	ANDA -82,S
	ADDA #$0c
	STA -82,S
	LDA #$e0
	STA 272,Y
	STA -121,S
	LEAS -159,S
	LDX #$cede
	STX 282,Y
	STX -2,S
	LDA  #$F0
	ANDA -3,S
	ADDA #$0c
	STA -3,S
	LDX #$5eed
	STX 295,Y
	STX -42,S
	LDA  #$F0
	ANDA -43,S
	ADDA #$08
	STA -43,S
	LEAS -80,S
	LDA #$c3
	LDX #$38da
	PSHS X,A
	LEAS -37,S
	LDA #$01
	LDX #$38aa
	PSHS X,A
	LDA  #$0F
	ANDA -38,S
	ADDA #$a0
	STA -38,S
	LDX #$611a
	STX 341,Y
	STX -40,S
	LDX #$007a
	STX 347,Y
	STX -80,S
	LDA  #$0F
	ANDA -118,S
	ADDA #$d0
	STA -118,S
	LDX #$0077
	STX 363,Y
	STX -120,S
	LEAS -157,S
	LDA #$a0
	LDX #$77ed
	PSHS X,A
	LEAS -37,S
	LDA #$7a
	LDX #$77ee
	PSHS X,A
	LEAS -37,S
	LDA #$77
	LDX #$77dd
	PSHS X,A
	LEAS -37,S
	LDA #$74
	LDX #$44aa
	PSHS X,A
	LDA  #$0F
	ANDA -38,S
	ADDA #$a0
	STA -38,S
	LDX #$7477
	STX 420,Y
	STX -40,S
	LDX #$a773
	STX 426,Y
	STX -80,S
	LDX #$e7c3
	STX 432,Y
	STX -120,S
	LEAS -158,S
	LDX #$d7d3
	STX 442,Y
	STX -2,S
	LDX #$78ee
	STX 447,Y
	STX -41,S
	LDA  #$0F
	ANDA -42,S
	ADDA #$d0
	STA -42,S
	LDX #$7ddd
	STX 463,Y
	STX -81,S
	LDA  #$0F
	ANDA -82,S
	ADDA #$d0
	STA -82,S
	LDX #$a7aa
	STX 479,Y
	STX -121,S
	LEAS -161,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0a
	STA ,S

	LDS POS_TEST1X100000+2
	LDU #DATA_TEST1X100000_2

	LDY DRAW_EREF_TEST1X100000
	LEAS -2,S
	LDA #$00
	LDX #$ff0f
	PSHS X,A
	LEAS -37,S
	LDA #$cf
	LDX #$99cf
	PSHS X,A
	LDX #$39cf
	STX 523,Y
	STX -39,S
	LDA  #$F0
	ANDA -40,S
	ADDA #$0c
	STA -40,S
	LDA  #$0F
	ANDA -78,S
	ADDA #$c0
	STA -78,S
	LDA #$01
	STA 548,Y
	STA -79,S
	LDA  #$0F
	ANDA -118,S
	ADDA #$00
	STA -118,S
	LDA #$62
	STA 563,Y
	STA -119,S
	LEAS -158,S
	LDA  #$0F
	ANDA ,S
	ADDA #$b0
	STA ,S
	LDA #$b0
	STA 580,Y
	STA -1,S
	LDA  #$0F
	ANDA -40,S
	ADDA #$60
	STA -40,S
	LDA #$6b
	STA 594,Y
	STA -41,S
	LDA  #$0F
	ANDA -81,S
	ADDA #$d0
	STA -81,S
	LDA  #$0F
	ANDA -121,S
	ADDA #$d0
	STA -121,S
	LEAS -161,S
	LDA  #$0F
	ANDA ,S
	ADDA #$d0
	STA ,S
	LDA  #$0F
	ANDA -39,S
	ADDA #$b0
	STA -39,S
	LDA  #$0F
	ANDA -40,S
	ADDA #$e0
	STA -40,S
	LDA  #$0F
	ANDA -79,S
	ADDA #$60
	STA -79,S
	LDA  #$0F
	ANDA -80,S
	ADDA #$e0
	STA -80,S
	LDX #$0ebd
	STX 672,Y
	STX -120,S
	LEAS -158,S
	LDX #$dd6f
	STX 682,Y
	STX -2,S
	LDX #$8c18
	STX 687,Y
	STX -42,S
	LDX #$35e5
	STX 693,Y
	STX -82,S
	LDX #$3383
	STX 699,Y
	STX -122,S
	LEAS -160,S
	LDX #$333a
	STX 709,Y
	STX -2,S
	LDA  #$0F
	ANDA -41,S
	ADDA #$e0
	STA -41,S
	LDA #$58
	STA 723,Y
	STA -42,S
	LDX #$f0dd
	STX 729,Y
	STX -82,S
	LDA  #$0F
	ANDA -120,S
	ADDA #$a0
	STA -120,S
	LDX #$88ee
	STX 745,Y
	STX -122,S
	LEAS -160,S
	LDX #$330e
	STX 755,Y
	STX -2,S
	LDX #$33ee
	STX 760,Y
	STX -42,S
	LDX #$11ee
	STX 766,Y
	STX -82,S
	LDA  #$F0
	ANDA -83,S
	ADDA #$00
	STA -83,S
	LDX #$17de
	STX 782,Y
	STX -122,S
	LDA  #$F0
	ANDA -123,S
	ADDA #$00
	STA -123,S
	LEAS -160,S
	LDX #$11ae
	STX 802,Y
	STX -2,S
	STX 804,Y
	STX -42,S
	LEAS -79,S
	LDA #$11
	LDX #$aedd
	PSHS X,A
	LDA  #$0F
	ANDA -38,S
	ADDA #$e0
	STA -38,S
	LDX #$11ad
	STX 830,Y
	STX -40,S
	LDA  #$0F
	ANDA -78,S
	ADDA #$a0
	STA -78,S
	LDX #$21ad
	STX 846,Y
	STX -80,S
	LDX #$a1ad
	STX 852,Y
	STX -120,S
	LEAS -158,S
	LDX #$7aad
	STX 862,Y
	STX -2,S
	LDX #$44ea
	STX 867,Y
	STX -42,S
	LDX #$44ed
	STX 873,Y
	STX -82,S
	LDX #$74ee
	STX 879,Y
	STX -122,S
	LEAS -160,S
	LDX #$77dd
	STX 889,Y
	STX -2,S
	LDA  #$0F
	ANDA -40,S
	ADDA #$d0
	STA -40,S
	LDA #$aa
	STA 903,Y
	STA -41,S
	LDA  #$F0
	ANDA -42,S
	ADDA #$07
	STA -42,S
	LDA #$77
	STA 918,Y
	STA -81,S
	LDA #$aa
	STA 923,Y
	STA -121,S

	LDS  >SSAVE
	PULS U,DP
	RTS

DATA_TEST1X100000_2
DATA_TEST1X100000_1
POS_TEST1X100000
	FDB $1F40
	FDB $3F40

DRAW_EREF_TEST1X100000
	FDB E1DRAW_TEST1X100000
	FDB E2DRAW_TEST1X100000

E1DRAW_TEST1X100000
	PSHS U,DP
	STS >SSAVE

	LDS E1POS_TEST1X100000
	LDU #E1DATA_TEST1X100000_1
	LEAS -2,S
	LDX #$fff0
	STX -2,S
	LDX #$c996
	STX -42,S
	LDX #$f026
	STX -82,S
	LDX #$2b2c
	STX -122,S
	LEAS -160,S
	LDA #$c2
	STA -1,S
	LDA  #$F0
	ANDA -2,S
	ADDA #$0c
	STA -2,S
	LDA #$26
	STA -41,S
	LDA  #$F0
	ANDA -42,S
	ADDA #$02
	STA -42,S
	LDA #$11
	STA -81,S
	LDA  #$F0
	ANDA -82,S
	ADDA #$02
	STA -82,S
	LDA  #$F0
	ANDA -121,S
	ADDA #$0e
	STA -121,S
	LEAS -161,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0e
	STA ,S
	LDA #$db
	STA -40,S
	LDA  #$F0
	ANDA -41,S
	ADDA #$0b
	STA -41,S
	LDA #$d6
	STA -80,S
	LDA  #$F0
	ANDA -81,S
	ADDA #$0b
	STA -81,S
	LDA  #$0F
	ANDA -119,S
	ADDA #$e0
	STA -119,S
	LDX #$b662
	STX -121,S
	LEAS -159,S
	LDA  #$0F
	ANDA ,S
	ADDA #$e0
	STA ,S
	LDX #$6b21
	STX -2,S
	LDA  #$0F
	ANDA -40,S
	ADDA #$d0
	STA -40,S
	LDX #$2b11
	STX -42,S
	LDA  #$0F
	ANDA -80,S
	ADDA #$a0
	STA -80,S
	LDA #$11
	STA -81,S
	LDA  #$F0
	ANDA -82,S
	ADDA #$00
	STA -82,S
	LDA #$d2
	STA -121,S
	LDA  #$F0
	ANDA -122,S
	ADDA #$08
	STA -122,S
	LEAS -160,S
	LDA #$d0
	STA -1,S
	LDA  #$F0
	ANDA -2,S
	ADDA #$05
	STA -2,S
	LDA #$ec
	STA -41,S
	LDA  #$F0
	ANDA -42,S
	ADDA #$08
	STA -42,S
	LDA #$c3
	STA -81,S
	LDA  #$F0
	ANDA -82,S
	ADDA #$0c
	STA -82,S
	LDA #$e0
	STA -121,S
	LEAS -159,S
	LDX #$cede
	STX -2,S
	LDA  #$F0
	ANDA -3,S
	ADDA #$0c
	STA -3,S
	LDX #$5eed
	STX -42,S
	LDA  #$F0
	ANDA -43,S
	ADDA #$08
	STA -43,S
	LEAS -80,S
	LDA #$c3
	LDX #$38da
	PSHS X,A
	LEAS -37,S
	LDA #$01
	LDX #$38aa
	PSHS X,A
	LDA  #$0F
	ANDA -38,S
	ADDA #$a0
	STA -38,S
	LDX #$611a
	STX -40,S
	LDX #$007a
	STX -80,S
	LDA  #$0F
	ANDA -118,S
	ADDA #$d0
	STA -118,S
	LDX #$0077
	STX -120,S
	LEAS -157,S
	LDA #$a0
	LDX #$77ed
	PSHS X,A
	LEAS -37,S
	LDA #$7a
	LDX #$77ee
	PSHS X,A
	LEAS -37,S
	LDA #$77
	LDX #$77dd
	PSHS X,A
	LEAS -37,S
	LDA #$74
	LDX #$44aa
	PSHS X,A
	LDA  #$0F
	ANDA -38,S
	ADDA #$a0
	STA -38,S
	LDX #$7477
	STX -40,S
	LDX #$a773
	STX -80,S
	LDX #$e7c3
	STX -120,S
	LEAS -158,S
	LDX #$d7d3
	STX -2,S
	LDX #$78ee
	STX -41,S
	LDA  #$0F
	ANDA -42,S
	ADDA #$d0
	STA -42,S
	LDX #$7ddd
	STX -81,S
	LDA  #$0F
	ANDA -82,S
	ADDA #$d0
	STA -82,S
	LDX #$a7aa
	STX -121,S
	LEAS -161,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0a
	STA ,S

	LDS E1POS_TEST1X100000+2
	LDU #E1DATA_TEST1X100000_2

	LEAS -2,S
	LDA #$00
	LDX #$ff0f
	PSHS X,A
	LEAS -37,S
	LDA #$cf
	LDX #$99cf
	PSHS X,A
	LDX #$39cf
	STX -39,S
	LDA  #$F0
	ANDA -40,S
	ADDA #$0c
	STA -40,S
	LDA  #$0F
	ANDA -78,S
	ADDA #$c0
	STA -78,S
	LDA #$01
	STA -79,S
	LDA  #$0F
	ANDA -118,S
	ADDA #$00
	STA -118,S
	LDA #$62
	STA -119,S
	LEAS -158,S
	LDA  #$0F
	ANDA ,S
	ADDA #$b0
	STA ,S
	LDA #$b0
	STA -1,S
	LDA  #$0F
	ANDA -40,S
	ADDA #$60
	STA -40,S
	LDA #$6b
	STA -41,S
	LDA  #$0F
	ANDA -81,S
	ADDA #$d0
	STA -81,S
	LDA  #$0F
	ANDA -121,S
	ADDA #$d0
	STA -121,S
	LEAS -161,S
	LDA  #$0F
	ANDA ,S
	ADDA #$d0
	STA ,S
	LDA  #$0F
	ANDA -39,S
	ADDA #$b0
	STA -39,S
	LDA  #$0F
	ANDA -40,S
	ADDA #$e0
	STA -40,S
	LDA  #$0F
	ANDA -79,S
	ADDA #$60
	STA -79,S
	LDA  #$0F
	ANDA -80,S
	ADDA #$e0
	STA -80,S
	LDX #$0ebd
	STX -120,S
	LEAS -158,S
	LDX #$dd6f
	STX -2,S
	LDX #$8c18
	STX -42,S
	LDX #$35e5
	STX -82,S
	LDX #$3383
	STX -122,S
	LEAS -160,S
	LDX #$333a
	STX -2,S
	LDA  #$0F
	ANDA -41,S
	ADDA #$e0
	STA -41,S
	LDA #$58
	STA -42,S
	LDX #$f0dd
	STX -82,S
	LDA  #$0F
	ANDA -120,S
	ADDA #$a0
	STA -120,S
	LDX #$88ee
	STX -122,S
	LEAS -160,S
	LDX #$330e
	STX -2,S
	LDX #$33ee
	STX -42,S
	LDX #$11ee
	STX -82,S
	LDA  #$F0
	ANDA -83,S
	ADDA #$00
	STA -83,S
	LDX #$17de
	STX -122,S
	LDA  #$F0
	ANDA -123,S
	ADDA #$00
	STA -123,S
	LEAS -160,S
	LDX #$11ae
	STX -2,S
	STX -42,S
	LEAS -79,S
	LDA #$11
	LDX #$aedd
	PSHS X,A
	LDA  #$0F
	ANDA -38,S
	ADDA #$e0
	STA -38,S
	LDX #$11ad
	STX -40,S
	LDA  #$0F
	ANDA -78,S
	ADDA #$a0
	STA -78,S
	LDX #$21ad
	STX -80,S
	LDX #$a1ad
	STX -120,S
	LEAS -158,S
	LDX #$7aad
	STX -2,S
	LDX #$44ea
	STX -42,S
	LDX #$44ed
	STX -82,S
	LDX #$74ee
	STX -122,S
	LEAS -160,S
	LDX #$77dd
	STX -2,S
	LDA  #$0F
	ANDA -40,S
	ADDA #$d0
	STA -40,S
	LDA #$aa
	STA -41,S
	LDA  #$F0
	ANDA -42,S
	ADDA #$07
	STA -42,S
	LDA #$77
	STA -81,S
	LDA #$aa
	STA -121,S

	LDS  >SSAVE
	PULS U,DP
	RTS

E1DATA_TEST1X100000_2
E1DATA_TEST1X100000_1
E1POS_TEST1X100000
	FDB $1F40
	FDB $3F40

E2DRAW_TEST1X100000
	PSHS U,DP
	STS >SSAVE

	LDS E2POS_TEST1X100000
	LDU #E2DATA_TEST1X100000_1
	LEAS -2,S
	LDX #$fff0
	STX -2,S
	LDX #$c996
	STX -42,S
	LDX #$f026
	STX -82,S
	LDX #$2b2c
	STX -122,S
	LEAS -160,S
	LDA #$c2
	STA -1,S
	LDA  #$F0
	ANDA -2,S
	ADDA #$0c
	STA -2,S
	LDA #$26
	STA -41,S
	LDA  #$F0
	ANDA -42,S
	ADDA #$02
	STA -42,S
	LDA #$11
	STA -81,S
	LDA  #$F0
	ANDA -82,S
	ADDA #$02
	STA -82,S
	LDA  #$F0
	ANDA -121,S
	ADDA #$0e
	STA -121,S
	LEAS -161,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0e
	STA ,S
	LDA #$db
	STA -40,S
	LDA  #$F0
	ANDA -41,S
	ADDA #$0b
	STA -41,S
	LDA #$d6
	STA -80,S
	LDA  #$F0
	ANDA -81,S
	ADDA #$0b
	STA -81,S
	LDA  #$0F
	ANDA -119,S
	ADDA #$e0
	STA -119,S
	LDX #$b662
	STX -121,S
	LEAS -159,S
	LDA  #$0F
	ANDA ,S
	ADDA #$e0
	STA ,S
	LDX #$6b21
	STX -2,S
	LDA  #$0F
	ANDA -40,S
	ADDA #$d0
	STA -40,S
	LDX #$2b11
	STX -42,S
	LDA  #$0F
	ANDA -80,S
	ADDA #$a0
	STA -80,S
	LDA #$11
	STA -81,S
	LDA  #$F0
	ANDA -82,S
	ADDA #$00
	STA -82,S
	LDA #$d2
	STA -121,S
	LDA  #$F0
	ANDA -122,S
	ADDA #$08
	STA -122,S
	LEAS -160,S
	LDA #$d0
	STA -1,S
	LDA  #$F0
	ANDA -2,S
	ADDA #$05
	STA -2,S
	LDA #$ec
	STA -41,S
	LDA  #$F0
	ANDA -42,S
	ADDA #$08
	STA -42,S
	LDA #$c3
	STA -81,S
	LDA  #$F0
	ANDA -82,S
	ADDA #$0c
	STA -82,S
	LDA #$e0
	STA -121,S
	LEAS -159,S
	LDX #$cede
	STX -2,S
	LDA  #$F0
	ANDA -3,S
	ADDA #$0c
	STA -3,S
	LDX #$5eed
	STX -42,S
	LDA  #$F0
	ANDA -43,S
	ADDA #$08
	STA -43,S
	LEAS -80,S
	LDA #$c3
	LDX #$38da
	PSHS X,A
	LEAS -37,S
	LDA #$01
	LDX #$38aa
	PSHS X,A
	LDA  #$0F
	ANDA -38,S
	ADDA #$a0
	STA -38,S
	LDX #$611a
	STX -40,S
	LDX #$007a
	STX -80,S
	LDA  #$0F
	ANDA -118,S
	ADDA #$d0
	STA -118,S
	LDX #$0077
	STX -120,S
	LEAS -157,S
	LDA #$a0
	LDX #$77ed
	PSHS X,A
	LEAS -37,S
	LDA #$7a
	LDX #$77ee
	PSHS X,A
	LEAS -37,S
	LDA #$77
	LDX #$77dd
	PSHS X,A
	LEAS -37,S
	LDA #$74
	LDX #$44aa
	PSHS X,A
	LDA  #$0F
	ANDA -38,S
	ADDA #$a0
	STA -38,S
	LDX #$7477
	STX -40,S
	LDX #$a773
	STX -80,S
	LDX #$e7c3
	STX -120,S
	LEAS -158,S
	LDX #$d7d3
	STX -2,S
	LDX #$78ee
	STX -41,S
	LDA  #$0F
	ANDA -42,S
	ADDA #$d0
	STA -42,S
	LDX #$7ddd
	STX -81,S
	LDA  #$0F
	ANDA -82,S
	ADDA #$d0
	STA -82,S
	LDX #$a7aa
	STX -121,S
	LEAS -161,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0a
	STA ,S

	LDS E2POS_TEST1X100000+2
	LDU #E2DATA_TEST1X100000_2

	LEAS -2,S
	LDA #$00
	LDX #$ff0f
	PSHS X,A
	LEAS -37,S
	LDA #$cf
	LDX #$99cf
	PSHS X,A
	LDX #$39cf
	STX -39,S
	LDA  #$F0
	ANDA -40,S
	ADDA #$0c
	STA -40,S
	LDA  #$0F
	ANDA -78,S
	ADDA #$c0
	STA -78,S
	LDA #$01
	STA -79,S
	LDA  #$0F
	ANDA -118,S
	ADDA #$00
	STA -118,S
	LDA #$62
	STA -119,S
	LEAS -158,S
	LDA  #$0F
	ANDA ,S
	ADDA #$b0
	STA ,S
	LDA #$b0
	STA -1,S
	LDA  #$0F
	ANDA -40,S
	ADDA #$60
	STA -40,S
	LDA #$6b
	STA -41,S
	LDA  #$0F
	ANDA -81,S
	ADDA #$d0
	STA -81,S
	LDA  #$0F
	ANDA -121,S
	ADDA #$d0
	STA -121,S
	LEAS -161,S
	LDA  #$0F
	ANDA ,S
	ADDA #$d0
	STA ,S
	LDA  #$0F
	ANDA -39,S
	ADDA #$b0
	STA -39,S
	LDA  #$0F
	ANDA -40,S
	ADDA #$e0
	STA -40,S
	LDA  #$0F
	ANDA -79,S
	ADDA #$60
	STA -79,S
	LDA  #$0F
	ANDA -80,S
	ADDA #$e0
	STA -80,S
	LDX #$0ebd
	STX -120,S
	LEAS -158,S
	LDX #$dd6f
	STX -2,S
	LDX #$8c18
	STX -42,S
	LDX #$35e5
	STX -82,S
	LDX #$3383
	STX -122,S
	LEAS -160,S
	LDX #$333a
	STX -2,S
	LDA  #$0F
	ANDA -41,S
	ADDA #$e0
	STA -41,S
	LDA #$58
	STA -42,S
	LDX #$f0dd
	STX -82,S
	LDA  #$0F
	ANDA -120,S
	ADDA #$a0
	STA -120,S
	LDX #$88ee
	STX -122,S
	LEAS -160,S
	LDX #$330e
	STX -2,S
	LDX #$33ee
	STX -42,S
	LDX #$11ee
	STX -82,S
	LDA  #$F0
	ANDA -83,S
	ADDA #$00
	STA -83,S
	LDX #$17de
	STX -122,S
	LDA  #$F0
	ANDA -123,S
	ADDA #$00
	STA -123,S
	LEAS -160,S
	LDX #$11ae
	STX -2,S
	STX -42,S
	LEAS -79,S
	LDA #$11
	LDX #$aedd
	PSHS X,A
	LDA  #$0F
	ANDA -38,S
	ADDA #$e0
	STA -38,S
	LDX #$11ad
	STX -40,S
	LDA  #$0F
	ANDA -78,S
	ADDA #$a0
	STA -78,S
	LDX #$21ad
	STX -80,S
	LDX #$a1ad
	STX -120,S
	LEAS -158,S
	LDX #$7aad
	STX -2,S
	LDX #$44ea
	STX -42,S
	LDX #$44ed
	STX -82,S
	LDX #$74ee
	STX -122,S
	LEAS -160,S
	LDX #$77dd
	STX -2,S
	LDA  #$0F
	ANDA -40,S
	ADDA #$d0
	STA -40,S
	LDA #$aa
	STA -41,S
	LDA  #$F0
	ANDA -42,S
	ADDA #$07
	STA -42,S
	LDA #$77
	STA -81,S
	LDA #$aa
	STA -121,S

	LDS  >SSAVE
	PULS U,DP
	RTS

E2DATA_TEST1X100000_2
E2DATA_TEST1X100000_1
E2POS_TEST1X100000
	FDB $1F40
	FDB $3F40

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
