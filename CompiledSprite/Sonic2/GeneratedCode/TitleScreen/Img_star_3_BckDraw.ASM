(main)IMGD.ASM
	ORG $A000
	SETDP $FF
BCKDRAW_Img_star_3
	STS SSAV_Img_star_3+1,PCR

	STD DYN_POS+2,PCR
	LEAS ,U
	LDU ,Y
	LEAU -1,U

	LDX ,U
	PSHS X
	LDA -80,U
	PSHS A
	ANDA #$F0
	ORA #$0c
	STA -80,U
	LDA -40,U
	PSHS A
	ANDA #$F0
	ORA #$0d
	STA -40,U
	LDA 40,U
	PSHS A
	ANDA #$F0
	ORA #$0d
	STA 40,U
	LDA 80,U
	PSHS U,A
	ANDA #$F0
	ORA #$0c
	STA 80,U
	LDD #$b0bd
	STD ,U
DYN_POS

	LDU #$0000
	LEAU -160,U

	LDA -120,U
	PSHS A
	ANDA #$0F
	ORA #$d0
	STA -120,U
	LDA -80,U
	PSHS A
	ANDA #$0F
	ORA #$d0
	STA -80,U
	LDA -40,U
	PSHS A
	ANDA #$0F
	ORA #$c0
	STA -40,U
	LDA ,U
	PSHS A
	ANDA #$0F
	ORA #$b0
	STA ,U
	LDA 40,U
	PSHS A
	ANDA #$0F
	ORA #$b0
	STA 40,U
	LDA 80,U
	LDB 120,U
	PSHS U,B,A
	LDA #$ac
	STA 80,U
	LDA #$0d
	STA 120,U
	LEAU 280,U

	LDD -121,U
	PSHS D
	ANDA #$F0
	ORA #$0d
	LDB #$00
	STD -121,U
	LDA -80,U
	PSHS A
	LDA #$0d
	STA -80,U
	LDA -40,U
	LDB ,U
	PSHS B,A
	ANDB #$0F
	ORB #$a0
	STB ,U
	LDA 40,U
	PSHS A
	ANDA #$0F
	ORA #$b0
	STA 40,U
	LDA 80,U
	PSHS A
	ANDA #$0F
	ORA #$c0
	STA 80,U
	LDA 120,U
	PSHS U,A
	ANDA #$0F
	ORA #$d0
	STA 120,U
	LDA #$0c
	STA -40,U
	LEAU 160,U

	LDA ,U
	PSHS U,A
	ANDA #$0F
	ORA #$d0
	STA ,U
	LEAU ,S
SSAV_Img_star_3
	LDS #$0000
	RTS

(info)

