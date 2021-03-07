(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemBack02
	STD DYN_POS+2,PCR
	LEAS ,U
	LDU ,Y
	LEAU -1444,U

	LDD #$0000
	STD -8,U
	LDX #$dd81
	LDY #$88e9
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$ed8c
	LDY #$88c9
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	PSHU D,X,Y
	LEAU -34,U

	LDD #$1ec0
	STD -8,U
	LDD #$0000
	LDX #$cd8e
	LDY #$88de
	PSHU D,X,Y
	LEAU -34,U

	LDA #$ed
	STD -8,U
	LDA #$00
	LDX #$cd1c
	LDY #$18dc
	PSHU D,X,Y
	LEAU -34,U

	LDA #$dc
	STD -8,U
	LDA #$00
	LDX #$0e68
	LDY #$88ed
	PSHU D,X,Y
	LEAU -34,U

	LDA #$cc
	STD -8,U
	LDA #$00
	LDX #$0e78
	LDY #$88cd
	PSHU D,X,Y
	LEAU -34,U

	LDA #$c0
	STD -8,U
	LDA #$00
	LDX #$0c78
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$0c76
	LDY #$888e
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$00e7
	LDY #$888c
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDY #$8888
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$00c7
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$00de
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$00dc
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$00ed
	LDY #$6818
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$00cd
	LDY #$78c8
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDY #$76c1
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$000e
	LDY #$778e
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$00cc
	LDY #$e71e
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDD #$ce8e
	STD -42,U
	LDD -44,U
	LDA #$cd
	ANDB #$F0
	ORB #$0e
	STD -44,U
	LDD #$0000
	LDX #$0ced
	LDY #$e7cc
	PSHU D,X,Y
	LEAU -38,U

	LDD #$dc6c
	STD -38,U
	LDD #$0000
	LDX #$0000
	PSHU D,X
	LEAU -36,U

	LDD #$dd76
	STD -38,U
	LDY #$000c
	PSHU X,Y
	LEAU -36,U

	LDD #$ed77
	STD -38,U
	LDY #$00ce
	PSHU X,Y
	LEAU -37,U

	LDA #$cd
	STD -37,U
	LDA #$00
	LDX #$000c
	PSHU A,X
	LEAU -37,U

	LDD #$dee7
	STD -37,U
	STX -43,U
	LDD #$ecce
	STD -77,U
	STY -83,U
	LDD -117,U
	ANDA #$F0
	ORA #$0e
	LDB #$dc
	STD -117,U
	LDA #$0c
	STA -123,U
	LDA #$00
	PSHU A,Y
	LEAU -193,U

	LDA #$dd
	STA 40,U
	LDA #$cd
	STA 33,U
	LDA #$ce
	STA -40,U
	LDA #$ed
	STA ,U
	LDA -7,U
	ANDA #$0F
	ORA #$e0
	STA -7,U
DYN_POS

	LDU #$0000
	LEAU -1444,U

	LDD #$0000
	STD -8,U
	LDX #$0c78
	LDY #$81ed
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$0078
	LDY #$8ccd
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$00e6
	LDY #$1c8e
	PSHU D,X,Y
	LEAU -34,U

	LDD #$ccdc
	STD -8,U
	LDD #$0000
	LDX #$00e7
	LDY #$ee8e
	PSHU D,X,Y
	LEAU -34,U

	LDD #$e1cc
	STD -8,U
	LDD #$0000
	LDX #$00c7
	LDY #$ec8c
	PSHU D,X,Y
	LEAU -34,U

	LDD #$1ec0
	STD -8,U
	LDD #$0000
	LDX #$00d7
	LDY #$e888
	PSHU D,X,Y
	LEAU -34,U

	LDA #$ed
	STD -8,U
	LDA #$00
	LDX #$00de
	PSHU D,X,Y
	LEAU -34,U

	LDA #$dc
	STD -8,U
	LDA #$00
	LDY #$c888
	PSHU D,X,Y
	LEAU -34,U

	LDA #$cc
	STD -8,U
	LDA #$00
	LDX #$00dc
	LDY #$8888
	PSHU D,X,Y
	LEAU -34,U

	LDA #$c0
	STD -8,U
	LDA #$00
	LDX #$00ed
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$00cd
	LDY #$6888
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDY #$7888
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$000e
	LDY #$7688
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$000c
	LDY #$7788
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$0000
	LDY #$e788
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDY #$c788
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDY #$ce88
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDY #$de88
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDY #$dc68
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDD #$cd77
	STD -42,U
	LDD -44,U
	LDA #$0c
	ANDB #$0F
	ORB #$10
	STD -44,U
	LDD #$0000
	LDX #$00cc
	LDY #$ed76
	PSHU D,X,Y
	LEAU -38,U

	LDD #$de77
	STD -38,U
	LDD #$0000
	LDX #$0000
	PSHU D,X
	LEAU -35,U

	LDD #$ece7
	STD -39,U
	LDA #$00
	LDY #$00ce
	PSHU A,X,Y
	LEAU -36,U

	LDD -38,U
	ANDA #$F0
	ORA #$0d
	LDB #$cd
	STD -38,U
	LDY #$000c
	PSHU X,Y
	LEAU -36,U

	LDD -38,U
	ANDA #$F0
	ORA #$0e
	LDB #$de
	STD -38,U
	LDY #$00ce
	PSHU X,Y
	LEAU -37,U

	LDA #$dc
	STA -36,U
	LDA #$00
	LDX #$000c
	PSHU A,X
	LEAU -37,U

	LDA #$ed
	STA -36,U
	STX -43,U
	LDA #$cd
	STA -76,U
	STY -83,U
	STB -116,U
	LDD -123,U
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD -123,U
	PSHU A,Y
	LEAU -177,U

	LDA #$ec
	STA 24,U
	LDA #$cc
	STA 17,U
	LDA -16,U
	ANDA #$F0
	ORA #$0e
	STA -16,U
	LDA #$d1
	STA -23,U
	RTS

(info)

