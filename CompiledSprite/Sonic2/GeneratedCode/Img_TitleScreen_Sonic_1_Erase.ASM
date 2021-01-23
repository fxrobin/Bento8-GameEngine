(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_TitleScreen_Sonic_1
	STS ERASE_SSAV_Img_TitleScreen_Sonic_1+2,PCR

ERASE_CODE_Img_TitleScreen_Sonic_1_1
	PULU D,X,S
	PSHS D,X

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

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 40,S

	PULU A,X,Y,S
	PSHS A,X,Y

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

	PULU A
	STA 6,S

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

	PULU D
	STD 6,S

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

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 6,S
	STX 40,S

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

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X
	STA 5,S
	STX 38,S

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

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 38,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 36,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X
	STA 37,S
	STX 39,S

	PULU D,X,S
	PSHS D,X

	PULU A,B
	STA 37,S
	STB 4,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD -40,S
	STX -79,S
	STY -38,S

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

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 38,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 39,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 4,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 5,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 4,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 6,S
	STX 40,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 5,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X
	STA 5,S
	STX 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 6,S
	STX 40,S

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

	PULU A
	STA 6,S

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

	PULU A,X
	STA 6,S
	STX 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 6,S
	STX 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 6,S
	STX 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 6,S
	STX 38,S

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

	PULU A,X
	STA 8,S
	STX 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 38,S

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

	PULU D
	STD 6,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 5,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,B
	STA 38,S
	STB 5,S

	PULU A,X,S
	PSHS A,X

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 39,S

	PULU A,B,X,S
	PSHS B,X
	STA -38,S

	PULU D
	STD -40,S

ERASE_SSAV_Img_TitleScreen_Sonic_1
	LDS #$0000
	RTS

