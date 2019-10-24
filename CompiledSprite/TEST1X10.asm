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
	PULU B
	PSHS B,A
	LEAS -5,S
	PULU B,A
	PSHS B,A
	LEAS -31,S
	PULU B,A
	PSHS B,A
	LEAS -5,S
	PULU A
	PSHS B,A
	LEAS -34,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 2,S
	PULU B
	PSHS B,A
	LEAS -3,S
	PULU B,A
	PSHS B,A
	LEAS -33,S
	PULU B,A
	PSHS B,A
	LEAS -3,S
	PULU B,A
	PSHS B,A
	LEAS -33,S
	PULU B
	PSHS B,A
	LEAS -3,S
	PULU DP
	PSHS DP,B
	LEAS -33,S
	PULU B,A
	PSHS B,A
	LEAS -3,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU B,A
	PSHS B,A
	LEAS -33,S
	PULU DP,B,A
	PSHS DP,B,A
	LEAS -1,S
	PULU DP,B,A
	PSHS DP,B,A
	LEAS -34,S
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
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU X,Y
	PSHS X,Y,DP
	LEAS -41,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 6,S
	PULU X,Y,B
	PSHS X,Y,B,A
	LEAS -35,S
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
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU Y
	PSHS Y,DP,B
	LEAS -36,S
	PULU Y,DP
	PSHS Y,DP,B
	LEAS -36,S
	PULU Y,B,A
	PSHS Y,B,A
	LEAS -41,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 5,S
	PULU Y,DP,B
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU Y,B,A
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU Y,B,A
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU Y,B
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU Y,B,A
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -40,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 6,S
	PULU X,Y,B
	PSHS X,Y,B,A
	LEAS -34,S
	PULU X,Y
	PSHS X,Y,B
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
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU X,Y,B,A
	PSHS X,Y,B,A
	LEAS -33,S
	PULU X,Y,DP,B,A
	PSHS X,Y,DP,B,A
	LEAS -33,S
	PULU X,Y,DP,B
	PSHS X,Y,DP,B,A
	LEAS -40,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 7,S
	PULU X,Y,DP,B
	PSHS X,Y,DP,B,A
	LEAS -33,S
	PULU X,Y,B,A
	PSHS X,Y,B,A
	LEAS -36,S
	LDA  #$F0
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
	PULU B
	PSHS B,A
	PULU B,A
	PSHS DP,B,A
	LEAS -37,S
	LDA  #$F0
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
	PULU B
	PSHS B,A
	PULU DP,B,A
	PSHS DP,B,A
	LEAS -35,S
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU Y,B,A
	PSHS Y,B,A
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
	LEAS -36,S
	PULU DP
	PSHS DP,B
	LEAS -41,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 3,S
	PULU DP,B
	PSHS DP,B,A
	LEAS -76,S

	LDS >POS_TEST1X100000
	LEAS 8192,S
	LDU #DATA_TEST1X100000_2

	PULU DP,B,A
	PSHS DP,B,A
	LEAS -4,S
	PSHS DP,B,A
	LEAS -30,S
	PULU B,A
	PSHS DP,B,A
	LEAS -4,S
	PULU A
	PSHS DP,B,A
	LEAS -31,S
	PULU B
	PSHS B,A
	LEAS -4,S
	PULU B,A
	PSHS B,A
	LEAS -32,S
	PULU B,A
	PSHS B,A
	LEAS -4,S
	PULU A
	PSHS DP,A
	LEAS -33,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU A
	PSHS A
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
	LEAS -35,S
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
	LEAS -2,S
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
	LEAS -37,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 3,S
	PULU DP,B
	PSHS DP,B,A
	PULU DP,B,A
	PSHS DP,B,A
	LEAS -34,S
	PULU X,Y,B,A
	PSHS X,Y,B,A
	LEAS -35,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -35,S
	PULU Y,DP,A
	PSHS Y,DP,B,A
	LEAS -40,S
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
	PULU Y,A
	PSHS Y,B,A
	LEAS -36,S
	PULU Y,B,A
	PSHS Y,B,A
	LEAS -36,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU Y,A
	PSHS Y,B,A
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
	LEAS -35,S
	PULU Y,DP,B
	PSHS Y,DP,B,A
	LEAS -35,S
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
	LEAS -40,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 5,S
	PULU Y
	PSHS Y,DP,B,A
	LEAS -35,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU Y,B,A
	PSHS Y,B,A
	LEAS -35,S
	PULU Y,DP,A
	PSHS Y,DP,B,A
	LEAS -34,S
	PULU X,Y,A
	PSHS X,Y,B,A
	LEAS -34,S
	PULU X,B,A
	PSHS X,Y,B,A
	LEAS -34,S
	PULU X,Y,B,A
	PSHS X,Y,B,A
	LEAS -34,S
	PULU X,Y,B,A
	PSHS X,Y,B,A
	LEAS -34,S
	PULU X,Y,B,A
	PSHS X,Y,B,A
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
	PULU A
	PSHS A
	LEAS -1,S
	PULU Y,B,A
	PSHS Y,B,A
	LEAS -36,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	LEAS 2,S
	PULU B
	PSHS B,A
	PULU DP,B,A
	PSHS DP,B,A
	LEAS -37,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	LEAS 2,S
	PULU B
	PSHS B,A
	PULU DP,B,A
	PSHS DP,B,A
	LEAS -35,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU Y,DP,B,A
	PSHS Y,DP,B,A
	LEAS -40,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 6,S
	PULU X,Y,B
	PSHS X,Y,B,A
	LEAS -37,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	LEAS 3,S
	PULU DP,B
	PSHS DP,B,A
	PULU B,A
	PSHS B,A
	LEAS -35,S
	PULU B,A
	PSHS B,A
	LEAS -1,S
	PULU B,A
	PSHS B,A
	LEAS -38,S
	LDA  #$F0
	ANDA ,S
	ADDA ,U+
	LEAS 3,S
	PULU DP,B
	PSHS DP,B,A
	PULU A
	PSHS A
	LEAS -37,S
	LDA  #$0F
	ANDA ,S
	ADDA ,U+
	STA  ,S
	PULU B,A
	PSHS B,A
	LEAS -38,S
	PULU B,A
	PSHS B,A
	LEAS -38,S
	PULU B,A
	PSHS B,A
	LEAS -5,S

	LDS  >SSAVE
	PULS U,DP
	RTS

