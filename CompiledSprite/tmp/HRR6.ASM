(main)IMG.ASM
	ORG $C310
DRAW_HRR6
	PSHS U,DP
	STS SSAV_HRR6+2

	LDS $9F00
	STS ERASE_POS_HRR6_1+2
	LDU #ERASE_DATA_HRR6_2
	LEAS 523,S

	LDD 80,S
	PSHU D

	LDD 39,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 39,S

	LDA 1,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 1,S

	LDA -80,S
	PSHU A

	LDD -41,S
	PSHU D,S

	LDD -1,S
	PSHU D

	LDA 41,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 41,S

	LDD #$ddca
	STD -1,S

	LDD #$ccaa
	STD -41,S

	STB -80,S

	LDA #$cd
	STD 80,S

	LEAS 239,S

	LDD -79,S
	PSHU D

	LDA -38,S
	PSHU A

	LDD -119,S
	PSHU D

	LDD #$cdaa
	STD -79,S

	STD -119,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$cd
	STD -40,S

	LDA #$da
	STA -38,S

	PULS A,X
	PSHU A,X,S

	LDA #$cc
	LDX #$caba
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDX #$cbbc
	PSHS B,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$cab0
	PSHS A,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$ca
	STD 40,S

	LDA 42,S
	PSHU A

	LDA 122,S
	PSHU A

	LDD 120,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD 120,S

	LDD 81,S
	PSHU D

	LDD #$ccb9
	STD 81,S

	STB 42,S

	LDA #$b2
	STA 122,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$caba
	PSHS A,X

	LEAS 160,S

	PULS A,X
	PSHU A,X,S

	LDA #$cc
	LDX #$c322
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$d322
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$dd21
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$ad
	LDX #$0dba
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$aa
	LDX #$10ab
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$f9
	LDX #$1eab
	PSHS A,X

	LEAS 40,S

	LDD 41,S
	PSHU D

	LDD 79,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$a1
	STD 79,S

	LDD 39,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$ab
	STD 39,S

	LDD 81,S
	PSHU D

	LDD #$21bb
	STD 41,S

	LDA #$32
	STD 81,S

	LDD 119,S
	PSHU D

	ANDA #$F0
	ORA #$0e
	LDB #$90
	STD 119,S

	LDD 121,S
	PSHU D

	LDD #$13aa
	STD 121,S

	PULS A,X
	PSHU A,X,S

	LDA #$fb
	LDX #$31bb
	PSHS A,X

	LEAS 281,S

	LDD -121,S
	PSHU D

	LDD #$eefd
	STD -121,S

	LDD ,S
	PSHU D

	ANDA #$F0
	ANDB #$F0
	ADDD #$000f
	STD ,S

	LDA -40,S
	PSHU A

	ANDA #$F0
	ORA #$00
	STA -40,S

	LDA -80,S
	PSHU A

	LDD 80,S
	PSHU D,S

	LDD #$aafe
	STD 80,S

	LDD 120,S
	PSHU D

	LDD 40,S
	PSHU D

	ANDA #$F0
	ANDB #$F0
	ADDD #$0d01
	STD 40,S

	LDA #$1d
	STA -80,S

	LDD #$9a10
	STD 120,S

	LEAS 240,S

	LDD -40,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD #$9910
	STD -80,S

	LDD #$eeee
	STD -40,S

	LDD ,S
	PSHU D,S

	LDA #$e9
	ANDB #$0F
	ORB #$00
	STD ,S

	LDD 40,S
	PSHU D

	LDA #$e9
	ANDB #$0F
	ORB #$e0
	STD 40,S

	LDA 80,S
	PSHU A

	LDA #$00
	STA 80,S


	LDS $9F00+2
	STS ERASE_POS_HRR6_2+2
	LDU #ERASE_DATA_HRR6_END

	LEAS 562,S

	LDD -80,S
	PSHU D

	LDA #$ca
	ANDB #$0F
	ORB #$a0
	STD -80,S

	LDA -120,S
	PSHU A

	LDA -39,S
	PSHU A

	LDD ,S
	PSHU D

	LDD -41,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -41,S

	LDD 80,S
	PSHU D,S

	ANDA #$F0
	ORA #$0d
	LDB #$23
	STD 80,S

	LDD 40,S
	PSHU D

	LDA #$aa
	STA -120,S

	LDD 120,S
	PSHU D

	LDD #$dd23
	STD 40,S

	LDB #$2d
	STD ,S

	STA -39,S

	LDD #$cc2a
	STD 120,S

	LEAS 160,S

	LDD ,S
	PSHU D,S

	LDD #$ccaa
	STD ,S

	LEAS 159,S

	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD -38,S
	PSHU D

	LDA #$aa
	ANDB #$0F
	ORB #$c0
	STD -38,S

	LDD #$dcca
	STD 81,S

	LDB #$aa
	STD 41,S

	LDD -78,S
	PSHU D

	LDA #$ac
	ANDB #$0F
	ORB #$a0
	STD -78,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -40,S

	LDD -119,S
	PSHU D

	LDD 121,S
	PSHU D

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA 3,S

	LDD #$ccac
	STD -119,S

	LDB #$2c
	STD 121,S

	LDA -117,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -117,S

	LDD -80,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -80,S

	LDA 83,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 83,S

	LDA 123,S
	PSHU A

	ANDA #$0F
	ORA #$90
	STA 123,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$dcaa
	PSHS A,X

	LEAS 201,S

	LDD -40,S
	PSHU D

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA -38,S

	LDD ,S
	PSHU D,S

	LDD 40,S
	PSHU D

	LDD #$dd2b
	STD -40,S

	LDB #$22
	STD ,S

	LDA #$d0
	STD 40,S

	LEAS 199,S

	LDD -40,S
	PSHU D

	LDA -118,S
	PSHU A

	LDD -120,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$0d
	STD -120,S

	LDD -80,S
	PSHU D

	ANDA #$F0
	ORA #$09
	LDB #$d3
	STD -80,S

	LDA -78,S
	PSHU A

	LDA #$da
	STA -78,S

	LDA #$13
	STA -118,S

	LDA #$ef
	STD -40,S

	LDA -38,S
	PSHU A

	ANDA #$F0
	ORA #$0b
	STA -38,S

	PULS A,X
	PSHU A,X,S

	LDA #$11
	LDX #$d1bb
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$11
	LDX #$fdab
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$e1
	LDX #$ffaa
	PSHS A,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	LDA 81,S
	PSHU A

	ANDA #$F0
	ORA #$0e
	STA 81,S

	LDD #$eee1
	STD 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$00
	LDX #$f2e9
	PSHS A,X

	LEAS 382,S

	LDD -21,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$a1
	STD -21,S

	LDA -60,S
	PSHU A

	STB -60,S

	LDA -100,S
	PSHU A

	LDA #$9a
	STA -100,S

	LDD 19,S
	PSHU D,S

	ANDA #$F0
	ORA #$0e
	LDB #$a1
	STD 19,S

	LDD 59,S
	PSHU D

	ANDA #$F0
	ORA #$0e
	LDB #$10
	STD 59,S

	LDD 99,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$0e
	STD 99,S

