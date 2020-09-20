(main)IMG.ASM
	ORG $BBDE
DRAW_HRL3
	PSHS U,DP
	STS SSAV_HRL3+2

	LDS $9F00
	STS ERASE_POS_HRL3_1+2
	LDU #ERASE_DATA_HRL3_2
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
	LDB #$cc
	STD -81,S

	LDD 79,S
	PSHU D
	LDA #$ac
	ANDB #$0F
	ORB #$c0
	STD 79,S

	LDD -41,S
	PSHU D

	LDD -1,S
	PSHU D

	LDD 39,S
	PSHU D

	LDD 119,S
	PSHU D,S

	LDD #$cacc
	STD -41,S

	LDA #$aa
	STD 119,S

	LDB #$cd
	STD -1,S

	LDB #$dd
	STD 39,S

	LEAS 280,S
	LDD -82,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$bc
	STD -82,S

	LDD -42,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ba
	STD -42,S

	LDD -2,S
	PSHU D
	ANDA #$F0
	ORA #$00
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
	ORA #$09
	LDB #$ba
	STD 38,S

	LDD 40,S
	PSHU D
	LDA #$c0
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
	ORA #$0a
	LDB #$bc
	STD 118,S

	LDD -121,S
	PSHU D

	LDA -80,S
	PSHU A

	LDA -40,S
	PSHU A

	LDA 80,S
	PSHU A

	LDA 120,S
	PSHU A,S

	LDD #$dacc
	STD -121,S

	LDA #$d0
	STA 80,S

	LDA #$dd
	STA 120,S

	LDA #$cd
	STA -80,S

	STA -40,S

	LEAS 279,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$bb
	STD -121,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$b2
	STD -81,S

	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 42,S

	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 82,S

	LDA -119,S
	PSHU A

	LDA -79,S
	PSHU A

	LDD -40,S
	PSHU D

	LDD ,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDA 121,S
	PSHU A,S

	LDA #$dc
	STA -119,S

	LDD #$33d1
	STD 40,S

	LDD #$1110
	STD 80,S

	LDA #$23
	STA 121,S

	LDD #$22dd
	STD ,S

	STB -79,S

	LDB #$0d
	STD -40,S

	LEAS 161,S
	LDA ,S
	PSHU A,S

	LDA #$23
	STA ,S

	LEAS 158,S
	LDD -119,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$a1
	STD -119,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$ae
	STD -40,S

	LDD -38,S
	PSHU D
	LDA #$9a
	ANDB #$F0
	ORB #$0f
	STD -38,S

	LDA 3,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA 3,S

	LDD -79,S
	PSHU D

	LDD #$aaaa
	STD -79,S

	PULS A,X
	PSHU A,X,S
	LDA #$e0
	LDX #$a1ba
	PSHS A,X

	LEAS 40,S
	PULS D,X
	PSHU D,X,S
	LDD #$1e91
	LDX #$bac0
	PSHS D,X

	LEAS 41,S
	LDD 40,S
	PSHU D
	LDA #$e0
	ANDB #$0F
	ORB #$a0
	STD 40,S

	LDA 80,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA 80,S

	LDA 82,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA 82,S

	LDA 122,S
	PSHU A
	ANDA #$F0
	ORA #$0b
	STA 122,S

	LDA 42,S
	PSHU A

	LDA #$ba
	STA 42,S

	PULS A,X
	PSHU A,X,S
	LDA #$01
	LDX #$b9d0
	PSHS A,X

	LEAS 242,S
	LDA -80,S
	PSHU A
	ANDA #$F0
	ORA #$0b
	STA -80,S

	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$ee
	STD 79,S

	LDA -40,S
	PSHU A

	LDA ,S
	PSHU A

	LDA 40,S
	PSHU A,S

	LDA #$ff
	STA -40,S

	STA ,S

	STA 40,S


	LDS $9F00+2
	STS ERASE_POS_HRL3_2+2
	LDU #ERASE_DATA_HRL3_END

	LEAS 562,S
	LDA -80,S
	PSHU A
	ANDA #$F0
	ORA #$0c
	STA -80,S

	LDD -40,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$c0
	STD -40,S

	LDA 41,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 41,S

	LDD ,S
	PSHU D

	LDD 39,S
	PSHU D

	LDD 79,S
	PSHU D,S

	LDD #$da32
	STD 79,S

	LDD #$dcdd
	STD 39,S

	LDA #$ad
	STD ,S

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

	LDD #$ca22
	STD -120,S

	LDD #$aaad
	STD -40,S

	LDB #$a2
	STD -80,S

	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$bccc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ac
	LDX #$aadc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$a0
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

	LDD #$ab2c
	STD 120,S

	LDD #$b9cc
	STD 80,S

	LDA #$a9
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$ca
	LDX #$acdd
	PSHS A,X

	LEAS 160,S
	PULS A,X
	PSHU A,X,S
	LDA #$02
	LDX #$2dcc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$32
	LDX #$2ddc
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$d0
	STD 40,S

	LDD 81,S
	PSHU D
	LDA #$0e
	ANDB #$0F
	ORB #$30
	STD 81,S

	LDD 121,S
	PSHU D
	LDA #$c3
	ANDB #$0F
	ORB #$20
	STD 121,S

	LDA 42,S
	PSHU A

	LDA #$dd
	STA 42,S

	PULS A,X
	PSHU A,X,S
	LDA #$12
	LDX #$3ddd
	PSHS A,X

	LEAS 240,S
	LDD -79,S
	PSHU D

	LDD -39,S
	PSHU D

	LDD #$da2d
	STD -39,S

	LDA #$d2
	STD -79,S

	PULS A,X
	PSHU A,X,S
	LDA #$ff
	LDX #$db3d
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 3,S

	LDD 42,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$10
	STD 42,S

	LDD 40,S
	PSHU D

	LDD #$01bb
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$11
	LDX #$ab00
	PSHS A,X

	LEAS 80,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$ab
	STD 40,S

	LDD 42,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$e1
	STD 42,S

	LDA 121,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 121,S

	LDA 81,S
	PSHU A

	LDA 83,S
	PSHU A

	LDA 123,S
	PSHU A

	LDA #$ea
	STA 81,S

	STB 83,S

	LDA #$11
	STA 123,S

	PULS D,X
	PSHU D,X,S
	LDD #$e0ab
	LDX #$dce1
	PSHS D,X

	LEAS 263,S
	LDD 59,S
	PSHU D
	LDA #$f2
	ANDB #$0F
	ORB #$e0
	STD 59,S

	LDA -100,S
	PSHU A

	LDA -60,S
	PSHU A

	LDA -20,S
	PSHU A

	LDA 20,S
	PSHU A

	LDA 99,S
	PSHU A,S

	LDA #$11
	STA -100,S

	LDA #$a0
	STA -60,S

	LDA #$a9
	STA -20,S

	LDA #$19
	STA 20,S

	LDA #$ee
	STA 99,S

