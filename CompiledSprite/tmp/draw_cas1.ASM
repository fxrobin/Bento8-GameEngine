(main)IMGD.ASM
	ORG $A000
	SETDP $FF
BCKDRAW_Img_star_1
	STS SSAV_Img_star_1+1,PCR  ; bckp pile systeme

	STD DYN_POS+2,PCR       ; D sauvegarde vers S ptr sur memoire video RAMB
	LDS ,Y                  ; S ptr sur memoire video RAMA
	LEAS -1,S               ; offset de départ

; dans ce cas pas d'optim de valeur de registre possible

; noeud 1
	LDA -80,S               
	PSHU A                  ; background backup vers U 
	ANDA #$F0
	ORA #$0b                ; couleur cible : b
	STA -80,S
	LDA 80,S
	PSHU S,A                ; background backup vers U avec sauvegarde de S
	ANDA #$F0
	ORA #$0b
	STA 80,S
DYN_POS

	LDS #$0000
	LDA -80,S
	PSHU A
	ANDA #$F0
	ORA #$0b
	STA -80,S
	LDA ,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA ,S
	LDA 80,S
	PSHU S,A
	ANDA #$F0
	ORA #$0b
	STA 80,S
SSAV_Img_star_1
	LDS #$0000
	RTS

