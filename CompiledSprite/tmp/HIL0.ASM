(main)IMG.ASM
	ORG $A000
DRAW_HIL0
	PSHS U,DP
	STS SSAV_HIL0+2

	LDS $9F00
	STS ERASE_POS_HIL0_1+2
	LDU #ERASE_DATA_HIL0_2
	LEAS 443,S
	LDA -80,S
	PSHU A
	ANDA #$F0
	ORA #$0c
	STA -80,S

	LDD -1,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$ad
	STD -1,S

	LDD 39,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$a3
	STD 39,S

	LDD -40,S
	PSHU D

	LDA 1,S
	PSHU A

	LDA 41,S
	PSHU A

	LDD 79,S
	PSHU D,S

	LDD #$cacc
	STD -40,S

	LDD #$dcd2
	STD 79,S

	LDA #$dd
	STA 1,S

	STA 41,S

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

	LDD #$da12
	STD -120,S

	LDD #$caaa
	STD -40,S

	LDB #$a2
	STD -80,S

	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$aacc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$aadd
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$aadd
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

	LDD #$00cc
	STD 80,S

	LDB #$ac
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$c0
	LDX #$aadd
	PSHS A,X

	LEAS 160,S
	PULS A,X
	PSHU A,X,S
	LDA #$02
	LDX #$23cc
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$03
	LDB #$2d
	STD 40,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$1d
	STD 80,S

	LDA 42,S
	PSHU A

	LDA 82,S
	PSHU A

	LDA 121,S
	PSHU A

	LDA #$d0
	STA 121,S

	LDA #$dd
	STA 42,S

	STA 82,S

	PULS A,X
	PSHU A,X,S
	LDA #$12
	LDX #$23dc
	PSHS A,X

	LEAS 281,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$12
	STD -121,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$03
	LDB #$d1
	STD -81,S

	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$02
	LDB #$d0
	STD -41,S

	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$03
	LDB #$da
	STD -1,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$bb
	STD 39,S

	LDA 41,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 41,S

	LDA 81,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 81,S

	LDA 121,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 121,S

	LDD 79,S
	PSHU D,S

	LDD 119,S
	PSHU D

	LDD #$a9ab
	STD 119,S

	LDB #$bb
	STD 79,S

	LEAS 279,S
	LDA -118,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -118,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$da
	STD -80,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$d9
	STD -40,S

	LDA 1,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA 1,S

	LDA 41,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA 41,S

	LDD 80,S
	PSHU D,S
	ANDA #$F0
	ORA #$0a
	LDB #$bb
	STD 80,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$aa
	STD 120,S

	LDD -120,S
	PSHU D

	LDD #$9aaa
	STD -120,S

	LEAS 240,S
	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$1a
	STD -80,S

	LDD -40,S
	PSHU D

	LDD ,S
	PSHU D,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$a9a1
	STD -40,S

	LDD #$e0aa
	STD ,S

	LDD #$1ffa
	STD 40,S

	LDD #$eee0
	STD 80,S


	LDS $9F00+2
	STS ERASE_POS_HIL0_2+2
	LDU #ERASE_DATA_HIL0_END

	LEAS 483,S
	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -41,S

	LDA -39,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -39,S

	LDA -120,S
	PSHU A

	LDA -80,S
	PSHU A

	LDD -1,S
	PSHU D

	LDD 39,S
	PSHU D,S

	LDD 79,S
	PSHU D

	LDD 119,S
	PSHU D

	LDD #$cadd
	STD -1,S

	LDA #$cc
	STA -120,S

	STA -80,S

	LDA #$aa
	STD 39,S

	STD 79,S

	LDB #$dc
	STD 119,S

	LEAS 159,S
	LDD ,S
	PSHU D,S

	LDD #$accd
	STD ,S

	LEAS 160,S
	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -78,S

	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -38,S

	LDD 119,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$ba
	STD 119,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDA 121,S
	PSHU A

	LDA #$dd
	STA 121,S

	LDD #$abcd
	STD -80,S

	LDA #$cb
	STD -120,S

	LDA #$bb
	STD -40,S

	STD 40,S

	STD 80,S

	PULS A,X
	PSHU A,X,S
	LDA #$bb
	LDX #$cddd
	PSHS A,X

	LEAS 280,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$b2
	STD -121,S

	LDA 2,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 2,S

	LDD 80,S
	PSHU D
	LDA #$23
	ANDB #$0F
	ORB #$d0
	STD 80,S

	LDA -119,S
	PSHU A

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD ,S
	PSHU D,S

	LDD 40,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$e0dd
	STD 40,S

	LDA #$33
	STD ,S

	LDA #$22
	STD -80,S

	STB -119,S

	LDB #$0d
	STD -40,S

	LDB #$2c
	STD 120,S

	LEAS 280,S
	LDD 80,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$d0a0
	STD 80,S

	LDD 120,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$d090
	STD 120,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D,S

	LDD ,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD #$31b3
	STD -40,S

	LDD #$ddae
	STD ,S

	LDD #$0d9d
	STD 40,S

	LDD #$22d2
	STD -80,S

	LDB #$32
	STD -120,S

	LEAS 240,S
	LDA -80,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -80,S

	LDA -40,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -40,S

	LDA ,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA ,S

	LDD 40,S
	PSHU D,S
	LDA #$a9
	ANDB #$0F
	ORB #$a0
	STD 40,S

	LDD 80,S
	PSHU D
	LDA #$90
	ANDB #$0F
	ORB #$90
	STD 80,S

	LEAS 239,S
	LDD -119,S
	PSHU D
	LDA #$aa
	ANDB #$0F
	ORB #$00
	STD -119,S

	LDD -79,S
	PSHU D
	LDA #$0b
	ANDB #$0F
	ORB #$10
	STD -79,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$2f
	STD -40,S

	LDA -38,S
	PSHU A

	LDA #$1e
	STA -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$1e
	LDX #$ff1e
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$00
	LDX #$ee0e
	PSHS A,X

