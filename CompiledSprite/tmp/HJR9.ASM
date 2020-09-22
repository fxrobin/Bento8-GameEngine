(main)IMG.ASM
	ORG $A000
DRAW_HJR9
	PSHS U,DP
	STS SSAV_HJR9+2

	LDS $9F00
	STS ERASE_POS_HJR9_1+2
	LDU #ERASE_DATA_HJR9_2
	LEAS 682,S

	LDD -40,S
	PSHU D

	LDD -80,S
	PSHU D

	LDA -119,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -119,S

	LDD #$ccca
	STD -80,S

	LDD #$cacc
	STD -40,S

	PULS A,X
	PSHU A,X,S

	LDA #$cd
	LDX #$cdaf
	PSHS A,X

	LEAS 40,S

	LDD 41,S
	PSHU D

	LDD 79,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$cd
	STD 79,S

	LDA 121,S
	PSHU A

	LDA 81,S
	PSHU A

	LDD #$ac0e
	STD 41,S

	STA 81,S

	LDD 39,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$cd
	STD 39,S

	LDD 119,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$cd
	STD 119,S

	LDA #$cc
	STA 121,S

	PULS A,X
	PSHU A,X,S

	LDX #$ac91
	PSHS B,X

	LEAS 239,S

	LDD -78,S
	PSHU D

	LDD -80,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -80,S

	LDD #$caa9
	STD -78,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD -40,S

	LDD -38,S
	PSHU D

	LDD #$ccaa
	STD -38,S

	PULS D,X
	PSHU D,X,S

	LDD #$cdcc
	LDX #$c2aa
	PSHS D,X

	LEAS 40,S

	LDD 42,S
	PSHU D

	LDD 80,S
	PSHU D

	ANDA #$0F
	ORA #$d0
	LDB #$dd
	STD 80,S

	LDD 40,S
	PSHU D

	ANDA #$0F
	ORA #$d0
	LDB #$dc
	STD 40,S

	LDD 82,S
	PSHU D

	LDD #$12ca
	STD 42,S

	LDA #$c3
	STD 82,S

	LDD 120,S
	PSHU D

	ANDA #$0F
	ORA #$d0
	LDB #$dd
	STD 120,S

	LDD 122,S
	PSHU D

	LDA #$cc
	ANDB #$0F
	ORB #$a0
	STD 122,S

	PULS D,X
	PSHU D,X,S

	LDD #$cddd
	LDX #$32ca
	PSHS D,X

	LEAS 201,S

	LDD -40,S
	PSHU D

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -38,S

	LDD #$ddcc
	STD -40,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$ddca
	PSHS A,X

	LEAS 40,S

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD 80,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 40,S

	LDA 42,S
	PSHU A

	LDA #$aa
	STA 42,S

	LDA 82,S
	PSHU A

	LDA #$91
	STA 82,S

	PULS A,X
	PSHU A,X,S

	LDX #$cda9
	PSHS B,X

	LEAS 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$cd
	LDX #$dcef
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$cd
	LDX #$dd1f
	PSHS A,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0dd0
	STD 40,S

	LDA 82,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 82,S

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 42,S

	LDD 80,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0dd0
	STD 80,S

	LDD 120,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0dd0
	STD 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$cd
	LDX #$dde1
	PSHS A,X


	LDS $9F00+2
	STS ERASE_POS_HJR9_2+2
	LDU #ERASE_DATA_HJR9_END

	LEAS 582,S

	LDA 20,S
	PSHU A,S

	LDA -20,S
	PSHU A

	LDA #$aa
	STA -20,S

	STA 20,S

	LEAS 179,S

	LDD -80,S
	PSHU D

	LDD -120,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$cc
	STD -120,S

	LDA -118,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -118,S

	LDD #$accc
	STD -80,S

	LDA -78,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -78,S

	LDD -40,S
	PSHU D

	LDD #$cc2c
	STD -40,S

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA -38,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$f0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$cd
	LDX #$dc99
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$f0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$cd
	LDX #$ccc2
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$f0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$ccc2
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$10
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$ccab
	PSHS A,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$ddcc
	LDX #$ab1f
	PSHS D,X

	LEAS 40,S

	LDD 42,S
	PSHU D

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 80,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 40,S

	LDD 82,S
	PSHU D

	LDD #$ca1f
	STD 42,S

	LDA #$ac
	STD 82,S

	PULS D,X
	PSHU D,X,S

	LDD #$ddcc
	LDX #$ab1f
	PSHS D,X

	LEAS 120,S

	PULS D,X
	PSHU D,X,S

	LDD #$cddc
	LDX #$2c1f
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$cdcc
	LDX #$ca1f
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$cddd
	LDX #$ac1f
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$dddd
	LDX #$ac1f
	PSHS D,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDX #$dd3a
	PSHS B,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDX #$dd2c
	PSHS B,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	ANDA #$0F
	ANDB #$0F
	ADDD #$d0d0
	STD 40,S

	LDD 42,S
	PSHU D

	LDA #$da
	ANDB #$0F
	ORB #$f0
	STD 42,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$f0
	STA 3,S

	LDD 80,S
	PSHU D

	ANDA #$0F
	ANDB #$0F
	ADDD #$d0d0
	STD 80,S

	LDD 82,S
	PSHU D

	LDA #$c9
	ANDB #$0F
	ORB #$f0
	STD 82,S

	LDA 120,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 120,S

	LDA 122,S
	PSHU A

	LDA #$cd
	STA 122,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$dd2c
	PSHS A,X

	LEAS 242,S

	LDA -40,S
	PSHU A

	LDA -80,S
	PSHU A

	LDA ,S
	PSHU A

	LDA #$dc
	STA -80,S

	LDA #$dd
	STA -40,S

	STA ,S

	LDA 39,S
	PSHU A,S

	ANDA #$0F
	ORA #$d0
	STA 39,S

	LDA 79,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 79,S

