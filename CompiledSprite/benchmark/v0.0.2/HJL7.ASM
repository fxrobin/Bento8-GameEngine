(main)IMG.ASM
	ORG $A000
DRAW_HJL7
	PSHS U
	STS SSAV_HJL7+2

	LDS $9F00
	LDU #ERASE_DATA_HJL7_2
	LEAS 604,S

	LDA -2,S
	LDB -81,S
	LDX 118,S
	LDY 38,S
	PSHU Y,X,B,A
	LDA #$fa
	STA -2,S
	LDD #$eaaa
	STD 118,S
	LDD #$fa99
	STD 38,S
	LDX 78,S
	LDY -42,S
	PSHU Y,X
	LDD #$19aa
	STD 78,S
	LDA -121,S
	LDB ,S
	PSHU B,A
	ANDB #$0F
	ORB #$10
	STB ,S
	LDA 40,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 40,S
	LDA 120,S
	PSHU S,A
	ANDA #$0F
	ORA #$90
	STA 120,S
	LDA #$ff
	STA -121,S
	LDD #$fa00
	STD -42,S
	LDA #$11
	STA -81,S
	LEAS 278,S

	LDX -120,S
	LDY -80,S
	PSHU Y,X
	LDA -118,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA -118,S
	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA -38,S
	LDD #$aaaa
	STD -80,S
	LDX -40,S
	PSHU X
	LDA #$ac
	STD -120,S
	STD -40,S
	PULS A,X
	PSHU S,X,A
	LDA #$ba
	LDX #$910d
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$ba
	LDX #$239d
	PSHS A,X
	LEAS 40,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ac
	STD 39,S
	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ac
	STD 79,S
	LDD 119,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD 119,S
	LDX 41,S
	LDD #$23ac
	STD 41,S
	LDY 81,S
	PSHU Y,X
	LDA #$3c
	STD 81,S
	LDD 121,S
	PSHU D
	LDD #$ccad
	STD 121,S
	PULS A,X
	PSHU S,X,A
	LDA #$ba
	LDX #$23ad
	PSHS A,X
	LEAS 160,S

	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$ccdd
	PSHS A,X
	LEAS 40,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ac
	STD 39,S
	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 79,S
	LDX 41,S
	LDD #$ccdd
	STD 41,S
	LDY 81,S
	PSHU Y,X
	LDA #$cd
	STD 81,S
	PULS A,X
	PSHU S,X,A
	LDA #$dc
	LDX #$ccdd
	PSHS A,X
	LEAS 120,S

	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$ccd3
	PSHS A,X
	LEAS 40,S

	LDD 40,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$cd
	STD 40,S
	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$dd
	STD 80,S
	LDA 42,S
	PSHU A
	LDA #$00
	STA 42,S
	LDA 82,S
	STB 82,S
	PULS B,X
	PSHU S,X,B,A
	LDA #$dd
	LDX #$dddd
	PSHS A,X
	LEAS 120,S

	PULS A,X
	PSHU S,X,A
	LDA #$ac
	LDX #$dddd
	PSHS A,X
	LEAS 40,S

	LDD 40,S
	PSHU D
	LDA #$dd
	ANDB #$F0
	ORB #$0c
	STD 40,S
	LDD 80,S
	PSHU D
	LDA #$dd
	ANDB #$F0
	ORB #$0c
	STD 80,S
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 42,S
	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 82,S
	LDA 121,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA 121,S
	PULS A,X
	PSHU S,X,A
	LDA #$cd
	LDX #$dcdd
	PSHS A,X
	LEAS 181,S

	LDA -20,S
	LDB 20,S
	PSHU S,B,A
	LDA #$dd
	STA -20,S
	STA 20,S

	LDS $9F00+2
	LDU #ERASE_DATA_HJL7_END

	LEAS 543,S

	LDA -61,S
	LDB 60,S
	LDX 19,S
	PSHU X,B,A
	LDD -21,S
	PSHU D
	LDA #$ff
	ANDB #$0F
	ORB #$10
	STD -21,S
	STA -61,S
	LDD #$a111
	STD 19,S
	LDD 58,S
	PSHU S,D
	ANDA #$F0
	ORA #$0f
	LDB #$ae
	STD 58,S
	LDA #$0e
	STA 60,S
	LEAS 218,S

	LDD -120,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0f90
	STD -120,S
	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$a9
	STD -80,S
	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA -38,S
	LDX -40,S
	PSHU X
	LDD #$af9a
	STD -40,S
	PULS A,X
	PSHU S,X,A
	LDA #$ac
	LDX #$0aa0
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$0a11
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$dc33
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$ca
	LDX #$dcaa
	PSHS A,X
	LEAS 40,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$cc
	STD 40,S
	LDA 42,S
	PSHU A
	LDA #$ca
	STA 42,S
	PULS A,X
	PSHU S,X,A
	LDA #$ca
	LDX #$dcaa
	PSHS A,X
	LEAS 80,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$aa
	LDX #$cdca
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$aa
	LDX #$ccca
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$ca
	LDX #$ccdd
	PSHS A,X
	LEAS 40,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ca
	STD 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	LDD 42,S
	PSHU D
	LDA #$dd
	ANDB #$0F
	ORB #$d0
	STD 42,S
	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$cccd
	PSHS A,X
	LEAS 80,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$aa
	LDX #$cacd
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$ca
	LDX #$dadd
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$dadd
	PSHS A,X
	LEAS 40,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 40,S
	LDA 42,S
	LDX 81,S
	PSHU X,A
	LDA #$d0
	STA 42,S
	LDD #$cddd
	STD 81,S
	PULS A,X
	PSHU S,X,A
	LDX #$ccdd
	PSHS B,X
	LEAS 120,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dd
	STD 40,S
	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 80,S
	LDD 121,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$dd
	STD 121,S
	LDA 42,S
	PSHU A
	LDA #$cd
	STA 42,S
	LDA 82,S
	STB 82,S
	PULS B,X
	PSHU S,X,B,A
	LDA #$ca
	LDX #$cddd
	PSHS A,X
	LEAS 202,S

	LDA -40,S
	LDB ,S
	PSHU B,A
	ANDB #$0F
	ORB #$d0
	STB ,S
	LDA 39,S
	PSHU S,A
	ANDA #$F0
	ORA #$0d
	STA 39,S
	LDA #$dd
	STA -40,S
