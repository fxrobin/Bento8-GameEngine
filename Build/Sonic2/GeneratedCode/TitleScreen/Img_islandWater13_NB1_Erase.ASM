(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_islandWater13
	STS ERASE_SSAV_Img_islandWater13+1,PCR

	LEAS ,U
ERASE_CODE_Img_islandWater13_1
	PULS A,U
	STA 1,U

	PULS A
	STA -1,U

	PULS A,U
	STA ,U

	LEAU ,S
ERASE_SSAV_Img_islandWater13
	LDS #$0000
	RTS

(info)

DataSize equ $0007
