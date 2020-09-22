(main)IMG.ASM
	ORG $BB10
DRAW_HRL4
	PSHS U,DP
	STS SSAV_HRL4+2

	LDS $9F00
	STS ERASE_POS_HRL4_1+2
	LDU #ERASE_DATA_HRL4_2
	LEAS 603,S

	LDD 39,S
	PSHU D

	LDD -1,S
	PSHU D

	LDD 119,S
	PSHU D

	LDD -41,S
	PSHU D

	LDA -120,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -120,S

	LDD 79,S
	PSHU D,S

	LDA #$a3
	ANDB #$0F
	ORB #$c0
	STD 79,S

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

	LDD #$cacc
	STD -41,S

	LDA #$aa
	STD 119,S

	LEAS 280,S

	LDD 40,S
	PSHU D

	LDA #$cd
	ANDB #$0F
	ORB #$d0
	STD 40,S

	LDD -82,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$ac
	STD -82,S

	LDD -121,S
	PSHU D

	LDD -42,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$bc
	STD -42,S

	LDD #$dacc
	STD -121,S

	LDD ,S
	PSHU D

	LDA #$cd
	ANDB #$0F
	ORB #$c0
	STD ,S

	LDA -40,S
	PSHU A

	LDA 80,S
	PSHU A

	LDD -2,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$ba
	STD -2,S

	LDD 118,S
	PSHU D

	ANDA #$F0
	ORA #$09
	LDB #$ba
	STD 118,S

	LDA 120,S
	PSHU A

	LDA -80,S
	PSHU A

	LDD 78,S
	PSHU D,S

	ANDA #$F0
	ORA #$09
	LDB #$ba
	STD 78,S

	LDD 38,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$ba
	STD 38,S

	LDA #$cd
	STA 80,S

	STA -80,S

	STA -40,S

	LDA #$dd
	STA 120,S

	LEAS 279,S

	LDD -81,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$b2
	STD -81,S

	LDA -79,S
	PSHU A

	LDA -119,S
	PSHU A

	LDD -121,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$ab
	STD -121,S

	LDA #$dc
	STA -119,S

	LDA #$dd
	STA -79,S

	LDD -40,S
	PSHU D

	LDD #$220d
	STD -40,S

	PULS A,X
	PSHU A,X,S

	LDA #$22
	LDX #$ddaa
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$22
	LDX #$d3c9
	PSHS A,X

	LEAS 40,S

	LDA 42,S
	PSHU A

	LDD 40,S
	PSHU D

	ANDA #$0F
	ORA #$b0
	LDB #$13
	STD 40,S

	LDA #$09
	STA 42,S

	PULS A,X
	PSHU A,X,S

	LDA #$31
	LDX #$e3da
	PSHS A,X

	LEAS 80,S

	PULS A,X
	PSHU A,X,S

	LDA #$ba
	LDX #$20a9
	PSHS A,X

	LEAS 40,S

	LDD 41,S
	PSHU D

	LDA #$1d
	ANDB #$F0
	ORB #$0a
	STD 41,S

	LDD 39,S
	PSHU D

	ANDA #$0F
	ORA #$10
	LDB #$b9
	STD 39,S

	PULS A,X
	PSHU A,X,S

	LDA #$ba
	LDX #$3d9e
	PSHS A,X

	LEAS 79,S

	PULS D,X
	PSHU D,X,S

	LDD #$0fba
	LDX #$dcc0
	PSHS D,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$aa
	STD 40,S

	LDA 4,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA 4,S

	LDD 43,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0a90
	STD 43,S

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$fa
	STD 80,S

	LDD 83,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0a90
	STD 83,S

	LDD 120,S
	PSHU D

	ANDA #$F0
	ORA #$0e
	LDB #$19
	STD 120,S

	LDD 123,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0b90
	STD 123,S

	PULS D,X
	PSHU D,X,S

	LDD #$e1b9
	LDX #$0ddd
	PSHS D,X

	LEAS 282,S

	LDA 41,S
	PSHU A

	ANDA #$F0
	ORA #$0f
	STA 41,S

	LDA 39,S
	PSHU A

	LDA -81,S
	PSHU A

	LDA -118,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA -118,S

	LDA 81,S
	PSHU A

	LDA 121,S
	PSHU A

	LDA -41,S
	PSHU A

	LDA #$0e
	STA -41,S

	LDA #$f2
	STA 81,S

	LDA #$e1
	STA 39,S

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$e0
	STA -38,S

	LDA -1,S
	PSHU A

	LDA #$e0
	STA -1,S

	LDA -78,S
	PSHU A,S

	ANDA #$0F
	ORA #$e0
	STA -78,S

	LDA -121,S
	PSHU A

	LDA #$1e
	STA -121,S

	STA -81,S

	STA 121,S


	LDS $9F00+2
	STS ERASE_POS_HRL4_2+2
	LDU #ERASE_DATA_HRL4_END

	LEAS 562,S

	LDD -1,S
	PSHU D

	ANDA #$0F
	ORA #$d0
	LDB #$1c
	STD -1,S

	LDD 79,S
	PSHU D

	LDA 1,S
	PSHU A

	LDD -40,S
	PSHU D,S

	LDA #$da
	ANDB #$0F
	ORB #$c0
	STD -40,S

	LDD 39,S
	PSHU D

	LDD #$dc2d
	STD 39,S

	LDA -80,S
	PSHU A

	ANDA #$F0
	ORA #$0c
	STA -80,S

	LDA 41,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 41,S

	LDA #$dd
	STA 1,S

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

	PULS A,X
	PSHU A,X,S

	LDA #$22
	LDX #$2ddc
	PSHS A,X

	LEAS 40,S

	LDD 81,S
	PSHU D

	LDD #$01e9
	STD 81,S

	LDA 42,S
	PSHU A

	LDA 122,S
	PSHU A

	LDD 120,S
	PSHU D

	ANDA #$F0
	ORA #$0b
	LDB #$e3
	STD 120,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$03
	LDB #$d0
	STD 40,S

	LDA #$dd
	STA 42,S

	LDA #$d9
	STA 122,S

	PULS A,X
	PSHU A,X,S

	LDA #$12
	LDX #$3ddd
	PSHS A,X

	LEAS 160,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$a9
	LDX #$12dc
	PSHS A,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$bae2
	LDX #$dde0
	PSHS D,X

	LEAS 40,S

	LDD 42,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$a1
	STD 42,S

	LDD 40,S
	PSHU D

	LDD #$ab11
	STD 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$ab33
	LDX #$ddee
	PSHS D,X

	LEAS 80,S

	LDD 40,S
	PSHU D

	LDA #$1a
	ANDB #$0F
	ORB #$00
	STD 40,S

	LDD 120,S
	PSHU D

	LDA #$ea
	ANDB #$0F
	ORB #$a0
	STD 120,S

	LDD 42,S
	PSHU D

	LDD #$ddaa
	STD 42,S

	LDD 80,S
	PSHU D

	LDA #$1a
	ANDB #$0F
	ORB #$90
	STD 80,S

	LDA 83,S
	PSHU A

	LDA 123,S
	PSHU A

	LDA #$ba
	STA 83,S

	STA 123,S

	PULS D,X
	PSHU D,X,S

	LDD #$fbd0
	LDX #$cda1
	PSHS D,X

	LEAS 282,S

	LDD -82,S
	PSHU D

	LDA #$e9
	ANDB #$0F
	ORB #$00
	STD -82,S

	LDA -119,S
	PSHU A

	LDA #$bf
	STA -119,S

	LDA 41,S
	PSHU A

	LDA 1,S
	PSHU A

	LDA -39,S
	PSHU A

	LDA 81,S
	PSHU A

	LDA #$f1
	STA 41,S

	STA 1,S

	LDA -79,S
	PSHU A

	LDA #$ff
	STA -79,S

	STA -39,S

	LDD -42,S
	PSHU D,S

	ANDA #$F0
	ANDB #$0F
	ADDD #$0000
	STD -42,S

	LDA #$1e
	STA 81,S

	LDD -122,S
	PSHU D

	LDA #$0a
	ANDB #$0F
	ORB #$90
	STD -122,S

	LDA -2,S
	PSHU A

	ANDA #$F0
	ORA #$01
	STA -2,S

	LDA 121,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA 121,S

