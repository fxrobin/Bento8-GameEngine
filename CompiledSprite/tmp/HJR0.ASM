(main)IMG.ASM
	ORG $CA0A
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
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -120,S

	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -38,S

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD #$ddcc
	STD -40,S

	STD -80,S

	PULS A,X
	PSHU A,X,S
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
	PULS A,X
	PSHU A,X,S
	LDX #$cccc
	PSHS B,X

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

	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDD #$ccac
	STD 81,S

	STX 41,S

	LDD #$caaa
	STD 121,S

	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$cccc
	PSHS A,X

	LEAS 280,S
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
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 119,S

	LDD -119,S
	PSHU D

	LDD -79,S
	PSHU D

	LDD -39,S
	PSHU D

	LDD 1,S
	PSHU D

	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D,S

	STX -79,S

	LDD #$ccac
	STD -119,S

	STX -39,S

	STX 1,S

	STX 41,S

	STX 81,S

	STX 121,S

	LEAS 160,S
	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -1,S

	LDD 1,S
	PSHU D,S

	STX 1,S

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

	LDD -119,S
	PSHU D

	LDD -79,S
	PSHU D

	LDD -39,S
	PSHU D

	STX -79,S

	STX -119,S

	STX -39,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$cccc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$cccd
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$ccdd
	PSHS A,X

	LEAS 40,S
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

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$dddd
	STD 80,S

	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDX #$ccdd
	PSHS B,X

	LEAS 161,S
	LDA ,S
	PSHU A,S

	STB ,S


	LDS $9F00+2
	STS ERASE_POS_HJR0_2+2
	LDU #ERASE_DATA_HJR0_END

	LEAS 542,S
	LDA -20,S
	PSHU A

	LDD 20,S
	PSHU D,S

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

	LDD -119,S
	PSHU D

	LDA -78,S
	PSHU A

	LDA -38,S
	PSHU A

	LDD #$cccc
	STD -119,S

	STA -38,S

	STA -78,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$cccc
	PSHS A,X

	LEAS 40,S
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

	PULS A,X
	PSHU A,X,S
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
	PSHU A,X,S
	LDA #$dc
	LDX #$ccab
	PSHS A,X

	LEAS 40,S
	PULS D,X
	PSHU D,X,S
	LDD #$dccc
	LDX #$abcc
	PSHS D,X

	LEAS 40,S
	PULS D,X
	PSHU D,X,S
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
	PULS D,X
	PSHU D,X,S
	LDD #$dccc
	LDX #$cacc
	PSHS D,X

	LEAS 40,S
	PULS D,X
	PSHU D,X,S
	LDD #$dccc
	LDX #$cccc
	PSHS D,X

	LEAS 40,S
	PULS D,X
	PSHU D,X,S
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
	PULS D,X
	PSHU D,X,S
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
	PSHU A,X,S
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
	PSHU A,X,S
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
	PSHU A,X,S
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
	PSHU A,X,S
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
	PSHU A,X,S
	LDA #$dd
	LDX #$cccc
	PSHS A,X

	LEAS 40,S
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

	LDA 42,S
	PSHU A

	LDA 82,S
	PSHU A

	LDD 121,S
	PSHU D

	LDD #$dddd
	STD 121,S

	LDA #$cd
	STA 42,S

	STB 82,S

	PULS A,X
	PSHU A,X,S
	LDX #$dccc
	PSHS B,X

	LEAS 181,S
	LDD -20,S
	PSHU D

	LDA 20,S
	PSHU A,S

	LDA #$dd
	STA 20,S

	LDD #$dddd
	STD -20,S

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
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 80,S
	PULU D
	STD 40,S
	PULU D
	STD 120,S
	PULU A
	STA 42,S
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU D
	STD -39,S
	PULU D
	STD -79,S
	PULU D
	STD -119,S
	PULU D
	STD -41,S
	PULU D
	STD -81,S
	PULU D
	STD -121,S
	PULU D,S
	STD 1,S
	PULU D
	STD -1,S
	PULU D,S
	STD 121,S
	PULU D
	STD 81,S
	PULU D
	STD 41,S
	PULU D
	STD 1,S
	PULU D
	STD -39,S
	PULU D
	STD -79,S
	PULU D
	STD -119,S
	PULU D
	STD 119,S
	PULU D
	STD 79,S
	PULU D
	STD 39,S
	PULU D
	STD -1,S
	PULU D
	STD -41,S
	PULU D
	STD -81,S
	PULU D
	STD -121,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 121,S
	PULU D
	STD 81,S
	PULU D
	STD 41,S
	PULU D
	STD 119,S
	PULU D
	STD 79,S
	PULU D
	STD 39,S
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU D
	STD -40,S
	PULU D
	STD -80,S
	PULU A
	STA -38,S
	PULU D
	STD -120,S
	PULU A,S
	STA ,S
ERASE_POS_HJR0_2
	LDS #$0000
	LDU #ERASE_DATA_HJR0_2

ERASE_CODE_HJR0_2
	PULU A,S
	STA 20,S
	PULU D
	STD -20,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 121,S
	PULU A
	STA 82,S
	PULU A
	STA 42,S
	PULU D
	STD 80,S
	PULU D
	STD 40,S
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
	PULU A,X,S
	PSHS A,X
	PULU A
	STA -38,S
	PULU A
	STA -78,S
	PULU D
	STD -119,S
	PULU D
	STD -40,S
	PULU D
	STD -80,S
	PULU D,S
	STD 20,S
	PULU A
	STA -20,S
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
	FCB $00
	FCB $00
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
