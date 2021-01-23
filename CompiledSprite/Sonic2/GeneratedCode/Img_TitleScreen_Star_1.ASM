(main)IMG.ASM
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

ERASE_Img_TitleScreen_Star_1
	STS ERASE_SSAV_Img_TitleScreen_Star_1+2,PCR

ERASE_CODE_Img_TitleScreen_Star_1_1
	PULU A,S
	STA 80,S

	PULU A,B
	STA ,S
	STB -80,S

	PULU A,S
	STA 80,S

	PULU A
	STA -80,S

ERASE_SSAV_Img_TitleScreen_Star_1
	LDS #$0000
	RTS

