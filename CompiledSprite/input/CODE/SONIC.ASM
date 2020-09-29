********************************************************************************
* OBJET : SONIC
*
********************************************************************************

SONIC_ACCELERATION			EQU $000C	* 000C constante acceleration 0.046875 = 12/256
SONIC_DECELERATION			EQU $0080	* 0080 constante deceleration 0.5 = 128/256
SONIC_FRICTION				EQU $000C	* 000C constante de friction 0.046875 = 12/256
SONIC_AIR_X_ACCELERATION	EQU $0018	* 0018 constante air acceleration 0.09375 = 24/256
SONIC_AIR_Y_GRAVITY			EQU $0038	* 0038 constante gravite 0.21875 = 56/256
SONIC_AIR_X_DRAG			EQU $00F8	* 00F8 constante air drag 0.96875 = 248/256
SONIC_AIR_JUMP_VEL			EQU $F980	* F980 constante air jump start velocity -6.5 = -1664/256
SONIC_AIR_JUMP_CUT			EQU $FC00	* FC constante air jump cut -4 = -1024/256
SONIC_X_TOP_SPEED			EQU $0600	* 0600 vitesse X maximum autorisee 6 = 1536/256
SONIC_X_NEG_TOP_SPEED		EQU $FA00	* FA00 vitesse X maximum autorisee -6 = -1536/256
SONIC_Y_TOP_SPEED			EQU $1000	* 0010 vitesse Y maximum autorisee 16 = 4096/256
SONIC_JOG_SPD_LIMIT			EQU $0600	* 0600 - 0400
SONIC_JOG_NEG_SPD_LIMIT		EQU $FA00	* FA00 - FC00

SONIC_Move
* si bouton jump: Maj ysp Jump start & charge anim & jump en cours
	LDD JOY_BTN_STATUS
	CMPD #$4000
	BNE SONIC_alreadyJumping	* si saut deja en cours on passe le code de demarrage de saut
	LDB SONIC_ISJUMPING
	BNE SONIC_alreadyJumping		* si un saut n'est pas en cours: on est au sol
	INC SONIC_ISJUMPING		* set flag is jumping a 1
	LDD SONIC_G_SPEED		* charge la vitesse (negative ou positive)
	BLT SONIC_JumpLeft      * si vitesse negative on branche pour animation gauche
	LDX #SONIC_JUMP_R        * Charge animation Saut Droite
	BRA SONIC_Jump
SONIC_JumpLeft	
	LDX #SONIC_JUMP_L        * Charge animation Saut Gauche
SONIC_Jump
	STX SONIC_ANIMATION_ADR	* Sauvegarde animation
	STD SONIC_X_SPEED		* Initialisation de la vitesse X
	LDD SONIC_AIR_JUMP_VEL	* Initialisation de la vitesse Y
	STD SONIC_Y_SPEED
	LDD #$0000
	STD SONIC_X_SPS
	STD SONIC_Y_SPS

SONIC_alreadyJumping
* Maj xsp en fonction de G ou D joystick
	LDB SONIC_ISJUMPING
	LBEQ SONIC_OnGround		* si un saut n'est pas en cours: on est au sol
	LDA JOY_DIR_STATUS
	CMPA #JOY_D
	BEQ SONIC_JumpAccelD
	CMPA #JOY_G
	BEQ SONIC_JumpAccelG
	LDD SONIC_X_SPEED
	BRA SONIC_JumpCapTopXSpeed
SONIC_JumpAccelD
	LDD SONIC_X_SPEED
	ADDD SONIC_AIR_X_ACCELERATION
	BRA SONIC_JumpCapTopXSpeed
SONIC_JumpAccelG
	LDD SONIC_X_SPEED
	SUBD SONIC_AIR_X_ACCELERATION

SONIC_JumpCapTopXSpeed
* Top xsp
	CMPD SONIC_X_TOP_SPEED
	BLE SONIC_JumpAirDrag
	LDD SONIC_X_TOP_SPEED
	
SONIC_JumpAirDrag	
* Maj xsp Air drag
	STD SONIC_X_SPEED
	LDD SONIC_Y_SPEED	* si ysp (ysp < 0 && ysp > -$0400) on applique le air drag
	BGE SONIC_JumpCut
	CMPD #$FC00
	BLE SONIC_JumpCut
	LDD SONIC_X_SPEED
	BGE SONIC_JumpAirDragPositive
	LDB #$C3				* ADD
	STB SONIC_AirDragSUB
	LDD #$0000
	SUBD SONIC_X_SPEED
	BRA SONIC_JumpAirDragCommon
SONIC_JumpAirDragPositive
	LDB #$83				* SUB
	STB SONIC_AirDragSUB
	LDD SONIC_X_SPEED
