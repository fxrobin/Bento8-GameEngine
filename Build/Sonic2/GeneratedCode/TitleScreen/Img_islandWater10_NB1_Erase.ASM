(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_islandWater10
	STS ERASE_SSAV_Img_islandWater10+1,PCR

	LEAS ,U
ERASE_CODE_Img_islandWater10_1
	PULS A,X,U
	PSHU A,X

	PULS A,X,U
	STA -1,U
	STX 1,U

	LEAU ,S
ERASE_SSAV_Img_islandWater10
	LDS #$0000
	RTS

(info)

DataSize equ $000A
