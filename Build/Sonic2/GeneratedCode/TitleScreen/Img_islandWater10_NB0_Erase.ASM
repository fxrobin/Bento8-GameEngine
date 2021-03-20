(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_islandWater10
	STS ERASE_SSAV_Img_islandWater10+1,PCR

	LEAS ,U
ERASE_CODE_Img_islandWater10_1
	PULS D,U
	STD 1,U

	PULS D
	STD -1,U

	PULS A,U
	STA 2,U

	PULS D,X
	STD ,U
	STX -2,U

	LEAU ,S
ERASE_SSAV_Img_islandWater10
	LDS #$0000
	RTS

(info)

DataSize equ $000D
