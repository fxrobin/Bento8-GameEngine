(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_tails_2
	STS ERASE_SSAV_Img_tails_2+1,PCR

ERASE_CODE_Img_tails_2_1
	PULU A,X,S
	PSHS A,X

	PULU D
	STD 40,S

	PULU A
	STA 80,S

	PULU D,X,S
	PSHS D,X

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 34,S

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

	PULU D
	STD 6,S

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

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X
	STD 38,S
	STX 36,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 4,S
	STX 36,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 35,S

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

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 38,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 38,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 38,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 38,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 38,S

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

	PULU D
	STD 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X
	STA 6,S
	STX 39,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 6,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 5,S

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
	STA 6,S

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

	PULU A,X,S
	PSHS A,X

	PULU D
	STD -43,S

	PULU A,B,X,Y
	STA -123,S
	STB 3,S
	STX -79,S
	STY -39,S

	PULU A,X,Y
	STA -83,S
	STX -119,S
	STY -3,S

	PULU A,B,S
	STA -20,S
	STB 20,S

	PULU D
	STD 59,S

	PULU A,B
	STA 55,S
	STB -60,S

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 80,S
	STX 40,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 6,S
	STX 4,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 3,S
	STX 34,S

	PULU A,X,S
	PSHS A,X

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

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU D,X
	STD 34,S
	STX 36,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X
	STD 42,S
	STX 38,S

	PULU A,X
	STA 6,S
	STX 40,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X
	STD 39,S
	STX 6,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 34,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 4,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 39,S
	STX 35,S
	STY 37,S

	PULU A,X,S
	PSHS A,X

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 4,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,S
	PSHS A,X

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,B,X
	STA 38,S
	STB 5,S
	STX 36,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 37,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 38,S

	PULU A,X,S
	PSHS A,X

	PULU D,X
	STD 38,S
	STX 3,S

	PULU A,X,S
	PSHS A,X

	PULU D,X
	STD 38,S
	STX 3,S

	PULU A,X,S
	PSHS A,X

	PULU D,X
	STD 38,S
	STX 3,S

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

	PULU A,X,Y,S
	PSHS A,X,Y

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

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 5,S

	PULU D,X,S
	PSHS D,X

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

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 4,S
	STX 38,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 36,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD -118,S
	STX -123,S
	STY 39,S

	PULU D
	STD -79,S

	PULU A,B,X,Y
	STA -37,S
	STB -77,S
	STX -39,S
	STY -3,S

	PULU D,X,Y
	STD 37,S
	STX -83,S
	STY -43,S

	PULU D,S
	STD 59,S

	PULU D
	STD 19,S

	PULU A,B,X
	STA 54,S
	STB -60,S
	STX -21,S

ERASE_SSAV_Img_tails_2
	LDS #$0000
	RTS

(info)

