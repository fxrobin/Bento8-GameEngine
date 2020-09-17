(main)IMG.ASM
	ORG $A829
DRAW_HRL2
	PSHS U,DP
	STS SSAV_HRL2+2

	LDS $9F00
	STS ERASE_POS_HRL2_1+2
	LDU #ERASE_DATA_HRL2_2
	LEAS 603,S
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

	LDA -120,S
	PSHU A

	LDD -41,S
	PSHU D

	LDD -1,S
	PSHU D

	LDD 39,S
	PSHU D

	LDD 119,S
	PSHU D,S

	LDD #$aacd
	STD -1,S

	LDB #$dd
	STD 39,S

	LDB #$cc
	STD 119,S

	STB -120,S

	LDA #$ca
	STD -41,S

	LEAS 280,S
	LDD -82,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$bc
	STD -82,S

	LDD -42,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ba
	STD -42,S

	LDD -40,S
	PSHU D
	LDA #$cd
	ANDB #$0F
	ORB #$c0
	STD -40,S

	LDD -2,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$ba
	STD -2,S

	LDD ,S
	PSHU D
	LDA #$cd
	ANDB #$0F
	ORB #$d0
	STD ,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$ba
	STD 38,S

	LDD 78,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$ba
	STD 78,S

	LDD 118,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$bc
	STD 118,S

	LDD -121,S
	PSHU D

	LDA -80,S
	PSHU A

	LDA 40,S
	PSHU A

	LDA 80,S
	PSHU A

	LDA 120,S
	PSHU A,S

	LDA #$cd
	STA -80,S

	LDD #$dacc
	STD -121,S

	LDA #$c0
	STA 40,S

	LDA #$d0
	STA 80,S

	LDA #$dd
	STA 120,S

	LEAS 279,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$bb
	STD -121,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$b2
	STD -81,S

	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -38,S

	LDA 2,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 2,S

	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$30
	STA 82,S

	LDA -119,S
	PSHU A

	LDA -79,S
	PSHU A

	LDD -40,S
	PSHU D

	LDD ,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 121,S
	PSHU D,S

	LDA #$dc
	STA -119,S

	LDD #$22dd
	STD ,S

	STB -79,S

	LDB #$0d
	STD -40,S

	LDD #$33d1
	STD 40,S

	LDD #$1110
	STD 80,S

	LDD #$23aa
	STD 121,S

	LEAS 161,S
	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$23
	STD -1,S

	LDA 1,S
	PSHU A,S

	LDA #$ab
	STA 1,S

	LEAS 159,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$23
	STD -120,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$2c
	STD -80,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$3c
	STD -40,S

	LDD 40,S
	PSHU D
	LDA #$1e
	ANDB #$F0
	ORB #$0d
	STD 40,S

	LDA 42,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA 42,S

	LDD 80,S
	PSHU D
	LDA #$10
	ANDB #$F0
	ORB #$0d
	STD 80,S

	LDD 120,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$100c
	STD 120,S

	LDA -118,S
	PSHU A

	LDA -78,S
	PSHU A

	LDA -38,S
	PSHU A

	LDA #$ab
	STA -78,S

	LDA #$bb
	STA -118,S

	STA -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$fe
	LDX #$ddab
	PSHS A,X

	LEAS 281,S
	LDA -121,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA -121,S

	LDA -119,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -119,S

	LDA -79,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA -79,S

	LDD ,S
	PSHU D
	ANDA #$F0
	ORA #$0b
	LDB #$11
	STD ,S

	LDA -39,S
	PSHU A

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D,S

	LDD #$ff11
	STD 40,S

	LDA #$a0
	STA -39,S

	LDA #$2f
	STD 80,S

	LDD #$ee00
	STD 120,S


	LDS $9F00+2
	STS ERASE_POS_HRL2_2+2
	LDU #ERASE_DATA_HRL2_END

	LEAS 562,S
	LDD -80,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0cc0
	STD -80,S

	LDD ,S
	PSHU D
	LDA #$ad
	ANDB #$0F
	ORB #$d0
	STD ,S

	LDD -40,S
	PSHU D

	LDD 39,S
	PSHU D

	LDD 79,S
	PSHU D,S

	LDD #$dcdd
	STD 39,S

	LDD #$cccd
	STD -40,S

	LDD #$da32
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

	LDD #$ca22
	STD -120,S

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
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 42,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$caac
	STD 40,S

	LDD #$b9cc
	STD 120,S

	LDA #$a9
	STD 80,S

	PULS A,X
	PSHU A,X,S
	LDA #$a0
	LDX #$acdd
	PSHS A,X

	LEAS 200,S
	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -38,S

	LDD -40,S
	PSHU D

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
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$d0
	STD 40,S

	LDD 121,S
	PSHU D
	LDA #$93
	ANDB #$0F
	ORB #$d0
	STD 121,S

	LDA 42,S
	PSHU A

	LDD 81,S
	PSHU D

	LDD #$0e13
	STD 81,S

	LDA #$22
	STA 42,S

	PULS A,X
	PSHU A,X,S
	LDA #$12
	LDX #$3ddd
	PSHS A,X

	LEAS 282,S
	LDA -119,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -119,S

	LDA -79,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -79,S

	LDA -39,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA -39,S

	LDA 1,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA 1,S

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

	LDA 81,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA 81,S

	LDA 120,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 120,S

	LDD -121,S
	PSHU D

	LDD -81,S
	PSHU D

	LDD -41,S
	PSHU D

	LDD -1,S
	PSHU D

	LDA 39,S
	PSHU A,S

	LDD #$e2dd
	STD -81,S

	LDA #$02
	STD -121,S

	LDA #$a2
	STD -41,S

	LDA #$91
	STD -1,S

	LDA #$90
	STA 39,S

	LEAS 281,S
	LDA -1,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA -1,S

	LDD 79,S
	PSHU D
	LDA #$aa
	ANDB #$0F
	ORB #$e0
	STD 79,S

	LDA 120,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 120,S

	LDA -121,S
	PSHU A

	LDA -81,S
	PSHU A

	LDA -41,S
	PSHU A

	LDA 39,S
	PSHU A

	LDD 118,S
	PSHU D,S

	LDA #$bb
	STA -81,S

	LDA #$d0
	STA -121,S

	LDA #$aa
	STA -41,S

	LDA #$a1
	STA 39,S

	LDD #$fffa
	STD 118,S

	LEAS 159,S
	LDA 1,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 1,S

	LDD -1,S
	PSHU D,S

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
	PULU D,S
	STD 120,S
	PULU D
	STD 80,S
	PULU D
	STD 40,S
	PULU A
	STA -39,S
	PULU D
	STD ,S
	PULU A
	STA -79,S
	PULU A
	STA -119,S
	PULU A
	STA -121,S
	PULU A,X,S
	PSHS A,X
	PULU A
	STA -38,S
	PULU A
	STA -78,S
	PULU A
	STA -118,S
	PULU D
	STD 120,S
	PULU D
	STD 80,S
	PULU A
	STA 42,S
	PULU D
	STD 40,S
	PULU D
	STD -40,S
	PULU D
	STD -80,S
	PULU D
	STD -120,S
	PULU A,S
	STA 1,S
	PULU D
	STD -1,S
	PULU D,S
	STD 121,S
	PULU D
	STD 80,S
	PULU D
	STD 40,S
	PULU D
	STD ,S
	PULU D
	STD -40,S
	PULU A
	STA -79,S
	PULU A
	STA -119,S
	PULU A
	STA 82,S
	PULU A
	STA 2,S
	PULU A
	STA -38,S
	PULU D
	STD -81,S
	PULU D
	STD -121,S
	PULU A,S
	STA 120,S
	PULU A
	STA 80,S
	PULU A
	STA 40,S
	PULU A
	STA -80,S
	PULU D
	STD -121,S
	PULU D
	STD 118,S
	PULU D
	STD 78,S
	PULU D
	STD 38,S
	PULU D
	STD ,S
	PULU D
	STD -2,S
	PULU D
	STD -40,S
	PULU D
	STD -42,S
	PULU D
	STD -82,S
	PULU D,S
	STD 119,S
	PULU D
	STD 39,S
	PULU D
	STD -1,S
	PULU D
	STD -41,S
	PULU A
	STA -120,S
	PULU D
	STD 79,S
	PULU D
	STD -81,S
