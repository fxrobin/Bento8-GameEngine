(main)IMG.ASM
	ORG $C8C1
DRAW_HRL9
	PSHS U,DP
	STS SSAV_HRL9+2

	LDS $9F00
	STS ERASE_POS_HRL9_1+2
	LDU #ERASE_DATA_HRL9_2
	LEAS 603,S

	LDD 39,S
	PSHU D

	LDA -120,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -120,S

	LDD -1,S
	PSHU D

	LDD -81,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$ac
	STD -81,S

	LDD #$acdd
	STD -1,S

	LDA #$a3
	STD 39,S

	LDD -41,S
	PSHU D,S

	LDD 79,S
	PSHU D

	LDA #$a3
	ANDB #$0F
	ORB #$c0
	STD 79,S

	LDD 119,S
	PSHU D

	LDD #$cacc
	STD -41,S

	LDA #$aa
	STD 119,S

	LEAS 280,S

	LDD -82,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$ac
	STD -82,S

	LDD -42,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$bc
	STD -42,S

	LDA -40,S
	PSHU A

	LDA -80,S
	PSHU A

	LDD 78,S
	PSHU D

	ANDA #$F0
	ORA #$09
	LDB #$ba
	STD 78,S

	LDD -121,S
	PSHU D

	LDD 118,S
	PSHU D

	ANDA #$F0
	ORA #$09
	LDB #$ba
	STD 118,S

	LDD 38,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$ba
	STD 38,S

	LDA 80,S
	PSHU A

	LDA 120,S
	PSHU A

	LDD 40,S
	PSHU D,S

	LDA #$cd
	ANDB #$0F
	ORB #$d0
	STD 40,S

	LDD #$dacc
	STD -121,S

	LDD -2,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$ba
	STD -2,S

	LDD ,S
	PSHU D

	LDA #$cd
	ANDB #$0F
	ORB #$c0
	STD ,S

	STA -80,S

	STA -40,S

	STA 80,S

	LDA #$dd
	STA 120,S

	LEAS 279,S

	LDD -121,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$ab
	STD -121,S

	LDD -81,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$b2
	STD -81,S

	LDA -119,S
	PSHU A

	LDA #$dc
	STA -119,S

	LDA -79,S
	PSHU A

	LDA #$dd
	STA -79,S

	LDD -40,S
	PSHU D

	LDD #$220d
	STD -40,S

	LDA -38,S
	PSHU A

	ANDA #$F0
	ORA #$0a
	STA -38,S

	PULS A,X
	PSHU A,X,S

	LDA #$22
	LDX #$d2aa
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$22
	LDX #$deea
	PSHS A,X

	LEAS 40,S

	LDD 42,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$09a0
	STD 42,S

	LDD 79,S
	PSHU D

	ANDA #$F0
	ORA #$01
	LDB #$a1
	STD 79,S

	LDA 81,S
	PSHU A

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 3,S

	LDD 40,S
	PSHU D

	ANDA #$0F
	ORA #$00
	LDB #$2d
	STD 40,S

	LDA #$dd
	STA 81,S

	LDD 119,S
	PSHU D

	ANDA #$F0
	ORA #$0e
	LDB #$9e
	STD 119,S

	LDD 121,S
	PSHU D

	LDA #$dc
	ANDB #$F0
	ORB #$01
	STD 121,S

	PULS A,X
	PSHU A,X,S

	LDA #$11
	LDX #$3dda
	PSHS A,X

	LEAS 240,S

	LDA 80,S
	PSHU A

	LDA 120,S
	PSHU A

	LDD -79,S
	PSHU D

	LDA #$00
	ANDB #$F0
	ORB #$0e
	STD -79,S

	LDA -81,S
	PSHU A

	ANDA #$F0
	ORA #$0e
	STA -81,S

	LDA 42,S
	PSHU A

	LDA -38,S
	PSHU A

	LDA 82,S
	PSHU A

	ANDA #$F0
	ORA #$0a
	STA 82,S

	LDD -40,S
	PSHU D

	ANDA #$0F
	ORA #$b0
	LDB #$ed
	STD -40,S

	LDA #$09
	STA 42,S

	LDA #$af
	STA 120,S

	STA 80,S

	LDA 40,S
	PSHU A

	LDA #$9e
	STA -38,S

	LDA #$b1
	STA 40,S

	LDA 122,S
	PSHU A

	ANDA #$F0
	ORA #$0f
	STA 122,S

	PULS A,X
	PSHU A,X,S

	LDA #$ba
	LDX #$d0a9
	PSHS A,X

	LEAS 281,S

	LDA -119,S
	PSHU A

	ANDA #$F0
	ORA #$0a
	STA -119,S

	LDA 121,S
	PSHU A

	LDA -121,S
	PSHU A

	LDA -41,S
	PSHU A

	ANDA #$F0
	ORA #$0e
	STA -41,S

	LDA 41,S
	PSHU A

	ANDA #$F0
	ORA #$0f
	STA 41,S

	LDA -79,S
	PSHU A

	ANDA #$F0
	ORA #$0a
	STA -79,S

	LDA #$91
	STA -121,S

	LDA 81,S
	PSHU A,S

	ANDA #$F0
	ORA #$01
	STA 81,S

	LDA -81,S
	PSHU A

	LDA #$e0
	STA -81,S

	STA 121,S


	LDS $9F00+2
	STS ERASE_POS_HRL9_2+2
	LDU #ERASE_DATA_HRL9_END

	LEAS 562,S

	LDD -40,S
	PSHU D

	LDA #$da
	ANDB #$0F
	ORB #$c0
	STD -40,S

	LDD 79,S
	PSHU D

	LDA 1,S
	PSHU A

	LDA 41,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 41,S

	LDD 39,S
	PSHU D,S

	LDD -1,S
	PSHU D

	ANDA #$0F
	ORA #$d0
	LDB #$1c
	STD -1,S

	LDA #$dd
	STA 1,S

	LDA -80,S
	PSHU A

	ANDA #$F0
	ORA #$0c
	STA -80,S

	LDD #$dc2d
	STD 39,S

	LDA #$da
	STD 79,S

	LEAS 239,S

	LDD -80,S
	PSHU D

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -38,S

	LDD -40,S
	PSHU D

	LDD -120,S
	PSHU D

	LDD #$aa2d
	STD -120,S

	LDB #$ad
	STD -40,S

	STD -80,S

	PULS A,X
	PSHU A,X,S

	LDA #$ac
	LDX #$bccc
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$aa
	LDX #$acdc
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$cb
	LDX #$acdd
	PSHS A,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 42,S

	LDA 122,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA 122,S

	LDD 120,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$0bcc
	STD 80,S

	LDB #$ac
	STD 40,S

	LDD #$9b2c
	STD 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$0b
	LDX #$acdd
	PSHS A,X

	LEAS 160,S

	PULS A,X
	PSHU A,X,S

	LDA #$92
	LDX #$2dcc
	PSHS A,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$222d
	LDX #$22aa
	PSHS D,X

	LEAS 40,S

	LDD 42,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$03
	LDB #$d0
	STD 40,S

	LDD 82,S
	PSHU D

	ANDA #$0F
	ORA #$d0
	LDB #$ab
	STD 82,S

	LDD 80,S
	PSHU D

	LDD #$ddbb
	STD 42,S

	LDD #$a901
	STD 80,S

	LDB #$12
	STD 120,S

	LDD 122,S
	PSHU D

	ANDA #$0F
	ORA #$d0
	LDB #$bb
	STD 122,S

	PULS D,X
	PSHU D,X,S

	LDD #$123d
	LDX #$33bb
	PSHS D,X

	LEAS 160,S

	PULS D,X
	PSHU D,X,S

	LDD #$fa32
	LDX #$dcaa
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$292c
	LDX #$dd0a
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$ff3d
	LDX #$dde0
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$ffad
	LDX #$0de0
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$1faa
	LDX #$d0ee
	PSHS D,X

	LEAS 40,S

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$10
	STD 80,S

	LDA 83,S
	PSHU A

	LDA 43,S
	PSHU A

	LDD 120,S
	PSHU D

	ANDA #$F0
	ORA #$0e
	LDB #$10
	STD 120,S

	LDD 40,S
	PSHU D

	LDD #$e1ea
	STD 40,S

	LDA 123,S
	PSHU A

	LDA #$a9
	STA 83,S

	STA 43,S

	LDA #$a1
	STA 123,S

	PULS D,X
	PSHU D,X,S

	LDD #$0fa9
	LDX #$ddee
	PSHS D,X

	LEAS 262,S

	LDA -101,S
	PSHU A

	LDA -59,S
	PSHU A

	LDA -99,S
	PSHU A

	LDA -21,S
	PSHU A

	ANDA #$0F
	ORA #$e0
	STA -21,S

	LDA 61,S
	PSHU A

	ANDA #$0F
	ORA #$10
	STA 61,S

	LDA 21,S
	PSHU A

	LDA #$11
	STA -99,S

	STA -59,S

	LDA -19,S
	PSHU A

	LDA #$1e
	STA -19,S

	STA 21,S

	LDA -61,S
	PSHU A,S

	LDA #$e0
	STA -101,S

	LDA #$0e
	STA -61,S

	LDA 101,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA 101,S

