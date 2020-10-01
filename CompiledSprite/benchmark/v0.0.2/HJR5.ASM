(main)IMG.ASM
	ORG $A000
DRAW_HJR5
	PSHS U
	STS SSAV_HJR5+2

	LDS $9F00
	LDU #ERASE_DATA_HJR5_2
	LEAS 723,S

	LDA -81,S
	LDX 79,S
	PSHU X,A
	LDA -121,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA -121,S
	LDA -39,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA -39,S
	LDA 1,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA 1,S
	LDA 41,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA 41,S
	LDA 81,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA 81,S
	LDA #$dc
	STA -81,S
	LDD -41,S
	PSHU D
	LDA #$dd
	ANDB #$0F
	ORB #$a0
	STD -41,S
	LDD -1,S
	PSHU D
	LDA #$fd
	ANDB #$0F
	ORB #$a0
	STD -1,S
	LDD 39,S
	PSHU D
	LDA #$2c
	ANDB #$0F
	ORB #$a0
	STD 39,S
	LDD 120,S
	PSHU D
	LDA #$cc
	ANDB #$F0
	ORB #$0c
	STD 120,S
	LDD #$2aaa
	STD 79,S
	LDD 118,S
	PSHU S,D
	ANDA #$F0
	ORA #$00
	LDB #$9a
	STD 118,S
	LEAS 279,S

	LDX 1,S
	LDY 81,S
	PSHU Y,X
	LDD -119,S
	LDX -39,S
	LDY -79,S
	PSHU Y,X,D
	LDD 121,S
	LDX 41,S
	PSHU X,D
	LDD #$ccac
	STD -119,S
	STD -79,S
	STD -39,S
	LDB #$cd
	STD 121,S
	LDB #$cc
	STD 41,S
	STD 81,S
	LDA #$ac
	STD 1,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$ac
	STD -121,S
	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$0d
	STD -81,S
	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$cd
	STD -41,S
	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$ca
	STD -1,S
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$aa
	STD 39,S
	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$ac
	STD 79,S
	LDD 119,S
	PSHU S,D
	ANDA #$F0
	ORA #$0e
	LDB #$a9
	STD 119,S
	LEAS 180,S

	LDD -21,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$aa
	STD -21,S
	LDD 19,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$ac
	STD 19,S
	LDX -19,S
	LDD #$dcaa
	STD -19,S
	LDY 21,S
	PSHU S,Y,X
	LDA #$cc
	STD 21,S
	LEAS 180,S

	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$a1
	STD -121,S
	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$9a
	STD -81,S
	LDX -119,S
	LDD #$dcaa
	STD -119,S
	LDY -79,S
	PSHU Y,X
	LDA #$cc
	STD -79,S
	LDD -41,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$000a
	STD -41,S
	LDX -39,S
	PSHU X
	LDD #$ddac
	STD -39,S
	PULS A,X
	PSHU S,X,A
	LDA #$03
	LDX #$dccc
	PSHS A,X
	LEAS 40,S

	LDD 40,S
	PSHU D
	ANDA #$0F
	ORA #$00
	LDB #$dc
	STD 40,S
	LDD 80,S
	PSHU D
	ANDA #$0F
	ORA #$00
	LDB #$dd
	STD 80,S
	LDA 42,S
	LDB 82,S
	PSHU B,A
	LDD 121,S
	PSHU D
	LDA #$dd
	ANDB #$0F
	ORB #$d0
	STD 121,S
	STA 42,S
	STA 82,S
	PULS A,X
	PSHU S,X,A
	LDA #$00
	LDX #$ddcc
	PSHS A,X
	LEAS 181,S

	LDA -20,S
	LDB 20,S
	PSHU S,B,A
	LDA #$dd
	STA -20,S
	STA 20,S

	LDS $9F00+2
	LDU #ERASE_DATA_HJR5_END

	LEAS 562,S

	LDD ,S
	PSHU S,D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0aa0
	STD ,S
	LEAS 159,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ac
	STD -80,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$ac
	STD -40,S
	LDA -78,S
	LDB -38,S
	PSHU B,A
	LDD -119,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0aa0
	STD -119,S
	LDA #$aa
	STA -78,S
	STA -38,S
	PULS A,X
	PSHU S,X,A
	LDA #$11
	LDX #$adaa
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$e1
	LDX #$caca
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$11
	LDX #$caca
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$11
	LDX #$ddca
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$aa
	LDX #$ddab
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$aa
	LDX #$dcab
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$19
	LDX #$ddab
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$1a
	LDX #$dcca
	PSHS A,X
	LEAS 40,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$22
	STD 40,S
	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$2c
	STD 80,S
	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$c2
	STD 120,S
	LDA 42,S
	LDX 122,S
	PSHU X,A
	LDA #$ac
	STA 42,S
	LDD 82,S
	PSHU D
	LDA #$cc
	ANDB #$F0
	ORB #$0a
	STD 82,S
	LDD #$ccaa
	STD 122,S
	PULS A,X
	PSHU S,X,A
	LDA #$19
	LDX #$ddcc
	PSHS A,X
	LEAS 240,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$13
	STD -80,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$dd
	STD -40,S
	LDD 40,S
	PSHU D
	ANDA #$0F
	ORA #$10
	LDB #$a9
	STD 40,S
	LDD 80,S
	PSHU D
	ANDA #$0F
	ORA #$f0
	LDB #$aa
	STD 80,S
	LDD 120,S
	PSHU D
	ANDA #$0F
	ORA #$10
	LDB #$aa
	STD 120,S
	LDX -78,S
	LDY -38,S
	PSHU Y,X
	LDD #$caac
	STD -78,S
	STD -38,S
	LDD 42,S
	PSHU D
	LDA #$ca
	ANDB #$0F
	ORB #$c0
	STD 42,S
	LDD 82,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$c0
	STD 82,S
	LDD 122,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$d0
	STD 122,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$1a9d
	LDX #$cacc
	PSHS D,X
	LEAS 262,S

	LDX -101,S
	LDY -61,S
	PSHU Y,X
	LDD 19,S
	LDX -21,S
	PSHU X,D
	LDD #$ddd3
	STD 19,S
	LDB #$cd
	STD -21,S
	LDD 59,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0dd0
	STD 59,S
	LDA 100,S
	PSHU S,A
	ANDA #$0F
	ORA #$d0
	STA 100,S
	LDD #$0adc
	STD -101,S
	LDA #$a9
	STD -61,S