ERASE_POS_HRL2_2
	LDS #$0000
	LDU #ERASE_DATA_HRL2_2

ERASE_CODE_HRL2_2
	PULU D,S
	STD -1,S
	PULU A
	STA 1,S
	PULU D,S
	STD 118,S
	PULU A
	STA 39,S
	PULU A
	STA -41,S
	PULU A
	STA -81,S
	PULU A
	STA -121,S
	PULU A
	STA 120,S
	PULU D
	STD 79,S
	PULU A
	STA -1,S
	PULU A,S
	STA 39,S
	PULU D
	STD -1,S
	PULU D
	STD -41,S
	PULU D
	STD -81,S
	PULU D
	STD -121,S
	PULU A
	STA 120,S
	PULU A
	STA 81,S
	PULU A
	STA 79,S
	PULU A
	STA 41,S
	PULU A
	STA 1,S
	PULU A
	STA -39,S
	PULU A
	STA -79,S
	PULU A
	STA -119,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 81,S
	PULU A
	STA 42,S
	PULU D
	STD 121,S
	PULU D
	STD 40,S
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU D
	STD -40,S
	PULU A
	STA -38,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 120,S
	PULU D
	STD 80,S
	PULU D
	STD 40,S
	PULU A
	STA 42,S
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU D
	STD -40,S
	PULU D
	STD -80,S
	PULU D
	STD -120,S
	PULU A
	STA -38,S
	PULU D,S
	STD 79,S
	PULU D
	STD 39,S
	PULU D
	STD -40,S
	PULU D
	STD ,S
	PULU D
	STD -80,S
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
	FCB $00
	FCB $00
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
	FCB $00
	FCB $00
ERASE_DATA_HRL2_END
