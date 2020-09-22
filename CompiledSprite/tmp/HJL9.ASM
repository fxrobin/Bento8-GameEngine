(main)IMG.ASM
	ORG $A6FE
DRAW_HJL9
	PSHS U,DP
	STS SSAV_HJL9+2

	LDS $9F00
	STS ERASE_POS_HJL9_1+2
	LDU #ERASE_DATA_HJL9_2
	LEAS 663,S

	LDD 100,S
	PSHU D

	LDA -100,S
	PSHU A

	LDD 19,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD 19,S

	LDD 98,S
	PSHU D

	ANDA #$F0
	ORA #$0f
	LDB #$99
	STD 98,S

	LDA 61,S
	PSHU A

	LDA -60,S
	PSHU A

	LDD 59,S
	PSHU D,S

	ANDA #$F0
	ORA #$00
	LDB #$c2
	STD 59,S

	LDD -21,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$cc
	STD -21,S

	STB 61,S

	LDA #$aa
	STA -100,S

	STA -60,S

	LDA -19,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -19,S

	LDA 21,S
	PSHU A

	LDA #$ca
	STA 21,S

	LDD #$cddc
	STD 100,S

	LEAS 258,S

	LDD -38,S
	PSHU D

	LDD -80,S
	PSHU D

	ANDA #$F0
	ORA #$0f
	LDB #$2c
	STD -80,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$01
	LDB #$ba
	STD -40,S

	LDD -118,S
	PSHU D

	LDD -78,S
	PSHU D

	LDD -120,S
	PSHU D

	ANDA #$F0
	ORA #$0f
	LDB #$2c
	STD -120,S

	LDD #$ccdc
	STD -118,S

	LDB #$dd
	STD -78,S

	STD -38,S

	PULS D,X
	PSHU D,X,S

	LDD #$f1ba
	LDX #$ccdd
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$f1ba
	LDX #$ccdd
	PSHS D,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$f1
	LDX #$accc
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$f1
	LDX #$cacc
	PSHS A,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$f1c2
	LDX #$cddc
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$f1ac
	LDX #$ccdc
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$f1ca
	LDX #$dddc
	PSHS D,X

	LEAS 40,S

	LDD 82,S
	PSHU D

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$c2
	STD 80,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$a3
	STD 40,S

	LDD 122,S
	PSHU D

	LDD 42,S
	PSHU D

	LDD 120,S
	PSHU D

	ANDA #$F0
	ORA #$0f
	LDB #$c2
	STD 120,S

	LDD #$dddd
	STD 82,S

	STD 42,S

	STD 122,S

	PULS D,X
	PSHU D,X,S

	LDD #$f1ca
	LDX #$dddd
	PSHS D,X

	LEAS 281,S

	LDD -79,S
	PSHU D

	ANDA #$F0
	ANDB #$F0
	ADDD #$0d0d
	STD -79,S

	LDA -40,S
	PSHU A

	LDA #$dc
	STA -40,S

	LDA 80,S
	PSHU A

	LDD -121,S
	PSHU D

	ANDA #$F0
	ORA #$0f
	LDB #$ad
	STD -121,S

	LDD -81,S
	PSHU D

	ANDA #$F0
	ORA #$0f
	LDB #$9c
	STD -81,S

	LDA 40,S
	PSHU A

	LDA ,S
	PSHU A

	LDD -119,S
	PSHU D,S

	ANDA #$F0
	ANDB #$F0
	ADDD #$0d0d
	STD -119,S

	LDA #$cd
	STA ,S

	LDA -38,S
	PSHU A

	ANDA #$F0
	ORA #$0d
	STA -38,S

	LDA #$dd
	STA 80,S

	STA 40,S

	LDA 121,S
	PSHU A

	ANDA #$F0
	ORA #$0d
	STA 121,S

	LEAS 161,S

	LDA ,S
	PSHU A,S

	ANDA #$F0
	ORA #$0d
	STA ,S


	LDS $9F00+2
	STS ERASE_POS_HJL9_2+2
	LDU #ERASE_DATA_HJL9_END

	LEAS 681,S

	LDD -39,S
	PSHU D

	LDD -79,S
	PSHU D

	LDA -119,S
	PSHU A

	ANDA #$F0
	ORA #$0a
	STA -119,S

	LDD #$accc
	STD -79,S

	LDD #$ccac
	STD -39,S

	PULS A,X
	PSHU A,X,S

	LDA #$fa
	LDX #$dcdc
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$19
	LDX #$cadc
	PSHS A,X

	LEAS 40,S

	LDD 41,S
	PSHU D

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 3,S

	STX 41,S

	LDA 43,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA 43,S

	LDD 81,S
	PSHU D

	LDD #$ccdc
	STD 81,S

	LDA 83,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA 83,S

	PULS A,X
	PSHU A,X,S

	LDA #$e0
	LDX #$cadc
	PSHS A,X

	LEAS 120,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$9a
	LDX #$accc
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$aa
	LDX #$cccd
	PSHS A,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$aa2c
	LDX #$ccdc
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$ac23
	LDX #$dddc
	PSHS D,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$F0
	ORA #$0d
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$ac
	LDX #$21cd
	PSHS A,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$cc
	STD 40,S

	LDA 3,S
	PSHU A

	ANDA #$F0
	ORA #$0d
	STA 3,S

	LDA 82,S
	PSHU A

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$cc
	STD 80,S

	LDD 42,S
	PSHU D

	LDA #$dd
	ANDB #$F0
	ORB #$0d
	STD 42,S

	STA 82,S

	PULS A,X
	PSHU A,X,S

	LDA #$ac
	LDX #$3cdd
	PSHS A,X

	LEAS 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$ac
	LDX #$dddd
	PSHS A,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$aadd
	STD 40,S

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 42,S

	LDD #$19cd
	STD 80,S

	LDA 82,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 82,S

	PULS A,X
	PSHU A,X,S

	LDA #$9a
	LDX #$dcdd
	PSHS A,X

	LEAS 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$fe
	LDX #$cddc
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$f1
	LDX #$dddc
	PSHS A,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ANDB #$F0
	ADDD #$0d0d
	STD 40,S

	LDA 82,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 82,S

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 42,S

	LDD 80,S
	PSHU D

	ANDA #$F0
	ANDB #$F0
	ADDD #$0d0d
	STD 80,S

	LDD 121,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0dd0
	STD 121,S

	PULS A,X
	PSHU A,X,S

	LDA #$1e
	LDX #$dddc
	PSHS A,X

