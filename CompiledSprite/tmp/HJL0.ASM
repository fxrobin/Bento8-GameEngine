(main)IMG.ASM
	ORG $AD9A
DRAW_HJL0
	PSHS U,DP
	STS SSAV_HJL0+2

	LDS $9F00
	STS ERASE_POS_HJL0_1+2
	LDU #ERASE_DATA_HJL0_2
	LEAS 543,S

	LDA -20,S
	LDX 19,S
	PSHU S,X,A
	LDD #$cccd
	STD 19,S
	STA -20,S
	LEAS 179,S

	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -78,S
	LDB -38,S
	ANDA #$0F
	ORA #$d0
	STA -38,S
	LDX -120,S
	LDY -80,S
	PSHU Y,X,B
	LDD -40,S
	PSHU D
	LDD #$cccc
	STD -120,S
	STD -80,S
	STD -40,S
	PULS A,X
	PSHU S,X,A
	LDX #$ccdd
	PSHS B,X
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
	ORA #$0c
	LDB #$ac
	STD 79,S
	LDD 119,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ba
	STD 119,S
	LDX 41,S
	LDY 81,S
	PSHU Y,X
	LDD 121,S
	PSHU D
	LDD #$ccdd
	STD 41,S
	STD 81,S
	LDB #$cd
	STD 121,S
	PULS A,X
	PSHU S,X,A
	LDA #$ac
	LDX #$ccdd
	PSHS A,X
	LEAS 199,S

	LDX -38,S
	PSHU X
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ba
	STD -40,S
	LDD #$cccd
	STD -38,S
	PULS X,Y
	PSHU S,Y,X
	LDB #$ba
	LDX #$cccd
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$ccac
	LDX #$cccd
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$ccac
	LDX #$cccd
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$ccac
	LDX #$cccd
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$cccc
	LDX #$cccd
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$cccc
	LDX #$cccd
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$cccc
	LDX #$ccdd
	PSHS D,X
	LEAS 40,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD 40,S
	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD 80,S
	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 120,S
	LDX 42,S
	LDY 82,S
	PSHU Y,X
	LDD 122,S
	PSHU D
	LDD #$ccdd
	STD 42,S
	STD 82,S
	STD 122,S
	PULS X,Y
	PSHU S,Y,X
	LDB #$cc
	LDX #$ccdd
	PSHS D,X
	LEAS 241,S

	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 42,S
	LDB 82,S
	ANDA #$0F
	ORA #$d0
	STA 82,S
	LDX 80,S
	LDY 120,S
	PSHU Y,X,B
	LDD 40,S
	LDX -39,S
	LDY -79,S
	PSHU Y,X,D
	LDD #$ccdd
	STD -79,S
	STD -39,S
	LDA #$dc
	STD 40,S
	LDA #$dd
	STD 80,S
	STD 120,S
	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -81,S
	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -41,S
	PULS A,X
	PSHU S,X,A
	LDX #$cddd
	PSHS B,X
	LEAS 181,S

	LDA 20,S
	LDX -21,S
	PSHU S,X,A
	LDD #$dddd
	STD -21,S
	STA 20,S

	LDS $9F00+2
	STS ERASE_POS_HJL0_2+2
	LDU #ERASE_DATA_HJL0_END

	LEAS 522,S

	LDA ,S
	PSHU S,A
	LDA #$cc
	STA ,S
	LEAS 159,S

	LDD -119,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$c0
	STD -119,S
	LDX -79,S
	PSHU X
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -40,S
	LDA -38,S
	LDD #$ccdd
	STD -79,S
	STB -38,S
	PULS B,X
	PSHU S,X,B,A
	LDX #$cccd
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$cccd
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,X
	PSHU S,X,B
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,X
	PSHU S,X,B
	LDA #$ca
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,X
	PSHU S,X,B
	LDA #$aa
	LDX #$accc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,X
	PSHU S,X,B
	LDA #$ca
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,X
	PSHU S,X,B
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,X
	PSHU S,X,B
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,X
	PSHU S,X,B
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,X
	PSHU S,X,B
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,X
	PSHU S,X,B
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,X
	PSHU S,X,B
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,X
	PSHU S,X,B
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,X
	PSHU S,X,B
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,X
	PSHU S,X,B
	LDA #$cc
	LDX #$cccd
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,X
	PSHU S,X,B
	LDA #$cc
	LDX #$cccd
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$ccdd
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$dc
	LDX #$ccdd
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$dd
	LDX #$ccdd
	PSHS A,X
	LEAS 40,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 40,S
	LDA 42,S
	STB 42,S
	LDX 81,S
	PSHU X,A
	LDD 121,S
	PSHU D
	LDA #$dd
	ANDB #$0F
	ORB #$d0
	STD 121,S
	LDD #$dddd
	STD 81,S
	PULS A,X
	PSHU S,X,A
	LDX #$ccdd
	PSHS B,X
	LEAS 161,S

	LDA ,S
	PSHU S,A
	LDA #$dd
	STA ,S
