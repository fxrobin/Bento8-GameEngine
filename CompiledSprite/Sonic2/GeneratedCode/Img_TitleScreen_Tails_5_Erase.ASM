(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_TitleScreen_Tails_5
	STS ERASE_SSAV_Img_TitleScreen_Tails_5+2,PCR

ERASE_CODE_Img_TitleScreen_Tails_5_1
	PULU D,X,S
	STD -59,S
	STX -19,S

	PULU A,B,X,Y
	STA 21,S
	STB 60,S
	STX 19,S
	STY -21,S

	PULU D,X
	STD -57,S
	STX -61,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 124,S
	STX 120,S
	STY 84,S

	PULU D,X,Y
	STD 80,S
	STX 44,S
	STY 40,S

	PULU D,X,Y
	STD 4,S
	STX 46,S
	STY 86,S

	PULU D,X,Y
	STD 42,S
	STX 122,S
	STY 126,S

	PULU D,X
	STD 6,S
	STX 82,S

	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD 6,S
	STX 4,S

	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD 6,S
	STX 4,S

	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD 6,S
	STX 4,S

	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD 4,S
	STX 6,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 3,S

	PULU D,X,S
	PSHS D,X

	PULU A,X,Y
	STA 8,S
	STX 6,S
	STY 4,S

	PULU D,X,S
	PSHS D,X

	PULU A,X,Y
	STA 8,S
	STX 6,S
	STY 4,S

	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD 6,S
	STX 4,S

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y
	STD 77,S
	STX 81,S
	STY 37,S

	PULU D,X,Y
	STD 41,S
	STX 79,S
	STY 75,S

	PULU D,X
	STD 39,S
	STX 35,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 38,S

	PULU A,X
	STA 3,S
	STX 36,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 36,S

	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD 39,S
	STX 37,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 37,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 39,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 4,S
	STX 36,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU A,X
	STA 4,S
	STX 36,S

	PULU D,X,S
	PSHS D,X

	PULU A,B,X
	STA 38,S
	STB 4,S
	STX 36,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 4,S
	STX 37,S

	PULU D,X,S
	PSHS D,X

	PULU A,B,X
	STA 38,S
	STB 4,S
	STX 36,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 37,S

	PULU A,X
	STA 3,S
	STX 35,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 36,S

	PULU A,X,Y
	STA 3,S
	STX 38,S
	STY 34,S

	PULU D,X,S
	PSHS D,X

	PULU A,X,Y
	STA 36,S
	STX 38,S
	STY 34,S

	PULU D,X,S
	PSHS D,X

	PULU A,X,Y
	STA 36,S
	STX 38,S
	STY 34,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X
	STD 40,S
	STX 37,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 37,S

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

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 5,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 5,S
	STX 38,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 5,S
	STX 38,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 6,S
	STX 40,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D,X
	STD 39,S
	STX 37,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,Y
	STA 42,S
	STX -40,S
	STY -80,S

	PULU D,X
	STD -38,S
	STX 36,S

	PULU A,B,X,Y
	STA -4,S
	STB -119,S
	STX 40,S
	STY 76,S

	PULU A,B,S
	STA ,S
	STB 40,S

	PULU A
	STA -40,S

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 80,S
	STX 40,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,Y
	STA 7,S
	STX 5,S
	STY 3,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,Y
	STA 7,S
	STX 5,S
	STY 3,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 3,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,Y
	STA 7,S
	STX 5,S
	STY 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 33,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 3,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 33,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 4,S

	PULU D,X,S
	PSHS D,X

	PULU A,X,Y
	STA 8,S
	STX 6,S
	STY 4,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD 6,S
	STX 4,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD 6,S
	STX 4,S

	PULU A,X,S
	PSHS A,X

	PULU D,X
	STD 5,S
	STX 3,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD 38,S
	STX 36,S

	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD 38,S
	STX 36,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X
	STD 39,S
	STX 37,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 37,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 37,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 37,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 37,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X,S
	PSHS D,X

	PULU A,B,X
	STA 38,S
	STB 4,S
	STX 36,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 36,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 36,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 38,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 40,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 7,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 6,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 5,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 7,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,S
	PSHS A,X

	PULU D
	STD -119,S

	PULU A,X,Y
	STA -83,S
	STX -39,S
	STY -79,S

	PULU A,B,X
	STA -117,S
	STB -43,S
	STX -3,S

	PULU D,S
	STD 79,S

	PULU D
	STD 39,S

	PULU A,B,X
	STA -40,S
	STB -80,S
	STX -1,S

ERASE_SSAV_Img_TitleScreen_Tails_5
	LDS #$0000
	RTS

