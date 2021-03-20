(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_islandMask_1
	STD DYN_POS+1,PCR
	LDU ,Y
	LEAU 896,U

	LDD ,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD ,U
	LDD #$ffff
	LDX #$ffff
	LDY #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	LDD -34,U
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD -34,U
	PSHU X,Y
	LEAU -30,U

	LDD #$ffff
	PSHU D,X,Y
	PSHU D,X
DYN_POS

	LDU #$0000
	LEAU 897,U

	LDD #$ffff
	LDX #$ffff
	LDY #$ffff
	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	LEAU -28,U

	PSHU D,X,Y
	PSHU D,X,Y
	RTS

(info)

