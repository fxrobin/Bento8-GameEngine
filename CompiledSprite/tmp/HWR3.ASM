(main)IMG.ASM
	ORG $E547
DRAW_HWR3
	PSHS U,DP
	STS SSAV_HWR3+2

	LDS $9F00
	STS ERASE_POS_HWR3_1+2
	LDU #ERASE_DATA_HWR3_2
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
	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$2200
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$2239
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$3219
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$22
	LDX #$d399
	PSHS A,X

	LEAS 39,S
	LDD 40,S
	PSHU D
	LDA #$ba
	ANDB #$F0
	ORB #$0d
	STD 40,S

	LDD 80,S
	PSHU D
	LDA #$bb
	ANDB #$F0
	ORB #$0d
	STD 80,S

	LDD 42,S
	PSHU D

	LDD 82,S
	PSHU D

	LDD #$230a
	STD 42,S

	LDD #$2299
	STD 82,S

	PULS D,X
	PSHU D,X,S
	LDD #$aa33
	LDX #$e19a
	PSHS D,X

	LEAS 120,S
	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$cd22
	PSHS A,X

	LEAS 40,S
	LDA 4,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 4,S

	LDD 40,S
	PSHU D
	ANDA #$0F
	ORA #$a0
	LDB #$d0
	STD 40,S

	LDA 44,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 44,S

	LDD 121,S
	PSHU D
	LDA #$ea
	ANDB #$0F
	ORB #$00
	STD 121,S

	LDA 123,S
	PSHU A
	ANDA #$F0
	ORA #$0b
	STA 123,S

	LDA 42,S
	PSHU A

	LDD 81,S
	PSHU D

	LDA #$aa
	STA 42,S

	LDD #$eadc
	STD 81,S

	PULS A,X
	PSHU A,X,S
	LDA #$9a
	LDX #$dd23
	PSHS A,X

	LEAS 282,S
	LDD -2,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$01f0
	STD -2,S

	LDA 38,S
	PSHU A
	ANDA #$F0
	ORA #$01
	STA 38,S

	LDA 78,S
	PSHU A
	ANDA #$F0
	ORA #$01
	STA 78,S

	LDA 118,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA 118,S

	LDA -121,S
	PSHU A

	LDA -119,S
	PSHU A

	LDA -81,S
	PSHU A

	LDA -79,S
	PSHU A

	LDA -41,S
	PSHU A

	LDA -39,S
	PSHU A

	LDA 1,S
	PSHU A

	LDA 41,S
	PSHU A

	LDA 81,S
	PSHU A

	LDA 121,S
	PSHU A,S

	LDA #$ea
	STA -121,S

	LDA #$bb
	STA -119,S

	LDA #$19
	STA -81,S

	LDA #$bf
	STA -79,S

	LDA #$e0
	STA -41,S

	LDA #$af
	STA -39,S

	LDA #$ef
	STA 1,S

	LDA #$1f
	STA 41,S

	LDA #$11
	STA 81,S

	LDA #$1e
	STA 121,S

	LEAS 198,S
	LDA -40,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -40,S

	LDA -37,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA -37,S

	LDA ,S
	PSHU A
	ANDA #$F0
	ORA #$00
	STA ,S

	LDA 40,S
	PSHU A,S
	ANDA #$F0
	ORA #$01
	STA 40,S


	LDS $9F00+2
	STS ERASE_POS_HWR3_2+2
	LDU #ERASE_DATA_HWR3_END

	LEAS 482,S
	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cd
	STD -41,S

	LDA -39,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -39,S

	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cd
	STD -1,S

	LDA -120,S
	PSHU A

	LDA -80,S
	PSHU A

	LDA 1,S
	PSHU A

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D,S

	LDA #$ac
	STA 1,S

	LDD #$d2aa
	STD 40,S

	LDA #$cc
	STA -120,S

	STA -80,S

	LDA #$c2
	STD 80,S

	STD 120,S

	LEAS 160,S
	LDD ,S
	PSHU D,S

	LDD #$cdda
	STD ,S

	LEAS 159,S
	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ca
	STD -80,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -40,S

	LDD -119,S
	PSHU D

	LDA -78,S
	PSHU A

	LDA -38,S
	PSHU A

	LDD #$ccba
	STD -119,S

	LDA #$bc
	STA -78,S

	LDA #$b0
	STA -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$ccba
	PSHS A,X

	LEAS 40,S
	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDD #$ddb2
	STD 121,S

	LDD #$dcbb
	STD 81,S

	LDB #$b9
	STD 41,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$dcb9
	PSHS A,X

	LEAS 281,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$0d
	STD -121,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD -81,S

	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$30
	STD -41,S

	LDD -2,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$a2
	STD -2,S

	LDD ,S
	PSHU D
	LDA #$e3
	ANDB #$F0
	ORB #$09
	STD ,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$b3
	STD 38,S

	LDD 78,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0ba0
	STD 78,S

	LDA 118,S
	PSHU A
	ANDA #$F0
	ORA #$0b
	STA 118,S

	LDA -119,S
	PSHU A

	LDA -79,S
	PSHU A

	LDA -39,S
	PSHU A

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDA 120,S
	PSHU A,S

	LDA #$31
	STA -39,S

	LDD #$0239
	STD 40,S

	LDD #$d21e
	STD 80,S

	LDA #$c2
	STA 120,S

	LDA #$22
	STA -119,S

	STA -79,S

	LEAS 280,S
	LDA -122,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA -122,S

	LDA -118,S
	PSHU A
	ANDA #$F0
	ORA #$0f
	STA -118,S

	LDD -82,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$0a0e
	STD -82,S

	LDA -78,S
	PSHU A
	ANDA #$F0
	ORA #$02
	STA -78,S

	LDD -39,S
	PSHU D
	ANDA #$0F
	ORA #$a0
	LDB #$ff
	STD -39,S

	LDD -1,S
	PSHU D
	LDA #$10
	ANDB #$F0
	ORB #$0d
	STD -1,S

	LDD 41,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$b1
	STD 41,S

	LDD 79,S
	PSHU D
	LDA #$e1
	ANDB #$0F
	ORB #$00
	STD 79,S

	LDD 81,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$be
	STD 81,S

	LDD 121,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0aa0
	STD 121,S

	LDA -120,S
	PSHU A

	LDA -80,S
	PSHU A

	LDD -41,S
	PSHU D

	LDD 1,S
	PSHU D

	LDD 39,S
	PSHU D

	LDA 119,S
	PSHU A,S

	LDA #$dc
	STA -80,S

	LDD #$100d
	STD -41,S

	LDD #$e0d0
	STD 39,S

	LDA #$e1
	STA 119,S

	LDD #$ccff
	STD 1,S

	STA -120,S

	LEAS 259,S
	LDD -98,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$09a0
	STD -98,S

	LDD -58,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$00e0
	STD -58,S

	LDA -18,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -18,S

	LDA 60,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 60,S

	LDA 100,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 100,S

	LDA -100,S
	PSHU A

	LDA -60,S
	PSHU A

	LDA -20,S
	PSHU A

	LDA 20,S
	PSHU A,S

	LDA #$e1
	STA -100,S

	LDA #$1f
	STA 20,S

	LDA #$0a
	STA -60,S

	STA -20,S

