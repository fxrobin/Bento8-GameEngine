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
	JSR SCRC
	JSR EFF
	JSR SCRC
	JSR EFF
	JSR SCRC        * changement de page ecran
********************************************************************************
* Boucle principale
********************************************************************************
	LDB #$03
	STB $E7E5
MAIN
	JSR DRAWBCKGRN
	JSR DRAW_TEST1X100000
	LDX POSA_TEST1X100000	* avance de 2 px a gauche
	LDY POSB_TEST1X100000
	STX POSB_TEST1X100000
	LEAY -1,Y
	STY POSA_TEST1X100000
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

	LDS POSA_TEST1X100000
	LDU #DATA_TEST1X100000_1

	LEAS -2,S
	LDX #$eeef
	STX -2,S
	LDX #$b885
	STX -42,S
	LDX #$ef15
	STX -82,S
	LDX #$1a1b
	STX -122,S
	LEAS -160,S
	LDA #$b1
	STA -1,S
	LDA  #$F0
	ANDA -2,S
	ADDA #$0b
	STA -2,S
	LDA #$15
	STA -41,S
	LDA  #$F0
	ANDA -42,S
	ADDA #$01
	STA -42,S
	LDA #$00
	STA -81,S
	LDA  #$F0
	ANDA -82,S
	ADDA #$01
	STA -82,S
	LDA  #$F0
	ANDA -121,S
	ADDA #$0d
	STA -121,S
	LEAS -161,S
	LDA  #$F0
	ANDA ,S
	ADDA #$0d
	STA ,S
	LDA #$ca
	STA -40,S
	LDA  #$F0
	ANDA -41,S
	ADDA #$0a
	STA -41,S
	LDA #$c5
	STA -80,S
	LDA  #$F0
	ANDA -81,S
	ADDA #$0a
	STA -81,S
	LDA  #$0F
	ANDA -119,S
	ADDA #$d0
	STA -119,S
	LDX #$a551
	STX -121,S
	LEAS -159,S
	LDA  #$0F
	ANDA ,S
	ADDA #$d0
	STA ,S
	LDX #$5a10
	STX -2,S
	LDA  #$0F
	ANDA -40,S
	ADDA #$c0
	STA -40,S
	LDX #$1a00
	STX -42,S
	LDA  #$0F
	ANDA -80,S
	ADDA #$90
	STA -80,S
	LDA #$00
	STA -81,S
	LDA  #$F0
	ANDA -82,S
	ADDA #$0f
	STA -82,S
	LDA #$c1
	STA -121,S
	LDA  #$F0
	ANDA -122,S
	ADDA #$07
	STA -122,S
	LEAS -160,S
	LDA #$cf
	STA -1,S
	LDA  #$F0
	ANDA -2,S
	ADDA #$04
	STA -2,S
	LDA #$db
	STA -41,S
	LDA  #$F0
	ANDA -42,S
	ADDA #$07
	STA -42,S
	LDA #$b2
	STA -81,S
	LDA  #$F0
	ANDA -82,S
	ADDA #$0b
	STA -82,S
	LDA #$df
	STA -121,S
	LEAS -159,S
	LDX #$bdcd
	STX -2,S
	LDA  #$F0
	ANDA -3,S
	ADDA #$0b
	STA -3,S
	LDX #$4ddc
	STX -42,S
	LDA  #$F0
	ANDA -43,S
	ADDA #$07
	STA -43,S
	LEAS -80,S
	LDA #$b2
	LDX #$27c9
	PSHS X,A
	LEAS -37,S
	LDA #$f0
	LDX #$2799
	PSHS X,A
	LDA  #$0F
	ANDA -38,S
	ADDA #$90
	STA -38,S
	LDX #$5009
	STX -40,S
	LDX #$ff69
	STX -80,S
	LDA  #$0F
	ANDA -118,S
	ADDA #$c0
	STA -118,S
	LDX #$ff66
	STX -120,S
	LEAS -157,S
	LDA #$9f
	LDX #$66dc
	PSHS X,A
	LEAS -37,S
	LDA #$69
	LDX #$66dd
	PSHS X,A
	LEAS -37,S
	LDA #$66
	LDX #$66cc
	PSHS X,A
	LEAS -37,S
	LDA #$63
	LDX #$3399
	PSHS X,A
	LDA  #$0F
	ANDA -38,S
	ADDA #$90
	STA -38,S
	LDX #$6366
	STX -40,S
	LDX #$9662
	STX -80,S
	LDX #$d6b2
	STX -120,S
	LEAS -158,S
	LDX #$c6c2
	STX -2,S
	LDX #$67dd
	STX -41,S
	LDA  #$0F
	ANDA -42,S
	ADDA #$c0
	STA -42,S
	LDX #$6ccc
	STX -81,S
	LDA  #$0F
	ANDA -82,S
	ADDA #$c0
	STA -82,S
	LDX #$9699
	STX -121,S
	LEAS -161,S
	LDA  #$F0
	ANDA ,S
	ADDA #$09
	STA ,S

	LDS POSB_TEST1X100000
	LDU #DATA_TEST1X100000_2

	LEAS -2,S
	LDA #$ff
	LDX #$eefe
	PSHS X,A
	LEAS -37,S
	LDA #$be
	LDX #$88be
	PSHS X,A
	LDX #$28be
	STX -39,S
	LDA  #$F0
	ANDA -40,S
	ADDA #$0b
	STA -40,S
	LDA  #$0F
	ANDA -78,S
	ADDA #$b0
	STA -78,S
	LDA #$f0
	STA -79,S
	LDA  #$0F
	ANDA -118,S
	ADDA #$f0
	STA -118,S
	LDA #$51
	STA -119,S
	LEAS -158,S
	LDA  #$0F
	ANDA ,S
	ADDA #$a0
	STA ,S
	LDA #$af
	STA -1,S
	LDA  #$0F
	ANDA -40,S
	ADDA #$50
	STA -40,S
	LDA #$5a
	STA -41,S
	LDA  #$0F
	ANDA -81,S
	ADDA #$c0
	STA -81,S
	LDA  #$0F
	ANDA -121,S
	ADDA #$c0
	STA -121,S
	LEAS -161,S
	LDA  #$0F
	ANDA ,S
	ADDA #$c0
	STA ,S
	LDA  #$0F
	ANDA -39,S
	ADDA #$a0
	STA -39,S
	LDA  #$0F
	ANDA -40,S
	ADDA #$d0
	STA -40,S
	LDA  #$0F
	ANDA -79,S
	ADDA #$50
	STA -79,S
	LDA  #$0F
	ANDA -80,S
	ADDA #$d0
	STA -80,S
	LDX #$fdac
	STX -120,S
	LEAS -158,S
	LDX #$cc5e
	STX -2,S
	LDX #$7b07
	STX -42,S
	LDX #$24d4
	STX -82,S
	LDX #$2272
	STX -122,S
	LEAS -160,S
	LDX #$2229
	STX -2,S
	LDA  #$0F
	ANDA -41,S
	ADDA #$d0
	STA -41,S
	LDA #$47
	STA -42,S
	LDX #$efcc
	STX -82,S
	LDA  #$0F
	ANDA -120,S
	ADDA #$90
	STA -120,S
	LDX #$77dd
	STX -122,S
	LEAS -160,S
	LDX #$22fd
	STX -2,S
	LDX #$22dd
	STX -42,S
	LDX #$00dd
	STX -82,S
	LDA  #$F0
	ANDA -83,S
	ADDA #$0f
	STA -83,S
	LDX #$06cd
	STX -122,S
	LDA  #$F0
	ANDA -123,S
	ADDA #$0f
	STA -123,S
	LEAS -160,S
	LDX #$009d
	STX -2,S
	STX -42,S
	LEAS -79,S
	LDA #$00
	LDX #$9dcc
	PSHS X,A
	LDA  #$0F
	ANDA -38,S
	ADDA #$d0
	STA -38,S
	LDX #$009c
	STX -40,S
	LDA  #$0F
	ANDA -78,S
	ADDA #$90
	STA -78,S
	LDX #$109c
	STX -80,S
	LDX #$909c
	STX -120,S
	LEAS -158,S
	LDX #$699c
	STX -2,S
	LDX #$33d9
	STX -42,S
	LDX #$33dc
	STX -82,S
	LDX #$63dd
	STX -122,S
	LEAS -160,S
	LDX #$66cc
	STX -2,S
	LDA  #$0F
	ANDA -40,S
	ADDA #$c0
	STA -40,S
	LDA #$99
	STA -41,S
	LDA  #$F0
	ANDA -42,S
	ADDA #$06
	STA -42,S
	LDA #$66
	STA -81,S
	LDA #$99
	STA -121,S

	LDS  >SSAVE
	PULS U,DP
	RTS

DATA_TEST1X100000_1
DATA_TEST1X100000_2
POSA_TEST1X100000
	FDB $1F40
POSB_TEST1X100000
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
