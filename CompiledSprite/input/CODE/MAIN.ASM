********************************************************************************
*                               CompiledSprite                                 *
********************************************************************************
* Auteur  :                                                                    *
* Date    :                                                                    *
* Licence :                                                                    *
********************************************************************************
*
********************************************************************************

(main)MAIN
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

<ANIMATION_TABLE>
* Limite a 128 images par animations

	FDB $0018		* 00 Absolute 18 Nb frames par image
HERO_IDLE-L
	FCB $01			* Page associee a l adresse drw img 00
	FDB $A000		* Adresse drw img 00
	FDB $A000		* Adresse del img 00
	FCB $01			* Page associee a l adresse drw img 01
	FDB $A000		* Adresse drw img 01
	FDB $A000		* Adresse del img 01
	FCB $01			* Page associee a l adresse drw img 02
	FDB $A000		* Adresse drw img 02
	FDB $A000		* Adresse del img 02
	FCB $FF			* FF Boucle
	FDB $0300		* 03 nb de boucles 00 image de depart
	FDB $0000		* non utilise
	FCB $01			* Page associee a l adresse drw img 04
	FDB $A000		* Adresse drw img 04
	FDB $A000		* Adresse del img 04
	FCB $FF			* FF Boucle
	FDB $0004		* 00 nb de boucles 04 image de depart
	FDB $0000		* non utilise
	
	FDB $0018		* 00 Absolute 18 Nb frames par image
HERO_IDLE-R
	FCB $01			* Page associee a l adresse drw img 00
	FDB $A000		* Adresse drw img 00
	FDB $A000		* Adresse del img 00
	FCB $01			* Page associee a l adresse drw img 01
	FDB $A000		* Adresse drw img 01
	FDB $A000		* Adresse del img 01
	FCB $01			* Page associee a l adresse drw img 02
	FDB $A000		* Adresse drw img 02
	FDB $A000		* Adresse del img 02
	FCB $FE			* FE do not save return adress and BRANCH
	FDB $0000		* 00 unused 00 image cible
	FDB HERO_IDLE-C * adresse animation cible

	FDB $0018		* 00 Absolute 18 Nb frames par image
HERO_IDLE-L
	FCB $01			* Page associee a l adresse drw img 00
	FDB $A000		* Adresse drw img 00
	FDB $A000		* Adresse del img 00
	FCB $FD			* FD save return adress and BRANCH
	FDB $0000		* 00 unused 00 image cible
	FDB HERO_IDLE-B * animation cible
	FCB $01			* Page associee a l adresse drw img 02
	FDB $A000		* Adresse drw img 02
	FDB $A000		* Adresse del img 02
	FCB $FF			* FF Boucle
	FDB $0001		* 00 nb de boucles 01 image de depart
	FDB $0000		* non utilise
	
	FDB $0018		* 00 Absolute (FF for GSP relative) 18 Nb frames par image
HERO_SUBIDLE-B
	FCB $01			* Page associee a l adresse drw
	FDB $A000		* Adresse drw
	FDB $A000		* Adresse del
	FDB $FC			* FC return to saved adress and next image

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

********************************************************************************
* Initialisation des deux pages videos avec Fond et sprites
********************************************************************************
	LDX #HERO_IDLE-R
	JSR HERO_ANIMATION_LOAD

	FCB $01
INIT_SCREEN
	LDB #$03							* On monte la page 3
	STB $E7E5							* en RAM Donnees (A000-DFFF)
	JSR DRAW_RAM_DATA_TO_CART_160x200
	
	LDB HERO_ANIMATION_PAG				* On monte la page 
	STB $E7E5							* en RAM Donnees (A000-DFFF)
	JSR [HERO_ANIMATION_DRW]			* TODO Boucle sur tous les sprites visibles
	
	JSR SCRC                    		* page 0 en RAM Cartouche (0000-3FFF) - page 2 en RAM Ecran (4000-5FFF)
										* page 2 en RAM Cartouche (0000-3FFF) - page 0 en RAM Ecran (4000-5FFF)
	DEC -1,INIT_SCREEN
	BCC INIT_SCREEN

