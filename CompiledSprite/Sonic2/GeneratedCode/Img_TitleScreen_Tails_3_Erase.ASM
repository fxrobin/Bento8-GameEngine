(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_TitleScreen_Tails_3
	STS ERASE_SSAV_Img_TitleScreen_Tails_3+2,PCR

ERASE_CODE_Img_TitleScreen_Tails_3_1
	PULU A,S
	STA ,S

	PULU A,X,Y,S
	PSHS X,Y
	STA 82,S

	PULU D,X,Y
	STD 120,S
	STX 80,S
	STY 40,S

	PULU A,X
	STA 5,S
	STX 42,S

	PULU A,X,S
	PSHS A,X

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 7,S
	STX 5,S

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 7,S
	STX 5,S

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 4,S

	PULU A,X,S
	PSHS A,X

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 4,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X
	STA 38,S
	STX 36,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X
	STD 37,S
	STX 35,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X
	STD 37,S
	STX 35,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X
	STA 38,S
	STX 36,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X
	STA 38,S
	STX 36,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 36,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 36,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 4,S
	STX 36,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 36,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 117,S
	STX 42,S
	STY 82,S

	PULU A,B
	STA 78,S
	STB 38,S

	PULU A,B,X,Y
	STA 36,S
	STB 5,S
	STX 115,S
	STY 80,S

	PULU D,X
	STD 75,S
	STX 40,S

	PULU D,X,S
	PSHS D,X

	PULU A,B
	STA 38,S
	STB 5,S

	PULU D,X,S
	PSHS D,X

	PULU A,B
	STA 38,S
	STB 4,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 4,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 4,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 4,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 4,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 4,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 4,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 5,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 5,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 5,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 5,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 4,S
	STX -40,S

	PULU A,B,X,Y
	STA -36,S
	STB -38,S
	STX -80,S
	STY -120,S

	PULU A,B,S
	STA -20,S
	STB -60,S

	PULU A,B
	STA 100,S
	STB 20,S

	PULU A,B
	STA 60,S
	STB -100,S

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 80,S
	STX 40,S

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 5,S
	STX 3,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 3,S

	PULU A,X,S
	PSHS A,X

	PULU D,X
	STD 6,S
	STX 4,S

	PULU A,X,S
	PSHS A,X

	PULU D,X
	STD 6,S
	STX 4,S

	PULU A,X,S
	PSHS A,X

	PULU D,X
	STD 6,S
	STX 4,S

	PULU A,X,S
	PSHS A,X

	PULU D,X
	STD 6,S
	STX 4,S

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y
	STD 4,S
	STX -36,S
	STY -41,S

	PULU D,X,Y
	STD -76,S
	STX -81,S
	STY -121,S

	PULU D,X,Y
	STD -115,S
	STX -119,S
	STY -79,S

	PULU D,X,Y
	STD 6,S
	STX -39,S
	STY -74,S

	PULU A,B,X
	STA -113,S
	STB -117,S
	STX -34,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 115,S
	STX 79,S
	STY 75,S

	PULU D,X,Y
	STD 39,S
	STX 35,S
	STY 77,S

	PULU D
	STD 37,S

	PULU A,B,X,Y
	STA 119,S
	STB 43,S
	STX 81,S
	STY 117,S

	PULU D,X
	STD 121,S
	STX 41,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 4,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 4,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 38,S

	PULU A,X
	STA 3,S
	STX 35,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 39,S

	PULU A,X
	STA 4,S
	STX 36,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X
	STA 5,S
	STX 37,S

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 3,S
	STX 35,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 39,S

	PULU A,X
	STA 4,S
	STX 36,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 37,S

	PULU A,X
	STA 6,S
	STX 4,S

	PULU A,B,X,S
	PSHS B,X
	STA 5,S

	PULU A,X
	STA 3,S
	STX 35,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU A,X
	STA 5,S
	STX 35,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 38,S
	STX 35,S

	PULU D,X,S
	PSHS D,X

	PULU A,B
	STA 35,S
	STB 38,S

	PULU D,X,S
	PSHS D,X

	PULU A,B
	STA 38,S
	STB 4,S

	PULU D,X,S
	PSHS D,X

	PULU A,B
	STA 38,S
	STB 4,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 37,S
	STX 4,S

	PULU D,X,S
	PSHS D,X

	PULU A,B
	STA 37,S
	STB 4,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,B
	STA 37,S
	STB 5,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,B
	STA 37,S
	STB 5,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 4,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 4,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 3,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 4,S
	STX 38,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 4,S
	STX 38,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 4,S
	STX 38,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 3,S
	STX 38,S

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 3,S
	STX 38,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU A,X,Y,S
	PSHS X,Y
	STA -80,S

	PULU D,X,Y
	STD 38,S
	STX -2,S
	STY -42,S

	PULU D,X
	STD -82,S
	STX -122,S

	PULU A,B,X
	STA -77,S
	STB -37,S
	STX -40,S

	PULU D,S
	STD 120,S

	PULU D,X
	STD 80,S
	STX 40,S

	PULU A,B
	STA -40,S
	STB -80,S

	PULU A,X
	STA -120,S
	STX ,S

ERASE_SSAV_Img_TitleScreen_Tails_3
	LDS #$0000
	RTS

