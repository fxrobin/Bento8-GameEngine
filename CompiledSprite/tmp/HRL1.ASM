(main)IMG.ASM
	ORG $CA53
DRAW_HRL1
	PSHS U,DP
	STS SSAV_HRL1+2

	LDS $9F00
	STS ERASE_POS_HRL1_1+2
	LDU #ERASE_DATA_HRL1_2
	LEAS 563,S
	LDA -120,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -120,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -81,S

	LDD 79,S
	PSHU D
	LDA #$ac
	ANDB #$0F
	ORB #$c0
	STD 79,S

	LDD -41,S
	PSHU D

	LDD -1,S
	PSHU D

	LDD 39,S
	PSHU D

	LDD 119,S
	PSHU D,S

	LDD #$cacc
	STD -41,S

	LDA #$aa
	STD 119,S

	LDB #$cd
	STD -1,S

	LDB #$dd
	STD 39,S

	LEAS 280,S
	LDD -82,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$bc
	STD -82,S

	LDD -42,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ba
	STD -42,S

	LDD -2,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$ba
	STD -2,S

	LDD ,S
	PSHU D
	LDA #$cd
	ANDB #$0F
	ORB #$c0
	STD ,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$ba
	STD 38,S

	LDD 40,S
	PSHU D
	LDA #$c0
	ANDB #$0F
	ORB #$d0
	STD 40,S

	LDD 78,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$ba
	STD 78,S

	LDD 118,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$bc
	STD 118,S

	LDD -121,S
	PSHU D

	LDA -80,S
	PSHU A

	LDA -40,S
	PSHU A

	LDA 80,S
	PSHU A

	LDA 120,S
	PSHU A,S

	LDD #$dacc
	STD -121,S

	LDA #$d0
	STA 80,S

	LDA #$dd
	STA 120,S

	LDA #$cd
	STA -80,S

	STA -40,S

	LEAS 279,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$bb
	STD -121,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$b2
	STD -81,S

	LDA -119,S
	PSHU A

	LDA -79,S
	PSHU A

	LDD -40,S
	PSHU D

	LDA #$dc
	STA -119,S

	LDA #$dd
	STA -79,S

	LDD #$220d
	STD -40,S

	PULS A,X
	PSHU A,X,S
	LDA #$22
	LDX #$d32a
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 3,S

	LDD 42,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$09a0
	STD 42,S

	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$0e
	STD 79,S

	LDA 83,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 83,S

	LDD 122,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$e0a0
	STD 122,S

	LDD 40,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$1110
	STD 40,S

	LDD #$231a
	STD 81,S

	LDD #$9123
	STD 120,S

	PULS A,X
	PSHU A,X,S
	LDA #$33
	LDX #$de3a
	PSHS A,X

	LEAS 221,S
	LDA -59,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA -59,S

	LDD -21,S
	PSHU D
	ANDA #$0F
	ORA #$00
	LDB #$2c
	STD -21,S

	LDA -19,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA -19,S

	LDD 20,S
	PSHU D
	LDA #$cd
	ANDB #$0F
	ORB #$c0
	STD 20,S

	LDD 60,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$d0d0
	STD 60,S

	LDD -61,S
	PSHU D,S

	LDD #$9e23
	STD -61,S

	LEAS 379,S
	LDD -120,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$f0a0
	STD -120,S

	LDD -80,S
	PSHU D
	LDA #$fb
	ANDB #$0F
	ORB #$a0
	STD -80,S

	LDD -40,S
	PSHU D
	LDA #$ff
	ANDB #$0F
	ORB #$90
	STD -40,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$00
	STD 120,S

	LDD ,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D,S

	LDD #$ffe0
	STD ,S

	LDD #$e111
	STD 80,S

	LDA #$1f
	STD 40,S


	LDS $9F00+2
	STS ERASE_POS_HRL1_2+2
	LDU #ERASE_DATA_HRL1_END

	LEAS 522,S
	LDA -80,S
	PSHU A
	ANDA #$F0
	ORA #$0c
	STA -80,S

	LDD -40,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$c0
	STD -40,S

	LDA 41,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 41,S

	LDD ,S
	PSHU D

	LDD 39,S
	PSHU D

	LDD 79,S
	PSHU D,S

	LDD #$da32
	STD 79,S

	LDD #$dcdd
	STD 39,S

	LDA #$ad
	STD ,S

	LEAS 239,S
	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -38,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD #$ca22
	STD -120,S

	LDD #$aaad
	STD -40,S

	LDB #$a2
	STD -80,S

	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$bccc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ac
	LDX #$aadc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$a0
	LDX #$acdd
	PSHS A,X

	LEAS 40,S
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 42,S

	LDA 122,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 122,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$ab2c
	STD 120,S

	LDD #$b9cc
	STD 80,S

	LDA #$a9
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$ca
	LDX #$acdd
	PSHS A,X

	LEAS 160,S
	PULS A,X
	PSHU A,X,S
	LDA #$02
	LDX #$2dcc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$32
	LDX #$2d22
	PSHS A,X

	LEAS 40,S
	PULS D,X
	PSHU D,X,S
	LDD #$123d
	LDX #$33aa
	PSHS D,X

	LEAS 40,S
	PULS D,X
	PSHU D,X,S
	LDD #$a1d0
	LDX #$ddbb
	PSHS D,X

	LEAS 40,S
	PULS D,X
	PSHU D,X,S
	LDD #$900e
	LDX #$d1bb
	PSHS D,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	LDA #$99
	ANDB #$F0
	ORB #$02
	STD 40,S

	LDD 80,S
	PSHU D
	LDA #$a9
	ANDB #$F0
	ORB #$02
	STD 80,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$12
	STD 120,S

	LDD 42,S
	PSHU D

	LDD 82,S
	PSHU D

	LDA 122,S
	PSHU A

	LDD #$dda9
	STD 82,S

	LDB #$ab
	STD 42,S

	STA 122,S

	PULS D,X
	PSHU D,X,S
	LDD #$0ae3
	LDX #$deba
	PSHS D,X

	LEAS 281,S
	LDD -80,S
	PSHU D
	LDA #$0c
	ANDB #$F0
	ORB #$0e
	STD -80,S

	LDA -40,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA -40,S

	LDA ,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA ,S

	LDD 39,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$f00d
	STD 39,S

	LDD 79,S
	PSHU D
	LDA #$1f
	ANDB #$F0
	ORB #$0d
	STD 79,S

	LDD 119,S
	PSHU D
	LDA #$e2
	ANDB #$F0
	ORB #$0b
	STD 119,S

	LDD -120,S
	PSHU D,S

	LDD #$e3dd
	STD -120,S

	LEAS 260,S
	LDD -101,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$0f0a
	STD -101,S

	LDD -61,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$ba
	STD -61,S

	LDD -21,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$bf
	STD -21,S

	LDA 20,S
	PSHU A

	LDA 60,S
	PSHU A

	LDA 100,S
	PSHU A,S

	LDA #$00
	STA 100,S

	LDA #$aa
	STA 20,S

	STA 60,S