SONIC_JumpAirDragCommon	
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
	STB SONIC_AirDragSUB+2	* STB suffisant tant que la vitesse max est <= #$2000 sinon utiliser STD SONIC_AirDragSUB+1
	LDD SONIC_X_SPEED
SONIC_AirDragSUB
	SUBD #$0000
	STD SONIC_X_SPEED

SONIC_JumpCut
* Maj ysp Jump cut
	LDD SONIC_Y_SPEED
	TST JOY_BTN_STATUS	* si le bouton n'est plus appuye
	BNE SONIC_JumpGravity
	CMPD SONIC_AIR_JUMP_CUT	* et si ysp < SONIC_AIR_JUMP_CUT
	BGE SONIC_JumpGravity
	LDD SONIC_AIR_JUMP_CUT	* ysp est limite a SONIC_AIR_JUMP_CUT

SONIC_JumpGravity
* Maj ysp with gravity
	ADDD SONIC_AIR_Y_GRAVITY	* ajout de la gravite a la vitesse ysp (ce qui fait retomber le hero)

SONIC_JumpCapTopYSpeed
* Top ysp
	CMPD SONIC_Y_TOP_SPEED	* si la vitesse positive Y (en chute) dépasse la limite
	BLE SONIC_JumpPosUpdate
	LDD SONIC_Y_TOP_SPEED	* on repositionne la vitesse Y a la limite

SONIC_JumpPosUpdate
	STD SONIC_Y_SPEED
	
* Maj X et Y pos
	JMP SONIC_MoveUpdatePosJump * remplacement de JSR RTS par JMP (Gain: 9c 1o)

* Gestion a Terre
********************************

SONIC_OnGround
	LDA JOY_DIR_STATUS
	CMPA #JOY_G
	BNE SONIC_NotLeft
	BRA SONIC_MoveLeft

SONIC_NotLeft                   * XREF: SONIC_Move
	CMPA #JOY_D
	BNE SONIC_NotLeftOrRight
	JMP SONIC_MoveRight

SONIC_NotLeftOrRight            * XREF: SONIC_NotLeft
	LDD SONIC_G_SPEED
	CMPD #$0000
	LBEQ SONIC_MoveUpdatePos  * Si la vitesse est deja nulle on passe
	BLT SONIC_NotLeftOrRight_00 * se deplace a gauche
	SUBD SONIC_FRICTION     * se deplace a droite on soustrait la friction a la vitesse
	CMPD #$0000	
	BGT SONIC_NotLeftOrRight_01 * si on passe en dessous de 0 on repositionne a 0
	LDD #$0000
	STD SONIC_G_SPEED
	STD SONIC_X_SPS
	LDX #SONIC_IDLE_R        * Charge animation IDLE R
	STX SONIC_ANIMATION_ADR	* Sauvegarde animation

	JMP SONIC_MoveUpdatePos
SONIC_NotLeftOrRight_01	       
	CMPD #SONIC_JOG_SPD_LIMIT
	BGE SONIC_NotLeftOrRight_02
	STD SONIC_G_SPEED
	LDX #SONIC_WALK_R        * Charge animation WALK R
	STX SONIC_ANIMATION_ADR	* Sauvegarde animation

	BRA SONIC_NotLeftOrRight_03
SONIC_NotLeftOrRight_02	
	STD SONIC_G_SPEED
SONIC_NotLeftOrRight_03
	JMP SONIC_MoveUpdatePos
SONIC_NotLeftOrRight_00	
	ADDD SONIC_FRICTION     * se deplace a gauche on ajoute la friction a la vitesse negative
	BCC SONIC_NotLeftOrRight_11 * si on passe au dessus de 0 on repositionne a 0. Remarque le passage de FFFF a 0000 declenche un depassement contrairement au passage de 0001 a 1 (cas droite)
	LDD #$0000
	STD SONIC_G_SPEED
	LDX #SONIC_IDLE_L        * Charge animation IDLE L
	STX SONIC_ANIMATION_ADR	* Sauvegarde animation

	JMP SONIC_MoveUpdatePos
SONIC_NotLeftOrRight_11	       
	CMPD #SONIC_JOG_NEG_SPD_LIMIT
	BLE SONIC_NotLeftOrRight_12
	STD SONIC_G_SPEED
	LDX #SONIC_WALK_L        * Charge animation WALK L
	STX SONIC_ANIMATION_ADR	* Sauvegarde animation

	BRA SONIC_NotLeftOrRight_13
SONIC_NotLeftOrRight_12	
	STD SONIC_G_SPEED
SONIC_NotLeftOrRight_13
	JMP SONIC_MoveUpdatePos

