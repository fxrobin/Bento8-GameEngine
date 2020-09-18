(main)IMG.ASM
	ORG $C78F
DRAW_HWL7
	PSHS U,DP
	STS SSAV_HWL7+2

	LDS $9F00
	STS ERASE_POS_HWL7_1+2
	LDU #ERASE_DATA_HWL7_2
	LEAS 523,S
	LDA 1,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 1,S

	LDA -80,S
	PSHU A

	LDD -40,S
	PSHU D

	LDD -1,S
	PSHU D

	LDD 39,S
	PSHU D

	LDD 79,S
	PSHU D,S

	LDA #$aa
	STA -80,S

	LDD #$ddcc
	STD -1,S

	LDA #$aa
	STD -40,S

	LDD #$adcd
	STD 39,S

	LDA #$a3
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

	LDD #$a3cd
	STD -120,S

	LDD #$dacc
	STD -40,S

	LDA #$aa
	STD -80,S

	PULS A,X
	PSHU A,X,S
	LDA #$bc
	LDX #$cccc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$bc
	LDX #$ccdc
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

	LDD #$bacc
	STD 40,S

	STD 80,S

	STD 120,S

	PULS A,X
	PSHU A,X,S
	LDA #$ba
	LDX #$ccdd
	PSHS A,X

	LEAS 240,S
	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -38,S

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD #$bccd
	STD -80,S

	LDD #$2bdd
	STD -40,S

	PULS A,X
	PSHU A,X,S
	LDA #$22
	LDX #$dddc
	PSHS A,X

	LEAS 40,S
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 42,S

	LDD 121,S
	PSHU D
	LDA #$bb
	ANDB #$0F
	ORB #$a0
	STD 121,S

	LDD 40,S
	PSHU D

	LDA 81,S
	PSHU A

	LDD #$33ba
	STD 40,S

	LDA #$bb
	STA 81,S

	PULS A,X
	PSHU A,X,S
	LDA #$22
	LDX #$b0dd
	PSHS A,X

	LEAS 281,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$aa
	STD -121,S

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

	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD -1,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$cd
	STD 39,S

	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$d0
	STD 79,S

	LDD 119,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$dc
	STD 119,S

	LDA 121,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA 121,S

	LDD -81,S
	PSHU D

	LDD -41,S
	PSHU D,S

	LDD #$cda9
	STD -81,S

	LDD #$d09d
	STD -41,S

	LEAS 280,S
	LDD -121,S
	PSHU D
	LDA #$a9
	ANDB #$F0
	ORB #$0d
	STD -121,S

	LDD -81,S
	PSHU D
	LDA #$ae
	ANDB #$F0
	ORB #$0d
	STD -81,S

	LDA 79,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 79,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$fa
	STD 120,S

	LDA -119,S
	PSHU A

	LDA -79,S
	PSHU A

	LDA -41,S
	PSHU A

	LDA -39,S
	PSHU A

	LDA -1,S
	PSHU A

	LDA 1,S
	PSHU A

	LDA 39,S
	PSHU A

	LDA 41,S
	PSHU A

	LDA 81,S
	PSHU A,S

	LDA #$e1
	STA -119,S

	LDA #$aa
	STA -41,S

	LDA #$1a
	STA -1,S

	LDA #$91
	STA 1,S

	LDA #$19
	STA 39,S

	LDA #$ba
	STA 81,S

	LDA #$a1
	STA -79,S

	STA -39,S

	STA 41,S

	LEAS 180,S
	LDD -20,S
	PSHU D

	LDD 20,S
	PSHU D,S

	LDD #$fffa
	STD -20,S

	LDD #$1100
	STD 20,S


	LDS $9F00+2
	STS ERASE_POS_HWL7_2+2
	LDU #ERASE_DATA_HWL7_END

	LEAS 523,S
	LDD -81,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0aa0
	STD -81,S

	LDD 78,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$2d
	STD 78,S

	LDA 80,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 80,S

	LDD -41,S
	PSHU D

	LDD -1,S
	PSHU D

	LDD 39,S
	PSHU D,S

	LDD #$aacc
	STD -41,S

	LDD #$dacd
	STD -1,S

	LDD #$2cdd
	STD 39,S

	LEAS 238,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$2d
	STD -120,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$2d
	STD -80,S

	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -78,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ad
	STD -40,S

	LDA -38,S
	PSHU A

	LDA #$cc
	STA -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$ca
	LDX #$aacc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ac
	LDX #$abcd
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$c0
	LDX #$aacd
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$aa
	STD 40,S

	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 82,S

	LDA 42,S
	PSHU A

	LDD 80,S
	PSHU D

	LDA #$dd
	STA 42,S

	LDD #$a9cc
	STD 80,S

	PULS A,X
	PSHU A,X,S
	LDA #$ca
	LDX #$aadd
	PSHS A,X

	LEAS 120,S
	PULS A,X
	PSHU A,X,S
	LDA #$92
	LDX #$2ccc
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$02
	LDB #$23
	STD 40,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$2d
	STD 80,S

	LDA 42,S
	PSHU A

	LDA 82,S
	PSHU A

	LDD 121,S
	PSHU D

	LDD #$1add
	STD 121,S

	STB 42,S

	STB 82,S

	PULS A,X
	PSHU A,X,S
	LDA #$02
	LDX #$23cc
	PSHS A,X

	LEAS 281,S
	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD ,S
	PSHU D

	LDD 40,S
	PSHU D

	LDA 80,S
	PSHU A

	LDA 120,S
	PSHU A,S

	LDD #$ebda
	STD -120,S

	LDD #$3ba9
	STD -80,S

	LDB #$b2
	STD -40,S

	LDD #$3aa1
	STD ,S

	LDD #$130d
	STD 40,S

	LDA #$01
	STA 80,S

	LDA #$ad
	STA 120,S

	LEAS 281,S
	LDA -121,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA -121,S

	LDD -81,S
	PSHU D
	LDA #$9e
	ANDB #$0F
	ORB #$d0
	STD -81,S

	LDA 1,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 1,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$1e
	STD 38,S

	LDD 40,S
	PSHU D
	LDA #$db
	ANDB #$0F
	ORB #$00
	STD 40,S

	LDD 78,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$a0
	STD 78,S

	LDD 80,S
	PSHU D
	LDA #$ba
	ANDB #$0F
	ORB #$00
	STD 80,S

	LDD 118,S
	PSHU D
	LDA #$f1
	ANDB #$0F
	ORB #$90
	STD 118,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0a00
	STD 120,S

	LDD -41,S
	PSHU D

	LDD -1,S
	PSHU D,S

	LDD #$0e0a
	STD -41,S

	LDD #$eedb
	STD -1,S

	LEAS 219,S
	LDD -59,S
	PSHU D
	LDA #$ff
	ANDB #$0F
	ORB #$00
	STD -59,S

	LDD -19,S
	PSHU D
	LDA #$2f
	ANDB #$0F
	ORB #$00
	STD -19,S

	LDA -61,S
	PSHU A

	LDA -21,S
	PSHU A

	LDA 21,S
	PSHU A

	LDA 61,S
	PSHU A,S

	LDA #$11
	STA -61,S

	LDA #$ff
	STA 21,S

	LDA #$ee
	STA -21,S

	STA 61,S

