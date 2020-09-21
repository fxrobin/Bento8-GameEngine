(main)IMG.ASM
	ORG $AE2C
DRAW_HWL1
	PSHS U,DP
	STS SSAV_HWL1+2

	LDS $9F00
	STS ERASE_POS_HWL1_1+2
	LDU #ERASE_DATA_HWL1_2
	LEAS 543,S
	LDD -60,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$d0
	STD -60,S

	LDD -21,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dc
	STD -21,S

	LDA -100,S
	PSHU A

	LDD 19,S
	PSHU D,S

	LDD 59,S
	PSHU D

	LDD 99,S
	PSHU D

	LDA #$cc
	STA -100,S

	LDD #$cadc
	STD 19,S

	LDD #$aa2c
	STD 99,S

	LDB #$2d
	STD 59,S

	LEAS 259,S
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

	LDD #$aa2c
	STD -120,S

	LDD #$addc
	STD -80,S

	LDD #$abcc
	STD -40,S

	PULS A,X
	PSHU A,X,S
	LDA #$cb
	LDX #$acdc
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$abcc
	STD 40,S

	LDD #$9bcd
	STD 80,S

	STD 120,S

	PULS A,X
	PSHU A,X,S
	LDA #$0b
	LDX #$ccdd
	PSHS A,X

	LEAS 240,S
	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -38,S

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD #$bbcd
	STD -80,S

	LDD #$2bdd
	STD -40,S

	PULS A,X
	PSHU A,X,S
	LDA #$22
	LDX #$d0dc
	PSHS A,X

	LEAS 40,S
	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$31
	STD 80,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$dd
	STD 120,S

	LDA 122,S
	PSHU A
	ANDA #$0F
	ORA #$20
	STA 122,S

	LDD 40,S
	PSHU D

	LDD #$130d
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$22
	LDX #$dddd
	PSHS A,X

	LEAS 281,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$0d
	STD -121,S

	LDA -119,S
	PSHU A
	ANDA #$0F
	ORA #$30
	STA -119,S

	LDD -80,S
	PSHU D
	LDA #$b0
	ANDB #$0F
	ORB #$b0
	STD -80,S

	LDD 119,S
	PSHU D
	ANDA #$F0
	ORA #$0b
	LDB #$1e
	STD 119,S

	LDA 121,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 121,S

	LDD -40,S
	PSHU D

	LDD ,S
	PSHU D,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$aaaa
	STD -40,S

	LDD #$1eba
	STD 80,S

	LDD #$eeb9
	STD 40,S

	LDA #$ae
	STD ,S

	LEAS 280,S
	LDA -119,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA -119,S

	LDA -79,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA -79,S

	LDD -41,S
	PSHU D
	LDA #$ff
	ANDB #$F0
	ORB #$09
	STD -41,S

	LDA -39,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA -39,S

	LDD -1,S
	PSHU D
	LDA #$e0
	ANDB #$F0
	ORB #$09
	STD -1,S

	LDA 1,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 1,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0a10
	STD 40,S

	LDD 80,S
	PSHU D
	LDA #$fa
	ANDB #$0F
	ORB #$10
	STD 80,S

	LDD -121,S
	PSHU D,S

	LDD -81,S
	PSHU D

	LDA 120,S
	PSHU A

	LDD #$ffe0
	STD -121,S

	LDD #$2f0a
	STD -81,S

	LDA #$1a
	STA 120,S

	LEAS 180,S
	LDA -20,S
	PSHU A,S

	LDA 20,S
	PSHU A

	LDA #$19
	STA -20,S

	LDA #$00
	STA 20,S


	LDS $9F00+2
	STS ERASE_POS_HWL1_2+2
	LDU #ERASE_DATA_HWL1_END

	LEAS 523,S
	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ad
	STD 38,S

	LDA 40,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 40,S

	LDD 78,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$a3
	STD 78,S

	LDA 80,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 80,S

	LDA -80,S
	PSHU A

	LDD -41,S
	PSHU D,S

	LDD -1,S
	PSHU D

	LDD #$aacd
	STD -1,S

	LDD #$cccc
	STD -41,S

	STA -80,S

	LEAS 238,S
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
	LDX #$cbdd
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
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 42,S

	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 82,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$9aac
	STD 40,S

	LDD #$abcc
	STD 80,S

	PULS A,X
	PSHU A,X,S
	LDA #$9c
	LDX #$aa0d
	PSHS A,X

	LEAS 120,S
	PULS A,X
	PSHU A,X,S
	LDA #$0a
	LDX #$b2dc
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

	LDA 42,S
	PSHU A

	LDA 82,S
	PSHU A

	LDD 121,S
	PSHU D

	LDD #$3ddd
	STD 121,S

	STB 42,S

	STB 82,S

	PULS A,X
	PSHU A,X,S
	LDA #$00
	LDX #$22dd
	PSHS A,X

	LEAS 281,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0b
	LDB #$db
	STD 40,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0b
	LDB #$aa
	STD 80,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D,S

	LDD ,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$0e22
	STD -120,S

	LDD #$9213
	STD -80,S

	LDD #$faab
	STD 120,S

	LDD #$0ddd
	STD ,S

	LDA #$9c
	STD -40,S

	LEAS 281,S
	LDD 38,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0fe0
	STD 38,S

	LDA 78,S
	PSHU A
	ANDA #$F0
	ORA #$01
	STA 78,S

	LDD -121,S
	PSHU D

	LDD -81,S
	PSHU D

	LDD -41,S
	PSHU D

	LDD -1,S
	PSHU D

	LDA 40,S
	PSHU A

	LDA 80,S
	PSHU A,S

	LDA 120,S
	PSHU A

	LDD #$bfab
	STD -121,S

	LDD #$b19a
	STD -81,S

	LDD #$aa1a
	STD -41,S

	LDD #$1911
	STD -1,S

	LDA #$1e
	STA 120,S

	LDA #$10
	STA 40,S

	STA 80,S

	LEAS 220,S
	LDD 19,S
	PSHU D,S
	ANDA #$F0
	ORA #$0f
	LDB #$ee
	STD 19,S

	LDD 59,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$0e
	STD 59,S

	LDA -60,S
	PSHU A

	LDA -20,S
	PSHU A

	LDA #$1e
	STA -60,S

	STB -20,S