SSAV_HRL4
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HRL4
	PSHS U,DP
	STS ERASE_SSAV_HRL4+2

ERASE_POS_HRL4_1
	LDS #$0000
	LDU #ERASE_DATA_HRL4_1

ERASE_CODE_HRL4_1
	PULU A,B,S
	STA -121,S
	STB -78,S

	PULU A,B
	STA -1,S
	STB -38,S

	PULU A,B
	STA -41,S
	STB 121,S

	PULU A,B
	STA 81,S
	STB -118,S

	PULU A,B
	STA -81,S
	STB 39,S

	PULU A
	STA 41,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 123,S
	STX 120,S
	STY 83,S

	PULU D,X
	STD 80,S
	STX 43,S

	PULU A,X
	STA 4,S
	STX 40,S

	PULU D,X,S
	PSHS D,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 39,S
	STX 41,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 40,S

	PULU A
	STA 42,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -40,S
	STX -121,S

	PULU A,B,X
	STA -119,S
	STB -79,S
	STX -81,S

	PULU D,X,S
	STD 38,S
	STX 78,S

	PULU A,B,X,Y
	STA -80,S
	STB 120,S
	STX 118,S
	STY -2,S

	PULU A,B,X,Y
	STA 80,S
	STB -40,S
	STX ,S
	STY -42,S

	PULU D,X,Y
	STD -121,S
	STX -82,S
	STY 40,S

	PULU D,X,S
	STD -81,S
	STX 79,S

	PULU A,X,Y
	STA -120,S
	STX -41,S
	STY 119,S

	PULU D,X
	STD -1,S
	STX 39,S

ERASE_POS_HRL4_2
	LDS #$0000
	LDU #ERASE_DATA_HRL4_2

ERASE_CODE_HRL4_2
	PULU A,B,X,Y,S
	STA 121,S
	STB -2,S
	STX -122,S
	STY -42,S

	PULU A,B
	STA -79,S
	STB 81,S

	PULU A,B
	STA -39,S
	STB 1,S

	PULU A,B,X
	STA 41,S
	STB -119,S
	STX -82,S

	PULU D,X,S
	PSHS D,X

	PULU A,B,X,Y
	STA 123,S
	STB 83,S
	STX 80,S
	STY 42,S

	PULU D,X
	STD 120,S
	STX 40,S

	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD 40,S
	STX 42,S

	PULU D,X,S
	PSHS D,X

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

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

	PULU A,B,X,Y,S
	STA 41,S
	STB -80,S
	STX 39,S
	STY -40,S

	PULU A,X,Y
	STA 1,S
	STX 79,S
	STY -1,S

ERASE_SSAV_HRL4
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HRL4_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRL4_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRL4_END
