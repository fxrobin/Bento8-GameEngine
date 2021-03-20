(main)IMGD.ASM
	ORG $A000
	SETDP $FF
BCKDRAW_Img_islandWater02
	STS SSAV_Img_islandWater02+1,PCR

	STD DYN_POS+1,PCR
	LEAS ,U
	LDU ,Y
	LEAU 705,U

	LDD -2,U
	PSHS D
	ANDA #$F0
	ORA #$02
	LDB #$c2
	STD -2,U
	LDD 8,U
	PSHS D
	ANDA #$F0
	ORA #$08
	LDB #$c0
	STD 8,U
	LDX 6,U
	PSHS X
	LDD #$c2c2
	STD 6,U
	PULU D,X,Y
	PSHS U,Y,X,D
	LDD #$c2c2
	LDX #$c2c2
	LDY #$c2c2
	PSHU D,X,Y
	LEAU 10,U

	PULU D,X,Y
	PSHS U,Y,X,D
	LDD #$2288
	LDX #$2c2d
	LDY #$2b2d
	PSHU D,X,Y
	LEAU 6,U

	PULU D,X,Y
	PSHS U,Y,X,D
	LDD #$c2c2
	LDX #$c2c2
	LDY #$c2c2
	PSHU D,X,Y
	LEAU 6,U

	PULU D,X,Y
	PSHS U,Y,X,D
	LDD #$c2c2
	LDX #$c2c2
	LDY #$c2c2
	PSHU D,X,Y
	LEAU 6,U

	LDA 4,U
	PSHS A
	ANDA #$0F
	ORA #$c0
	STA 4,U
	PULU X,Y
	PSHS U,Y,X
	LDD #$c2c2
	LDX #$c2c2
	PSHU D,X
DYN_POS

	LDU #$0000
	LEAU 703,U

	PULU D,X,Y
	PSHS U,Y,X,D
	LDD #$cccc
	LDX #$cc22
	LDY #$cccc
	PSHU D,X,Y
	LEAU 6,U

	PULU A,X
	PSHS U,X,A
	PSHU B,Y
	LEAU 4,U

	PULU D,X,Y
	PSHS U,Y,X,D
	LDD #$88dd
	LDX #$d22d
	LDY #$2ddd
	PSHU D,X,Y
	LEAU 6,U

	PULU D,X,Y
	PSHS U,Y,X,D
	LDD #$d22d
	LDX #$cc22
	LDY #$cccc
	PSHU D,X,Y
	LEAU 6,U

	PULU D,X,Y
	PSHS U,Y,X,D
	LDD #$cccc
	LDX #$22cc
	LDY #$cccc
	PSHU D,X,Y
	LEAU 6,U

	PULU D,X,Y
	PSHS U,Y,X,D
	LDD #$cccc
	LDX #$cccc
	LDY #$cccc
	PSHU D,X,Y
	LEAU ,S
SSAV_Img_islandWater02
	LDS #$0000
	RTS

(info)

