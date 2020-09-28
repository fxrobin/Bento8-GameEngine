(main)IMG.ASM
	ORG $A000
DRAW_HJL6
	PSHS U
	STS SSAV_HJL6+2

	LDS $9F00
	LDU #ERASE_DATA_HJL6_2
	LEAS 603,S

	LDA -120,S
	LDB 81,S
	LDX 120,S
	PSHU X,B,A
	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$f1
	STD -81,S
	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ff
	STD -41,S
	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$fc
	STD -1,S
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$99
	STD 39,S
	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$aa
	STD 79,S
	LDD 118,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ca
	STD 118,S
	LDA 1,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 1,S
	LDA 41,S
	PSHU S,A
	ANDA #$0F
	ORA #$e0
	STA 41,S
	LDA #$10
	STA 81,S
	LDD #$d91e
	STD 120,S
	STB -120,S
	LEAS 259,S

	LDX 100,S
	LDY 21,S
	PSHU Y,X
	LDD #$cdaf
	STD 21,S
	LDD -99,S
	LDX -19,S
	PSHU X,D
	LDD -59,S
	PSHU D
	LDA #$ca
	ANDB #$F0
	ORB #$01
	STD -59,S
	LDD 61,S
	PSHU D
	LDA #$c3
	ANDB #$0F
	ORB #$a0
	STD 61,S
	LDD #$ddf1
	STD -99,S
	LDD #$ba2a
	STD 100,S
	LDD -101,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ca
	STD -101,S
	LDD -61,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ac
	STD -61,S
	LDD -21,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ac
	STD -21,S
	LDD 19,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ba
	STD 19,S
	LDD 59,S
	PSHU S,D
	ANDA #$F0
	ORA #$0c
	LDB #$ba
	STD 59,S
	LDD #$da9f
	STD -19,S
	LEAS 259,S

	LDX -78,S
	LDY -38,S
	PSHU Y,X
	LDA -118,S
	LDB 3,S
	PSHU B,A
	ANDB #$0F
	ORB #$00
	STB 3,S
	LDA #$2d
	STA -118,S
	LDA #$22
	STD -78,S
	LDD -120,S
	PSHU D
	ANDA #$0F
	ORA #$a0
	LDB #$ac
	STD -120,S
	LDD -80,S
	PSHU D
	ANDA #$0F
	ORA #$c0
	LDB #$cc
	STD -80,S
	LDD -40,S
	PSHU D
	ANDA #$0F
	ORA #$c0
	LDB #$cc
	STD -40,S
	LDD #$33a0
	STD -38,S
	PULS A,X
	PSHU S,X,A
	LDA #$da
	LDX #$dacd
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 3,S
	LDD 42,S
	PSHU D
	LDA #$dd
	ANDB #$0F
	ORB #$c0
	STD 42,S
	LDD 82,S
	PSHU D
	LDA #$cd
	ANDB #$0F
	ORB #$d0
	STD 82,S
	LDD 122,S
	PSHU D
	LDA #$dd
	ANDB #$0F
	ORB #$d0
	STD 122,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ca
	STD 40,S
	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 80,S
	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD 120,S
	PULS A,X
	PSHU S,X,A
	LDX #$cacd
	PSHS B,X
	LEAS 281,S

	LDX 40,S
	LDY 80,S
	PSHU Y,X
	LDD -80,S
	LDX -40,S
	LDY ,S
	PSHU Y,X,D
	LDA -118,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -118,S
	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -78,S
	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -38,S
	LDD #$ccdd
	STD 40,S
	LDA #$cd
	STD ,S
	LDX 120,S
	LDB #$dc
	STD -40,S
	LDY -120,S
	PSHU S,Y,X
	LDA #$dd
	STD -80,S
	LDB #$cd
	STD -120,S
	LDB #$d3
	STD 120,S
	LDD #$cdd1
	STD 80,S
	LEAS 180,S

	LDX -20,S
	PSHU X
	LDD #$dddd
	STD -20,S
	LDA 20,S
	PSHU S,A
	ANDA #$F0
	ORA #$0d
	STA 20,S

	LDS $9F00+2
	LDU #ERASE_DATA_HJL6_END

	LEAS 583,S

	LDD -61,S
	PSHU D
	LDA #$af
	ANDB #$0F
	ORB #$90
	STD -61,S
	LDA -101,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA -101,S
	LDA 100,S
	PSHU A
	ANDA #$F0
	ORA #$0f
	STA 100,S
	LDD 18,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$cf
	STD 18,S
	LDD 58,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$da
	STD 58,S
	LDD 98,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$aa
	STD 98,S
	LDA 20,S
	LDB 60,S
	LDX -21,S
	PSHU S,X,B,A
	LDD #$cfa0
	STD -21,S
	LDA #$11
	STA 20,S
	LDA #$f1
	STA 60,S
	LEAS 258,S

	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$cc
	STD -120,S
	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$c3
	STD -80,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$c3
	STD -40,S
	LDD -38,S
	PSHU D
	LDA #$ca
	ANDB #$0F
	ORB #$00
	STD -38,S
	LDA -78,S
	LDB -118,S
	PSHU B,A
	ANDB #$0F
	ORB #$90
	STB -118,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 3,S
	LDA #$a9
	STA -78,S
	PULS A,X
	PSHU S,X,A
	LDA #$aa
	LDX #$cdaa
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$aa
	LDX #$cdaa
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$aa
	LDX #$cd9a
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$ca
	LDX #$ccaa
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$f0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$dc
	LDX #$ac21
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$f0
	STA 3,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ac
	STD 40,S
	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 80,S
	LDA 42,S
	LDB 82,S
	PSHU B,A
	LDA #$aa
	STA 42,S
	STA 82,S
	PULS A,X
	PSHU S,X,A
	LDA #$dc
	LDX #$acd9
	PSHS A,X
	LEAS 120,S

	PULS A,X
	PSHU S,X,A
	LDA #$ac
	LDX #$ccaa
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$ccaa
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$dc
	LDX #$ccaa
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$dd
	LDX #$ccaa
	PSHS A,X
	LEAS 40,S

	LDA 42,S
	LDX 81,S
	LDY 121,S
	PSHU Y,X,A
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cd
	STD 40,S
	LDD #$ccdd
	STD 81,S
	STB 42,S
	LDA #$dd
	STD 121,S
	PULS A,X
	PSHU S,X,A
	LDX #$ccad
	PSHS B,X
	LEAS 160,S

	LDX 40,S
	PSHU X
	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 80,S
	LDA 121,S
	LDB 42,S
	PSHU B,A
	ANDB #$0F
	ORB #$d0
	STB 42,S
	LDA #$dd
	STA 121,S
	STD 40,S
	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$cddd
	PSHS A,X
	LEAS 161,S

	LDA ,S
	PSHU S,A
	LDA #$dd
	STA ,S