SSAV_HWL7
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HWL7
	PSHS U,DP
	STS ERASE_SSAV_HWL7+2

ERASE_POS_HWL7_1
	LDS #$0000
	LDU #ERASE_DATA_HWL7_1

ERASE_CODE_HWL7_1
	PULU D,S
	STD 20,S
	PULU D
	STD -20,S
	PULU A,S
	STA 81,S
	PULU A
	STA 41,S
	PULU A
	STA 39,S
	PULU A
	STA 1,S
	PULU A
	STA -1,S
	PULU A
	STA -39,S
	PULU A
	STA -41,S
	PULU A
	STA -79,S
	PULU A
	STA -119,S
	PULU D
	STD 120,S
	PULU A
	STA 79,S
	PULU D
	STD -81,S
	PULU D
	STD -121,S
	PULU D,S
	STD -41,S
	PULU D
	STD -81,S
	PULU A
	STA 121,S
	PULU D
	STD 119,S
	PULU D
	STD 79,S
	PULU D
	STD 39,S
	PULU D
	STD -1,S
	PULU A
	STA -79,S
	PULU A
	STA -119,S
	PULU D
	STD -121,S
	PULU A,X,S
	PSHS A,X
	PULU A
	STA 81,S
	PULU D
	STD 40,S
	PULU D
	STD 121,S
	PULU A
	STA 42,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD -40,S
	PULU D
	STD -80,S
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
	STD -1,S
	PULU D
	STD -40,S
	PULU A
	STA -80,S
	PULU A
	STA 1,S
ERASE_POS_HWL7_2
	LDS #$0000
	LDU #ERASE_DATA_HWL7_2

ERASE_CODE_HWL7_2
	PULU A,S
	STA 61,S
	PULU A
	STA 21,S
	PULU A
	STA -21,S
	PULU A
	STA -61,S
	PULU D
	STD -19,S
	PULU D
	STD -59,S
	PULU D,S
	STD -1,S
	PULU D
	STD -41,S
	PULU D
	STD 120,S
	PULU D
	STD 118,S
	PULU D
	STD 80,S
	PULU D
	STD 78,S
	PULU D
	STD 40,S
	PULU D
	STD 38,S
	PULU A
	STA 1,S
	PULU D
	STD -81,S
	PULU A
	STA -121,S
	PULU A,S
	STA 120,S
	PULU A
	STA 80,S
	PULU D
	STD 40,S
	PULU D
	STD ,S
	PULU D
	STD -40,S
	PULU D
	STD -80,S
	PULU D
	STD -120,S
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
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 80,S
	PULU A
	STA 42,S
	PULU A
	STA 82,S
	PULU D
	STD 40,S
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
	PULU D
	STD -40,S
	PULU A
	STA -78,S
	PULU D
	STD -80,S
	PULU D
	STD -120,S
	PULU D,S
	STD 39,S
	PULU D
	STD -1,S
	PULU D
	STD -41,S
	PULU A
	STA 80,S
	PULU D
	STD 78,S
	PULU D
	STD -81,S
ERASE_SSAV_HWL7
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HWL7_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWL7_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWL7_END
