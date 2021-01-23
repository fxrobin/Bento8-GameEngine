(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_TitleScreen_Tails_1
	STS ERASE_SSAV_Img_TitleScreen_Tails_1+2,PCR

ERASE_CODE_Img_TitleScreen_Tails_1_1
	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD -38,S
	STX -118,S
	STY -78,S

	PULU D,X,Y
	STD -40,S
	STX -80,S
	STY -120,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 122,S
	STX 42,S
	STY 82,S

	PULU D,X,Y
	STD 120,S
	STX 80,S
	STY 40,S

	PULU D,X,S
	PSHS D,X

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

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 40,S

	PULU A,X,S
	PSHS A,X

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

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 36,S

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 36,S
	STX 38,S

	PULU A,X,S
	PSHS A,X

	PULU D,X
	STD 38,S
	STX 36,S

	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD 39,S
	STX 37,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 39,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 38,S

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 3,S
	STX 37,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 39,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 39,S

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

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 37,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 39,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU A,B,X,S
	PSHS B,X
	STA -38,S

	PULU D,X,Y
	STD 41,S
	STX 39,S
	STY -40,S

	PULU D,X
	STD -119,S
	STX -79,S

	PULU A,X,S
	STA -40,S
	STX 39,S

	PULU D
	STD -1,S

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

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 39,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 39,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X,S
	PSHS D,X

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

	PULU A,X
	STA 4,S
	STX 39,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 38,S

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 3,S
	STX 38,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 4,S
	STX 39,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 38,S

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

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 38,S

	PULU D,X,S
	PSHS D,X

	PULU A,B
	STA 38,S
	STB 4,S

	PULU A,X,Y,S
	PSHS A,X,Y

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

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 4,S
	STX 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 40,S

	PULU D,X,S
	PSHS D,X

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

	PULU A
	STA 38,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU D,X
	STD 39,S
	STX 41,S

	PULU A,B,X,S
	PSHS B,X
	STA -38,S

	PULU D,X,Y
	STD -40,S
	STX -119,S
	STY -79,S

	PULU A,B,S
	STA -20,S
	STB 20,S

	PULU D
	STD 59,S

	PULU A
	STA -60,S

ERASE_SSAV_Img_TitleScreen_Tails_1
	LDS #$0000
	RTS

