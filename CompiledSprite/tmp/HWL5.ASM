(main)IMG.ASM
	ORG $D824
DRAW_HWL5
	PSHS U,DP
	STS SSAV_HWL5+2

	LDS $9F00
	STS ERASE_POS_HWL5_1+2
	LDU #ERASE_DATA_HWL5_2
	LEAS 523,S

	LDD 79,S
	PSHU D

	LDD 39,S
	PSHU D

	LDA -80,S
	PSHU A

	LDA -39,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA -39,S

	LDD -1,S
	PSHU D

	LDA -120,S
	PSHU A

	LDD 119,S
	PSHU D,S

	LDD #$aa2d
	STD 39,S

	LDD -41,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$dc
	STD -41,S

	LDA #$cc
	STA -80,S

	STA -120,S

	LDA #$ca
	STD -1,S

	LDD #$aa2c
	STD 79,S

	STD 119,S

	LEAS 279,S

	LDD -80,S
	PSHU D

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

	LDD #$addc
	STD -120,S

	LDD -40,S
	PSHU D

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

	LDD #$9bcd
	STD 80,S

	STD 40,S

	LDA #$bb
	STD 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$ab
	LDX #$ccdd
	PSHS A,X

	LEAS 280,S

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD #$22d0
	STD -80,S

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA -38,S

	LDA 42,S
	PSHU A

	LDD -120,S
	PSHU D

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$01
	LDB #$1d
	STD 40,S

	LDD #$22dd
	STD -40,S

	LDA #$2b
	STD -120,S

	LDD 121,S
	PSHU D

	LDD 81,S
	PSHU D

	LDA -118,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -118,S

	LDA #$ba
	STA 42,S

	LDA -78,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -78,S

	LDD #$23bb
	STD 81,S

	STD 121,S

	PULS A,X
	PSHU A,X,S

	LDA #$13
	LDX #$0dac
	PSHS A,X

	LEAS 282,S

	LDD -42,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$3c
	STD -42,S

	LDA ,S
	PSHU A

	LDA 40,S
	PSHU A

	ANDA #$F0
	ORA #$0a
	STA 40,S

	LDD -82,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$2c
	STD -82,S

	LDA -80,S
	PSHU A

	LDA 81,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA 81,S

	LDD 38,S
	PSHU D

	ANDA #$F0
	ORA #$09
	LDB #$dc
	STD 38,S

	LDA -120,S
	PSHU A

	LDD -122,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$23
	STD -122,S

	LDA 119,S
	PSHU A

	LDA #$aa
	STA -120,S

	STA -80,S

	LDA -40,S
	PSHU A

	LDA #$99
	STA -40,S

	LDA #$ad
	STA 119,S

	LDD -2,S
	PSHU D,S

	ANDA #$F0
	ORA #$0a
	LDB #$da
	STD -2,S

	STB ,S

	LDA 79,S
	PSHU A

	ANDA #$F0
	ORA #$0d
	STA 79,S

	LDA 121,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA 121,S

	LEAS 278,S

	LDD ,S
	PSHU D

	LDA #$1f
	ANDB #$0F
	ORB #$a0
	STD ,S

	LDD 40,S
	PSHU D

	LDA #$1e
	ANDB #$0F
	ORB #$a0
	STD 40,S

	LDA -37,S
	PSHU A

	ANDA #$0F
	ORA #$e0
	STA -37,S

	LDD -80,S
	PSHU D

	LDA #$fb
	ANDB #$0F
	ORB #$b0
	STD -80,S

	LDD 80,S
	PSHU D

	LDA #$e1
	ANDB #$0F
	ORB #$e0
	STD 80,S

	LDA -77,S
	PSHU A

	ANDA #$0F
	ORA #$e0
	STA -77,S

	LDA -117,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA -117,S

	LDD -120,S
	PSHU D,S

	ANDA #$0F
	ANDB #$0F
	ADDD #$20a0
	STD -120,S

	LDD -40,S
	PSHU D

	LDA #$ef
	ANDB #$0F
	ORB #$a0
	STD -40,S

	LDD 120,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0ee0
	STD 120,S

	LEAS 181,S

	LDA 20,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA 20,S

	LDD -21,S
	PSHU D,S

	ANDA #$F0
	ANDB #$0F
	ADDD #$00e0
	STD -21,S


	LDS $9F00+2
	STS ERASE_POS_HWL5_2+2
	LDU #ERASE_DATA_HWL5_END

	LEAS 503,S

	LDD -61,S
	PSHU D

	LDD #$cccc
	STD -61,S

	LDD -21,S
	PSHU D

	LDD 58,S
	PSHU D,S

	ANDA #$F0
	ORA #$0d
	LDB #$a3
	STD 58,S

	LDD 18,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$ad
	STD 18,S

	LDA 20,S
	PSHU A

	LDD #$aacd
	STD -21,S

	LDA #$dd
	STA 20,S

	LDA 60,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 60,S

	LEAS 218,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$aa
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
	ORA #$0c
	LDB #$c2
	STD -120,S

	LDD -80,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$aa
	STD -80,S

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

	LDD 40,S
	PSHU D

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 42,S

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

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$01
	LDB #$23
	STD 80,S

	LDA 82,S
	PSHU A

	LDA 42,S
	PSHU A

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$03
	LDB #$22
	STD 40,S

	LDA #$dd
	STA 42,S

	STA 82,S

	LDD 121,S
	PSHU D

	LDD #$3d3b
	STD 121,S

	PULS A,X
	PSHU A,X,S

	LDA #$00
	LDX #$22dc
	PSHS A,X

	LEAS 161,S

	LDD ,S
	PSHU D,S

	LDD #$1e1b
	STD ,S

	LEAS 160,S

	LDD -40,S
	PSHU D

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -38,S

	LDA -78,S
	PSHU A

	ANDA #$0F
	ORA #$b0
	STA -78,S

	LDD -80,S
	PSHU D

	LDD #$92da
	STD -40,S

	LDD -120,S
	PSHU D

	ANDA #$F0
	ORA #$03
	LDB #$da
	STD -120,S

	LDD #$a2db
	STD -80,S

	PULS A,X
	PSHU A,X,S

	LDA #$92
	LDX #$daa0
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$a1
	LDX #$dd99
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$99
	LDX #$0a1e
	PSHS A,X

	LEAS 40,S

	LDD 119,S
	PSHU D

	ANDA #$F0
	ANDB #$F0
	ADDD #$0e0b
	STD 119,S

	LDA 82,S
	PSHU A

	LDA 42,S
	PSHU A

	LDA #$11
	STA 42,S

	LDA #$f1
	STA 82,S

	LDD 40,S
	PSHU D

	ANDA #$0F
	ANDB #$0F
	ADDD #$a0d0
	STD 40,S

	LDA 79,S
	PSHU A

	ANDA #$F0
	ORA #$0f
	STA 79,S

	LDA 122,S
	PSHU A

	ANDA #$F0
	ORA #$01
	STA 122,S

	PULS A,X
	PSHU A,X,S

	LDA #$9a
	LDX #$0d1e
	PSHS A,X

	LEAS 280,S

	LDD -41,S
	PSHU D

	ANDA #$F0
	ORA #$0e
	LDB #$bf
	STD -41,S

	LDA 40,S
	PSHU A

	LDA 120,S
	PSHU A

	LDD -81,S
	PSHU D

	ANDA #$F0
	ORA #$01
	LDB #$b1
	STD -81,S

	LDA ,S
	PSHU A

	LDA #$9a
	STA 40,S

	STB ,S

	LDA -118,S
	PSHU A

	ANDA #$F0
	ORA #$0f
	STA -118,S

	LDD -121,S
	PSHU D,S

	ANDA #$F0
	ANDB #$F0
	ADDD #$010b
	STD -121,S

	LDA 80,S
	PSHU A

	LDA #$ea
	STA 80,S

	LDA #$ee
	STA 120,S

	LEAS 160,S

	LDA ,S
	PSHU A,S

	LDA #$00
	STA ,S