DATA_TEST1X100000_1
	FDB $cccc
	FDB $7a77
	FDB $aca7
	FDB $cccc
	FDB $0cca
	FDB $aacc
	FDB $c7a7
	FDB $aac7
	FDB $cc73
	FDB $a77c
	FDB $c0c7
	FDB $3acc
	FDB $773c
	FDB $c337
	FDB $7cc0
	FDB $aa73
	FDB $0c33
	FDB $a7aa
	FDB $7acc
	FDB $a733
	FDB $77aa
	FDB $7a33
	FDB $0c48
	FDB $777a
	FDB $733c
	FDB $c00c
	FDB $44aa
	FDB $33a3
	FDB $c077
	FDB $a7cc
	FDB $a7a7
	FDB $c455
	FDB $c70c
	FDB $0cac
	FDB $55cc
	FDB $ccc4
	FDB $7a22
	FDB $c3c2
	FDB $44cc
	FDB $55c3
	FDB $c541
	FDB $c533
	FDB $5c14
	FDB $cc77
	FDB $cc8c
	FDB $7c41
	FDB $4448
	FDB $c4cc
	FDB $c444
	FDB $524c
	FDB $0c0c
	FDB $1425
	FDB $4ccb
	FDB $cc2b
	FDB $ccb8
	FDB $88c0
	FDB $0c88
	FDB $b8cc
	FDB $8844
	FDB $c0c7
	FDB $ccb8
	FDB $b3c8
	FDB $48c3
	FDB $22bc
	FDB $88c8
	FDB $848c
	FDB $ccb4
	FDB $11cc
	FDB $814c
	FDB $0c77
	FDB $b11c
	FDB $40c1
	FDB $cccc
	FDB $9b4c
	FDB $1bc4
	FDB $ac0c
	FDB $7c66
	FDB $bcb9
	FDB $0ccc
	FDB $996b
	FDB $0c88
	FDB $966b
	FDB $bb0c
	FDB $4899
	FDB $966b
	FDB $bb46
	FDB $46c4
	FDB $bcb4
	FDB $bbc4
	FDB $4bb0
	FDB $4b44
	FDB $0b14
	FDB $0ccc
	FDB $cc00
DATA_TEST1X100000_2
	FDB $cccc
	FDB $ccca
	FDB $aacc
	FDB $773a
	FDB $accc
	FDB $3cc7
	FDB $c0ca
	FDB $c00c
	FDB $ac0c
	FDB $7ccc
	FDB $acca
	FDB $a733
	FDB $7aca
	FDB $33c0
	FDB $3777
	FDB $0cac
	FDB $3770
	FDB $aa7c
	FDB $ca37
	FDB $aaca
	FDB $770c
	FDB $c0cc
	FDB $a377
	FDB $7a77
	FDB $84ca
	FDB $7a3a
	FDB $a34c
	FDB $8ca7
	FDB $a3a7
	FDB $cc73
	FDB $a337
	FDB $0c4c
	FDB $aa7a
	FDB $7cc0
	FDB $cacc
	FDB $c3c7
	FDB $c255
	FDB $ccc0
	FDB $4c55
	FDB $0cc0
	FDB $0c14
	FDB $2555
	FDB $30c1
	FDB $4455
	FDB $5c7c
	FDB $88c5
	FDB $5ccc
	FDB $c00c
	FDB $44cc
	FDB $5c44
	FDB $0cc7
	FDB $8cc0
	FDB $148c
	FDB $cc30
	FDB $41c8
	FDB $cc8c
	FDB $c0c4
	FDB $cc88
	FDB $cccc
	FDB $c244
	FDB $88c5
	FDB $25c4
	FDB $0044
	FDB $487c
	FDB $5c84
	FDB $4484
	FDB $4437
	FDB $cb84
	FDB $48cc
	FDB $44b0
	FDB $4c03
	FDB $bbb4
	FDB $c4c7
	FDB $ccb9
	FDB $bbcc
	FDB $b077
	FDB $b966
	FDB $ccb0
	FDB $7cb9
	FDB $9641
	FDB $c0b9
	FDB $694b
	FDB $9bc8
	FDB $0b64
	FDB $bb6b
	FDB $448c
	FDB $b04b
	FDB $8cb6
	FDB $bbb8
	FDB $4cbb
	FDB $140c
	FDB $484c
	FDB $bbc0
	FDB $c444
	FDB $4111
	FDB $cccc
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
