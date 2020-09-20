(main)IMG.ASM
	ORG $DCAC
DRAW_HRR5
	PSHS U,DP
	STS SSAV_HRR5+2

	LDS $9F00
	STS ERASE_POS_HRR5_1+2
	LDU #ERASE_DATA_HRR5_2
	LEAS 523,S
	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$aa
	STD -41,S

	LDA 1,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 1,S

	LDA 41,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 41,S

	LDA -80,S
	PSHU A

	LDD -1,S
	PSHU D

	LDD 39,S
	PSHU D

	LDD 80,S
	PSHU D,S

	LDD #$ddcc
	STD 39,S

	LDD #$cdaa
	STD 80,S

	STB -80,S

	LDB #$ca
	STD -1,S

	LEAS 239,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cd
	STD -40,S

	LDD -119,S
	PSHU D

	LDD -79,S
	PSHU D

	LDA -38,S
	PSHU A

	LDA #$da
	STA -38,S

	LDD #$cdaa
	STD -119,S

	STD -79,S

	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$caba
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$cbbc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$cab0
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$caba
	PSHS A,X

	LEAS 40,S
	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD 80,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$c3
	STD 120,S

	LDD 41,S
	PSHU D

	LDA 82,S
	PSHU A

	LDA 122,S
	PSHU A

	LDD #$ccb9
	STD 41,S

	LDA #$b2
	STA 82,S

	LDA #$22
	STA 122,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$cab9
	PSHS A,X

	LEAS 199,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$cd
	STD -40,S

	LDD -38,S
	PSHU D

	LDD #$d322
	STD -38,S

	PULS D,X
	PSHU D,X,S
	LDD #$a9dd
	LDX #$dd2a
	PSHS D,X

	LEAS 40,S
	PULS D,X
	PSHU D,X,S
	LDD #$aadd
	LDX #$0d9b
	PSHS D,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$000d
	STD 40,S

	LDD 42,S
	PSHU D

	LDD #$2ebb
	STD 42,S

	PULS D,X
	PSHU D,X,S
	LDD #$99d0
	LDX #$10aa
	PSHS D,X

	LEAS 80,S
	PULS D,X
	PSHU D,X,S
	LDD #$9eed
	LDX #$32bb
	PSHS D,X

	LEAS 40,S
	PULS D,X
	PSHU D,X,S
	LDD #$91ed
	LDX #$e3ab
	PSHS D,X

	LEAS 40,S
	LDD 42,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$100f
	STD 42,S

	LDD 82,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$d00f
	STD 82,S

	LDD 122,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$d001
	STD 122,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$ab90
	STD 40,S

	LDD #$1bdc
	STD 80,S

	LDD #$fbdd
	STD 120,S

	PULS D,X
	PSHU D,X,S
	LDD #$a19d
	LDX #$119a
	PSHS D,X

	LEAS 282,S
	LDD -120,S
	PSHU D
	LDA #$dc
	ANDB #$F0
	ORB #$01
	STD -120,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$a1
	STD -80,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$a1
	STD -40,S

	LDD ,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ae
	STD ,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$a0
	STD 40,S

	LDA 78,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 78,S

	LDA 118,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 118,S

	LDA -122,S
	PSHU A

	LDA -82,S
	PSHU A

	LDA -42,S
	PSHU A

	LDA -2,S
	PSHU A

	LDA 38,S
	PSHU A

	LDA 81,S
	PSHU A

	LDA 121,S
	PSHU A,S

	LDA #$1f
	STA 38,S

	LDA #$90
	STA 81,S

	LDA #$9e
	STA 121,S

	LDA #$ff
	STA -122,S

	STA -82,S

	STA -42,S

	STA -2,S

	LEAS 201,S
	LDA ,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA ,S

	LDA 40,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 40,S

	LDA -40,S
	PSHU A,S

	LDA #$01
	STA -40,S


	LDS $9F00+2
	STS ERASE_POS_HRR5_2+2
	LDU #ERASE_DATA_HRR5_END

	LEAS 562,S
	LDD -80,S
	PSHU D
	LDA #$ca
	ANDB #$0F
	ORB #$a0
	STD -80,S

	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD -1,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$23
	STD 80,S

	LDA -120,S
	PSHU A

	LDD -40,S
	PSHU D

	LDA 1,S
	PSHU A

	LDD 40,S
	PSHU D

	LDD 120,S
	PSHU D,S

	LDA #$aa
	STA -120,S

	LDA #$2d
	STA 1,S

	LDD #$dd23
	STD 40,S

	LDD #$cc2a
	STD 120,S

	LDB #$dd
	STD -40,S

	LEAS 181,S
	LDA 21,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 21,S

	LDD -21,S
	PSHU D

	LDD 19,S
	PSHU D,S

	LDD #$ccac
	STD 19,S

	LDB #$aa
	STD -21,S

	LEAS 178,S
	LDA -117,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -117,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -80,S

	LDD -78,S
	PSHU D
	LDA #$aa
	ANDB #$0F
	ORB #$c0
	STD -78,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD -40,S

	LDD -38,S
	PSHU D
	LDA #$aa
	ANDB #$0F
	ORB #$c0
	STD -38,S

	LDA 43,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 43,S

	LDA 83,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA 83,S

	LDA 123,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 123,S

	LDD -119,S
	PSHU D

	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDD #$dcca
	STD 41,S

	LDD #$cd2b
	STD 121,S

	LDD #$cc2c
	STD 81,S

	LDB #$ac
	STD -119,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$dcaa
	PSHS A,X

	LEAS 200,S
	LDD -40,S
	PSHU D
	ANDA #$0F
	ORA #$a0
	LDB #$dd
	STD -40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 3,S

	LDA -38,S
	PSHU A

	LDA #$22
	STA -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$09
	LDX #$d022
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$99
	LDX #$dd13
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA 3,S

	LDD 42,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0ab0
	STD 42,S

	LDD 82,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0ab0
	STD 82,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$edde
	STD 40,S

	LDD #$11c3
	STD 80,S

	PULS A,X
	PSHU A,X,S
	LDA #$0d
	LDX #$03da
	PSHS A,X

	LEAS 120,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$ea
	LDX #$c32a
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 3,S

	LDA 43,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 43,S

	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$ad
	STD 79,S

	LDA 83,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 83,S

	LDD 119,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$fb
	STD 119,S

	LDA 121,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 121,S

	LDA 123,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 123,S

	LDD 40,S
	PSHU D

	LDA 81,S
	PSHU A

	LDD #$addc
	STD 40,S

	LDA #$cd
	STA 81,S

	PULS A,X
	PSHU A,X,S
	LDA #$a0
	LDX #$d331
	PSHS A,X

	LEAS 281,S
	LDA -122,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -122,S

	LDA -118,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA -118,S

	LDA -82,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -82,S

	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA -78,S

	LDA -42,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -42,S

	LDD -39,S
	PSHU D
	LDA #$aa
	ANDB #$0F
	ORB #$e0
	STD -39,S

	LDA -2,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -2,S

	LDD 1,S
	PSHU D
	LDA #$a9
	ANDB #$0F
	ORB #$e0
	STD 1,S

	LDD 41,S
	PSHU D
	LDA #$ae
	ANDB #$0F
	ORB #$10
	STD 41,S

	LDA 81,S
	PSHU A

	LDA 121,S
	PSHU A,S

	LDA #$91
	STA 81,S

	LDA #$0e
	STA 121,S

	LEAS 201,S
	LDA ,S
	PSHU A
	ANDA #$F0
	ORA #$00
	STA ,S

	LDA 40,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA 40,S

	LDA -40,S
	PSHU A,S

	LDA #$0e
	STA -40,S

