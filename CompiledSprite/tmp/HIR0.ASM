(main)IMG.ASM
	ORG $C3B9
DRAW_HIR0
	PSHS U,DP
	STS SSAV_HIR0+2

	LDS $9F00
	STS ERASE_POS_HIR0_1+2
	LDU #ERASE_DATA_HIR0_2
	LEAS 482,S
	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -41,S

	LDA -39,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -39,S

	LDA -120,S
	PSHU A

	LDA -80,S
	PSHU A

	LDD ,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D,S

	LDD #$ddac
	STD ,S

	LDB #$aa
	STD 40,S

	STD 80,S

	LDA #$cc
	STA -120,S

	STA -80,S

	LDA #$cd
	STD 120,S

	LEAS 160,S
	LDD ,S
	PSHU D,S

	LDD #$dcca
	STD ,S

	LEAS 159,S
	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dc
	STD -80,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD -40,S

	LDA 123,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 123,S

	LDD -119,S
	PSHU D

	LDA -78,S
	PSHU A

	LDA -38,S
	PSHU A

	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDA #$ba
	STA -78,S

	LDD #$ddab
	STD 121,S

	LDD #$dcbc
	STD -119,S

	LDB #$bb
	STD 41,S

	STD 81,S

	STB -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$dcbb
	PSHS A,X

	LEAS 281,S
	LDA -118,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA -118,S

	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dd
	STD -1,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$32
	STD 80,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDA 1,S
	PSHU A

	LDD 40,S
	PSHU D

	LDD 120,S
	PSHU D,S

	LDA #$33
	STA 1,S

	LDD #$dd2b
	STD -120,S

	LDB #$0e
	STD 40,S

	LDB #$22
	STD -80,S

	LDA #$d0
	STD -40,S

	LDA #$c2
	STD 120,S

	LEAS 280,S
	LDD 80,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$0a0d
	STD 80,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$090d
	STD 120,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD ,S
	PSHU D

	LDD 40,S
	PSHU D,S

	LDD #$3b13
	STD -40,S

	LDD #$eadd
	STD ,S

	LDD #$d9d0
	STD 40,S

	LDD #$2d22
	STD -80,S

	LDA #$23
	STD -120,S

	LEAS 241,S
	LDA -80,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA -80,S

	LDA -40,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA -40,S

	LDA ,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA ,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$9a
	STD 39,S

	LDD 79,S
	PSHU D,S
	ANDA #$F0
	ORA #$09
	LDB #$09
	STD 79,S

	LEAS 239,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$aa
	STD -120,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$b0
	STD -80,S

	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA -38,S

	LDD -40,S
	PSHU D

	LDD #$e1f2
	STD -40,S

	PULS A,X
	PSHU A,X,S
	LDA #$e1
	LDX #$ffe1
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$e0
	LDX #$ee00
	PSHS A,X


	LDS $9F00+2
	STS ERASE_POS_HIR0_2+2
	LDU #ERASE_DATA_HIR0_END

	LEAS 442,S
	LDA -80,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -80,S

	LDA 1,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA 1,S

	LDA 41,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA 41,S

	LDD -41,S
	PSHU D

	LDD -1,S
	PSHU D

	LDD 39,S
	PSHU D

	LDD 80,S
	PSHU D,S

	LDD #$ccac
	STD -41,S

	LDD #$2dcd
	STD 80,S

	LDD #$dd3a
	STD 39,S

	LDB #$da
	STD -1,S

	LEAS 239,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$aa
	STD -40,S

	LDD -119,S
	PSHU D

	LDD -79,S
	PSHU D

	LDA -38,S
	PSHU A

	LDD #$21ad
	STD -119,S

	LDA #$ac
	STA -38,S

	LDD #$2aac
	STD -79,S

	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$aaaa
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$aaaa
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$aacc
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ca
	STD 40,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$c2
	STD 120,S

	LDA 42,S
	PSHU A

	LDD 81,S
	PSHU D

	LDA 122,S
	PSHU A

	LDA #$ba
	STA 122,S

	LDD #$cc00
	STD 81,S

	STB 42,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$aa0c
	PSHS A,X

	LEAS 160,S
	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$3220
	PSHS A,X

	LEAS 40,S
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$30
	STA 42,S

	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 82,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDA 121,S
	PSHU A

	LDA #$0d
	STA 121,S

	LDD #$ddd1
	STD 80,S

	LDB #$d2
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$3221
	PSHS A,X

	LEAS 282,S
	LDD -121,S
	PSHU D
	LDA #$21
	ANDB #$0F
	ORB #$10
	STD -121,S

	LDD -81,S
	PSHU D
	LDA #$1d
	ANDB #$0F
	ORB #$30
	STD -81,S

	LDD -41,S
	PSHU D
	LDA #$0d
	ANDB #$0F
	ORB #$20
	STD -41,S

	LDD -1,S
	PSHU D
	LDA #$ad
	ANDB #$0F
	ORB #$30
	STD -1,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$bb
	STD 38,S

	LDA 40,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 40,S

	LDD 78,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$bb
	STD 78,S

	LDD 118,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ba
	STD 118,S

	LDA 80,S
	PSHU A

	LDA 120,S
	PSHU A,S

	LDA #$9a
	STA 80,S

	STA 120,S

	LEAS 279,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$aa
	STD -121,S

	LDD -80,S
	PSHU D
	LDA #$ad
	ANDB #$0F
	ORB #$90
	STD -80,S

	LDD -40,S
	PSHU D
	LDA #$9d
	ANDB #$0F
	ORB #$90
	STD -40,S

	LDA ,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA ,S

	LDA 40,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 40,S

	LDD 80,S
	PSHU D
	LDA #$bb
	ANDB #$0F
	ORB #$a0
	STD 80,S

	LDD 120,S
	PSHU D
	LDA #$aa
	ANDB #$0F
	ORB #$a0
	STD 120,S

	LDA -119,S
	PSHU A,S

	LDA #$a9
	STA -119,S

	LEAS 240,S
	LDD -80,S
	PSHU D
	LDA #$a1
	ANDB #$0F
	ORB #$10
	STD -80,S

	LDD -40,S
	PSHU D

	LDD ,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D,S

	LDD #$1a9a
	STD -40,S

	LDD #$aa0e
	STD ,S

	LDD #$aff1
	STD 40,S

	LDD #$0eee
	STD 80,S

