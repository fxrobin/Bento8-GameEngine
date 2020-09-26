(main)IMG.ASM
	ORG $BABA
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

	LDX -120,S
	LDY -80,S
	PSHU Y,X
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
	LDX -40,S
	PSHU X
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

	LDX 40,S
	LDY 80,S
	PSHU Y,X
	LDD -39,S
	LDX -79,S
	LDY 120,S
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
	LDA -38,S
	LDX -79,S
	PSHU X,A
	LDD #$ccdd
	STD -79,S
	STB -38,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -40,S
	PULS A,X
	PSHU S,X,A
	LDX #$cccd
	PSHS B,X
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
	PULS A,X
	PSHU S,X,A
	LDA #$ca
	LDX #$cccc
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
	LDX #$accc
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
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
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
	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$cccd
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS A,X
	PSHU S,X,A
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

	PULU A,X,S
	PSHS A,X

	PULU A,B,X,Y
	STA 82,S
	STB 42,S
	STX -41,S
	STY -81,S

	PULU D,X,Y
	STD -39,S
	STX -79,S
	STY 120,S

	PULU D,X
	STD 40,S
	STX 80,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 122,S
	STX 42,S
	STY 82,S

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

	PULU D
	STD -40,S

	PULU A,B,X,Y
	STA -38,S
	STB -78,S
	STX -120,S
	STY -80,S

	PULU A,X,S
	STA -20,S
	STX 19,S

ERASE_POS_HJL0_2
	LDS #$0000
	LDU #ERASE_DATA_HJL0_2

ERASE_CODE_HJL0_2
	PULU A,S
	STA ,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 121,S

	PULU A,X,Y
	STA 42,S
	STX 81,S
	STY 40,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

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

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

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
	STX -79,S
	STY -119,S

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
