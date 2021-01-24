(main)IMGD.ASM
	ORG $A000
	SETDP $FF
BCKDRAW_Img_TitleScreen_Star_2
	STS SSAV_Img_TitleScreen_Star_2+2,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS 3812,S

	LDA ,S
	PSHU S,A
	ANDA #$F0
	ORA #$0b
	STA ,S
DYN_POS

	LDS #$0000
	LEAS 3813,S

	LDA ,S
	LDB -120,S
	PSHU B,A
	ANDB #$0F
	ORB #$d0
	STB -120,S
	LDA -80,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA -80,S
	LDA -40,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA -40,S
	LDA 40,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA 40,S
	LDA 80,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA 80,S
	LDA 120,S
	PSHU S,A
	ANDA #$0F
	ORA #$d0
	STA 120,S
	LDA #$ab
	STA ,S
SSAV_Img_TitleScreen_Star_2
	LDS #$0000
	RTS

