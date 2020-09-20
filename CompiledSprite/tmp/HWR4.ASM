(main)IMG.ASM
	ORG $E8FB
DRAW_HWR4
	PSHS U,DP
	STS SSAV_HWR4+2

	LDS $9F00
	STS ERASE_POS_HWR4_1+2
	LDU #ERASE_DATA_HWR4_2
	LEAS 463,S
	LDA 21,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 21,S

	LDD 59,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$3a
	STD 59,S

	LDA 61,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 61,S

	LDD -61,S
	PSHU D

	LDD -21,S
	PSHU D

	LDD 19,S
	PSHU D,S

	LDD #$cccc
	STD -61,S

	LDD #$dcaa
	STD -21,S

	LDD #$ddda
	STD 19,S

	LEAS 219,S
	LDD -119,S
	PSHU D
	LDA #$2c
	ANDB #$0F
	ORB #$c0
	STD -119,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$aa
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

	LDD -40,S
	PSHU D

	LDD #$ccaa
	STD -40,S

	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$bcac
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$aaad
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$aaa0
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$d0
	LDX #$aac9
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 40,S

	LDA 42,S
	PSHU A

	LDA #$ba
	STA 42,S

	PULS A,X
	PSHU A,X,S
	LDA #$d0
	LDX #$caa9
	PSHS A,X

	LEAS 80,S
	PULS A,X
	PSHU A,X,S
	LDX #$2ba0
	PSHS B,X

	LEAS 40,S
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$30
	STA 42,S

	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 82,S

	LDD 119,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$22
	STD 119,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDA 121,S
	PSHU A

	LDA #$d3
	STA 121,S

	LDD #$dd32
	STD 80,S

	LDB #$22
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$2200
	PSHS A,X

	LEAS 159,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 3,S

	LDD 40,S
	PSHU D
	LDA #$ab
	ANDB #$F0
	ORB #$0d
	STD 40,S

	LDD 42,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$30a0
	STD 42,S

	LDD 82,S
	PSHU D
	ANDA #$0F
	ORA #$20
	LDB #$aa
	STD 82,S

	LDD 80,S
	PSHU D

	LDD #$abdd
	STD 80,S

	PULS A,X
	PSHU A,X,S
	LDA #$ab
	LDX #$31e1
	PSHS A,X

	LEAS 120,S
	PULS D,X
	PSHU D,X,S
	LDD #$aadd
	LDX #$23aa
	PSHS D,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$9b
	LDX #$dd21
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA 3,S

	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 82,S

	LDD 122,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$d00f
	STD 122,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$e90d
	STD 40,S

	LDD #$01dd
	STD 120,S

	LDB #$d0
	STD 80,S

	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$dd1e
	PSHS A,X

	LEAS 281,S
	LDD -79,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$bf
	STD -79,S

	LDA -41,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA -41,S

	LDD -39,S
	PSHU D
	ANDA #$F0
	ORA #$0b
	LDB #$bf
	STD -39,S

	LDA -1,S
	PSHU A
	ANDA #$0F
	ORA #$f0
	STA -1,S

	LDD 1,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$b1
	STD 1,S

	LDD 41,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$10
	STD 41,S

	LDD 81,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$0e
	STD 81,S

	LDD 121,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$00e0
	STD 121,S

	LDA -121,S
	PSHU A

	LDD -119,S
	PSHU D

	LDA -81,S
	PSHU A,S

	LDA #$11
	STA -121,S

	LDD #$dcbf
	STD -119,S

	LDA #$1f
	STA -81,S

	LEAS 161,S
	LDA ,S
	PSHU A,S
	ANDA #$F0
	ORA #$0e
	STA ,S


	LDS $9F00+2
	STS ERASE_POS_HWR4_2+2
	LDU #ERASE_DATA_HWR4_END

	LEAS 482,S
	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cd
	STD -41,S

	LDA -39,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -39,S

	LDA -120,S
	PSHU A

	LDA -80,S
	PSHU A

	LDD ,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D,S

	LDD #$cdac
	STD ,S

	LDD #$d2aa
	STD 40,S

	LDA #$cc
	STA -120,S

	STA -80,S

	LDA #$c2
	STD 80,S

	STD 120,S

	LEAS 279,S
	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -80,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ca
	STD -40,S

	LDD -119,S
	PSHU D

	LDA -78,S
	PSHU A

	LDA -38,S
	PSHU A

	LDD #$cdda
	STD -119,S

	LDA #$ba
	STA -78,S

	LDA #$bc
	STA -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$ccb0
	PSHS A,X

	LEAS 40,S
	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDD #$dcbb
	STD 121,S

	LDB #$b9
	STD 41,S

	STD 81,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$ccba
	PSHS A,X

	LEAS 280,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dd
	STD -120,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$0d
	STD -80,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD -40,S

	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 42,S

	LDA 82,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA 82,S

	LDA -118,S
	PSHU A

	LDA -78,S
	PSHU A

	LDA -38,S
	PSHU A

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDA #$b2
	STA -118,S

	LDD #$b3d1
	STD 40,S

	LDD #$a132
	STD 80,S

	LDA #$22
	STA -78,S

	STA -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$bd
	LDX #$d031
	PSHS A,X

	LEAS 120,S
	PULS A,X
	PSHU A,X,S
	LDA #$be
	LDX #$32aa
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ae
	LDX #$3299
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ac
	LDX #$c20a
	PSHS A,X

	LEAS 40,S
	LDD 42,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$090f
	STD 42,S

	LDD 80,S
	PSHU D
	ANDA #$0F
	ORA #$a0
	LDB #$dd
	STD 80,S

	LDD 120,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$a0c0
	STD 120,S

	LDD 40,S
	PSHU D

	LDA 83,S
	PSHU A

	LDA 123,S
	PSHU A

	LDD #$addc
	STD 40,S

	LDA #$21
	STA 83,S

	LDA #$f1
	STA 123,S

	PULS A,X
	PSHU A,X,S
	LDA #$ed
	LDX #$c319
	PSHS A,X

	LEAS 281,S
	LDA -122,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -122,S

	LDD -119,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$b0f0
	STD -119,S

	LDA -82,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -82,S

	LDD -79,S
	PSHU D
	LDA #$bf
	ANDB #$0F
	ORB #$10
	STD -79,S

	LDA -42,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -42,S

	LDD -39,S
	PSHU D
	LDA #$bf
	ANDB #$0F
	ORB #$00
	STD -39,S

	LDA -2,S
	PSHU A
	ANDA #$F0
	ORA #$00
	STA -2,S

	LDD 1,S
	PSHU D
	LDA #$ea
	ANDB #$0F
	ORB #$e0
	STD 1,S

	LDA 38,S
	PSHU A
	ANDA #$F0
	ORA #$01
	STA 38,S

	LDA 41,S
	PSHU A

	LDA 81,S
	PSHU A

	LDA 121,S
	PSHU A,S

	LDA #$e9
	STA 121,S

	LDA #$1a
	STA 41,S

	STA 81,S

	LEAS 181,S
	LDA 20,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 20,S

	LDA -20,S
	PSHU A,S

	LDA #$0e
	STA -20,S

