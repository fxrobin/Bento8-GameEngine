(main)IMG.ASM
	ORG $B068
DRAW_HRR2
	PSHS U,DP
	STS SSAV_HRR2+2

	LDS $9F00
	STS ERASE_POS_HRR2_1+2
	LDU #ERASE_DATA_HRR2_2
	LEAS 563,S
	LDD -81,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0cc0
	STD -81,S

	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$da
	STD -1,S

	LDD -41,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D,S

	LDD #$dccc
	STD -41,S

	LDD #$ddcd
	STD 40,S

	LDD #$23ad
	STD 80,S

	LEAS 239,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$da
	STD -40,S

	LDD -119,S
	PSHU D

	LDD -79,S
	PSHU D

	LDA -38,S
	PSHU A

	LDD #$22ac
	STD -119,S

	LDD #$2aaa
	STD -79,S

	STB -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$cbaa
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$aaca
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ca
	STD 40,S

	LDA 42,S
	PSHU A

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDA #$ac
	STA 42,S

	LDD #$cc9a
	STD 81,S

	LDB #$9b
	STD 121,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$ca0a
	PSHS A,X

	LEAS 200,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$c2
	STD -40,S

	LDA -38,S
	PSHU A

	LDA #$ba
	STA -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$d220
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$d223
	PSHS A,X

	LEAS 40,S
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 42,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$39
	STD 120,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$220d
	STD 40,S

	LDD #$31e0
	STD 80,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$d321
	PSHS A,X

	LEAS 280,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$dd
	STD -121,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$dd
	STD -81,S

	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0b
	LDB #$dd
	STD -41,S

	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0b
	LDB #$dd
	STD -1,S

	LDA 39,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA 39,S

	LDA 79,S
	PSHU A
	ANDA #$F0
	ORA #$09
	STA 79,S

	LDA 81,S
	PSHU A
	ANDA #$F0
	ORA #$00
	STA 81,S

	LDA 120,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA 120,S

	LDA -119,S
	PSHU A

	LDA -79,S
	PSHU A

	LDA -39,S
	PSHU A

	LDA 1,S
	PSHU A

	LDA 41,S
	PSHU A,S

	LDA #$20
	STA -119,S

	LDA #$2e
	STA -79,S

	LDA #$2a
	STA -39,S

	LDA #$19
	STA 1,S

	LDA #$09
	STA 41,S

	LEAS 281,S
	LDA -1,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -1,S

	LDD 78,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$aa
	STD 78,S

	LDD 118,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$af
	STD 118,S

	LDA -121,S
	PSHU A

	LDA -81,S
	PSHU A

	LDA -41,S
	PSHU A

	LDA 39,S
	PSHU A

	LDA 120,S
	PSHU A,S

	LDA #$0d
	STA -121,S

	LDA #$bb
	STA -81,S

	LDA #$aa
	STA -41,S

	LDA #$1a
	STA 39,S

	LDA #$ff
	STA 120,S

	LEAS 159,S
	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$ee
	STD -1,S

	LDA 1,S
	PSHU A,S

	LDA #$11
	STA 1,S


	LDS $9F00+2
	STS ERASE_POS_HRR2_2+2
	LDU #ERASE_DATA_HRR2_END

	LEAS 602,S
	LDD -80,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$c0
	STD -80,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ca
	STD 80,S

	LDA -120,S
	PSHU A

	LDD -40,S
	PSHU D

	LDD ,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 120,S
	PSHU D,S

	LDA #$cc
	STA -120,S

	LDD #$ccac
	STD -40,S

	LDD #$dcaa
	STD ,S

	LDA #$dd
	STD 40,S

	LDA #$cc
	STD 120,S

	LEAS 281,S
	LDA -79,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -79,S

	LDD -42,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dc
	STD -42,S

	LDD -40,S
	PSHU D
	LDA #$ab
	ANDB #$0F
	ORB #$d0
	STD -40,S

	LDD -2,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD -2,S

	LDD ,S
	PSHU D
	LDA #$ab
	ANDB #$0F
	ORB #$00
	STD ,S

	LDA 41,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA 41,S

	LDA 81,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA 81,S

	LDA 121,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 121,S

	LDD -121,S
	PSHU D

	LDD -81,S
	PSHU D

	LDD 39,S
	PSHU D

	LDD 79,S
	PSHU D

	LDD 119,S
	PSHU D,S

	LDD #$ccad
	STD -121,S

	LDD #$dccb
	STD -81,S

	LDD #$0cab
	STD 39,S

	LDA #$0d
	STD 79,S

	LDD #$ddcb
	STD 119,S

	LEAS 279,S
	LDA -118,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA -118,S

	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA -78,S

	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$d0
	STD -41,S

	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD -1,S

	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$03
	LDB #$01
	STD 79,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDA -39,S
	PSHU A

	LDA 1,S
	PSHU A

	LDD 40,S
	PSHU D

	LDA 81,S
	PSHU A

	LDD 119,S
	PSHU D,S

	LDD #$cdbb
	STD -120,S

	LDD #$dd2b
	STD -80,S

	LDA #$22
	STA -39,S

	STA 1,S

	LDD #$1d33
	STD 40,S

	LDA #$11
	STA 81,S

	LDD #$aa32
	STD 119,S

	LEAS 160,S
	LDA 1,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 1,S

	LDD -1,S
	PSHU D,S

	LDD #$ba32
	STD -1,S

	LEAS 159,S
	LDA -118,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -118,S

	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -78,S

	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA -38,S

	LDD 40,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$a0d0
	STD 40,S

	LDD 81,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$01
	STD 81,S

	LDD 121,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$c001
	STD 121,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDA 42,S
	PSHU A

	LDD #$bb32
	STD -120,S

	LDD #$bac2
	STD -80,S

	LDD #$bbc3
	STD -40,S

	LDA #$e1
	STA 42,S

	PULS A,X
	PSHU A,X,S
	LDA #$ba
	LDX #$ddef
	PSHS A,X

	LEAS 280,S
	LDA -120,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA -120,S

	LDA -118,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -118,S

	LDA -80,S
	PSHU A
	ANDA #$F0
	ORA #$09
	STA -80,S

	LDD ,S
	PSHU D
	LDA #$11
	ANDB #$0F
	ORB #$b0
	STD ,S

	LDA -40,S
	PSHU A

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D,S

	LDA #$0a
	STA -40,S

	LDD #$11ff
	STD 40,S

	LDB #$f2
	STD 80,S

	LDD #$00ee
	STD 120,S

