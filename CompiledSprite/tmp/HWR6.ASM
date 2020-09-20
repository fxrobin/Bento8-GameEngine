(main)IMG.ASM
	ORG $DCB8
DRAW_HWR6
	PSHS U,DP
	STS SSAV_HWR6+2

	LDS $9F00
	STS ERASE_POS_HWR6_1+2
	LDU #ERASE_DATA_HWR6_2
	LEAS 503,S
	LDA -19,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -19,S

	LDA 21,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 21,S

	LDD 59,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$23
	STD 59,S

	LDA 61,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 61,S

	LDD -61,S
	PSHU D

	LDD -21,S
	PSHU D

	LDD 19,S
	PSHU D,S

	LDD #$ccdc
	STD -61,S

	LDD #$dc1a
	STD -21,S

	LDD #$dd2c
	STD 19,S

	LEAS 219,S
	LDD -119,S
	PSHU D
	LDA #$23
	ANDB #$0F
	ORB #$a0
	STD -119,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$aa
	STD -80,S

	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -78,S

	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -38,S

	LDD -40,S
	PSHU D

	LDD #$ccaa
	STD -40,S

	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$bcac
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$acac
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$aacc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$aa0d
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

	LDA #$09
	STA 42,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$aa09
	PSHS A,X

	LEAS 80,S
	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$2b90
	PSHS A,X

	LEAS 40,S
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$20
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

	LDD 120,S
	PSHU D

	LDD #$dad2
	STD 120,S

	LDD #$dd32
	STD 80,S

	LDB #$22
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$2290
	PSHS A,X

	LEAS 280,S
	LDD -80,S
	PSHU D
	LDA #$ab
	ANDB #$0F
	ORB #$30
	STD -80,S

	LDD -40,S
	PSHU D
	LDA #$ab
	ANDB #$0F
	ORB #$20
	STD -40,S

	LDD ,S
	PSHU D
	LDA #$ab
	ANDB #$0F
	ORB #$20
	STD ,S

	LDD 40,S
	PSHU D
	LDA #$aa
	ANDB #$0F
	ORB #$20
	STD 40,S

	LDD 80,S
	PSHU D
	LDA #$9a
	ANDB #$0F
	ORB #$30
	STD 80,S

	LDD 120,S
	PSHU D
	LDA #$1d
	ANDB #$0F
	ORB #$a0
	STD 120,S

	LDD -120,S
	PSHU D,S

	LDD #$abe1
	STD -120,S

	LEAS 280,S
	LDD -40,S
	PSHU D
	LDA #$dc
	ANDB #$0F
	ORB #$f0
	STD -40,S

	LDD ,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$d0f0
	STD ,S

	LDD 40,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$d0f0
	STD 40,S

	LDD 80,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$b010
	STD 80,S

	LDD 120,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$a010
	STD 120,S

	LDA -120,S
	PSHU A

	LDA -80,S
	PSHU A,S

	LDA #$ed
	STA -120,S

	LDA #$0c
	STA -80,S

	LEAS 240,S
	LDD -80,S
	PSHU D
	LDA #$1a
	ANDB #$0F
	ORB #$e0
	STD -80,S

	LDD 40,S
	PSHU D
	LDA #$af
	ANDB #$0F
	ORB #$f0
	STD 40,S

	LDD 80,S
	PSHU D
	LDA #$0e
	ANDB #$0F
	ORB #$10
	STD 80,S

	LDA -40,S
	PSHU A

	LDA ,S
	PSHU A,S

	LDA #$ab
	STA -40,S

	LDA #$af
	STA ,S


	LDS $9F00+2
	STS ERASE_POS_HWR6_2+2
	LDU #ERASE_DATA_HWR6_END

	LEAS 522,S
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

	LDA #$cc
	STA -120,S

	LDD #$ddac
	STD ,S

	LDB #$aa
	STD 40,S

	STB -80,S

	LDA #$cd
	STD 80,S

	STD 120,S

	LEAS 279,S
	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -80,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -40,S

	LDD -119,S
	PSHU D

	LDA -78,S
	PSHU A

	LDA -38,S
	PSHU A

	LDD #$cdda
	STD -119,S

	LDA #$bc
	STA -78,S

	LDA #$ba
	STA -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$ccbb
	PSHS A,X

	LEAS 40,S
	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDD #$dcbb
	STD 81,S

	STX 41,S

	LDB #$ab
	STD 121,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$ccbb
	PSHS A,X

	LEAS 280,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dd
	STD -120,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$0d
	STD -80,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD -40,S

	LDD 40,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$ba
	STD 40,S

	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$30
	STA 42,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$03
	LDB #$bb
	STD 80,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$bb
	STD 120,S

	LDA -118,S
	PSHU A

	LDA -78,S
	PSHU A

	LDA -38,S
	PSHU A

	LDA #$b2
	STA -118,S

	LDA #$22
	STA -78,S

	STA -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$b023
	PSHS A,X

	LEAS 281,S
	LDA -120,S
	PSHU A

	LDA -80,S
	PSHU A

	LDA -40,S
	PSHU A

	LDA ,S
	PSHU A

	LDA 40,S
	PSHU A

	LDA 80,S
	PSHU A

	LDA 120,S
	PSHU A,S

	LDA #$ba
	STA -120,S

	LDA #$99
	STA -80,S

	LDA #$a3
	STA -40,S

	LDA #$d0
	STA ,S

	LDA #$aa
	STA 40,S

	LDA #$9a
	STA 80,S

	LDA #$a1
	STA 120,S

	LEAS 280,S
	LDD -41,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$0a0e
	STD -41,S

	LDD -1,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$0a00
	STD -1,S

	LDA 39,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA 39,S

	LDD 79,S
	PSHU D
	LDA #$ee
	ANDB #$0F
	ORB #$f0
	STD 79,S

	LDA -120,S
	PSHU A

	LDA -80,S
	PSHU A

	LDD 119,S
	PSHU D,S

	LDA #$e1
	STA -120,S

	LDA #$01
	STA -80,S

	LDD #$112f
	STD 119,S

	LEAS 179,S
	LDD -20,S
	PSHU D

	LDD 20,S
	PSHU D,S

	LDD #$11ff
	STD -20,S

	LDD #$00ee
	STD 20,S

