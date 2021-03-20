(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_islandWater08
	STS ERASE_SSAV_Img_islandWater08+1,PCR

	LEAS ,U
ERASE_CODE_Img_islandWater08_1
	PULS A,U
	STA 1,U

	PULS D
	STD -2,U

	PULS A,U
	STA -1,U

	PULS D
	STD 1,U

	LEAU ,S
ERASE_SSAV_Img_islandWater08
	LDS #$0000
	RTS

(info)

DataSize equ $000A
