(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_star_1
	STS ERASE_SSAV_Img_star_1+1,PCR

ERASE_CODE_Img_star_1_1
	PULU A,S
	STA 80,S

	PULU A,B
	STA ,S
	STB -80,S

	PULU A,S
	STA 80,S

	PULU A
	STA -80,S

ERASE_SSAV_Img_star_1
	LDS #$0000
	RTS

(info)

