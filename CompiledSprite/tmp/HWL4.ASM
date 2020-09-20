(main)IMG.ASM
	ORG $E0C2
DRAW_HWL4
	PSHS U,DP
	STS SSAV_HWL4+2

	LDS $9F00
	STS ERASE_POS_HWL4_1+2
	LDU #ERASE_DATA_HWL4_2
	LEAS 483,S
	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dc
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
	PSHU D

	LDD 79,S
	PSHU D

	LDD 119,S
	PSHU D,S

	LDD #$cadc
	STD -1,S

	LDA #$cc
	STA -120,S

	STA -80,S

	LDD #$aa2c
	STD 79,S

	STD 119,S

	LDB #$2d
	STD 39,S

	LEAS 279,S
	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -78,S

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
	STD -120,S

	LDD #$abcc
	STD -80,S

	LDD #$cbac
	STD -40,S

	PULS A,X
	PSHU A,X,S
	LDA #$0b
	LDX #$ccdc
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$bbcd
	STD 120,S

	LDA #$9b
	STD 40,S

	STD 80,S

	PULS A,X
	PSHU A,X,S
	LDA #$ab
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
	ORA #$c0
	STA -78,S

	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -38,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$1d
	STD 40,S

	LDD 80,S
	PSHU D
	ANDA #$0F
	ORA #$a0
	LDB #$23
	STD 80,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDA 42,S
	PSHU A

	LDA 82,S
	PSHU A

	LDA #$3b
	STA 42,S

	LDA #$1a
	STA 82,S

	LDD #$2bdd
	STD -120,S

	LDA #$22
	STD -40,S

	LDB #$d0
	STD -80,S

	PULS A,X
	PSHU A,X,S
	LDA #$13
	LDX #$0ddb
	PSHS A,X

	LEAS 120,S
	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$23eb
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$99
	LDX #$23ea
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$a0
	LDX #$2cca
	PSHS A,X

	LEAS 40,S
	LDD 39,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$f090
	STD 39,S

	LDD 81,S
	PSHU D
	LDA #$dd
	ANDB #$F0
	ORB #$0a
	STD 81,S

	LDD 121,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$0c0a
	STD 121,S

	LDD 41,S
	PSHU D

	LDA 79,S
	PSHU A

	LDA 119,S
	PSHU A

	LDD #$cdda
	STD 41,S

	LDA #$12
	STA 79,S

	LDA #$1f
	STA 119,S

	PULS A,X
	PSHU A,X,S
	LDA #$91
	LDX #$3cde
	PSHS A,X

	LEAS 280,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$0f0b
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
	LDB #$fb
	STD -81,S

	LDA -77,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA -77,S

	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$fb
	STD -41,S

	LDA -37,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA -37,S

	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$ae
	STD -1,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 3,S

	LDA 43,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 43,S

	LDA 40,S
	PSHU A

	LDA 80,S
	PSHU A

	LDA 120,S
	PSHU A,S

	LDA #$9e
	STA 120,S

	LDA #$a1
	STA 40,S

	STA 80,S

	LEAS 180,S
	LDA 20,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA 20,S

	LDA -20,S
	PSHU A,S

	LDA #$e0
	STA -20,S


	LDS $9F00+2
	STS ERASE_POS_HWL4_2+2
	LDU #ERASE_DATA_HWL4_END

	LEAS 463,S
	LDD 18,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ad
	STD 18,S

	LDD 58,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$a3
	STD 58,S

	LDA 60,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 60,S

	LDD -61,S
	PSHU D

	LDD -21,S
	PSHU D

	LDA 20,S
	PSHU A,S

	LDD #$cccc
	STD -61,S

	LDD #$aacd
	STD -21,S

	LDA #$dd
	STA 20,S

	LEAS 218,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$c2
	STD -120,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$aa
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
	LDB #$aa
	STD -40,S

	LDA -38,S
	PSHU A

	LDA #$cc
	STA -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$ca
	LDX #$cbdc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$da
	LDX #$aadd
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$0a
	LDX #$aadd
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$9c
	LDX #$aa0d
	PSHS A,X

	LEAS 40,S
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 42,S

	LDD 40,S
	PSHU D

	LDD #$abcc
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$9a
	LDX #$ac0d
	PSHS A,X

	LEAS 80,S
	PULS A,X
	PSHU A,X,S
	LDA #$0a
	LDX #$b2cc
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$03
	LDB #$22
	STD 40,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$23
	STD 80,S

	LDA 123,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 123,S

	LDA 42,S
	PSHU A

	LDA 82,S
	PSHU A

	LDD 121,S
	PSHU D

	LDD #$3d22
	STD 121,S

	LDA #$dd
	STA 42,S

	STA 82,S

	PULS A,X
	PSHU A,X,S
	LDA #$00
	LDX #$22dc
	PSHS A,X

	LEAS 280,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$1e
	STD -120,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$0a03
	STD -80,S

	LDD -78,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$ba
	STD -78,S

	LDD -40,S
	PSHU D
	LDA #$aa
	ANDB #$F0
	ORB #$02
	STD -40,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$12
	STD 40,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$e1
	STD 80,S

	LDD -118,S
	PSHU D

	LDD -38,S
	PSHU D

	LDD 42,S
	PSHU D

	LDD 82,S
	PSHU D

	LDD 122,S
	PSHU D

	LDD #$d09e
	STD 122,S

	LDD #$13ba
	STD -118,S

	LDA #$dd
	STD -38,S

	LDB #$aa
	STD 82,S

	LDB #$b9
	STD 42,S

	PULS D,X
	PSHU D,X,S
	LDD #$aa32
	LDX #$ddaa
	PSHS D,X

	LEAS 281,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$0d
	STD -120,S

	LDD -81,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$f00d
	STD -81,S

	LDD -1,S
	PSHU D
	LDA #$fb
	ANDB #$0F
	ORB #$d0
	STD -1,S

	LDD 39,S
	PSHU D
	LDA #$fb
	ANDB #$0F
	ORB #$b0
	STD 39,S

	LDA 42,S
	PSHU A
	ANDA #$F0
	ORA #$01
	STA 42,S

	LDD 79,S
	PSHU D
	LDA #$1b
	ANDB #$0F
	ORB #$a0
	STD 79,S

	LDA 82,S
	PSHU A
	ANDA #$F0
	ORA #$0f
	STA 82,S

	LDD 119,S
	PSHU D
	LDA #$01
	ANDB #$0F
	ORB #$a0
	STD 119,S

	LDA -118,S
	PSHU A

	LDD -79,S
	PSHU D

	LDD -41,S
	PSHU D

	LDA -38,S
	PSHU A

	LDA 2,S
	PSHU A,S

	LDD #$fbcd
	STD -41,S

	LDA #$11
	STA -38,S

	LDA #$f1
	STA 2,S

	LDD #$dd10
	STD -79,S

	STB -118,S

	LEAS 200,S
	LDD -41,S
	PSHU D
	LDA #$e0
	ANDB #$0F
	ORB #$00
	STD -41,S

	LDD -1,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0e00
	STD -1,S

	LDA 40,S
	PSHU A,S
	ANDA #$0F
	ORA #$e0
	STA 40,S

