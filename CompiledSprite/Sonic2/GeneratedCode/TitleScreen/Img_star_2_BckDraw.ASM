(main)IMGD.ASM
	ORG $A000
	SETDP $FF
BCKDRAW_Img_star_2
	STS SSAV_Img_star_2+1,PCR

	STD DYN_POS+2,PCR
	LEAS ,U
	LDU ,Y
	LDA ,U
	PSHS U,A
	ANDA #$0F
	ORA #$c0
	STA ,U
DYN_POS

	LDU #$0000
	LDA ,U
	LDB -120,U
	PSHS B,A
	ANDB #$F0
	ORB #$0d
	STB -120,U
	LDA -80,U
	PSHS A
	ANDA #$F0
	ORA #$0c
	STA -80,U
	LDA -40,U
	PSHS A
	ANDA #$F0
	ORA #$0b
	STA -40,U
	LDA 40,U
	PSHS A
	ANDA #$F0
	ORA #$0b
	STA 40,U
	LDA 80,U
	PSHS A
	ANDA #$F0
	ORA #$0c
	STA 80,U
	LDA 120,U
	PSHS U,A
	ANDA #$F0
	ORA #$0d
	STA 120,U
	LDA #$c0
	STA ,U
	LEAU ,S
SSAV_Img_star_2
	LDS #$0000
	RTS

(info)

