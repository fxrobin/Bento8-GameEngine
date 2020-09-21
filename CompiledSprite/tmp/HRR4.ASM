(main)IMG.ASM
	ORG $E0E1
DRAW_HRR4
	PSHS U,DP
	STS SSAV_HRR4+2

	LDS $9F00
	STS ERASE_POS_HRR4_1+2
	LDU #ERASE_DATA_HRR4_2
	LEAS 563,S
	LDA -80,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -80,S

	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ad
	STD -41,S

	LDA 1,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA 1,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$d2
	STD 39,S

	LDD -1,S
	PSHU D

	LDA 41,S
	PSHU A

	LDD 80,S
	PSHU D,S

	LDD #$ddc1
	STD -1,S

	LDA #$cd
	STA 41,S

	LDD #$d2ad
	STD 80,S

	LEAS 239,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$da
	STD -40,S

	LDD -119,S
	PSHU D

	LDD -79,S
	PSHU D

	LDA -38,S
	PSHU A

	LDD #$daaa
	STD -79,S

	LDA #$d2
	STD -119,S

	STB -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$cbca
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$caaa
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$cabc
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ca
	STD 40,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$c2
	STD 120,S

	LDA 42,S
	PSHU A

	LDD 81,S
	PSHU D

	LDA 122,S
	PSHU A

	LDA #$b9
	STA 122,S

	LDD #$ccb0
	STD 81,S

	STB 42,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$cab0
	PSHS A,X

	LEAS 160,S
	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$d229
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$d222
	PSHS A,X

	LEAS 40,S
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$30
	STA 42,S

	LDA 122,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA 122,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$dd0d
	STD 40,S

	LDD #$9e10
	STD 80,S

	LDD #$9d3e
	STD 120,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$d321
	PSHS A,X

	LEAS 199,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$cd
	STD -40,S

	LDD -38,S
	PSHU D

	LDD #$219a
	STD -38,S

	PULS D,X
	PSHU D,X,S
	LDD #$0edd
	LDX #$2eab
	PSHS D,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	LDA #$1a
	ANDB #$0F
	ORB #$c0
	STD 40,S

	LDD 42,S
	PSHU D

	LDD #$11ba
	STD 42,S

	PULS D,X
	PSHU D,X,S
	LDD #$eedd
	LDX #$33ba
	PSHS D,X

	LEAS 80,S
	LDD 42,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$a1
	STD 42,S

	LDD 82,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$a1
	STD 82,S

	LDD 122,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ae
	STD 122,S

	LDD 40,S
	PSHU D

	LDA 80,S
	PSHU A

	LDA 120,S
	PSHU A

	LDD #$aadd
	STD 40,S

	LDA #$ab
	STA 80,S

	STA 120,S

	PULS D,X
	PSHU D,X,S
	LDD #$1adc
	LDX #$0dbf
	PSHS D,X

	LEAS 280,S
	LDD -118,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$a0
	STD -118,S

	LDD -78,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$9e
	STD -78,S

	LDD -38,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0000
	STD -38,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 3,S

	LDA 120,S
	PSHU A
	ANDA #$F0
	ORA #$00
	STA 120,S

	LDA -120,S
	PSHU A

	LDA -80,S
	PSHU A

	LDA -40,S
	PSHU A

	LDA ,S
	PSHU A

	LDA 40,S
	PSHU A,S

	LDA 80,S
	PSHU A

	LDA #$fb
	STA -120,S

	LDA #$e1
	STA 80,S

	LDA #$1f
	STA ,S

	STA 40,S

	LDA #$ff
	STA -80,S

	STA -40,S


	LDS $9F00+2
	STS ERASE_POS_HRR4_2+2
	LDU #ERASE_DATA_HRR4_END

	LEAS 602,S
	LDA -120,S
	PSHU A
	ANDA #$F0
	ORA #$0c
	STA -120,S

	LDD -80,S
	PSHU D
	LDA #$ca
	ANDB #$0F
	ORB #$c0
	STD -80,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$3a
	STD 80,S

	LDD -40,S
	PSHU D

	LDD ,S
	PSHU D,S

	LDD 40,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$ddca
	STD ,S

	LDB #$3a
	STD 40,S

	LDD #$ccac
	STD -40,S

	LDB #$aa
	STD 120,S

	LEAS 281,S
	LDA -79,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -79,S

	LDA -39,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -39,S

	LDD -2,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dc
	STD -2,S

	LDD ,S
	PSHU D
	LDA #$ab
	ANDB #$0F
	ORB #$c0
	STD ,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD 38,S

	LDD 40,S
	PSHU D
	LDA #$ab
	ANDB #$0F
	ORB #$d0
	STD 40,S

	LDA 81,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA 81,S

	LDA 121,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA 121,S

	LDD -121,S
	PSHU D

	LDD -81,S
	PSHU D

	LDD -41,S
	PSHU D,S

	LDD 79,S
	PSHU D

	LDD 119,S
	PSHU D

	LDD #$ccad
	STD -121,S

	LDD #$dccb
	STD -41,S

	LDB #$ca
	STD -81,S

	LDB #$ab
	STD 79,S

	LDA #$dd
	STD 119,S

	LEAS 278,S
	LDA -117,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA -117,S

	LDA -77,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA -77,S

	LDD -119,S
	PSHU D

	LDD -79,S
	PSHU D

	LDD -39,S
	PSHU D

	LDD #$cdba
	STD -119,S

	LDD #$dd2b
	STD -79,S

	LDD #$d022
	STD -39,S

	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$dd22
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$9c
	LDX #$3d22
	PSHS A,X

	LEAS 40,S
	LDA 42,S
	PSHU A
	ANDA #$F0
	ORA #$0b
	STA 42,S

	LDD 40,S
	PSHU D

	LDD #$9031
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$ad
	LDX #$3e13
	PSHS A,X

	LEAS 80,S
	PULS A,X
	PSHU A,X,S
	LDA #$9a
	LDX #$02ab
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$0F
	ORA #$a0
	LDB #$d1
	STD 40,S

	LDD 42,S
	PSHU D
	LDA #$9b
	ANDB #$F0
	ORB #$01
	STD 42,S

	PULS A,X
	PSHU A,X,S
	LDA #$e9
	LDX #$d3ab
	PSHS A,X

	LEAS 80,S
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$dd
	STD 39,S

	PULS D,X
	PSHU D,X,S
	LDD #$0ccd
	LDX #$abf0
	PSHS D,X

	LEAS 41,S
	LDD 38,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$09a0
	STD 38,S

	LDD 41,S
	PSHU D
	LDA #$aa
	ANDB #$0F
	ORB #$00
	STD 41,S

	LDD 78,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$09a0
	STD 78,S

	LDD 81,S
	PSHU D
	LDA #$af
	ANDB #$0F
	ORB #$00
	STD 81,S

	LDD 118,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$09b0
	STD 118,S

	LDD 121,S
	PSHU D
	LDA #$91
	ANDB #$0F
	ORB #$e0
	STD 121,S

	PULS A,X
	PSHU A,X,S
	LDA #$d0
	LDX #$9b1e
	PSHS A,X

	LEAS 279,S
	LDA -121,S
	PSHU A
	ANDA #$F0
	ORA #$00
	STA -121,S

	LDA -81,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -81,S

	LDA -41,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA -41,S

	LDA 40,S
	PSHU A
	ANDA #$0F
	ORA #$f0
	STA 40,S

	LDA -118,S
	PSHU A

	LDA -78,S
	PSHU A

	LDA -38,S
	PSHU A

	LDA 2,S
	PSHU A

	LDA 42,S
	PSHU A

	LDA 80,S
	PSHU A,S

	LDA 120,S
	PSHU A

	LDA #$e0
	STA -38,S

	LDA #$0e
	STA 2,S

	LDA #$1e
	STA 42,S

	LDA #$2f
	STA 80,S

	LDA #$e1
	STA -118,S

	STA -78,S

	STA 120,S

