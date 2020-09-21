(main)IMG.ASM
	ORG $CBF3
DRAW_HWL10
	PSHS U,DP
	STS SSAV_HWL10+2

	LDS $9F00
	STS ERASE_POS_HWL10_1+2
	LDU #ERASE_DATA_HWL10_2
	LEAS 442,S
	LDD -39,S
	PSHU D
	LDA #$aa
	ANDB #$0F
	ORB #$c0
	STD -39,S

	LDA -79,S
	PSHU A

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDA #$aa
	STA -79,S

	LDD #$a3cd
	STD 80,S

	STD 120,S

	LDA #$ad
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$ccdd
	PSHS A,X

	LEAS 280,S
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

	LDD #$dacc
	STD -80,S

	LDA #$aa
	STD -120,S

	LDA #$bc
	STD -40,S

	PULS A,X
	PSHU A,X,S
	LDA #$bc
	LDX #$cccc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ba
	LDX #$ccdd
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$bccc
	STD 120,S

	LDA #$ba
	STD 40,S

	STD 80,S

	PULS A,X
	PSHU A,X,S
	LDA #$ba
	LDX #$ccdd
	PSHS A,X

	LEAS 280,S
	LDA -118,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -118,S

	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -78,S

	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -38,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD #$2bcd
	STD -120,S

	LDD #$22dd
	STD -80,S

	LDD #$a2d0
	STD -40,S

	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$0ddc
	PSHS A,X

	LEAS 40,S
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA 42,S

	LDD 40,S
	PSHU D

	LDD #$ba2d
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$3dad
	PSHS A,X

	LEAS 80,S
	PULS A,X
	PSHU A,X,S
	LDA #$bb
	LDX #$2d00
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ba
	LDX #$3da1
	PSHS A,X

	LEAS 40,S
	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$d0
	STD 80,S

	LDD 119,S
	PSHU D
	ANDA #$0F
	ORA #$f0
	LDB #$dd
	STD 119,S

	LDD 41,S
	PSHU D

	LDA 82,S
	PSHU A

	LDD 121,S
	PSHU D

	LDD #$dd9e
	STD 41,S

	LDA #$a1
	STA 82,S

	LDD #$cd1f
	STD 121,S

	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$ed9e
	PSHS A,X

	LEAS 281,S
	LDD -122,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$10d0
	STD -122,S

	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ff
	STD -120,S

	LDD -82,S
	PSHU D
	LDA #$1a
	ANDB #$0F
	ORB #$d0
	STD -82,S

	LDD -42,S
	PSHU D
	LDA #$1a
	ANDB #$0F
	ORB #$d0
	STD -42,S

	LDD -2,S
	PSHU D
	LDA #$9a
	ANDB #$0F
	ORB #$90
	STD -2,S

	LDD 38,S
	PSHU D
	LDA #$01
	ANDB #$0F
	ORB #$90
	STD 38,S

	LDD 78,S
	PSHU D
	LDA #$e1
	ANDB #$0F
	ORB #$90
	STD 78,S

	LDA 118,S
	PSHU A
	ANDA #$F0
	ORA #$00
	STA 118,S

	LDA -79,S
	PSHU A

	LDA -39,S
	PSHU A

	LDA 1,S
	PSHU A

	LDA 41,S
	PSHU A

	LDA 81,S
	PSHU A,S

	LDA 121,S
	PSHU A

	LDA #$ff
	STA 1,S

	STA 41,S

	STA 81,S

	STA 121,S

	LDA #$bb
	STA -79,S

	STA -39,S

	LEAS 200,S
	LDA -42,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -42,S

	LDA 41,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 41,S

	LDA -39,S
	PSHU A,S

	LDA 1,S
	PSHU A

	LDA #$11
	STA -39,S

	LDA #$1e
	STA 1,S


	LDS $9F00+2
	STS ERASE_POS_HWL10_2+2
	LDU #ERASE_DATA_HWL10_END

	LEAS 443,S
	LDD -81,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0aa0
	STD -81,S

	LDD 78,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$2d
	STD 78,S

	LDA 80,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 80,S

	LDD -41,S
	PSHU D,S

	LDD -1,S
	PSHU D

	LDD 39,S
	PSHU D

	LDD #$aacc
	STD -41,S

	LDD #$dacd
	STD -1,S

	LDD #$2cdd
	STD 39,S

	LEAS 238,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$2d
	STD -120,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$2d
	STD -80,S

	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -78,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ad
	STD -40,S

	LDA -38,S
	PSHU A

	LDA #$cc
	STA -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$ca
	LDX #$aacc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ac
	LDX #$abcd
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$c0
	LDX #$aacd
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$aa
	STD 40,S

	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 82,S

	LDA 42,S
	PSHU A

	LDD 80,S
	PSHU D

	LDA #$dd
	STA 42,S

	LDD #$a9cc
	STD 80,S

	PULS A,X
	PSHU A,X,S
	LDA #$ca
	LDX #$aadd
	PSHS A,X

	LEAS 120,S
	PULS A,X
	PSHU A,X,S
	LDA #$92
	LDX #$2ccc
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$02
	LDB #$23
	STD 40,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$2d
	STD 80,S

	LDA 42,S
	PSHU A

	LDA 82,S
	PSHU A

	LDA #$dd
	STA 42,S

	STA 82,S

	PULS A,X
	PSHU A,X,S
	LDA #$02
	LDX #$23dc
	PSHS A,X

	LEAS 120,S
	PULS A,X
	PSHU A,X,S
	LDA #$ab
	LDX #$10dd
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ab
	LDX #$ed0a
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ab
	LDX #$31d0
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$32
	STD 40,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$13
	STD 80,S

	LDD 82,S
	PSHU D
	LDA #$dc
	ANDB #$0F
	ORB #$00
	STD 82,S

	LDA 123,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 123,S

	LDA 42,S
	PSHU A

	LDA 119,S
	PSHU A

	LDD 121,S
	PSHU D

	LDA #$de
	STA 42,S

	LDA #$0f
	STA 119,S

	LDD #$d10d
	STD 121,S

	PULS A,X
	PSHU A,X,S
	LDA #$ab
	LDX #$23dd
	PSHS A,X

	LEAS 281,S
	LDA -118,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA -118,S

	LDD -79,S
	PSHU D
	LDA #$de
	ANDB #$0F
	ORB #$a0
	STD -79,S

	LDA -42,S
	PSHU A
	ANDA #$F0
	ORA #$00
	STA -42,S

	LDD -39,S
	PSHU D
	LDA #$d9
	ANDB #$0F
	ORB #$a0
	STD -39,S

	LDD -2,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$000a
	STD -2,S

	LDD 1,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$09a0
	STD 1,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$fa
	STD 38,S

	LDD 41,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0910
	STD 41,S

	LDD 78,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$ea
	STD 78,S

	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 82,S

	LDA 122,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 122,S

	LDA -122,S
	PSHU A

	LDD -120,S
	PSHU D,S

	LDA -82,S
	PSHU A

	LDA 119,S
	PSHU A

	LDA #$01
	STA -122,S

	LDD #$0dcd
	STD -120,S

	LDA #$e1
	STA -82,S

	LDA #$19
	STA 119,S

	LEAS 239,S
	LDA -77,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA -77,S

	LDA -37,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA -37,S

	LDA 80,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 80,S

	LDA -80,S
	PSHU A

	LDA -40,S
	PSHU A

	LDA ,S
	PSHU A,S

	LDA 40,S
	PSHU A

	LDA #$10
	STA -80,S

	LDA #$0e
	STA 40,S

	LDA #$ee
	STA -40,S

	STA ,S

