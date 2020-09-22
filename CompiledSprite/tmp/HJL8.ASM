(main)IMG.ASM
	ORG $A000
DRAW_HJL8
	PSHS U,DP
	STS SSAV_HJL8+2

	LDS $9F00
	STS ERASE_POS_HJL8_1+2
	LDU #ERASE_DATA_HJL8_2
	LEAS 562,S

	LDD ,S
	PSHU D,S

	LDA #$f1
	ANDB #$0F
	ORB #$90
	STD ,S

	LDD 40,S
	PSHU D

	ANDA #$0F
	ANDB #$0F
	ADDD #$1000
	STD 40,S

	LDA -40,S
	PSHU A

	LDA #$ff
	STA -40,S

	LEAS 200,S

	LDD -39,S
	PSHU D

	LDA #$09
	ANDB #$0F
	ORB #$c0
	STD -39,S

	LDD 39,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$ac
	STD 39,S

	LDD 41,S
	PSHU D

	LDD -41,S
	PSHU D

	ANDA #$F0
	ORA #$0f
	LDB #$ac
	STD -41,S

	LDD -120,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$9c
	STD -120,S

	LDD -80,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$0a
	STD -80,S

	LDD 81,S
	PSHU D

	LDD 119,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$ba
	STD 119,S

	LDD 79,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$ac
	STD 79,S

	LDD 121,S
	PSHU D

	LDD #$ccca
	STD 41,S

	LDB #$cc
	STD 81,S

	LDA #$ca
	STD 121,S

	PULS A,X
	PSHU A,X,S

	LDA #$ac
	LDX #$cccc
	PSHS A,X

	LEAS 159,S

	PULS D,X
	PSHU D,X,S

	LDD #$ffb2
	LDX #$ccaa
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$f1ba
	LDX #$ccdd
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$f1ac
	LDX #$ccdd
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$f12c
	LDX #$ccdc
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$f12c
	LDX #$ccdc
	PSHS D,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$cd
	STD 40,S

	LDD 120,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 120,S

	LDD 42,S
	PSHU D

	LDD #$cccd
	STD 42,S

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$cd
	STD 80,S

	LDD 82,S
	PSHU D

	LDD 122,S
	PSHU D

	LDD #$dddd
	STD 82,S

	LDA #$dc
	STD 122,S

	PULS D,X
	PSHU D,X,S

	LDD #$d1cc
	LDX #$ccdd
	PSHS D,X

	LEAS 281,S

	LDD -119,S
	PSHU D

	LDD 41,S
	PSHU D

	ANDA #$F0
	ANDB #$F0
	ADDD #$0d0d
	STD 41,S

	LDA 82,S
	PSHU A

	ANDA #$F0
	ORA #$0d
	STA 82,S

	LDA -78,S
	PSHU A

	LDD 1,S
	PSHU D

	ANDA #$F0
	ANDB #$F0
	ADDD #$0d0d
	STD 1,S

	LDA -38,S
	PSHU A

	LDD -80,S
	PSHU D

	ANDA #$0F
	ORA #$d0
	LDB #$dd
	STD -80,S

	STB -78,S

	STB -38,S

	LDD #$dddd
	STD -119,S

	LDD 80,S
	PSHU D

	ANDA #$F0
	ANDB #$F0
	ADDD #$0d0d
	STD 80,S

	LDD -40,S
	PSHU D,S

	ANDA #$0F
	ORA #$d0
	LDB #$dd
	STD -40,S

	LDD -121,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$0d
	STD -121,S

	LDD 120,S
	PSHU D

	ANDA #$F0
	ANDB #$F0
	ADDD #$0d0d
	STD 120,S

	LEAS 201,S

	LDD -41,S
	PSHU D,S

	LDA ,S
	PSHU A

	LDD #$dddd
	STD -41,S

	STA ,S

	LDA 40,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 40,S


	LDS $9F00+2
	STS ERASE_POS_HJL8_2+2
	LDU #ERASE_DATA_HJL8_END

	LEAS 522,S

	LDA ,S
	PSHU A,S

	ANDA #$0F
	ORA #$10
	STA ,S

	LEAS 159,S

	LDA -80,S
	PSHU A

	ANDA #$F0
	ORA #$02
	STA -80,S

	LDA -120,S
	PSHU A

	ANDA #$F0
	ORA #$0f
	STA -120,S

	LDD -40,S
	PSHU D

	LDD #$ff90
	STD -40,S

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -38,S

	PULS A,X
	PSHU A,X,S

	LDA #$f1
	LDX #$e0cc
	PSHS A,X

	LEAS 40,S

	LDD 80,S
	PSHU D

	ANDA #$0F
	ORA #$10
	LDB #$c3
	STD 80,S

	LDD 40,S
	PSHU D

	ANDA #$0F
	ORA #$10
	LDB #$ac
	STD 40,S

	LDA 42,S
	PSHU A

	STB 42,S

	LDA 82,S
	PSHU A

	LDA #$cc
	STA 82,S

	PULS A,X
	PSHU A,X,S

	LDA #$fe
	LDX #$a2cc
	PSHS A,X

	LEAS 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$1a
	LDX #$ccac
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$aa
	LDX #$a3cc
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$aa
	LDX #$a3cc
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$ca
	LDX #$23cd
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$ca
	LDX #$23cd
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$aa
	LDX #$c1cd
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$aa
	LDX #$dccd
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$a9
	LDX #$ddcc
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$cc
	LDX #$dccc
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$cc
	LDX #$dddd
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$ddcd
	PSHS A,X

	LEAS 40,S

	LDD 42,S
	PSHU D

	LDA #$dd
	ANDB #$0F
	ORB #$c0
	STD 42,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	LDD 82,S
	PSHU D

	LDA #$dd
	ANDB #$0F
	ORB #$c0
	STD 82,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$d0
	STD 40,S

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 80,S

	PULS A,X
	PSHU A,X,S

	LDX #$0ddd
	PSHS B,X

	LEAS 120,S

	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDA #$dd
	ANDB #$0F
	ORB #$d0
	STD 81,S

	LDD 121,S
	PSHU D

	ANDA #$0F
	ANDB #$0F
	ADDD #$d0d0
	STD 121,S

	LDD #$dddd
	STD 41,S

	PULS A,X
	PSHU A,X,S

	LDX #$dddd
	PSHS B,X

	LEAS 202,S

	LDA 39,S
	PSHU A,S

	ANDA #$F0
	ORA #$0d
	STA 39,S

	LDA -40,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA -40,S

