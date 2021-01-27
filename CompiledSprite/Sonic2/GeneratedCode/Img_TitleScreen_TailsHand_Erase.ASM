(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_TitleScreen_TailsHand
	STS ERASE_SSAV_Img_TitleScreen_TailsHand+2,PCR

ERASE_CODE_Img_TitleScreen_TailsHand_1
	PULU D,S
	STD 39,S

	PULU D,X
	STD -1,S
	STX -41,S

	PULU A,B
	STA -80,S
	STB 79,S

	PULU A,S
	STA -120,S

	PULU A,B
	STA ,S
	STB -80,S

	PULU A,B
	STA 120,S
	STB 80,S

	PULU A,B
	STA -40,S
	STB 40,S

	PULU A,B,S
	STA -40,S
	STB 80,S

	PULU A,B
	STA -80,S
	STB -120,S

	PULU A,B
	STA 40,S
	STB ,S

	PULU A
	STA 120,S

	PULU A,B,S
	STA 20,S
	STB 60,S

	PULU A,B
	STA -60,S
	STB -20,S

	PULU D,X,S
	STD ,S
	STX -80,S

	PULU A,X,Y
	STA 120,S
	STX -40,S
	STY -120,S

	PULU D,X
	STD 80,S
	STX 40,S

	PULU D,S
	STD -40,S

	PULU D
	STD -80,S

	PULU A,X,Y
	STA -120,S
	STX 40,S
	STY ,S

	PULU D,X
	STD 120,S
	STX 80,S

ERASE_SSAV_Img_TitleScreen_TailsHand
	LDS #$0000
	RTS

