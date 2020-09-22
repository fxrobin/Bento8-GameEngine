(main)IMG.ASM
	ORG $D7BA
DRAW_HWR2
	PSHS U,DP
	STS SSAV_HWR2+2

	LDS $9F00
	STS ERASE_POS_HWR2_1+2
	LDU #ERASE_DATA_HWR2_2
	LEAS 543,S

	LDD -61,S
	PSHU D

	LDD 19,S
	PSHU D

	LDD #$cccc
	STD -61,S

	LDD -21,S
	PSHU D,S

	LDD #$ddda
	STD 19,S

	LDD 59,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$3a
	STD 59,S

	LDD #$dcaa
	STD -21,S

	LDA 21,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 21,S

	LDA 61,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 61,S

	LEAS 219,S

	LDD -80,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$aa
	STD -80,S

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -38,S

	LDA -78,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -78,S

	LDD -40,S
	PSHU D

	LDD -119,S
	PSHU D

	LDA #$2c
	ANDB #$0F
	ORB #$c0
	STD -119,S

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

	LDA 42,S
	PSHU A

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 40,S

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

	LDD 120,S
	PSHU D

	LDD 40,S
	PSHU D

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$30
	STA 42,S

	LDA 82,S
	PSHU A

	ANDA #$0F
	ORA #$10
	STA 82,S

	LDD 80,S
	PSHU D

	LDD #$dd32
	STD 80,S

	LDB #$22
	STD 40,S

	LDB #$d3
	STD 120,S

	LDA 122,S
	PSHU A

	ANDA #$0F
	ORA #$90
	STA 122,S

	PULS A,X
	PSHU A,X,S

	LDA #$cd
	LDX #$2200
	PSHS A,X

	LEAS 239,S

	LDD -79,S
	PSHU D

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$90
	STA 3,S

	LDA -77,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -77,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$33
	STD -40,S

	LDD #$221e
	STD -79,S

	LDD -38,S
	PSHU D

	LDA #$23
	ANDB #$0F
	ORB #$a0
	STD -38,S

	PULS A,X
	PSHU A,X,S

	LDA #$aa
	LDX #$cd22
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$bb
	LDX #$dda2
	PSHS A,X

	LEAS 40,S

	LDA 4,S
	PSHU A

	ANDA #$0F
	ORA #$f0
	STA 4,S

	PULS A,X
	PSHU A,X,S

	LDA #$ba
	LDX #$dddc
	PSHS A,X

	LEAS 40,S

	LDD 82,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$bb
	STD 82,S

	LDD 40,S
	PSHU D

	LDD #$bb0a
	STD 40,S

	LDD 42,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$bf
	STD 42,S

	LDD 80,S
	PSHU D

	LDD #$aa0d
	STD 80,S

	LDA 4,S
	PSHU A

	ANDA #$0F
	ORA #$10
	STA 4,S

	LDD 120,S
	PSHU D

	LDD #$9a90
	STD 120,S

	LDD 122,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$fb
	STD 122,S

	PULS A,X
	PSHU A,X,S

	LDA #$ba
	LDX #$d0dc
	PSHS A,X

	LEAS 281,S

	LDD -81,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0110
	STD -81,S

	LDD 39,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$01f0
	STD 39,S

	LDA 2,S
	PSHU A

	ANDA #$0F
	ORA #$e0
	STA 2,S

	LDA -38,S
	PSHU A

	LDD -1,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$01a0
	STD -1,S

	LDA -118,S
	PSHU A

	LDA -78,S
	PSHU A

	LDD -41,S
	PSHU D,S

	ANDA #$F0
	ANDB #$0F
	ADDD #$01a0
	STD -41,S

	LDA #$19
	STA -38,S

	LDD -121,S
	PSHU D

	ANDA #$F0
	ORA #$01
	LDB #$9a
	STD -121,S

	LDA #$fa
	STA -78,S

	STA -118,S

	LDA 80,S
	PSHU A

	ANDA #$0F
	ORA #$f0
	STA 80,S

	LDA 120,S
	PSHU A

	ANDA #$0F
	ORA #$10
	STA 120,S

	LEAS 180,S

	LDA 20,S
	PSHU A,S

	LDA -20,S
	PSHU A

	ANDA #$0F
	ORA #$10
	STA -20,S

	LDA #$01
	STA 20,S


	LDS $9F00+2
	STS ERASE_POS_HWR2_2+2
	LDU #ERASE_DATA_HWR2_END

	LEAS 562,S

	LDD ,S
	PSHU D

	LDA -39,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -39,S

	LDA -80,S
	PSHU A

	LDD 120,S
	PSHU D

	LDA -120,S
	PSHU A

	LDD #$cdac
	STD ,S

	LDD -41,S
	PSHU D,S

	ANDA #$F0
	ORA #$0d
	LDB #$cd
	STD -41,S

	LDA #$cc
	STA -80,S

	STA -120,S

	LDD 80,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD #$d2aa
	STD 40,S

	LDA #$c2
	STD 80,S

	STD 120,S

	LEAS 279,S

	LDD -119,S
	PSHU D

	LDA -78,S
	PSHU A

	LDA #$ba
	STA -78,S

	LDD #$cdda
	STD -119,S

	LDA -38,S
	PSHU A

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$ca
	STD -40,S

	LDD -80,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -80,S

	LDA #$bc
	STA -38,S

	PULS A,X
	PSHU A,X,S

	LDA #$cd
	LDX #$ccb0
	PSHS A,X

	LEAS 40,S

	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDD #$dcb9
	STD 81,S

	STD 41,S

	LDB #$bb
	STD 121,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$ccba
	PSHS A,X

	LEAS 280,S

	LDD -80,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$0d
	STD -80,S

	LDD 40,S
	PSHU D

	ANDA #$0F
	ORA #$d0
	LDB #$33
	STD 40,S

	LDA -118,S
	PSHU A

	LDA -78,S
	PSHU A

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD -40,S

	LDD -120,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$dd
	STD -120,S

	LDA #$b2
	STA -118,S

	LDA 42,S
	PSHU A

	LDA -38,S
	PSHU A

	LDA #$22
	STA -78,S

	STA -38,S

	LDA #$99
	STA 42,S

	PULS A,X
	PSHU A,X,S

	LDA #$cd
	LDX #$d031
	PSHS A,X

	LEAS 80,S

	PULS A,X
	PSHU A,X,S

	LDA #$22
	LDX #$e290
	PSHS A,X

	LEAS 40,S

	LDD 119,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$ac
	STD 119,S

	LDA 81,S
	PSHU A

	LDA #$dc
	STA 81,S

	LDA 121,S
	PSHU A

	LDD 79,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0aa0
	STD 79,S

	LDD 40,S
	PSHU D

	ANDA #$0F
	ORA #$10
	LDB #$c2
	STD 40,S

	LDA 123,S
	PSHU A

	LDA 83,S
	PSHU A

	ANDA #$F0
	ORA #$0f
	STA 83,S

	LDA #$dd
	STA 121,S

	LDA #$2f
	STA 123,S

	PULS A,X
	PSHU A,X,S

	LDA #$33
	LDX #$02e9
	PSHS A,X

	LEAS 200,S

	LDD -39,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$cb
	STD -39,S

	LDD -41,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$ad
	STD -41,S

	LDA -37,S
	PSHU A

	LDA #$ff
	STA -37,S

	PULS D,X
	PSHU D,X,S

	LDD #$9ed0
	LDX #$aafe
	PSHS D,X

	LEAS 40,S

	LDD 42,S
	PSHU D

	LDA #$af
	ANDB #$0F
	ORB #$e0
	STD 42,S

	LDA 80,S
	PSHU A

	LDA 122,S
	PSHU A

	LDA 120,S
	PSHU A

	LDD 40,S
	PSHU D

	LDA #$ee
	ANDB #$0F
	ORB #$00
	STD 40,S

	STA 80,S

	LDA 82,S
	PSHU A

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$10
	STA 3,S

	LDA #$e9
	STA 120,S

	LDA #$ef
	STA 82,S

	LDA #$11
	STA 122,S

	PULS A,X
	PSHU A,X,S

	LDA #$ee
	LDX #$d0b1
	PSHS A,X

	LEAS 260,S

	LDA -98,S
	PSHU A

	LDA -58,S
	PSHU A

	LDA -60,S
	PSHU A

	LDA -20,S
	PSHU A

	LDA #$ee
	STA -60,S

	LDA 20,S
	PSHU A

	LDA 60,S
	PSHU A

	LDA -100,S
	PSHU A,S

	LDA #$00
	STA -58,S

	LDA #$e0
	STA -20,S

	STA 20,S

	LDA #$11
	STA -98,S

	LDA #$e9
	STA -100,S

	LDA #$1e
	STA 60,S

	LDA 100,S
	PSHU A

	ANDA #$F0
	ORA #$00
	STA 100,S

