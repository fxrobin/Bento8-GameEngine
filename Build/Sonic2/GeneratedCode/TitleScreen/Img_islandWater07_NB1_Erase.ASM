(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_islandWater07
	STS ERASE_SSAV_Img_islandWater07+1,PCR

	LEAS ,U
ERASE_CODE_Img_islandWater07_1
	PULS D,X,Y,U
	PSHU D,X,Y

	PULS A
	STA 6,U

	PULS A,X,U
	PSHU A,X

	PULS D,X
	STD 5,U
	STX 3,U

	LEAU ,S
ERASE_SSAV_Img_islandWater07
	LDS #$0000
	RTS

(info)

DataSize equ $0012
