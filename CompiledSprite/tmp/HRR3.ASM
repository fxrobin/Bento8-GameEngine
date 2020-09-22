(main)IMG.ASM
	ORG $C9C1
DRAW_HRR3
	PSHS U,DP
	STS SSAV_HRR3+2

	LDS $9F00
	STS ERASE_POS_HRR3_1+2
	LDU #ERASE_DATA_HRR3_2
	LEAS 563,S

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

	LDA #$cd
	LDX #$d223
	PSHS A,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$10
	STA 42,S

	LDD #$dd0d
	STD 40,S

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$03
	LDB #$e0
	STD 80,S

	LDD 120,S
	PSHU D

	ANDA #$F0
	ORA #$02
	LDB #$3c
	STD 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$d321
	PSHS A,X

	LEAS 240,S

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD #$d22d
	STD -80,S

	LDB #$ad
	STD -40,S

	LDD 39,S
	PSHU D

	ANDA #$F0
	ORA #$0e
	LDB #$00
	STD 39,S

	LDD 41,S
	PSHU D

	LDD #$ba11
	STD 41,S

	LDD 79,S
	PSHU D

	LDA #$01
	ANDB #$F0
	ORB #$0d
	STD 79,S

	LDD 81,S
	PSHU D

	LDD #$bb10
	STD 81,S

	PULS A,X
	PSHU A,X,S

	LDA #$d3
	LDX #$bdff
	PSHS A,X

	LEAS 119,S

	LDD 42,S
	PSHU D

	LDA #$ba
	ANDB #$0F
	ORB #$e0
	STD 42,S

	LDA 80,S
	PSHU A

	LDA 82,S
	PSHU A

	LDD 40,S
	PSHU D

	LDA #$1e
	ANDB #$0F
	ORB #$d0
	STD 40,S

	STA 80,S

	LDA #$ae
	STA 82,S

	LDA 120,S
	PSHU A

	LDA #$11
	STA 120,S

	LDA 122,S
	PSHU A

	ANDA #$F0
	ORA #$00
	STA 122,S

	PULS D,X
	PSHU D,X,S

	LDD #$1ecd
	LDX #$ba0e
	PSHS D,X

	LEAS 261,S

	LDA -101,S
	PSHU A

	LDA #$11
	STA -101,S

	LDA -61,S
	PSHU A

	LDA #$0a
	STA -61,S

	LDA -21,S
	PSHU A

	LDA #$9a
	STA -21,S

	LDA 19,S
	PSHU A

	LDA #$91
	STA 19,S

	LDD 59,S
	PSHU D,S

	ANDA #$F0
	ORA #$0e
	LDB #$2f
	STD 59,S

	LDA 100,S
	PSHU A

	LDA #$ee
	STA 100,S


	LDS $9F00+2
	STS ERASE_POS_HRR3_2+2
	LDU #ERASE_DATA_HRR3_END

	LEAS 602,S

	LDD -80,S
	PSHU D

	LDA #$cc
	ANDB #$0F
	ORB #$c0
	STD -80,S

	LDA -120,S
	PSHU A

	ANDA #$F0
	ORA #$0c
	STA -120,S

	LDD 40,S
	PSHU D

	LDD ,S
	PSHU D

	LDD #$ddaa
	STD 40,S

	LDA #$dc
	STD ,S

	LDD 80,S
	PSHU D,S

	ANDA #$F0
	ORA #$0c
	LDB #$ca
	STD 80,S

	LDD -40,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$ccac
	STD -40,S

	LDB #$aa
	STD 120,S

	LEAS 281,S

	LDD -41,S
	PSHU D

	LDD 119,S
	PSHU D

	LDD -81,S
	PSHU D

	LDD 79,S
	PSHU D

	LDD -121,S
	PSHU D

	LDD 38,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$0c
	STD 38,S

	LDD -2,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$dc
	STD -2,S

	LDA -39,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA -39,S

	LDD #$ccad
	STD -121,S

	LDD #$dccb
	STD -81,S

	LDA 81,S
	PSHU A

	ANDA #$0F
	ORA #$90
	STA 81,S

	LDD ,S
	PSHU D,S

	LDA #$ab
	ANDB #$0F
	ORB #$00
	STD ,S

	LDD 40,S
	PSHU D

	LDA #$ab
	ANDB #$0F
	ORB #$90
	STD 40,S

	LDD #$0dab
	STD 79,S

	LDA #$dc
	STD -41,S

	LDD #$ddcb
	STD 119,S

	LDA -79,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -79,S

	LDA 121,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 121,S

	LEAS 279,S

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDA 120,S
	PSHU A

	LDA 41,S
	PSHU A

	LDD 79,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$01
	STD 79,S

	LDD -120,S
	PSHU D

	LDA -78,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA -78,S

	LDA 81,S
	PSHU A

	LDD #$cdbb
	STD -120,S

	LDD ,S
	PSHU D,S

	LDD #$d022
	STD -40,S

	LDA #$dd
	STD ,S

	LDA #$11
	STA 81,S

	LDD #$dd2b
	STD -80,S

	LDD 39,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$1d
	STD 39,S

	LDA #$33
	STA 41,S

	LDA -118,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA -118,S

	LDA #$32
	STA 120,S

	LEAS 180,S

	LDD 20,S
	PSHU D,S

	LDA #$1a
	ANDB #$0F
	ORB #$a0
	STD 20,S

	LDA -20,S
	PSHU A

	LDA #$32
	STA -20,S

	LEAS 179,S

	LDD -80,S
	PSHU D

	ANDA #$0F
	ORA #$f0
	LDB #$a9
	STD -80,S

	LDD -119,S
	PSHU D

	LDD #$aaaa
	STD -119,S

	LDD -78,S
	PSHU D

	LDA #$ea
	ANDB #$0F
	ORB #$f0
	STD -78,S

	LDD -40,S
	PSHU D

	ANDA #$0F
	ORA #$a0
	LDB #$ab
	STD -40,S

	LDD -38,S
	PSHU D

	LDD #$1a0e
	STD -38,S

	PULS D,X
	PSHU D,X,S

	LDD #$0cab
	LDX #$19e1
	PSHS D,X

	LEAS 40,S

	LDA 80,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 80,S

	LDA 42,S
	PSHU A

	LDD 40,S
	PSHU D

	LDA #$ab
	ANDB #$F0
	ORB #$0a
	STD 40,S

	LDA #$0e
	STA 42,S

	LDA 82,S
	PSHU A

	ANDA #$0F
	ORA #$e0
	STA 82,S

	LDA 120,S
	PSHU A

	ANDA #$0F
	ORA #$b0
	STA 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$0d
	LDX #$9b10
	PSHS A,X

	LEAS 240,S

	LDD 80,S
	PSHU D

	LDA #$ee
	ANDB #$0F
	ORB #$10
	STD 80,S

	LDA -80,S
	PSHU A

	ANDA #$0F
	ORA #$b0
	STA -80,S

	LDA 40,S
	PSHU A

	LDA -40,S
	PSHU A,S

	LDA ,S
	PSHU A

	LDA #$ff
	STA ,S

	STA -40,S

	STA 40,S