SSAV_HWR4
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HWR4
	PSHS U,DP
	STS ERASE_SSAV_HWR4+2

ERASE_POS_HWR4_1
	LDS #$0000
	LDU #ERASE_DATA_HWR4_1

ERASE_CODE_HWR4_1
	PULU A,S
	STA ,S



	PULU A,S
	STA -81,S

	PULU D
	STD -119,S

	PULU A,X,Y
	STA -121,S
	STX 121,S
	STY 81,S

	PULU D,X
	STD 41,S
	STX 1,S

	PULU A,X
	STA -1,S
	STX -39,S

	PULU A,X
	STA -41,S
	STX -79,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 120,S
	STX 80,S
	STY 40,S

	PULU D
	STD 122,S

	PULU A,B
	STA 82,S
	STB 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU D,X,S
	PSHS D,X



	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 80,S
	STX 82,S
	STY 42,S

	PULU D
	STD 40,S

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA 121,S
	STX 80,S
	STY 40,S

	PULU D
	STD 119,S

	PULU A,B
	STA 82,S
	STB 42,S

	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA 42,S
	STX 40,S

	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X

	PULU D
	STD -40,S

	PULU A,B,X,Y
	STA -38,S
	STB -78,S
	STX -80,S
	STY -119,S

	PULU D,S
	STD 19,S

	PULU D,X
	STD -21,S
	STX -61,S

	PULU A,X
	STA 61,S
	STX 59,S

	PULU A
	STA 21,S

ERASE_POS_HWR4_2
	LDS #$0000
	LDU #ERASE_DATA_HWR4_2

ERASE_CODE_HWR4_2
	PULU A,S
	STA -20,S

	PULU A
	STA 20,S

	PULU A,S
	STA 121,S

	PULU A,B
	STA 81,S
	STB 41,S

	PULU A,X
	STA 38,S
	STX 1,S

	PULU A,X
	STA -2,S
	STX -39,S

	PULU A,X
	STA -42,S
	STX -79,S

	PULU A,X
	STA -82,S
	STX -119,S

	PULU A
	STA -122,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA 123,S
	STB 83,S
	STX 40,S
	STY 120,S

	PULU D,X
	STD 80,S
	STX 42,S

	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 80,S
	STX 40,S

	PULU A,B
	STA -38,S
	STB -78,S

	PULU A,B
	STA -118,S
	STB 82,S

	PULU A,X,Y
	STA 42,S
	STX -40,S
	STY -80,S

	PULU D
	STD -120,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 121,S
	STX 81,S
	STY 41,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA -38,S
	STB -78,S
	STX -119,S
	STY -40,S

	PULU D
	STD -80,S

	PULU D,S
	STD 120,S

	PULU D,X,Y
	STD 80,S
	STX 40,S
	STY ,S

	PULU A,B
	STA -80,S
	STB -120,S

	PULU A,X
	STA -39,S
	STX -41,S

ERASE_SSAV_HWR4
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HWR4_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWR4_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWR4_END
