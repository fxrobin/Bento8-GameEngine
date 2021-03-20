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

	PULS D,U
	STD 3,U

	PULS D,X,Y
	STD -1,U
	STX 1,U
	STY -3,U

	LEAU ,S
ERASE_SSAV_Img_islandWater07
	LDS #$0000
	RTS

(info)

DataSize equ $0013
