(main)IMG.ASM
	ORG $B83E
DRAW_HRL0
	PSHS U,DP
	STS SSAV_HRL0+2

	LDS $9F00
	STS ERASE_POS_HRL0_1+2
	LDU #ERASE_DATA_HRL0_2
	LEAS 563,S
	LDA -120,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -120,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -81,S

	LDD 79,S
	PSHU D
	LDA #$ac
	ANDB #$0F
	ORB #$c0
	STD 79,S

	LDD -41,S
	PSHU D

	LDD -1,S
	PSHU D,S

	LDD 39,S
	PSHU D

	LDD 119,S
	PSHU D

	LDD #$cacc
	STD -41,S

	LDA #$aa
	STD 119,S

	LDB #$cd
	STD -1,S

	LDB #$dd
	STD 39,S

	LEAS 260,S
	LDD -62,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$bc
	STD -62,S

	LDD -22,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ba
	STD -22,S

	LDD 18,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$ba
	STD 18,S

	LDD 58,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$ba
	STD 58,S

	LDD 60,S
	PSHU D
	LDA #$c0
	ANDB #$0F
	ORB #$c0
	STD 60,S

	LDD 98,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$ba
	STD 98,S

	LDD 100,S
	PSHU D
	LDA #$d0
	ANDB #$0F
	ORB #$d0
	STD 100,S

	LDD -101,S
	PSHU D

	LDA -60,S
	PSHU A

	LDA -20,S
	PSHU A,S

	LDA 20,S
	PSHU A

	LDD #$dacc
	STD -101,S

	LDA #$cd
	STA -60,S

	STA -20,S

	STA 20,S

	LEAS 259,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$bc
	STD -121,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$bb
	STD -81,S

	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$b2
	STD -41,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 3,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$22
	STD 39,S

	LDD 41,S
	PSHU D
	LDA #$d3
	ANDB #$F0
	ORB #$0a
	STD 41,S

	LDA 43,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA 43,S

	LDA -119,S
	PSHU A

	LDA -79,S
	PSHU A

	LDD -39,S
	PSHU D

	LDA #$dc
	STA -79,S

	LDD #$dd2a
	STD -39,S

	STA -119,S

	PULS A,X
	PSHU A,X,S
	LDA #$22
	LDX #$0d1b
	PSHS A,X

	LEAS 79,S
	LDD 3,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$c0a0
	STD 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$33de
	PSHS A,X

	LEAS 40,S
	LDD 3,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$c0a0
	STD 3,S

	LDA 44,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 44,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$33
	STD 80,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$11
	STD 120,S

	LDA 40,S
	PSHU A

	LDD 42,S
	PSHU D

	LDD 82,S
	PSHU D

	LDD 122,S
	PSHU D

	LDA #$90
	STA 40,S

	LDD #$23ee
	STD 82,S

	LDB #$00
	STD 42,S

	LDB #$0e
	STD 122,S

	PULS A,X
	PSHU A,X,S
	LDA #$a9
	LDX #$1110
	PSHS A,X

	LEAS 281,S
	LDA -121,S
	PSHU A
	ANDA #$F0
	ORA #$01
	STA -121,S

	LDA -81,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -81,S

	LDA -41,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -41,S

	LDA -1,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -1,S

	LDD 41,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$d00a
	STD 41,S

	LDA 80,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA 80,S

	LDD -119,S
	PSHU D

	LDD -79,S
	PSHU D

	LDD -39,S
	PSHU D,S

	LDD 1,S
	PSHU D

	LDA 120,S
	PSHU A

	LDD #$2c9e
	STD -119,S

	LDD #$1c0e
	STD -79,S

	LDD #$adca
	STD -39,S

	LDD #$d0da
	STD 1,S

	LDA #$bb
	STA 120,S

	LEAS 260,S
	LDA -100,S
	PSHU A

	LDA -60,S
	PSHU A

	LDA -20,S
	PSHU A

	LDA 20,S
	PSHU A

	LDA 60,S
	PSHU A,S

	LDA 100,S
	PSHU A

	LDA #$ae
	STA -100,S

	LDA #$01
	STA 20,S

	LDA #$ee
	STA 60,S

	LDA #$00
	STA 100,S

	LDA #$a1
	STA -60,S

	STA -20,S


	LDS $9F00+2
	STS ERASE_POS_HRL0_2+2
	LDU #ERASE_DATA_HRL0_END

	LEAS 561,S
	LDA -119,S
	PSHU A
	ANDA #$F0
	ORA #$0c
	STA -119,S

	LDD -79,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$c0
	STD -79,S

	LDD -39,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$addc
	STD -39,S

	LDD #$da32
	STD 40,S

	LDD #$ca22
	STD 80,S

	LDD #$aaa2
	STD 120,S

	PULS A,X
	PSHU A,X,S
	LDA #$dc
	LDX #$dddd
	PSHS A,X

	LEAS 240,S
	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -78,S

	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -38,S

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD #$aabc
	STD -40,S

	LDB #$ad
	STD -80,S

	PULS A,X
	PSHU A,X,S
	LDA #$ac
	LDX #$aadc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$a0
	LDX #$acdc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ca
	LDX #$acdd
	PSHS A,X

	LEAS 40,S
	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 82,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$b9cc
	STD 40,S

	LDD #$ab2c
	STD 80,S

	PULS A,X
	PSHU A,X,S
	LDA #$a9
	LDX #$ccdd
	PSHS A,X

	LEAS 120,S
	PULS D,X
	PSHU D,X,S
	LDD #$022d
	LDX #$c2aa
	PSHS D,X

	LEAS 40,S
	PULS D,X
	PSHU D,X,S
	LDD #$322d
	LDX #$23bb
	PSHS D,X

	LEAS 40,S
	PULS D,X
	PSHU D,X,S
	LDD #$123d
	LDX #$1dbb
	PSHS D,X

	LEAS 40,S
	LDD 42,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$a9
	STD 42,S

	LDD 82,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$d00a
	STD 82,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$000e
	STD 40,S

	LDD #$99e3
	STD 80,S

	PULS D,X
	PSHU D,X,S
	LDD #$91d0
	LDX #$ddab
	PSHS D,X

	LEAS 120,S
	LDA 3,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA 3,S

	LDD 40,S
	PSHU D
	LDA #$ae
	ANDB #$F0
	ORB #$02
	STD 40,S

	LDD 42,S
	PSHU D
	LDA #$dd
	ANDB #$0F
	ORB #$00
	STD 42,S

	LDD 80,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$f002
	STD 80,S

	LDD 82,S
	PSHU D
	LDA #$dd
	ANDB #$0F
	ORB #$90
	STD 82,S

	LDD 120,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$f001
	STD 120,S

	LDD 122,S
	PSHU D
	LDA #$dd
	ANDB #$0F
	ORB #$a0
	STD 122,S

	PULS A,X
	PSHU A,X,S
	LDA #$09
	LDX #$e2de
	PSHS A,X

	LEAS 282,S
	LDD -122,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$200d
	STD -122,S

	LDD -80,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$1e
	STD -80,S

	LDD -42,S
	PSHU D
	LDA #$ff
	ANDB #$F0
	ORB #$0a
	STD -42,S

	LDD 118,S
	PSHU D
	LDA #$0a
	ANDB #$0F
	ORB #$a0
	STD 118,S

	LDA 121,S
	PSHU A
	ANDA #$F0
	ORA #$01
	STA 121,S

	LDD -120,S
	PSHU D

	LDA -82,S
	PSHU A

	LDA -39,S
	PSHU A

	LDD -2,S
	PSHU D

	LDA 1,S
	PSHU A

	LDD 38,S
	PSHU D

	LDA 41,S
	PSHU A

	LDD 78,S
	PSHU D,S

	LDA 81,S
	PSHU A

	LDD #$00a0
	STD -120,S

	LDA #$ff
	STA -82,S

	LDD #$1fbc
	STD -2,S

	LDA #$f1
	STA 41,S

	STA 81,S

	LDA #$11
	STA -39,S

	STA 1,S

	LDD #$efaa
	STD 38,S

	LDB #$a9
	STD 78,S

	LEAS 198,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0e00
	STD -40,S

	LDA -37,S
	PSHU A
	ANDA #$F0
	ORA #$01
	STA -37,S

	LDD ,S
	PSHU D,S
	ANDA #$F0
	ANDB #$0F
	ADDD #$0e00
	STD ,S

	LDA 3,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA 3,S

	LDA 40,S
	PSHU A
	ANDA #$F0
	ORA #$00
	STA 40,S