SONIC_MoveLeft                  	* XREF: SONIC_Move
	LDD SONIC_G_SPEED       	* Chargement de la vitesse au sol
	CMPD #$0000                	* Test orientation
	BLE SONIC_MoveLeft_00       	* BRANCH si orientation a GAUCHE
	SUBD SONIC_DECELERATION 	* orientation a DROITE on reduit la vitesse
	BCC SONIC_MoveLeft_03       	* BRANCH si orientation toujours a DROITE
	LDD #$0000				   	
	SUBD SONIC_DECELERATION 	* si la vitesse est devenue negative on la force a la valeur de -DECELERATION
SONIC_MoveLeft_03	           	
	STD SONIC_G_SPEED       	* On stocke la vitesse
	JMP SONIC_MoveUpdatePos	   	* Mise a jour des coordonnees
SONIC_MoveLeft_00		       	* Orientation a GAUCHE 
	CMPD SONIC_X_NEG_TOP_SPEED	* Comparaison avec la vitesse maximum
	BEQ SONIC_MoveUpdatePos     	* vitesse au sol deja au maximum - Mise a jour des coordonnees
	SUBD SONIC_ACCELERATION 	* acceleration
	CMPD SONIC_X_NEG_TOP_SPEED	* Comparaison avec la vitesse maximum
	BGT SONIC_MoveLeft_01       	* BRANCH si vitesse inferieur au maximum
	LDX #SONIC_RUN_L        * Charge animation RUN L
	STX SONIC_ANIMATION_ADR	* Sauvegarde animation

	LDD SONIC_X_NEG_TOP_SPEED 	* Limitation de la vitesse au maximum
	STD SONIC_G_SPEED       	* Enregistrement de la vitesse
	JMP SONIC_MoveUpdatePos    	* Mise a jour des coordonnees
SONIC_MoveLeft_01               	
	STD SONIC_G_SPEED       	* Enregistrement de la vitesse
	LDX #SONIC_WALK_L        * Charge animation WALK L
	STX SONIC_ANIMATION_ADR	* Sauvegarde animation

	JMP SONIC_MoveUpdatePos

SONIC_MoveRight                  * XREF: SONIC_NotLeft
	LDD SONIC_G_SPEED        * Chargement de la vitesse au sol
	CMPD #$0000                 * Test orientation
	BGE SONIC_MoveRight_00       * BRANCH si orientation a DROITE
	ADDD SONIC_DECELERATION 	* orientation a GAUCHE on reduit la vitesse
	BCC SONIC_MoveRight_03       * BRANCH si orientation toujours a GAUCHE
	LDD SONIC_DECELERATION   * si la vitesse est devenue positive on la force a la valeur de DECELERATION
SONIC_MoveRight_03	
	STD SONIC_G_SPEED        * On stocke la vitesse
	JMP SONIC_MoveUpdatePos		* Mise a jour des coordonnees
SONIC_MoveRight_00		      	* Orientation a DROITE 
	CMPD SONIC_X_TOP_SPEED		* Comparaison avec la vitesse maximum
	BEQ SONIC_MoveUpdatePos      * vitesse au sol deja au maximum - Mise a jour des coordonnees
	ADDD SONIC_ACCELERATION 	* acceleration
	CMPD SONIC_X_TOP_SPEED		* Comparaison avec la vitesse maximum
	BLT SONIC_MoveRight_01       * BRANCH si vitesse inferieur au maximum
	LDX #SONIC_RUN_R			* Charge animation RUN R
	STX SONIC_ANIMATION_ADR	* Sauvegarde animation

	LDD SONIC_X_TOP_SPEED		* Limitation de la vitesse au maximum
	STD SONIC_G_SPEED		* Enregistrement de la vitesse
	JMP SONIC_MoveUpdatePos		* Mise a jour des coordonnees
SONIC_MoveRight_01
	STD SONIC_G_SPEED				* Enregistrement de la vitesse
	LDX #SONIC_WALK_R        		* Charge animation WALK R
	STX SONIC_ANIMATION_ADR			* Sauvegarde animation

*******************************************************************
* Mise a jour de la vitesse X et Y a partir de la vitesse au sol  *
*******************************************************************

SONIC_MoveUpdatePos
	LDD SONIC_G_SPEED				* Chargement de la vitesse au sol
* TODO MAJ SONIC_X_SPEED : xsp = gsp*cos(angle)
* TODO MAJ SONIC_Y_SPEED : ysp = gsp*-sin(angle)
	STD SONIC_X_SPEED
	CLR SONIC_Y_SPEED

*******************************************************************
* Mise a jour de la position X et Y a partir de la vitesse X et Y *
*******************************************************************

* Coordonnees X
***************

SONIC_MoveUpdatePosJump
	LDD SONIC_X_SPEED
	BGE SONIC_MoveUpdateXPos_00   	* BRANCH si orientation vers la DROITE
	LDA #$C0						* code de l'instruction SUBB
	STA SONIC_MoveUpdateXPos_00C		* Auto-modification de code on positionne SUBB
	LDD #$0000
	SUBD SONIC_X_SPEED				* La vitesse negative est convertie en positive 
	BRA SONIC_MoveUpdateXPos_00A