SSAV_HWR6
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HWR6
	PSHS U,DP
	STS ERASE_SSAV_HWR6+2

ERASE_POS_HWR6_1
	LDS #$0000
	LDU #ERASE_DATA_HWR6_1

ERASE_CODE_HWR6_1
	PULU A,S
	STA ,S

	PULU A,X,Y
	STA -40,S
	STX 80,S
	STY 40,S

	PULU D
	STD -80,S

	PULU A,S
	STA -80,S

	PULU A,X,Y
	STA -120,S
	STX 120,S
	STY 80,S

	PULU D,X,Y
	STD 40,S
	STX ,S
	STY -40,S

	PULU D,S
	STD -120,S

	PULU D,X,Y
	STD 120,S
	STX 80,S
	STY 40,S

	PULU D,X,Y
	STD ,S
	STX -40,S
	STY -80,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 120,S
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

	PULU D
	STD -40,S

	PULU A,B,X,Y
	STA -38,S
	STB -78,S
	STX -80,S
	STY -119,S

	PULU D,S
	STD 19,S

	PULU D,X
	STD -21,S
	STX -61,S

	PULU A,X
	STA 61,S
	STX 59,S

	PULU A,B
	STA 21,S
	STB -19,S

ERASE_POS_HWR6_2
	LDS #$0000
	LDU #ERASE_DATA_HWR6_2

ERASE_CODE_HWR6_2
	PULU D,S
	STD 20,S

	PULU D
	STD -20,S

	PULU D,S
	STD 119,S

	PULU A,B,X
	STA -80,S
	STB -120,S
	STX 79,S

	PULU A,X,Y
	STA 39,S
	STX -1,S
	STY -41,S

	PULU A,S
	STA 120,S

	PULU A,B
	STA 80,S
	STB 40,S

	PULU A,B
	STA ,S
	STB -40,S

	PULU A,B
	STA -80,S
	STB -120,S

	PULU B,X,S
	PSHS B,X

	PULU A,B
	STA -38,S
	STB -78,S

	PULU A,X,Y
	STA -118,S
	STX 120,S
	STY 80,S

	PULU A,X,Y
	STA 42,S
	STX 40,S
	STY -40,S

	PULU D,X
	STD -80,S
	STX -120,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 121,S
	STX 81,S
	STY 41,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA -38,S
	STB -78,S
	STX -119,S
	STY -40,S

	PULU D
	STD -80,S

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

ERASE_SSAV_HWR6
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HWR6_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWR6_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWR6_END
