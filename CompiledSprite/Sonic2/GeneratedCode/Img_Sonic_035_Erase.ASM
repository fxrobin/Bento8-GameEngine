(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_Sonic_035
	STS ERASE_SSAV_Img_Sonic_035+2,PCR

ERASE_CODE_Img_Sonic_035_1
	PULU A,S
	STA 22,S

	PULU A,B
	STA 20,S
	STB -20,S

	PULU A,X
	STA -18,S
	STX -22,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 122,S
	STX 82,S
	STY 120,S

	PULU D
	STD 80,S

	PULU A,B
	STA 124,S
	STB 84,S

	PULU A,B,X,Y
	STA 44,S
	STB 4,S
	STX 42,S
	STY 40,S

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

	PULU A
	STA 4,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 4,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 4,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD -40,S

	PULU A,B
	STA 4,S
	STB -36,S

	PULU A,X,Y
	STA -38,S
	STX -120,S
	STY -80,S

	PULU A,S
	STA -60,S

	PULU A,X,Y
	STA -20,S
	STX 59,S
	STY 19,S

	PULU A,S
	STA 20,S

	PULU A
	STA -20,S

	PULU A,B,X,S
	PSHS B,X
	STA 121,S

	PULU D
	STD 81,S

	PULU A,B,X
	STA 42,S
	STB 4,S
	STX 40,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 4,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 4,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 4,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 3,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 3,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 4,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD -38,S

	PULU A,X,Y
	STA -118,S
	STX -78,S
	STY -40,S

	PULU D,X
	STD -80,S
	STX -120,S

	PULU D,S
	STD 78,S

	PULU D,X
	STD 38,S
	STX -2,S

	PULU A,B
	STA 80,S
	STB 40,S

	PULU A,B
	STA -41,S
	STB ,S

	PULU A
	STA -81,S

ERASE_SSAV_Img_Sonic_035
	LDS #$0000
	RTS

