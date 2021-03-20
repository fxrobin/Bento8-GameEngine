(main)IMGD.ASM
	ORG $A000
	SETDP $FF
BCKDRAW_Img_islandWater02
	STS SSAV_Img_islandWater02+1,PCR

	STD DYN_POS+1,PCR
	LEAS ,U
	LDU ,Y
	LEAU 703,U

	PULU D,X,Y
	PSHS U,Y,X,D
	LDD #$2c2c
	LDX #$2c22
	LDY #$2c2c
	PSHU D,X,Y
	LEAU 6,U

	LDD 3,U
	PSHS D
	ANDA #$0F
	ORA #$20
	LDB #$88
	STD 3,U
	PULU A,X
	PSHS U,X,A
	LDA #$2c
	PSHU A,Y
	LEAU 5,U

	PULU D,X,Y
	PSHS U,Y,X,D
	LDD #$0d2d
	LDX #$82c2
	LDY #$ddbd
	PSHU D,X,Y
	LEAU 6,U

	PULU D,X,Y
	PSHS U,Y,X,D
	LDD #$d22c
	LDX #$222c
	LDY #$2c2c
	PSHU D,X,Y
	LEAU 6,U

	PULU D,X,Y
	PSHS U,Y,X,D
	LDD #$2c22
	LDX #$2c2c
	LDY #$2c2c
	PSHU D,X,Y
	LEAU 6,U

	PULU A,X,Y
	PSHS U,Y,X,A
	LDA #$2c
	LDX #$2c2c
	LDY #$2c2c
	PSHU A,X,Y
DYN_POS

	LDU #$0000
	LEAU 703,U

	PULU D,X,Y
	PSHS U,Y,X,D
	LDD #$cccc
	LDX #$cc2c
	LDY #$cccc
	PSHU D,X,Y
	LEAU 6,U

	PULU A,X
	PSHS U,X,A
	PSHU B,Y
	LEAU 4,U

	PULU D,X,Y
	PSHS U,Y,X,D
	LDD #$8cd2
	LDX #$28d2
	LDY #$d2d2
	PSHU D,X,Y
	LEAU 6,U

	PULU D,X,Y
	PSHS U,Y,X,D
	LDD #$22dc
	LDX #$cc2c
	LDY #$cccc
	PSHU D,X,Y
	LEAU 6,U

	PULU D,X,Y
	PSHS U,Y,X,D
	LDD #$cccc
	LDX #$2ccc
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

