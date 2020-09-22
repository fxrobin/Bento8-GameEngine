(main)IMG.ASM
	ORG $AEAB
DRAW_HWL9
	PSHS U,DP
	STS SSAV_HWL9+2

	LDS $9F00
	STS ERASE_POS_HWL9_1+2
	LDU #ERASE_DATA_HWL9_2
	LEAS 482,S

	LDD 80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -38,S

	LDD 40,S
	PSHU D

	LDD 120,S
	PSHU D

	LDA -119,S
	PSHU A

	LDA -79,S
	PSHU A

	LDD #$a3cd
	STD 40,S

	STD 80,S

	LDD #$ddcc
	STD -40,S

	LDA #$aa
	STA -79,S

	STA -119,S

	STD 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$ad
	LDX #$cddd
	PSHS A,X

	LEAS 280,S

	LDD -40,S
	PSHU D

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -38,S

	LDA -78,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -78,S

	LDD -80,S
	PSHU D

	LDD -120,S
	PSHU D

	LDD #$dacc
	STD -120,S

	LDA #$bc
	STD -80,S

	STD -40,S

	PULS A,X
	PSHU A,X,S

	LDA #$ba
	LDX #$ccdc
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$ba
	LDX #$ccdd
	PSHS A,X

	LEAS 40,S

	LDD 80,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD #$bacc
	STD 40,S

	LDA #$bc
	STD 80,S

	LDD 120,S
	PSHU D

	LDD #$2bcd
	STD 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$ba
	LDX #$ccdd
	PSHS A,X

	LEAS 280,S

	LDD -80,S
	PSHU D

	LDD -120,S
	PSHU D

	LDA -118,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -118,S

	LDD #$a2dd
	STD -120,S

	LDB #$d0
	STD -80,S

	LDA -78,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA -78,S

	LDD -40,S
	PSHU D

	LDD #$a30d
	STD -40,S

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA -38,S

	PULS A,X
	PSHU A,X,S

	LDA #$ba
	LDX #$1ddd
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$ba
	LDX #$2cad
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$aa
	LDX #$2d99
	PSHS A,X

	LEAS 40,S

	LDD 39,S
	PSHU D

	ANDA #$0F
	ORA #$10
	LDB #$d0
	STD 39,S

	LDD 119,S
	PSHU D

	LDA #$0a
	ANDB #$0F
	ORB #$00
	STD 119,S

	LDD 41,S
	PSHU D

	LDD #$1cca
	STD 41,S

	LDD 79,S
	PSHU D

	LDA #$1a
	ANDB #$0F
	ORB #$00
	STD 79,S

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDD #$dc1f
	STD 81,S

	LDB #$af
	STD 121,S

	PULS A,X
	PSHU A,X,S

	LDA #$9a
	LDX #$2d90
	PSHS A,X

	LEAS 281,S

	LDD -82,S
	PSHU D

	LDA #$e0
	ANDB #$0F
	ORB #$00
	STD -82,S

	LDA -39,S
	PSHU A

	LDA 81,S
	PSHU A

	LDA #$9a
	STA 81,S

	LDA 38,S
	PSHU A

	ANDA #$F0
	ORA #$0e
	STA 38,S

	LDA -2,S
	PSHU A

	LDA 41,S
	PSHU A

	LDA #$1e
	STA -2,S

	LDA -79,S
	PSHU A

	LDD -120,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$0a
	STD -120,S

	LDA 1,S
	PSHU A

	STB -79,S

	LDA #$e1
	STA 41,S

	LDA -42,S
	PSHU A

	LDA #$a9
	STA 1,S

	LDA #$ee
	STA -42,S

	LDD -122,S
	PSHU D,S

	LDA #$ea
	ANDB #$0F
	ORB #$90
	STD -122,S

	LDA 78,S
	PSHU A

	ANDA #$F0
	ORA #$01
	STA 78,S

	LDA #$aa
	STA -39,S

	LDA 121,S
	PSHU A

	ANDA #$F0
	ORA #$0a
	STA 121,S

	LEAS 222,S

	LDA -20,S
	PSHU A

	ANDA #$0F
	ORA #$f0
	STA -20,S

	LDD -61,S
	PSHU D,S

	ANDA #$F0
	ANDB #$0F
	ADDD #$00f0
	STD -61,S

	LDA 20,S
	PSHU A

	ANDA #$0F
	ORA #$f0
	STA 20,S

	LDA 60,S
	PSHU A

	ANDA #$0F
	ORA #$10
	STA 60,S


	LDS $9F00+2
	STS ERASE_POS_HWL9_2+2
	LDU #ERASE_DATA_HWL9_END

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

	LDD 80,S
	PSHU D

	LDA 82,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 82,S

	LDD #$a9cc
	STD 80,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$09
	LDB #$aa
	STD 40,S

	LDD 42,S
	PSHU D

	LDA #$dd
	ANDB #$0F
	ORB #$d0
	STD 42,S

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

	LDA 42,S
	PSHU A

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$23
	STD 40,S

	LDA #$dd
	STA 42,S

	PULS A,X
	PSHU A,X,S

	LDA #$02
	LDX #$23cc
	PSHS A,X

	LEAS 80,S

	PULS A,X
	PSHU A,X,S

	LDA #$ab
	LDX #$2ddd
	PSHS A,X

	LEAS 40,S

	LDD 42,S
	PSHU D

	LDA #$d0
	ANDB #$0F
	ORB #$a0
	STD 42,S

	LDD 40,S
	PSHU D

	LDA #$bb
	ANDB #$F0
	ORB #$01
	STD 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$ab
	LDX #$100d
	PSHS A,X

	LEAS 80,S

	LDD 39,S
	PSHU D

	ANDA #$0F
	ORA #$10
	LDB #$aa
	STD 39,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$ab
	LDX #$33dd
	PSHS A,X

	LEAS 41,S

	LDD 38,S
	PSHU D

	LDA #$01
	ANDB #$F0
	ORB #$09
	STD 38,S

	PULS A,X
	PSHU A,X,S

	LDA #$11
	LDX #$dd9a
	PSHS A,X

	LEAS 40,S

	LDD 38,S
	PSHU D

	LDA #$10
	ANDB #$F0
	ORB #$0d
	STD 38,S

	PULS A,X
	PSHU A,X,S

	LDA #$e2
	LDX #$ddaa
	PSHS A,X

	LEAS 40,S

	LDD 38,S
	PSHU D

	ANDA #$F0
	ORA #$0e
	LDB #$aa
	STD 38,S

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$90
	STA 42,S

	LDD 40,S
	PSHU D

	LDA #$d1
	ANDB #$F0
	ORB #$0d
	STD 40,S

	LDD 78,S
	PSHU D

	ANDA #$F0
	ORA #$01
	LDB #$ea
	STD 78,S

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$cb
	STD 80,S

	LDD 118,S
	PSHU D

	ANDA #$F0
	ORA #$01
	LDB #$1a
	STD 118,S

	LDD 121,S
	PSHU D

	LDA #$cc
	ANDB #$0F
	ORB #$f0
	STD 121,S

	PULS A,X
	PSHU A,X,S

	LDA #$13
	LDX #$dd99
	PSHS A,X

	LEAS 281,S

	LDA 41,S
	PSHU A

	LDA 78,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA 78,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$09
	LDB #$fb
	STD -40,S

	LDA -2,S
	PSHU A

	LDA 38,S
	PSHU A

	LDA 1,S
	PSHU A

	LDA 81,S
	PSHU A

	LDA #$bb
	STA 1,S

	LDA #$a2
	STA 81,S

	LDD -80,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0bf0
	STD -80,S

	LDA -122,S
	PSHU A

	LDA -82,S
	PSHU A

	LDD -120,S
	PSHU D,S

	LDA #$dd
	ANDB #$0F
	ORB #$f0
	STD -120,S

	LDA 121,S
	PSHU A

	LDA -42,S
	PSHU A

	LDA #$19
	STA -122,S

	LDA #$1e
	STA -42,S

	STA -82,S

	LDA #$00
	STA 38,S

	LDA #$0e
	STA -2,S

	LDA #$bf
	STA 41,S

	LDA #$1f
	STA 121,S

	LEAS 181,S

	LDA 20,S
	PSHU A,S

	ANDA #$F0
	ORA #$01
	STA 20,S

	LDA -20,S
	PSHU A

	LDA #$ef
	STA -20,S

