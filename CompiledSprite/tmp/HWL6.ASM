(main)IMG.ASM
	ORG $C987
DRAW_HWL6
	PSHS U,DP
	STS SSAV_HWL6+2

	LDS $9F00
	STS ERASE_POS_HWL6_1+2
	LDU #ERASE_DATA_HWL6_2
	LEAS 523,S

	LDD -1,S
	PSHU D

	LDA -120,S
	PSHU A

	LDA -39,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA -39,S

	LDD 39,S
	PSHU D

	LDD 79,S
	PSHU D

	LDD #$cadd
	STD -1,S

	LDA #$aa
	STD 39,S

	LDA -80,S
	PSHU A

	LDD 119,S
	PSHU D,S

	LDD -41,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -41,S

	STB -120,S

	LDD #$aadc
	STD 79,S

	STA -80,S

	STD 119,S

	LEAS 279,S

	LDD -80,S
	PSHU D

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

	LDD -120,S
	PSHU D

	LDD #$addc
	STD -120,S

	LDD -40,S
	PSHU D

	LDD #$cbcc
	STD -80,S

	LDA #$ab
	STD -40,S

	PULS A,X
	PSHU A,X,S

	LDA #$bb
	LDX #$ccdc
	PSHS A,X

	LEAS 40,S

	LDD 80,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$bbcc
	STD 40,S

	LDB #$cd
	STD 80,S

	LDA #$ba
	STD 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$bb
	LDX #$ccdd
	PSHS A,X

	LEAS 280,S

	LDD 81,S
	PSHU D

	LDA #$bb
	ANDB #$0F
	ORB #$30
	STD 81,S

	LDD -40,S
	PSHU D

	LDA -118,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -118,S

	LDA -78,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -78,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDA 42,S
	PSHU A

	ANDA #$F0
	ORA #$0d
	STA 42,S

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA -38,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$03
	LDB #$ab
	STD 40,S

	LDD #$2bdd
	STD -120,S

	LDA #$22
	STD -40,S

	LDB #$d0
	STD -80,S

	LDD 121,S
	PSHU D

	LDA #$bb
	ANDB #$0F
	ORB #$10
	STD 121,S

	PULS A,X
	PSHU A,X,S

	LDA #$32
	LDX #$0bdc
	PSHS A,X

	LEAS 281,S

	LDA ,S
	PSHU A

	LDA -80,S
	PSHU A

	LDA -40,S
	PSHU A

	LDA 80,S
	PSHU A

	LDA #$99
	STA -80,S

	LDA -120,S
	PSHU A

	LDA 40,S
	PSHU A,S

	LDA #$a9
	STA 80,S

	LDA #$ab
	STA -120,S

	LDA 120,S
	PSHU A

	LDA #$0d
	STA ,S

	LDA #$3a
	STA -40,S

	LDA #$aa
	STA 40,S

	LDA #$1a
	STA 120,S

	LEAS 280,S

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$0f
	LDB #$ee
	STD 80,S

	LDD -40,S
	PSHU D

	ANDA #$0F
	ANDB #$0F
	ADDD #$e0a0
	STD -40,S

	LDA -120,S
	PSHU A

	LDD 120,S
	PSHU D,S

	LDD ,S
	PSHU D

	ANDA #$0F
	ANDB #$0F
	ADDD #$00a0
	STD ,S

	LDA #$1e
	STA -120,S

	LDA 41,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 41,S

	LDA -80,S
	PSHU A

	LDA #$10
	STA -80,S

	LDD #$f211
	STD 120,S

	LEAS 180,S

	LDD 20,S
	PSHU D,S

	LDD -20,S
	PSHU D

	LDD #$ff11
	STD -20,S

	LDD #$ee00
	STD 20,S


	LDS $9F00+2
	STS ERASE_POS_HWL6_2+2
	LDU #ERASE_DATA_HWL6_END

	LEAS 503,S

	LDD -61,S
	PSHU D

	LDD -22,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$a1
	STD -22,S

	LDA 20,S
	PSHU A

	LDA -20,S
	PSHU A

	LDD 58,S
	PSHU D,S

	ANDA #$F0
	ORA #$0d
	LDB #$32
	STD 58,S

	LDA #$dd
	STA 20,S

	LDD #$cdcc
	STD -61,S

	STA -20,S

	LDD 18,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$c2
	STD 18,S

	LDA 60,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 60,S

	LEAS 218,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$aa
	STD -40,S

	LDA -38,S
	PSHU A

	LDA -78,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -78,S

	LDD -120,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$32
	STD -120,S

	LDD -80,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$aa
	STD -80,S

	LDA #$cc
	STA -38,S

	PULS A,X
	PSHU A,X,S

	LDA #$ca
	LDX #$cbdc
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$ca
	LDX #$cadd
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$cc
	LDX #$aadd
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$d0
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

	LDD #$90ac
	STD 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$90
	LDX #$aadd
	PSHS A,X

	LEAS 80,S

	PULS A,X
	PSHU A,X,S

	LDA #$09
	LDX #$b2cc
	PSHS A,X

	LEAS 40,S

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$01
	LDB #$23
	STD 80,S

	LDA 82,S
	PSHU A

	LDA 42,S
	PSHU A

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$02
	LDB #$22
	STD 40,S

	LDA #$dd
	STA 42,S

	STA 82,S

	LDD 121,S
	PSHU D

	LDD #$2dad
	STD 121,S

	PULS A,X
	PSHU A,X,S

	LDA #$09
	LDX #$22dc
	PSHS A,X

	LEAS 281,S

	LDD -80,S
	PSHU D

	ANDA #$F0
	ORA #$03
	LDB #$ba
	STD -80,S

	LDD -120,S
	PSHU D

	LDD #$1eba
	STD -120,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$02
	LDB #$ba
	STD -40,S

	LDD ,S
	PSHU D

	ANDA #$F0
	ORA #$02
	LDB #$ba
	STD ,S

	LDD 40,S
	PSHU D,S

	ANDA #$F0
	ORA #$02
	LDB #$aa
	STD 40,S

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$03
	LDB #$a9
	STD 80,S

	LDD 120,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$d1
	STD 120,S

	LEAS 281,S

	LDD -1,S
	PSHU D

	ANDA #$F0
	ANDB #$F0
	ADDD #$0f0d
	STD -1,S

	LDD -41,S
	PSHU D

	ANDA #$F0
	ORA #$0f
	LDB #$cd
	STD -41,S

	LDA -80,S
	PSHU A

	LDA -120,S
	PSHU A

	LDA #$c0
	STA -80,S

	LDA #$de
	STA -120,S

	LDD 39,S
	PSHU D,S

	ANDA #$F0
	ANDB #$F0
	ADDD #$0f0d
	STD 39,S

	LDD 79,S
	PSHU D

	ANDA #$F0
	ANDB #$F0
	ADDD #$010b
	STD 79,S

	LDD 119,S
	PSHU D

	ANDA #$F0
	ANDB #$F0
	ADDD #$010a
	STD 119,S

	LEAS 239,S

	LDD -80,S
	PSHU D

	ANDA #$F0
	ORA #$0e
	LDB #$a1
	STD -80,S

	LDA 1,S
	PSHU A

	LDA -39,S
	PSHU A

	LDD 40,S
	PSHU D,S

	ANDA #$F0
	ORA #$0f
	LDB #$fa
	STD 40,S

	LDA #$ba
	STA -39,S

	STB 1,S

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$01
	LDB #$e0
	STD 80,S

