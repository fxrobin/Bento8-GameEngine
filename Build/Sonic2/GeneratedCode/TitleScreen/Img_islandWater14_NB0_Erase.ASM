(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_islandWater14
	STS ERASE_SSAV_Img_islandWater14+1,PCR

	LEAS ,U
ERASE_CODE_Img_islandWater14_1
	PULS A,U
	STA ,U

	PULS D,U
	STD ,U

	LEAU ,S
ERASE_SSAV_Img_islandWater14
	LDS #$0000
	RTS

(info)

DataSize equ $0007