SSAV_HWL9
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HWL9
	PSHS U,DP
	STS ERASE_SSAV_HWL9+2

ERASE_POS_HWL9_1
	LDS #$0000
	LDU #ERASE_DATA_HWL9_1

ERASE_CODE_HWL9_1
	PULU A,B,X,S
	STA 60,S
	STB 20,S
	STX -61,S

	PULU A
	STA -20,S

	PULU A,B,X,S
	STA 121,S
	STB 78,S
	STX -122,S

	PULU A,B,X
	STA -42,S
	STB 1,S
	STX -120,S

	PULU A,B
	STA -79,S
	STB 41,S

	PULU A,B
	STA -2,S
	STB 38,S

	PULU A,B,X
	STA 81,S
	STB -39,S
	STX -82,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 121,S
	STX 81,S
	STY 79,S

	PULU D,X,Y
	STD 41,S
	STX 119,S
	STY 39,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA -38,S
	STX -40,S

	PULU A,B,X,Y
	STA -78,S
	STB -118,S
	STX -120,S
	STY -80,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 120,S
	STX 40,S
	STY 80,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -120,S
	STX -80,S

	PULU A,B,X
	STA -78,S
	STB -38,S
	STX -40,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA -79,S
	STB -119,S
	STX 120,S
	STY 40,S

	PULU A,X,Y
	STA -38,S
	STX -40,S
	STY 80,S

ERASE_POS_HWL9_2
	LDS #$0000
	LDU #ERASE_DATA_HWL9_2

ERASE_CODE_HWL9_2
	PULU A,B,S
	STA -20,S
	STB 20,S

	PULU A,B,X,S
	STA -42,S
	STB 121,S
	STX -120,S

	PULU A,B,X
	STA -82,S
	STB -122,S
	STX -80,S

	PULU A,B
	STA 81,S
	STB 1,S

	PULU A,B,X
	STA 38,S
	STB -2,S
	STX -40,S

	PULU A,B
	STA 78,S
	STB 41,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 121,S
	STX 118,S
	STY 80,S

	PULU D,X
	STD 78,S
	STX 40,S

	PULU A,X
	STA 42,S
	STX 38,S

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 38,S

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 38,S

	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA 3,S
	STX 39,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 40,S
	STX 42,S

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
	STD 42,S
	STX 40,S

	PULU A,X
	STA 82,S
	STX 80,S

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

ERASE_SSAV_HWL9
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HWL9_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWL9_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWL9_END
