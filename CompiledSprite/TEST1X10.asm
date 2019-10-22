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
* Changement de page ecran
********************************************************************************
SCRC
	LDB SCRC0+1
	ANDB #$80          * BANK1 utilisee ou pas pour l affichage / fond couleur 0
	ORB #$0A           * contour ecran = couleur A
	STB $E7DD
	COM SCRC0+1
SCRC0
	LDB #$00
	ANDB #$02          * page RAM no0 ou no2 utilisee dans l espace cartouche
	ORB #$60           * espace cartouche recouvert par RAM / ecriture autorisee
	STB $E7E6
	RTS

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

	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	STA  ,S
	LEAS -7,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 7,S
	PULU X,Y,DP,B
	PSHS X,Y,DP,B,A
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	STA  ,S

	LDS >POS_TEST1X100000
	LEAS 8192,S
	LDU #DATA_TEST1X100000_2

	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	STA  ,S
	LEAS -7,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 7,S
	PULU X,Y,DP,B
	PSHS X,Y,DP,B,A
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	STA  ,S

	LDS  >SSAVE
	PULS U,DP
	RTS

DATA_TEST1X100000_1
	FDB $0303
	FDB $3333
	FDB $3333
	FDB $3333
	FDB $0300
DATA_TEST1X100000_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
	FDB $5555
	FDB $5555
	FDB $5555
	FDB $5555

TILEBCKGRNDB
	FDB $6666
	FDB $6666
	FDB $6666
	FDB $6666
