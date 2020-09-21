(main)IMG.ASM
	ORG $ADB3
DRAW_HJR3
	PSHS U,DP
	STS SSAV_HJR3+2

	LDS $9F00
	STS ERASE_POS_HJR3_1+2
	LDU #ERASE_DATA_HJR3_2
	LEAS 503,S
	LDA -20,S
	PSHU A,S

	LDA 20,S
	PSHU A

	LDA #$aa
	STA -20,S

	LDA #$dc
	STA 20,S

	LEAS 179,S
	LDA -119,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA -119,S

	LDD -80,S
	PSHU D
	LDA #$cc
	ANDB #$F0
	ORB #$0d
	STD -80,S

	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -78,S

	LDD -40,S
	PSHU D
	LDA #$cc
	ANDB #$F0
	ORB #$0d
	STD -40,S

	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -38,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cd
	STD 40,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 80,S

	LDD 120,S
	PSHU D
	ANDA #$0F
	ORA #$c0
	LDB #$cc
	STD 120,S

	LDA 42,S
	PSHU A

	LDA 82,S
	PSHU A

	LDA 122,S
	PSHU A

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
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD 39,S

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

	LDD 121,S
	PSHU D

	LDD #$ccaa
	STD 81,S

	STD 121,S

	LDB #$a3
	STD 41,S

	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$cccc
	PSHS A,X

	LEAS 160,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 40,S

	LDA 42,S
	PSHU A

	LDA #$aa
	STA 42,S

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
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cd
	STD 39,S

	LDD 41,S
	PSHU D

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

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$acab
	STD 40,S

	LDD #$9aaa
	STD 120,S

	LDB #$bb
	STD 80,S

	PULS A,X
	PSHU A,X,S
	LDA #$c3
	LDX #$a3ad
	PSHS A,X

	LEAS 281,S
	LDA 1,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 1,S

	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$1f
	STD 79,S

	LDD -121,S
	PSHU D

	LDD -81,S
	PSHU D

	LDD -41,S
	PSHU D

	LDA -1,S
	PSHU A

	LDD 39,S
	PSHU D,S

	LDA 120,S
	PSHU A

	LDD #$ea99
	STD -41,S

	LDD #$09f2
	STD 39,S

	LDA #$ee
	STA 120,S

	LDD #$0aaa
	STD -121,S

	LDA #$e9
	STA -1,S

	STD -81,S


	LDS $9F00+2
	STS ERASE_POS_HJR3_2+2
	LDU #ERASE_DATA_HJR3_END

	LEAS 583,S
	LDA -101,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA -101,S

	LDA -60,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -60,S

	LDD 19,S
	PSHU D
	ANDA #$0F
	ORA #$c0
	LDB #$ca
	STD 19,S

	LDD 58,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD 58,S

	LDD 98,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 98,S

	LDA -20,S
	PSHU A

	LDA 60,S
	PSHU A,S

	LDA 100,S
	PSHU A

	LDA #$ca
	STA -20,S

	STB 60,S

	LDA #$dc
	STA 100,S

	LEAS 258,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dd
	STD -40,S

	LDD -119,S
	PSHU D

	LDD -79,S
	PSHU D

	LDA -38,S
	PSHU A

	LDA #$cc
	STA -38,S

	LDD #$dcdc
	STD -119,S

	STD -79,S

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
	LDA #$dd
	LDX #$ddab
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 3,S

	LDA 43,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 43,S

	LDA 83,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 83,S

	LDA 123,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 123,S

	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDD #$dcab
	STD 41,S

	LDD #$ddca
	STD 81,S

	LDD #$cccc
	STD 121,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$dcab
	PSHS A,X

	LEAS 200,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD -40,S

	LDD -38,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$a0
	STD -38,S

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
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 3,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 40,S

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
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA 42,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$90
	STD 80,S

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

	LDD 40,S
	PSHU D

	LDD #$0e99
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$d0
	LDX #$a9a0
	PSHS A,X

	LEAS 221,S
	LDD -61,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$af
	STD -61,S

	LDD 60,S
	PSHU D,S
	LDA #$ee
	ANDB #$0F
	ORB #$10
	STD 60,S

	LDD -20,S
	PSHU D

	LDD 20,S
	PSHU D

	LDD #$af2f
	STD -20,S

	LDD #$a1f1
	STD 20,S

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
	PULU A,X,S
	STA 120,S
	STX 39,S

	PULU A,X,Y
	STA -1,S
	STX -41,S
	STY -81,S

	PULU D,X
	STD -121,S
	STX 79,S

	PULU A
	STA 1,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 120,S
	STX 80,S
	STY 40,S

	PULU A,B
	STA 122,S
	STB 82,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 41,S
	STX 39,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA 42,S
	STX 40,S

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

	PULU A,B
	STA 122,S
	STB 82,S

	PULU A,X,Y
	STA 42,S
	STX 120,S
	STY 80,S

	PULU D
	STD 40,S

	PULU A,X
	STA -38,S
	STX -40,S

	PULU A,X
	STA -78,S
	STX -80,S

	PULU A
	STA -119,S

	PULU A,B,S
	STA 20,S
	STB -20,S

ERASE_POS_HJR3_2
	LDS #$0000
	LDU #ERASE_DATA_HJR3_2

ERASE_CODE_HJR3_2
	PULU D,X,Y,S
	STD 20,S
	STX -20,S
	STY 60,S

	PULU D
	STD -61,S

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 40,S

	PULU A,X
	STA 122,S
	STX 120,S

	PULU A,X
	STA 82,S
	STX 80,S

	PULU A
	STA 42,S

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

	PULU A,X
	STA 42,S
	STX 40,S

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA 3,S
	STX -38,S
	STY -40,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 121,S
	STX 81,S
	STY 41,S

	PULU A,B
	STA 123,S
	STB 83,S

	PULU A,B
	STA 43,S
	STB 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA -38,S
	STX -79,S
	STY -119,S

	PULU D
	STD -40,S

	PULU A,B,S
	STA 100,S
	STB 60,S

	PULU A,X,Y
	STA -20,S
	STX 98,S
	STY 58,S

	PULU D
	STD 19,S

	PULU A,B
	STA -60,S
	STB -101,S

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
