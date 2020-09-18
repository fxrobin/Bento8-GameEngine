(main)IMG.ASM
	ORG $D887
DRAW_HJR6
	PSHS U,DP
	STS SSAV_HJR6+2

	LDS $9F00
	STS ERASE_POS_HJR6_1+2
	LDU #ERASE_DATA_HJR6_2
	LEAS 604,S
	LDA -121,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -121,S

	LDD -82,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$fa
	STD -82,S

	LDA ,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA ,S

	LDA 40,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 40,S

	LDD 78,S
	PSHU D
	ANDA #$0F
	ORA #$f0
	LDB #$aa
	STD 78,S

	LDA 80,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 80,S

	LDD 118,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$cc
	STD 118,S

	LDA 120,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 120,S

	LDD -42,S
	PSHU D

	LDD -2,S
	PSHU D

	LDD 38,S
	PSHU D,S

	LDD #$1fad
	STD 38,S

	LDD #$11fc
	STD -2,S

	LDA #$0a
	STD -42,S

	LEAS 279,S
	LDA -119,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -119,S

	LDD -82,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$ac
	STD -82,S

	LDD -80,S
	PSHU D
	LDA #$3c
	ANDB #$0F
	ORB #$a0
	STD -80,S

	LDD -42,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$aa
	STD -42,S

	LDD -2,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$aa
	STD -2,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$a9
	STD 38,S

	LDD 78,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$aa
	STD 78,S

	LDD 118,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$12
	STD 118,S

	LDD -121,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD ,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D,S

	LDD #$9a3c
	STD -121,S

	LDD #$ccac
	STD 80,S

	LDD #$cacd
	STD 120,S

	LDD #$dcaa
	STD -40,S

	STD ,S

	STD 40,S

	LEAS 279,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$9d
	STD -121,S

	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -78,S

	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -38,S

	LDD -119,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD #$cacd
	STD -119,S

	LDD #$aaca
	STD -80,S

	LDB #$cc
	STD -40,S

	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$ccca
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$cccc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$cccd
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$ccdd
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

	LDD #$dddc
	STD 40,S

	LDB #$cc
	STD 80,S

	LDB #$dd
	STD 120,S

	PULS A,X
	PSHU A,X,S
	LDA #$da
	LDX #$ccdd
	PSHS A,X

	LEAS 160,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 40,S

	LDD 81,S
	PSHU D
	LDA #$dd
	ANDB #$0F
	ORB #$d0
	STD 81,S

	LDA 42,S
	PSHU A

	LDA 121,S
	PSHU A

	LDA #$dd
	STA 42,S

	STA 121,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$dccc
	PSHS A,X

	LEAS 161,S
	LDA ,S
	PSHU A,S

	LDA #$dd
	STA ,S


	LDS $9F00+2
	STS ERASE_POS_HJR6_2+2
	LDU #ERASE_DATA_HJR6_END

	LEAS 522,S
	LDD ,S
	PSHU D
	LDA #$1f
	ANDB #$0F
	ORB #$a0
	STD ,S

	LDD 40,S
	PSHU D
	LDA #$ff
	ANDB #$0F
	ORB #$a0
	STD 40,S

	LDA -40,S
	PSHU A,S

	LDA #$e1
	STA -40,S

	LEAS 199,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$cf
	STD -120,S

	LDA -118,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -118,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$99
	STD -80,S

	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -78,S

	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -38,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 3,S

	LDD -40,S
	PSHU D

	LDD #$01aa
	STD -40,S

	PULS A,X
	PSHU A,X,S
	LDA #$e1
	LDX #$9dac
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 3,S

	LDD 40,S
	PSHU D
	ANDA #$0F
	ORA #$10
	LDB #$ac
	STD 40,S

	LDD 42,S
	PSHU D
	LDA #$ca
	ANDB #$0F
	ORB #$c0
	STD 42,S

	PULS A,X
	PSHU A,X,S
	LDA #$1f
	LDX #$ddac
	PSHS A,X

	LEAS 80,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$f9
	LDX #$adca
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 3,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$3c
	STD 40,S

	LDD 42,S
	PSHU D
	LDA #$ab
	ANDB #$0F
	ORB #$c0
	STD 42,S

	LDA 123,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA 123,S

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDD #$a2ab
	STD 81,S

	LDD #$d2ca
	STD 121,S

	PULS A,X
	PSHU A,X,S
	LDA #$fa
	LDX #$dcab
	PSHS A,X

	LEAS 160,S
	LDA 3,S
	PSHU A
	ANDA #$F0
	ORA #$0c
	STA 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$00
	LDX #$22cc
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$F0
	ORA #$0c
	STA 3,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$dc
	STD 40,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$dc
	STD 80,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dd
	STD 120,S

	LDD 122,S
	PSHU D
	LDA #$ac
	ANDB #$0F
	ORB #$d0
	STD 122,S

	LDD 42,S
	PSHU D

	LDD 82,S
	PSHU D

	LDD #$adad
	STD 42,S

	LDD #$accd
	STD 82,S

	PULS A,X
	PSHU A,X,S
	LDA #$0a
	LDX #$33cc
	PSHS A,X

	LEAS 281,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD -121,S

	LDD -119,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$d0
	STD -119,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD -81,S

	LDD -79,S
	PSHU D
	LDA #$cd
	ANDB #$0F
	ORB #$d0
	STD -79,S

	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD -41,S

	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cd
	STD -1,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cd
	STD 39,S

	LDA -39,S
	PSHU A

	LDA 1,S
	PSHU A

	LDA 41,S
	PSHU A

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D,S

	LDD #$ddcc
	STD 120,S

	LDB #$dc
	STD 80,S

	STA -39,S

	STA 1,S

	STB 41,S

	LEAS 221,S
	LDA 60,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 60,S

	LDD -61,S
	PSHU D

	LDD -21,S
	PSHU D

	LDD 19,S
	PSHU D,S

	LDD #$1ddc
	STD -61,S

	LDD #$dddd
	STD 19,S

	LDA #$3d
	STD -21,S

