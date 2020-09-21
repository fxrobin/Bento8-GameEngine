(main)IMG.ASM
	ORG $D429
DRAW_HWL3
	PSHS U,DP
	STS SSAV_HWL3+2

	LDS $9F00
	STS ERASE_POS_HWL3_1+2
	LDU #ERASE_DATA_HWL3_2
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
	ORA #$c0
	STA -39,S

	LDA 1,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 1,S

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

	LEAS 159,S
	LDD ,S
	PSHU D,S

	LDD #$addc
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

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD #$cbac
	STD -80,S

	LDD #$0bcc
	STD -40,S

	LDA #$ab
	STD -120,S

	PULS A,X
	PSHU A,X,S
	LDA #$ab
	LDX #$ccdc
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$2bdd
	STD 120,S

	LDD #$bbcd
	STD 80,S

	LDA #$9b
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$9b
	LDX #$cddd
	PSHS A,X

	LEAS 161,S
	LDA 1,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 1,S

	LDD -1,S
	PSHU D,S

	LDD #$22d0
	STD -1,S

	LEAS 159,S
	LDA -118,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -118,S

	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -78,S

	LDD -40,S
	PSHU D
	ANDA #$0F
	ORA #$90
	LDB #$3e
	STD -40,S

	LDD -38,S
	PSHU D
	LDA #$2a
	ANDB #$0F
	ORB #$a0
	STD -38,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 3,S

	LDD 42,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0ab0
	STD 42,S

	LDA 83,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA 83,S

	LDA 119,S
	PSHU A
	ANDA #$0F
	ORA #$f0
	STA 119,S

	LDA 123,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 123,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD 40,S
	PSHU D

	LDA 81,S
	PSHU A

	LDA 121,S
	PSHU A

	LDD #$22dd
	STD -120,S

	LDD #$1303
	STD -80,S

	LDD #$e12d
	STD 40,S

	LDA #$2c
	STA 81,S

	LDA #$cc
	STA 121,S

	PULS A,X
	PSHU A,X,S
	LDA #$93
	LDX #$203b
	PSHS A,X

	LEAS 281,S
	LDA -122,S
	PSHU A
	ANDA #$0F
	ORA #$20
	STA -122,S

	LDD -120,S
	PSHU D
	LDA #$cd
	ANDB #$0F
	ORB #$e0
	STD -120,S

	LDA -118,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -118,S

	LDD -82,S
	PSHU D
	LDA #$ff
	ANDB #$F0
	ORB #$0a
	STD -82,S

	LDD -40,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$01
	STD -40,S

	LDD -2,S
	PSHU D
	LDA #$1b
	ANDB #$0F
	ORB #$d0
	STD -2,S

	LDD 38,S
	PSHU D
	LDA #$eb
	ANDB #$0F
	ORB #$a0
	STD 38,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$1e
	STD 40,S

	LDD 78,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0aa0
	STD 78,S

	LDD 118,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0a90
	STD 118,S

	LDD -80,S
	PSHU D

	LDD -42,S
	PSHU D,S

	LDD ,S
	PSHU D

	LDA 81,S
	PSHU A

	LDA 121,S
	PSHU A

	LDD #$d001
	STD -80,S

	LDD #$ffcc
	STD -42,S

	LDD #$0d0e
	STD ,S

	LDA #$1e
	STA 81,S

	STA 121,S

	LEAS 240,S
	LDD -82,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0e00
	STD -82,S

	LDA -41,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA -41,S

	LDA 41,S
	PSHU A
	ANDA #$F0
	ORA #$01
	STA 41,S

	LDA 81,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA 81,S

	LDA -79,S
	PSHU A

	LDA -39,S
	PSHU A,S

	LDA 1,S
	PSHU A

	LDA #$f1
	STA 1,S

	LDA #$a0
	STA -79,S

	STA -39,S


	LDS $9F00+2
	STS ERASE_POS_HWL3_2+2
	LDU #ERASE_DATA_HWL3_END

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
	PSHU D,S

	LDD -21,S
	PSHU D

	LDA 20,S
	PSHU A

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
	PULS A,X
	PSHU A,X,S
	LDA #$00
	LDX #$22dc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$93
	LDX #$22dd
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$91
	LDX #$23dd
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$99
	LDX #$3d22
	PSHS A,X

	LEAS 40,S
	LDD 42,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$ab
	STD 42,S

	LDD 82,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$bb
	STD 82,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$a032
	STD 40,S

	LDD #$9922
	STD 80,S

	PULS D,X
	PSHU D,X,S
	LDD #$a91e
	LDX #$33aa
	PSHS D,X

	LEAS 121,S
	LDA 38,S
	PSHU A
	ANDA #$F0
	ORA #$01
	STA 38,S

	PULS A,X
	PSHU A,X,S
	LDA #$22
	LDX #$dcaa
	PSHS A,X

	LEAS 40,S
	LDA 38,S
	PSHU A
	ANDA #$F0
	ORA #$01
	STA 38,S

	LDA 42,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA 42,S

	LDD 119,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$b000
	STD 119,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDA 121,S
	PSHU A

	LDD #$aa0d
	STD 40,S

	LDA #$ae
	STA 121,S

	LDD #$cdae
	STD 80,S

	PULS A,X
	PSHU A,X,S
	LDA #$32
	LDX #$dda9
	PSHS A,X

	LEAS 281,S
	LDD ,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0f10
	STD ,S

	LDA 41,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 41,S

	LDA 81,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 81,S

	LDA 121,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 121,S

	LDA -122,S
	PSHU A

	LDA -120,S
	PSHU A

	LDA -82,S
	PSHU A

	LDA -80,S
	PSHU A

	LDA -42,S
	PSHU A

	LDA -40,S
	PSHU A

	LDA -2,S
	PSHU A

	LDA 38,S
	PSHU A

	LDA 78,S
	PSHU A,S

	LDA 118,S
	PSHU A

	LDA #$bb
	STA -122,S

	LDA #$ae
	STA -120,S

	LDA #$fb
	STA -82,S

	LDA #$91
	STA -80,S

	LDA #$fa
	STA -42,S

	LDA #$0e
	STA -40,S

	LDA #$fe
	STA -2,S

	LDA #$f1
	STA 38,S

	LDA #$11
	STA 78,S

	LDA #$e1
	STA 118,S

	LEAS 200,S
	LDA -42,S
	PSHU A
	ANDA #$F0
	ORA #$00
	STA -42,S

	LDA -39,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA -39,S

	LDA 1,S
	PSHU A,S
	ANDA #$0F
	ORA #$00
	STA 1,S

	LDA 41,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 41,S

