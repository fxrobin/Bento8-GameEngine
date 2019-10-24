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

	PULU B,A
	PSHS B,A
	LEAS -5,S
	PSHS B,A
	LEAS -31,S
	PULU DP,B,A
	PSHS DP,B,A
	LEAS -4,S
	PULU A
	PSHS DP,B,A
	LEAS -31,S
	PULU A
	PSHS DP,A
	LEAS -5,S
	PULU A
	PSHS DP,A
	LEAS -32,S
	PULU B
	PSHS B,A
	LEAS -4,S
	PULU A
	PSHS DP,A
	LEAS -33,S
	PULU B
	PSHS B,A
	LEAS -3,S
	PULU B,A
	PSHS B,A
	LEAS -36,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 2,S
	PULU B
	PSHS B,A
	LEAS -2,S
	PULU B,A
	PSHS B,A
	LEAS -34,S
	PULU B,A
	PSHS B,A
	LEAS -3,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU B,A
	PSHS B,A
	LEAS -34,S
	PULU B,A
	PSHS B,A
	LEAS -2,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU B,A
	PSHS B,A
	LEAS -35,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU B,A
	PSHS B,A
	LEAS -4,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 3,S
	PULU DP,B
	PSHS DP,B,A
	LEAS -34,S
	PULU X,Y,B,A
	PSHS X,Y,B,A
	LEAS -35,S
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -36,S
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -36,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	LEAS -5,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 5,S
	PULU Y,DP,B
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -36,S
	PULU Y,B,A
	PSHS Y,B,A
	LEAS -37,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU Y,B,A
	PSHS Y,B,A
	LEAS -41,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 5,S
	PULU Y,DP,B
	PSHS Y,DP,B,A
	LEAS -36,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU Y,B,A
	PSHS Y,B,A
	LEAS -36,S
	PULU Y,B,A
	PSHS Y,DP,B,A
	LEAS -36,S
	PULU Y,B,A
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU Y,B,A
	PSHS Y,DP,B,A
	LEAS -36,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	LEAS -5,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 5,S
	PULU Y,DP,B
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU X,Y
	PSHS X,Y,B
	LEAS -36,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU Y,B,A
	PSHS Y,B,A
	LEAS -41,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 6,S
	PULU X,Y,B
	PSHS X,Y,B,A
	LEAS -34,S
	PULU X,Y,B,A
	PSHS X,Y,B,A
	LEAS -35,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	LEAS -6,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 6,S
	PULU X,Y,B
	PSHS X,Y,B,A
	LEAS -34,S
	PULU X,Y,B,A
	PSHS X,Y,B,A
	LEAS -34,S
	PULU X,Y,DP,B,A
	PSHS X,Y,DP,B,A
	LEAS -34,S
	PULU X,Y,B,A
	PSHS X,Y,B,A
	LEAS -41,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 7,S
	PULU X,Y,DP,B
	PSHS X,Y,DP,B,A
	LEAS -34,S
	PULU A
	PSHS A
	LEAS -1,S
	PULU Y,B,A
	PSHS Y,B,A
	LEAS -36,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 2,S
	PULU B
	PSHS B,A
	PULU DP,B,A
	PSHS DP,B,A
	LEAS -38,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	LEAS 2,S
	PULU B
	PSHS B,A
	PULU Y
	PSHS Y,DP
	LEAS -37,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 2,S
	PULU B
	PSHS B,A
	PULU DP,B,A
	PSHS DP,B,A
	LEAS -41,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 6,S
	PULU X,Y,B
	PSHS X,Y,B,A
	LEAS -35,S
	PULU X,Y
	PSHS X,Y,DP
	LEAS -35,S
	PULU B,A
	PSHS B,A
	LEAS -1,S
	PULU B,A
	PSHS B,A
	LEAS -39,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	LEAS 3,S
	PULU DP,B
	PSHS DP,B,A
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	STA  ,S
	LEAS -37,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU A
	PSHS DP,A
	LEAS -41,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 3,S
	PULU DP,B
	PSHS DP,B,A
	LEAS -38,S
	PSHS DP,B
	LEAS -5,S

	LDS >POS_TEST1X100000
	LEAS 8192,S
	LDU #DATA_TEST1X100000_2

	PULU DP,B,A
	PSHS DP,B,A
	LEAS -4,S
	PSHS DP,B,A
	LEAS -31,S
	PULU B
	PSHS B,A
	LEAS -5,S
	PULU B,A
	PSHS B,A
	LEAS -32,S
	PULU B,A
	PSHS B,A
	LEAS -4,S
	PULU B,A
	PSHS B,A
	LEAS -35,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 2,S
	PULU B
	PSHS B,A
	LEAS -3,S
	PULU A
	PSHS DP,A
	LEAS -34,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PSHS B
	LEAS -4,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	LEAS -2,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 2,S
	PULU B
	PSHS B,A
	LEAS -33,S
	PULU A
	PSHS DP,A
	LEAS -3,S
	PULU B,A
	PSHS B,A
	LEAS -34,S
	PULU B,A
	PSHS B,A
	LEAS -2,S
	PULU B,A
	PSHS B,A
	LEAS -34,S
	PULU Y
	PSHS Y,DP
	LEAS -1,S
	PULU DP,B,A
	PSHS DP,B,A
	LEAS -37,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 3,S
	PULU DP,B
	PSHS DP,B,A
	PULU DP,B,A
	PSHS DP,B,A
	LEAS -35,S
	PULU X,Y
	PSHS X,Y,B
	LEAS -36,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -41,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 6,S
	PULU X,Y,B
	PSHS X,Y,B,A
	LEAS -35,S
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -36,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU Y,B,A
	PSHS Y,B,A
	LEAS -41,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 5,S
	PULU Y,DP,B
	PSHS Y,DP,B,A
	LEAS -36,S
	PULU Y,B,A
	PSHS Y,B,A
	LEAS -37,S
	PULU Y,B,A
	PSHS Y,B,A
	LEAS -36,S
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -36,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	LEAS -5,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 5,S
	PULU Y,DP,B
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -36,S
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -41,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 5,S
	PULU Y,DP,B
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU Y,DP,A
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU X,Y,B,A
	PSHS X,Y,B,A
	LEAS -35,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU X,Y,A
	PSHS X,Y,DP,A
	LEAS -34,S
	PULU X,Y,B,A
	PSHS X,Y,B,A
	LEAS -34,S
	PULU X,Y,DP,B,A
	PSHS X,Y,DP,B,A
	LEAS -36,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	LEAS 2,S
	PULU B
	PSHS B,A
	PULU Y,B,A
	PSHS Y,B,A
	LEAS -34,S
	PULU X,Y,B,A
	PSHS X,Y,B,A
	LEAS -37,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	LEAS 2,S
	PULU B
	PSHS B,A
	PULU DP,B,A
	PSHS DP,B,A
	LEAS -37,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 2,S
	PSHS DP,A
	PULU DP,B,A
	PSHS DP,B,A
	LEAS -36,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU X,Y
	PSHS X,Y,DP
	LEAS -37,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 2,S
	PULU B
	PSHS B,A
	PULU DP,B,A
	PSHS DP,B,A
	LEAS -38,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	LEAS 3,S
	PULU DP,B
	PSHS DP,B,A
	PULU B,A
	PSHS B,A
	LEAS -36,S
	PULU Y,A
	PSHS Y,B,A
	LEAS -39,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 3,S
	PULU DP,B
	PSHS DP,B,A
	PULU A
	PSHS A
	LEAS -37,S
	PULU B,A
	PSHS B,A
	LEAS -39,S
	PULU B,A
	PSHS B,A
	LEAS -46,S

	LDS  >SSAVE
	PULS U,DP
	RTS