SSAV_HIL0
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HIL0
	PSHS U,DP
	STS ERASE_SSAV_HIL0+2

ERASE_POS_HIL0_1
	LDS #$0000
	LDU #ERASE_DATA_HIL0_1

ERASE_CODE_HIL0_1
	PULU D,X,Y,S
	STD 80,S
	STX 40,S
	STY ,S

	PULU D,X
	STD -40,S
	STX -80,S

	PULU D,X,Y,S
	STD -120,S
	STX 120,S
	STY 80,S

	PULU A,B,X,Y
	STA 41,S
	STB 1,S
	STX -40,S
	STY -80,S

	PULU A
	STA -118,S

	PULU D,X,S
	STD 119,S
	STX 79,S

	PULU A,B
	STA 121,S
	STB 81,S

	PULU A,X,Y
	STA 41,S
	STX 39,S
	STY -1,S

	PULU D,X,Y
	STD -41,S
	STX -81,S
	STY -121,S

	PULU B,X,S
	PSHS B,X

	PULU A,B
	STA 121,S
	STB 82,S

	PULU A,X,Y
	STA 42,S
	STX 80,S
	STY 40,S

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

	PULU A,B,X,Y
	STA 41,S
	STB 1,S
	STX -40,S
	STY 39,S

	PULU D
	STD -1,S

	PULU A
	STA -80,S

ERASE_POS_HIL0_2
	LDS #$0000
	LDU #ERASE_DATA_HIL0_2

ERASE_CODE_HIL0_2
	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA -38,S
	STX -40,S
	STY -79,S

	PULU D
	STD -119,S

	PULU D,X,S
	STD 80,S
	STX 40,S

	PULU A,B
	STA ,S
	STB -40,S

	PULU A
	STA -80,S

	PULU D,X,Y,S
	STD 40,S
	STX ,S
	STY -40,S

	PULU D,X,Y
	STD -80,S
	STX -120,S
	STY 120,S

	PULU D
	STD 80,S

	PULU D,X,Y,S
	STD 120,S
	STX 40,S
	STY ,S

	PULU D,X
	STD -40,S
	STX -80,S

	PULU A,X
	STA -119,S
	STX 80,S

	PULU A,X
	STA 2,S
	STX -121,S

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA 121,S
	STX 80,S
	STY 40,S

	PULU D,X,Y
	STD -40,S
	STX -80,S
	STY -120,S

	PULU D
	STD 119,S

	PULU A,B
	STA -38,S
	STB -78,S

	PULU D,S
	STD ,S

	PULU D,X,Y,S
	STD 119,S
	STX 79,S
	STY 39,S

	PULU D
	STD -1,S

	PULU A,B
	STA -80,S
	STB -120,S

	PULU A,X
	STA -39,S
	STX -41,S

ERASE_SSAV_HIL0
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HIL0_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HIL0_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HIL0_END
