(main)IMG.ASM
	ORG $ACE3
DRAW_HJR7
	PSHS U,DP
	STS SSAV_HJR7+2

	LDS $9F00
	STS ERASE_POS_HJR7_1+2
	LDU #ERASE_DATA_HJR7_2
	LEAS 544,S

	LDD 18,S
	PSHU D

	LDA -61,S
	PSHU A

	LDA 60,S
	PSHU A

	ANDA #$0F
	ORA #$f0
	STA 60,S

	LDD 58,S
	PSHU D,S

	LDD #$111a
	STD 18,S

	LDD -22,S
	PSHU D

	ANDA #$F0
	ORA #$01
	LDB #$ff
	STD -22,S

	STB -61,S

	LDD #$e0ea
	STD 58,S

	LEAS 218,S

	LDD -79,S
	PSHU D

	LDA #$9a
	ANDB #$0F
	ORB #$f0
	STD -79,S

	LDA -38,S
	PSHU A

	LDD -119,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$09f0
	STD -119,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$09
	LDB #$a9
	STD -40,S

	LDA #$fa
	STA -38,S

	PULS A,X
	PSHU A,X,S

	LDA #$0a
	LDX #$a0ca
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$11
	LDX #$a0cc
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$33
	LDX #$cdcc
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$aa
	LDX #$cdac
	PSHS A,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	LDD 119,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$ac
	STD 119,S

	LDD #$accc
	STD 40,S

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 42,S

	LDD 79,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$ac
	STD 79,S

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDD #$dcaa
	STD 81,S

	LDA #$cc
	STD 121,S

	PULS A,X
	PSHU A,X,S

	LDX #$cdac
	PSHS B,X

	LEAS 180,S

	LDD -19,S
	PSHU D

	LDD 19,S
	PSHU D,S

	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD 19,S

	LDD -21,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD -21,S

	LDD 21,S
	PSHU D

	LDD #$ccac
	STD -19,S

	LDB #$cc
	STD 21,S

	LEAS 180,S

	LDD -121,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD -121,S

	LDD -39,S
	PSHU D

	LDD -119,S
	PSHU D

	LDA #$ac
	ANDB #$0F
	ORB #$d0
	STD -119,S

	LDD -81,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD -81,S

	LDD -79,S
	PSHU D

	LDD #$acaa
	STD -79,S

	LDD #$adac
	STD -39,S

	LDD -41,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD -41,S

	PULS A,X
	PSHU A,X,S

	LDX #$adcc
	PSHS B,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$0dcc
	STD 40,S

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 42,S

	LDD #$dddc
	STD 80,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$ccdd
	PSHS A,X

	LEAS 120,S

	LDD 120,S
	PSHU D

	LDA #$dd
	ANDB #$F0
	ORB #$0d
	STD 120,S

	LDA 82,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 82,S

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA 42,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$dddd
	STD 80,S

	LDA #$dc
	STD 40,S

	PULS A,X
	PSHU A,X,S

	LDX #$dcac
	PSHS B,X

	LEAS 201,S

	LDA -1,S
	PSHU A

	ANDA #$F0
	ORA #$0d
	STA -1,S

	LDA -41,S
	PSHU A,S

	STB -41,S

	LDA 40,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 40,S


	LDS $9F00+2
	STS ERASE_POS_HJR7_2+2
	LDU #ERASE_DATA_HJR7_END

	LEAS 603,S

	LDD -41,S
	PSHU D

	LDD 79,S
	PSHU D

	LDA 40,S
	PSHU A

	LDD #$aa91
	STD 79,S

	LDA 120,S
	PSHU A

	LDD 118,S
	PSHU D

	ANDA #$F0
	ORA #$09
	LDB #$aa
	STD 118,S

	LDD #$00af
	STD -41,S

	STB 40,S

	LDA -121,S
	PSHU A

	LDA ,S
	PSHU A

	STB ,S

	LDA #$ff
	STA -121,S

	LDD 38,S
	PSHU D,S

	ANDA #$F0
	ORA #$0e
	LDB #$99
	STD 38,S

	LDA -2,S
	PSHU A

	ANDA #$F0
	ORA #$01
	STA -2,S

	LDA -81,S
	PSHU A

	LDA #$11
	STA -81,S

	LDA #$ae
	STA 120,S

	LEAS 278,S

	LDD -120,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$aa
	STD -120,S

	LDA -38,S
	PSHU A

	LDA -118,S
	PSHU A

	LDD -79,S
	PSHU D

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$aa
	STD -40,S

	LDA #$ca
	STA -38,S

	STA -118,S

	LDA #$aa
	STD -79,S

	PULS A,X
	PSHU A,X,S

	LDA #$d0
	LDX #$19ab
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$d9
	LDX #$32ab
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$da
	LDX #$32ab
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$ca
	LDX #$32ca
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$ca
	LDX #$c3ca
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$da
	LDX #$cccc
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$cccc
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$cccd
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$ccca
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$dccc
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$3d
	LDX #$cccc
	PSHS A,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$00dc
	STD 40,S

	LDA 42,S
	PSHU A

	ANDA #$F0
	ORA #$0d
	STA 42,S

	LDD #$dddd
	STD 80,S

	LDA 82,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 82,S

	PULS A,X
	PSHU A,X,S

	LDX #$dddd
	PSHS B,X

	LEAS 120,S

	PULS A,X
	PSHU A,X,S

	LDX #$ddca
	PSHS B,X

	LEAS 40,S

	LDA 42,S
	PSHU A

	STB 42,S

	LDA 82,S
	PSHU A

	STB 82,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0dc0
	STD 40,S

	LDD 80,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0dc0
	STD 80,S

	LDA 121,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 121,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$cddc
	PSHS A,X

	LEAS 181,S

	LDA 20,S
	PSHU A,S

	LDA -20,S
	PSHU A

	LDA #$dd
	STA -20,S

	STA 20,S