SSAV_HRL0
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HRL0
	PSHS U,DP
	STS ERASE_SSAV_HRL0+2

ERASE_POS_HRL0_1
	LDS #$0000
	LDU #ERASE_DATA_HRL0_1

ERASE_CODE_HRL0_1
	PULU A,B,S
	STA 100,S
	STB 60,S

	PULU A,B
	STA 20,S
	STB -20,S

	PULU A,B
	STA -60,S
	STB -100,S

	PULU A,X,Y,S
	STA 120,S
	STX 1,S
	STY -39,S

	PULU D,X
	STD -79,S
	STX -119,S

	PULU A,X
	STA 80,S
	STX 41,S

	PULU A,B
	STA -1,S
	STB -41,S

	PULU A,B
	STA -81,S
	STB -121,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 122,S
	STX 82,S
	STY 42,S

	PULU A,X,Y
	STA 40,S
	STX 120,S
	STY 80,S

	PULU A,X
	STA 44,S
	STX 3,S

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 3,S

	PULU B,X,S
	PSHS B,X

	PULU D
	STD -39,S

	PULU A,B
	STA -79,S
	STB -119,S

	PULU A,X,Y
	STA 43,S
	STX 41,S
	STY 39,S

	PULU A,X,Y
	STA 3,S
	STX -41,S
	STY -81,S

	PULU D
	STD -121,S

	PULU A,B,S
	STA 20,S
	STB -20,S

	PULU A,X,Y
	STA -60,S
	STX -101,S
	STY 100,S

	PULU D,X,Y
	STD 98,S
	STX 60,S
	STY 58,S

	PULU D,X,Y
	STD 18,S
	STX -22,S
	STY -62,S

	PULU D,X,Y,S
	STD 119,S
	STX 39,S
	STY -1,S

	PULU D,X,Y
	STD -41,S
	STX 79,S
	STY -81,S

	PULU A
	STA -120,S

