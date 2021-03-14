(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemFront07
	STD DYN_POS+1,PCR
	LDU ,Y
	LEAU 3161,U

	LDD ,U
	LDA #$11
	ANDB #$0F
	ORB #$10
	STD ,U
	LDD -40,U
	LDA #$11
	ANDB #$0F
	ORB #$10
	STD -40,U
	LDX #$1111
	PSHU A,X
	LEAU -37,U

	PSHU A,X
	LEAU -35,U

	LDY #$1111
	PSHU A,X,Y
	LEAU -35,U

	LDA #$cc
	LDX #$cccc
	LDY #$cccc
	PSHU A,X,Y
	LEAU -35,U

	LDA #$ee
	LDX #$eeee
	LDY #$eeec
	PSHU A,X,Y
	LEAU -35,U

	PSHU A,X,Y
	LEAU -35,U

	PSHU A,X,Y
	LEAU -35,U

	PSHU A,X,Y
	LEAU -35,U

	LDY #$eee0
	PSHU A,X,Y
	LEAU -35,U

	PSHU A,X,Y
	LEAU -35,U

	PSHU A,X,Y
	LEAU -35,U

	PSHU A,X,Y
	LEAU -35,U

	LDX #$1111
	LDY #$1110
	PSHU A,X,Y
	LEAU -35,U

	LDD -42,U
	LDA #$ee
	ANDB #$0F
	ORB #$10
	STD -42,U
	LDX #$00cc
	LDY #$0c00
	PSHU A,X,Y
	LEAU -37,U

	LDD -40,U
	LDA #$ee
	ANDB #$0F
	ORB #$c0
	STD -40,U
	LDX #$eeee
	PSHU A,X
	LEAU -37,U

	PSHU A,X
	LEAU -35,U

	LDY #$eee1
	PSHU A,X,Y
	LEAU -35,U

	PSHU A,X,Y
	LEAU -35,U

	LDA #$1e
	LDY #$eeec
	PSHU A,X,Y
DYN_POS

	LDU #$0000
	LEAU 3162,U

	LDD #$1111
	LDX #$1111
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$01
	STA -5,U
	LDD #$1111
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$01
	STA -5,U
	LDD #$1111
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0c
	STA -5,U
	LDD #$cccc
	LDX #$cccc
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$01
	STA -5,U
	LDD #$eeee
	LDX #$eeee
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$01
	STA -5,U
	LDD #$eeee
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$01
	STA -5,U
	LDD #$eeee
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$01
	STA -5,U
	LDD #$eeee
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$01
	STA -5,U
	LDD #$eeee
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$01
	STA -5,U
	LDD #$eeee
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$01
	STA -5,U
	LDD #$eeee
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$01
	STA -5,U
	LDD #$eeee
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$01
	STA -5,U
	LDD #$ee11
	LDX #$1111
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$01
	STA -5,U
	LDD #$ee0c
	LDX #$cccc
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$01
	STA -5,U
	LDD #$eeee
	LDX #$eeec
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$00
	STA -5,U
	LDD #$eeee
	LDX #$eeee
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$00
	STA -5,U
	LDD #$edee
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$00
	STA -5,U
	LDD #$edee
	PSHU D,X
	LEAU -36,U

	LDA #$ee
	PSHU D,X
	RTS

(info)

