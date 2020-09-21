(main)IMG.ASM
	ORG $B505
DRAW_HRL6
	PSHS U,DP
	STS SSAV_HRL6+2

	LDS $9F00
	STS ERASE_POS_HRL6_1+2
	LDU #ERASE_DATA_HRL6_2
	LEAS 563,S
	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ac
	STD -81,S

	LDA -39,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -39,S

	LDD 79,S
	PSHU D
	LDA #$32
	ANDB #$0F
	ORB #$d0
	STD 79,S

	LDA -120,S
	PSHU A

	LDD -41,S
	PSHU D

	LDD -1,S
	PSHU D,S

	LDD 39,S
	PSHU D

	LDD 119,S
	PSHU D

	LDA #$aa
	STA -120,S

	LDD #$d2dd
	STD -1,S

	LDA #$32
	STD 39,S

	LDD #$ddcc
	STD -41,S

	LDA #$a2
	STD 119,S

	LEAS 280,S
	LDD -82,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ca
	STD -82,S

	LDD -42,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ca
	STD -42,S

	LDD -40,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$c0
	STD -40,S

	LDD -2,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$aa
	STD -2,S

	LDD ,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$d0
	STD ,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$aa
	STD 38,S

	LDD 118,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ac
	STD 118,S

	LDD -121,S
	PSHU D

	LDA -80,S
	PSHU A

	LDD 40,S
	PSHU D,S

	LDD 79,S
	PSHU D

	LDA 120,S
	PSHU A

	LDD #$cddd
	STD 40,S

	LDD #$aacc
	STD -121,S

	STB -80,S

	LDB #$cd
	STD 79,S

	STB 120,S

	LEAS 219,S
	LDD -61,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$c2
	STD -61,S

	LDD -21,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$b2
	STD -21,S

	LDA -59,S
	PSHU A

	LDA -19,S
	PSHU A

	LDD 20,S
	PSHU D,S

	LDD 60,S
	PSHU D

	LDA #$cc
	STA -59,S

	LDD #$22dd
	STD 20,S

	STB -19,S

	LDB #$0d
	STD 60,S

	LEAS 220,S
	LDA -118,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -118,S

	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA -78,S

	LDD -40,S
	PSHU D
	ANDA #$0F
	ORA #$b0
	LDB #$3d
	STD -40,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDA -38,S
	PSHU A

	LDD #$31d0
	STD -120,S

	LDD #$ad3d
	STD -80,S

	LDA #$fe
	STA -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$bb
	LDX #$1d11
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ba
	LDX #$df11
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$ff1e
	PSHS A,X

	LEAS 40,S
	LDA 81,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 81,S

	LDD 41,S
	PSHU D

	LDD #$1eee
	STD 41,S

	PULS A,X
	PSHU A,X,S
	LDA #$9e
	LDX #$2f00
	PSHS A,X

	LEAS 380,S
	LDD -20,S
	PSHU D
	LDA #$1a
	ANDB #$0F
	ORB #$00
	STD -20,S

	LDD 20,S
	PSHU D
	LDA #$1a
	ANDB #$0F
	ORB #$e0
	STD 20,S

	LDD 60,S
	PSHU D,S
	LDA #$01
	ANDB #$0F
	ORB #$e0
	STD 60,S

	LDD 100,S
	PSHU D
	LDA #$e0
	ANDB #$0F
	ORB #$00
	STD 100,S

	LDA -100,S
	PSHU A

	LDA -60,S
	PSHU A

	LDA #$a9
	STA -100,S

	LDA #$1a
	STA -60,S


	LDS $9F00+2
	STS ERASE_POS_HRL6_2+2
	LDU #ERASE_DATA_HRL6_END

	LEAS 522,S
	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ac
	STD -1,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$cc
	STD 39,S

	LDA 41,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 41,S

	LDA -80,S
	PSHU A

	LDD -40,S
	PSHU D

	LDA 1,S
	PSHU A

	LDD 79,S
	PSHU D,S

	LDA #$dd
	STA 1,S

	LDD #$aacc
	STD -40,S

	STA -80,S

	LDB #$dc
	STD 79,S

	LEAS 239,S
	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -38,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
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
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 42,S

	LDA 122,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 122,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$2bcc
	STD 120,S

	LDA #$9b
	STD 80,S

	LDB #$ac
	STD 40,S

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
	PULS A,X
	PSHU A,X,S
	LDA #$12
	LDX #$dddd
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ab
	LDX #$d0da
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ba
	LDX #$01aa
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ba
	LDX #$e19f
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$bb
	LDX #$13bf
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$bb
	LDX #$12ba
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$bb
	LDX #$231a
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 3,S

	LDA 121,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 121,S

	LDD 41,S
	PSHU D

	LDA 81,S
	PSHU A

	LDD #$dfee
	STD 41,S

	LDA #$d1
	STA 81,S

	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$3109
	PSHS A,X

	LEAS 280,S
	LDD -120,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$f000
	STD -120,S

	LDD -80,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$10d0
	STD -80,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$9e
	STD 120,S

	LDD -40,S
	PSHU D

	LDD ,S
	PSHU D,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$efaa
	STD -40,S

	LDD #$eeee
	STD 80,S

	LDD #$0199
	STD 40,S

	LDB #$a9
	STD ,S

	LEAS 181,S
	LDD -21,S
	PSHU D,S
	ANDA #$F0
	ORA #$0e
	LDB #$9e
	STD -21,S

	LDA 20,S
	PSHU A

	LDA #$00
	STA 20,S

