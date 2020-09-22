(main)IMG.ASM
	ORG $BC2D
DRAW_HRR7
	PSHS U,DP
	STS SSAV_HRR7+2

	LDS $9F00
	STS ERASE_POS_HRR7_1+2
	LDU #ERASE_DATA_HRR7_2
	LEAS 544,S

	LDD 18,S
	PSHU D

	LDD -22,S
	PSHU D

	LDD #$ccaa
	STD -22,S

	LDA -61,S
	PSHU A

	STB -61,S

	LDD #$ddca
	STD 18,S

	LDA 20,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 20,S

	LDD 58,S
	PSHU D,S

	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 58,S

	LDA 60,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 60,S

	LEAS 218,S

	LDD -119,S
	PSHU D

	LDD -79,S
	PSHU D

	LDD -39,S
	PSHU D

	LDD #$cdaa
	STD -79,S

	STD -119,S

	STD -39,S

	PULS A,X
	PSHU A,X,S

	LDA #$cc
	LDX #$cdda
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$cc
	LDX #$caba
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
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

	LDD 80,S
	PSHU D

	LDD #$ae10
	STD 80,S

	LDA 121,S
	PSHU A

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$30
	STA 42,S

	LDD 119,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$90
	STD 119,S

	LDD 40,S
	PSHU D

	LDD #$dd0d
	STD 40,S

	LDA #$bf
	STA 121,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$dd21
	PSHS A,X

	LEAS 280,S

	LDD -79,S
	PSHU D

	LDA #$af
	ANDB #$0F
	ORB #$a0
	STD -79,S

	LDD -81,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$9e
	STD -81,S

	LDA 2,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 2,S

	LDD -119,S
	PSHU D

	LDA #$bf
	ANDB #$0F
	ORB #$b0
	STD -119,S

	LDD -40,S
	PSHU D

	LDA 41,S
	PSHU A

	LDD #$0011
	STD -40,S

	LDA 81,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 81,S

	LDA #$dd
	STA 41,S

	LDD -121,S
	PSHU D,S

	ANDA #$F0
	ORA #$0a
	LDB #$9e
	STD -121,S

	LDD ,S
	PSHU D

	LDD #$eeee
	STD ,S

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -38,S

	LDA 121,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 121,S

	LEAS 281,S

	LDD 79,S
	PSHU D

	LDA -1,S
	PSHU A

	LDA -81,S
	PSHU A

	ANDA #$F0
	ORA #$09
	STA -81,S

	LDD 119,S
	PSHU D,S

	LDD 39,S
	PSHU D

	LDA #$ee
	ANDB #$0F
	ORB #$a0
	STD 39,S

	LDA #$09
	STA -1,S

	LDA -120,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA -120,S

	LDA -41,S
	PSHU A

	ANDA #$F0
	ORA #$0a
	STA -41,S

	LDD #$ee1f
	STD 79,S

	LDB #$11
	STD 119,S

	LEAS 159,S

	LDD ,S
	PSHU D,S

	LDD #$000e
	STD ,S


	LDS $9F00+2
	STS ERASE_POS_HRR7_2+2
	LDU #ERASE_DATA_HRR7_END

	LEAS 602,S

	LDD 120,S
	PSHU D

	LDD ,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD #$dd23
	STD 40,S

	LDB #$2d
	STD ,S

	LDD -81,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$ca
	STD -81,S

	LDA -79,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -79,S

	LDA -120,S
	PSHU A

	LDD 80,S
	PSHU D,S

	ANDA #$F0
	ORA #$0d
	LDB #$23
	STD 80,S

	LDA #$aa
	STA -120,S

	LDD -40,S
	PSHU D

	LDD #$ccdd
	STD -40,S

	LDB #$2a
	STD 120,S

	LEAS 279,S

	LDD 81,S
	PSHU D

	LDD -78,S
	PSHU D

	LDA #$ac
	ANDB #$0F
	ORB #$c0
	STD -78,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -40,S

	LDD 121,S
	PSHU D

	LDD 41,S
	PSHU D

	LDD -80,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -80,S

	LDD -38,S
	PSHU D

	LDA #$ac
	ANDB #$0F
	ORB #$a0
	STD -38,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA 3,S

	LDD -119,S
	PSHU D

	LDD #$ccaa
	STD -119,S

	LDA #$dc
	STD 41,S

	STD 81,S

	LDB #$ca
	STD 121,S

	LDA 43,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA 43,S

	LDA 123,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 123,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$ccaa
	PSHS A,X

	LEAS 162,S

	LDD -1,S
	PSHU D,S

	LDA 1,S
	PSHU A

	ANDA #$0F
	ORA #$90
	STA 1,S

	LDD #$cc2c
	STD -1,S

	LEAS 158,S

	LDD 40,S
	PSHU D

	LDD -119,S
	PSHU D

	LDA -78,S
	PSHU A

	LDA -117,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA -117,S

	LDD -80,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$dd
	STD -80,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD -40,S

	LDA -38,S
	PSHU A

	LDD #$dd2b
	STD -119,S

	LDD #$99aa
	STD 40,S

	LDA #$22
	STA -38,S

	STA -78,S

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 42,S

	PULS A,X
	PSHU A,X,S

	LDX #$dd13
	PSHS B,X

	LEAS 80,S

	PULS A,X
	PSHU A,X,S

	LDA #$99
	LDX #$ffab
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$90
	LDX #$fbfa
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$a9
	LDX #$1a2a
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$90
	LDX #$09ff
	PSHS A,X

	LEAS 40,S

	LDD 41,S
	PSHU D

	LDA 81,S
	PSHU A

	ANDA #$F0
	ORA #$00
	STA 81,S

	LDD #$0d91
	STD 41,S

	PULS A,X
	PSHU A,X,S

	LDA #$a9
	LDX #$e11f
	PSHS A,X

	LEAS 282,S

	LDA 120,S
	PSHU A

	LDA -1,S
	PSHU A

	LDD 118,S
	PSHU D

	ANDA #$F0
	ORA #$0e
	LDB #$91
	STD 118,S

	LDA 39,S
	PSHU A

	LDA -41,S
	PSHU A

	LDD 78,S
	PSHU D,S

	ANDA #$F0
	ORA #$00
	LDB #$aa
	STD 78,S

	LDA -121,S
	PSHU A

	ANDA #$F0
	ORA #$0d
	STA -121,S

	LDA #$a9
	STA -41,S

	LDA -81,S
	PSHU A

	LDA #$1a
	STA 39,S

	LDA #$9d
	STA -81,S

	STB -1,S

	LDA #$1f
	STA 120,S

	LEAS 159,S

	LDA 1,S
	PSHU A

	LDD -1,S
	PSHU D,S

	ANDA #$F0
	ORA #$00
	LDB #$00
	STD -1,S

	LDA #$e1
	STA 1,S

