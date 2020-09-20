(main)IMG.ASM
	ORG $D5E9
DRAW_HRR6
	PSHS U,DP
	STS SSAV_HRR6+2

	LDS $9F00
	STS ERASE_POS_HRR6_1+2
	LDU #ERASE_DATA_HRR6_2
	LEAS 523,S
	LDA 1,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 1,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 39,S

	LDA 41,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 41,S

	LDA -80,S
	PSHU A

	LDD -41,S
	PSHU D

	LDD -1,S
	PSHU D

	LDD 80,S
	PSHU D,S

	LDD #$ddca
	STD -1,S

	LDD #$ccaa
	STD -41,S

	STB -80,S

	LDA #$cd
	STD 80,S

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
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ca
	STD 40,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD 120,S

	LDA 42,S
	PSHU A

	LDD 81,S
	PSHU D

	LDA 122,S
	PSHU A

	LDA #$b2
	STA 122,S

	LDD #$ccb9
	STD 81,S

	STB 42,S

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
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$ab
	STD 39,S

	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$a1
	STD 79,S

	LDD 119,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$90
	STD 119,S

	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDD #$13aa
	STD 121,S

	LDD #$32bb
	STD 81,S

	LDA #$21
	STD 41,S

	PULS A,X
	PSHU A,X,S
	LDA #$fb
	LDX #$31bb
	PSHS A,X

	LEAS 281,S
	LDA -40,S
	PSHU A
	ANDA #$F0
	ORA #$00
	STA -40,S

	LDD ,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$000f
	STD ,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$0d01
	STD 40,S

	LDD -121,S
	PSHU D

	LDA -80,S
	PSHU A

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D,S

	LDD #$eefd
	STD -121,S

	LDA #$1d
	STA -80,S

	LDD #$aafe
	STD 80,S

	LDD #$9a10
	STD 120,S

	LEAS 240,S
	LDD ,S
	PSHU D
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

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDA 80,S
	PSHU A,S

	LDD #$9910
	STD -80,S

	LDD #$eeee
	STD -40,S

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

	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -41,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$23
	STD 80,S

	LDA -120,S
	PSHU A

	LDA -39,S
	PSHU A

	LDD ,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 120,S
	PSHU D,S

	LDA #$aa
	STA -120,S

	LDD #$cc2a
	STD 120,S

	LDD #$dd2d
	STD ,S

	STA -39,S

	LDB #$23
	STD 40,S

	LEAS 160,S
	LDD ,S
	PSHU D,S

	LDD #$ccaa
	STD ,S

	LEAS 159,S
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

	LDD -38,S
	PSHU D
	LDA #$aa
	ANDB #$0F
	ORB #$c0
	STD -38,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 3,S

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

	LDD -119,S
	PSHU D

	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDD #$dcaa
	STD 41,S

	LDB #$ca
	STD 81,S

	LDD #$ccac
	STD -119,S

	LDB #$2c
	STD 121,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$dcaa
	PSHS A,X

	LEAS 201,S
	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA -38,S

	LDD -40,S
	PSHU D

	LDD ,S
	PSHU D

	LDD 40,S
	PSHU D,S

	LDD #$d022
	STD 40,S

	LDA #$dd
	STD ,S

	LDB #$2b
	STD -40,S

	LEAS 199,S
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

	LDA -38,S
	PSHU A
	ANDA #$F0
	ORA #$0b
	STA -38,S

	LDA -118,S
	PSHU A

	LDA -78,S
	PSHU A

	LDD -40,S
	PSHU D

	LDA #$13
	STA -118,S

	LDA #$da
	STA -78,S

	LDD #$efd3
	STD -40,S

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
	LDA 81,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA 81,S

	LDD 40,S
	PSHU D

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

	LDD 19,S
	PSHU D
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

	LDA -100,S
	PSHU A

	LDA -60,S
	PSHU A,S

	LDA #$9a
	STA -100,S

	LDA #$a1
	STA -60,S

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
	PULU A,S
	STA 80,S

	PULU D,X,Y
	STD -40,S
	STX -80,S
	STY 40,S

	PULU D
	STD ,S

	PULU D,S
	STD 120,S

	PULU D
	STD 80,S

	PULU A,X,Y
	STA -80,S
	STX -121,S
	STY 40,S

	PULU D
	STD ,S

	PULU A
	STA -40,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 121,S
	STX 81,S
	STY 41,S

	PULU D,X,Y
	STD 119,S
	STX 79,S
	STY 39,S

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

	PULU A,X
	STA 122,S
	STX 81,S

	PULU A,X,Y
	STA 42,S
	STX 120,S
	STY 40,S

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
	STD -1,S
	STX -41,S

	PULU A,B,X
	STA -80,S
	STB 41,S
	STX 39,S

	PULU A
	STA 1,S

ERASE_POS_HRR6_2
	LDS #$0000
	LDU #ERASE_DATA_HRR6_2

ERASE_CODE_HRR6_2
	PULU A,S
	STA -60,S

	PULU A,X,Y
	STA -100,S
	STX 99,S
	STY 59,S

	PULU D,X
	STD 19,S
	STX -21,S

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 40,S

	PULU A
	STA 81,S

	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X

	PULU D
	STD -40,S

	PULU A,B
	STA -78,S
	STB -118,S

	PULU A,X,Y
	STA -38,S
	STX -80,S
	STY -120,S

	PULU D,S
	STD 40,S

	PULU D,X
	STD ,S
	STX -40,S

	PULU A
	STA -38,S

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
	STA 3,S
	STX -38,S
	STY -40,S

	PULU D,X
	STD -78,S
	STX -80,S

	PULU A
	STA -117,S

	PULU D,S
	STD ,S



	PULU D,S
	STD 120,S

	PULU D,X
	STD 40,S
	STX ,S

	PULU A,B,X,Y
	STA -39,S
	STB -120,S
	STX 80,S
	STY -41,S

	PULU D
	STD -80,S

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
	FCB $00
	FCB $00
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
	FCB $00
	FCB $00
ERASE_DATA_HRR6_END
