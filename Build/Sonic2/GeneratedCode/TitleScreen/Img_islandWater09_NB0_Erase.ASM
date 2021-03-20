(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_islandWater09
	STS ERASE_SSAV_Img_islandWater09+1,PCR

	LEAS ,U
ERASE_CODE_Img_islandWater09_1
	PULS A,U
	STA ,U

	PULS A,U
	STA 1,U

	PULS D
	STD -1,U

	LEAU ,S
ERASE_SSAV_Img_islandWater09
	LDS #$0000
	RTS

(info)

DataSize equ $0008
