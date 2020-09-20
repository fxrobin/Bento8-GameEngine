(main)IMG.ASM
	ORG $BB5F
DRAW_HRL5
	PSHS U,DP
	STS SSAV_HRL5+2

	LDS $9F00
	STS ERASE_POS_HRL5_1+2
	LDU #ERASE_DATA_HRL5_2
	LEAS 563,S
	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ac
	STD -81,S

	LDA 1,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 1,S

	LDD 79,S
	PSHU D
	LDA #$32
	ANDB #$0F
	ORB #$d0
	STD 79,S

	LDA -120,S
	PSHU A

	LDD -41,S
	PSHU D

	LDD -1,S
	PSHU D

	LDD 39,S
	PSHU D

	LDD 119,S
	PSHU D,S

	LDA #$aa
	STA -120,S

	LDD #$d2dd
	STD -1,S

	LDA #$32
	STD 39,S

	LDD #$ddcc
	STD -41,S

	LDA #$a2
	STD 119,S

	LEAS 180,S
	LDD 18,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ca
	STD 18,S

	LDD -21,S
	PSHU D

	LDA 20,S
	PSHU A,S

	LDA #$cc
	STA 20,S

	LDD #$aacc
	STD -21,S

	LEAS 179,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ca
	STD -121,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$aa
	STD -81,S

	LDD -79,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$c0
	STD -79,S

	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$aa
	STD -41,S

	LDD -39,S
	PSHU D
	LDA #$cd
	ANDB #$0F
	ORB #$d0
	STD -39,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ac
	STD 39,S

	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$c2
	STD 79,S

	LDD 119,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$b2
	STD 119,S

	LDA -119,S
	PSHU A

	LDA 41,S
	PSHU A

	LDA 81,S
	PSHU A

	LDA 121,S
	PSHU A

	LDA #$cd
	STA 41,S

	LDA #$dc
	STA 121,S

	LDA #$cc
	STA -119,S

	STA 81,S

	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$cddd
	PSHS A,X

	LEAS 281,S
	LDA -119,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA -119,S

	LDD -82,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$22
	STD -82,S

	LDD -42,S
	PSHU D
	ANDA #$F0
	ORA #$0b
	LDB #$31
	STD -42,S

	LDD -2,S
	PSHU D
	ANDA #$F0
	ORA #$0b
	LDB #$ad
	STD -2,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0ba0
	STD 38,S

	LDD 78,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0ba0
	STD 78,S

	LDD 118,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$a2
	STD 118,S

	LDD -121,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD ,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D,S

	LDD #$22dd
	STD -121,S

	LDD #$0d90
	STD -80,S

	LDD #$dd99
	STD -40,S

	LDD #$30d0
	STD ,S

	LDD #$edde
	STD 40,S

	LDD #$3cae
	STD 120,S

	LDB #$11
	STD 80,S

	LEAS 280,S
	LDD -122,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$13
	STD -122,S

	LDA -82,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -82,S

	LDA -42,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -42,S

	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA -38,S

	LDA -2,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -2,S

	LDD ,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$bf
	STD ,S

	LDA 2,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 2,S

	LDA 38,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA 38,S

	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 42,S

	LDA 78,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA 78,S

	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 82,S

	LDD 118,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$aa
	STD 118,S

	LDA 122,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 122,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D,S

	LDD #$3d0a
	STD -120,S

	LDD #$dcda
	STD -40,S

	LDA #$cd
	STD -80,S

	LEAS 279,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$9a
	STD -121,S

	LDA -117,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA -117,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$ea
	STD -81,S

	LDA 80,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 80,S

	LDA 120,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 120,S

	LDA -40,S
	PSHU A

	LDA ,S
	PSHU A

	LDA 40,S
	PSHU A,S

	LDA #$19
	STA -40,S

	LDA #$e0
	STA ,S

	STA 40,S


	LDS $9F00+2
	STS ERASE_POS_HRL5_2+2
	LDU #ERASE_DATA_HRL5_END

	LEAS 522,S
	LDD -40,S
	PSHU D
	LDA #$aa
	ANDB #$0F
	ORB #$c0
	STD -40,S

	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ac
	STD -1,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$cc
	STD 39,S

	LDA -80,S
	PSHU A

	LDA 1,S
	PSHU A

	LDA 41,S
	PSHU A

	LDD 79,S
	PSHU D,S

	LDA #$dd
	STA 41,S

	LDD #$aadc
	STD 79,S

	STA -80,S

	STB 1,S

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

	LDD #$addc
	STD -40,S

	LDA #$aa
	STD -120,S

	STD -80,S

	PULS A,X
	PSHU A,X,S
	LDA #$ab
	LDX #$accc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$cb
	LDX #$bcdc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$0b
	LDX #$acdd
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ab
	LDX #$acdd
	PSHS A,X

	LEAS 40,S
	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 82,S

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

	LDD #$223c
	STD 120,S

	LDD #$2bcc
	STD 80,S

	LDA #$9b
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$9b
	LDX #$acdd
	PSHS A,X

	LEAS 160,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$22
	LDX #$3ddc
	PSHS A,X

	LEAS 40,S
	PULS D,X
	PSHU D,X,S
	LDD #$a2dd
	LDX #$dd9a
	PSHS D,X

	LEAS 40,S
	PULS D,X
	PSHU D,X,S
	LDD #$b9d0
	LDX #$ddaa
	PSHS D,X

	LEAS 40,S
	LDD 42,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$d000
	STD 42,S

	LDD 40,S
	PSHU D

	LDD #$bbe2
	STD 40,S

	PULS D,X
	PSHU D,X,S
	LDD #$aa01
	LDX #$0d99
	PSHS D,X

	LEAS 80,S
	PULS D,X
	PSHU D,X,S
	LDD #$bb23
	LDX #$dee9
	PSHS D,X

	LEAS 40,S
	PULS D,X
	PSHU D,X,S
	LDD #$ba3e
	LDX #$de19
	PSHS D,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$f001
	STD 40,S

	LDD 80,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$f00d
	STD 80,S

	LDD 120,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$100d
	STD 120,S

	LDD 42,S
	PSHU D

	LDD 82,S
	PSHU D

	LDD 122,S
	PSHU D

	LDD #$09ba
	STD 42,S

	LDD #$cdb1
	STD 82,S

	LDD #$ddbf
	STD 122,S

	PULS D,X
	PSHU D,X,S
	LDD #$a911
	LDX #$d91a
	PSHS D,X

	LEAS 282,S
	LDD -122,S
	PSHU D
	ANDA #$0F
	ORA #$10
	LDB #$cd
	STD -122,S

	LDD -82,S
	PSHU D
	LDA #$1a
	ANDB #$0F
	ORB #$c0
	STD -82,S

	LDD -42,S
	PSHU D
	LDA #$1a
	ANDB #$0F
	ORB #$d0
	STD -42,S

	LDD -2,S
	PSHU D
	LDA #$ea
	ANDB #$0F
	ORB #$d0
	STD -2,S

	LDD 38,S
	PSHU D
	LDA #$0a
	ANDB #$0F
	ORB #$90
	STD 38,S

	LDA 81,S
	PSHU A
	ANDA #$F0
	ORA #$01
	STA 81,S

	LDA 121,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA 121,S

	LDA -119,S
	PSHU A

	LDA -79,S
	PSHU A

	LDA -39,S
	PSHU A

	LDA 1,S
	PSHU A

	LDA 41,S
	PSHU A

	LDA 78,S
	PSHU A

	LDA 118,S
	PSHU A,S

	LDA #$f1
	STA 41,S

	LDA #$09
	STA 78,S

	LDA #$e9
	STA 118,S

	LDA #$ff
	STA -119,S

	STA -79,S

	STA -39,S

	STA 1,S

	LEAS 198,S
	LDA ,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA ,S

	LDA 40,S
	PSHU A
	ANDA #$F0
	ORA #$01
	STA 40,S

	LDA -40,S
	PSHU A,S

	LDA #$10
	STA -40,S

