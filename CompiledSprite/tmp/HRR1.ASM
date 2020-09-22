(main)IMG.ASM
	ORG $A000
DRAW_HRR1
	PSHS U,DP
	STS SSAV_HRR1+2

	LDS $9F00
	STS ERASE_POS_HRR1_1+2
	LDU #ERASE_DATA_HRR1_2
	LEAS 523,S

	LDD -41,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -41,S

	LDD -1,S
	PSHU D

	LDA 41,S
	PSHU A

	LDD #$ddda
	STD -1,S

	LDA -80,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -80,S

	LDD 39,S
	PSHU D,S

	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 39,S

	LDA #$cd
	STA 41,S

	LDD 80,S
	PSHU D

	LDD #$23ad
	STD 80,S

	LEAS 239,S

	LDD -119,S
	PSHU D

	LDD #$22ac
	STD -119,S

	LDA -38,S
	PSHU A

	LDD -79,S
	PSHU D

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$da
	STD -40,S

	LDD #$2aaa
	STD -79,S

	STB -38,S

	PULS A,X
	PSHU A,X,S

	LDA #$cc
	LDX #$cbaa
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$cd
	LDX #$aaca
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$ca0a
	PSHS A,X

	LEAS 40,S

	LDD 81,S
	PSHU D

	LDD #$cc9b
	STD 81,S

	LDA 42,S
	PSHU A

	LDA 122,S
	PSHU A

	LDD 120,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$c2
	STD 120,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 40,S

	LDA #$9a
	STA 42,S

	LDA #$ba
	STA 122,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$caac
	PSHS A,X

	LEAS 160,S

	PULS A,X
	PSHU A,X,S

	LDX #$d220
	PSHS B,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$22
	LDX #$d223
	PSHS A,X

	LEAS 39,S

	PULS D,X
	PSHU D,X,S

	LDD #$aa33
	LDX #$d321
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$bbdd
	LDX #$0d1a
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$bb1d
	LDX #$e009
	PSHS D,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	LDD 42,S
	PSHU D

	ANDA #$0F
	ORA #$20
	LDB #$99
	STD 42,S

	LDD 80,S
	PSHU D

	LDD #$badd
	STD 40,S

	LDA #$9a
	STD 80,S

	LDD 82,S
	PSHU D

	ANDA #$0F
	ORA #$20
	LDB #$9a
	STD 82,S

	LDD 121,S
	PSHU D

	LDD #$dd21
	STD 121,S

	LDA 123,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 123,S

	PULS D,X
	PSHU D,X,S

	LDD #$abed
	LDX #$3ea0
	PSHS D,X

	LEAS 282,S

	LDD -81,S
	PSHU D

	ANDA #$0F
	ORA #$e0
	LDB #$c0
	STD -81,S

	LDD -121,S
	PSHU D

	LDD #$dd3e
	STD -121,S

	LDA -40,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA -40,S

	LDA ,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA ,S

	LDD 40,S
	PSHU D,S

	ANDA #$0F
	ANDB #$F0
	ADDD #$d00f
	STD 40,S

	LDD 80,S
	PSHU D

	ANDA #$0F
	ORA #$d0
	LDB #$f1
	STD 80,S

	LDD 120,S
	PSHU D

	ANDA #$0F
	ORA #$b0
	LDB #$2e
	STD 120,S

	LEAS 260,S

	LDD -60,S
	PSHU D

	LDA #$ab
	ANDB #$0F
	ORB #$10
	STD -60,S

	LDD -20,S
	PSHU D

	LDA #$fb
	ANDB #$0F
	ORB #$e0
	STD -20,S

	LDA 60,S
	PSHU A

	LDA 20,S
	PSHU A

	LDD -100,S
	PSHU D,S

	ANDA #$0F
	ANDB #$0F
	ADDD #$a0f0
	STD -100,S

	LDA #$aa
	STA 20,S

	STA 60,S

	LDA 100,S
	PSHU A

	LDA #$00
	STA 100,S


	LDS $9F00+2
	STS ERASE_POS_HRR1_2+2
	LDU #ERASE_DATA_HRR1_END

	LEAS 562,S

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$ca
	STD 80,S

	LDA -120,S
	PSHU A

	ANDA #$F0
	ORA #$0c
	STA -120,S

	LDD 40,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD -40,S
	PSHU D,S

	LDD ,S
	PSHU D

	LDD -80,S
	PSHU D

	LDA #$cc
	ANDB #$0F
	ORB #$c0
	STD -80,S

	LDD #$ccac
	STD -40,S

	LDD #$dcaa
	STD ,S

	LDA #$dd
	STD 40,S

	LDA #$cc
	STD 120,S

	LEAS 281,S

	LDD ,S
	PSHU D

	LDA #$ab
	ANDB #$0F
	ORB #$00
	STD ,S

	LDD -121,S
	PSHU D

	LDD -41,S
	PSHU D

	LDD 38,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$0c
	STD 38,S

	LDD 40,S
	PSHU D

	LDA #$ab
	ANDB #$0F
	ORB #$90
	STD 40,S

	LDD -81,S
	PSHU D

	LDD #$ccad
	STD -121,S

	LDD 119,S
	PSHU D

	LDA -79,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -79,S

	LDA -39,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA -39,S

	LDD 79,S
	PSHU D,S

	LDD #$ddcb
	STD 119,S

	LDA #$dc
	STD -81,S

	LDD -2,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$dc
	STD -2,S

	LDD #$0dab
	STD 79,S

	LDA #$dc
	STD -41,S

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

	LEAS 278,S

	LDD 121,S
	PSHU D

	LDD 41,S
	PSHU D

	LDD 119,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$a1
	STD 119,S

	LDD -39,S
	PSHU D

	LDD -119,S
	PSHU D

	LDD #$cdbb
	STD -119,S

	LDD #$d022
	STD -39,S

	LDD #$ed33
	STD 41,S

	LDA -77,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA -77,S

	LDD 81,S
	PSHU D

	LDD -79,S
	PSHU D

	LDD #$0111
	STD 81,S

	LDD 79,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0a90
	STD 79,S

	LDD #$32e0
	STD 121,S

	LDD 39,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$a3
	STD 39,S

	LDD #$dd2b
	STD -79,S

	LDA -117,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA -117,S

	LDA 123,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 123,S

	PULS A,X
	PSHU A,X,S

	LDA #$a2
	LDX #$3d22
	PSHS A,X

	LEAS 240,S

	LDD -81,S
	PSHU D

	ANDA #$F0
	ANDB #$F0
	ADDD #$0a0e
	STD -81,S

	LDA -38,S
	PSHU A

	LDA 2,S
	PSHU A

	ANDA #$F0
	ORA #$00
	STA 2,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0e
	LDB #$32
	STD -40,S

	LDA #$e9
	STA -38,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$dc
	STD 40,S

	LDD ,S
	PSHU D,S

	ANDA #$F0
	ORA #$0e
	LDB #$c2
	STD ,S

	LDD -79,S
	PSHU D

	LDD #$3219
	STD -79,S

	LDD 80,S
	PSHU D

	ANDA #$F0
	ANDB #$F0
	ADDD #$0d0d
	STD 80,S

	LEAS 401,S

	LDD -120,S
	PSHU D

	ANDA #$F0
	ANDB #$F0
	ADDD #$0a0f
	STD -120,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$09
	LDB #$ff
	STD -40,S

	LDD ,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D,S

	LDD #$111e
	STD 80,S

	LDB #$f1
	STD 40,S

	LDD -80,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$bf
	STD -80,S

	LDD #$0eff
	STD ,S

	LDD 120,S
	PSHU D

	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD 120,S