SSAV_HRR7
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HRR7
	PSHS U,DP
	STS ERASE_SSAV_HRR7+2

ERASE_POS_HRR7_1
	LDS #$0000
	LDU #ERASE_DATA_HRR7_1

ERASE_CODE_HRR7_1
	PULU D,S
	STD ,S

	PULU A,B,X,Y,S
	STA -41,S
	STB -120,S
	STX 39,S
	STY 119,S

	PULU A,B,X
	STA -81,S
	STB -1,S
	STX 79,S

	PULU A,B,X,Y,S
	STA 121,S
	STB -38,S
	STX ,S
	STY -121,S

	PULU A,B,X,Y
	STA 81,S
	STB 41,S
	STX -40,S
	STY -119,S

	PULU A,X,Y
	STA 2,S
	STX -81,S
	STY -79,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 40,S
	STX 119,S

	PULU A,B,X
	STA 42,S
	STB 121,S
	STX 80,S

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

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD -39,S
	STX -79,S
	STY -119,S

	PULU A,X,S
	STA 60,S
	STX 58,S

	PULU A,B,X,Y
	STA 20,S
	STB -61,S
	STX -22,S
	STY 18,S

ERASE_POS_HRR7_2
	LDS #$0000
	LDU #ERASE_DATA_HRR7_2

ERASE_CODE_HRR7_2
	PULU D,S
	STD -1,S

	PULU A
	STA 1,S

	PULU A,B,X,S
	STA -81,S
	STB -121,S
	STX 78,S

	PULU A,B,X
	STA -41,S
	STB 39,S
	STX 118,S

	PULU A,B
	STA -1,S
	STB 120,S

	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA 81,S
	STX 41,S

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

	PULU A,B,X,Y
	STA 42,S
	STB -38,S
	STX -40,S
	STY -80,S

	PULU A,B,X,Y
	STA -117,S
	STB -78,S
	STX -119,S
	STY 40,S

	PULU A,X,S
	STA 1,S
	STX -1,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X
	STA 123,S
	STB 43,S
	STX -119,S

	PULU A,X,Y
	STA 3,S
	STX -38,S
	STY -80,S

	PULU D,X,Y
	STD 41,S
	STX 121,S
	STY -40,S

	PULU D,X
	STD -78,S
	STX 81,S

	PULU D,X,S
	STD -40,S
	STX 80,S

	PULU A,B,X,Y
	STA -120,S
	STB -79,S
	STX -81,S
	STY 40,S

	PULU D,X
	STD ,S
	STX 120,S

ERASE_SSAV_HRR7
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HRR7_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HRR7_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRR7_END
