(main)IMG.ASM
	ORG $A000
DRAW_HJR3
	PSHS U,DP
	STS SSAV_HJR3+2

	LDS $9F00
	STS ERASE_POS_HJR3_1+2
	LDU #ERASE_DATA_HJR3_2
	LEAS 503,S

	LDA 20,S
	PSHU A,S

	LDA -20,S
	PSHU A

	LDA #$aa
	STA -20,S

	LDA #$dc
	STA 20,S

	LEAS 179,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$cd
	STD 40,S

	LDD -40,S
	PSHU D

	LDA #$cc
	ANDB #$F0
	ORB #$0d
	STD -40,S

	LDA 82,S
	PSHU A

	LDA -78,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -78,S

	LDD -80,S
	PSHU D

	LDA #$cc
	ANDB #$F0
	ORB #$0d
	STD -80,S

	LDD 120,S
	PSHU D

	ANDA #$0F
	ORA #$c0
	LDB #$cc
	STD 120,S

	LDA 122,S
	PSHU A

	LDA 42,S
	PSHU A

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 80,S

	LDA -119,S
	PSHU A

	ANDA #$F0
	ORA #$0d
	STA -119,S

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -38,S

	LDA #$aa
	STA 42,S

	STA 82,S

	STA 122,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$cdaa
	PSHS A,X

	LEAS 160,S

	LDD 121,S
	PSHU D

	LDD 79,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 79,S

	LDD 119,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 119,S

	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD 39,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD 39,S

	LDD #$cca3
	STD 41,S

	LDB #$aa
	STD 81,S

	STD 121,S

	PULS A,X
	PSHU A,X,S

	LDA #$cc
	LDX #$cccc
	PSHS A,X

	LEAS 160,S

	LDA 42,S
	PSHU A

	STB 42,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$ccaa
	PSHS A,X

	LEAS 80,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$ccda
	PSHS A,X

	LEAS 40,S

	LDD 41,S
	PSHU D

	LDD 39,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$cd
	STD 39,S

	LDD #$22ac
	STD 41,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$2cac
	PSHS A,X

	LEAS 80,S

	PULS A,X
	PSHU A,X,S

	LDA #$cd
	LDX #$32ac
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$dc
	LDX #$32ac
	PSHS A,X

	LEAS 40,S

	LDD 80,S
	PSHU D

	LDA 82,S
	PSHU A

	ANDA #$0F
	ORA #$90
	STA 82,S

	LDA 122,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA 122,S

	LDD 40,S
	PSHU D

	LDD #$acab
	STD 40,S

	LDD 120,S
	PSHU D

	LDD #$9abb
	STD 80,S

	LDB #$aa
	STD 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$c3
	LDX #$a3ad
	PSHS A,X

	LEAS 281,S

	LDD -121,S
	PSHU D

	LDD -41,S
	PSHU D

	LDD 79,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$1f
	STD 79,S

	LDD 39,S
	PSHU D

	LDA 120,S
	PSHU A

	LDD #$09f2
	STD 39,S

	LDD #$ea99
	STD -41,S

	LDD -81,S
	PSHU D,S

	LDA 1,S
	PSHU A

	ANDA #$0F
	ORA #$10
	STA 1,S

	LDD #$0aaa
	STD -121,S

	LDA -1,S
	PSHU A

	LDA #$e9
	STA -1,S

	STD -81,S

	LDA #$ee
	STA 120,S


	LDS $9F00+2
	STS ERASE_POS_HJR3_2+2
	LDU #ERASE_DATA_HJR3_END

	LEAS 583,S

	LDD 98,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 98,S

	LDA -20,S
	PSHU A

	LDA -60,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -60,S

	LDD 58,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD 58,S

	LDA 60,S
	PSHU A

	STB 60,S

	LDA 100,S
	PSHU A

	LDD 19,S
	PSHU D,S

	ANDA #$0F
	ORA #$c0
	LDB #$ca
	STD 19,S

	STB -20,S

	LDA -101,S
	PSHU A

	ANDA #$F0
	ORA #$0d
	STA -101,S

	LDA #$dc
	STA 100,S

	LEAS 258,S

	LDD -79,S
	PSHU D

	LDA -38,S
	PSHU A

	LDD -119,S
	PSHU D

	LDD #$dcdc
	STD -79,S

	STD -119,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$dd
	STD -40,S

	LDA #$cc
	STA -38,S

	PULS A,X
	PSHU A,X,S

	LDA #$cc
	LDX #$ddca
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDX #$ddab
	PSHS B,X

	LEAS 40,S

	LDD 121,S
	PSHU D

	LDA 83,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 83,S

	LDA 43,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 43,S

	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD #$dcab
	STD 41,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 3,S

	LDD #$cccc
	STD 121,S

	LDD #$ddca
	STD 81,S

	LDA 123,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 123,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$dcab
	PSHS A,X

	LEAS 200,S

	LDD -38,S
	PSHU D

	LDA #$cc
	ANDB #$0F
	ORB #$a0
	STD -38,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD -40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$cccd
	PSHS A,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 3,S

	LDA 42,S
	PSHU A

	LDA #$ca
	STA 42,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$ddca
	PSHS A,X

	LEAS 80,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$ddaa
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$dc
	LDX #$daa9
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$caa0
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$0a21
	PSHS A,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$0e
	LDB #$90
	STD 80,S

	LDD #$0e99
	STD 40,S

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$b0
	STA 42,S

	LDA 82,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 82,S

	LDD 120,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0e00
	STD 120,S

	LDA 122,S
	PSHU A

	ANDA #$0F
	ORA #$90
	STA 122,S

	PULS A,X
	PSHU A,X,S

	LDA #$d0
	LDX #$a9a0
	PSHS A,X

	LEAS 221,S

	LDD -20,S
	PSHU D

	LDD -61,S
	PSHU D,S

	ANDA #$F0
	ORA #$00
	LDB #$af
	STD -61,S

	LDD #$af2f
	STD -20,S

	LDD 20,S
	PSHU D

	LDD #$a1f1
	STD 20,S

	LDD 60,S
	PSHU D

	LDA #$ee
	ANDB #$0F
	ORB #$10
	STD 60,S