SSAV_HRR1
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HRR1
	PSHS U,DP
	STS ERASE_SSAV_HRR1+2

ERASE_POS_HRR1_1
	LDS #$0000
	LDU #ERASE_DATA_HRR1_1

ERASE_CODE_HRR1_1
	PULU A,X,S
	STA 100,S
	STX -100,S

	PULU A,B,X,Y
	STA 20,S
	STB 60,S
	STX -20,S
	STY -60,S

	PULU D,X,Y,S
	STD 120,S
	STX 80,S
	STY 40,S

	PULU A,B,X,Y
	STA ,S
	STB -40,S
	STX -121,S
	STY -81,S

	PULU D,X,S
	PSHS D,X

	PULU A,X,Y
	STA 123,S
	STX 121,S
	STY 82,S

	PULU D,X,Y
	STD 80,S
	STX 42,S
	STY 40,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 40,S
	STX 120,S

	PULU A,B,X
	STA 122,S
	STB 42,S
	STX 81,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -40,S
	STX -79,S

	PULU A,X
	STA -38,S
	STX -119,S

	PULU D,X,S
	STD 80,S
	STX 39,S

	PULU A,B,X,Y
	STA -80,S
	STB 41,S
	STX -1,S
	STY -41,S

ERASE_POS_HRR1_2
	LDS #$0000
	LDU #ERASE_DATA_HRR1_2

ERASE_CODE_HRR1_2
	PULU D,X,Y,S
	STD 120,S
	STX -80,S
	STY 80,S

	PULU D,X,Y
	STD 40,S
	STX ,S
	STY -40,S

	PULU D
	STD -120,S

	PULU D,X,Y,S
	STD 80,S
	STX -79,S
	STY ,S

	PULU D,X
	STD 40,S
	STX -40,S

	PULU A,B,X
	STA 2,S
	STB -38,S
	STX -81,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA 123,S
	STB -117,S
	STX 39,S
	STY 79,S

	PULU D,X
	STD -79,S
	STX 81,S

	PULU A,X,Y
	STA -77,S
	STX -119,S
	STY -39,S

	PULU D,X,Y
	STD 119,S
	STX 41,S
	STY 121,S

	PULU A,B,X,Y,S
	STA 121,S
	STB 81,S
	STX -2,S
	STY 79,S

	PULU A,B,X,Y
	STA -39,S
	STB -79,S
	STX 119,S
	STY -81,S

	PULU D,X,Y
	STD 40,S
	STX 38,S
	STY -41,S

	PULU D,X
	STD -121,S
	STX ,S

	PULU D,X,Y,S
	STD -80,S
	STX ,S
	STY -40,S

	PULU D,X
	STD 120,S
	STX 40,S

	PULU A,X
	STA -120,S
	STX 80,S

ERASE_SSAV_HRR1
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HRR1_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRR1_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRR1_END