SSAV_HRR5
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HRR5
	PSHS U,DP
	STS ERASE_SSAV_HRR5+2

ERASE_POS_HRR5_1
	LDS #$0000
	LDU #ERASE_DATA_HRR5_1

ERASE_CODE_HRR5_1
	PULU A,S
	STA -40,S

	PULU A,B
	STA 40,S
	STB ,S

	PULU A,S
	STA 121,S

	PULU A,B
	STA 81,S
	STB 38,S

	PULU A,B
	STA -2,S
	STB -42,S

	PULU A,B
	STA -82,S
	STB -122,S

	PULU A,B,X,Y
	STA 118,S
	STB 78,S
	STX 40,S
	STY ,S

	PULU D,X,Y
	STD -40,S
	STX -80,S
	STY -120,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 120,S
	STX 80,S
	STY 40,S

	PULU D,X,Y
	STD 122,S
	STX 82,S
	STY 42,S

	PULU D,X,S
	PSHS D,X



	PULU D,X,S
	PSHS D,X



	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD 42,S
	STX 40,S

	PULU D,X,S
	PSHS D,X



	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD -38,S
	STX -40,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA 122,S
	STB 82,S
	STX 41,S
	STY 120,S

	PULU D
	STD 80,S

	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA -38,S
	STX -79,S
	STY -119,S

	PULU D
	STD -40,S

	PULU D,S
	STD 80,S

	PULU D,X
	STD 39,S
	STX -1,S

	PULU A,B
	STA -80,S
	STB 41,S

	PULU A,X
	STA 1,S
	STX -41,S

ERASE_POS_HRR5_2
	LDS #$0000
	LDU #ERASE_DATA_HRR5_2

ERASE_CODE_HRR5_2
	PULU A,S
	STA -40,S

	PULU A,B
	STA 40,S
	STB ,S

	PULU A,S
	STA 121,S

	PULU A,X,Y
	STA 81,S
	STX 41,S
	STY 1,S

	PULU A,X
	STA -2,S
	STX -39,S

	PULU A,B
	STA -42,S
	STB -78,S

	PULU A,B
	STA -82,S
	STB -118,S

	PULU A
	STA -122,S

	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA 81,S
	STX 40,S

	PULU A,B,X
	STA 123,S
	STB 121,S
	STX 119,S

	PULU A,X
	STA 83,S
	STX 79,S

	PULU A,B
	STA 43,S
	STB 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 80,S
	STX 40,S
	STY 82,S

	PULU D
	STD 42,S

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X
	STA -38,S
	STB 3,S
	STX -40,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 121,S
	STX 81,S
	STY 41,S

	PULU D
	STD -119,S

	PULU A,B
	STA 123,S
	STB 83,S

	PULU A,X,Y
	STA 43,S
	STX -38,S
	STY -40,S

	PULU D,X
	STD -78,S
	STX -80,S

	PULU A
	STA -117,S

	PULU D,S
	STD 19,S

	PULU D
	STD -21,S

	PULU A
	STA 21,S

	PULU D,S
	STD 120,S

	PULU D
	STD 40,S

	PULU A,X
	STA 1,S
	STX -40,S

	PULU A,X,Y
	STA -120,S
	STX 80,S
	STY -1,S

	PULU D
	STD -80,S

ERASE_SSAV_HRR5
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HRR5_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FCB $00
ERASE_DATA_HRR5_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FCB $00
ERASE_DATA_HRR5_END
