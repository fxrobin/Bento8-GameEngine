(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_TitleScreen_Star_1
	STS SSAV_Img_TitleScreen_Star_1+2,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS 3812,S

	LDA -80,S
	PSHU A
	ANDA #$F0
	ORA #$0b
	STA -80,S
	LDA 80,S
	PSHU S,A
	ANDA #$F0
	ORA #$0b
	STA 80,S
DYN_POS

	LDS #$0000
	LEAS 3813,S

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
SSAV_Img_TitleScreen_Star_1
	LDS #$0000
	RTS

