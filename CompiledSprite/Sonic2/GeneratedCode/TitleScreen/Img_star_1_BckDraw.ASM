(main)IMGD.ASM
	ORG $A000
	SETDP $FF
BCKDRAW_Img_star_1
	STS SSAV_Img_star_1+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS -1,S

	LDA -80,S
	PSHU A
	ANDA #$F0
	ORA #$0c
	STA -80,S
	LDA 80,S
	PSHU S,A
	ANDA #$F0
	ORA #$0c
	STA 80,S
DYN_POS

	LDS #$0000
	LDA -80,S
	PSHU A
	ANDA #$F0
	ORA #$0c
	STA -80,S
	LDA ,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA ,S
	LDA 80,S
	PSHU S,A
	ANDA #$F0
	ORA #$0c
	STA 80,S
SSAV_Img_star_1
	LDS #$0000
	RTS

(info)

