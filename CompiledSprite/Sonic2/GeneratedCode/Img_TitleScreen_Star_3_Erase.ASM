(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_TitleScreen_Star_3
	STS ERASE_SSAV_Img_TitleScreen_Star_3+2,PCR

ERASE_CODE_Img_TitleScreen_Star_3_1
	PULU A,S
	STA ,S

	PULU A,S
	STA 120,S

	PULU A,B
	STA 80,S
	STB 40,S

	PULU A,B
	STA -40,S
	STB ,S

	PULU A,X
	STA -80,S
	STX -121,S

	PULU A,B,S
	STA 80,S
	STB 120,S

	PULU A,B
	STA 40,S
	STB ,S

	PULU A,B
	STA -40,S
	STB -80,S

	PULU A
	STA -120,S

	PULU A,S
	STA 80,S

	PULU A,B
	STA 40,S
	STB -40,S

	PULU A,X
	STA -80,S
	STX ,S

ERASE_SSAV_Img_TitleScreen_Star_3
	LDS #$0000
	RTS