SSAV_HJL8
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HJL8
	PSHS U,DP
	STS ERASE_SSAV_HJL8+2

ERASE_POS_HJL8_1
	LDS #$0000
	LDU #ERASE_DATA_HJL8_1

ERASE_CODE_HJL8_1
	PULU A,B,X,S
	STA 40,S
	STB ,S
	STX -41,S

	PULU D,X,Y,S
	STD 120,S
	STX -121,S
	STY -40,S

	PULU D,X
	STD 80,S
	STX -80,S

	PULU A,X
	STA -38,S
	STX 1,S

	PULU A,B,X,Y
	STA -78,S
	STB 82,S
	STX 41,S
	STY -119,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 122,S
	STX 82,S
	STY 80,S

	PULU D,X,Y
	STD 42,S
	STX 120,S
	STY 40,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 121,S
	STX 79,S
	STY 119,S

	PULU D,X,Y
	STD 81,S
	STX -80,S
	STY -120,S

	PULU D,X,Y
	STD -41,S
	STX 41,S
	STY 39,S

	PULU D
	STD -39,S

	PULU A,X,Y,S
	STA -40,S
	STX 40,S
	STY ,S

ERASE_POS_HJL8_2
	LDS #$0000
	LDU #ERASE_DATA_HJL8_2

ERASE_CODE_HJL8_2
	PULU A,B,S
	STA -40,S
	STB 39,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 121,S
	STX 81,S
	STY 41,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 80,S
	STX 40,S
	STY 82,S

	PULU A,X
	STA 3,S
	STX 42,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA 82,S
	STB 42,S
	STX 40,S
	STY 80,S

	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA -38,S
	STX -40,S

	PULU A,B
	STA -120,S
	STB -80,S

	PULU A,S
	STA ,S

ERASE_SSAV_HJL8
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HJL8_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJL8_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJL8_END
