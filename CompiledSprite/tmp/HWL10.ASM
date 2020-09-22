(main)IMG.ASM
	ORG $A68A
DRAW_HWL10
	PSHS U,DP
	STS SSAV_HWL10+2

	LDS $9F00
	STS ERASE_POS_HWL10_1+2
	LDU #ERASE_DATA_HWL10_2
	LEAS 442,S

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDA -79,S
	PSHU A

	LDD -39,S
	PSHU D

	LDA #$aa
	ANDB #$0F
	ORB #$c0
	STD -39,S

	STA -79,S

	LDD 40,S
	PSHU D

	LDD #$adcd
	STD 40,S

	LDA #$a3
	STD 80,S

	STD 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$ccdd
	PSHS A,X

	LEAS 280,S

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

	LDD #$aacc
	STD -120,S

	LDA #$bc
	STD -40,S

	LDA #$da
	STD -80,S

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

	LDD #$bacc
	STD 80,S

	STD 40,S

	LDA #$bc
	STD 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$ba
	LDX #$ccdd
	PSHS A,X

	LEAS 280,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD #$2bcd
	STD -120,S

	LDA -118,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -118,S

	LDD #$22dd
	STD -80,S

	LDA -78,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA -78,S

	LDD -40,S
	PSHU D

	LDD #$a2d0
	STD -40,S

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA -38,S

	PULS A,X
	PSHU A,X,S

	LDA #$aa
	LDX #$0ddc
	PSHS A,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$90
	STA 42,S

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

	LDD 41,S
	PSHU D

	LDD #$dd9e
	STD 41,S

	LDA 82,S
	PSHU A

	LDA #$a1
	STA 82,S

	LDD 119,S
	PSHU D

	ANDA #$0F
	ORA #$f0
	LDB #$dd
	STD 119,S

	LDD 121,S
	PSHU D

	LDD #$cd1f
	STD 121,S

	PULS A,X
	PSHU A,X,S

	LDA #$aa
	LDX #$ed9e
	PSHS A,X

	LEAS 281,S

	LDA 118,S
	PSHU A

	ANDA #$F0
	ORA #$00
	STA 118,S

	LDD -82,S
	PSHU D

	LDA #$1a
	ANDB #$0F
	ORB #$d0
	STD -82,S

	LDA -39,S
	PSHU A

	LDA 81,S
	PSHU A

	LDA #$bb
	STA -39,S

	LDD -42,S
	PSHU D

	LDA #$1a
	ANDB #$0F
	ORB #$d0
	STD -42,S

	LDA 41,S
	PSHU A

	LDA 1,S
	PSHU A

	LDD -122,S
	PSHU D

	ANDA #$0F
	ANDB #$0F
	ADDD #$10d0
	STD -122,S

	LDD -2,S
	PSHU D

	LDA #$9a
	ANDB #$0F
	ORB #$90
	STD -2,S

	LDD 78,S
	PSHU D

	LDA #$e1
	ANDB #$0F
	ORB #$90
	STD 78,S

	LDD 38,S
	PSHU D,S

	LDA #$01
	ANDB #$0F
	ORB #$90
	STD 38,S

	LDD -120,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$ff
	STD -120,S

	LDA 121,S
	PSHU A

	LDA -79,S
	PSHU A

	STB 1,S

	LDA #$bb
	STA -79,S

	STB 41,S

	STB 81,S

	STB 121,S

	LEAS 200,S

	LDA -39,S
	PSHU A

	LDA -42,S
	PSHU A

	ANDA #$F0
	ORA #$0e
	STA -42,S

	LDA #$11
	STA -39,S

	LDA 1,S
	PSHU A,S

	LDA #$1e
	STA 1,S

	LDA 41,S
	PSHU A

	ANDA #$0F
	ORA #$e0
	STA 41,S


	LDS $9F00+2
	STS ERASE_POS_HWL10_2+2
	LDU #ERASE_DATA_HWL10_END

	LEAS 443,S

	LDD -41,S
	PSHU D

	LDD -81,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0aa0
	STD -81,S

	LDD #$aacc
	STD -41,S

	LDD -1,S
	PSHU D

	LDD #$dacd
	STD -1,S

	LDD 39,S
	PSHU D,S

	LDD #$2cdd
	STD 39,S

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

	LEAS 238,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$ad
	STD -40,S

	LDA -38,S
	PSHU A

	LDA -78,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -78,S

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

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$09
	LDB #$aa
	STD 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	LDA 42,S
	PSHU A

	LDA #$dd
	STA 42,S

	LDD 80,S
	PSHU D

	LDD #$a9cc
	STD 80,S

	LDA 82,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 82,S

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

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$2d
	STD 80,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$02
	LDB #$23
	STD 40,S

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

	LDD 121,S
	PSHU D

	LDD #$d10d
	STD 121,S

	LDA 42,S
	PSHU A

	LDA 119,S
	PSHU A

	LDA #$de
	STA 42,S

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

	LDA #$0f
	STA 119,S

	LDA 123,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA 123,S

	PULS A,X
	PSHU A,X,S

	LDA #$ab
	LDX #$23dd
	PSHS A,X

	LEAS 281,S

	LDD -79,S
	PSHU D

	LDA #$de
	ANDB #$0F
	ORB #$a0
	STD -79,S

	LDD -120,S
	PSHU D

	LDA -118,S
	PSHU A

	ANDA #$0F
	ORA #$10
	STA -118,S

	LDD -2,S
	PSHU D

	ANDA #$F0
	ANDB #$F0
	ADDD #$000a
	STD -2,S

	LDD #$0dcd
	STD -120,S

	LDA 82,S
	PSHU A

	ANDA #$0F
	ORA #$10
	STA 82,S

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

	LDA -82,S
	PSHU A

	LDA #$e1
	STA -82,S

	LDA 119,S
	PSHU A

	LDD 38,S
	PSHU D

	ANDA #$F0
	ORA #$0e
	LDB #$fa
	STD 38,S

	LDD 78,S
	PSHU D

	ANDA #$F0
	ORA #$0e
	LDB #$ea
	STD 78,S

	LDD 1,S
	PSHU D,S

	ANDA #$F0
	ANDB #$0F
	ADDD #$09a0
	STD 1,S

	LDD 41,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0910
	STD 41,S

	LDA -122,S
	PSHU A

	LDA #$01
	STA -122,S

	LDA #$19
	STA 119,S

	LDA 122,S
	PSHU A

	ANDA #$0F
	ORA #$10
	STA 122,S

	LEAS 239,S

	LDA -77,S
	PSHU A

	ANDA #$0F
	ORA #$e0
	STA -77,S

	LDA 40,S
	PSHU A

	LDA -80,S
	PSHU A

	LDA ,S
	PSHU A

	LDA #$10
	STA -80,S

	LDA #$0e
	STA 40,S

	LDA -40,S
	PSHU A

	LDA #$ee
	STA ,S

	STA -40,S

	LDA -37,S
	PSHU A,S

	ANDA #$0F
	ORA #$e0
	STA -37,S

	LDA 80,S
	PSHU A

	ANDA #$0F
	ORA #$e0
	STA 80,S

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
	STA 41,S
	STB 1,S

	PULU A,B
	STA -42,S
	STB -39,S

	PULU A,B,X,Y,S
	STA -79,S
	STB 121,S
	STX -120,S
	STY 38,S

	PULU D,X,Y
	STD 78,S
	STX -2,S
	STY -122,S

	PULU A,B,X
	STA 1,S
	STB 41,S
	STX -42,S

	PULU A,B,X
	STA 81,S
	STB -39,S
	STX -82,S

	PULU A
	STA 118,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 121,S
	STX 119,S

	PULU A,X,Y
	STA 82,S
	STX 41,S
	STY 80,S

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

	PULU A,X
	STA -38,S
	STX -40,S

	PULU A,B,X,Y
	STA -78,S
	STB -118,S
	STX -80,S
	STY -120,S

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

	PULU D,X
	STD -120,S
	STX -40,S

	PULU A,X
	STA -38,S
	STX -80,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 40,S
	STX -39,S

	PULU A,X,Y
	STA -79,S
	STX 120,S
	STY 80,S