SSAV_HWR3
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HWR3
	PSHS U,DP
	STS ERASE_SSAV_HWR3+2

ERASE_POS_HWR3_1
	LDS #$0000
	LDU #ERASE_DATA_HWR3_1

ERASE_CODE_HWR3_1
	PULU A,S
	STA 40,S

	PULU A,B
	STA ,S
	STB -37,S

	PULU A
	STA -40,S

	PULU A,S
	STA 121,S

	PULU A,B
	STA 81,S
	STB 41,S

	PULU A,B
	STA 1,S
	STB -39,S

	PULU A,B
	STA -41,S
	STB -79,S

	PULU A,B
	STA -81,S
	STB -119,S

	PULU A,B
	STA -121,S
	STB 118,S

	PULU A,B,X
	STA 78,S
	STB 38,S
	STX -2,S

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 81,S

	PULU A,B,X
	STA 42,S
	STB 123,S
	STX 121,S

	PULU A,X
	STA 44,S
	STX 40,S

	PULU A
	STA 4,S

	PULU B,X,S
	PSHS B,X



	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 82,S
	STX 42,S
	STY 80,S

	PULU D
	STD 40,S

	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X



	PULU B,X,S
	PSHS B,X



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

ERASE_POS_HWR3_2
	LDS #$0000
	LDU #ERASE_DATA_HWR3_2

ERASE_CODE_HWR3_2
	PULU A,S
	STA 20,S

	PULU A,B
	STA -20,S
	STB -60,S

	PULU A,B
	STA -100,S
	STB 100,S

	PULU A,B,X,Y
	STA 60,S
	STB -18,S
	STX -58,S
	STY -98,S

	PULU A,S
	STA 119,S

	PULU D,X,Y
	STD 39,S
	STX 1,S
	STY -41,S

	PULU A,B,X,Y
	STA -80,S
	STB -120,S
	STX 121,S
	STY 81,S

	PULU D,X,Y
	STD 79,S
	STX 41,S
	STY -1,S

	PULU D
	STD -39,S

	PULU A,X
	STA -78,S
	STX -82,S

	PULU A,B
	STA -118,S
	STB -122,S

	PULU A,S
	STA 120,S

	PULU D,X
	STD 80,S
	STX 40,S

	PULU A,B
	STA -39,S
	STB -79,S

	PULU A,B,X,Y
	STA -119,S
	STB 118,S
	STX 78,S
	STY 38,S

	PULU D,X,Y
	STD ,S
	STX -2,S
	STY -41,S

	PULU D,X
	STD -81,S
	STX -121,S

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
	STD ,S



	PULU D,S
	STD 120,S

	PULU D,X
	STD 80,S
	STX 40,S

	PULU A,B
	STA 1,S
	STB -80,S

	PULU A,X
	STA -120,S
	STX -1,S

	PULU A,X
	STA -39,S
	STX -41,S

ERASE_SSAV_HWR3
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HWR3_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWR3_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWR3_END
