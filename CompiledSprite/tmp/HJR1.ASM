(main)IMG.ASM
	ORG $AD21
DRAW_HJR1
	PSHS U,DP
	STS SSAV_HJR1+2

	LDS $9F00
	STS ERASE_POS_HJR1_1+2
	LDU #ERASE_DATA_HJR1_2
	LEAS 523,S

	LDA ,S
	PSHU A,S
	LDA #$cc
	STA ,S
	LEAS 159,S

	LDX -80,S
	PSHU X
	LDB -38,S
	PSHU B
	ANDA #$0F
	ORA #$c0
	STA -38,S
	LDX -40,S
	PSHU X
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -120,S
	LDD #$ddcc
	STD -80,S
	STD -40,S
	PULS B,X
	PSHU B,X,S
	LDA #$dc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	PULS A,Y
	PSHU A,Y,S
	LDA #$dc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$dc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDD 119,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 119,S
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 39,S
	LDX 121,S
	PSHU X
	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 79,S
	LDD 81,S
	PSHU D
	LDD #$ccac
	STD 121,S
	LDX 41,S
	PSHU X
	STD 81,S
	LDB #$cc
	STD 41,S
	PULS B,Y
	PSHU B,Y,S
	LDX #$cccc
	PSHS A,X
	LEAS 280,S

	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -41,S
	LDX -39,S
	PSHU X
	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 79,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -121,S
	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -81,S
	LDX 121,S
	PSHU X
	LDD 1,S
	PSHU D
	LDX 81,S
	PSHU X
	LDD -119,S
	PSHU D
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 39,S
	LDD 41,S
	PSHU D
	LDX -79,S
	PSHU X,S
	LDD #$cccc
	STD 41,S
	STD 121,S
	STD -79,S
	STD -39,S
	STD 81,S
	STD 1,S
	LDB #$ac
	STD -119,S
	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -1,S
	LDD 119,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD 119,S
	LEAS 160,S

	LDD 1,S
	PSHU D,S
	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD -1,S
	LDD #$cccc
	STD 1,S
	LEAS 160,S

	LDD -39,S
	PSHU D
	LDD -119,S
	PSHU D
	LDD #$cccc
	STD -119,S
	LDX -79,S
	PSHU X
	STD -39,S
	STD -79,S
	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD -41,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD -121,S
	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD -81,S
	PULS A,X
	PSHU A,X,S
	LDX #$cccd
	PSHS B,X
	LEAS 40,S

	PULS B,Y
	PSHU B,Y,S
	LDA #$dd
	LDX #$ccdd
	PSHS A,X
	LEAS 40,S

	PULS B,Y
	PSHU B,Y,S
	LDA #$dd
	LDX #$dddd
	PSHS A,X
	LEAS 40,S

	LDX 40,S
	PSHU X
	LDB 42,S
	PSHU B
	ANDA #$0F
	ORA #$d0
	STA 42,S
	LDX 80,S
	PSHU X
	LDD #$dddd
	STD 40,S
	STD 80,S
	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 120,S
	PULS A,X
	PSHU A,X,S
	LDX #$dddd
	PSHS B,X
	LEAS 161,S

	LDA ,S
	PSHU A,S
	LDA #$dd
	STA ,S

	LDS $9F00+2
	STS ERASE_POS_HJR1_2+2
	LDU #ERASE_DATA_HJR1_END

	LEAS 542,S

	LDD 20,S
	PSHU D,S
	LDA -20,S
	PSHU A
	LDD #$dccc
	STD 20,S
	STB -20,S
	LEAS 179,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -80,S
	LDB -38,S
	PSHU B
	LDA -78,S
	PSHU A
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -40,S
	LDX -119,S
	PSHU X
	STB -78,S
	STB -38,S
	LDD #$dccc
	STD -119,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDB 3,S
	PSHU B
	ANDA #$0F
	ORA #$c0
	STA 3,S
	PULS B,Y
	PSHU B,Y,S
	LDA #$dd
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 3,S
	PULS A,Y
	PSHU A,Y,S
	LDA #$dd
	LDX #$ccca
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 3,S
	PULS B,X
	PSHU B,X,S
	LDA #$dd
	LDX #$ccab
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 3,S
	PULS B,Y
	PSHU B,Y,S
	LDA #$dd
	LDX #$ccab
	PSHS A,X
	LEAS 40,S

	PULS D,X
	PSHU D,X,S
	LDD #$ddcc
	LDX #$abcc
	PSHS D,X
	LEAS 40,S

	PULS D,Y
	PSHU D,Y,S
	LDD #$ddcc
	LDX #$cacc
	PSHS D,X
	LEAS 40,S

	PULS D,X
	PSHU D,X,S
	LDD #$ddcc
	LDX #$cccc
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU X,Y,S
	LDD #$ddcc
	LDX #$cccc
	PSHS D,X
	LEAS 40,S

	PULS D,X
	PSHU D,X,S
	LDD #$ddcc
	LDX #$cccc
	PSHS D,X
	LEAS 40,S

	PULS D,X
	PSHU D,X,S
	LDD #$ddcc
	LDX #$cccc
	PSHS D,X
	LEAS 40,S

	PULS D,Y
	PSHU D,Y,S
	LDD #$ddcc
	LDX #$cccc
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU X,Y,S
	LDD #$ddcc
	LDX #$cccd
	PSHS D,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 3,S
	PULS B,Y
	PSHU B,Y,S
	LDA #$dd
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
	LDA #$dd
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
	LDA #$dd
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
	LDA #$dd
	LDX #$dccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS B,X
	PSHU B,X,S
	LDA #$dd
	LDX #$ddcc
	PSHS A,X
	LEAS 40,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 80,S
	LDA 82,S
	PSHU A
	LDA 42,S
	PSHU A
	LDX 121,S
	PSHU X
	STB 82,S
	STB 42,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 40,S
	LDD #$dddd
	STD 121,S
	PULS A,X
	PSHU A,X,S
	LDX #$dddd
	PSHS B,X
	LEAS 181,S

	LDD -20,S
	PSHU D,S
	LDA 20,S
	PSHU A
	LDD #$dddd
	STD -20,S
	STA 20,S
