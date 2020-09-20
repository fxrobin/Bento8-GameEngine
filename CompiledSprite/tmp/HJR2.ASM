(main)IMG.ASM
	ORG $B435
DRAW_HJR2
	PSHS U,DP
	STS SSAV_HJR2+2

	LDS $9F00
	STS ERASE_POS_HJR2_1+2
	LDU #ERASE_DATA_HJR2_2
	LEAS 603,S
	LDA -80,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -80,S

	LDD -41,S
	PSHU D

	LDD -1,S
	PSHU D

	LDD 39,S
	PSHU D

	LDD 79,S
	PSHU D,S

	LDD #$aaaa
	STD -41,S

	LDD #$cccc
	STD -1,S

	LDD #$dddd
	STD 79,S

	LDB #$cd
	STD 39,S

	LEAS 239,S
	LDA -118,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -118,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
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

	LDD -120,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD #$ccdd
	STD -40,S

	LDA #$dd
	STD -120,S

	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$ccaa
	PSHS A,X

	LEAS 40,S
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dd
	STD 39,S

	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dd
	STD 79,S

	LDD 119,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 119,S

	LDD 121,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$90
	STD 121,S

	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD #$ccad
	STD 81,S

	STX 41,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$ccca
	PSHS A,X

	LEAS 200,S
	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD -41,S

	LDD -39,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$00
	STD -39,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$c329
	PSHS A,X

	LEAS 40,S
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 42,S

	LDD 40,S
	PSHU D

	LDD #$dd12
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$3220
	PSHS A,X

	LEAS 80,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$d3aa
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ca
	STD 40,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$d9
	STD 80,S

	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 82,S

	LDA 42,S
	PSHU A

	LDA #$a9
	STA 42,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$d1b9
	PSHS A,X

	LEAS 120,S
	LDA 42,S
	PSHU A
	ANDA #$F0
	ORA #$02
	STA 42,S

	LDD 40,S
	PSHU D

	LDD #$ddc0
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$3d9f
	PSHS A,X

	LEAS 80,S
	LDD 40,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$9a
	STD 40,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$a9
	STD 80,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$0e
	STD 120,S

	LDA 122,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 122,S

	LDA 42,S
	PSHU A

	LDA 82,S
	PSHU A

	LDA #$f1
	STA 42,S

	LDA #$1e
	STA 82,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$adff
	PSHS A,X

	LEAS 201,S
	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$e1
	STD -41,S

	LDA ,S
	PSHU A

	LDA 40,S
	PSHU A,S

	LDA #$ee
	STA ,S

	LDA #$00
	STA 40,S


	LDS $9F00+2
	STS ERASE_POS_HJR2_2+2
	LDU #ERASE_DATA_HJR2_END

	LEAS 603,S
	LDD -2,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$cc
	STD -2,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dc
	STD 38,S

	LDD 78,S
	PSHU D
	ANDA #$0F
	ORA #$c0
	LDB #$dc
	STD 78,S

	LDA -81,S
	PSHU A

	LDA -41,S
	PSHU A

	LDA ,S
	PSHU A

	LDA 40,S
	PSHU A

	LDA 80,S
	PSHU A,S

	LDA #$ad
	STA ,S

	LDA #$aa
	STA -81,S

	STA -41,S

	STA 40,S

	STA 80,S

	LEAS 238,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dc
	STD -40,S

	LDD -119,S
	PSHU D

	LDD -79,S
	PSHU D

	LDA -38,S
	PSHU A

	LDD #$dcaa
	STD -119,S

	LDD #$ccca
	STD -79,S

	LDA #$cd
	STA -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$ccda
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$dcab
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$ccab
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$dcab
	PSHS A,X

	LEAS 40,S
	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dc
	STD 80,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 120,S

	LDD 41,S
	PSHU D

	LDA 82,S
	PSHU A

	LDA 122,S
	PSHU A

	LDD #$ddab
	STD 41,S

	LDA #$cb
	STA 82,S

	LDA #$32
	STA 122,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$ccab
	PSHS A,X

	LEAS 160,S
	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$dda2
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$ddab
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$f0
	STA 3,S

	LDD 40,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$dd
	STD 40,S

	LDD 42,S
	PSHU D
	LDA #$bb
	ANDB #$0F
	ORB #$f0
	STD 42,S

	LDD 80,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$dd
	STD 80,S

	LDD 82,S
	PSHU D
	LDA #$aa
	ANDB #$0F
	ORB #$f0
	STD 82,S

	LDA 123,S
	PSHU A
	ANDA #$0F
	ORA #$f0
	STA 123,S

	LDD 121,S
	PSHU D

	LDD #$ccaa
	STD 121,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$dd9a
	PSHS A,X

	LEAS 281,S
	LDA -118,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA -118,S

	LDD -80,S
	PSHU D
	LDA #$c9
	ANDB #$0F
	ORB #$a0
	STD -80,S

	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA -78,S

	LDD -120,S
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

	LDD #$de0e
	STD 120,S

	LDD #$dda1
	STD 40,S

	LDA #$d9
	STD ,S

	LDD #$cc99
	STD -120,S

	LDA #$d0
	STD 80,S

	LDB #$9f
	STD -40,S

	LEAS 160,S
	LDA ,S
	PSHU A,S
	ANDA #$F0
	ORA #$0d
	STA ,S