SONIC_MoveUpdateXPos_00
	LDA #$CB						* code de l'instruction ADDB
	STA SONIC_MoveUpdateXPos_00C		* Auto-modification de code on positionne ADDB
	LDD SONIC_X_SPEED
SONIC_MoveUpdateXPos_00A	
	ADDD SONIC_X_SPS         		* Ajout du reste subpixel
	STA SONIC_MoveUpdateXPos_00B+1 	* Sauvegarde par auto-modification de code
	ANDA #$03               		* on garde le reliquat de la division par 4 frames
	STD SONIC_X_SPS					* sauvegarde du nouveau reste subpixel
SONIC_MoveUpdateXPos_00B
	LDB #$00						* restauration du calcul de frame
	LSRB							* gestion pixel aspect ratio 2:1
	LSRB							* gestion pixel block 2x
	STB SONIC_MoveUpdateXPos_00C+1 	* auto-modification de code
	LDB SONIC_X_POS
SONIC_MoveUpdateXPos_00C
	ADDB #$00						* Mise a jour de la position
SONIC_MoveUpdateXPos_01
	CMPB #$47					* Test de butee ecran a droite
	BLE SONIC_MoveUpdateXPos_02	* Butee non atteinte
	LDB #$47					* Butee atteinte on limite a la butee
SONIC_MoveUpdateXPos_02
    CMPB #$00					* Test de la butee ecran a gauche
	BGE SONIC_MoveUpdateXPos_03	* Butee non atteinte
	LDB #$00					* Butee atteinte on limite a la butee
SONIC_MoveUpdateXPos_03
	STB SONIC_X_POS

* Coordonnees Y
***************

	LDD SONIC_Y_SPEED				* TODO voir si gain de cycles si on utilise une autre methode que l'automodif
	BGE SONIC_MoveUpdateYPos_00   	* BRANCH si orientation vers le HAUT
	LDA #$C0						* code de l'instruction SUBB
	STA SONIC_MoveUpdateYPos_00C		* Auto-modification de code on positionne SUBB
	LDD #$0000
	SUBD SONIC_Y_SPEED				* La vitesse negative est convertie en positive 
	BRA SONIC_MoveUpdateYPos_00A
SONIC_MoveUpdateYPos_00
	LDA #$CB						* code de l'instruction ADDB
	STA SONIC_MoveUpdateYPos_00C		* Auto-modification de code on positionne ADDB
	LDD SONIC_Y_SPEED
SONIC_MoveUpdateYPos_00A	
	ADDD SONIC_Y_SPS         		* Ajout du reste subpixel
	STB SONIC_Y_SPS+1				* sauvegarde du nouveau reste subpixel
	STA SONIC_MoveUpdateYPos_00C+1 	* auto-modification de code
	LDB SONIC_Y_POS
SONIC_MoveUpdateYPos_00C
	ADDB #$00						* Mise a jour de la position
SONIC_MoveUpdateYPos_01
	CMPB #$72						* Test de butee ecran en BAS
	BLS SONIC_MoveUpdateYPos_03		* Butee non atteinte
	LDB #$72						* Butee atteinte on limite a la butee
	TST SONIC_ISJUMPING
	BEQ SONIC_MoveUpdateYPos_03	* pas de saut en cours
	STB SONIC_Y_POS
* si retombe au sol on repositionne animation idle walk ou jog puis flag jump off et maj gsp
	CLR SONIC_ISJUMPING
	LDD SONIC_X_SPEED
	STD SONIC_G_SPEED
	LDX #SONIC_IDLE_R        		* Charge animation WALK R
	STX SONIC_ANIMATION_ADR			* Sauvegarde animation
	RTS
SONIC_MoveUpdateYPos_03
	STB SONIC_Y_POS
	RTS

* TODO : Braking Animation
* Sonic enters his braking animation when you turn around only if his absolute gsp is equal to or more than 4.
* In Sonic 1 and Sonic CD, he then stays in the braking animation until gsp reaches zero or changes sign.
* In the other 3 games, Sonic returns to his walking animation after the braking animation finishes displaying all of its frames.

* TODO Mettre les données ci dessous dans un tableau pour n instances

SONIC_G_SPEED	FDB $0000	* Ground Speed First byte : Frame, Second byte : 1/256 Frame
SONIC_X_SPEED	FDB $0000	* Horizontal Speed
SONIC_X_SPS		FDB $0000	* Subpixel X speed (reliquat entre deux frames)
SONIC_Y_SPEED	FDB $0000	* Vertical Speed
SONIC_Y_SPS		FDB $0000	* Subpixel Y speed (reliquat entre deux frames)