SSAV_HRR3
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HRR3
	PSHS U,DP
	STS ERASE_SSAV_HRR3+2

ERASE_POS_HRR3_1
	LDS #$0000
	LDU #ERASE_DATA_HRR3_1

ERASE_CODE_HRR3_1
	PULU A,X,S
	STA 100,S
	STX 59,S

	PULU A,B
	STA 19,S
	STB -21,S

	PULU A,B
	STA -61,S
	STB -101,S

	PULU D,X,S
	PSHS D,X

	PULU A,B,X
	STA 122,S
	STB 120,S
	STX 40,S

	PULU A,B,X
	STA 82,S
	STB 80,S
	STX 42,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 81,S
	STX 79,S
	STY 41,S

	PULU D,X,Y
	STD 39,S
	STX -40,S
	STY -80,S

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

ERASE_POS_HRR3_2
	LDS #$0000
	LDU #ERASE_DATA_HRR3_2

ERASE_CODE_HRR3_2
	PULU A,B,S
	STA ,S
	STB -40,S

	PULU A,B,X
	STA 40,S
	STB -80,S
	STX 80,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X
	STA 120,S
	STB 82,S
	STX 40,S

	PULU A,B
	STA 42,S
	STB 80,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD -38,S
	STX -40,S
	STY -78,S

	PULU D,X
	STD -119,S
	STX -80,S

	PULU A,X,S
	STA -20,S
	STX 20,S

	PULU A,X,Y,S
	STA -118,S
	STX 39,S
	STY ,S

	PULU A,B,X,Y
	STA 81,S
	STB -78,S
	STX -120,S
	STY 79,S

	PULU A,B,X,Y
	STA 41,S
	STB 120,S
	STX -40,S
	STY -80,S

	PULU A,B,X,Y,S
	STA 121,S
	STB -79,S
	STX 40,S
	STY ,S

	PULU A,B,X,Y
	STA 81,S
	STB -39,S
	STX -2,S
	STY 38,S

	PULU D,X,Y
	STD -121,S
	STX 79,S
	STY -81,S

	PULU D,X
	STD 119,S
	STX -41,S

	PULU D,X,Y,S
	STD 120,S
	STX -40,S
	STY 80,S

	PULU D,X
	STD ,S
	STX 40,S

	PULU A,X
	STA -120,S
	STX -80,S

ERASE_SSAV_HRR3
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HRR3_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRR3_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HRR3_END