SSAV_HWL10
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HWL10
	PSHS U,DP
	STS ERASE_SSAV_HWL10+2

ERASE_POS_HWL10_1
	LDS #$0000
	LDU #ERASE_DATA_HWL10_1

ERASE_CODE_HWL10_1
	PULU A,B,S
	STA 1,S
	STB -39,S

	PULU A,B
	STA 41,S
	STB -42,S

	PULU A,B,S
	STA 121,S
	STB 81,S

	PULU A,B
	STA 41,S
	STB 1,S

	PULU A,B
	STA -39,S
	STB -79,S

	PULU A,X,Y
	STA 118,S
	STX 78,S
	STY 38,S

	PULU D,X,Y
	STD -2,S
	STX -42,S
	STY -82,S

	PULU D,X
	STD -120,S
	STX -122,S

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 121,S

	PULU A,X,Y
	STA 82,S
	STX 41,S
	STY 119,S

	PULU D
	STD 80,S

	PULU B,X,S
	PSHS B,X

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

	PULU D,X,Y
	STD -40,S
	STX -80,S
	STY -120,S

	PULU A,B
	STA -38,S
	STB -78,S

	PULU A
	STA -118,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 120,S
	STX 80,S
	STY 40,S

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

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 120,S
	STX 80,S
	STY 40,S

	PULU A,X
	STA -79,S
	STX -39,S

ERASE_POS_HWL10_2
	LDS #$0000
	LDU #ERASE_DATA_HWL10_2

ERASE_CODE_HWL10_2
	PULU A,B,S
	STA 40,S
	STB ,S

	PULU A,B
	STA -40,S
	STB -80,S

	PULU A,B
	STA 80,S
	STB -37,S

	PULU A
	STA -77,S

	PULU A,B,X,S
	STA 119,S
	STB -82,S
	STX -120,S

	PULU A,B
	STA -122,S
	STB 122,S

	PULU A,X,Y
	STA 82,S
	STX 78,S
	STY 41,S

	PULU D,X,Y
	STD 38,S
	STX 1,S
	STY -2,S

	PULU D
	STD -39,S

	PULU A,X
	STA -42,S
	STX -79,S

	PULU A
	STA -118,S

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 121,S

	PULU A,B
	STA 119,S
	STB 42,S

	PULU A,X,Y
	STA 123,S
	STX 82,S
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

	PULU A,B,X,Y
	STA 82,S
	STB 42,S
	STX 80,S
	STY 40,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 80,S

	PULU A,B,X
	STA 42,S
	STB 82,S
	STX 40,S

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA -38,S
	STX -40,S

	PULU A,X,Y
	STA -78,S
	STX -80,S
	STY -120,S

	PULU D,X,Y,S
	STD 39,S
	STX -1,S
	STY -41,S

	PULU A,X,Y
	STA 80,S
	STX 78,S
	STY -81,S

ERASE_SSAV_HWL10
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HWL10_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWL10_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWL10_END