SSAV_HWL1
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HWL1
	PSHS U,DP
	STS ERASE_SSAV_HWL1+2

ERASE_POS_HWL1_1
	LDS #$0000
	LDU #ERASE_DATA_HWL1_1

ERASE_CODE_HWL1_1
	PULU A,B,S
	STA 20,S
	STB -20,S

	PULU A,X,Y,S
	STA 120,S
	STX -81,S
	STY -121,S

	PULU D,X
	STD 80,S
	STX 40,S

	PULU A,X
	STA 1,S
	STX -1,S

	PULU A,X
	STA -39,S
	STX -41,S

	PULU A,B
	STA -79,S
	STB -119,S

	PULU D,X,Y,S
	STD 80,S
	STX 40,S
	STY ,S

	PULU D
	STD -40,S

	PULU A,X,Y
	STA 121,S
	STX 119,S
	STY -80,S

	PULU A,X
	STA -119,S
	STX -121,S

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 40,S

	PULU A,X,Y
	STA 122,S
	STX 120,S
	STY 80,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -40,S
	STX -80,S

	PULU A
	STA -38,S

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

	PULU A
	STA -38,S

	PULU D,X,Y,S
	STD 99,S
	STX 59,S
	STY 19,S

	PULU A,X,Y
	STA -100,S
	STX -21,S
	STY -60,S

ERASE_POS_HWL1_2
	LDS #$0000
	LDU #ERASE_DATA_HWL1_2

ERASE_CODE_HWL1_2
	PULU A,B,X,Y,S
	STA -20,S
	STB -60,S
	STX 59,S
	STY 19,S

	PULU A,B,S
	STA 120,S
	STB 80,S

	PULU A,X,Y
	STA 40,S
	STX -1,S
	STY -41,S

	PULU D,X
	STD -81,S
	STX -121,S

	PULU A,X
	STA 78,S
	STX 38,S

	PULU D,X,Y,S
	STD 120,S
	STX ,S
	STY -40,S

	PULU D,X,Y
	STD -80,S
	STX -120,S
	STY 80,S

	PULU D
	STD 40,S

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 121,S

	PULU A,B,X,Y
	STA 82,S
	STB 42,S
	STX 80,S
	STY 40,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 80,S
	STX 40,S

	PULU A,B
	STA 82,S
	STB 42,S

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

	PULU D,X,S
	STD -1,S
	STX -41,S

	PULU A,B,X
	STA -80,S
	STB 80,S
	STX 78,S

	PULU A,X
	STA 40,S
	STX 38,S

ERASE_SSAV_HWL1
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HWL1_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWL1_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWL1_END