ERASE_POS_HWL10_2
	LDS #$0000
	LDU #ERASE_DATA_HWL10_2

ERASE_CODE_HWL10_2
	PULU A,B,S
	STA 80,S
	STB -37,S

	PULU A,B
	STA -40,S
	STB ,S

	PULU A,B
	STA -80,S
	STB 40,S

	PULU A
	STA -77,S

	PULU A,B,X,Y,S
	STA 122,S
	STB -122,S
	STX 41,S
	STY 1,S

	PULU D,X
	STD 78,S
	STX 38,S

	PULU A,B,X
	STA 119,S
	STB -82,S
	STX -39,S

	PULU A,B,X
	STA -42,S
	STB 82,S
	STX -2,S

	PULU A,X,Y
	STA -118,S
	STX -120,S
	STY -79,S

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA 123,S
	STX 82,S
	STY 80,S

	PULU A,B,X,Y
	STA 119,S
	STB 42,S
	STX 121,S
	STY 40,S

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
	STX 40,S
	STY 80,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA 82,S
	STX 80,S

	PULU A,B,X
	STA 42,S
	STB 3,S
	STX 40,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -80,S
	STX -120,S

	PULU A,B,X
	STA -78,S
	STB -38,S
	STX -40,S

	PULU A,X,Y,S
	STA 80,S
	STX 78,S
	STY 39,S

	PULU D,X,Y
	STD -1,S
	STX -81,S
	STY -41,S

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
