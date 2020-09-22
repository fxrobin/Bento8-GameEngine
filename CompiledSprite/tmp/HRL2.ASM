(main)IMG.ASM
	ORG $C9F1
DRAW_HRL2
	PSHS U,DP
	STS SSAV_HRL2+2

	LDS $9F00
	STS ERASE_POS_HRL2_1+2
	LDU #ERASE_DATA_HRL2_2
	LEAS 603,S

	LDD -1,S
	PSHU D

	LDA -120,S
	PSHU A

	LDD -41,S
	PSHU D

	LDD 119,S
	PSHU D

	LDD -81,S
	PSHU D,S

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

	LDD 39,S
	PSHU D

	LDD #$aadd
	STD 39,S

	LDB #$cd
	STD -1,S

	LDD #$cacc
	STD -41,S

	STB -120,S

	LDA #$aa
	STD 119,S

	LEAS 280,S

	LDD -121,S
	PSHU D

	LDD -42,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$ba
	STD -42,S

	LDD 38,S
	PSHU D

	ANDA #$F0
	ORA #$09
	LDB #$ba
	STD 38,S

	LDD 118,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$bc
	STD 118,S

	LDA 80,S
	PSHU A

	LDA 40,S
	PSHU A

	LDD ,S
	PSHU D

	LDA #$cd
	ANDB #$0F
	ORB #$d0
	STD ,S

	LDA #$d0
	STA 80,S

	LDD -2,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$ba
	STD -2,S

	LDA 120,S
	PSHU A

	LDA -80,S
	PSHU A

	LDA #$c0
	STA 40,S

	LDD -40,S
	PSHU D,S

	LDA #$cd
	ANDB #$0F
	ORB #$c0
	STD -40,S

	STA -80,S

	LDD #$dacc
	STD -121,S

	LDD 78,S
	PSHU D

	ANDA #$F0
	ORA #$09
	LDB #$ba
	STD 78,S

	LDD -82,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$bc
	STD -82,S

	LDA #$dd
	STA 120,S

	LEAS 279,S

	LDD ,S
	PSHU D

	LDA 2,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 2,S

	LDD -121,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$bb
	STD -121,S

	LDD 80,S
	PSHU D

	LDD #$1110
	STD 80,S

	LDD -40,S
	PSHU D

	LDD 121,S
	PSHU D

	LDA -119,S
	PSHU A

	LDA 82,S
	PSHU A

	ANDA #$0F
	ORA #$30
	STA 82,S

	LDD 40,S
	PSHU D,S

	LDD -81,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$b2
	STD -81,S

	LDD #$22dd
	STD ,S

	LDA -79,S
	PSHU A

	STB -79,S

	LDD #$33d1
	STD 40,S

	LDD #$220d
	STD -40,S

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -38,S

	LDA #$dc
	STA -119,S

	LDD #$23aa
	STD 121,S

	LEAS 161,S

	LDA 1,S
	PSHU A

	LDD -1,S
	PSHU D,S

	ANDA #$F0
	ORA #$0a
	LDB #$23
	STD -1,S

	LDA #$ab
	STA 1,S

	LEAS 159,S

	LDD 40,S
	PSHU D

	LDA #$1e
	ANDB #$F0
	ORB #$0d
	STD 40,S

	LDD 80,S
	PSHU D

	LDA #$10
	ANDB #$F0
	ORB #$0d
	STD 80,S

	LDA -118,S
	PSHU A

	LDA 42,S
	PSHU A

	ANDA #$F0
	ORA #$0a
	STA 42,S

	LDD -120,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$23
	STD -120,S

	LDA -78,S
	PSHU A

	LDA -38,S
	PSHU A

	LDD -80,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$2c
	STD -80,S

	LDA #$bb
	STA -38,S

	STA -118,S

	LDA #$ab
	STA -78,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$01
	LDB #$3c
	STD -40,S

	LDD 120,S
	PSHU D

	ANDA #$0F
	ANDB #$F0
	ADDD #$100c
	STD 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$fe
	LDX #$ddab
	PSHS A,X

	LEAS 281,S

	LDD 40,S
	PSHU D

	LDD 120,S
	PSHU D

	LDA -39,S
	PSHU A

	LDA -79,S
	PSHU A

	ANDA #$0F
	ORA #$90
	STA -79,S

	LDD 80,S
	PSHU D,S

	LDD ,S
	PSHU D

	ANDA #$F0
	ORA #$0b
	LDB #$11
	STD ,S

	LDA -119,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -119,S

	LDA -121,S
	PSHU A

	ANDA #$0F
	ORA #$e0
	STA -121,S

	LDA #$a0
	STA -39,S

	LDA #$ff
	STD 40,S

	LDA #$2f
	STD 80,S

	LDD #$ee00
	STD 120,S


	LDS $9F00+2
	STS ERASE_POS_HRL2_2+2
	LDU #ERASE_DATA_HRL2_END

	LEAS 562,S

	LDD -40,S
	PSHU D

	LDD -80,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0cc0
	STD -80,S

	LDD #$cccd
	STD -40,S

	LDD ,S
	PSHU D,S

	LDA #$ad
	ANDB #$0F
	ORB #$d0
	STD ,S

	LDD 39,S
	PSHU D

	LDD #$dcdd
	STD 39,S

	LDD 79,S
	PSHU D

	LDD #$da32
	STD 79,S

	LEAS 239,S

	LDD -120,S
	PSHU D

	LDD #$ca22
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

	LDD #$aaad
	STD -40,S

	LDB #$a2
	STD -80,S

	PULS A,X
	PSHU A,X,S

	LDA #$aa
	LDX #$bcdd
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$ac
	LDX #$aadd
	PSHS A,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 42,S

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$caac
	STD 40,S

	LDD #$a9cc
	STD 80,S

	LDA #$b9
	STD 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$a0
	LDX #$acdd
	PSHS A,X

	LEAS 200,S

	LDD -40,S
	PSHU D

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -38,S

	LDD #$ab2c
	STD -40,S

	PULS A,X
	PSHU A,X,S

	LDA #$02
	LDX #$2ddc
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$32
	LDX #$2ddd
	PSHS A,X

	LEAS 40,S

	LDD 81,S
	PSHU D

	LDA 42,S
	PSHU A

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$01
	LDB #$d0
	STD 40,S

	LDA #$22
	STA 42,S

	LDD #$0e13
	STD 81,S

	LDD 121,S
	PSHU D

	LDA #$93
	ANDB #$0F
	ORB #$d0
	STD 121,S

	PULS A,X
	PSHU A,X,S

	LDA #$12
	LDX #$3ddd
	PSHS A,X

	LEAS 282,S

	LDD -81,S
	PSHU D

	LDA -39,S
	PSHU A

	ANDA #$0F
	ORA #$b0
	STA -39,S

	LDA 39,S
	PSHU A

	LDA -119,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -119,S

	LDD -1,S
	PSHU D

	LDA 81,S
	PSHU A

	ANDA #$0F
	ORA #$90
	STA 81,S

	LDA -79,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -79,S

	LDD -41,S
	PSHU D

	LDA #$90
	STA 39,S

	LDA 41,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 41,S

	LDA 79,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA 79,S

	LDD -121,S
	PSHU D,S

	LDA 1,S
	PSHU A

	ANDA #$0F
	ORA #$b0
	STA 1,S

	LDD #$02dd
	STD -121,S

	LDA #$91
	STD -1,S

	LDA #$e2
	STD -81,S

	LDA #$a2
	STD -41,S

	LDA 120,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 120,S

	LEAS 281,S

	LDA -41,S
	PSHU A

	LDA -81,S
	PSHU A

	LDD 79,S
	PSHU D

	LDA #$aa
	ANDB #$0F
	ORB #$e0
	STD 79,S

	STA -41,S

	LDA -121,S
	PSHU A

	LDA 39,S
	PSHU A

	LDA #$d0
	STA -121,S

	LDD 118,S
	PSHU D,S

	LDA #$bb
	STA -81,S

	LDA -1,S
	PSHU A

	ANDA #$F0
	ORA #$0a
	STA -1,S

	LDD #$fffa
	STD 118,S

	LDA #$a1
	STA 39,S

	LDA 120,S
	PSHU A

	ANDA #$0F
	ORA #$10
	STA 120,S

	LEAS 159,S

	LDD -1,S
	PSHU D,S

	LDA 1,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA 1,S

	LDD #$11ee
	STD -1,S

