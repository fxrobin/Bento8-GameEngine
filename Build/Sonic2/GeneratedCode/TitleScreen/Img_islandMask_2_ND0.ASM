(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_islandMask_2
	STD DYN_POS+1,PCR
	LDU ,Y
	LEAU 890,U

	LDD ,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD ,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD #$ffff
	LDX #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD -40,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -40,U
	LDD #$ffff
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0f
	STA -5,U
	LDD #$ffff
	PSHU D,X
DYN_POS

	LDU #$0000
	LEAU 891,U

	LDD #$ffff
	LDX #$ffff
	LDY #$ffff
	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	RTS

(info)