SSAV_HRL1
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HRL1
	PSHS U,DP
	STS ERASE_SSAV_HRL1+2

ERASE_POS_HRL1_1
	LDS #$0000
	LDU #ERASE_DATA_HRL1_1

ERASE_CODE_HRL1_1
	PULU D,S
	STD 80,S

	PULU D,X,Y
	STD 40,S
	STX ,S
	STY 120,S

	PULU D,X,Y
	STD -40,S
	STX -80,S
	STY -120,S

	PULU D,S
	STD -61,S

	PULU D,X
	STD 60,S
	STX 20,S

	PULU A,X
	STA -19,S
	STX -21,S

	PULU A
	STA -59,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 120,S
	STX 81,S
	STY 40,S

	PULU D
	STD 122,S

	PULU A,X,Y
	STA 83,S
	STX 79,S
	STY 42,S

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU D
	STD -40,S

	PULU A,B,X,Y
	STA -79,S
	STB -119,S
	STX -81,S
	STY -121,S

	PULU A,S
	STA 120,S

	PULU A,B
	STA 80,S
	STB -40,S

	PULU A,X,Y
	STA -80,S
	STX -121,S
	STY 118,S

	PULU D,X,Y
	STD 78,S
	STX 40,S
	STY 38,S

	PULU D,X,Y
	STD ,S
	STX -2,S
	STY -42,S

	PULU D
	STD -82,S

	PULU D,S
	STD 119,S

	PULU D,X,Y
	STD 39,S
	STX -1,S
	STY -41,S

	PULU D,X
	STD 79,S
	STX -81,S

	PULU A
	STA -120,S

ERASE_POS_HRL1_2
	LDS #$0000
	LDU #ERASE_DATA_HRL1_2

ERASE_CODE_HRL1_2
	PULU A,S
	STA 100,S

	PULU A,B,X,Y
	STA 60,S
	STB 20,S
	STX -21,S
	STY -61,S

	PULU D
	STD -101,S

	PULU D,S
	STD -120,S

	PULU D,X,Y
	STD 119,S
	STX 79,S
	STY 39,S

	PULU A,B,X
	STA ,S
	STB -40,S
	STX -80,S

	PULU D,X,S
	PSHS D,X

	PULU A,X,Y
	STA 122,S
	STX 82,S
	STY 42,S

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



	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 120,S
	STX 80,S
	STY 40,S

	PULU A,B
	STA 122,S
	STB 42,S

	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD -40,S
	STX -80,S
	STY -120,S

	PULU A
	STA -38,S

	PULU D,S
	STD 79,S

	PULU D,X
	STD 39,S
	STX ,S

	PULU A,X
	STA 41,S
	STX -40,S

	PULU A
	STA -80,S

ERASE_SSAV_HRL1
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HRL1_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRL1_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRL1_END
