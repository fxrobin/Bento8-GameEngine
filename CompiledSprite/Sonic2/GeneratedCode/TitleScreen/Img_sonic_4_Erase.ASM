(main)IMGE.ASM
	ORG $A000
	SETDP $FF
ERASE_Img_sonic_4
	STS ERASE_SSAV_Img_sonic_4+1,PCR

ERASE_CODE_Img_sonic_4_1
	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 82,S
	STX 41,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 40,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

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

	PULU A
	STA 5,S

	PULU D,X,S
	PSHS D,X

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

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 6,S
	STX 39,S

	PULU A,X,Y,S
	PSHS A,X,Y

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

	PULU A,X,S
	PSHS A,X

	PULU A,X,Y
	STA 43,S
	STX 41,S
	STY 39,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA -39,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 83,S
	STX 42,S

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

	PULU A
	STA 6,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 6,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 5,S

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

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 39,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 40,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 39,S

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

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

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

	PULU D
	STD 6,S

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

	PULU A
	STA 5,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X
	STA 5,S
	STX 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 39,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 39,S

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,Y
	STA 3,S
	STX -79,S
	STY -39,S

ERASE_SSAV_Img_sonic_4
	LDS #$0000
	RTS

(info)

