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
FINECRANA EQU $1F40	* fin de la RAM A video
DEBUTECRANB EQU $2014	* test pour fin stack blasting
FINECRANB EQU $3F40	* fin de la RAM B video

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
* Initialisation de la couleur de bordure
********************************************************************************
INITBORD
	LDA	#$0F	* couleur 15
	STA	$E7DD

********************************************************************************
* Initialisation de la routine de commutation de page video
********************************************************************************
	LDB $6081
	ORB #$10
	STB $6081
	STB $E7E7

********************************************************************************
* Effacement ecran (les deux pages)
********************************************************************************
	LDB #$03
	STB $E7E5
	JSR SCRC
	JSR DRAWBCKGRN
	JSR SCRC
	JSR DRAWBCKGRN
	JSR SCRC        * changement de page ecran
********************************************************************************
* Boucle principale
********************************************************************************
	JSR DRAW_TEST1X100000
	
	LDX POS_TEST1X100000	* save des positions
	LDY DRAW_EREF_TEST1X100000_1
	STX 45,Y
	LDX POS_TEST1X100000+2
	LDY DRAW_EREF_TEST1X100000_1
	STX 47,Y
	
	LDX DRAW_EREF_TEST1X100000_1
	LDY DRAW_EREF_TEST1X100000_1+2
	STY DRAW_EREF_TEST1X100000_1
	STX DRAW_EREF_TEST1X100000_1+2
	JSR SCRC
	
	JSR DRAW_TEST1X100000
	
	LDX POS_TEST1X100000	* save des positions
	LDY DRAW_EREF_TEST1X100000_1
	STX 45,Y
	LDX POS_TEST1X100000+2
	LDY DRAW_EREF_TEST1X100000_1
	STX 47,Y
	
	LDX DRAW_EREF_TEST1X100000_1
	LDY DRAW_EREF_TEST1X100000_1+2
	STY DRAW_EREF_TEST1X100000_1
	STX DRAW_EREF_TEST1X100000_1+2
	JSR SCRC
	
MAIN
	JSR [DRAW_EREF_TEST1X100000_1]
	JSR DRAW_TEST1X100000
	
	LDX POS_TEST1X100000	* save des positions
	LDY DRAW_EREF_TEST1X100000_1
	STX 45,Y
	LDX POS_TEST1X100000+2
	LDY DRAW_EREF_TEST1X100000_1
	STX 47,Y
	
	LDX DRAW_EREF_TEST1X100000_1	* permute les deux routines pour effacer le sprite
	LDY DRAW_EREF_TEST1X100000_1+2
	STY DRAW_EREF_TEST1X100000_1
	STX DRAW_EREF_TEST1X100000_1+2

	LDX POS_TEST1X100000	* avance de 2 px a gauche
	LDY POS_TEST1X100000+2
	STX POS_TEST1X100000+2
	LEAY -1,Y
	STY POS_TEST1X100000

	JSR VSYNC
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

********************************************************************************  
* Affichage de l arriere plan xxx cycles
********************************************************************************	
DRAWBCKGRN
	PSHS U,DP		* sauvegarde des registres pour utilisation du stack blast
	STS >SSAVE
	
	LDS #FINECRANA	* init pointeur au bout de la RAM A video (ecriture remontante)
	LDU #$A000

DRWBCKGRNDA
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
	BNE DRWBCKGRNDA
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU A,B,DP,X,Y
	PSHS Y,X,DP,B,A
	PULU B,DP,X,Y
	PSHS Y,X,DP,B

	LDS #FINECRANB	* init pointeur au bout de la RAM B video (ecriture remontante)
	LDU #$C000

DRWBCKGRNDB
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
	BNE DRWBCKGRNDB
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