SSAV_HJL0
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HJL0
	PSHS U,DP
	STS ERASE_SSAV_HJL0+2

ERASE_POS_HJL0_1
	LDS #$0000
	LDU #ERASE_DATA_HJL0_1

ERASE_CODE_HJL0_1
	PULU A,X,S
	STA 20,S
	STX -21,S

	PULU A,X,Y,S
	STA 1,S
	STX 3,S
	STY -41,S

	PULU D,X,Y
	STD -81,S
	STX 40,S
	STY -39,S

	PULU D
	STD -79,S

	PULU A,X,Y
	STA 82,S
	STX 80,S
	STY 120,S

	PULU A
	STA 42,S

	PULU D,X,Y,S
	STD 2,S
	STX 4,S
	STY 122,S

	PULU D,X,Y
	STD 42,S
	STX 82,S
	STY 120,S

	PULU D,X
	STD 80,S
	STX 40,S

	PULU D,X,S
	STD 2,S
	STX 4,S

	PULU D,X,S
	STD 2,S
	STX 4,S

	PULU D,X,S
	STD 2,S
	STX 4,S

	PULU D,X,S
	STD 2,S
	STX 4,S

	PULU D,X,S
	STD 2,S
	STX 4,S

	PULU D,X,S
	STD 2,S
	STX 4,S

	PULU D,X,Y,S
	STD 2,S
	STX 4,S
	STY -40,S

	PULU D
	STD -38,S

	PULU A,X,Y,S
	STA 1,S
	STX 3,S
	STY 121,S

	PULU D,X,Y
	STD 41,S
	STX 81,S
	STY 119,S

	PULU D,X
	STD 79,S
	STX 39,S

	PULU A,X,Y,S
	STA 1,S
	STX 3,S
	STY -40,S

	PULU A,X,Y
	STA -38,S
	STX -120,S
	STY -80,S

	PULU A
	STA -78,S

	PULU A,X,S
	STA -20,S
	STX 19,S

ERASE_POS_HJL0_2
	LDS #$0000
	LDU #ERASE_DATA_HJL0_2

ERASE_CODE_HJL0_2
	PULU A,S
	STA ,S

	PULU A,X,Y,S
	STA 1,S
	STX 3,S
	STY 121,S

	PULU A,X,Y
	STA 42,S
	STX 81,S
	STY 40,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A
	STA 3,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A
	STA 3,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A
	STA 3,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A
	STA 3,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A
	STA 3,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A
	STA 3,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A
	STA 3,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A
	STA 3,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A
	STA 3,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A
	STA 3,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A
	STA 3,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A
	STA 3,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A
	STA 3,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A
	STA 3,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A,X,S
	STA 1,S
	STX 3,S

	PULU A,B,X,Y,S
	STA -38,S
	STB 1,S
	STX 3,S
	STY -40,S

	PULU D,X
	STD -79,S
	STX -119,S

	PULU A,S
	STA ,S

ERASE_SSAV_HJL0
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HJL0_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJL0_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HJL0_END