SSAV_HRR2
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HRR2
	PSHS U,DP
	STS ERASE_SSAV_HRR2+2

ERASE_POS_HRR2_1
	LDS #$0000
	LDU #ERASE_DATA_HRR2_1

ERASE_CODE_HRR2_1
	PULU A,S
	STA 1,S
	PULU D
	STD -1,S
	PULU A,S
	STA 120,S
	PULU A
	STA 39,S
	PULU A
	STA -41,S
	PULU A
	STA -81,S
	PULU A
	STA -121,S
	PULU D
	STD 118,S
	PULU D
	STD 78,S
	PULU A
	STA -1,S
	PULU A,S
	STA 41,S
	PULU A
	STA 1,S
	PULU A
	STA -39,S
	PULU A
	STA -79,S
	PULU A
	STA -119,S
	PULU A
	STA 120,S
	PULU A
	STA 81,S
	PULU A
	STA 79,S
	PULU A
	STA 39,S
	PULU D
	STD -1,S
	PULU D
	STD -41,S
	PULU D
	STD -81,S
	PULU D
	STD -121,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 80,S
	PULU D
	STD 40,S
	PULU D
	STD 120,S
	PULU A
	STA 42,S
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU A
	STA -38,S
	PULU D
	STD -40,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 121,S
	PULU D
	STD 81,S
	PULU A
	STA 42,S
	PULU D
	STD 40,S
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU A
	STA -38,S
	PULU D
	STD -79,S
	PULU D
	STD -119,S
	PULU D
	STD -40,S
	PULU D,S
	STD 80,S
	PULU D
	STD 40,S
	PULU D
	STD -41,S
	PULU D
	STD -1,S
	PULU D
	STD -81,S
ERASE_POS_HRR2_2
	LDS #$0000
	LDU #ERASE_DATA_HRR2_2

ERASE_CODE_HRR2_2
	PULU D,S
	STD 120,S
	PULU D
	STD 80,S
	PULU D
	STD 40,S
	PULU A
	STA -40,S
	PULU D
	STD ,S
	PULU A
	STA -80,S
	PULU A
	STA -118,S
	PULU A
	STA -120,S
	PULU A,X,S
	PSHS A,X
	PULU A
	STA 42,S
	PULU D
	STD -40,S
	PULU D
	STD -80,S
	PULU D
	STD -120,S
	PULU D
	STD 121,S
	PULU D
	STD 81,S
	PULU D
	STD 40,S
	PULU A
	STA -38,S
	PULU A
	STA -78,S
	PULU A
	STA -118,S
	PULU D,S
	STD -1,S
	PULU A
	STA 1,S
	PULU D,S
	STD 119,S
	PULU A
	STA 81,S
	PULU D
	STD 40,S
	PULU A
	STA 1,S
	PULU A
	STA -39,S
	PULU D
	STD -80,S
	PULU D
	STD -120,S
	PULU D
	STD 79,S
	PULU D
	STD -1,S
	PULU D
	STD -41,S
	PULU A
	STA -78,S
	PULU A
	STA -118,S
	PULU D,S
	STD 119,S
	PULU D
	STD 79,S
	PULU D
	STD 39,S
	PULU D
	STD -81,S
	PULU D
	STD -121,S
	PULU A
	STA 121,S
	PULU A
	STA 81,S
	PULU A
	STA 41,S
	PULU D
	STD ,S
	PULU D
	STD -2,S
	PULU D
	STD -40,S
	PULU D
	STD -42,S
	PULU A
	STA -79,S
	PULU D,S
	STD 120,S
	PULU D
	STD 40,S
	PULU D
	STD ,S
	PULU D
	STD -40,S
	PULU A
	STA -120,S
	PULU D
	STD 80,S
	PULU D
	STD -80,S
ERASE_SSAV_HRR2
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HRR2_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRR2_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRR2_END
