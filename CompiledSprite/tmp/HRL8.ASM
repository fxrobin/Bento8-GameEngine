(main)IMG.ASM
	ORG $D088
DRAW_HRL8
	PSHS U,DP
	STS SSAV_HRL8+2

	LDS $9F00
	STS ERASE_POS_HRL8_1+2
	LDU #ERASE_DATA_HRL8_2
	LEAS 603,S

	LDD 39,S
	PSHU D

	LDD 79,S
	PSHU D

	LDA #$32
	ANDB #$0F
	ORB #$d0
	STD 79,S

	LDD -81,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$ac
	STD -81,S

	LDD 119,S
	PSHU D

	LDA -120,S
	PSHU A

	LDA #$aa
	STA -120,S

	LDA -39,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA -39,S

	LDD -1,S
	PSHU D,S

	LDD #$d2dd
	STD -1,S

	LDA #$32
	STD 39,S

	LDD -41,S
	PSHU D

	LDD #$ddcc
	STD -41,S

	LDA #$a2
	STD 119,S

	LEAS 280,S

	LDD 40,S
	PSHU D

	LDD #$cddd
	STD 40,S

	LDD -2,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$aa
	STD -2,S

	LDD -121,S
	PSHU D

	LDD 38,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$aa
	STD 38,S

	LDD -40,S
	PSHU D

	LDA #$cc
	ANDB #$0F
	ORB #$c0
	STD -40,S

	LDD -82,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$ca
	STD -82,S

	LDD 79,S
	PSHU D

	LDD -42,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$ca
	STD -42,S

	LDA -80,S
	PSHU A

	LDA 120,S
	PSHU A

	LDD 118,S
	PSHU D,S

	ANDA #$F0
	ORA #$0a
	LDB #$ac
	STD 118,S

	LDD ,S
	PSHU D

	LDA #$cc
	ANDB #$0F
	ORB #$d0
	STD ,S

	STA -80,S

	LDD #$aacc
	STD -121,S

	LDB #$cd
	STD 79,S

	STB 120,S

	LEAS 159,S

	LDA 1,S
	PSHU A

	LDD -1,S
	PSHU D,S

	ANDA #$F0
	ORA #$09
	LDB #$c2
	STD -1,S

	LDA #$cc
	STA 1,S

	LEAS 160,S

	LDD -80,S
	PSHU D

	LDD 120,S
	PSHU D

	ANDA #$0F
	ORA #$f0
	LDB #$a0
	STD 120,S

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -38,S

	LDA -119,S
	PSHU A

	LDA #$dd
	STA -119,S

	LDD -40,S
	PSHU D

	LDD #$2202
	STD -40,S

	LDB #$dd
	STD -80,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 40,S

	LDD 81,S
	PSHU D

	LDD -121,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$b2
	STD -121,S

	LDA 122,S
	PSHU A

	LDA 42,S
	PSHU A

	LDD #$0dbb
	STD 81,S

	LDA #$ba
	STA 42,S

	STA 122,S

	PULS A,X
	PSHU A,X,S

	LDA #$31
	LDX #$13b9
	PSHS A,X

	LEAS 160,S

	LDD 40,S
	PSHU D

	LDD #$fb90
	STD 40,S

	LDA 122,S
	PSHU A

	ANDA #$F0
	ORA #$09
	STA 122,S

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$0a0d
	STD 120,S

	LDD #$1aed
	STD 80,S

	PULS A,X
	PSHU A,X,S

	LDA #$fb
	LDX #$a0a9
	PSHS A,X

	LEAS 281,S

	LDA 1,S
	PSHU A

	LDA -79,S
	PSHU A

	LDD -121,S
	PSHU D

	ANDA #$F0
	ORA #$09
	LDB #$00
	STD -121,S

	LDA -39,S
	PSHU A

	LDA 41,S
	PSHU A

	ANDA #$F0
	ORA #$0a
	STA 41,S

	LDA 121,S
	PSHU A

	LDA -119,S
	PSHU A,S

	LDA #$a1
	STA -39,S

	STA -119,S

	STA -79,S

	STA 1,S

	LDA 81,S
	PSHU A

	ANDA #$F0
	ORA #$0a
	STA 81,S

	LDA #$f1
	STA 121,S

	LEAS 201,S

	LDD 39,S
	PSHU D,S

	ANDA #$F0
	ORA #$01
	LDB #$00
	STD 39,S

	LDA -40,S
	PSHU A

	LDA ,S
	PSHU A

	LDA #$11
	STA ,S

	STA -40,S


	LDS $9F00+2
	STS ERASE_POS_HRL8_2+2
	LDU #ERASE_DATA_HRL8_END

	LEAS 562,S

	LDD -1,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$ac
	STD -1,S

	LDD 79,S
	PSHU D

	LDA 1,S
	PSHU A

	LDD -40,S
	PSHU D,S

	LDD 39,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$cc
	STD 39,S

	LDA #$dd
	STA 1,S

	LDA 41,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 41,S

	LDA -80,S
	PSHU A

	LDA #$aa
	STA -80,S

	STD -40,S

	LDB #$dc
	STD 79,S

	LEAS 239,S

	LDD -40,S
	PSHU D

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -38,S

	LDD -80,S
	PSHU D

	LDD -120,S
	PSHU D

	LDD #$addc
	STD -40,S

	LDA #$aa
	STD -120,S

	STD -80,S

	PULS A,X
	PSHU A,X,S

	LDA #$ab
	LDX #$accc
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$cb
	LDX #$bcdc
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$0b
	LDX #$acdd
	PSHS A,X

	LEAS 40,S

	LDD 80,S
	PSHU D

	LDA 122,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA 122,S

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 42,S

	LDD 40,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$9bac
	STD 40,S

	LDB #$cc
	STD 80,S

	LDA #$2b
	STD 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$ab
	LDX #$acdd
	PSHS A,X

	LEAS 160,S

	PULS A,X
	PSHU A,X,S

	LDA #$22
	LDX #$3ccc
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$22
	LDX #$3ddd
	PSHS A,X

	LEAS 40,S

	LDD 80,S
	PSHU D

	ANDA #$0F
	ORA #$f0
	LDB #$01
	STD 80,S

	LDA 42,S
	PSHU A

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$03
	LDB #$d0
	STD 40,S

	LDA #$ab
	STA 42,S

	LDD 82,S
	PSHU D

	LDA #$bb
	ANDB #$0F
	ORB #$a0
	STD 82,S

	PULS A,X
	PSHU A,X,S

	LDA #$12
	LDX #$dd3b
	PSHS A,X

	LEAS 120,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$ff
	LDX #$ecab
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$f2
	LDX #$1bda
	PSHS A,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$01
	LDB #$fe
	STD 40,S

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$0e
	LDB #$f1
	STD 80,S

	LDA 42,S
	PSHU A

	LDA #$dc
	STA 42,S

	LDA 82,S
	PSHU A

	LDA #$dd
	STA 82,S

	LDD 121,S
	PSHU D

	LDA #$11
	ANDB #$0F
	ORB #$c0
	STD 121,S

	LDA 123,S
	PSHU A

	LDA #$00
	STA 123,S

	PULS A,X
	PSHU A,X,S

	LDA #$1f
	LDX #$fad9
	PSHS A,X

	LEAS 161,S

	LDA 82,S
	PSHU A

	LDA 42,S
	PSHU A

	LDD 40,S
	PSHU D

	LDA #$ee
	ANDB #$F0
	ORB #$0d
	STD 40,S

	STA 42,S

	STA 82,S

	LDA 80,S
	PSHU A

	ANDA #$F0
	ORA #$00
	STA 80,S

	LDA 122,S
	PSHU A

	LDA #$1e
	STA 122,S

	PULS A,X
	PSHU A,X,S

	LDA #$ee
	LDX #$ddee
	PSHS A,X

	LEAS 262,S

	LDA -20,S
	PSHU A

	LDA -60,S
	PSHU A

	LDA #$a0
	STA -20,S

	STA -60,S

	LDD 59,S
	PSHU D

	LDA #$f1
	ANDB #$0F
	ORB #$00
	STD 59,S

	LDA -100,S
	PSHU A

	LDA 20,S
	PSHU A,S

	ANDA #$0F
	ORA #$90
	STA 20,S

	LDA #$1e
	STA -100,S

	LDA 99,S
	PSHU A

	LDA #$e0
	STA 99,S