SSAV_HRL5
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HRL5
	PSHS U,DP
	STS ERASE_SSAV_HRL5+2

ERASE_POS_HRL5_1
	LDS #$0000
	LDU #ERASE_DATA_HRL5_1

ERASE_CODE_HRL5_1
	PULU A,S
	STA 40,S

	PULU A,B
	STA ,S
	STB -40,S

	PULU A,B,X
	STA 120,S
	STB 80,S
	STX -81,S

	PULU A,X
	STA -117,S
	STX -121,S

	PULU D,S
	STD -40,S

	PULU D,X
	STD -80,S
	STX -120,S

	PULU A,X
	STA 122,S
	STX 118,S

	PULU A,B
	STA 82,S
	STB 78,S

	PULU A,B
	STA 42,S
	STB 38,S

	PULU A,X
	STA 2,S
	STX ,S

	PULU A,B
	STA -2,S
	STB -38,S

	PULU A,B,X
	STA -42,S
	STB -82,S
	STX -122,S

	PULU D,S
	STD 120,S

	PULU D,X,Y
	STD 80,S
	STX 40,S
	STY ,S

	PULU D,X,Y
	STD -40,S
	STX -80,S
	STY -121,S

	PULU D,X,Y
	STD 118,S
	STX 78,S
	STY 38,S

	PULU D,X,Y
	STD -2,S
	STX -42,S
	STY -82,S

	PULU A
	STA -119,S

	PULU B,X,S
	PSHS B,X

	PULU A,B
	STA 121,S
	STB 81,S

	PULU A,B,X,Y
	STA 41,S
	STB -119,S
	STX 119,S
	STY 79,S

	PULU D,X,Y
	STD 39,S
	STX -39,S
	STY -41,S

	PULU D,X,Y
	STD -79,S
	STX -81,S
	STY -121,S

	PULU A,S
	STA 20,S

	PULU D,X
	STD -21,S
	STX 18,S

	PULU D,S
	STD 119,S

	PULU D,X,Y
	STD 39,S
	STX -1,S
	STY -41,S

	PULU A,X
	STA -120,S
	STX 79,S

	PULU A,X
	STA 1,S
	STX -81,S

ERASE_POS_HRL5_2
	LDS #$0000
	LDU #ERASE_DATA_HRL5_2

ERASE_CODE_HRL5_2
	PULU A,S
	STA -40,S

	PULU A,B
	STA 40,S
	STB ,S

	PULU A,S
	STA 118,S

	PULU A,B
	STA 78,S
	STB 41,S

	PULU A,B
	STA 1,S
	STB -39,S

	PULU A,B
	STA -79,S
	STB -119,S

	PULU A,B,X,Y
	STA 121,S
	STB 81,S
	STX 38,S
	STY -2,S

	PULU D,X,Y
	STD -42,S
	STX -82,S
	STY -122,S

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

	PULU D,X,S
	PSHS D,X



	PULU D,X,S
	PSHS D,X



	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD 40,S
	STX 42,S

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

	PULU D,X,Y
	STD 120,S
	STX 80,S
	STY 40,S

	PULU A,B
	STA 122,S
	STB 82,S

	PULU B,X,S
	PSHS B,X



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

	PULU A,B
	STA 41,S
	STB 1,S

	PULU A,X,Y
	STA -80,S
	STX 39,S
	STY -1,S

	PULU D
	STD -40,S

ERASE_SSAV_HRL5
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HRL5_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRL5_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRL5_END