SSAV_HRL2
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HRL2
	PSHS U,DP
	STS ERASE_SSAV_HRL2+2

ERASE_POS_HRL2_1
	LDS #$0000
	LDU #ERASE_DATA_HRL2_1

ERASE_CODE_HRL2_1
	PULU A,B,X,Y,S
	STA -121,S
	STB -119,S
	STX ,S
	STY 80,S

	PULU A,B,X,Y
	STA -79,S
	STB -39,S
	STX 120,S
	STY 40,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 120,S
	STX -40,S
	STY -80,S

	PULU A,B,X
	STA -38,S
	STB -78,S
	STX -120,S

	PULU A,B,X,Y
	STA 42,S
	STB -118,S
	STX 80,S
	STY 40,S

	PULU D,S
	STD -1,S

	PULU A
	STA 1,S

	PULU A,B,X,Y,S
	STA -38,S
	STB -79,S
	STX -81,S
	STY 40,S

	PULU A,B,X,Y
	STA 82,S
	STB -119,S
	STX 121,S
	STY -40,S

	PULU D,X
	STD 80,S
	STX -121,S

	PULU A,X
	STA 2,S
	STX ,S

	PULU D,X,Y,S
	STD -82,S
	STX 78,S
	STY -40,S

	PULU A,B,X,Y
	STA -80,S
	STB 120,S
	STX -2,S
	STY ,S

	PULU A,B,X,Y
	STA 40,S
	STB 80,S
	STX 118,S
	STY 38,S

	PULU D,X
	STD -42,S
	STX -121,S

	PULU D,X,Y,S
	STD 39,S
	STX 79,S
	STY -81,S

	PULU D,X
	STD 119,S
	STX -41,S

	PULU A,X
	STA -120,S
	STX -1,S