DATA_TEST1X100000_1
	FDB $cccc
	FDB $caaa
	FDB $cccc
	FDB $a7cc
	FDB $3cc7
	FDB $a7aa
	FDB $c70c
	FDB $7ccc
	FDB $aca7
	FDB $7cc0
	FDB $c73a
	FDB $ca33
	FDB $c037
	FDB $77c0
	FDB $aa73
	FDB $0c33
	FDB $a7ca
	FDB $37aa
	FDB $ca77
	FDB $0ccc
	FDB $77aa
	FDB $7a33
	FDB $84ca
	FDB $7a3a
	FDB $a3c0
	FDB $0c44
	FDB $aa33
	FDB $a3cc
	FDB $8c73
	FDB $a337
	FDB $44cc
	FDB $a7a7
	FDB $c0ca
	FDB $4ccc
	FDB $c30c
	FDB $ac55
	FDB $cccc
	FDB $c04c
	FDB $c255
	FDB $0c44
	FDB $ccc3
	FDB $c5c1
	FDB $445c
	FDB $7c14
	FDB $cc77
	FDB $ccc0
	FDB $0c44
	FDB $cc5c
	FDB $4448
	FDB $55c4
	FDB $ccc0
	FDB $148c
	FDB $cc30
	FDB $0c14
	FDB $254c
	FDB $cbcc
	FDB $c08c
	FDB $c4cc
	FDB $88cc
	FDB $c00c
	FDB $88b8
	FDB $cc88
	FDB $44c5
	FDB $25c4
	FDB $0044
	FDB $48c3
	FDB $22bc
	FDB $88c8
	FDB $848c
	FDB $37cb
	FDB $8448
	FDB $cc44
	FDB $0c77
	FDB $b11c
	FDB $40c1
	FDB $ccc7
	FDB $ccb9
	FDB $bbcc
	FDB $0c7c
	FDB $66bc
	FDB $b9b0
	FDB $7c96
	FDB $410c
	FDB $8896
	FDB $6bbb
	FDB $0b64
	FDB $bb6b
	FDB $448c
	FDB $4646
	FDB $c4bc
	FDB $b84c
	FDB $bb14
	FDB $b04b
	FDB $440b
	FDB $c0c4
	FDB $0ccc
	FDB $cc00