SSAV_HJR2
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HJR2
	PSHS U,DP
	STS ERASE_SSAV_HJR2+2

ERASE_POS_HJR2_1
	LDS #$0000
	LDU #ERASE_DATA_HJR2_1

ERASE_CODE_HJR2_1
	PULU A,S
	STA 40,S

	PULU A,X
	STA ,S
	STX -41,S

	PULU B,X,S
	PSHS B,X

	PULU A,B
	STA 82,S
	STB 42,S

	PULU A,X,Y
	STA 122,S
	STX 120,S
	STY 80,S

	PULU D
	STD 40,S

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 40,S

	PULU A
	STA 42,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA 42,S
	STB 82,S
	STX 80,S
	STY 40,S

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

	PULU D,X
	STD -39,S
	STX -41,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 81,S
	STX 41,S
	STY 121,S

	PULU D,X,Y
	STD 119,S
	STX 79,S
	STY 39,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -40,S
	STX -120,S

	PULU A,B,X
	STA -38,S
	STB -78,S
	STX -80,S

	PULU A
	STA -118,S

	PULU D,S
	STD 79,S

	PULU D,X,Y
	STD 39,S
	STX -1,S
	STY -41,S

	PULU A
	STA -80,S

ERASE_POS_HJR2_2
	LDS #$0000
	LDU #ERASE_DATA_HJR2_2

ERASE_CODE_HJR2_2
	PULU A,S
	STA ,S



	PULU D,S
	STD 120,S

	PULU D,X,Y
	STD 80,S
	STX 40,S
	STY ,S

	PULU D,X
	STD -40,S
	STX -120,S

	PULU A,X
	STA -78,S
	STX -80,S

	PULU A
	STA -118,S

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 121,S

	PULU A,X,Y
	STA 123,S
	STX 82,S
	STY 80,S

	PULU D,X
	STD 42,S
	STX 40,S

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA 122,S
	STB 82,S
	STX 41,S
	STY 120,S

	PULU D
	STD 80,S

	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA -38,S
	STX -79,S
	STY -119,S

	PULU D
	STD -40,S

	PULU A,S
	STA 80,S

	PULU A,B
	STA 40,S
	STB ,S

	PULU A,B,X,Y
	STA -41,S
	STB -81,S
	STX 78,S
	STY 38,S

	PULU D
	STD -2,S

ERASE_SSAV_HJR2
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HJR2_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJR2_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJR2_END
