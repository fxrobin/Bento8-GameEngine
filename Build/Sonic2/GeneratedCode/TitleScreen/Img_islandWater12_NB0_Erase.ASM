(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_islandWater12
	STS ERASE_SSAV_Img_islandWater12+1,PCR

	LEAS ,U
ERASE_CODE_Img_islandWater12_1
	PULS D,U
	STD 1,U

	PULS D
	STD -1,U

	PULS A,B,U
	STA -1,U
	STB 1,U

	LEAU ,S
ERASE_SSAV_Img_islandWater12
	LDS #$0000
	RTS

(info)

DataSize equ $000A
