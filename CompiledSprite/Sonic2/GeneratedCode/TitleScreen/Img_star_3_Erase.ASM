(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_star_3
	STS ERASE_SSAV_Img_star_3+1,PCR

	LEAS ,U
ERASE_CODE_Img_star_3_1
	PULS A,U
	STA ,U

	PULS A,U
	STA 120,U

	PULS A,B
	STA 80,U
	STB 40,U

	PULS A,B
	STA -40,U
	STB ,U

	PULS A,X
	STA -80,U
	STX -121,U

	PULS A,B,U
	STA 80,U
	STB 120,U

	PULS A,B
	STA 40,U
	STB ,U

	PULS A,B
	STA -40,U
	STB -80,U

	PULS A
	STA -120,U

	PULS A,U
	STA 80,U

	PULS A,B
	STA 40,U
	STB -40,U

	PULS A,X
	STA -80,U
	STX ,U

	LEAU ,S
ERASE_SSAV_Img_star_3
	LDS #$0000
	RTS

(info)