SSAV_HRL9
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HRL9
	PSHS U,DP
	STS ERASE_SSAV_HRL9+2

ERASE_POS_HRL9_1
	LDS #$0000
	LDU #ERASE_DATA_HRL9_1

ERASE_CODE_HRL9_1
	PULU A,B,S
	STA -81,S
	STB 81,S

	PULU A,B
	STA -79,S
	STB 41,S

	PULU A,B
	STA -41,S
	STB -121,S

	PULU A,B
	STA 121,S
	STB -119,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X
	STA 122,S
	STB 40,S
	STX -40,S

	PULU A,B
	STA 82,S
	STB -38,S

	PULU A,B,X
	STA 42,S
	STB -81,S
	STX -79,S

	PULU A,B
	STA 120,S
	STB 80,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 121,S
	STX 119,S
	STY 40,S

	PULU A,B,X,Y
	STA 3,S
	STB 81,S
	STX 79,S
	STY 42,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA -38,S
	STX -40,S

	PULU A,B,X,Y
	STA -79,S
	STB -119,S
	STX -81,S
	STY -121,S

	PULU D,X,Y,S
	STD ,S
	STX -2,S
	STY 40,S

	PULU A,B,X,Y
	STA 120,S
	STB 80,S
	STX 38,S
	STY 118,S

	PULU D,X
	STD -121,S
	STX 78,S

	PULU A,B,X,Y
	STA -80,S
	STB -40,S
	STX -42,S
	STY -82,S

	PULU D,X,Y,S
	STD 119,S
	STX 79,S
	STY -41,S

	PULU D,X
	STD -81,S
	STX -1,S

	PULU A,X
	STA -120,S
	STX 39,S

