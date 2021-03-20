(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_islandWater15
	STS ERASE_SSAV_Img_islandWater15+1,PCR

	LEAS ,U
ERASE_CODE_Img_islandWater15_1
	PULS A,U
	STA ,U

	LEAU ,S
ERASE_SSAV_Img_islandWater15
	LDS #$0000
	RTS

(info)

DataSize equ $0003
