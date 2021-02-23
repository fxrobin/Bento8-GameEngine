(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemFront08
	STS SSAV_Img_emblemFront08+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS 2613,S

	LDA 40,S
	ANDA #$0F
	ORA #$20
	STA 40,S
	LDD -1,S
	LDA #$22
	ANDB #$0F
	ORB #$20
	STD -1,S
	LDD -41,S
	LDA #$22
	ANDB #$0F
	ORB #$20
	STD -41,S
	LEAS -200,S

	LDD #$2222
	STD 118,S
	STD 78,S
	STD 38,S
	LDA 37,S
	ANDA #$F0
	ORA #$02
	STA 37,S
	LDX #$2222
	PSHS B,X
	LEAS -37,S

	PSHS B,X
	LEAS -37,S

	LDA -4,S
	ANDA #$F0
	ORA #$02
	STA -4,S
	LDA #$32
	PSHS A,X
	LEAS -37,S

	LDA #$23
	PSHS D,X
	LEAS -36,S

	LDD #$f332
	PSHS D,X
	LEAS -36,S

	LDB #$22
	LDX #$2220
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$02
	STA -5,S
	LDD #$f332
	LDX #$2200
	PSHS D,X
	LEAS -36,S

	LDA #$2f
	LDX #$f322
	LDU #$2002
	PSHS A,X,U
	LEAS -35,S

	LDD -42,S
	LDA #$00
	ANDB #$0F
	ORB #$00
	STD -42,S
	LDA #$1f
	LDX #$f332
	LDU #$0002
	PSHS A,X,U
	LEAS -37,S

	LDD -40,S
	LDA #$00
	ANDB #$0F
	ORB #$00
	STD -40,S
	LDA #$1f
	LDX #$f322
	PSHS A,X
	LEAS -37,S

	LDD -40,S
	LDA #$00
	ANDB #$0F
	ORB #$20
	STD -40,S
	LDA #$1f
	LDX #$f360
	PSHS A,X
	LEAS -37,S

	LDD -40,S
	LDA #$00
	ANDB #$0F
	ORB #$20
	STD -40,S
	LDA #$1f
	LDX #$f300
	PSHS A,X
	LEAS -37,S

	LDA #$31
	LDX #$f360
	PSHS A,X
	LEAS -36,S

	LDD #$f3f7
	LDX #$0000
	PSHS D,X
	LEAS -36,S

	LDA #$3f
	LDX #$6000
	PSHS D,X
	LEAS -36,S

	LDD -41,S
	LDA #$00
	ANDB #$0F
	ORB #$20
	STD -41,S
	LDD #$3f27
	LDX #$0000
	PSHS D,X
	LEAS -37,S

	LDA -7,S
	ANDA #$0F
	ORA #$10
	STA -7,S
	LDD -40,S
	LDA #$00
	ANDB #$0F
	ORB #$00
	STD -40,S
	LDA #$3f
	LDX #$1760
	PSHS A,X
	LEAS -37,S

	LDA -7,S
	ANDA #$0F
	ORA #$e0
	STA -7,S
	LDA #$3f
	LDX #$1700
	PSHS A,X
	LEAS -35,S

	LDA #$d1
	STA -9,S
	LDA #$3f
	LDX #$2760
	PSHS A,X,U
	LEAS -35,S

	LDA #$ed
	STA -9,S
	LDA #$3f
	LDX #$3200
	LDU #$0022
	PSHS A,X,U
	LEAS -35,S

	LDA #$ee
	STA -9,S
	LDA #$32
	LDX #$3260
	PSHS A,X,U
	LEAS -35,S

	LDA #$ee
	STA -9,S
	LDA #$22
	LDX #$3200
	LDU #$0222
	PSHS A,X,U
	LEAS -35,S

	LDA #$ce
	STA -9,S
	LDD #$2222
	LDX #$3260
	LDU #$2222
	PSHS D,X,U
	LEAS -34,S

	LDA #$3c
	STD -9,S
	LDD -41,S
	LDA #$22
	ANDB #$0F
	ORB #$20
	STD -41,S
	LDX #$2222
	LDY #$3200
	PSHS A,X,Y,U
	LEAS -34,S

	STA -8,S
	LDD -40,S
	LDA #$22
	ANDB #$0F
	ORB #$20
	STD -40,S
	LDY #$2232
	LDU #$3222
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$11
	STA -8,S
	LDA #$22
	LDY #$2233
	LDU #$2222
	PSHS A,X,Y,U
	LEAS -32,S

	LDD #$0022
	STD -9,S
	LDY #$3332
	PSHS B,X,Y,U
	LEAS -33,S

	STD -9,S
	LDY #$3322
	PSHS B,X,Y,U
	LEAS -34,S

	LDA #$10
	STA -8,S
	LDY #$2233
	LDU #$3222
	PSHS B,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDD -42,S
	LDA #$32
	ANDB #$0F
	ORB #$20
	STD -42,S
	LDA #$22
	LDU #$2222
	PSHS A,X,Y,U
	LEAS -35,S

	LDD #$1122
	LDU #$2237
	PSHS D,X,U
	LEAS -33,S

	LDA #$00
	LDY #$1122
	LDU #$3722
	PSHS A,X,Y,U
DYN_POS

	LDS #$0000
	LEAS 2653,S

	LDA ,S
	ANDA #$F0
	ORA #$02
	STA ,S
	LEAS -159,S

	LDD #$2222
	STD 78,S
	STD 38,S
	STA 119,S
	LDX #$2222
	PSHS A,X
	LEAS -37,S

	PSHS A,X
	LEAS -37,S

	LDA #$23
	STD -44,S
	LDA #$33
	STD -84,S
	STD -124,S
	LDA -4,S
	ANDA #$F0
	ORA #$02
	STA -4,S
	LDD -42,S
	LDA #$22
	ANDB #$0F
	ORB #$20
	STD -42,S
	LDD -82,S
	LDA #$22
	ANDB #$0F
	ORB #$20
	STD -82,S
	LDD -122,S
	LDA #$22
	ANDB #$0F
	ORB #$20
	STD -122,S
	PSHS A,X
	LEAS -198,S

	LDD 39,S
	LDA #$22
	ANDB #$0F
	ORB #$20
	STD 39,S
	LDD #$3322
	STD 37,S
	LDA 36,S
	ANDA #$F0
	ORA #$02
	STA 36,S
	LDD #$2f33
	PSHS D,X
	LEAS -36,S

	LDA #$ff
	LDX #$2220
	PSHS D,X
	LEAS -36,S

	LDX #$2200
	PSHS D,X
	LEAS -36,S

	LDX #$2000
	PSHS D,X
	LEAS -36,S

	LDX #$0000
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$02
	STA -5,S
	LDD #$ff33
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$02
	STA -5,S
	LDD #$ff36
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$02
	STA -5,S
	LDD #$ff76
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$02
	STA -5,S
	LDD #$2f66
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$02
	STA -5,S
	LDA -9,S
	ANDA #$0F
	ORA #$10
	STA -9,S
	LDD #$f276
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$02
	STA -5,S
	LDA #$e1
	STA -9,S
	LDD #$ff66
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$02
	STA -5,S
	LDA #$ce
	STA -9,S
	LDD #$ff76
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$02
	STA -5,S
	LDA #$ed
	STA -9,S
	LDD #$ff66
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$02
	STA -5,S
	LDA #$ee
	STA -9,S
	LDD #$f176
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$02
	STA -5,S
	LDA #$ce
	STA -9,S
	LDD -41,S
	LDA #$22
	ANDB #$0F
	ORB #$20
	STD -41,S
	LDD #$f266
	PSHS D,X
	LEAS -37,S

	LDA -4,S
	ANDA #$F0
	ORA #$02
	STA -4,S
	LDD -8,S
	LDA #$7c
	ANDB #$0F
	ORB #$10
	STD -8,S
	LDD -40,S
	LDA #$22
	ANDB #$0F
	ORB #$20
	STD -40,S
	LDX #$7600
	PSHS A,X
	LEAS -37,S

	LDA -4,S
	ANDA #$F0
	ORA #$02
	STA -4,S
	LDD #$73d1
	STD -8,S
	LDA #$22
	LDX #$6600
	PSHS A,X
	LEAS -35,S

	LDD #$33ed
	STD -10,S
	LDA #$22
	LDX #$2222
	LDY #$7602
	LDU #$2222
	PSHS A,X,Y,U
	LEAS -33,S

	LDY #$6622
	PSHS A,X,Y,U
	LDA #$33
	LDX #$e222
	PSHS A,X
	LEAS -30,S

	LDA #$22
	LDX #$2222
	LDY #$7622
	PSHS A,X,Y,U
	PSHS A,X
	LEAS -30,S

	LDY #$6322
	PSHS A,X,Y,U
	LDA #$21
	PSHS A,X
	LEAS -30,S

	LDA #$22
	LDY #$3322
	PSHS A,X,Y,U
	LDA #$10
	PSHS A,X
	LEAS -31,S

	LDB #$22
	STD -9,S
	LDY #$2233
	PSHS B,X,Y,U
	LEAS -33,S

	STD -9,S
	PSHS B,X,Y,U
	LEAS -34,S

	STA -8,S
	LDY #$2222
	LDU #$3322
	PSHS B,X,Y,U
	LEAS -33,S

	STA -8,S
	LDD -42,S
	LDA #$33
	ANDB #$0F
	ORB #$20
	STD -42,S
	LDA #$22
	PSHS A,X,Y,U
	LEAS -35,S

	LDD #$1022
	LDX #$2211
	PSHS D,X,Y
SSAV_Img_emblemFront08
	LDS #$0000
	RTS

(info)

