(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_TitleScreen_Star_4
	STS ERASE_SSAV_Img_TitleScreen_Star_4+2,PCR

ERASE_CODE_Img_TitleScreen_Star_4_1
	PULU A,S
	STA ,S

	PULU A,S
	STA 120,S

	PULU A,B
	STA 80,S
	STB 40,S

	PULU A,B
	STA ,S
	STB -80,S

	PULU A,X
	STA -120,S
	STX -41,S

	PULU A,X,S
	PSHS A,X

	PULU A,B
	STA 41,S
	STB 81,S

	PULU A,B
	STA -79,S
	STB -39,S

	PULU A,B
	STA 121,S
	STB -119,S

	PULU A,S
	STA ,S

	PULU A,S
	STA 120,S

	PULU A,B
	STA 40,S
	STB ,S

	PULU A,B
	STA -40,S
	STB -80,S

	PULU A,X
	STA -120,S
	STX 79,S

	PULU A,S
	STA 100,S

	PULU A,X,Y
	STA -61,S
	STX 19,S
	STY -101,S

	PULU D,S
	STD 118,S

	PULU D
	STD 79,S

	PULU A,B
	STA 39,S
	STB 120,S

	PULU A,X
	STA -120,S
	STX -41,S

ERASE_SSAV_Img_TitleScreen_Star_4
	LDS #$0000
	RTS

