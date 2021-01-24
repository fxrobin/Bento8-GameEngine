(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_TitleScreen_Tails_4
	STS ERASE_SSAV_Img_TitleScreen_Tails_4+2,PCR

ERASE_CODE_Img_TitleScreen_Tails_4_1
	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 80,S
	STX 40,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 4,S

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

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X,Y
	STD 118,S
	STX 78,S
	STY 42,S

	PULU D,X,Y
	STD 38,S
	STX 40,S
	STY 83,S

	PULU A,X,Y
	STA 44,S
	STX 80,S
	STY 120,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X
	STA 5,S
	STX 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 6,S
	STX 39,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 6,S
	STX 38,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 34,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 36,S

	PULU A,X,Y
	STA 3,S
	STX 38,S
	STY 34,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X
	STD 43,S
	STX 39,S

	PULU A,X,Y
	STA 8,S
	STX 6,S
	STY 41,S

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,S
	PSHS D,X

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

	PULU A,X
	STA 38,S
	STX 36,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 4,S
	STX 37,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 5,S
	STX 37,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 5,S
	STX 37,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 37,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 37,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 38,S
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

	PULU D
	STD 36,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 4,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 5,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 4,S

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 3,S
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

	PULU A,X,S
	PSHS A,X

	PULU D,X
	STD 38,S
	STX 3,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 6,S
	STX 40,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,S
	PSHS A,X

	PULU A,B,X,Y
	STA -36,S
	STB -76,S
	STX -40,S
	STY -80,S

	PULU A,B
	STA -120,S
	STB 4,S

	PULU A,S
	STA ,S

	PULU D,X,S
	PSHS D,X

	PULU A,B,X,Y
	STA 40,S
	STB 118,S
	STX 78,S
	STY 38,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 36,S

	PULU A,X,S
	PSHS A,X

	PULU D,X
	STD 37,S
	STX 35,S

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

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 3,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 3,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 3,S

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,B,X,Y
	STA 38,S
	STB 7,S
	STX 5,S
	STY 3,S

	PULU D,X,S
	PSHS D,X

	PULU A,B,X
	STA 6,S
	STB 38,S
	STX 4,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,Y
	STA 38,S
	STX 5,S
	STY 3,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,B
	STA 6,S
	STB 38,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,Y
	STA 38,S
	STX 5,S
	STY 3,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,Y
	STA 42,S
	STX 36,S
	STY 40,S

	PULU D,X
	STD 38,S
	STX 34,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 4,S

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,S
	PSHS A,X

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 4,S

	PULU A,X,S
	PSHS A,X

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 4,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X
	STD 39,S
	STX 6,S

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X
	STD 40,S
	STX 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X
	STA 5,S
	STX 38,S

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 3,S
	STX 36,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 38,S

	PULU A,X
	STA 3,S
	STX 36,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 119,S
	STX 80,S
	STY 40,S

	PULU A,B
	STA 84,S
	STB 44,S

	PULU A,X,Y
	STA 4,S
	STX 82,S
	STY 77,S

	PULU D,X,Y
	STD 42,S
	STX 117,S
	STY 37,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X
	STA 38,S
	STX 36,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,B,X
	STA 38,S
	STB 5,S
	STX 36,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,B
	STA 37,S
	STB 5,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 5,S

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

	PULU A,X,Y,S
	PSHS A,X,Y

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

	PULU A
	STA 6,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,B,X,S
	PSHS B,X
	STA -36,S

	PULU D
	STD 3,S

	PULU A,B
	STA -76,S
	STB -38,S

	PULU A,B
	STA -120,S
	STB -116,S

	PULU A,B
	STA -40,S
	STB -80,S

	PULU A,B,S
	STA 2,S
	STB -2,S

ERASE_SSAV_Img_TitleScreen_Tails_4
	LDS #$0000
	RTS