SSAV_HJL9
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HJL9
	PSHS U,DP
	STS ERASE_SSAV_HJL9+2

ERASE_POS_HJL9_1
	LDS #$0000
	LDU #ERASE_DATA_HJL9_1

ERASE_CODE_HJL9_1
	PULU A,S
	STA ,S

	PULU A,B,X,S
	STA 121,S
	STB -38,S
	STX -119,S

	PULU A,B,X,Y
	STA ,S
	STB 40,S
	STX -81,S
	STY -121,S

	PULU A,B,X
	STA 80,S
	STB -40,S
	STX -79,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 120,S
	STX 42,S
	STY 122,S

	PULU D,X,Y
	STD 40,S
	STX 80,S
	STY 82,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD -120,S
	STX -78,S
	STY -118,S

	PULU D,X,Y
	STD -40,S
	STX -80,S
	STY -38,S

	PULU A,B,X,Y,S
	STA 21,S
	STB -19,S
	STX -21,S
	STY 59,S

	PULU A,B,X,Y
	STA -60,S
	STB 61,S
	STX 98,S
	STY 19,S

	PULU A,X
	STA -100,S
	STX 100,S

ERASE_POS_HJL9_2
	LDS #$0000
	LDU #ERASE_DATA_HJL9_2

ERASE_CODE_HJL9_2
	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 121,S
	STX 80,S

	PULU A,B,X
	STA 42,S
	STB 82,S
	STX 40,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA 82,S
	STB 42,S
	STX 80,S
	STY 40,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 42,S
	STX 80,S

	PULU A,B,X
	STA 82,S
	STB 3,S
	STX 40,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

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

	PULU A,X
	STA 83,S
	STX 81,S

	PULU A,B,X
	STA 43,S
	STB 3,S
	STX 41,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA -119,S
	STX -79,S
	STY -39,S

ERASE_SSAV_HJL9
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HJL9_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HJL9_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJL9_END