SSAV_HWL3
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HWL3
	PSHS U,DP
	STS ERASE_SSAV_HWL3+2

ERASE_POS_HWL3_1
	LDS #$0000
	LDU #ERASE_DATA_HWL3_1

ERASE_CODE_HWL3_1
	PULU A,B,S
	STA 1,S
	STB -39,S

	PULU A,B
	STA -79,S
	STB 81,S

	PULU A,B,X
	STA 41,S
	STB -41,S
	STX -82,S

	PULU A,B,X,Y,S
	STA 121,S
	STB 81,S
	STX ,S
	STY -42,S

	PULU D,X,Y
	STD -80,S
	STX 118,S
	STY 78,S

	PULU D,X,Y
	STD 40,S
	STX 38,S
	STY -2,S

	PULU D,X
	STD -40,S
	STX -82,S

	PULU A,X
	STA -118,S
	STX -120,S

	PULU A
	STA -122,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA 121,S
	STB 81,S
	STX 40,S
	STY -80,S

	PULU D
	STD -120,S

	PULU A,B
	STA 123,S
	STB 119,S

	PULU A,X
	STA 83,S
	STX 42,S

	PULU A,X,Y
	STA 3,S
	STX -38,S
	STY -40,S

	PULU A,B
	STA -78,S
	STB -118,S

	PULU D,S
	STD -1,S

	PULU A
	STA 1,S

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

	PULU A,B,X
	STA 1,S
	STB -39,S
	STX -41,S

ERASE_POS_HWL3_2
	LDS #$0000
	LDU #ERASE_DATA_HWL3_2

ERASE_CODE_HWL3_2
	PULU A,B,S
	STA 41,S
	STB 1,S

	PULU A,B
	STA -39,S
	STB -42,S

	PULU A,B,S
	STA 118,S
	STB 78,S

	PULU A,B
	STA 38,S
	STB -2,S

	PULU A,B
	STA -40,S
	STB -42,S

	PULU A,B
	STA -80,S
	STB -82,S

	PULU A,B
	STA -120,S
	STB -122,S

	PULU A,B
	STA 121,S
	STB 81,S

	PULU A,X
	STA 41,S
	STX ,S

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA 121,S
	STX 80,S
	STY 40,S

	PULU D
	STD 119,S

	PULU A,B
	STA 42,S
	STB 38,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 38,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 80,S
	STX 40,S
	STY 82,S

	PULU D
	STD 42,S

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

	PULU A,X,Y,S
	STA 20,S
	STX -21,S
	STY -61,S

	PULU A,X,Y
	STA 60,S
	STX 58,S
	STY 18,S

ERASE_SSAV_HWL3
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HWL3_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HWL3_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HWL3_END
