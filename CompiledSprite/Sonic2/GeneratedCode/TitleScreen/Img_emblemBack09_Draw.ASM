(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemBack09
	STS SSAV_Img_emblemBack09+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS -1108,S

	LDA 120,S
	ANDA #$0F
	ORA #$10
	STA 120,S
	LDA 80,S
	ANDA #$0F
	ORA #$e0
	STA 80,S
	LDA #$d1
	STA 40,S
	STA ,S
	LDA #$ce
	STA -40,S
	LDA #$cd
	STA -80,S
	LDA #$0c
	STA -120,S
	LEAS -280,S

	STA 120,S
	STA 80,S
	LDA #$00
	STA 40,S
	STA ,S
	LDD -40,S
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD -40,S
	LDD -80,S
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD -80,S
	LDD -120,S
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD -120,S
	LEAS -280,S

	LDD #$00d1
	STD 120,S
	LDA #$c0
	STD 80,S
	LDD #$ecce
	STD 40,S
	STB 1,S
	LDA #$1d
	STA -39,S
	LDA -80,S
	ANDA #$0F
	ORA #$10
	STA -80,S
	LDA #$e1
	STA -120,S
	LEAS -280,S

	LDA #$de
	STA 120,S
	LDA #$cd
	STA 80,S
	LDA #$cc
	STA 40,S
	LDA #$0c
	STA ,S
	LDD -40,S
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD -40,S
	LDD -80,S
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD -80,S
	LDD #$00d1
	STD -120,S
	LEAS -219,S

	LDB #$ce
	STD 59,S
	LDB #$cd
	STD 19,S
	LDB #$0c
	STD -21,S
	STD -61,S
	LEAS -218,S

	LDB #$00
	STD 117,S
	LDD 78,S
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD 78,S
	LDD 38,S
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD 38,S
	STA 77,S
	STA 37,S
	LDX #$00d1
	PSHS A,X
	LEAS -37,S

	LDX #$00ce
	PSHS A,X
	LEAS -37,S

	PSHS A,X
	LEAS -37,S

	LDX #$00cd
	PSHS A,X
	LEAS -37,S

	LDX #$000c
	PSHS A,X
	LEAS -37,S

	PSHS A,X
	LEAS -37,S

	LDX #$0000
	PSHS A,X
	LEAS -37,S

	LDD -41,S
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD -41,S
	LDD -81,S
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD -81,S
	LDD -121,S
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD -121,S
	LDD #$c000
	STD -43,S
	LDA #$ec
	STD -83,S
	LDD -123,S
	ANDA #$F0
	ORA #$01
	LDB #$00
	STD -123,S
	PSHS B,X
	LEAS -196,S

	LDD 38,S
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD 38,S
	LDA #$cc
	STA 37,S
	LDD #$c0d1
	STD -42,S
	LDA #$dc
	STD -82,S
	LDD -122,S
	ANDA #$F0
	ORA #$0e
	LDB #$ce
	STD -122,S
	LDA #$1d
	LDX #$00d1
	PSHS A,X
	LEAS -178,S

	STB 20,S
	STA -20,S
DYN_POS

	LDS #$0000
	LEAS -948,S

	LDA 120,S
	ANDA #$0F
	ORA #$10
	STA 120,S
	LDA 80,S
	ANDA #$0F
	ORA #$e0
	STA 80,S
	LDA #$d1
	STA 40,S
	LDA #$ce
	STA ,S
	LDA #$cd
	STA -40,S
	LDA #$cc
	STA -80,S
	LDA #$0c
	STA -120,S
	LEAS -280,S

	STA 120,S
	LDA #$00
	STA 80,S
	LDD 40,S
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD 40,S
	LDD ,S
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD ,S
	LDD -40,S
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD -40,S
	LDD #$00d1
	STD -80,S
	LDB #$ce
	STD -120,S
	LEAS -279,S

	STD 119,S
	LDB #$cd
	STD 79,S
	LDB #$0c
	STD 39,S
	STD -1,S
	LDA #$c0
	STD -41,S
	LDA #$dc
	STD -81,S
	LDD -121,S
	ANDA #$0F
	ORA #$10
	LDB #$c0
	STD -121,S
	LEAS -280,S

	LDD 119,S
	ANDA #$0F
	ORA #$e0
	LDB #$ec
	STD 119,S
	LDA #$d1
	STA 79,S
	LDA #$ce
	STA 39,S
	LDA #$cd
	STA -1,S
	LDD -81,S
	LDA #$0c
	ANDB #$0F
	ORB #$10
	STD -81,S
	STA -41,S
	LDD #$00e1
	STD -121,S
	LEAS -220,S

	LDB #$de
	STD 59,S
	LDB #$cd
	STD 19,S
	LDB #$cc
	STD -21,S
	LDB #$0c
	STD -61,S
	LEAS -218,S

	LDB #$00
	STD 117,S
	LDD 78,S
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD 78,S
	LDD 38,S
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD 38,S
	STA 77,S
	STA 37,S
	LDX #$00d1
	PSHS A,X
	LEAS -37,S

	LDX #$00ce
	PSHS A,X
	LEAS -37,S

	LDX #$00cd
	PSHS A,X
	LEAS -37,S

	LDX #$000c
	PSHS A,X
	LEAS -37,S

	PSHS A,X
	LEAS -37,S

	LDX #$0000
	PSHS A,X
	LEAS -37,S

	LDD -41,S
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD -41,S
	LDD -81,S
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD -81,S
	STX -43,S
	STX -83,S
	PSHS A,X
	LEAS -116,S

	LDU #$00d1
	PSHS X,U
	LEAS -36,S

	PSHS X,U
	LEAS -36,S

	LDD #$cc00
	LDX #$00ce
	PSHS D,X
	LEAS -36,S

	LDA #$1d
	LDX #$00cd
	PSHS D,X
	LEAS -36,S

	LDA #$c0
	PSHS A,X
	LEAS -37,S

	LDB #$0c
	STD -82,S
	LDA #$00
	STD -42,S
	LDA #$ec
	STD -122,S
	LDA -43,S
	ANDA #$F0
	ORA #$0e
	STA -43,S
	LDA #$dc
	LDX #$000c
	PSHS A,X
	LEAS -198,S

	LDD 39,S
	ANDA #$F0
	ORA #$01
	LDB #$00
	STD 39,S
	LDA #$cc
	STA ,S
	LDA #$1d
	STA -40,S
SSAV_Img_emblemBack09
	LDS #$0000
	RTS

(info)

