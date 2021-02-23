(main)IMGD.ASM
	ORG $A000
	SETDP $FF
BCKDRAW_Img_star_2
	STS SSAV_Img_star_2+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS -1,S

	LDA ,S
	PSHU S,A
	ANDA #$F0
	ORA #$0c
	STA ,S
DYN_POS

	LDS #$0000
	LDA ,S
	LDB -120,S
	PSHU B,A
	ANDB #$0F
	ORB #$d0
	STB -120,S
	LDA -80,S
	PSHU A
	ANDA #$0F
	ORA #$c0
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
	ORA #$c0
	STA 80,S
	LDA 120,S
	PSHU S,A
	ANDA #$0F
	ORA #$d0
	STA 120,S
	LDA #$0c
	STA ,S
SSAV_Img_star_2
	LDS #$0000
	RTS

(info)

