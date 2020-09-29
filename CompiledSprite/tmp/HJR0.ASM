(main)IMG.ASM
	ORG $BAB7
DRAW_HJR0
	PSHS U
	STS SSAV_HJR0+2

	LDS $9F00
	LDU #ERASE_DATA_HJR0_2
	LEAS 523,S

	LDA ,S
	PSHU S,A
	LDA #$cc
	STA ,S
	LEAS 159,S

	LDX -80,S
	LDY -40,S
	PSHU Y,X
	LDD #$ddcc
	STD -80,S
	STD -40,S
	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -38,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -120,S
	PULS A,X
	PSHU S,X,A
	LDA #$dc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$dc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

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
	LDD 119,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 119,S
	LDX 41,S
	LDY 81,S
	PSHU Y,X
	LDD 121,S
	PSHU D
	LDD #$caaa
	STD 121,S
	LDD #$ccac
	STD 81,S
	LDB #$cc
	STD 41,S
	PULS A,X
	PSHU S,X,A
	LDX #$cccc
	PSHS B,X
	LEAS 280,S

	LDX -39,S
	LDY 121,S
	PSHU Y,X
	LDD 41,S
	LDX -79,S
	LDY 1,S
	PSHU Y,X,D
	LDD 81,S
	LDX -119,S
	PSHU X,D
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
	LDD 119,S
	PSHU S,D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 119,S
	LDD #$ccac
	STD -119,S
	LDB #$cc
	STD -79,S
	STD -39,S
	STD 1,S
	STD 41,S
	STD 81,S
	STD 121,S
	LEAS 160,S

	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -1,S
	LDX 1,S
	PSHU S,X
	LDD #$cccc
	STD 1,S
	LEAS 160,S

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
	LDB #$dc
	STD -81,S
	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD -41,S
	LDX -119,S
	LDY -79,S
	PSHU Y,X
	LDD -39,S
	PSHU D
	LDD #$cccc
	STD -119,S
	STD -79,S
	STD -39,S
	PULS A,X
	PSHU S,X,A
	LDA #$dd
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$dd
	LDX #$cccd
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$dd
	LDX #$ccdd
	PSHS A,X
	LEAS 40,S

	LDX 40,S
	LDY 80,S
	PSHU Y,X
	LDD #$dddd
	STD 40,S
	STD 80,S
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 42,S
	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 120,S
	PULS A,X
	PSHU S,X,A
	LDX #$ccdd
	PSHS B,X
	LEAS 161,S

	LDA ,S
	PSHU S,A
	LDA #$dd
	STA ,S

	LDS $9F00+2
	LDU #ERASE_DATA_HJR0_END

	LEAS 542,S

	LDA -20,S
	LDX 20,S
	PSHU S,X,A
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
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -40,S
	LDA -78,S
	LDX -119,S
	PSHU X,A
	LDD #$cccc
	STD -119,S
	LDA -38,S
	STB -78,S
	STB -38,S
	PULS B,X
	PSHU S,X,B,A
	LDA #$dd
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
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
	PSHU S,X,A
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
	PSHU S,X,A
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
	PSHU S,X,A
	LDA #$dc
	LDX #$ccab
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$dc
	LDX #$ccab
	PSHS A,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$dccc
	LDX #$abcc
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$dccc
	LDX #$cacc
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$dccc
	LDX #$cacc
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$dccc
	LDX #$cacc
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$dccc
	LDX #$cccc
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$dccc
	LDX #$cccc
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$ddcc
	LDX #$cccc
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$ddcc
	LDX #$cccc
	PSHS D,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$dd
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$dd
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
	LDA #$dd
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
	LDA #$dd
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
	LDA #$dd
	LDX #$cccc
	PSHS A,X
	LEAS 40,S

	LDA 42,S
	LDB 82,S
	LDX 121,S
	PSHU X,B,A
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 40,S
	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 80,S
	LDA #$cd
	STA 42,S
	STB 82,S
	LDA #$dd
	STD 121,S
	PULS A,X
	PSHU S,X,A
	LDX #$dccc
	PSHS B,X
	LEAS 181,S

	LDA 20,S
	LDX -20,S
	PSHU S,X,A
	LDD #$dddd
	STD -20,S
	STA 20,S
SSAV_HJR0
	LDS #$0000
	PULS U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HJR0
	PSHS U
	STS ERASE_SSAV_HJR0+2

ERASE_POS_HJR0_1
	LDU #ERASE_DATA_HJR0_1

ERASE_CODE_HJR0_1
	PULU A,S
	STA ,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 120,S

	PULU A,X,Y
	STA 42,S
	STX 40,S
	STY 80,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y
	STD -39,S
	STX -119,S
	STY -79,S

	PULU D,X,Y
	STD -41,S
	STX -81,S
	STY -121,S

	PULU D,S
	STD 1,S

	PULU D
	STD -1,S

	PULU D,S
	STD 119,S

	PULU D,X,Y
	STD 79,S
	STX 39,S
	STY -1,S

	PULU D,X,Y
	STD -41,S
	STX -81,S
	STY -121,S

	PULU D,X,Y
	STD 81,S
	STX -119,S
	STY 41,S

	PULU D,X,Y
	STD -79,S
	STX 1,S
	STY -39,S

	PULU D
	STD 121,S

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

	PULU A,X,S
	PSHS A,X

	PULU D
	STD -120,S

	PULU A,X,Y
	STA -38,S
	STX -80,S
	STY -40,S

	PULU A,S
	STA ,S

	PULU A,X,S
	STA 20,S
	STX -20,S

	PULU A,X,S
	PSHS A,X

	PULU D,X
	STD 80,S
	STX 40,S

	PULU A,B,X
	STA 42,S
	STB 82,S
	STX 121,S

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

	PULU A,B,X,S
	PSHS B,X
	STA -38,S

	PULU A,X,Y
	STA -78,S
	STX -119,S
	STY -40,S

	PULU D
	STD -80,S

	PULU A,X,S
	STA -20,S
	STX 20,S

ERASE_SSAV_HJR0
	LDS #$0000
	PULS U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

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