********************************************************************************
* Boucle principale
********************************************************************************
MAIN
	* Effacement et affichage des sprites
	LDB HERO_ANIMATION_PAG				* On monte la page 
	STB $E7E5							* en RAM Donnees (A000-DFFF)
	JSR [HERO_ANIMATION_EFF]			* Efface le sprite
	JSR [HERO_ANIMATION_DRW]			* Sauve arriere plan et affiche le sprite

	* Gestion des deplacements
	JSR JOY_READ
	JSR Hero_Move
	JSR Compute_Position

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
	JSR VSYNC

	LDB SCRC0+1
	ANDB #$01
	LDA HERO_ANIMATION_PAG
	ADDA B
	STA HERO_ANIMATION_PAG
	
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

****************************************
* Get joystick parameters
****************************************
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

****************************************************************************
* Subroutine to	make HERO walk/run
****************************************************************************
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
	LDD HERO_G_SPEED
	CMPD #$0000
	BLT Hero_NotLeftOrRight_00 * se deplace a gauche
	SUBD HERO_FRICTION     * se deplace a droite on soustrait la friction a la vitesse
	BCC Hero_NotLeftOrRight_01 * si on passe en dessous de 0 on repositionne a 0
	LDD #$0000
	STD HERO_G_SPEED
	STD HERO_X_SPS
	LDA #$01                  * Charge animation IDLE R
	STA HERO_ANIMATION
	LBRA Hero_MoveUpdatePos
Hero_NotLeftOrRight_01	       
	CMPD #HERO_JOG_SPD_LIMIT
	BGE Hero_NotLeftOrRight_02
	STD HERO_G_SPEED
	LDA #$03                  * Charge animation WALK R
	STA HERO_ANIMATION
	BRA Hero_NotLeftOrRight_03
Hero_NotLeftOrRight_02	
	STD HERO_G_SPEED
Hero_NotLeftOrRight_03
	LBRA Hero_MoveUpdatePos
Hero_NotLeftOrRight_00	
	ADDD HERO_FRICTION     * se deplace a gauche on ajoute la friction a la vitesse negative
	BCC Hero_NotLeftOrRight_11 * si on passe au dessus de 0 on repositionne a 0
	LDD #$0000
	STD HERO_G_SPEED
	LDA #$02                  * Charge animation IDLE L
	STA HERO_ANIMATION
	LBRA Hero_MoveUpdatePos
Hero_NotLeftOrRight_11	       
	CMPD #HERO_JOG_SPD_LIMIT
	BLE Hero_NotLeftOrRight_12
	STD HERO_G_SPEED
	LDA #$04                  * Charge animation WALK L
	STA HERO_ANIMATION
	BRA Hero_NotLeftOrRight_13
Hero_NotLeftOrRight_12	
	STD HERO_G_SPEED
Hero_NotLeftOrRight_13
	LBRA Hero_MoveUpdatePos

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
	LBRA Hero_MoveUpdatePos	   	* Mise a jour des coordonnees
Hero_MoveLeft_00		       	* Orientation a GAUCHE 
*	CMPD #$0000					* Comparaison avec la vitesse nulle
*	BNE Hero_MoveLeft_02     	* BRANCH vitesse au sol non nulle
*	LDD #$FEFF					* init vitesse de depart
*Hero_MoveLeft_02
	CMPD HERO_NEG_TOP_SPEED	* Comparaison avec la vitesse maximum
	BEQ Hero_MoveUpdatePos     	* vitesse au sol deja au maximum - Mise a jour des coordonnees
	SUBD HERO_ACCELERATION 	* acceleration
	CMPD HERO_NEG_TOP_SPEED	* Comparaison avec la vitesse maximum
	BGT Hero_MoveLeft_01       	* BRANCH si vitesse inferieur au maximum
	LDA #$06                   	* Charge animation RUN L
	STA HERO_ANIMATION     	* Sauvegarde animation
	LDD HERO_NEG_TOP_SPEED 	* Limitation de la vitesse au maximum
	STD HERO_G_SPEED       	* Enregistrement de la vitesse
	LBRA Hero_MoveUpdatePos    	* Mise a jour des coordonnees
