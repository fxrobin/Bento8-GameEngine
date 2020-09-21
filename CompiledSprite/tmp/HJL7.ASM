(main)IMG.ASM
	ORG $A000
DRAW_HJL7
	PSHS U,DP
	STS SSAV_HJL7+2

	LDS $9F00
	STS ERASE_POS_HJL7_1+2
	LDU #ERASE_DATA_HJL7_2
	LEAS 604,S
	LDA ,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA ,S

	LDA 40,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 40,S

	LDA 120,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA 120,S

	LDA -121,S
	PSHU A

	LDA -81,S
	PSHU A

	LDD -42,S
	PSHU D

	LDA -2,S
	PSHU A

	LDD 38,S
	PSHU D,S

	LDD 78,S
	PSHU D

	LDD 118,S
	PSHU D

	LDA #$ff
	STA -121,S

	LDA #$11
	STA -81,S

	LDD #$fa99
	STD 38,S

	LDB #$00
	STD -42,S

	STA -2,S

	LDD #$19aa
	STD 78,S

	LDA #$ea
	STD 118,S

	LEAS 278,S
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

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD #$aaaa
	STD -80,S

	LDA #$ac
	STD -120,S

	STD -40,S

	PULS A,X
	PSHU A,X,S
	LDA #$ba
	LDX #$910d
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
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

	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDD #$ccad
	STD 121,S

	LDD #$3cac
	STD 81,S

	LDA #$23
	STD 41,S

	PULS A,X
	PSHU A,X,S
	LDA #$ba
	LDX #$23ad
	PSHS A,X

	LEAS 160,S
	PULS A,X
	PSHU A,X,S
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

	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD #$cddd
	STD 81,S

	STX 41,S

	PULS A,X
	PSHU A,X,S
	LDA #$dc
	LDX #$ccdd
	PSHS A,X

	LEAS 120,S
	PULS A,X
	PSHU A,X,S
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

	LDA 82,S
	PSHU A

	LDA #$00
	STA 42,S

	STB 82,S

	PULS A,X
	PSHU A,X,S
	LDX #$dddd
	PSHS B,X

	LEAS 120,S
	PULS A,X
	PSHU A,X,S
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

	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 42,S

	LDD 80,S
	PSHU D
	LDA #$dd
	ANDB #$F0
	ORB #$0c
	STD 80,S

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
	PSHU A,X,S
	LDA #$cd
	LDX #$dcdd
	PSHS A,X

	LEAS 181,S
	LDA -20,S
	PSHU A,S

	LDA 20,S
	PSHU A

	LDA #$dd
	STA -20,S

	STA 20,S


	LDS $9F00+2
	STS ERASE_POS_HJL7_2+2
	LDU #ERASE_DATA_HJL7_END

	LEAS 543,S
	LDD -21,S
	PSHU D
	LDA #$ff
	ANDB #$0F
	ORB #$10
	STD -21,S

	LDD 58,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$ae
	STD 58,S

	LDA -61,S
	PSHU A

	LDD 19,S
	PSHU D,S

	LDA 60,S
	PSHU A

	LDA #$ff
	STA -61,S

	LDD #$a111
	STD 19,S

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

	LDD -40,S
	PSHU D

	LDD #$af9a
	STD -40,S

	PULS A,X
	PSHU A,X,S
	LDA #$ac
	LDX #$0aa0
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$0a11
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$dc33
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
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
	PSHU A,X,S
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
	PSHU A,X,S
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
	PSHU A,X,S
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
	PSHU A,X,S
	LDA #$ca
	LDX #$ccdd
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ca
	STD 40,S

	LDD 42,S
	PSHU D
	LDA #$dd
	ANDB #$0F
	ORB #$d0
	STD 42,S

	PULS A,X
	PSHU A,X,S
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
	PSHU A,X,S
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
	PSHU A,X,S
	LDA #$ca
	LDX #$dadd
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
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
	PSHU A

	LDD 81,S
	PSHU D

	LDA #$d0
	STA 42,S

	LDD #$cddd
	STD 81,S

	PULS A,X
	PSHU A,X,S
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

	LDA 82,S
	PSHU A

	LDA #$cd
	STA 42,S

	STB 82,S

	PULS A,X
	PSHU A,X,S
	LDA #$ca
	LDX #$cddd
	PSHS A,X

	LEAS 202,S
	LDA ,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA ,S

	LDA 39,S
	PSHU A,S
	ANDA #$F0
	ORA #$0d
	STA 39,S

	LDA -40,S
	PSHU A

	STB -40,S

SSAV_HJL7
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HJL7
	PSHS U,DP
	STS ERASE_SSAV_HJL7+2

ERASE_POS_HJL7_1
	LDS #$0000
	LDU #ERASE_DATA_HJL7_1

ERASE_CODE_HJL7_1
	PULU A,B,S
	STA 20,S
	STB -20,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X
	STA 121,S
	STB 82,S
	STX 80,S

	PULU A,X
	STA 42,S
	STX 40,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA 82,S
	STB 42,S
	STX 80,S
	STY 40,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 81,S
	STX 41,S
	STY 79,S

	PULU D
	STD 39,S

	PULU B,X,S
	PSHS B,X

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

	PULU D,X,Y
	STD -40,S
	STX -80,S
	STY -120,S

	PULU A,B
	STA -38,S
	STB -118,S

	PULU D,X,Y,S
	STD 118,S
	STX 78,S
	STY 38,S

	PULU A,X
	STA -2,S
	STX -42,S

	PULU A,B
	STA -81,S
	STB -121,S

	PULU A,B
	STA 120,S
	STB 40,S

	PULU A
	STA ,S

ERASE_POS_HJL7_2
	LDS #$0000
	LDU #ERASE_DATA_HJL7_2

ERASE_CODE_HJL7_2
	PULU A,B,S
	STA -40,S
	STB 39,S

	PULU A
	STA ,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA 82,S
	STB 42,S
	STX 121,S
	STY 80,S

	PULU D
	STD 40,S

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 81,S

	PULU A,X
	STA 42,S
	STX 40,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 42,S
	STX 40,S

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA 42,S
	STX 40,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D
	STD -40,S

	PULU A,X,Y
	STA -38,S
	STX -80,S
	STY -120,S

	PULU A,X,S
	STA 60,S
	STX 19,S

	PULU A,X,Y
	STA -61,S
	STX 58,S
	STY -21,S

ERASE_SSAV_HJL7
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

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