SSAV_HJL7
	LDS #$0000
	PULS U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HJL7
	PSHS U
	STS ERASE_SSAV_HJL7+2

ERASE_POS_HJL7_1
	LDU #ERASE_DATA_HJL7_1

ERASE_CODE_HJL7_1
	PULU A,B,S
	STA -20,S
	STB 20,S

	PULU A,X,S
	PSHS A,X

	PULU A,B
	STA 121,S
	STB 82,S

	PULU A,X,Y
	STA 42,S
	STX 80,S
	STY 40,S

	PULU A,X,S
	PSHS A,X

	PULU A,B,X,S
	PSHS B,X
	STA 82,S

	PULU A,X,Y
	STA 42,S
	STX 80,S
	STY 40,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y
	STD 41,S
	STX 81,S
	STY 79,S

	PULU D
	STD 39,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y
	STD 121,S
	STX 41,S
	STY 81,S

	PULU D,X,Y
	STD 119,S
	STX 79,S
	STY 39,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD -40,S

	PULU A,B,X,Y
	STA -38,S
	STB -118,S
	STX -120,S
	STY -80,S

	PULU A,S
	STA 120,S

	PULU A,B
	STA 40,S
	STB -121,S

	PULU A,X,Y
	STA ,S
	STX 78,S
	STY -42,S

	PULU A,B,X,Y
	STA -2,S
	STB -81,S
	STX 118,S
	STY 38,S

	PULU A,S
	STA 39,S

	PULU A,B
	STA -40,S
	STB ,S

	PULU A,B,X,S
	PSHS B,X
	STA 82,S

	PULU A,X,Y
	STA 42,S
	STX 121,S
	STY 80,S

	PULU D
	STD 40,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,Y
	STA 42,S
	STX 81,S
	STY 40,S

	PULU A,X,S
	PSHS A,X

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

	PULU D
	STD 42,S

	PULU A,X
	STA 3,S
	STX 40,S

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

	PULU A,X
	STA 42,S
	STX 40,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD -40,S

	PULU A,X,Y
	STA -38,S
	STX -80,S
	STY -120,S

	PULU D,S
	STD 58,S

	PULU D
	STD -21,S

	PULU A,B,X
	STA -61,S
	STB 60,S
	STX 19,S

ERASE_SSAV_HJL7
	LDS #$0000
	PULS U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HJL7_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HJL7_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HJL7_END
