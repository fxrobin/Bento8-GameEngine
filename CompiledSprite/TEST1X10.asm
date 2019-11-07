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

* 5 2
	LDX #$eeef
	STX -2,S
* 14 7
	LDX #$b885
	STX -42,S
* 23 13
	LDX #$ef15
	STX -82,S
* 32 19
	LDX #$1a1b
	STX -122,S
* 41 25
	LEAS -160,S

* 49 29
	LDA #$b1
	STA -1,S
* 56 33
	LDA  #$F0

* 58 35
	ANDA -2,S

* 63 37
	ADDA #$0b

* 65 39
	STA -2,S

* 70 41
	LDA #$15
	STA -41,S
* 77 46
	LDA  #$F0

* 79 48
	ANDA -42,S

* 84 51
	ADDA #$01

* 86 53
	STA -42,S

* 91 56
	LDA #$00
	STA -81,S
* 98 61
	LDA  #$F0

* 100 63
	ANDA -82,S

* 105 66
	ADDA #$01

* 107 68
	STA -82,S

* 112 71
	LDA  #$F0

* 114 73
	ANDA -121,S

* 119 76
	ADDA #$0d

* 121 78
	STA -121,S

* 126 81
	LEAS -161,S

* 134 85
	LDA  #$F0

* 136 87
	ANDA ,S

* 140 89
	ADDA #$0d

* 142 91
	STA ,S

* 146 93
	LDA #$ca
	STA -40,S
* 153 98
	LDA  #$F0

* 155 100
	ANDA -41,S

* 160 103
	ADDA #$0a

* 162 105
	STA -41,S

* 167 108
	LDA #$c5
	STA -80,S
* 174 113
	LDA  #$F0

* 176 115
	ANDA -81,S

* 181 118
	ADDA #$0a

* 183 120
	STA -81,S

* 188 123
	LDA  #$0F

* 190 125
	ANDA -119,S

* 195 128
	ADDA #$d0

* 197 130
	STA -119,S

* 202 133
	LDX #$a551
	STX -121,S
* 211 139
	LEAS -159,S

* 219 143
	LDA  #$0F

* 221 145
	ANDA ,S

* 225 147
	ADDA #$d0

* 227 149
	STA ,S

* 231 151
	LDX #$5a10
	STX -2,S
* 240 156
	LDA  #$0F

* 242 158
	ANDA -40,S

* 247 161
	ADDA #$c0

* 249 163
	STA -40,S

* 254 166
	LDX #$1a00
	STX -42,S
* 263 172
	LDA  #$0F

* 265 174
	ANDA -80,S

* 270 177
	ADDA #$90

* 272 179
	STA -80,S

* 277 182
	LDA #$00
	STA -81,S
* 284 187
	LDA  #$F0

* 286 189
	ANDA -82,S

* 291 192
	ADDA #$0f

* 293 194
	STA -82,S

* 298 197
	LDA #$c1
	STA -121,S
* 305 202
	LDA  #$F0

* 307 204
	ANDA -122,S

* 312 207
	ADDA #$07

* 314 209
	STA -122,S

* 319 212
	LEAS -160,S

* 327 216
	LDA #$cf
	STA -1,S
* 334 220
	LDA  #$F0

* 336 222
	ANDA -2,S

* 341 224
	ADDA #$04

* 343 226
	STA -2,S

* 348 228
	LDA #$db
	STA -41,S
* 355 233
	LDA  #$F0

* 357 235
	ANDA -42,S

* 362 238
	ADDA #$07

* 364 240
	STA -42,S

* 369 243
	LDA #$b2
	STA -81,S
* 376 248
	LDA  #$F0

* 378 250
	ANDA -82,S

* 383 253
	ADDA #$0b

* 385 255
	STA -82,S

* 390 258
	LDA #$df
	STA -121,S
* 397 263
	LEAS -159,S

* 405 267
	LDX #$bdcd
	STX -2,S
* 414 272
	LDA  #$F0

* 416 274
	ANDA -3,S

* 421 276
	ADDA #$0b

* 423 278
	STA -3,S

* 428 280
	LDX #$4ddc
	STX -42,S