SSAV_HRR4
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HRR4
	PSHS U,DP
	STS ERASE_SSAV_HRR4+2

ERASE_POS_HRR4_1
	LDS #$0000
	LDU #ERASE_DATA_HRR4_1

ERASE_CODE_HRR4_1
	PULU A,B,S
	STA 80,S
	STB 40,S

	PULU A,B
	STA ,S
	STB -40,S

	PULU A,B
	STA -80,S
	STB -120,S

	PULU A,B,X,Y
	STA 120,S
	STB 3,S
	STX -38,S
	STY -78,S

	PULU D
	STD -118,S

	PULU D,X,S
	PSHS D,X

	PULU A,B,X,Y
	STA 120,S
	STB 80,S
	STX 40,S
	STY 122,S

	PULU D,X
	STD 82,S
	STX 42,S

	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD 42,S
	STX 40,S

	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD -38,S
	STX -40,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 120,S
	STX 80,S
	STY 40,S

	PULU A,B
	STA 122,S
	STB 42,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,X
	STA 122,S
	STX 81,S

	PULU A,X,Y
	STA 42,S
	STX 120,S
	STY 40,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA -38,S
	STX -79,S
	STY -119,S

	PULU D
	STD -40,S

	PULU D,S
	STD 80,S

	PULU A,X,Y
	STA 41,S
	STX -1,S
	STY 39,S

	PULU A,X
	STA 1,S
	STX -41,S

	PULU A
	STA -80,S

ERASE_POS_HRR4_2
	LDS #$0000
	LDU #ERASE_DATA_HRR4_2

ERASE_CODE_HRR4_2
	PULU A,B,S
	STA 120,S
	STB 80,S

	PULU A,B
	STA 42,S
	STB 2,S

	PULU A,B
	STA -38,S
	STB -78,S

	PULU A,B
	STA -118,S
	STB 40,S

	PULU A,B
	STA -41,S
	STB -81,S

	PULU A
	STA -121,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 121,S
	STX 118,S
	STY 81,S

	PULU D,X,Y
	STD 78,S
	STX 41,S
	STY 38,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 39,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 42,S
	STX 40,S

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

	PULU D,X,Y
	STD -39,S
	STX -79,S
	STY -119,S

	PULU A,B
	STA -77,S
	STB -117,S

	PULU D,X,Y,S
	STD 119,S
	STX 79,S
	STY -41,S

	PULU D,X
	STD -81,S
	STX -121,S

	PULU A,B,X,Y
	STA 121,S
	STB 81,S
	STX 40,S
	STY 38,S

	PULU D,X
	STD ,S
	STX -2,S

	PULU A,B
	STA -39,S
	STB -79,S

	PULU D,X,Y,S
	STD 120,S
	STX 40,S
	STY ,S

	PULU D,X,Y
	STD -40,S
	STX 80,S
	STY -80,S

	PULU A
	STA -120,S

ERASE_SSAV_HRR4
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HRR4_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRR4_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRR4_END