ERASE_POS_HRL9_2
	LDS #$0000
	LDU #ERASE_DATA_HRL9_2

ERASE_CODE_HRL9_2
	PULU A,B,S
	STA 101,S
	STB -61,S

	PULU A,B
	STA -19,S
	STB 21,S

	PULU A,B
	STA 61,S
	STB -21,S

	PULU A,B
	STA -99,S
	STB -59,S

	PULU A
	STA -101,S

	PULU D,X,S
	PSHS D,X

	PULU A,X,Y
	STA 123,S
	STX 40,S
	STY 120,S

	PULU A,B,X
	STA 43,S
	STB 83,S
	STX 80,S

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

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 122,S
	STX 80,S
	STY 82,S

	PULU D,X,Y
	STD 40,S
	STX 120,S
	STY 42,S

	PULU D,X,S
	PSHS D,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 80,S
	STX 120,S

	PULU A,B,X
	STA 122,S
	STB 42,S
	STX 40,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -120,S
	STX -40,S

	PULU A,X
	STA -38,S
	STX -80,S

	PULU A,X,Y,S
	STA -80,S
	STX -1,S
	STY 39,S

	PULU A,B,X,Y
	STA 41,S
	STB 1,S
	STX 79,S
	STY -40,S

ERASE_SSAV_HRL9
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HRL9_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRL9_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRL9_END