SSAV_HWR2
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HWR2
	PSHS U,DP
	STS ERASE_SSAV_HWR2+2

ERASE_POS_HWR2_1
	LDS #$0000
	LDU #ERASE_DATA_HWR2_1

ERASE_CODE_HWR2_1
	PULU A,B,S
	STA -20,S
	STB 20,S

	PULU A,B,X,Y,S
	STA 120,S
	STB 80,S
	STX -121,S
	STY -41,S

	PULU A,B,X
	STA -78,S
	STB -118,S
	STX -1,S

	PULU A,B,X,Y
	STA -38,S
	STB 2,S
	STX 39,S
	STY -81,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 122,S
	STX 120,S

	PULU A,X,Y
	STA 4,S
	STX 80,S
	STY 42,S

	PULU D,X
	STD 40,S
	STX 82,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 4,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -38,S
	STX -40,S

	PULU A,B,X
	STA -77,S
	STB 3,S
	STX -79,S

	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA 122,S
	STX 80,S

	PULU A,B,X,Y
	STA 82,S
	STB 42,S
	STX 40,S
	STY 120,S

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

	PULU D,X
	STD -119,S
	STX -40,S

	PULU A,B,X
	STA -78,S
	STB -38,S
	STX -80,S

	PULU A,B,X,Y,S
	STA 61,S
	STB 21,S
	STX 59,S
	STY -21,S

	PULU D,X
	STD 19,S
	STX -61,S

