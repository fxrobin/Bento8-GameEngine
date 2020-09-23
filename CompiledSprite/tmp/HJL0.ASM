(main)IMG.ASM
	ORG $A6E3
DRAW_HJL0
	PSHS U,DP
	STS SSAV_HJL0+2

	LDS $9F00
	STS ERASE_POS_HJL0_1+2
	LDU #ERASE_DATA_HJL0_2
	LEAS 543,S

	LDD 19,S
	PSHU D,S
	LDA -20,S
	PSHU A
	LDD #$cccd
	STD 19,S
	STA -20,S
	LEAS 179,S

	LDD -40,S
	PSHU D
	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -38,S
	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -78,S
	LDD -120,S
	PSHU D
	LDD -80,S
	PSHU D
	LDD #$cccc
	STD -80,S
	STD -120,S
	STD -40,S
	PULS A,X
	PSHU A,X,S
	LDX #$ccdd
	PSHS B,X
	LEAS 40,S

	LDD 41,S
	PSHU D
	LDD 121,S
	PSHU D
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ac
	STD 39,S
	LDD 119,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ba
	STD 119,S
	LDD #$ccdd
	STD 41,S
	LDX 81,S
	PSHU X
	STD 81,S
	LDB #$cd
	STD 121,S
	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ac
	STD 79,S
	PULS A,X
	PSHU A,X,S
	LDX #$ccdd
	PSHS B,X
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
	PULS D,X
	PSHU D,X,S
	LDD #$ccba
	LDX #$cccd
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU X,Y,S
	LDD #$ccac
	LDX #$cccd
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU X,Y,S
	LDD #$ccac
	LDX #$cccd
	PSHS D,X
	LEAS 40,S

	PULS D,Y
	PSHU D,Y,S
	LDD #$ccac
	LDX #$cccd
	PSHS D,X
	LEAS 40,S

	PULS D,X
	PSHU D,X,S
	LDD #$cccc
	LDX #$cccd
	PSHS D,X
	LEAS 40,S

	PULS D,X
	PSHU D,X,S
	LDD #$cccc
	LDX #$cccd
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU X,Y,S
	LDD #$cccc
	LDX #$ccdd
	PSHS D,X
	LEAS 40,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD 80,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD 40,S
	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 120,S
	LDX 42,S
	PSHU X
	LDD 82,S
	PSHU D
	LDX 122,S
	PSHU X
	LDD #$ccdd
	STD 42,S
	STD 122,S
	STD 82,S
	PULS X,Y
	PSHU X,Y,S
	LDB #$cc
	LDX #$ccdd
	PSHS D,X
	LEAS 241,S

	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -41,S
	LDX 80,S
	PSHU X
	LDB 42,S
	PSHU B
	ANDA #$0F
	ORA #$d0
	STA 42,S
	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 82,S
	LDX -79,S
	PSHU X
	LDX -39,S
	PSHU X
	LDD #$dddd
	STD 80,S
	LDX 120,S
	PSHU X
	STD 120,S
	LDA #$cc
	STD -39,S
	LDX 40,S
	PSHU X
	STD -79,S
	LDA #$dc
	STD 40,S
	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -81,S
	PULS A,X
	PSHU A,X,S
	LDX #$cddd
	PSHS B,X
	LEAS 181,S

	LDD -21,S
	PSHU D,S
	LDA 20,S
	PSHU A
	LDD #$dddd
	STD -21,S
	STA 20,S

	LDS $9F00+2
	STS ERASE_POS_HJL0_2+2
	LDU #ERASE_DATA_HJL0_END

	LEAS 522,S

	LDB ,S
	PSHU B,S
	LDA #$cc
	STA ,S
	LEAS 159,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -40,S
	LDB -38,S
	PSHU B
	LDD -79,S
	PSHU D
	LDD -119,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$c0
	STD -119,S
	LDD #$ccdd
	STD -79,S
	STB -38,S
	PULS B,Y
	PSHU B,Y,S
	LDX #$cccd
	PSHS A,X
	LEAS 40,S

	PULS B,X
	PSHU B,X,S
	LDA #$cc
	LDX #$cccd
	PSHS A,X
	LEAS 40,S

	PULS B,X
	PSHU B,X,S
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDB 3,S
	PSHU B
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,Y
	PSHU B,Y,S
	LDA #$cc
	LDX #$cccc
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
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,X
	PSHU B,X,S
	LDA #$aa
	LDX #$accc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,Y
	PSHU B,Y,S
	LDA #$ca
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS A,Y
	PSHU A,Y,S
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
	PSHU B,X,S
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
	PSHU B,X,S
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDB 3,S
	PSHU B
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS A,Y
	PSHU A,Y,S
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,Y
	PSHU B,Y,S
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDB 3,S
	PSHU B
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS A,Y
	PSHU A,Y,S
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDB 3,S
	PSHU B
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,X
	PSHU B,X,S
	LDA #$cc
	LDX #$cccd
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,Y
	PSHU B,Y,S
	LDA #$cc
	LDX #$cccd
	PSHS A,X
	LEAS 40,S

	PULS B,Y
	PSHU B,Y,S
	LDA #$cc
	LDX #$ccdd
	PSHS A,X
	LEAS 40,S

	PULS B,Y
	PSHU B,Y,S
	LDA #$dc
	LDX #$ccdd
	PSHS A,X
	LEAS 40,S

	PULS A,Y
	PSHU A,Y,S
	LDA #$dd
	LDX #$ccdd
	PSHS A,X
	LEAS 40,S

	LDD 81,S
	PSHU D
	LDA 42,S
	PSHU A
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 40,S
	LDD #$dddd
	STD 81,S
	STA 42,S
	LDD 121,S
	PSHU D
	LDA #$dd
	ANDB #$0F
	ORB #$d0
	STD 121,S
	PULS B,Y
	PSHU B,Y,S
	LDX #$ccdd
	PSHS A,X
	LEAS 161,S

	LDB ,S
	PSHU B,S
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

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD -81,S
	STX 40,S
	STY 120,S

	PULU D,X
	STD -39,S
	STX -79,S

	PULU A,B,X,Y
	STA 82,S
	STB 42,S
	STX 80,S
	STY -41,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 122,S
	STX 82,S
	STY 42,S

	PULU D,X,Y
	STD 120,S
	STX 40,S
	STY 80,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD -40,S
	STX -38,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 79,S
	STX 81,S
	STY 119,S

	PULU D,X,Y
	STD 39,S
	STX 121,S
	STY 41,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -80,S
	STX -120,S

	PULU A,B,X
	STA -78,S
	STB -38,S
	STX -40,S

	PULU A,X,S
	STA -20,S
	STX 19,S

ERASE_POS_HJL0_2
	LDS #$0000
	LDU #ERASE_DATA_HJL0_2

ERASE_CODE_HJL0_2
	PULU A,S
	STA ,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 121,S
	STX 40,S

	PULU A,X
	STA 42,S
	STX 81,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

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

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -119,S
	STX -79,S

	PULU A,X
	STA -38,S
	STX -40,S

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