DATA_TEST1X100000_2
	FDB $cccc
	FDB $cc7a
	FDB $77ac
	FDB $cc77
	FDB $3aac
	FDB $0cca
	FDB $aac0
	FDB $c00c
	FDB $acaa
	FDB $cc73
	FDB $caa7
	FDB $337a
	FDB $773c
	FDB $c337
	FDB $7c0c
	FDB $ac37
	FDB $70aa
	FDB $7c7a
	FDB $cca7
	FDB $33c0
	FDB $cca3
	FDB $777a
	FDB $770c
	FDB $4877
	FDB $7a73
	FDB $3c4c
	FDB $8ca7
	FDB $a3a7
	FDB $c044
	FDB $aa77
	FDB $a70c
	FDB $4caa
	FDB $7a7c
	FDB $c455
	FDB $c70c
	FDB $c7c2
	FDB $55cc
	FDB $c47a
	FDB $22c3
	FDB $c2c0
	FDB $0c14
	FDB $2555
	FDB $3041
	FDB $c555
	FDB $335c
	FDB $c188
	FDB $c55c
	FDB $cc14
	FDB $8c55
	FDB $7c41
	FDB $0c44
	FDB $ccc7
	FDB $8cc4
	FDB $524c
	FDB $0c41
	FDB $8cc8
	FDB $cc8c
	FDB $142b
	FDB $ccb8
	FDB $88cc
	FDB $c2c4
	FDB $cc44
	FDB $88c0
	FDB $c7b8
	FDB $b3c8
	FDB $487c
	FDB $5c84
	FDB $4484
	FDB $44c3
	FDB $ccb4
	FDB $11cc
	FDB $814c
	FDB $b04c
	FDB $03bb
	FDB $b4c4
	FDB $cc9b
	FDB $4c1b
	FDB $c4ac
	FDB $b077
	FDB $b966
	FDB $cc0c
	FDB $996b
	FDB $b9c0
	FDB $694b
	FDB $9bc8
	FDB $0c48
	FDB $9996
	FDB $6bb0
	FDB $4b8c
	FDB $b6bb
	FDB $b4c4
	FDB $4b0c
	FDB $484c
	FDB $bb4b
	FDB $1441
	FDB $1100
POS_TEST1X100000
	FDB $1F40

TABPALETTE
	FDB $0bee	* index:0  R:248 V:248 B:232
	FDB $029e	* index:1  R:248 V:216 B:128
	FDB $00ae	* index:2  R:248 V:224 B:0  
	FDB $0158	* index:3  R:208 V:176 B:112
	FDB $0038	* index:4  R:208 V:144 B:64 
	FDB $003a	* index:5  R:224 V:152 B:0  
	FDB $0016	* index:6  R:192 V:104 B:0  
	FDB $0012	* index:7  R:136 V:104 B:56 
	FDB $0002	* index:8  R:136 V:80  B:16 
	FDB $0002	* index:9  R:128 V:56  B:0  
	FDB $0000	* index:10 R:80  V:48  B:8  
	FDB $0000	* index:11 R:64  V:32  B:0  
	FDB $0000	* index:12 R:24  V:16  B:8  
	FDB $0000	* index:13 R:0   V:0   B:0  
	FDB $0111	* index:14 R:96  V:96  B:96 
	FDB $0666	* index:15 R:192 V:192 B:192
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