SSAV_HJR9
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HJR9
	PSHS U,DP
	STS ERASE_SSAV_HJR9+2

ERASE_POS_HJR9_1
	LDS #$0000
	LDU #ERASE_DATA_HJR9_1

ERASE_CODE_HJR9_1
	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 120,S
	STX 80,S

	PULU A,B,X
	STA 42,S
	STB 82,S
	STX 40,S

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

	PULU A,X
	STA -38,S
	STX -40,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 122,S
	STX 120,S
	STY 82,S

	PULU D,X,Y
	STD 40,S
	STX 80,S
	STY 42,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD -38,S
	STX -40,S
	STY -80,S

	PULU D
	STD -78,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 119,S
	STX 39,S

	PULU A,B,X,Y
	STA 81,S
	STB 121,S
	STX 79,S
	STY 41,S

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA -119,S
	STX -80,S
	STY -40,S

ERASE_POS_HJR9_2
	LDS #$0000
	LDU #ERASE_DATA_HJR9_2

ERASE_CODE_HJR9_2
	PULU A,B,S
	STA 79,S
	STB 39,S

	PULU A,B
	STA ,S
	STB -80,S

	PULU A
	STA -40,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA 122,S
	STB 120,S
	STX 82,S
	STY 80,S

	PULU A,X,Y
	STA 3,S
	STX 42,S
	STY 40,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 82,S
	STX 40,S
	STY 80,S

	PULU D
	STD 42,S

	PULU D,X,S
	PSHS D,X

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

	PULU A,B,X
	STA 3,S
	STB -38,S
	STX -40,S

	PULU A,B,X,Y
	STA -78,S
	STB -118,S
	STX -120,S
	STY -80,S

	PULU A,B,S
	STA -20,S
	STB 20,S

ERASE_SSAV_HJR9
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HJR9_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJR9_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HJR9_END
