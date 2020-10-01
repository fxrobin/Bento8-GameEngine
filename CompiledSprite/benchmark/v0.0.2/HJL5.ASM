(main)IMG.ASM
	ORG $A707
DRAW_HJL5
	PSHS U
	STS SSAV_HJL5+2

	LDS $9F00
	LDU #ERASE_DATA_HJL5_2
	LEAS 562,S

	LDD ,S
	PSHU S,D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0aa0
	STD ,S
	LEAS 160,S

	LDX -80,S
	LDY -40,S
	PSHU Y,X
	LDD #$aaca
	STD -80,S
	STD -40,S
	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -78,S
	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$f0
	STA -38,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0aa0
	STD -120,S
	PULS A,X
	PSHU S,X,A
	LDA #$aa
	LDX #$da11
	PSHS A,X
	LEAS 40,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ac
	STD 39,S
	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ac
	STD 79,S
	LDD 119,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ba
	STD 119,S
	LDX 41,S
	LDY 81,S
	PSHU Y,X
	LDD 121,S
	PSHU D
	LDD #$ac11
	STD 41,S
	LDA #$dd
	STD 81,S
	LDB #$aa
	STD 121,S
	PULS A,X
	PSHU S,X,A
	LDA #$ac
	LDX #$ac1e
	PSHS A,X
	LEAS 280,S

	LDX -79,S
	LDY 40,S
	PSHU Y,X
	LDD #$ca22
	STD 40,S
	LDD -39,S
	LDX -119,S
	PSHU X,D
	LDD 81,S
	PSHU D
	LDA #$c2
	ANDB #$0F
	ORB #$a0
	STD 81,S
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 42,S
	LDD #$dd91
	STD -79,S
	LDD #$cdaa
	STD -119,S
	LDB #$a1
	STD -39,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ba
	STD -121,S
	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ba
	STD -81,S
	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ac
	STD -41,S
	LDD 79,S
	PSHU D
	ANDA #$0F
	ORA #$a0
	LDB #$cc
	STD 79,S
	PULS A,X
	PSHU S,X,A
	LDX #$dd91
	PSHS B,X
	LEAS 119,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$aa
	LDX #$cc2c
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$ca
	LDX #$ac31
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$ca
	LDX #$acdd
	PSHS A,X
	LEAS 40,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ac
	STD 40,S
	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD 80,S
	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 120,S
	LDD 42,S
	PSHU D
	LDA #$9a
	ANDB #$F0
	ORB #$01
	STD 42,S
	LDD 82,S
	PSHU D
	LDA #$aa
	ANDB #$F0
	ORB #$0f
	STD 82,S
	LDD 122,S
	PSHU D
	LDA #$aa
	ANDB #$F0
	ORB #$01
	STD 122,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$ccac
	LDX #$d9a1
	PSHS D,X
	LEAS 261,S

	LDX 20,S
	LDY -20,S
	PSHU Y,X
	LDD #$dcdd
	STD -20,S
	LDA #$3d
	STD 20,S
	LDD -60,S
	LDX -100,S
	PSHU X,D
	LDD #$cda0
	STD -100,S
	LDB #$9a
	STD -60,S
	LDD 60,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0dd0
	STD 60,S
	LDA 100,S
	PSHU S,A
	ANDA #$F0
	ORA #$0d
	STA 100,S

	LDS $9F00+2
	LDU #ERASE_DATA_HJL5_END

	LEAS 663,S

	LDA -20,S
	LDB -60,S
	PSHU B,A
	ANDB #$0F
	ORB #$a0
	STB -60,S
	LDA #$cd
	STA -20,S
	LDD 18,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$a00a
	STD 18,S
	LDD 58,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$a00a
	STD 58,S
	LDA 20,S
	LDB 60,S
	PSHU S,B,A
	LDA #$dd
	STA 20,S
	LDA #$df
	STA 60,S
	LEAS 218,S

	LDD -120,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$a00a
	STD -120,S
	LDA -118,S
	PSHU A
	LDA #$c2
	STA -118,S
	LDD -80,S
	PSHU D
	ANDA #$0F
	ORA #$a0
	LDB #$aa
	STD -80,S
	LDD -40,S
	PSHU D
	ANDA #$0F
	ORA #$c0
	LDB #$cc
	STD -40,S
	LDA -78,S
	LDB 3,S
	PSHU B,A
	ANDB #$0F
	ORB #$90
	STB 3,S
	LDA #$a2
	STA -78,S
	LDD -38,S
	PSHU D
	LDA #$a9
	ANDB #$0F
	ORB #$00
	STD -38,S
	PULS A,X
	PSHU S,X,A
	LDA #$ca
	LDX #$ccca
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$ca
	LDX #$ccd0
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$ca
	LDX #$ccdc
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$caac
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$ccaa
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$ccca
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$dc
	LDX #$cc9a
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$aa
	LDX #$cdaa
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$aa
	LDX #$ccca
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$aa
	LDX #$cd1a
	PSHS A,X
	LEAS 40,S

	LDX 40,S
	PSHU X
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 3,S
	LDD #$cadd
	STD 40,S
	LDD 42,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$a000
	STD 42,S
	PULS A,X
	PSHU S,X,A
	LDA #$aa
	LDX #$cca9
	PSHS A,X
	LEAS 80,S

	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$cd30
	PSHS A,X
	LEAS 40,S

	LDX 40,S
	LDD #$ddcd
	STD 40,S
	LDY 80,S
	PSHU Y,X
	LDB #$dd
	STD 80,S
	LDA 42,S
	PSHU A
	ANDA #$F0
	ORA #$00
	STA 42,S
	LDA 82,S
	PSHU A
	ANDA #$F0
	ORA #$00
	STA 82,S
	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 120,S
	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$dd00
	PSHS A,X
	LEAS 181,S

	LDA -20,S
	LDB 20,S
	PSHU S,B,A
	LDA #$dd
	STA -20,S
	STA 20,S