SSAV_HWL5
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HWL5
	PSHS U,DP
	STS ERASE_SSAV_HWL5+2

ERASE_POS_HWL5_1
	LDS #$0000
	LDU #ERASE_DATA_HWL5_1

ERASE_CODE_HWL5_1
	PULU D,S
	STD -21,S

	PULU A
	STA 20,S

	PULU D,X,Y,S
	STD 120,S
	STX -40,S
	STY -120,S

	PULU A,B,X,Y
	STA -117,S
	STB -77,S
	STX 80,S
	STY -80,S

	PULU A,X,Y
	STA -37,S
	STX 40,S
	STY ,S

	PULU A,B,X,S
	STA 121,S
	STB 79,S
	STX -2,S

	PULU A,B,X
	STA -40,S
	STB 119,S
	STX -122,S

	PULU A,X
	STA -120,S
	STX 38,S

	PULU A,B,X
	STA 81,S
	STB -80,S
	STX -82,S

	PULU A,B,X
	STA 40,S
	STB ,S
	STX -42,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA -78,S
	STB -118,S
	STX 81,S
	STY 121,S

	PULU D,X
	STD 40,S
	STX -120,S

	PULU A,B,X,Y
	STA 42,S
	STB -38,S
	STX -40,S
	STY -80,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 120,S
	STX 80,S
	STY 40,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -40,S
	STX -120,S

	PULU A,B,X
	STA -38,S
	STB -78,S
	STX -80,S

	PULU D,X,S
	STD -41,S
	STX 119,S

	PULU A,X
	STA -120,S
	STX -1,S

	PULU A,B,X,Y
	STA -39,S
	STB -80,S
	STX 39,S
	STY 79,S

ERASE_POS_HWL5_2
	LDS #$0000
	LDU #ERASE_DATA_HWL5_2

ERASE_CODE_HWL5_2
	PULU A,S
	STA ,S

	PULU A,X,S
	STA 80,S
	STX -121,S

	PULU A,B,X
	STA -118,S
	STB ,S
	STX -81,S

	PULU A,B,X
	STA 120,S
	STB 40,S
	STX -41,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X
	STA 122,S
	STB 79,S
	STX 40,S

	PULU A,B,X
	STA 42,S
	STB 82,S
	STX 119,S

	PULU B,X,S
	PSHS B,X

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

	PULU D,S
	STD ,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 121,S
	STX 40,S

	PULU A,B,X
	STA 42,S
	STB 82,S
	STX 80,S

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

	PULU D,X
	STD -80,S
	STX -120,S

	PULU A,B,X
	STA -78,S
	STB -38,S
	STX -40,S

	PULU A,B,X,Y,S
	STA 60,S
	STB 20,S
	STX 18,S
	STY 58,S

	PULU D,X
	STD -21,S
	STX -61,S

ERASE_SSAV_HWL5
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HWL5_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWL5_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HWL5_END
