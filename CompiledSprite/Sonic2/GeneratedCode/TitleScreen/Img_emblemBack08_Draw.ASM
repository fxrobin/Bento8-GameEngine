(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemBack08
	STS SSAV_Img_emblemBack08+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS 50,S

	LDD -1,S
	ANDA #$F0
	ANDB #$0F
	ADDD #$0c10
	STD -1,S
	LEAS -159,S

	LDD 118,S
	ANDA #$F0
	ANDB #$0F
	ADDD #$00e0
	STD 118,S
	LDD #$00d1
	STD 78,S
	LDB #$ce
	STD 38,S
	LDX #$00cd
	PSHS A,X
	LEAS -37,S

	LDA -4,S
	ANDA #$F0
	ORA #$0d
	STA -4,S
	LDA #$00
	LDX #$000c
	PSHS A,X
	LEAS -37,S

	LDA -5,S
	ANDA #$F0
	ORA #$08
	STA -5,S
	LDD #$6d00
	PSHS D,X
	LEAS -36,S

	LDA -6,S
	ANDA #$F0
	ORA #$0c
	STA -6,S
	LDD -41,S
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD -41,S
	LDA #$88
	LDX #$6d00
	LDU #$0000
	PSHS A,X,U
	LEAS -36,S

	LDD -40,S
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD -40,S
	LDD #$99dc
	LDX #$886d
	PSHS D,X,U
	LEAS -34,S

	PSHS D,X,U
	LEAS -32,S

	STA -8,S
	LDY #$0000
	LDU #$00d1
	PSHS B,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$00de
	LDU #$ccd1
	PSHS B,X,Y,U
	LEAS -33,S

	STA -8,S
	LDD -42,S
	ANDA #$0F
	ORA #$10
	LDB #$cd
	STD -42,S
	LDA #$dc
	LDY #$00cd
	LDU #$1dce
	PSHS A,X,Y,U
	LEAS -35,S

	LDD #$99dc
	LDU #$000c
	PSHS D,X,U
	LEAS -33,S

	LDX #$dc88
	LDY #$6d00
	LDU #$00e1
	PSHS A,X,Y,U
	LEAS -33,S

	LDU #$00de
	PSHS A,X,Y,U
	LEAS -33,S

	LDX #$dc11
	LDU #$00cd
	PSHS A,X,Y,U
	LEAS -33,S

	LDX #$dcee
	LDU #$00cc
	PSHS A,X,Y,U
	LEAS -33,S

	LDD -41,S
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD -41,S
	LDA #$99
	LDU #$000c
	PSHS A,X,Y,U
	LEAS -34,S

	LDD #$99dc
	LDX #$cc7d
	LDU #$0000
	PSHS D,X,U
	LEAS -32,S

	STA -8,S
	LDX #$ee7d
	LDY #$0000
	LDU #$00e1
	PSHS B,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$cc7d
	LDU #$00de
	PSHS B,X,Y,U
	LEAS -33,S

	STA -8,S
	LDA #$e8
	LDX #$887d
	LDU #$00cd
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$e8
	LDX #$88ed
	LDU #$00cc
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$e8
	LDU #$000c
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$e8
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$c8
	LDU #$0000
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$c8
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$c8
	LDX #$88de
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$88
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$88
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$9e
	STA -8,S
	LDA #$88
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$9e
	STA -8,S
	LDA #$88
	LDX #$88dc
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$9d
	STA -8,S
	LDA #$88
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$9d
	STA -8,S
	LDA #$88
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ed
	STA -8,S
	LDA #$88
	LDX #$88e0
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ed
	STA -8,S
	LDA #$18
	PSHS A,X,Y,U
DYN_POS

	LDS #$0000
	LEAS 70,S

	LDA 100,S
	ANDA #$0F
	ORA #$10
	STA 100,S
	LDA 60,S
	ANDA #$0F
	ORA #$e0
	STA 60,S
	LDA #$d1
	STA 20,S
	LDA #$ce
	STA -20,S
	LDA #$cd
	STA -60,S
	LDA #$0c
	STA -100,S
	LEAS -258,S

	LDD #$000c
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
	LDD #$e000
	STD 36,S
	LDA #$88
	LDX #$e000
	LDU #$00d1
	PSHS A,X,U
	LEAS -35,S

	LDB #$88
	LDU #$00ce
	PSHS D,X,U
	LEAS -34,S

	LDA #$99
	STA -8,S
	LDX #$8888
	LDY #$e000
	LDU #$00cd
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDA #$9e
	LDU #$000c
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$9e
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$9e
	LDY #$e00c
	LDU #$1c0c
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDD -42,S
	LDA #$de
	ANDB #$F0
	ORB #$0e
	STD -42,S
	LDA #$9e
	LDY #$e000
	LDU #$e1cc
	PSHS A,X,Y,U
	LEAS -35,S

	LDD #$999e
	PSHS D,X,Y
	LEAS -33,S

	LDX #$9e81
	LDY #$18e0
	LDU #$00cd
	PSHS A,X,Y,U
	LEAS -33,S

	LDD -41,S
	LDA #$0c
	ANDB #$0F
	ORB #$10
	STD -41,S
	LDA #$99
	LDX #$9e8c
	LDY #$c8e0
	LDU #$000c
	PSHS A,X,Y,U
	LEAS -34,S

	LDD #$999e
	LDX #$8cc8
	LDU #$e000
	PSHS D,X,U
	LEAS -32,S

	STA -8,S
	LDX #$8888
	LDY #$e000
	LDU #$00e1
	PSHS B,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$8118
	LDU #$00de
	PSHS B,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$8cc8
	LDU #$00cd
	PSHS B,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$8888
	LDU #$00cc
	PSHS B,X,Y,U
	LEAS -33,S

	STA -8,S
	LDA #$9d
	LDU #$000c
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$9d
	LDU #$0000
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$9d
	LDY #$c000
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$9d
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$9d
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$ed
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$ed
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$dd
	LDX #$8886
	LDY #$0000
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$de
	LDX #$8887
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$de
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$de
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$dc
	LDX #$886e
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$dc
	LDX #$887e
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$e8
	LDX #$887d
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$e8
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$99
	STA -8,S
	LDA #$c8
	LDX #$81ed
	PSHS A,X,Y,U
SSAV_Img_emblemBack08
	LDS #$0000
	RTS

(info)