SSAV_HJL6
	LDS #$0000
	PULS U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HJL6
	PSHS U
	STS ERASE_SSAV_HJL6+2

ERASE_POS_HJL6_1
	LDU #ERASE_DATA_HJL6_1

ERASE_CODE_HJL6_1
	PULU A,S
	STA 20,S

	PULU D
	STD -20,S

	PULU D,X,S
	STD 120,S
	STX -120,S

	PULU A,B
	STA -38,S
	STB -78,S

	PULU A,X,Y
	STA -118,S
	STX -80,S
	STY -40,S

	PULU D,X,Y
	STD ,S
	STX 40,S
	STY 80,S

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y
	STD 120,S
	STX 80,S
	STY 40,S

	PULU D,X,Y
	STD 122,S
	STX 82,S
	STY 42,S

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y
	STD -40,S
	STX -80,S
	STY -120,S

	PULU A,B,X,Y
	STA -118,S
	STB 3,S
	STX -78,S
	STY -38,S

	PULU D,S
	STD 59,S

	PULU D,X,Y
	STD 19,S
	STX -21,S
	STY -61,S

	PULU D,X,Y
	STD -101,S
	STX 61,S
	STY -59,S

	PULU D,X,Y
	STD -99,S
	STX -19,S
	STY 100,S

	PULU D
	STD 21,S

	PULU A,S
	STA 41,S

	PULU A,X,Y
	STA 1,S
	STX 118,S
	STY 79,S

	PULU D,X,Y
	STD 39,S
	STX -1,S
	STY -41,S

	PULU D
	STD -81,S

	PULU A,B,X
	STA -120,S
	STB 81,S
	STX 120,S

	PULU A,S
	STA ,S

	PULU A,X,S
	PSHS A,X

	PULU A,B,X,Y
	STA 121,S
	STB 42,S
	STX 80,S
	STY 40,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 40,S

	PULU A,X,Y
	STA 42,S
	STX 81,S
	STY 121,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,B,X,Y
	STA 42,S
	STB 82,S
	STX 80,S
	STY 40,S

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

	PULU A,B
	STA 3,S
	STB -78,S

	PULU A,X,Y
	STA -118,S
	STX -38,S
	STY -40,S

	PULU D,X
	STD -80,S
	STX -120,S

	PULU A,B,X,S
	STA 20,S
	STB 60,S
	STX -21,S

	PULU D,X,Y
	STD 98,S
	STX 58,S
	STY 18,S

	PULU A,B,X
	STA 100,S
	STB -101,S
	STX -61,S

ERASE_SSAV_HJL6
	LDS #$0000
	PULS U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HJL6_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJL6_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HJL6_END