SSAV_HRL8
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HRL8
	PSHS U,DP
	STS ERASE_SSAV_HRL8+2

ERASE_POS_HRL8_1
	LDS #$0000
	LDU #ERASE_DATA_HRL8_1

ERASE_CODE_HRL8_1
	PULU A,B,X,S
	STA ,S
	STB -40,S
	STX 39,S

	PULU A,B,S
	STA 81,S
	STB -119,S

	PULU A,B
	STA 121,S
	STB 41,S

	PULU A,X
	STA -39,S
	STX -121,S

	PULU A,B
	STA -79,S
	STB 1,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 120,S
	STX 80,S

	PULU A,X
	STA 122,S
	STX 40,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA 42,S
	STB 122,S
	STX -121,S
	STY 81,S

	PULU D,X
	STD 40,S
	STX -40,S

	PULU A,B,X,Y
	STA -119,S
	STB -38,S
	STX 120,S
	STY -80,S

	PULU D,S
	STD -1,S

	PULU A
	STA 1,S

	PULU D,X,S
	STD ,S
	STX 118,S

	PULU A,B,X,Y
	STA 120,S
	STB -80,S
	STX -42,S
	STY 79,S

	PULU D,X,Y
	STD -82,S
	STX -40,S
	STY 38,S

	PULU D,X,Y
	STD -121,S
	STX -2,S
	STY 40,S

	PULU D,X,S
	STD -41,S
	STX -1,S

	PULU A,B,X,Y
	STA -39,S
	STB -120,S
	STX 119,S
	STY -81,S

	PULU D,X
	STD 79,S
	STX 39,S

ERASE_POS_HRL8_2
	LDS #$0000
	LDU #ERASE_DATA_HRL8_2

ERASE_CODE_HRL8_2
	PULU A,B,S
	STA 99,S
	STB 20,S

	PULU A,X
	STA -100,S
	STX 59,S

	PULU A,B
	STA -60,S
	STB -20,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X
	STA 122,S
	STB 80,S
	STX 40,S

	PULU A,B
	STA 42,S
	STB 82,S

	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA 123,S
	STX 121,S

	PULU A,B,X,Y
	STA 82,S
	STB 42,S
	STX 80,S
	STY 40,S

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
	STD 82,S
	STX 40,S

	PULU A,X
	STA 42,S
	STX 80,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 120,S
	STX 40,S

	PULU A,B,X
	STA 42,S
	STB 122,S
	STX 80,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -120,S
	STX -80,S

	PULU A,X
	STA -38,S
	STX -40,S

	PULU A,B,X,Y,S
	STA -80,S
	STB 41,S
	STX 39,S
	STY -40,S

	PULU A,X,Y
	STA 1,S
	STX 79,S
	STY -1,S

ERASE_SSAV_HRL8
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HRL8_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRL8_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HRL8_END