ERASE_POS_HRL2_2
	LDS #$0000
	LDU #ERASE_DATA_HRL2_2

ERASE_CODE_HRL2_2
	PULU A,X,S
	STA 1,S
	STX -1,S

	PULU A,B,X,S
	STA 120,S
	STB -1,S
	STX 118,S

	PULU A,B,X
	STA 39,S
	STB -121,S
	STX 79,S

	PULU A,B
	STA -81,S
	STB -41,S

	PULU A,B,X,S
	STA 120,S
	STB 1,S
	STX -121,S

	PULU A,B,X
	STA 79,S
	STB 41,S
	STX -41,S

	PULU A,B,X
	STA -79,S
	STB 81,S
	STX -1,S

	PULU A,B
	STA -119,S
	STB 39,S

	PULU A,X
	STA -39,S
	STX -81,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 121,S
	STX 40,S

	PULU A,X
	STA 42,S
	STX 81,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA -38,S
	STX -40,S

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

	PULU D,X
	STD -40,S
	STX -80,S

	PULU A,X
	STA -38,S
	STX -120,S

	PULU D,X,Y,S
	STD 79,S
	STX 39,S
	STY ,S

	PULU D,X
	STD -80,S
	STX -40,S

ERASE_SSAV_HRL2
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HRL2_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HRL2_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HRL2_END