SSAV_HJR3
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HJR3
	PSHS U,DP
	STS ERASE_SSAV_HJR3+2

ERASE_POS_HJR3_1
	LDS #$0000
	LDU #ERASE_DATA_HJR3_1

ERASE_CODE_HJR3_1
	PULU A,B,X,S
	STA -1,S
	STB 1,S
	STX -81,S

	PULU A,X,Y
	STA 120,S
	STX 39,S
	STY 79,S

	PULU D,X
	STD -41,S
	STX -121,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 120,S
	STX 40,S

	PULU A,B,X
	STA 122,S
	STB 82,S
	STX 80,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 39,S
	STX 41,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 40,S

	PULU A
	STA 42,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 39,S
	STX 81,S
	STY 41,S

	PULU D,X,Y
	STD 119,S
	STX 79,S
	STY 121,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X
	STA -38,S
	STB -119,S
	STX 80,S

	PULU A,B,X,Y
	STA 42,S
	STB 122,S
	STX 120,S
	STY -80,S

	PULU A,B,X,Y
	STA -78,S
	STB 82,S
	STX -40,S
	STY 40,S

	PULU A,B,S
	STA -20,S
	STB 20,S

ERASE_POS_HJR3_2
	LDS #$0000
	LDU #ERASE_DATA_HJR3_2

ERASE_CODE_HJR3_2
	PULU D,X,Y,S
	STD 60,S
	STX 20,S
	STY -61,S

	PULU D
	STD -20,S

	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA 122,S
	STX 120,S

	PULU A,B,X,Y
	STA 82,S
	STB 42,S
	STX 80,S
	STY 40,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,B,X
	STA 42,S
	STB 3,S
	STX 40,S

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA 3,S
	STX -40,S
	STY -38,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA 123,S
	STB 3,S
	STX 81,S
	STY 41,S

	PULU A,B,X
	STA 43,S
	STB 83,S
	STX 121,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -40,S
	STX -119,S

	PULU A,X
	STA -38,S
	STX -79,S

	PULU A,X,S
	STA -101,S
	STX 19,S

	PULU A,B,X
	STA 100,S
	STB 60,S
	STX 58,S

	PULU A,B,X
	STA -60,S
	STB -20,S
	STX 98,S

ERASE_SSAV_HJR3
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HJR3_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HJR3_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJR3_END