Hero_MoveLeft_01               	
	STD HERO_G_SPEED       	* Enregistrement de la vitesse
	LDA #$04                   	* Charge animation WALK L
	STA HERO_ANIMATION     	* Sauvegarde animation
	LBRA Hero_MoveUpdatePos

Hero_MoveRight                  * XREF: Hero_NotLeft
	LDD HERO_G_SPEED        * Chargement de la vitesse au sol
	CMPD #$0000                 * Test orientation
	BGE Hero_MoveRight_00       * BRANCH si orientation a DROITE
	ADDD HERO_DECELERATION 	* orientation a GAUCHE on reduit la vitesse
	BCC Hero_MoveRight_03       * BRANCH si orientation toujours a GAUCHE
	LDD HERO_DECELERATION   * si la vitesse est devenue positive on la force a la valeur de DECELERATION
Hero_MoveRight_03	
	STD HERO_G_SPEED        * On stocke la vitesse
	LBRA Hero_MoveUpdatePos		* Mise a jour des coordonnees
Hero_MoveRight_00		      	* Orientation a DROITE 
*	CMPD #$0000					* Comparaison avec la vitesse nulle
*	BNE Hero_MoveRight_02     	* BRANCH vitesse au sol non nulle
*	LDD #$0100					* init vitesse de depart
*Hero_MoveRight_02
	CMPD HERO_TOP_SPEED		* Comparaison avec la vitesse maximum
	BEQ Hero_MoveUpdatePos      * vitesse au sol deja au maximum - Mise a jour des coordonnees
	ADDD HERO_ACCELERATION 	* acceleration
	CMPD HERO_TOP_SPEED		* Comparaison avec la vitesse maximum
	BLT Hero_MoveRight_01       * BRANCH si vitesse inferieur au maximum
	LDA #$05                    * Charge animation RUN R
	STA HERO_ANIMATION		* Sauvegarde animation
	LDD HERO_TOP_SPEED		* Limitation de la vitesse au maximum
	STD HERO_G_SPEED		* Enregistrement de la vitesse
	LBRA Hero_MoveUpdatePos		* Mise a jour des coordonnees
Hero_MoveRight_01
	STD HERO_G_SPEED		* Enregistrement de la vitesse
	LDA #$03                    * Charge animation WALK R
	STA HERO_ANIMATION		* Sauvegarde animation

Hero_MoveUpdatePos
	LDD HERO_G_SPEED		* Chargement de la vitesse au sol
	STD HERO_X_SPEED        * Stockage vitesse X TODO xsp = gsp*cos(angle)
	CMPD #$0000                 * Test orientation
	BLT Hero_MoveUpdatePos_00   * BRANCH si orientation a GAUCHE
	ADDD HERO_X_SPS         * Ajout du reste subpixel
	STB HERO_X_SPS+1		* sauvegarde du nouveau reste subpixel
	TFR A,B                     * Division par 256
	ADDB HERO_X_POS			* Ajout de la vitesse a la position
	BRA Hero_MoveUpdatePos_01
Hero_MoveUpdatePos_V00
	FCB $00
Hero_MoveUpdatePos_00
	LDD #$0000
	SUBD HERO_X_SPEED		* La vitesse negative est convertie en positive
	ADDD HERO_X_SPS         * Ajout du reste subpixel
	STB HERO_X_SPS+1		* sauvegarde du nouveau reste subpixel
	TFR A,B                     * Division par 256
	STB Hero_MoveUpdatePos_V00
	LDB HERO_X_POS
	SUBB Hero_MoveUpdatePos_V00 * Ajout de la vitesse a la position
Hero_MoveUpdatePos_01
*	CMPB #$50					* Test de butee ecran a droite
*	BLE Hero_MoveUpdatePos_02	* Butee non atteinte
*	LDB #$50					* Butee atteinte on limite a la butee
*Hero_MoveUpdatePos_02
*    CMPB #$0C					* Test de la butee ecran a gauche
*	BGE Hero_MoveUpdatePos_03	* Butee non atteinte
*	LDB #$0C					* Butee atteinte on limite a la butee
Hero_MoveUpdatePos_03
	STB HERO_X_POS			
	LDB #$00					
	STB TEST1X10_X_SPS			* reste subpixel est sur un octet stocké sur deux
	LDD #$0000                  * TODO ysp = gsp*-sin(angle)
	STD HERO_Y_SPEED
	TFR A,B                     * division par 256
	ADDB HERO_Y_POS
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
	STD POS_HERO0000
	ADDD #$2000
	STD POS_HERO0000+2
	RTS