* 437 286
	LDA  #$F0

* 439 288
	ANDA -43,S

* 444 291
	ADDA #$07

* 446 293
	STA -43,S

* 451 296
	LEAS -80,S

* 469 306
	LDA #$b2
	LDX #$27c9
	PSHS X,A
* 464 303
	LEAS -37,S

* 487 316
	LDA #$f0
	LDX #$2799
	PSHS X,A
* 482 313
	LDA  #$0F

* 489 318
	ANDA -38,S

* 494 321
	ADDA #$90

* 496 323
	STA -38,S

* 501 326
	LDX #$5009
	STX -40,S
* 510 332
	LDX #$ff69
	STX -80,S
* 519 338
	LDA  #$0F

* 521 340
	ANDA -118,S

* 526 343
	ADDA #$c0

* 528 345
	STA -118,S

* 533 348
	LDX #$ff66
	STX -120,S
* 542 354
	LEAS -157,S

* 550 358
	LDA #$9f
	LDX #$66dc
	PSHS X,A
* 563 365
	LEAS -37,S

* 581 375
	LDA #$69
	LDX #$66dd
	PSHS X,A
* 576 372
	LEAS -37,S

* 599 385
	LDA #$66
	LDX #$66cc
	PSHS X,A
* 594 382
	LEAS -37,S

* 617 395
	LDA #$63
	LDX #$3399
	PSHS X,A
* 612 392
	LDA  #$0F

* 619 397
	ANDA -38,S

* 624 400
	ADDA #$90

* 626 402
	STA -38,S

* 631 405
	LDX #$6366
	STX -40,S
* 640 411
	LDX #$9662
	STX -80,S
* 649 417
	LDX #$d6b2
	STX -120,S
* 658 423
	LEAS -158,S

* 666 427
	LDX #$c6c2
	STX -2,S
* 675 432
	LDX #$67dd
	STX -41,S
* 684 438
	LDA  #$0F

* 686 440
	ANDA -42,S

* 691 443
	ADDA #$c0

* 693 445
	STA -42,S

* 698 448
	LDX #$6ccc
	STX -81,S
* 707 454
	LDA  #$0F

* 709 456
	ANDA -82,S

* 714 459
	ADDA #$c0

* 716 461
	STA -82,S

* 721 464
	LDX #$9699
	STX -121,S
* 730 470
	LEAS -161,S

* 738 474
	LDA  #$F0

* 740 476
	ANDA ,S

* 744 478
	ADDA #$09

* 746 480
	STA ,S

* 750 482

	LDS POSB_TEST1X100000
	LDU #DATA_TEST1X100000_2

	LEAS -2,S

* 5 2
	LDA #$ff
	LDX #$eefe
	PSHS X,A
* 18 9
	LEAS -37,S

* 36 19
	LDA #$be
	LDX #$88be
	PSHS X,A
* 31 16
	LDX #$28be
	STX -39,S
* 45 25
	LDA  #$F0

* 47 27
	ANDA -40,S

* 52 30
	ADDA #$0b

* 54 32
	STA -40,S

* 59 35
	LDA  #$0F

* 61 37
	ANDA -78,S

* 66 40
	ADDA #$b0

* 68 42
	STA -78,S

* 73 45
	LDA #$f0
	STA -79,S
* 80 50
	LDA  #$0F

* 82 52
	ANDA -118,S

* 87 55
	ADDA #$f0

* 89 57
	STA -118,S

* 94 60
	LDA #$51
	STA -119,S
* 101 65
	LEAS -158,S

* 109 69
	LDA  #$0F

* 111 71
	ANDA ,S

* 115 73
	ADDA #$a0

* 117 75
	STA ,S

* 121 77
	LDA #$af
	STA -1,S
* 128 81
	LDA  #$0F

* 130 83
	ANDA -40,S

* 135 86
	ADDA #$50

* 137 88
	STA -40,S

* 142 91
	LDA #$5a
	STA -41,S
* 149 96
	LDA  #$0F

* 151 98
	ANDA -81,S

* 156 101
	ADDA #$c0

* 158 103
	STA -81,S