SSAV_HRR6
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HRR6
	PSHS U,DP
	STS ERASE_SSAV_HRR6+2

ERASE_POS_HRR6_1
	LDS #$0000
	LDU #ERASE_DATA_HRR6_1

ERASE_CODE_HRR6_1
	PULU A,X,Y,S
	STA 80,S
	STX 40,S
	STY ,S

	PULU D,X
	STD -80,S
	STX -40,S

	PULU D,X,Y,S
	STD 40,S
	STX 120,S
	STY 80,S

	PULU A,B,X,Y
	STA -80,S
	STB -40,S
	STX ,S
	STY -121,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 121,S
	STX 119,S
	STY 81,S

	PULU D,X,Y
	STD 39,S
	STX 79,S
	STY 41,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 81,S
	STX 120,S

	PULU A,B,X
	STA 122,S
	STB 42,S
	STX 40,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -40,S
	STX -119,S

	PULU A,X
	STA -38,S
	STX -79,S

	PULU A,X,Y,S
	STA 41,S
	STX -1,S
	STY -41,S

	PULU A,B,X,Y
	STA -80,S
	STB 1,S
	STX 39,S
	STY 80,S

ERASE_POS_HRR6_2
	LDS #$0000
	LDU #ERASE_DATA_HRR6_2

ERASE_CODE_HRR6_2
	PULU D,X,Y,S
	STD 99,S
	STX 59,S
	STY 19,S

	PULU A,B,X
	STA -100,S
	STB -60,S
	STX -21,S

	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA 81,S
	STX 40,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA -38,S
	STB -78,S
	STX -80,S
	STY -120,S

	PULU A,X
	STA -118,S
	STX -40,S

	PULU D,X,S
	STD 40,S
	STX ,S

	PULU A,X
	STA -38,S
	STX -40,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X
	STA 123,S
	STB 83,S
	STX -80,S

	PULU A,B,X,Y
	STA -117,S
	STB 3,S
	STX 121,S
	STY -119,S

	PULU D,X,Y
	STD -40,S
	STX -78,S
	STY -38,S

	PULU D,X
	STD 81,S
	STX 41,S

	PULU D,S
	STD ,S

	PULU D,X,Y,S
	STD 120,S
	STX 40,S
	STY 80,S

	PULU D,X
	STD -41,S
	STX ,S

	PULU A,B,X
	STA -39,S
	STB -120,S
	STX -80,S

ERASE_SSAV_HRR6
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HRR6_1
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
ERASE_DATA_HRR6_2
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
ERASE_DATA_HRR6_END