SSAV_HIR0
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HIR0
	PSHS U,DP
	STS ERASE_SSAV_HIR0+2

ERASE_POS_HIR0_1
	LDS #$0000
	LDU #ERASE_DATA_HIR0_1

ERASE_CODE_HIR0_1
	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X

	PULU D
	STD -40,S

	PULU A,X,Y
	STA -38,S
	STX -80,S
	STY -120,S

	PULU D,S
	STD 79,S

	PULU D
	STD 39,S

	PULU A,B
	STA ,S
	STB -40,S

	PULU A
	STA -80,S

	PULU D,S
	STD 40,S

	PULU D,X,Y
	STD ,S
	STX -40,S
	STY -80,S

	PULU D,X,Y
	STD -120,S
	STX 120,S
	STY 80,S

	PULU D,S
	STD 120,S

	PULU D
	STD 40,S

	PULU A,X,Y
	STA 1,S
	STX -40,S
	STY -80,S

	PULU D,X,Y
	STD -120,S
	STX 80,S
	STY -1,S

	PULU A
	STA -118,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 121,S
	STX 81,S
	STY 41,S

	PULU A,B,X
	STA -38,S
	STB -78,S
	STX -119,S

	PULU A,X,Y
	STA 123,S
	STX -40,S
	STY -80,S

	PULU D,S
	STD ,S



	PULU D,S
	STD 120,S

	PULU D,X,Y
	STD 80,S
	STX 40,S
	STY ,S

	PULU A,B
	STA -80,S
	STB -120,S

	PULU A,X
	STA -39,S
	STX -41,S

ERASE_POS_HIR0_2
	LDS #$0000
	LDU #ERASE_DATA_HIR0_2

ERASE_CODE_HIR0_2
	PULU D,S
	STD 80,S

	PULU D,X,Y
	STD 40,S
	STX ,S
	STY -40,S

	PULU D
	STD -80,S

	PULU A,S
	STA -119,S

	PULU D,X
	STD 120,S
	STX 80,S

	PULU A,B,X,Y
	STA 40,S
	STB ,S
	STX -40,S
	STY -80,S

	PULU D
	STD -121,S

	PULU A,S
	STA 120,S

	PULU A,X,Y
	STA 80,S
	STX 118,S
	STY 78,S

	PULU A,X,Y
	STA 40,S
	STX 38,S
	STY -1,S

	PULU D,X,Y
	STD -41,S
	STX -81,S
	STY -121,S

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA 121,S
	STX 80,S
	STY 40,S

	PULU A,B
	STA 82,S
	STB 42,S

	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA 122,S
	STX 81,S

	PULU A,X,Y
	STA 42,S
	STX 120,S
	STY 40,S

	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA -38,S
	STX -79,S
	STY -119,S

	PULU D
	STD -40,S

	PULU D,S
	STD 80,S

	PULU D,X,Y
	STD 39,S
	STX -1,S
	STY -41,S

	PULU A,B
	STA 41,S
	STB 1,S

	PULU A
	STA -80,S

ERASE_SSAV_HIR0
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HIR0_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HIR0_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HIR0_END
