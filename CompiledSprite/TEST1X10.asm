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
	LEAS -39,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 5,S
	PULU Y,DP,B
	PSHS Y,DP,B,A
	LEAS -40,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	STA  ,S
	LEAS -41,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 2,S
	PULU B
	PSHS B,A
	LEAS -38,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 3,S
	PULU DP,B
	PSHS DP,B,A
	LEAS -40,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 2,S
	PULU B
	PSHS B,A
	LEAS -38,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	LEAS 4,S
	PULU Y,B
	PSHS Y,B,A
	LEAS -40,S

	LDS >POS_TEST1X100000
	LEAS 8192,S
	LDU #DATA_TEST1X100000_2

	LEAS -1,S
	PULU A
	PSHS A
	LEAS -40,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	STA  ,S
	LEAS -40,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	STA  ,S
	LEAS -80,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	LEAS -39,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	LEAS -1,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	LEAS -40,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	LEAS -39,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	LEAS -2,S
	PULU A
	PSHS A
	LEAS -39,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU A
	PSHS A
	LEAS -41,S
	PULU B,A
	PSHS B,A
	LEAS -39,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU A
	PSHS A
	LEAS -38,S
	PULU B,A
	PSHS B,A
	LEAS -40,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 2,S
	PULU B
	PSHS B,A
	LEAS -40,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	STA  ,S
	LEAS -80,S

	LDS  >SSAVE
	PULS U,DP
	RTS

DATA_TEST1X100000_1
	FDB $0503
	FDB $a686
	FDB $6666
	FDB $050a
	FDB $3708
	FDB $8337
	FDB $0a88
	FDB $2014
	FDB $6788
DATA_TEST1X100000_2
	FDB $9509
	FDB $08a0
	FDB $50a0
	FDB $a030
	FDB $8a30
	FDB $aa38
	FDB $6560
	FDB $88aa
	FDB $660a
	FDB $880b
POS_TEST1X100000
	FDB $1F40

TABPALETTE
	FDB $0000	* index:0  R:0   V:0   B:0  
	FDB $0500	* index:1  R:0   V:0   B:173
	FDB $0f20	* index:2  R:0   V:140 B:255
	FDB $0000	* index:3  R:49  V:16  B:16 
	FDB $0fa0	* index:4  R:82  V:222 B:255
	FDB $0101	* index:5  R:99  V:82  B:99 
	FDB $0002	* index:6  R:140 V:82  B:0  
	FDB $0333	* index:7  R:156 V:156 B:156
	FDB $0016	* index:8  R:189 V:115 B:82 
	FDB $0888	* index:9  R:206 V:206 B:206
	FDB $036a	* index:10 R:222 V:189 B:156
	FDB $0fff	* index:11 R:255 V:255 B:255
	FDB $0fff	* index:12 R:255 V:255 B:255
	FDB $0fff	* index:13 R:255 V:255 B:255
	FDB $02af	* index:14 R:255 V:224 B:128
	FDB $0146	* index:15 R:186 V:163 B:93 
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