SSAV_HWL4
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HWL4
	PSHS U,DP
	STS ERASE_SSAV_HWL4+2

ERASE_POS_HWL4_1
	LDS #$0000
	LDU #ERASE_DATA_HWL4_1

ERASE_CODE_HWL4_1
	PULU A,S
	STA -20,S

	PULU A
	STA 20,S

	PULU A,S
	STA 120,S

	PULU A,B
	STA 80,S
	STB 40,S

	PULU A,B,X
	STA 43,S
	STB 3,S
	STX -1,S

	PULU A,X
	STA -37,S
	STX -41,S

	PULU A,X
	STA -77,S
	STX -81,S

	PULU A,X
	STA -117,S
	STX -121,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA 119,S
	STB 79,S
	STX 41,S
	STY 121,S

	PULU D,X
	STD 81,S
	STX 39,S

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
	STX -40,S
	STY -80,S

	PULU D,X,Y
	STD -120,S
	STX 80,S
	STY 40,S

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

	PULU D,X,Y
	STD -40,S
	STX -80,S
	STY -120,S

	PULU A,B
	STA -38,S
	STB -78,S

	PULU D,S
	STD 119,S

	PULU D,X,Y
	STD 79,S
	STX 39,S
	STY -1,S

	PULU A,B
	STA -80,S
	STB -120,S

	PULU A,X
	STA -39,S
	STX -41,S

ERASE_POS_HWL4_2
	LDS #$0000
	LDU #ERASE_DATA_HWL4_2

ERASE_CODE_HWL4_2
	PULU A,S
	STA 40,S

	PULU D,X
	STD -1,S
	STX -41,S

	PULU A,S
	STA 2,S

	PULU A,X,Y
	STA -38,S
	STX -41,S
	STY -79,S

	PULU A,X
	STA -118,S
	STX 119,S

	PULU A,X
	STA 82,S
	STX 79,S

	PULU A,X,Y
	STA 42,S
	STX 39,S
	STY -1,S

	PULU D,X
	STD -81,S
	STX -120,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 122,S
	STX 82,S
	STY 42,S

	PULU D,X,Y
	STD -38,S
	STX -118,S
	STY 80,S

	PULU D,X,Y
	STD 40,S
	STX -40,S
	STY -78,S

	PULU D,X
	STD -80,S
	STX -120,S

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 121,S

	PULU A,B
	STA 82,S
	STB 42,S

	PULU A,X,Y
	STA 123,S
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

	PULU A,S
	STA 20,S

	PULU D,X
	STD -21,S
	STX -61,S

	PULU A,X,Y
	STA 60,S
	STX 58,S
	STY 18,S

ERASE_SSAV_HWL4
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HWL4_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWL4_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWL4_END
