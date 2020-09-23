(main)IMG.ASM
	ORG $B3F9
DRAW_HJR0
	PSHS U,DP
	STS SSAV_HJR0+2

	LDS $9F00
	STS ERASE_POS_HJR0_1+2
	LDU #ERASE_DATA_HJR0_2
	LEAS 523,S

	LDA ,S
	PSHU A,S
	LDA #$cc
	STA ,S
	LEAS 159,S

	LDX -80,S
	PSHU X
	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -38,S
	LDD -40,S
	PSHU D
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -120,S
	LDD #$ddcc
	STD -80,S
	STD -40,S
	PULS A,Y
	PSHU A,Y,S
	LDA #$dc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	PULS B,X
	PSHU B,X,S
	LDA #$dc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	PULS B,X
	PSHU B,X,S
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDX 41,S
	PSHU X
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 39,S
	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 79,S
	LDD 121,S
	PSHU D
	LDD 81,S
	PSHU D
	LDD #$ccac
	STD 81,S
	LDB #$cc
	STD 41,S
	LDD #$caaa
	STD 121,S
	LDD 119,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 119,S
	PULS A,Y
	PSHU A,Y,S
	LDX #$cccc
	PSHS B,X
	LEAS 280,S

	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -41,S
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
	LDB #$cc
	STD 119,S
	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 79,S
	LDX -79,S
	PSHU X
	LDD -119,S
	PSHU D
	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -81,S
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 39,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -121,S
	LDX 41,S
	PSHU X
	LDD -39,S
	PSHU D
	LDX 1,S
	PSHU X,S
	LDD #$ccac
	STD -119,S
	LDX 81,S
	PSHU X
	LDB #$cc
	STD 41,S
	STD 1,S
	STD -79,S
	STD -39,S
	LDX 121,S
	PSHU X
	STD 81,S
	STD 121,S
	LEAS 160,S

	LDD 1,S
	PSHU D,S
	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -1,S
	LDD #$cccc
	STD 1,S
	LEAS 160,S

	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -121,S
	LDX -39,S
	PSHU X
	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD -81,S
	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD -41,S
	LDD #$cccc
	STD -39,S
	LDX -119,S
	PSHU X
	LDX -79,S
	PSHU X
	STD -79,S
	STD -119,S
	PULS B,Y
	PSHU B,Y,S
	LDA #$dd
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	PULS B,Y
	PSHU B,Y,S
	LDA #$dd
	LDX #$cccd
	PSHS A,X
	LEAS 40,S

	PULS B,Y
	PSHU B,Y,S
	LDA #$dd
	LDX #$ccdd
	PSHS A,X
	LEAS 40,S

	LDD 40,S
	PSHU D
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 42,S
	LDD #$dddd
	STD 40,S
	LDX 80,S
	PSHU X
	STD 80,S
	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 120,S
	PULS A,X
	PSHU A,X,S
	LDX #$ccdd
	PSHS B,X
	LEAS 161,S

	LDB ,S
	PSHU B,S
	LDA #$dd
	STA ,S

	LDS $9F00+2
	STS ERASE_POS_HJR0_2+2
	LDU #ERASE_DATA_HJR0_END

	LEAS 542,S

	LDD 20,S
	PSHU D,S
	LDB -20,S
	PSHU B
	LDD #$dccc
	STD 20,S
	STB -20,S
	LEAS 179,S

	LDX -119,S
	PSHU X
	LDA -78,S
	PSHU A
	LDD #$cccc
	STD -119,S
	LDA -38,S
	PSHU A
	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -80,S
	STB -38,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -40,S
	STB -78,S
	PULS A,Y
	PSHU A,Y,S
	LDA #$dd
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	PULS B,X
	PSHU B,X,S
	LDA #$dd
	LDX #$ccca
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
	LDX #$ccca
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 3,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$ccca
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 3,S
	PULS B,Y
	PSHU B,Y,S
	LDA #$dc
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
	LDA #$dc
	LDX #$ccab
	PSHS A,X
	LEAS 40,S

	PULS X,Y
	PSHU X,Y,S
	LDD #$dccc
	LDX #$abcc
	PSHS D,X
	LEAS 40,S

	PULS D,Y
	PSHU D,Y,S
	LDD #$dccc
	LDX #$cacc
	PSHS D,X
	LEAS 40,S

	PULS D,X
	PSHU D,X,S
	LDD #$dccc
	LDX #$cacc
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU X,Y,S
	LDD #$dccc
	LDX #$cacc
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU X,Y,S
	LDD #$dccc
	LDX #$cccc
	PSHS D,X
	LEAS 40,S

	PULS D,Y
	PSHU D,Y,S
	LDD #$dccc
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

	LDB 3,S
	PSHU B
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
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
	LDA #$dd
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDB 3,S
	PSHU B
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDD 121,S
	PSHU D
	LDB 82,S
	PSHU B
	LDB 42,S
	PSHU B
	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 80,S
	STB 82,S
	LDA #$cd
	STA 42,S
	LDA #$dd
	STD 121,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 40,S
	PULS A,X
	PSHU A,X,S
	LDX #$dccc
	PSHS B,X
	LEAS 181,S

	LDX -20,S
	PSHU X,S
	LDA 20,S
	PSHU A
	LDD #$dddd
	STD -20,S
	STA 20,S
SSAV_HJR0
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HJR0
	PSHS U,DP
	STS ERASE_SSAV_HJR0+2

ERASE_POS_HJR0_1
	LDS #$0000
	LDU #ERASE_DATA_HJR0_1

ERASE_CODE_HJR0_1
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
	STD -79,S
	STX -119,S
	STY -41,S

	PULU D,X,Y
	STD -81,S
	STX -39,S
	STY -121,S

	PULU D,X,S
	STD -1,S
	STX 1,S

	PULU D,X,Y,S
	STD 121,S
	STX 81,S
	STY 1,S

	PULU D,X,Y
	STD -39,S
	STX 41,S
	STY -121,S

	PULU D,X,Y
	STD 39,S
	STX -81,S
	STY -119,S

	PULU D,X,Y
	STD -79,S
	STX 79,S
	STY 119,S

	PULU D,X
	STD -1,S
	STX -41,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 119,S
	STX 81,S
	STY 121,S

	PULU D,X,Y
	STD 79,S
	STX 39,S
	STY 41,S

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

ERASE_POS_HJR0_2
	LDS #$0000
	LDU #ERASE_DATA_HJR0_2

ERASE_CODE_HJR0_2
	PULU A,X,S
	STA 20,S
	STX -20,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 40,S
	STX 80,S

	PULU A,B,X
	STA 42,S
	STB 82,S
	STX 121,S

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
	STD -40,S
	STX -80,S

	PULU A,B,X
	STA -38,S
	STB -78,S
	STX -119,S

	PULU A,X,S
	STA -20,S
	STX 20,S

ERASE_SSAV_HJR0
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HJR0_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HJR0_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJR0_END