SSAV_HWL6
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HWL6
	PSHS U,DP
	STS ERASE_SSAV_HWL6+2

ERASE_POS_HWL6_1
	LDS #$0000
	LDU #ERASE_DATA_HWL6_1

ERASE_CODE_HWL6_1
	PULU D,X,S
	STD -20,S
	STX 20,S

	PULU A,B,X,Y,S
	STA -80,S
	STB 41,S
	STX ,S
	STY 120,S

	PULU A,X,Y
	STA -120,S
	STX -40,S
	STY 80,S

	PULU A,B,S
	STA 120,S
	STB 40,S

	PULU A,B
	STA -120,S
	STB 80,S

	PULU A,B
	STA -40,S
	STB -80,S

	PULU A
	STA ,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 121,S
	STX 40,S

	PULU A,B,X,Y
	STA -38,S
	STB 42,S
	STX -80,S
	STY -120,S

	PULU A,B,X,Y
	STA -78,S
	STB -118,S
	STX -40,S
	STY 81,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 120,S
	STX 40,S
	STY 80,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -40,S
	STX -120,S

	PULU A,B,X
	STA -38,S
	STB -78,S
	STX -80,S

	PULU D,X,S
	STD -41,S
	STX 119,S

	PULU A,X,Y
	STA -80,S
	STX 79,S
	STY 39,S

	PULU A,B,X
	STA -39,S
	STB -120,S
	STX -1,S

ERASE_POS_HWL6_2
	LDS #$0000
	LDU #ERASE_DATA_HWL6_2

ERASE_CODE_HWL6_2
	PULU D,X,S
	STD 80,S
	STX 40,S

	PULU A,B,X
	STA -39,S
	STB 1,S
	STX -80,S

	PULU D,X,Y,S
	STD 119,S
	STX 79,S
	STY 39,S

	PULU A,B,X,Y
	STA -120,S
	STB -80,S
	STX -41,S
	STY -1,S

	PULU D,X,Y,S
	STD 120,S
	STX 80,S
	STY 40,S

	PULU D,X,Y
	STD ,S
	STX -40,S
	STY -120,S

	PULU D
	STD -80,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 121,S
	STX 40,S

	PULU A,B,X
	STA 42,S
	STB 82,S
	STX 80,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA 42,S
	STX 40,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -80,S
	STX -120,S

	PULU A,B,X
	STA -78,S
	STB -38,S
	STX -40,S

	PULU A,X,Y,S
	STA 60,S
	STX 18,S
	STY 58,S

	PULU A,B,X,Y
	STA -20,S
	STB 20,S
	STX -22,S
	STY -61,S

ERASE_SSAV_HWL6
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HWL6_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HWL6_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWL6_END
