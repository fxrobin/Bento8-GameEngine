(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemBack07
	STD DYN_POS+2,PCR
	LEAS ,U
	LDU ,Y
	LEAU -1428,U

	LDD #$cdc8
	STD -8,U
	LDD #$86e0
	LDX #$0000
	LDY #$0000
	PSHU D,X,Y
	LEAU -34,U

	LDD #$dec1
	STD -8,U
	LDD #$87c0
	PSHU D,X,Y
	LEAU -34,U

	LDD #$dc8e
	STD -8,U
	LDD #$87c0
	PSHU D,X,Y
	LEAU -34,U

	LDD #$dc1e
	STD -8,U
	LDD #$8700
	LDY #$cc1c
	PSHU D,X,Y
	LEAU -34,U

	LDD #$e8cc
	STD -8,U
	LDD #$6e00
	LDY #$0ce1
	PSHU D,X,Y
	LEAU -34,U

	LDD #$c88e
	STD -8,U
	LDD #$7e00
	LDY #$00de
	PSHU D,X,Y
	LEAU -34,U

	LDD #$888c
	STD -8,U
	LDD #$7c00
	LDY #$00cd
	PSHU D,X,Y
	LEAU -34,U

	LDD #$8888
	STD -8,U
	LDD #$7d00
	LDY #$00cc
	PSHU D,X,Y
	LEAU -34,U

	LDD #$8888
	STD -8,U
	LDD #$ed00
	LDY #$000c
	PSHU D,X,Y
	LEAU -34,U

	LDD #$8888
	STD -8,U
	LDD #$cd00
	LDY #$0000
	PSHU D,X,Y
	LEAU -34,U

	LDD #$8888
	STD -8,U
	LDD #$dd00
	PSHU D,X,Y
	LEAU -34,U

	LDD #$8888
	STD -8,U
	LDD #$de00
	PSHU D,X,Y
	LEAU -34,U

	LDD #$8886
	STD -8,U
	LDD #$de00
	PSHU D,X,Y
	LEAU -34,U

	LDD #$8887
	STD -8,U
	LDD #$dc00
	PSHU D,X,Y
	LEAU -34,U

	LDD #$8867
	STD -8,U
	LDD #$e000
	PSHU D,X,Y
	LEAU -34,U

	LDD #$8877
	STD -8,U
	LDD #$c000
	PSHU D,X,Y
	LEAU -34,U

	LDD #$887e
	STD -8,U
	LDD #$0000
	PSHU D,X,Y
	LEAU -34,U

	LDD #$887e
	STD -8,U
	LDD #$0000
	PSHU D,X,Y
	LEAU -34,U

	LDD #$88ec
	STD -8,U
	LDD #$0000
	PSHU D,X,Y
	LEAU -34,U

	LDD #$86ed
	STD -8,U
	LDD #$c000
	PSHU D,X,Y
	LEAU -34,U

	LDD #$17cd
	STD -8,U
	LDD #$dc00
	PSHU D,X,Y
	LEAU -34,U

	LDD #$67de
	STD -8,U
	LDA #$cc
	PSHU A,X,Y
	LEAU -35,U

	LDD #$77dc
	STD -8,U
	LDA #$1d
	PSHU A,X,Y
	LEAU -35,U

	LDD #$77ed
	STD -8,U
	LDD #$cc00
	PSHU D,X
	LEAU -36,U

	LDD #$7ece
	STD -8,U
	LDD #$1d00
	PSHU D,X
	LEAU -36,U

	LDD -8,U
	LDA #$ec
	ANDB #$0F
	ORB #$d0
	STD -8,U
	LDA #$cc
	PSHU A,X
	LEAU -37,U

	LDD -8,U
	LDA #$cd
	ANDB #$0F
	ORB #$e0
	STD -8,U
	LDD #$cc00
	STD -42,U
	LDA #$dd
	STA -48,U
	LDA #$de
	STA -88,U
	LDA #$c0
	STA -121,U
	LDA #$1d
	STD -82,U
	PSHU A,X
	LEAU -165,U

	LDA #$ec
	STA 40,U
	LDA #$dc
	STA 7,U
	LDA #$0d
	STA ,U
	LDA -33,U
	ANDA #$F0
	ORA #$0e
	STA -33,U
	LDA -40,U
	ANDA #$0F
	ORA #$d0
	STA -40,U
DYN_POS

	LDU #$0000
	LEAU -1428,U

	LDD #$99c8
	STD -8,U
	LDD #$8ced
	LDX #$0000
	LDY #$0000
	PSHU D,X,Y
	LEAU -34,U

	LDD #$9e88
	STD -8,U
	LDD #$1ced
	PSHU D,X,Y
	LEAU -34,U

	LDD #$9e88
	STD -8,U
	LDD #$e8dd
	PSHU D,X,Y
	LEAU -34,U

	LDD #$9c88
	STD -8,U
	LDD #$e1de
	LDY #$00de
	PSHU D,X,Y
	LEAU -34,U

	LDD #$ed88
	STD -8,U
	LDD #$ccde
	LDY #$00cd
	PSHU D,X,Y
	LEAU -34,U

	LDD #$cd88
	STD -8,U
	LDD #$e8dc
	LDY #$00cc
	PSHU D,X,Y
	LEAU -34,U

	LDD #$de88
	STD -8,U
	LDD #$c8dc
	LDY #$000c
	PSHU D,X,Y
	LEAU -34,U

	LDD #$de88
	STD -8,U
	LDD #$86e0
	LDY #$0000
	PSHU D,X,Y
	LEAU -34,U

	LDD #$dc88
	STD -8,U
	LDD #$87e0
	PSHU D,X,Y
	LEAU -34,U

	LDD #$e888
	STD -8,U
	LDD #$67c0
	PSHU D,X,Y
	LEAU -34,U

	LDD #$c888
	STD -8,U
	LDD #$77c0
	PSHU D,X,Y
	LEAU -34,U

	LDD #$8888
	STD -8,U
	LDD #$7e00
	PSHU D,X,Y
	LEAU -34,U

	LDD #$8888
	STD -8,U
	LDD #$7c00
	PSHU D,X,Y
	LEAU -34,U

	LDD #$8888
	STD -8,U
	LDD #$7d00
	PSHU D,X,Y
	LEAU -34,U

	LDD #$8888
	STD -8,U
	LDD #$ed00
	PSHU D,X,Y
	LEAU -34,U

	LDD #$8888
	STD -8,U
	LDD #$cd00
	PSHU D,X,Y
	LEAU -34,U

	LDD #$8186
	STD -8,U
	LDD #$de00
	PSHU D,X,Y
	LEAU -34,U

	LDD #$8c87
	STD -8,U
	LDD #$de00
	PSHU D,X,Y
	LEAU -34,U

	LDD #$1c67
	STD -8,U
	LDD #$dc00
	PSHU D,X,Y
	LEAU -34,U

	LDD #$ee77
	STD -8,U
	LDD #$ec00
	PSHU D,X,Y
	LEAU -34,U

	LDB #$7e
	STD -8,U
	LDD #$cec0
	PSHU D,X,Y
	LEAU -34,U

	LDD -7,U
	LDA #$7e
	ANDB #$0F
	ORB #$d0
	STD -7,U
	LDA #$e8
	STA -8,U
	LDA #$ec
	PSHU A,X,Y
	LEAU -35,U

	LDD -7,U
	LDA #$ec
	ANDB #$0F
	ORB #$e0
	STD -7,U
	LDA #$e6
	STA -8,U
	LDD #$cc00
	PSHU D,X
	LEAU -36,U

	LDD #$c7cd
	STD -8,U
	LDD #$1d00
	PSHU D,X
	LEAU -36,U

	LDD #$67dd
	STD -8,U
	LDA #$cc
	PSHU A,X
	LEAU -37,U

	LDD #$77de
	STD -8,U
	LDD #$7dec
	STD -48,U
	LDD #$7ecd
	STD -88,U
	LDA #$c0
	STA -121,U
	LDD -128,U
	LDA #$ec
	ANDB #$0F
	ORB #$d0
	STD -128,U
	LDD #$cc00
	STD -42,U
	LDA #$1d
	STD -82,U
	PSHU A,X
	LEAU -202,U

	LDA #$ec
	STA 44,U
	LDD 37,U
	LDA #$cd
	ANDB #$0F
	ORB #$e0
	STD 37,U
	LDA 4,U
	ANDA #$F0
	ORA #$01
	STA 4,U
	LDA #$dd
	STA -3,U
	LDA #$de
	STA -43,U
	RTS

(info)

