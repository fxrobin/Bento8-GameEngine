(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_islandWater11
	STS ERASE_SSAV_Img_islandWater11+1,PCR

	LEAS ,U
ERASE_CODE_Img_islandWater11_1
	PULS D,U
	STD ,U

	PULS A,U
	STA -1,U

	PULS D
	STD 1,U

	LEAU ,S
ERASE_SSAV_Img_islandWater11
	LDS #$0000
	RTS

(info)

DataSize equ $0009
