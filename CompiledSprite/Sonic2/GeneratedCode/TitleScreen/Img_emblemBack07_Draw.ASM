(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemBack07
	STS SSAV_Img_emblemBack07+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS -1428,S

	LDA #$cd
	STA -8,S
	LDA #$c8
	LDX #$86e0
	LDY #$0000
	LDU #$0000
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$de
	STA -8,S
	LDA #$c1
	LDX #$87c0
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$dc
	STA -8,S
	LDA #$8e
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$dc
	STA -8,S
	LDA #$1e
	LDX #$8700
	LDU #$cc1c
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$e8
	STA -8,S
	LDA #$cc
	LDX #$6e00
	LDU #$0ce1
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$c8
	STA -8,S
	LDA #$8e
	LDX #$7e00
	LDU #$00de
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$88
	STA -8,S
	LDA #$8c
	LDX #$7c00
	LDU #$00cd
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$88
	STA -8,S
	LDX #$7d00
	LDU #$00cc
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$ed00
	LDU #$000c
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$cd00
	LDU #$0000
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$dd00
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$de00
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDA #$86
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$88
	STA -8,S
	LDA #$87
	LDX #$dc00
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$88
	STA -8,S
	LDA #$67
	LDX #$e000
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$88
	STA -8,S
	LDA #$77
	LDX #$c000
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$88
	STA -8,S
	LDA #$7e
	LDX #$0000
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$88
	STA -8,S
	LDA #$7e
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$88
	STA -8,S
	LDA #$ec
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$86
	STA -8,S
	LDA #$ed
	LDX #$c000
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$17
	STA -8,S
	LDA #$cd
	LDX #$dc00
	PSHS A,X,Y,U
	LEAS -33,S

	LDD #$67de
	STD -8,S
	LDA #$cc
	PSHS A,Y,U
	LEAS -35,S

	LDD #$77dc
	STD -8,S
	LDA #$1d
	PSHS A,Y,U
	LEAS -35,S

	LDD #$77ed
	STD -8,S
	LDD #$cc00
	PSHS D,Y
	LEAS -36,S

	LDD #$7ece
	STD -8,S
	LDD #$1d00
	PSHS D,Y
	LEAS -36,S

	LDD -8,S
	LDA #$ec
	ANDB #$0F
	ORB #$d0
	STD -8,S
	LDA #$cc
	PSHS A,Y
	LEAS -37,S

	LDD -8,S
	LDA #$cd
	ANDB #$0F
	ORB #$e0
	STD -8,S
	LDD #$cc00
	STD -42,S
	LDA #$dd
	STA -48,S
	LDA #$de
	STA -88,S
	LDA #$c0
	STA -121,S
	LDA #$1d
	STD -82,S
	PSHS A,Y
	LEAS -165,S

	LDA #$ec
	STA 40,S
	LDA #$dc
	STA 7,S
	LDA #$0d
	STA ,S
	LDA -33,S
	ANDA #$F0
	ORA #$0e
	STA -33,S
	LDA -40,S
	ANDA #$0F
	ORA #$d0
	STA -40,S
DYN_POS

	LDS #$0000
	LEAS -1428,S

	LDA #$99
	STA -8,S
	LDA #$c8
	LDX #$8ced
	LDY #$0000
	LDU #$0000
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$9e
	STA -8,S
	LDA #$88
	LDX #$1ced
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$9e
	STA -8,S
	LDA #$88
	LDX #$e8dd
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$9c
	STA -8,S
	LDA #$88
	LDX #$e1de
	LDU #$00de
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ed
	STA -8,S
	LDA #$88
	LDX #$ccde
	LDU #$00cd
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$cd
	STA -8,S
	LDA #$88
	LDX #$e8dc
	LDU #$00cc
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$de
	STA -8,S
	LDA #$88
	LDX #$c8dc
	LDU #$000c
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$de
	STA -8,S
	LDA #$88
	LDX #$86e0
	LDU #$0000
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$dc
	STA -8,S
	LDA #$88
	LDX #$87e0
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$e8
	STA -8,S
	LDA #$88
	LDX #$67c0
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$c8
	STA -8,S
	LDA #$88
	LDX #$77c0
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$7e00
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$7c00
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$7d00
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$ed00
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$cd00
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$81
	STA -8,S
	LDA #$86
	LDX #$de00
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$8c
	STA -8,S
	LDA #$87
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$1c
	STA -8,S
	LDA #$67
	LDX #$dc00
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ee
	STA -8,S
	LDA #$77
	LDX #$ec00
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ec
	STA -8,S
	LDA #$7e
	LDX #$cec0
	PSHS A,X,Y,U
	LEAS -33,S

	LDD -7,S
	LDA #$7e
	ANDB #$0F
	ORB #$d0
	STD -7,S
	LDA #$e8
	STA -8,S
	LDA #$ec
	PSHS A,Y,U
	LEAS -35,S

	LDD -7,S
	LDA #$ec
	ANDB #$0F
	ORB #$e0
	STD -7,S
	LDA #$e6
	STA -8,S
	LDD #$cc00
	PSHS D,Y
	LEAS -36,S

	LDD #$c7cd
	STD -8,S
	LDD #$1d00
	PSHS D,Y
	LEAS -36,S

	LDD #$67dd
	STD -8,S
	LDA #$cc
	PSHS A,Y
	LEAS -37,S

	LDD #$77de
	STD -8,S
	LDD #$7dec
	STD -48,S
	LDD #$7ecd
	STD -88,S
	LDA #$c0
	STA -121,S
	LDD -128,S
	LDA #$ec
	ANDB #$0F
	ORB #$d0
	STD -128,S
	LDD #$cc00
	STD -42,S
	LDA #$1d
	STD -82,S
	PSHS A,Y
	LEAS -202,S

	LDA #$ec
	STA 44,S
	LDD 37,S
	LDA #$cd
	ANDB #$0F
	ORB #$e0
	STD 37,S
	LDA 4,S
	ANDA #$F0
	ORA #$01
	STA 4,S
	LDA #$dd
	STA -3,S
	LDA #$de
	STA -43,S
SSAV_Img_emblemBack07
	LDS #$0000
	RTS

(info)