Compute_Position_01
	STA Compute_Position_02+1
	LDA #$28
	LDB HERO_Y_POS
	DECB
	MUL
	ADDD Compute_Position_02
	ADDD #$2000
	STD POS_HERO0000
	SUBD #$1FFF
	STD POS_HERO0000+2
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
	
********************************************************************************
* Palette de 16 couleurs
********************************************************************************
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

********************************************************************************
* HERO Animations
********************************************************************************

HERO_ANIMATION_LOAD
	STX HERO_ANIMATION_ADR
	LDA -1,X
	STA HERO_ANIMATION_FRR
	LDA -2,X
	STA HERO_ANIMATION_NBI
	LDA #$00
	STA HERO_ANIMATION_IMC
HERO_ANIMATION_LOAD_00
	LDB A,X
	STB HERO_ANIMATION_PAG
	LDB #$04
	MUL
	ADDB HERO_ANIMATION_NBI
	LDY B,X
	STY HERO_ANIMATION_DRW
	ADDB #$02
	LDY B,X
	STY HERO_ANIMATION_EFF
	RTS

HERO_ANIMATION_NEXT				*TODO gestion derniere image et rebouclage ou boucle infinie
	LDA HERO_ANIMATION_FRR
	DECA
	BNE HERO_ANIMATION_NEXT_00
	LDX HERO_ANIMATION_ADR
	LDA -1,X
	STA HERO_ANIMATION_FRR
	DEC HERO_ANIMATION_IMC
	LDA HERO_ANIMATION_IMC	
	BRA HERO_ANIMATION_LOAD_00
HERO_ANIMATION_NEXT_00
	STA HERO_ANIMATION_FRR
	RTS

********************************************************************************
* HERO Variables
********************************************************************************
HERO_WALK_SPD_LIMIT EQU $0400
HERO_JOG_SPD_LIMIT  EQU $0600
HERO_X_POS
	FCB $50        * position horizontale
HERO_Y_POS
	FCB $C8        * position verticale
HERO_G_SPEED
	FDB $0000        * vitesse au sol
HERO_X_SPEED
	FDB $0000        * vitesse horizontale
HERO_X_SPS
	FDB $0000        * subpixel X speed
HERO_Y_SPEED
	FDB $0000        * vitesse verticale
HERO_Y_SPS
	FDB $0000        * subpixel Y speed
HERO_TOP_SPEED
	FDB $0600        * vitesse maximum autorisee 6 = 1536/256
HERO_NEG_TOP_SPEED
	FDB $FA00        * vitesse maximum autorisee -6 = -1536/256
HERO_ACCELERATION
	FDB $000C        * constante acceleration 0.046875 = 12/256
HERO_DECELERATION
	FDB $0080        * constante deceleration 0.5 = 128/256
HERO_FRICTION
	FDB $000C        * constante de friction 0.046875 = 12/256
HERO_ANIMATION_ADR
	FDB $0000        * Animation courante - Pointeurs Adresse
HERO_ANIMATION_RTN_ADR
	FDB $0000        * Animation courante - Pointeur Adresse Retour Animation apellante
HERO_ANIMATION_PAG
	FCB $00          * Animation courante - Pointeur Page
HERO_ANIMATION_DEL
	FDB $0000        * Animation courante - Pointeur Effacement
HERO_ANIMATION_DRW
	FDB $0000        * Animation courante - Pointeur Dessin
HERO_ANIMATION_NBI
	FCB $00          * Animation courante - Nombre d images
HERO_ANIMATION_IMC
	FCB $00          * Animation courante - Image courante
HERO_ANIMATION_FRR
	FCB $00          * Animation courante - Frames restante