SSAV_HJR1
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HJR1
	PSHS U,DP
	STS ERASE_SSAV_HJR1+2

ERASE_POS_HJR1_1
	LDS #$0000
	LDU #ERASE_DATA_HJR1_1

ERASE_CODE_HJR1_1
	PULU A,S
	STA ,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 120,S
	STX 80,S

	PULU A,X
	STA 42,S
	STX 40,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD -81,S
	STX -121,S
	STY -41,S

	PULU D,X,Y
	STD -79,S
	STX -119,S
	STY -39,S

	PULU D,X,S
	STD -1,S
	STX 1,S

	PULU D,X,Y,S
	STD 119,S
	STX -1,S
	STY -79,S

	PULU D,X,Y
	STD 41,S
	STX 39,S
	STY -119,S

	PULU D,X,Y
	STD 81,S
	STX 1,S
	STY 121,S

	PULU D,X,Y
	STD -81,S
	STX -121,S
	STY 79,S

	PULU D,X
	STD -39,S
	STX -41,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 41,S
	STX 81,S
	STY 79,S

	PULU D,X,Y
	STD 121,S
	STX 39,S
	STY 119,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -120,S
	STX -40,S

	PULU A,X
	STA -38,S
	STX -80,S

	PULU A,S
	STA ,S

ERASE_POS_HJR1_2
	LDS #$0000
	LDU #ERASE_DATA_HJR1_2

ERASE_CODE_HJR1_2
	PULU A,X,S
	STA 20,S
	STX -20,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 40,S
	STX 121,S

	PULU A,B,X
	STA 42,S
	STB 82,S
	STX 80,S

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

	PULU D,X,S
	PSHS D,X

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

	PULU D,X
	STD -119,S
	STX -40,S

	PULU A,B,X
	STA -78,S
	STB -38,S
	STX -80,S

	PULU A,X,S
	STA -20,S
	STX 20,S

ERASE_SSAV_HJR1
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HJR1_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HJR1_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJR1_END
