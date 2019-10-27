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
	ORG $A000

********************************************************************************  
* Constantes et variables
********************************************************************************
DEBUTECRANA EQU $0000	* debut de la RAM A video
FINECRANA EQU $1F40	* fin de la RAM A video
DEBUTECRANB EQU $2000	* debut de la RAM B video
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
	LDA	#$04	* couleur 4
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
	JSR SCRC
	JSR EFF
	JSR SCRC
	JSR EFF

********************************************************************************
* Boucle principale
********************************************************************************
MAIN
	JSR DRAWBCKGRN
	*LDX >POS_TEST1X100000
	*LEAX -1,X
	*STX >POS_TEST1X100000
	JSR DRAW_TEST1X100000
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
	LDB SCRC0+1        * charge la valeur du LDB suivant SCRC0 en lisant directeent dans le code
	ANDB #$80          * permute #$00 ou #$80 (suivant la valeur B #$00 ou #$FF) / fond couleur 0
	ORB #$0A           * recharger la couleur de cadre si diff de 0 car effacee juste au dessus (couleur A)
	STB $E7DD          * changement page dans ESPACE ECRAN
	COM SCRC0+1        * modification du code alterne 00 et FF sur le LDB suivant SCRC0
SCRC0
	LDB #$00
	ANDB #$02          * permute #$00 ou #$80 (suivant la valeur B #$00 ou #$FF)
	ORB #$60           * espace cartouche recouvert par RAM / ecriture autorisee
	STB $E7E6          * changement page dans ESPACE CARTOUCHE permute 60/62 dans E7E6 pour demander affectation banque 0 ou 2 dans espace cartouche 
	RTS                * E7E6 D5=1 pour autoriser affectation banque
	                   * CAS1N : banques 0-15 CAS2N : banques 16-31

********************************************************************************
* Effacement de l ecran
********************************************************************************
EFF
	LDA #$AA  * couleur fond
	LDY #$0000
EFF_RAM
	STA ,Y+
	CMPY #$3FFF
	BNE EFF_RAM
	RTS

********************************************************************************  
* Affichage de l arriere plan xxx cycles
********************************************************************************	
DRAWBCKGRN
	PSHS U,DP		* sauvegarde des registres pour utilisation du stack blast
	STS >SSAVE
	
	LDS #FINECRANA	* init pointeur au bout de la RAM A video (ecriture remontante)
	LDU #TILEBCKGRNDA
	PULU X,Y,DP,D

DRWBCKGRNDA
	PSHS X,Y,DP,D
	PSHS X,Y,DP,D
	PSHS X,Y,DP,D
	PSHS X,Y,DP,D
	PSHS X,Y,DP,D
	PSHS X,Y,DP
	CMPS #DEBUTECRANA
	BNE DRWBCKGRNDA
	
	LDS #FINECRANB	* init pointeur au bout de la RAM B video (ecriture remontante)
	LDU #TILEBCKGRNDB
	PULU X,Y,DP,D

DRWBCKGRNDB
	PSHS X,Y,DP,D
	PSHS X,Y,DP,D
	PSHS X,Y,DP,D
	PSHS X,Y,DP,D
	PSHS X,Y,DP,D
	PSHS X,Y,DP
	CMPS #DEBUTECRANB
	BNE DRWBCKGRNDB
	
	LDS  >SSAVE		* rechargement des registres
	PULS U,DP
	RTS

