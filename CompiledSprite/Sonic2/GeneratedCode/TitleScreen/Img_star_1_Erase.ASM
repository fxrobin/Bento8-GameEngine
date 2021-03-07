(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_star_1
	STS ERASE_SSAV_Img_star_1+1,PCR

	LEAS ,U
ERASE_CODE_Img_star_1_1
	PULS A,U
	STA 80,U

	PULS A,B
	STA ,U
	STB -80,U

	PULS A,U
	STA 80,U

	PULS A
	STA -80,U

	LEAU ,S
ERASE_SSAV_Img_star_1
	LDS #$0000
	RTS

(info)