SSAV_HJR6
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HJR6
	PSHS U,DP
	STS ERASE_SSAV_HJR6+2

ERASE_POS_HJR6_1
	LDS #$0000
	LDU #ERASE_DATA_HJR6_1

ERASE_CODE_HJR6_1
	PULU A,S
	STA ,S
	PULU A,X,S
	PSHS A,X
	PULU A
	STA 121,S
	PULU A
	STA 42,S
	PULU D
	STD 81,S
	PULU D
	STD 40,S
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
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU D
	STD -40,S
	PULU D
	STD -80,S
	PULU D
	STD -119,S
	PULU A
	STA -38,S
	PULU A
	STA -78,S
	PULU D
	STD -121,S
	PULU D,S
	STD 120,S
	PULU D
	STD 80,S
	PULU D
	STD 40,S
	PULU D
	STD ,S
	PULU D
	STD -40,S
	PULU D
	STD -121,S
	PULU D
	STD 118,S
	PULU D
	STD 78,S
	PULU D
	STD 38,S
	PULU D
	STD -2,S
	PULU D
	STD -42,S
	PULU D
	STD -80,S
	PULU D
	STD -82,S
	PULU A
	STA -119,S
	PULU D,S
	STD 38,S
	PULU D
	STD -2,S
	PULU D
	STD -42,S
	PULU A
	STA 120,S
	PULU D
	STD 118,S
	PULU A
	STA 80,S
	PULU D
	STD 78,S
	PULU A
	STA 40,S
	PULU A
	STA ,S
	PULU D
	STD -82,S
	PULU A
	STA -121,S
ERASE_POS_HJR6_2
	LDS #$0000
	LDU #ERASE_DATA_HJR6_2

ERASE_CODE_HJR6_2
	PULU D,S
	STD 19,S
	PULU D
	STD -21,S
	PULU D
	STD -61,S
	PULU A
	STA 60,S
	PULU D,S
	STD 120,S
	PULU D
	STD 80,S
	PULU A
	STA 41,S
	PULU A
	STA 1,S
	PULU A
	STA -39,S
	PULU D
	STD 39,S
	PULU D
	STD -1,S
	PULU D
	STD -41,S
	PULU D
	STD -79,S
	PULU D
	STD -81,S
	PULU D
	STD -119,S
	PULU D
	STD -121,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 82,S
	PULU D
	STD 42,S
	PULU D
	STD 122,S
	PULU D
	STD 120,S
	PULU D
	STD 80,S
	PULU D
	STD 40,S
	PULU A
	STA 3,S
	PULU A,X,S
	PSHS A,X
	PULU A
	STA 3,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 121,S
	PULU D
	STD 81,S
	PULU A
	STA 123,S
	PULU D
	STD 42,S
	PULU D
	STD 40,S
	PULU A
	STA 3,S
	PULU A,X,S
	PSHS A,X
	PULU A
	STA 3,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 42,S
	PULU D
	STD 40,S
	PULU A
	STA 3,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD -40,S
	PULU A
	STA 3,S
	PULU A
	STA -38,S
	PULU A
	STA -78,S
	PULU D
	STD -80,S
	PULU A
	STA -118,S
	PULU D
	STD -120,S
	PULU A,S
	STA -40,S
	PULU D
	STD 40,S
	PULU D
	STD ,S
ERASE_SSAV_HJR6
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HJR6_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJR6_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJR6_END
