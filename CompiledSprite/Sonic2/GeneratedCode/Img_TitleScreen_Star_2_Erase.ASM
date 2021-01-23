(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_TitleScreen_Star_2
	STS ERASE_SSAV_Img_TitleScreen_Star_2+2,PCR

ERASE_CODE_Img_TitleScreen_Star_2_1
	PULU A,S
	STA 120,S

	PULU A,B
	STA 80,S
	STB 40,S

	PULU A,B
	STA -40,S
	STB -80,S

	PULU A,B
	STA ,S
	STB -120,S

	PULU A,S
	STA ,S

ERASE_SSAV_Img_TitleScreen_Star_2
	LDS #$0000
	RTS

