(main)IMG.ASM
	ORG $C8B2
DRAW_HRL9
	PSHS U,DP
	STS SSAV_HRL9+2

	LDS $9F00
	STS ERASE_POS_HRL9_1+2
	LDU #ERASE_DATA_HRL9_2
	LEAS 603,S
	LDA -120,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -120,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ac
	STD -81,S

	LDD 79,S
	PSHU D
	LDA #$a3
	ANDB #$0F
	ORB #$c0
	STD 79,S

	LDD -41,S
	PSHU D

	LDD -1,S
	PSHU D,S

	LDD 39,S
	PSHU D

	LDD 119,S
	PSHU D

	LDD #$acdd
	STD -1,S

	LDA #$a3
	STD 39,S

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

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ba
	STD 38,S

	LDD 40,S
	PSHU D
	LDA #$cd
	ANDB #$0F
	ORB #$d0
	STD 40,S

	LDD 78,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$ba
	STD 78,S

	LDD 118,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$ba
	STD 118,S

	LDD -121,S
	PSHU D

	LDA -80,S
	PSHU A

	LDA -40,S
	PSHU A

	LDA 80,S
	PSHU A,S

	LDA 120,S
	PSHU A

	LDD #$dacc
	STD -121,S

	LDA #$dd
	STA 120,S

	LDA #$cd
	STA -80,S

	STA -40,S

	STA 80,S

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

	LDA -38,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA -38,S

	LDA -119,S
	PSHU A

	LDA -79,S
	PSHU A

	LDD -40,S
	PSHU D

	LDA #$dc
	STA -119,S

	LDA #$dd
	STA -79,S

	LDD #$220d
	STD -40,S

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

	LDA 81,S
	PSHU A

	LDA #$dd
	STA 81,S

	PULS A,X
	PSHU A,X,S
	LDA #$11
	LDX #$3dda
	PSHS A,X

	LEAS 240,S
	LDA -81,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -81,S

	LDD -79,S
	PSHU D
	LDA #$00
	ANDB #$F0
	ORB #$0e
	STD -79,S

	LDD -40,S
	PSHU D
	ANDA #$0F
	ORA #$b0
	LDB #$ed
	STD -40,S

	LDA 82,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA 82,S

	LDA 122,S
	PSHU A
	ANDA #$F0
	ORA #$0f
	STA 122,S

	LDA -38,S
	PSHU A

	LDA 40,S
	PSHU A

	LDA 42,S
	PSHU A

	LDA 80,S
	PSHU A

	LDA 120,S
	PSHU A

	LDA #$9e
	STA -38,S

	LDA #$b1
	STA 40,S

	LDA #$09
	STA 42,S

	LDA #$af
	STA 80,S

	STA 120,S

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

	LDA -79,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA -79,S

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

	LDA 81,S
	PSHU A
	ANDA #$F0
	ORA #$01
	STA 81,S

	LDA -121,S
	PSHU A

	LDA -81,S
	PSHU A,S

	LDA 121,S
	PSHU A

	LDA #$91
	STA -121,S

	LDA #$e0
	STA -81,S

	STA 121,S


	LDS $9F00+2
	STS ERASE_POS_HRL9_2+2
	LDU #ERASE_DATA_HRL9_END

	LEAS 562,S
	LDA -80,S
	PSHU A
	ANDA #$F0
	ORA #$0c
	STA -80,S

	LDD -40,S
	PSHU D
	LDA #$da
	ANDB #$0F
	ORB #$c0
	STD -40,S

	LDD -1,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$1c
	STD -1,S

	LDA 41,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 41,S

	LDA 1,S
	PSHU A

	LDD 39,S
	PSHU D,S

	LDD 79,S
	PSHU D

	LDA #$dd
	STA 1,S

	LDD #$da2d
	STD 79,S

	LDA #$dc
	STD 39,S

	LEAS 239,S
	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -38,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD #$aaad
	STD -80,S

	STD -40,S

	LDB #$2d
	STD -120,S

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

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$9b2c
	STD 120,S

	LDD #$0bcc
	STD 80,S

	LDB #$ac
	STD 40,S

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

	LDD 122,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$bb
	STD 122,S

	LDD 42,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$ddbb
	STD 42,S

	LDD #$a912
	STD 120,S

	LDB #$01
	STD 80,S

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

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$10
	STD 120,S

	LDD 40,S
	PSHU D

	LDA 43,S
	PSHU A

	LDA 83,S
	PSHU A

	LDA 123,S
	PSHU A

	LDD #$e1ea
	STD 40,S

	LDA #$a1
	STA 123,S

	LDA #$a9
	STA 43,S

	STA 83,S

	PULS D,X
	PSHU D,X,S
	LDD #$0fa9
	LDX #$ddee
	PSHS D,X

	LEAS 262,S
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

	LDA 101,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 101,S

	LDA -101,S
	PSHU A

	LDA -99,S
	PSHU A

	LDA -61,S
	PSHU A

	LDA -59,S
	PSHU A

	LDA -19,S
	PSHU A,S

	LDA 21,S
	PSHU A

	LDA #$e0
	STA -101,S

	LDA #$0e
	STA -61,S

	LDA #$1e
	STA -19,S

	STA 21,S

	LDA #$11
	STA -99,S

	STA -59,S

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
	STA 121,S
	STB -81,S

	PULU A,B
	STA -121,S
	STB 81,S

	PULU A,B
	STA 41,S
	STB -41,S

	PULU A,B
	STA -79,S
	STB -119,S

	PULU B,X,S
	PSHS B,X

	PULU A,B
	STA 120,S
	STB 80,S

	PULU A,B
	STA 42,S
	STB 40,S

	PULU A,B
	STA -38,S
	STB 122,S

	PULU A,X,Y
	STA 82,S
	STX -40,S
	STY -79,S

	PULU A
	STA -81,S

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA 81,S
	STX 121,S
	STY 119,S

	PULU D,X,Y
	STD 79,S
	STX 42,S
	STY 40,S

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU D
	STD -40,S

	PULU A,B
	STA -79,S
	STB -119,S

	PULU A,X,Y
	STA -38,S
	STX -81,S
	STY -121,S

	PULU A,B,S
	STA 120,S
	STB 80,S

	PULU A,B,X,Y
	STA -40,S
	STB -80,S
	STX -121,S
	STY 118,S

	PULU D,X,Y
	STD 78,S
	STX 40,S
	STY 38,S

	PULU D,X,Y
	STD ,S
	STX -2,S
	STY -42,S

	PULU D
	STD -82,S

	PULU D,X,Y,S
	STD 119,S
	STX 39,S
	STY -1,S

	PULU D,X,Y
	STD -41,S
	STX 79,S
	STY -81,S

	PULU A
	STA -120,S

ERASE_POS_HRL9_2
	LDS #$0000
	LDU #ERASE_DATA_HRL9_2

ERASE_CODE_HRL9_2
	PULU A,B,S
	STA 21,S
	STB -19,S

	PULU A,B
	STA -59,S
	STB -61,S

	PULU A,B
	STA -99,S
	STB -101,S

	PULU A,B
	STA 101,S
	STB 61,S

	PULU A
	STA -21,S

	PULU D,X,S
	PSHS D,X

	PULU A,B
	STA 123,S
	STB 83,S

	PULU A,X,Y
	STA 43,S
	STX 40,S
	STY 120,S

	PULU D
	STD 80,S

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
	STD 120,S
	STX 80,S
	STY 42,S

	PULU D,X,Y
	STD 122,S
	STX 82,S
	STY 40,S

	PULU D,X,S
	PSHS D,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 120,S
	STX 80,S
	STY 40,S

	PULU A,B
	STA 122,S
	STB 42,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD -40,S
	STX -80,S
	STY -120,S

	PULU A
	STA -38,S

	PULU D,X,S
	STD 79,S
	STX 39,S

	PULU A,B,X,Y
	STA 1,S
	STB 41,S
	STX -1,S
	STY -40,S

	PULU A
	STA -80,S

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
