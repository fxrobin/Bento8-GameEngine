(main)IMGD.ASM
	ORG $A000
	SETDP $FF
BCKDRAW_Img_TitleScreen_Star_3
	STS SSAV_Img_TitleScreen_Star_3+2,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS 3812,S

	LDX ,S
	PSHU X
	LDA -80,S
	PSHU A
	ANDA #$F0
	ORA #$0b
	STA -80,S
	LDA -40,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA -40,S
	LDA 40,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA 40,S
	LDA 80,S
	PSHU S,A
	ANDA #$F0
	ORA #$0b
	STA 80,S
	LDD #$babd
	STD ,S
DYN_POS

	LDS #$0000
	LEAS 3653,S

	LDA -120,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -120,S
	LDA -80,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -80,S
	LDA -40,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA -40,S
	LDA ,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA ,S
	LDA 40,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA 40,S
	LDA 80,S
	LDB 120,S
	PSHU S,B,A
	LDA #$ab
	STA 80,S
	LDA #$ad
	STA 120,S
	LEAS 280,S

	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$aa
	STD -121,S
	LDA -80,S
	PSHU A
	LDA #$ad
	STA -80,S
	LDA -40,S
	LDB ,S
	PSHU B,A
	ANDB #$0F
	ORB #$a0
	STB ,S
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
	STA -40,S
	LEAS 160,S

	LDA ,S
	PSHU S,A
	ANDA #$0F
	ORA #$d0
	STA ,S
SSAV_Img_TitleScreen_Star_3
	LDS #$0000
	RTS

