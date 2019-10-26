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

	LDX #$cccc
	STX ,--S
	LEAS -5,S
	STX ,--S
	LEAS -31,S
	LDX #$cc7a
	STX ,--S
	LEAS -5,S
	LDX #$77ac
	STX ,--S
	LEAS -31,S
	LDX #$a7cc
	STX ,--S
	LEAS -5,S
	LDX #$cccc
	STX ,--S
	LEAS -32,S
	LDA #$ca
	STA ,-S
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LEAS -3,S
	LDX #$aacc
	STX ,--S
	LEAS -33,S
	LDX #$c7a7
	STX ,--S
	LEAS -3,S
	LDX #$aac7
	STX ,--S
	LEAS -33,S
	LDX #$aacc
	STX ,--S
	LEAS -3,S
	LDX #$cc73
	STX ,--S
	LEAS -33,S
	LDX #$a77c
	STX ,--S
	LEAS -3,S
	LDA  #$0F
	ANDA ,S
	ADDA #$c0
	STA  ,S
	LDX #$c73a
	STX ,--S
	LEAS -33,S
	LDA #$cc
	LDX #$773c
	PSHS X,A
	LEAS -1,S
	LDA #$c3
	LDX #$377c
	PSHS X,A
	LEAS -34,S
	LDA  #$0F
	ANDA ,S
	ADDA #$c0
	STA  ,S
	LDX #$aa73
	STX ,--S
	LEAS -1,S
	LDX #$33a7
	STX ,--S
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LEAS -34,S
	LDA #$aa
	LDX #$7acc
	LDY #$a733
	PSHS Y,X,A
	LEAS -35,S
	LDA #$cc
	LDX #$77aa
	LDY #$7a33
	PSHS Y,X,A
	LEAS -35,S
	LDA #$48
	LDX #$777a
	LDY #$733c
	PSHS Y,X,A
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LEAS -35,S
	LDA  #$0F
	ANDA ,S
	ADDA #$c0
	STA  ,S
	LDA #$44
	LDB #$aa
	LDX #$33a3
	PSHS X,B,A
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LEAS -35,S
	LDA  #$0F
	ANDA ,S
	ADDA #$c0
	STA  ,S
	LDA #$44
	LDX #$77a7
	PSHS X,B,A
	LEAS -36,S
	LDB #$cc
	LDX #$a7a7
	PSHS X,B,A
	LEAS -36,S
	LDA #$c4
	LDB #$55
	LDX #$c70c
	PSHS X,B,A
	LEAS -36,S
	LDA #$ac
	LDX #$cccc
	PSHS X,B,A
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LEAS -35,S
	LDA #$c4
	LDX #$7a22
	LDY #$c3c2
	PSHS Y,X,A
	LEAS -35,S
	LDA #$44
	LDX #$cc55
	LDY #$c3c5
	PSHS Y,X,A
	LEAS -35,S
	LDA #$41
	LDX #$c555
	LDY #$335c
	PSHS Y,X,A
	LEAS -35,S
	LDA #$14
	LDX #$cc55
	LDY #$77cc
	PSHS Y,X,A
	LEAS -35,S
	LDX #$8c55
	LDY #$7c41
	PSHS Y,X,A
	LEAS -35,S
	LDA #$44
	LDX #$4855
	LDY #$c4cc
	PSHS Y,X,A
	LEAS -35,S
	LDA #$c4
	LDX #$4452
	LDY #$4c0c
	PSHS Y,X,A
	LEAS -34,S
	LDA #$14
	LDX #$254c
	LDY #$cbcc
	PSHS Y,X,A
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LEAS -34,S
	LDA #$14
	LDX #$2bcc
	LDY #$b888
	PSHS Y,X,A
	LEAS -35,S
	LDA  #$0F
	ANDA ,S
	ADDA #$c0
	STA  ,S
	LDA #$88
	LDX #$b8cc
	LDY #$8844
	PSHS Y,X,A
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LEAS -34,S
	LDA  #$0F
	ANDA ,S
	ADDA #$c0
	STA  ,S
	LDA #$c7
	LDB #$cc
	LDX #$b8b3
	LDY #$c848
	PSHS Y,X,B,A
	LEAS -33,S
	PULU Y,X,DP,B,A
	PSHS Y,X,DP,B,A
	LEAS -33,S
	PULU Y,X,DP,B
	PSHS Y,X,DP,B,A
	LEAS -33,S
	LDA #$77
	LDB #$b1
	LDX #$1c40
	LDY #$c1cc
	PSHS Y,X,B,A
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LEAS -33,S
	LDA #$cc
	LDB #$9b
	LDX #$4c1b
	LDY #$c4ac
	PSHS Y,X,B,A
	LEAS -34,S
	LDA #$7c
	STA ,-S
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LDA #$66
	LDX #$bcb9
	PSHS X,A
	LEAS -35,S
	LDA #$cc
	STA ,-S
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LDA #$99
	LDX #$6bb9
	PSHS X,A
	LEAS -35,S
	LDA #$88
	STA ,-S
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LDA #$96
	LDX #$6bbb
	PSHS X,A
	LEAS -35,S
	LDA #$48
	STA ,-S
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LDA #$99
	LDX #$966b
	PSHS X,A
	LEAS -35,S
	LDA #$bb
	LDX #$4646
	LDY #$c4bc
	PSHS Y,X,A
	LEAS -35,S
	LDA #$b4
	LDB #$bb
	LDX #$c44b
	PSHS X,B,A
	LEAS -36,S
	LDX #$4b44
	STX ,--S
	LEAS -1,S
	LDA  #$0F
	ANDA ,S
	ADDA #$b0
	STA  ,S
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0b
	STA  ,S
	LEAS -36,S
	LDX #$4b14
	STX ,--S
	LEAS -38,S
	LDX #$cccc
	STX ,--S
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LEAS -76,S

	LDS >POS_TEST1X100000
	LEAS 8192,S
	LDU #DATA_TEST1X100000_2

	LDA #$cc
	LDX #$cccc
	PSHS X,A
	LEAS -4,S
	PSHS X,A
	LEAS -30,S
	LDA #$ca
	LDX #$aacc
	PSHS X,A
	LEAS -4,S
	LDA #$cc
	PSHS X,A
	LEAS -31,S
	LDX #$cc77
	STX ,--S
	LEAS -4,S
	LDX #$3aac
	STX ,--S
	LEAS -32,S
	LDX #$cc3c
	STX ,--S
	LEAS -4,S
	LDX #$c7cc
	STX ,--S
	LEAS -33,S
	LDA  #$0F
	ANDA ,S
	ADDA #$c0
	STA  ,S
	LDA #$ca
	STA ,-S
	LEAS -4,S
	LDA  #$0F
	ANDA ,S
	ADDA #$c0
	STA  ,S
	LDA #$ac
	STA ,-S
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LEAS -33,S
	LDA #$7c
	STA ,-S
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LEAS -2,S
	LDX #$ccac
	STX ,--S
	LEAS -34,S
	LDX #$caa7
	STX ,--S
	LEAS -2,S
	LDX #$337a
	STX ,--S
	LEAS -34,S
	LDX #$ca33
	STX ,--S
	LEAS -2,S
	LDA  #$0F
	ANDA ,S
	ADDA #$c0
	STA  ,S
	LDX #$3777
	STX ,--S
	LEAS -34,S
	LDX #$ac37
	STX ,--S
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LDA #$70
	LDX #$aa7c
	PSHS X,A
	LEAS -34,S
	LDA #$ca
	LDB #$37
	LDX #$aaca
	LDY #$770c
	PSHS Y,X,B,A
	LEAS -35,S
	LDA  #$0F
	ANDA ,S
	ADDA #$c0
	STA  ,S
	LDA #$cc
	LDX #$a377
	LDY #$7a77
	PSHS Y,X,A
	LEAS -35,S
	LDA #$84
	LDX #$ca7a
	LDY #$3aa3
	PSHS Y,X,A
	LEAS -35,S
	LDA #$4c
	LDX #$8ca7
	LDY #$a3a7
	PSHS Y,X,A
	LEAS -35,S
	LDA #$cc
	LDX #$8c73
	LDY #$a337
	PSHS Y,X,A
	LEAS -35,S
	LDA #$4c
	LDB #$aa
	LDX #$7a7c
	PSHS X,B,A
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LEAS -36,S
	LDA  #$0F
	ANDA ,S
	ADDA #$c0
	STA  ,S
	LDA #$ca
	LDB #$4c
	LDX #$ccc3
	PSHS X,B,A
	LEAS -36,S
	LDA #$c7
	LDB #$c2
	LDX #$55cc
	PSHS X,B,A
	LEAS -36,S
	LDA  #$0F
	ANDA ,S
	ADDA #$c0
	STA  ,S
	LDA #$4c
	LDX #$550c
	PSHS X,B,A
	LEAS -36,S
	LDA  #$0F
	ANDA ,S
	ADDA #$c0
	STA  ,S
	LDA #$14
	LDB #$25
	LDX #$5530
	PSHS X,B,A
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LEAS -35,S
	LDA #$c1
	LDX #$4455
	LDY #$5c7c
	PSHS Y,X,A
	LEAS -35,S
	LDX #$88c5
	LDY #$5ccc
	PSHS Y,X,A
	LEAS -35,S
	LDA  #$0F
	ANDA ,S
	ADDA #$c0
	STA  ,S
	LDA #$44
	LDB #$cc
	LDX #$5c44
	PSHS X,B,A
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LEAS -35,S
	LDA #$44
	LDX #$c78c
	PSHS X,B,A
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LEAS -35,S
	LDA  #$0F
	ANDA ,S
	ADDA #$c0
	STA  ,S
	LDA #$14
	LDB #$8c
	LDX #$cc30
	PSHS X,B,A
	LEAS -35,S
	LDA #$41
	LDX #$8cc8
	LDY #$cc8c
	PSHS Y,X,A
	LEAS -34,S
	LDA #$c0
	LDX #$c4cc
	LDY #$88cc
	PSHS Y,X,B,A
	LEAS -34,S
	LDA #$cc
	LDB #$c2
	LDY #$4488
	PSHS Y,X,B,A
	LEAS -34,S
	LDA #$c5
	LDB #$25
	LDX #$c400
	LDY #$4448
	PSHS Y,X,B,A
	LEAS -34,S
	LDA #$7c
	LDB #$5c
	LDX #$8444
	LDY #$8444
	PSHS Y,X,B,A
	LEAS -34,S
	LDA #$37
	LDB #$cb
	LDX #$8448
	LDY #$cc44
	PSHS Y,X,B,A
	LEAS -34,S
	LDA #$4c
	STA ,-S
	LEAS -1,S
	LDA  #$0F
	ANDA ,S
	ADDA #$b0
	STA  ,S
	LDA #$03
	LDB #$bb
	LDX #$b4c4
	PSHS X,B,A
	LEAS -34,S
	LDA #$c7
	STA ,-S
	LEAS -1,S
	LDA #$cc
	LDB #$b9
	LDX #$bbcc
	PSHS X,B,A
	LEAS -34,S
	LDA #$77
	STA ,-S
	LEAS -1,S
	LDA  #$0F
	ANDA ,S
	ADDA #$b0
	STA  ,S
	LDX #$66cc
	PSHS X,B
	LEAS -35,S
	LDA #$7c
	STA ,-S
	LEAS -1,S
	LDA  #$0F
	ANDA ,S
	ADDA #$b0
	STA  ,S
	LDX #$9641
	PSHS X,B
	LEAS -35,S
	LDA  #$0F
	ANDA ,S
	ADDA #$c0
	STA  ,S
	LDX #$694b
	LDY #$9bc8
	PSHS Y,X,B
	LEAS -34,S
	LDA #$64
	LDX #$bb6b
	LDY #$448c
	PSHS Y,X,A
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0b
	STA  ,S
	LEAS -34,S
	LDX #$4b8c
	STX ,--S
	LEAS -1,S
	LDA  #$0F
	ANDA ,S
	ADDA #$b0
	STA  ,S
	LDX #$b6bb
	STX ,--S
	LEAS -35,S
	LDX #$b84c
	STX ,--S
	LEAS -1,S
	LDX #$bb14
	STX ,--S
	LEAS -35,S
	LDX #$484c
	STX ,--S
	LEAS -1,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0c
	STA  ,S
	LDA #$bb
	STA ,-S
	LEAS -37,S
	LDA  #$0F
	ANDA ,S
	ADDA #$c0
	STA  ,S
	LDX #$c444
	STX ,--S
	LEAS -38,S
	LDX #$4111
	STX ,--S
	LEAS -38,S
	LDX #$cccc
	STX ,--S
	LEAS -5,S

	LDS  >SSAVE
	PULS U,DP
	RTS

DATA_TEST1X100000_1
	FDB $c322
	FDB $bc88
	FDB $c884
	FDB $8ccc
	FDB $b411
	FDB $cc81
	FDB $4c00
DATA_TEST1X100000_2
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
