(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_TitleScreen_Sonic_2
	STS ERASE_SSAV_Img_TitleScreen_Sonic_2+2,PCR

ERASE_CODE_Img_TitleScreen_Sonic_2_1
	PULU D,S
	STD ,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 120,S

	PULU A,B,X,Y
	STA 82,S
	STB 42,S
	STX 40,S
	STY 80,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D,X
	STD -39,S
	STX -41,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 121,S

	PULU A,X,Y
	STA 3,S
	STX 41,S
	STY 81,S

	PULU D,X,Y
	STD 119,S
	STX 79,S
	STY 39,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 6,S
	STX 4,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 4,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 39,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,S
	PSHS A,X

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 39,S

	PULU D,X,S
	PSHS D,X

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

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X
	STD 40,S
	STX 6,S

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

	PULU D,X,Y,S
	PSHS D,X,Y

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

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X
	STD 40,S
	STX 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

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

	PULU D,X,Y,S
	PSHS D,X,Y

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

	PULU D,X,Y,S
	PSHS D,X,Y

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

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 8,S
	STX 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 8,S
	STX 6,S

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

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X
	STA 5,S
	STX 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 39,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

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

	PULU A
	STA 6,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 39,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 38,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 4,S
	STX 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 39,S

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD -39,S

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y
	STD 121,S
	STX 41,S
	STY 81,S

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

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,B,X,Y
	STA 45,S
	STB 83,S
	STX 41,S
	STY 81,S

	PULU D,X,Y
	STD 79,S
	STX 43,S
	STY 39,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,S
	PSHS D,X

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 39,S

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

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,B,X
	STA 7,S
	STB 5,S
	STX 40,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 7,S

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

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 8,S
	STX 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 8,S
	STX 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 6,S
	STX 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X
	STD 39,S
	STX 6,S

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

	PULU D
	STD 6,S

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

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

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

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 8,S
	STX 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 8,S
	STX 6,S

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

	PULU D
	STD 6,S

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

	PULU A
	STA 6,S

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
	STA 6,S

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
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 39,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA -2,S
	STX -40,S

ERASE_SSAV_Img_TitleScreen_Sonic_2
	LDS #$0000
	RTS