* 163 106
	LDA  #$0F

* 165 108
	ANDA -121,S

* 170 111
	ADDA #$c0

* 172 113
	STA -121,S

* 177 116
	LEAS -161,S

* 185 120
	LDA  #$0F

* 187 122
	ANDA ,S

* 191 124
	ADDA #$c0

* 193 126
	STA ,S

* 197 128
	LDA  #$0F

* 199 130
	ANDA -39,S

* 204 133
	ADDA #$a0

* 206 135
	STA -39,S

* 211 138
	LDA  #$0F

* 213 140
	ANDA -40,S

* 218 143
	ADDA #$d0

* 220 145
	STA -40,S

* 225 148
	LDA  #$0F

* 227 150
	ANDA -79,S

* 232 153
	ADDA #$50

* 234 155
	STA -79,S

* 239 158
	LDA  #$0F

* 241 160
	ANDA -80,S

* 246 163
	ADDA #$d0

* 248 165
	STA -80,S

* 253 168
	LDX #$fdac
	STX -120,S
* 262 174
	LEAS -158,S

* 270 178
	LDX #$cc5e
	STX -2,S
* 279 183
	LDX #$7b07
	STX -42,S
* 288 189
	LDX #$24d4
	STX -82,S
* 297 195
	LDX #$2272
	STX -122,S
* 306 201
	LEAS -160,S

* 314 205
	LDX #$2229
	STX -2,S
* 323 210
	LDA  #$0F

* 325 212
	ANDA -41,S

* 330 215
	ADDA #$d0

* 332 217
	STA -41,S

* 337 220
	LDA #$47
	STA -42,S
* 344 225
	LDX #$efcc
	STX -82,S
* 353 231
	LDA  #$0F

* 355 233
	ANDA -120,S

* 360 236
	ADDA #$90

* 362 238
	STA -120,S

* 367 241
	LDX #$77dd
	STX -122,S
* 376 247
	LEAS -160,S

* 384 251
	LDX #$22fd
	STX -2,S
* 393 256
	LDX #$22dd
	STX -42,S
* 402 262
	LDX #$00dd
	STX -82,S
* 411 268
	LDA  #$F0

* 413 270
	ANDA -83,S

* 418 273
	ADDA #$0f

* 420 275
	STA -83,S

* 425 278
	LDX #$06cd
	STX -122,S
* 434 284
	LDA  #$F0

* 436 286
	ANDA -123,S

* 441 289
	ADDA #$0f

* 443 291
	STA -123,S

* 448 294
	LEAS -160,S

* 456 298
	LDX #$009d
	STX -2,S
* 465 303
	STX -42,S
* 471 306
	LEAS -79,S

* 489 316
	LDA #$00
	LDX #$9dcc
	PSHS X,A
* 484 313
	LDA  #$0F

* 491 318
	ANDA -38,S

* 496 321
	ADDA #$d0

* 498 323
	STA -38,S

* 503 326
	LDX #$009c
	STX -40,S
* 512 332
	LDA  #$0F

* 514 334
	ANDA -78,S

* 519 337
	ADDA #$90

* 521 339
	STA -78,S

* 526 342
	LDX #$109c
	STX -80,S
* 535 348
	LDX #$909c
	STX -120,S
* 544 354
	LEAS -158,S

* 552 358
	LDX #$699c
	STX -2,S
* 561 363
	LDX #$33d9
	STX -42,S
* 570 369
	LDX #$33dc
	STX -82,S
* 579 375
	LDX #$63dd
	STX -122,S
* 588 381
	LEAS -160,S

* 596 385
	LDX #$66cc
	STX -2,S
* 605 390
	LDA  #$0F

* 607 392
	ANDA -40,S

* 612 395
	ADDA #$c0

* 614 397
	STA -40,S

* 619 400
	LDA #$99
	STA -41,S
* 626 405
	LDA  #$F0

* 628 407
	ANDA -42,S

* 633 410
	ADDA #$06

* 635 412
	STA -42,S

* 640 415
	LDA #$66
	STA -81,S
* 647 420
	LDA #$99
	STA -121,S
* 654 425

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
