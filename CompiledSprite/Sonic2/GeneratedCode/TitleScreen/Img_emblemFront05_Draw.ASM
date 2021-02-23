(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemFront05
	STS SSAV_Img_emblemFront05+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS 2626,S

	LDA #$22
	STA ,S
	LEAS -157,S

	STA 117,S
	LDD #$2222
	STD 77,S
	STD 37,S
	STD -42,S
	LDA -43,S
	ANDA #$F0
	ORA #$02
	STA -43,S
	LDD -81,S
	LDA #$22
	ANDB #$0F
	ORB #$20
	STD -81,S
	LDD -83,S
	ANDA #$F0
	ORA #$02
	LDB #$22
	STD -83,S
	LDX #$2222
	PSHS B,X
	LEAS -116,S

	LDA -4,S
	ANDA #$F0
	ORA #$02
	STA -4,S
	LDX #$2232
	PSHS B,X
	LEAS -37,S

	LDA -4,S
	ANDA #$F0
	ORA #$02
	STA -4,S
	LDD -41,S
	LDA #$33
	ANDB #$0F
	ORB #$20
	STD -41,S
	LDD #$2222
	STD -43,S
	LDX #$2233
	PSHS A,X
	LEAS -76,S

	LDX #$33f2
	PSHS D,X
	LEAS -36,S

	LDX #$33ff
	PSHS D,X
	LEAS -36,S

	LDA #$00
	PSHS D,X
	LEAS -36,S

	LDD -41,S
	LDA #$ff
	ANDB #$0F
	ORB #$20
	STD -41,S
	LDD #$0022
	PSHS D,X
	LEAS -37,S

	LDD -40,S
	LDA #$ff
	ANDB #$0F
	ORB #$20
	STD -40,S
	LDA #$00
	LDX #$0233
	PSHS A,X
	LEAS -37,S

	LDD -40,S
	LDA #$ff
	ANDB #$0F
	ORB #$10
	STD -40,S
	LDA #$00
	LDX #$0033
	PSHS A,X
	LEAS -37,S

	LDD -40,S
	LDA #$ff
	ANDB #$0F
	ORB #$10
	STD -40,S
	LDA #$00
	PSHS A,X
	LEAS -37,S

	LDD -40,S
	LDA #$ff
	ANDB #$0F
	ORB #$30
	STD -40,S
	LDA #$00
	LDX #$0067
	PSHS A,X
	LEAS -37,S

	LDD -40,S
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,S
	LDA #$00
	LDX #$0066
	PSHS A,X
	LEAS -37,S

	LDD -40,S
	LDA #$22
	ANDB #$0F
	ORB #$30
	STD -40,S
	LDA #$20
	LDX #$0067
	PSHS A,X
	LEAS -37,S

	LDA -35,S
	ANDA #$F0
	ORA #$01
	STA -35,S
	LDD -40,S
	LDA #$1f
	ANDB #$0F
	ORB #$30
	STD -40,S
	LDA #$20
	LDX #$0066
	PSHS A,X
	LEAS -37,S

	LDA #$1c
	STA -35,S
	LDD -40,S
	LDA #$1f
	ANDB #$0F
	ORB #$30
	STD -40,S
	LDA #$20
	LDX #$0067
	PSHS A,X
	LEAS -37,S

	LDA #$de
	STA -35,S
	LDD -40,S
	LDA #$1f
	ANDB #$0F
	ORB #$30
	STD -40,S
	LDA #$00
	LDX #$0066
	PSHS A,X
	LEAS -37,S

	LDA #$ee
	STA -35,S
	LDD -40,S
	LDA #$1f
	ANDB #$0F
	ORB #$30
	STD -40,S
	LDA #$00
	LDX #$0067
	PSHS A,X
	LEAS -37,S

	LDA #$ee
	STA -35,S
	LDD -40,S
	LDA #$21
	ANDB #$0F
	ORB #$30
	STD -40,S
	LDA #$00
	LDX #$0066
	PSHS A,X
	LEAS -37,S

	LDD -36,S
	ANDA #$F0
	ORA #$01
	LDB #$ec
	STD -36,S
	LDD -40,S
	LDA #$32
	ANDB #$0F
	ORB #$30
	STD -40,S
	LDA #$20
	LDX #$0067
	PSHS A,X
	LEAS -37,S

	LDD -36,S
	ANDA #$F0
	ORA #$0d
	LDB #$c7
	STD -36,S
	LDA #$22
	LDX #$0066
	PSHS A,X
	LEAS -35,S

	LDA -6,S
	ANDA #$F0
	ORA #$02
	STA -6,S
	LDD #$1e33
	STD -38,S
	LDA #$22
	LDX #$0067
	LDU #$3222
	PSHS A,X,U
	LEAS -34,S

	LDA -7,S
	ANDA #$F0
	ORA #$02
	STA -7,S
	LDD #$2220
	LDX #$6632
	LDU #$2222
	PSHS D,X,U
	LEAS -31,S

	LDA #$67
	LDX #$3222
	LDY #$2222
	LDU #$2233
	PSHS A,X,Y,U
	LDA #$22
	PSHS A,Y
	LEAS -30,S

	LDA #$36
	LDU #$2222
	PSHS A,X,Y,U
	LDA #$22
	PSHS A,Y
	LEAS -30,S

	LDA #$33
	LDX #$2222
	LDU #$2211
	PSHS A,X,Y,U
	LDA #$22
	PSHS A,X
	LEAS -30,S

	STX -9,S
	LDA -10,S
	ANDA #$F0
	ORA #$02
	STA -10,S
	LDA #$33
	PSHS A,X,Y,U
	LEAS -33,S

	STX -9,S
	PSHS A,X,Y,U
	LEAS -33,S

	LDD -9,S
	ANDA #$F0
	ORA #$02
	LDB #$22
	STD -9,S
	LDA #$33
	PSHS A,X,Y,U
	LEAS -33,S

	STB -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STB -8,S
	LDU #$2201
	PSHS A,X,Y,U
	LEAS -33,S

	LDA -8,S
	ANDA #$F0
	ORA #$02
	STA -8,S
	LDA #$33
	PSHS A,X,Y,U
DYN_POS

	LDS #$0000
	LEAS 2606,S

	LDA 20,S
	ANDA #$F0
	ORA #$02
	STA 20,S
	LDA #$22
	STA -19,S
	LEAS -176,S

	STA 117,S
	LDD #$2222
	STD 77,S
	STD 37,S
	LDX #$2222
	PSHS A,X
	LEAS -37,S

	LDD -41,S
	LDA #$23
	ANDB #$0F
	ORB #$20
	STD -41,S
	STX -43,S
	LDA #$22
	PSHS A,X
	LEAS -76,S

	LDU #$2232
	PSHS X,U
	LEAS -36,S

	LDU #$2333
	PSHS X,U
	LEAS -36,S

	LDD -41,S
	LDA #$33
	ANDB #$0F
	ORB #$20
	STD -41,S
	LDU #$2233
	PSHS X,U
	LEAS -37,S

	LDA #$20
	LDX #$2223
	PSHS A,X
	LEAS -35,S

	LDX #$2222
	LDU #$33f2
	PSHS A,X,U
	LEAS -35,S

	LDA -5,S
	ANDA #$F0
	ORA #$00
	STA -5,S
	LDD #$0023
	LDX #$33ff
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$00
	STA -5,S
	LDD #$0022
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$02
	STA -5,S
	LDD #$0003
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$02
	STA -5,S
	LDD #$0000
	PSHS D,X
	LEAS -36,S

	LDB #$06
	LDX #$33f1
	PSHS D,X
	LEAS -36,S

	LDB #$00
	LDX #$73f1
	PSHS D,X
	LEAS -36,S

	LDB #$06
	LDX #$7733
	PSHS D,X
	LEAS -36,S

	LDB #$00
	LDX #$77ff
	PSHS D,X
	LEAS -36,S

	LDB #$06
	PSHS D,X
	LEAS -36,S

	LDA -37,S
	ANDA #$F0
	ORA #$01
	STA -37,S
	LDD #$0000
	LDX #$72ff
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$02
	STA -5,S
	LDA -37,S
	ANDA #$F0
	ORA #$0e
	STA -37,S
	LDD #$0006
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$00
	STA -5,S
	LDA #$1d
	STA -37,S
	LDD #$0000
	LDX #$73ff
	PSHS D,X
	LEAS -36,S

	LDA #$de
	STA -37,S
	LDA #$22
	LDX #$0006
	LDU #$73ff
	PSHS A,X,U
	LEAS -35,S

	LDA #$ee
	STA -37,S
	LDA #$22
	LDX #$0000
	LDU #$732f
	PSHS A,X,U
	LEAS -35,S

	LDA #$ec
	STA -37,S
	LDA #$22
	LDX #$2206
	LDU #$7322
	PSHS A,X,U
	LEAS -34,S

	LDB #$22
	LDX #$0073
	LDU #$2222
	PSHS D,X,U
	LEAS -31,S

	STD -9,S
	LDA #$26
	LDX #$7322
	LDY #$2222
	LDU #$22e3
	PSHS A,X,Y,U
	LEAS -33,S

	STY -9,S
	LDU #$2222
	PSHS B,X,Y,U
	LEAS -33,S

	STU -9,S
	LDA -10,S
	ANDA #$F0
	ORA #$02
	STA -10,S
	LDA #$23
	LDX #$2322
	LDU #$2221
	PSHS A,X,Y,U
	LEAS -33,S

	STY -9,S
	LDU #$2220
	PSHS B,X,Y,U
	LEAS -33,S

	LDD -9,S
	ANDA #$F0
	ORA #$02
	LDB #$22
	STD -9,S
	LDA #$23
	PSHS A,X,Y,U
	LEAS -33,S

	STB -8,S
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	LDX #$6322
	LDU #$2210
	PSHS A,X,Y,U
	LEAS -33,S

	LDX #$6122
	LDU #$2200
	PSHS B,X,Y,U
	LEAS -33,S

	PSHS A,X,Y,U
SSAV_Img_emblemFront05
	LDS #$0000
	RTS

(info)