ERASE_POS_HWR2_2
	LDS #$0000
	LDU #ERASE_DATA_HWR2_2

ERASE_CODE_HWR2_2
	PULU A,B,S
	STA 100,S
	STB -100,S

	PULU A,B
	STA 60,S
	STB 20,S

	PULU A,B
	STA -20,S
	STB -60,S

	PULU A,B
	STA -58,S
	STB -98,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X
	STA 3,S
	STB 82,S
	STX 40,S

	PULU A,B
	STA 120,S
	STB 122,S

	PULU A,X
	STA 80,S
	STX 42,S

	PULU D,X,S
	PSHS D,X

	PULU A,X,Y
	STA -37,S
	STX -41,S
	STY -39,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA 83,S
	STB 123,S
	STX 40,S
	STY 79,S

	PULU A,B,X
	STA 121,S
	STB 81,S
	STX 119,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA -38,S
	STB 42,S
	STX -120,S
	STY -40,S

	PULU A,B,X,Y
	STA -78,S
	STB -118,S
	STX 40,S
	STY -80,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 121,S
	STX 81,S
	STY 41,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -80,S
	STX -40,S

	PULU A,B,X
	STA -38,S
	STB -78,S
	STX -119,S

	PULU D,X,Y,S
	STD 40,S
	STX 80,S
	STY -41,S

	PULU A,X
	STA -120,S
	STX 120,S

	PULU A,B,X
	STA -80,S
	STB -39,S
	STX ,S

ERASE_SSAV_HWR2
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HWR2_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWR2_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWR2_END