SSAV_HJR7
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HJR7
	PSHS U,DP
	STS ERASE_SSAV_HJR7+2

ERASE_POS_HJR7_1
	LDS #$0000
	LDU #ERASE_DATA_HJR7_1

ERASE_CODE_HJR7_1
	PULU A,B,S
	STA 40,S
	STB -41,S

	PULU A
	STA -1,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 80,S
	STX 40,S

	PULU A,B,X
	STA 42,S
	STB 82,S
	STX 120,S

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA 42,S
	STX 80,S
	STY 40,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD -41,S
	STX -79,S
	STY -81,S

	PULU D,X,Y
	STD -119,S
	STX -39,S
	STY -121,S

	PULU D,X,Y,S
	STD 21,S
	STX -21,S
	STY 19,S

	PULU D
	STD -19,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 121,S
	STX 81,S
	STY 79,S

	PULU A,X,Y
	STA 42,S
	STX 119,S
	STY 40,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -40,S
	STX -119,S

	PULU A,X
	STA -38,S
	STX -79,S

	PULU D,X,S
	STD -22,S
	STX 58,S

	PULU A,B,X
	STA 60,S
	STB -61,S
	STX 18,S

ERASE_POS_HJR7_2
	LDS #$0000
	LDU #ERASE_DATA_HJR7_2

ERASE_CODE_HJR7_2
	PULU A,B,S
	STA -20,S
	STB 20,S

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA 121,S
	STX 80,S
	STY 40,S

	PULU A,B
	STA 82,S
	STB 42,S

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

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -40,S
	STX -79,S

	PULU A,B,X
	STA -118,S
	STB -38,S
	STX -120,S

	PULU A,B,X,S
	STA -81,S
	STB -2,S
	STX 38,S

	PULU A,B,X
	STA ,S
	STB -121,S
	STX 118,S

	PULU A,B,X,Y
	STA 120,S
	STB 40,S
	STX 79,S
	STY -41,S

ERASE_SSAV_HJR7
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HJR7_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HJR7_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HJR7_END