SSAV_HRL6
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HRL6
	PSHS U,DP
	STS ERASE_SSAV_HRL6+2

ERASE_POS_HRL6_1
	LDS #$0000
	LDU #ERASE_DATA_HRL6_1

ERASE_CODE_HRL6_1
	PULU A,B,X,Y,S
	STA -60,S
	STB -100,S
	STX 100,S
	STY 60,S

	PULU D,X
	STD 20,S
	STX -20,S

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 41,S

	PULU A
	STA 81,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA -38,S
	STX -80,S
	STY -120,S

	PULU D
	STD -40,S

	PULU A,B
	STA -78,S
	STB -118,S

	PULU D,X,S
	STD 60,S
	STX 20,S

	PULU A,B,X,Y
	STA -19,S
	STB -59,S
	STX -21,S
	STY -61,S

	PULU A,X,Y,S
	STA 120,S
	STX 79,S
	STY 40,S

	PULU A,X,Y
	STA -80,S
	STX -121,S
	STY 118,S

	PULU D,X,Y
	STD 38,S
	STX ,S
	STY -2,S

	PULU D,X,Y
	STD -40,S
	STX -42,S
	STY -82,S

	PULU D,X,Y,S
	STD 119,S
	STX 39,S
	STY -1,S

	PULU D
	STD -41,S

	PULU A,X
	STA -120,S
	STX 79,S

	PULU A,X
	STA -39,S
	STX -81,S

ERASE_POS_HRL6_2
	LDS #$0000
	LDU #ERASE_DATA_HRL6_2

ERASE_CODE_HRL6_2
	PULU A,X,S
	STA 20,S
	STX -21,S

	PULU D,X,Y,S
	STD 80,S
	STX 40,S
	STY ,S

	PULU D,X,Y
	STD -40,S
	STX 120,S
	STY -80,S

	PULU D
	STD -120,S

	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA 81,S
	STX 41,S

	PULU A,B
	STA 121,S
	STB 3,S

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

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 120,S
	STX 80,S
	STY 40,S

	PULU A,B
	STA 122,S
	STB 42,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD -40,S
	STX -80,S
	STY -120,S

	PULU A
	STA -38,S

	PULU D,S
	STD 79,S

	PULU A,X
	STA 1,S
	STX -40,S

	PULU A,B,X,Y
	STA -80,S
	STB 41,S
	STX 39,S
	STY -1,S

ERASE_SSAV_HRL6
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HRL6_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HRL6_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HRL6_END
