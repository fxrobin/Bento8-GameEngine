(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_TitleScreen_SonicHand
	STS ERASE_SSAV_Img_TitleScreen_SonicHand+2,PCR

ERASE_CODE_Img_TitleScreen_SonicHand_1
	PULU A,B,S
	STA -20,S
	STB 20,S

	PULU A,S
	STA 120,S

	PULU A,B
	STA 40,S
	STB 80,S

	PULU A,B
	STA -40,S
	STB ,S

	PULU A,B
	STA -120,S
	STB -80,S

	PULU D,X,S
	STD -41,S
	STX -81,S

	PULU A,X,Y
	STA 120,S
	STX -1,S
	STY -121,S

	PULU D,X
	STD 79,S
	STX 39,S

	PULU A,X,Y,S
	STA -119,S
	STX -40,S
	STY ,S

	PULU D,X,Y
	STD 120,S
	STX 40,S
	STY 80,S

	PULU D,X
	STD -80,S
	STX -121,S

	PULU A,X,S
	PSHS A,X

	PULU A,B
	STA 122,S
	STB 42,S

	PULU A,X,Y
	STA 82,S
	STX 120,S
	STY 80,S

	PULU D
	STD 40,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA -38,S
	STX -40,S

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y
	STD 121,S
	STX 81,S
	STY 41,S

	PULU D,X,Y
	STD 119,S
	STX 79,S
	STY 39,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,B,X,Y
	STA -78,S
	STB -38,S
	STX -40,S
	STY -80,S

	PULU A,B
	STA -118,S
	STB -120,S

	PULU A,S
	STA ,S

	PULU A,S
	STA 40,S

	PULU D,X
	STD ,S
	STX -40,S

	PULU D,S
	STD 120,S

	PULU D,X,Y
	STD 80,S
	STX 40,S
	STY ,S

	PULU D,X,Y
	STD -40,S
	STX -80,S
	STY -120,S

	PULU A,B,S
	STA 80,S
	STB 120,S

	PULU A,B
	STA -79,S
	STB 40,S

	PULU A,X,Y
	STA -119,S
	STX -1,S
	STY -41,S

	PULU D,X
	STD -81,S
	STX -121,S

	PULU A,X,S
	PSHS A,X

	PULU A,B
	STA -38,S
	STB -78,S

	PULU A,B,X,Y
	STA 82,S
	STB -118,S
	STX 120,S
	STY 80,S

	PULU D,X
	STD 40,S
	STX -80,S

	PULU A,B,X,Y
	STA 42,S
	STB 122,S
	STX -40,S
	STY -120,S

	PULU A,S
	STA 1,S

	PULU D
	STD -1,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 120,S

	PULU A,B
	STA 122,S
	STB 82,S

	PULU A,X,Y
	STA 42,S
	STX 40,S
	STY 80,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,B,X,S
	PSHS B,X
	STA -79,S

	PULU D
	STD -38,S

	PULU A,B
	STA 3,S
	STB -77,S

	PULU A,B,X
	STA -117,S
	STB -119,S
	STX -40,S

	PULU A,S
	STA ,S

ERASE_SSAV_Img_TitleScreen_SonicHand
	LDS #$0000
	RTS

