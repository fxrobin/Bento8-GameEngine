(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_islandWater12
	STS ERASE_SSAV_Img_islandWater12+1,PCR

	LEAS ,U
ERASE_CODE_Img_islandWater12_1
	PULS A,U
	STA ,U

	PULS A,U
	STA 1,U

	PULS D
	STD -2,U

	LEAU ,S
ERASE_SSAV_Img_islandWater12
	LDS #$0000
	RTS

(info)

DataSize equ $0008