SSAV_HRL3
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HRL3
	PSHS U,DP
	STS ERASE_SSAV_HRL3+2

ERASE_POS_HRL3_1
	LDS #$0000
	LDU #ERASE_DATA_HRL3_1

ERASE_CODE_HRL3_1
	PULU A,S
	STA 40,S

	PULU A,B,X
	STA ,S
	STB -40,S
	STX 79,S

	PULU A
	STA -80,S

	PULU B,X,S
	PSHS B,X

	PULU A,B
	STA 42,S
	STB 122,S

	PULU A,B,X
	STA 82,S
	STB 80,S
	STX 40,S

	PULU D,X,S
	PSHS D,X



	PULU B,X,S
	PSHS B,X

	PULU D
	STD -79,S

	PULU A,X,Y
	STA 3,S
	STX -38,S
	STY -40,S

	PULU D
	STD -119,S

	PULU A,S
	STA ,S



	PULU A,S
	STA 121,S

	PULU D,X,Y
	STD 80,S
	STX 40,S
	STY ,S

	PULU D
	STD -40,S

	PULU A,B
	STA -79,S
	STB -119,S

	PULU A,B,X,Y
	STA 82,S
	STB 42,S
	STX -81,S
	STY -121,S

	PULU A,S
	STA 120,S

	PULU A,B
	STA 80,S
	STB -40,S

	PULU A,X,Y
	STA -80,S
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

	PULU D,S
	STD 119,S

	PULU D,X,Y
	STD 39,S
	STX -1,S
	STY -41,S

	PULU D,X
	STD 79,S
	STX -81,S

	PULU A
	STA -120,S

ERASE_POS_HRL3_2
	LDS #$0000
	LDU #ERASE_DATA_HRL3_2

ERASE_CODE_HRL3_2
	PULU A,S
	STA 99,S

	PULU A,B
	STA 20,S
	STB -20,S

	PULU A,B,X
	STA -60,S
	STB -100,S
	STX 59,S

	PULU D,X,S
	PSHS D,X

	PULU A,B
	STA 123,S
	STB 83,S

	PULU A,B,X,Y
	STA 81,S
	STB 121,S
	STX 42,S
	STY 40,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 40,S
	STX 42,S

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -39,S
	STX -79,S

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA 42,S
	STX 121,S
	STY 81,S

	PULU D
	STD 40,S

	PULU B,X,S
	PSHS B,X



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

	PULU D,S
	STD 79,S

	PULU D,X
	STD 39,S
	STX ,S

	PULU A,X
	STA 41,S
	STX -40,S

	PULU A
	STA -80,S

ERASE_SSAV_HRL3
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HRL3_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRL3_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRL3_END