SSAV_HJR5
	LDS #$0000
	PULS U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HJR5
	PSHS U
	STS ERASE_SSAV_HJR5+2

ERASE_POS_HJR5_1
	LDU #ERASE_DATA_HJR5_1

ERASE_CODE_HJR5_1
	PULU A,B,S
	STA -20,S
	STB 20,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 121,S

	PULU A,B,X,Y
	STA 42,S
	STB 82,S
	STX 80,S
	STY 40,S

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y
	STD -39,S
	STX -41,S
	STY -119,S

	PULU D,X,Y
	STD -79,S
	STX -81,S
	STY -121,S

	PULU D,X,S
	STD -19,S
	STX 21,S

	PULU D,X
	STD 19,S
	STX -21,S

	PULU D,S
	STD 119,S

	PULU D,X,Y
	STD 79,S
	STX 39,S
	STY -1,S

	PULU D,X,Y
	STD -41,S
	STX -81,S
	STY -121,S

	PULU D,X,Y
	STD 121,S
	STX 41,S
	STY -119,S

	PULU D,X,Y
	STD -39,S
	STX -79,S
	STY 1,S

	PULU D
	STD 81,S

	PULU D,S
	STD 118,S

	PULU D,X,Y
	STD 120,S
	STX 39,S
	STY -1,S

	PULU D
	STD -41,S

	PULU A,B
	STA 81,S
	STB 41,S

	PULU A,B
	STA 1,S
	STB -39,S

	PULU A,B,X
	STA -121,S
	STB -81,S
	STX 79,S

	PULU A,S
	STA 100,S

	PULU D,X,Y
	STD 59,S
	STX 19,S
	STY -21,S

	PULU D,X
	STD -101,S
	STX -61,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 122,S
	STX 82,S
	STY 42,S

	PULU D,X,Y
	STD -78,S
	STX -38,S
	STY 120,S

	PULU D,X,Y
	STD 80,S
	STX 40,S
	STY -40,S

	PULU D
	STD -80,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 82,S

	PULU A,X,Y
	STA 42,S
	STX 122,S
	STY 120,S

	PULU D,X
	STD 80,S
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

	PULU A,X,S
	PSHS A,X

	PULU D
	STD -119,S

	PULU A,B,X,Y
	STA -78,S
	STB -38,S
	STX -40,S
	STY -80,S

	PULU D,S
	STD ,S

ERASE_SSAV_HJR5
	LDS #$0000
	PULS U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HJR5_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HJR5_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJR5_END
