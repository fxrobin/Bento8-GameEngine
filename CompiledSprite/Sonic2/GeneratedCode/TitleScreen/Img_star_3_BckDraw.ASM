(main)IMGD.ASM
	ORG $A000
	SETDP $FF
BCKDRAW_Img_star_3
	STS SSAV_Img_star_3+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS -1,S

	LDX ,S
	PSHU X
	LDA -80,S
	PSHU A
	ANDA #$F0
	ORA #$0c
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
	ORA #$0c
	STA 80,S
	LDD #$b0bd
	STD ,S
DYN_POS

	LDS #$0000
	LEAS -160,S

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
	ORA #$c0
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
	LDA #$ac
	STA 80,S
	LDA #$0d
	STA 120,S
	LEAS 280,S

	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$00
	STD -121,S
	LDA -80,S
	PSHU A
	LDA #$0d
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
	ORA #$c0
	STA 80,S
	LDA 120,S
	PSHU S,A
	ANDA #$0F
	ORA #$d0
	STA 120,S
	LDA #$0c
	STA -40,S
	LEAS 160,S

	LDA ,S
	PSHU S,A
	ANDA #$0F
	ORA #$d0
	STA ,S
SSAV_Img_star_3
	LDS #$0000
	RTS

(info)

