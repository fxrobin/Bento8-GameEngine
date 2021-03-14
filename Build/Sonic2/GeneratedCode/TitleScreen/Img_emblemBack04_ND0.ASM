(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemBack04
	STD DYN_POS+1,PCR
	LDU ,Y
	LEAU -2715,U

	LDD #$8888
	LDX #$8677
	LDY #$ece0
	PSHU D,X,Y
	LDA #$ed
	LDX #$d77c
	PSHU A,X
	LEAU -31,U

	LDD #$6666
	LDX #$6777
	LDY #$cd0e
	PSHU D,X,Y
	LDD -36,U
	LDA #$dd
	ANDB #$0F
	ORB #$e0
	STD -36,U
	LDA #$0e
	LDX #$ed77
	PSHU A,X
	LEAU -33,U

	LDA #$d0
	STA -7,U
	LDD #$ce77
	LDX #$7777
	LDY #$777d
	PSHU D,X,Y
	LEAU -33,U

	LDD -8,U
	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD -8,U
	LDD #$d777
	LDY #$eede
	PSHU D,X,Y
	LEAU -34,U

	LDA #$ed
	STA -7,U
	LDA #$ee
	LDX #$777d
	LDY #$cce0
	PSHU D,X,Y
	LEAU -34,U

	LDA #$0e
	STA -7,U
	LDD #$ccee
	LDX #$eeee
	LDY #$dd0e
	PSHU D,X,Y
	LEAU -35,U

	LDD #$e0ed
	LDX #$cccc
	LDY #$ccee
	PSHU D,X,Y
	LEAU -34,U

	LDD -42,U
	LDA #$e0
	ANDB #$0F
	ORB #$e0
	STD -42,U
	LDA #$0e
	LDX #$dddd
	LDY #$de00
	PSHU A,X,Y
	LEAU -37,U

	LDA #$d0
	LDX #$eeee
	PSHU A,X
	LEAU -36,U

	LDA #$00
	LDX #$000d
	PSHU A,X
DYN_POS

	LDU #$0000
	LEAU -2717,U

	LDD ,U
	LDA #$dd
	ANDB #$0F
	ORB #$e0
	STD ,U
	LDD #$dcce
	STD -8,U
	LDD #$77c8
	LDX #$8888
	LDY #$e677
	PSHU D,X,Y
	LEAU -33,U

	LDD #$dc77
	STD -8,U
	LDA -9,U
	ANDA #$F0
	ORA #$0d
	STA -9,U
	LDD #$7666
	LDX #$66c7
	LDY #$7ede
	PSHU D,X,Y
	LEAU -34,U

	LDD #$ede7
	STD -8,U
	LDD #$7777
	LDX #$7777
	LDY #$ece0
	PSHU D,X,Y
	LEAU -34,U

	LDD #$0ece
	STD -8,U
	LDD -42,U
	LDA #$de
	ANDB #$0F
	ORB #$e0
	STD -42,U
	LDD #$7777
	LDY #$cd0e
	PSHU D,X,Y
	LEAU -36,U

	LDD #$d0dc
	LDX #$e777
	LDY #$77ee
	PSHU D,X,Y
	LEAU -33,U

	LDA -7,U
	ANDA #$F0
	ORA #$0d
	STA -7,U
	LDD #$edce
	LDX #$eeee
	LDY #$cce0
	PSHU D,X,Y
	LEAU -34,U

	LDD -42,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -42,U
	LDD #$0edc
	LDX #$cccc
	LDY #$dd0d
	PSHU D,X,Y
	LEAU -36,U

	LDD #$d0ed
	LDX #$dddd
	PSHU D,X
	LEAU -35,U

	LDD #$0eee
	LDX #$ee00
	PSHU D,X
	LEAU -37,U

	LDA #$e0
	LDX #$0000
	PSHU A,X
	RTS

(info)