SSAV_HJL5
	LDS #$0000
	PULS U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HJL5
	PSHS U
	STS ERASE_SSAV_HJL5+2

ERASE_POS_HJL5_1
	LDU #ERASE_DATA_HJL5_1

ERASE_CODE_HJL5_1
	PULU A,S
	STA 100,S

	PULU D,X,Y
	STD 60,S
	STX -60,S
	STY -100,S

	PULU D,X
	STD 20,S
	STX -20,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 122,S
	STX 82,S
	STY 42,S

	PULU D,X,Y
	STD 120,S
	STX 80,S
	STY 40,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y
	STD 79,S
	STX -41,S
	STY -81,S

	PULU D
	STD -121,S

	PULU A,X,Y
	STA 42,S
	STX 81,S
	STY -39,S

	PULU D,X,Y
	STD -119,S
	STX -79,S
	STY 40,S

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y
	STD 121,S
	STX 41,S
	STY 81,S

	PULU D,X,Y
	STD 119,S
	STX 79,S
	STY 39,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD -120,S

	PULU A,B,X,Y
	STA -38,S
	STB -78,S
	STX -80,S
	STY -40,S

	PULU D,S
	STD ,S

	PULU A,B,S
	STA -20,S
	STB 20,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 120,S

	PULU A,B,X,Y
	STA 82,S
	STB 42,S
	STX 40,S
	STY 80,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 42,S

	PULU A,X
	STA 3,S
	STX 40,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD -38,S

	PULU A,B,X,Y
	STA -78,S
	STB 3,S
	STX -40,S
	STY -80,S

	PULU A,X
	STA -118,S
	STX -120,S

	PULU A,B,S
	STA 20,S
	STB 60,S

	PULU D,X
	STD 58,S
	STX 18,S

	PULU A,B
	STA -20,S
	STB -60,S

ERASE_SSAV_HJL5
	LDS #$0000
	PULS U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HJL5_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJL5_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HJL5_END