********************************************************************************
* Affiche un computed sprite en xxx cycles
********************************************************************************
DRAW_TEST1X100000
	PSHS U,DP
	STS >SSAVE

	LDS >POS_TEST1X100000
	LDU #DATA_TEST1X100000_1

	LDA #$00
	LDB #$10
	LDX #$0022
	PSHS X,B,A
	LEAS -36,S
	LDA #$11
	LDX #$0222
	PSHS X,A
	LEAS -37,S
	LDX #$2223
	PSHS X,A
	LDA  #$0F
	ANDA -38,S
	ADDA #$20
	STA -38,S
	LDX #$1120
	STX -40,S
	LDA  #$0F
	ANDA -78,S
	ADDA #$20
	STA -78,S
	LDX #$2220
	STX -80,S
	LDX #$1442
	STX -120,S
	LEAS -158,S
	LDA  #$0F
	ANDA 0,S
	ADDA #$30
	STA 0,S
	LDX #$2134
	STX -2,S
	LDA  #$F0
	ANDA -3,S
	ADDA #$02
	STA -3,S
	LEAS -39,S
	LDA #$24
	LDX #$3333
	PSHS X,A
	LDA  #$F0
	ANDA -1,S
	ADDA #$03
	STA -1,S
	LDX #$2433
	STX -40,S
	LDA  #$F0
	ANDA -41,S
	ADDA #$02
	STA -41,S
	LDA  #$0F
	ANDA -78,S
	ADDA #$30
	STA -78,S
	LDX #$2422
	STX -80,S
	LEAS -117,S
	LDA #$24
	LDX #$2233
	PSHS X,A
	LDX #$2122
	STX -40,S
	LDX #$2222
	STX -80,S
	LDA  #$0F
	ANDA -118,S
	ADDA #$30
	STA -118,S
	LDX #$2223
	STX -120,S
	LEAS -159,S
	LDA  #$0F
	ANDA 0,S
	ADDA #$30
	STA 0,S

	LDS >POS_TEST1X100000
	LEAS 8192,S
	LDU #DATA_TEST1X100000_2

	LDA #$01
	LDB #$00
	LDX #$2222
	PSHS X,B,A
	LDA  #$0F
	ANDA -37,S
	ADDA #$30
	STA -37,S
	LEAS -37,S
	LDA #$11
	LDX #$0022
	PSHS X,A
	LEAS -37,S
	LDX #$1100
	PSHS X,A
	LDX #$1200
	STX -39,S
	LDA  #$F0
	ANDA -40,S
	ADDA #$01
	STA -40,S
	LEAS -77,S
	LDA #$22
	LDX #$2200
	PSHS X,A
	LEAS -37,S
	LDA #$44
	LDX #$4402
	PSHS X,A
	LEAS -37,S
	LDA #$21
	LDX #$1222
	PSHS X,A
	LEAS -37,S
	LDA #$14
	LDX #$1132
	PSHS X,A
	LEAS -37,S
	LDX #$1122
	PSHS X,A
	LEAS -37,S
	PSHS X,A
	LEAS -37,S
	LDX #$1123
	PSHS X,A
	LDA  #$0F
	ANDA -38,S
	ADDA #$20
	STA -38,S
	LDX #$2112
	STX -40,S
	LDX #$2233
	STX -79,S
	LDA  #$F0
	ANDA -80,S
	ADDA #$02
	STA -80,S
	STX -119,S
	LEAS -158,S
	LDA #$33
	STA -1,S
	LDA  #$F0
	ANDA -41,S
	ADDA #$03
	STA -41,S

	LDS  >SSAVE
	PULS U,DP
	RTS

DATA_TEST1X100000_1
DATA_TEST1X100000_2
POS_TEST1X100000
	FDB $1F40

TABPALETTE
	FDB $022f	* index:0  R:255 V:119 B:119
	FDB $0fff	* index:1  R:255 V:255 B:255
	FDB $00f0	* index:2  R:0   V:255 B:0  
	FDB $00ff	* index:3  R:255 V:255 B:0  
	FDB $0000	* index:4  R:0   V:0   B:0  
	FDB $0333	* index:5  R:144 V:144 B:144
	FDB $0111	* index:6  R:96  V:96  B:96 
	FDB $0666	* index:7  R:192 V:192 B:192
	FDB $0333	* index:8  R:144 V:144 B:144
	FDB $0111	* index:9  R:96  V:96  B:96 
	FDB $0666	* index:10 R:192 V:192 B:192
	FDB $0333	* index:11 R:144 V:144 B:144
	FDB $0111	* index:12 R:96  V:96  B:96 
	FDB $0666	* index:13 R:192 V:192 B:192
	FDB $0333	* index:14 R:144 V:144 B:144
	FDB $0111	* index:15 R:96  V:96  B:96 
FINTABPALETTE
********************************************************************************  
* Tile arriere plan   
********************************************************************************
TILEBCKGRNDA
	FDB $eeee
	FDB $eeee
	FDB $eeee
	FDB $eeee

TILEBCKGRNDB
	FDB $ffff
	FDB $ffff
	FDB $ffff
	FDB $ffff
