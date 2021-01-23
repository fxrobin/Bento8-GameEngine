(main)IMG.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_TitleScreen_TailsHand
	STS SSAV_Img_TitleScreen_TailsHand+2,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS 4214,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0ad0
	STD -80,S
	LDA -120,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA -120,S
	LDD -40,S
	PSHU D
	LDA #$da
	ANDB #$0F
	ORB #$a0
	STD -40,S
	LDX 120,S
	LDY 80,S
	PSHU Y,X
	LDD 40,S
	LDX ,S
	PSHU S,X,D
	LDD #$ddad
	STD ,S
	LDD #$baab
	STD 80,S
	STD 120,S
	LDA #$ad
	STD 40,S
	LEAS 280,S

	LDX ,S
	LDY -40,S
	PSHU Y,X
	LDA 120,S
	LDX -80,S
	LDY -120,S
	PSHU Y,X,A
	LDD #$dbab
	STD -120,S
	STA 120,S
	LDD 40,S
	PSHU D
	LDA #$ad
	ANDB #$0F
	ORB #$d0
	STD 40,S
	LDD 80,S
	PSHU S,D
	LDA #$ab
	ANDB #$0F
	ORB #$d0
	STD 80,S
	LDD #$ddbb
	STD -80,S
	LDB #$bd
	STD -40,S
	LDA #$bd
	STD ,S
	LEAS 220,S

	LDA -60,S
	LDB -20,S
	PSHU B,A
	LDA #$4b
	STA -60,S
	LDA #$6d
	STA -20,S
	LDA 20,S
	LDB 60,S
	PSHU S,B,A
	LDA #$94
	STA 20,S
	LDA #$96
	STA 60,S
DYN_POS

	LDS #$0000
	LEAS 4175,S

	LDA -120,S
	LDB 40,S
	PSHU B,A
	LDA #$dd
	STA -120,S
	LDA 120,S
	LDB 80,S
	PSHU B,A
	LDA -40,S
	LDB ,S
	PSHU B,A
	LDA #$ab
	STA 120,S
	LDA -80,S
	PSHU S,A
	LDA #$ba
	STA ,S
	LDA #$aa
	STA -80,S
	STA -40,S
	STA 40,S
	STA 80,S
	LEAS 280,S

	LDA 120,S
	LDB ,S
	PSHU B,A
	LDA -80,S
	LDB 80,S
	PSHU B,A
	LDA -120,S
	PSHU A
	LDA #$da
	STA -80,S
	LDA -40,S
	LDB 40,S
	PSHU S,B,A
	LDA #$db
	STA -40,S
	STA ,S
	STA 40,S
	LDA #$dd
	STA 80,S
	STA 120,S
	LDA #$ba
	STA -120,S
	LEAS 240,S

	LDA -80,S
	LDB 79,S
	PSHU B,A
	LDA #$dd
	STA -80,S
	LDD -41,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$06d0
	STD -41,S
	LDD -1,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$09d0
	STD -1,S
	LDD 39,S
	PSHU S,D
	LDA #$69
	ANDB #$0F
	ORB #$d0
	STD 39,S
	STA 79,S
SSAV_Img_TitleScreen_TailsHand
	LDS #$0000
	RTS

ERASE_Img_TitleScreen_TailsHand
	STS ERASE_SSAV_Img_TitleScreen_TailsHand+2,PCR

ERASE_CODE_Img_TitleScreen_TailsHand_1
	PULU D,S
	STD 39,S

	PULU D,X
	STD -1,S
	STX -41,S

	PULU A,B
	STA -80,S
	STB 79,S

	PULU A,B,S
	STA -40,S
	STB 40,S

	PULU A,B
	STA -120,S
	STB -80,S

	PULU A,B
	STA 80,S
	STB 120,S

	PULU A
	STA ,S

	PULU A,S
	STA -80,S

	PULU A,B
	STA -40,S
	STB ,S

	PULU A,B
	STA 120,S
	STB 80,S

	PULU A,B
	STA -120,S
	STB 40,S

	PULU A,B,S
	STA 20,S
	STB 60,S

	PULU A,B
	STA -60,S
	STB -20,S

	PULU D,S
	STD 80,S

	PULU D
	STD 40,S

	PULU A,X,Y
	STA 120,S
	STX -80,S
	STY -120,S

	PULU D,X
	STD ,S
	STX -40,S

	PULU D,X,S
	STD 40,S
	STX ,S

	PULU D,X,Y
	STD 120,S
	STX 80,S
	STY -40,S

	PULU A,X
	STA -120,S
	STX -80,S

ERASE_SSAV_Img_TitleScreen_TailsHand
	LDS #$0000
	RTS