ERASE_POS_HRL0_2
	LDS #$0000
	LDU #ERASE_DATA_HRL0_2

ERASE_CODE_HRL0_2
	PULU A,B,X,S
	STA 40,S
	STB 3,S
	STX ,S

	PULU A,X
	STA -37,S
	STX -40,S

	PULU A,X,S
	STA 81,S
	STX 78,S

	PULU A,X
	STA 41,S
	STX 38,S

	PULU A,X
	STA 1,S
	STX -2,S

	PULU A,B,X
	STA -39,S
	STB -82,S
	STX -120,S

	PULU A,X,Y
	STA 121,S
	STX 118,S
	STY -42,S

	PULU D,X
	STD -80,S
	STX -122,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 122,S
	STX 120,S
	STY 82,S

	PULU D,X,Y
	STD 80,S
	STX 42,S
	STY 40,S

	PULU A
	STA 3,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 80,S
	STX 40,S
	STY 82,S

	PULU D
	STD 42,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 80,S
	STX 40,S

	PULU A
	STA 82,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -40,S
	STX -80,S

	PULU A,B
	STA -38,S
	STB -78,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 120,S
	STX 80,S
	STY 40,S

	PULU D,X
	STD -39,S
	STX -79,S

	PULU A
	STA -119,S

ERASE_SSAV_HRL0
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HRL0_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRL0_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HRL0_END
