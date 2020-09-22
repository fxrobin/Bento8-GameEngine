(main)IMG.ASM
	ORG $AD52
DRAW_HRR9
	PSHS U,DP
	STS SSAV_HRR9+2

	LDS $9F00
	STS ERASE_POS_HRR9_1+2
	LDU #ERASE_DATA_HRR9_2
	LEAS 563,S

	LDD -1,S
	PSHU D

	LDD 80,S
	PSHU D

	LDA 1,S
	PSHU A

	ANDA #$F0
	ORA #$0d
	STA 1,S

	LDD #$ddc1
	STD -1,S

	LDD 39,S
	PSHU D,S

	ANDA #$F0
	ORA #$0d
	LDB #$d2
	STD 39,S

	LDD -41,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$ad
	STD -41,S

	LDA -80,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -80,S

	LDA 41,S
	PSHU A

	LDA #$cd
	STA 41,S

	LDA #$d2
	STD 80,S

	LEAS 239,S

	LDD -79,S
	PSHU D

	LDA -38,S
	PSHU A

	LDD -119,S
	PSHU D

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$da
	STD -40,S

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

	LDA 42,S
	PSHU A

	LDA 122,S
	PSHU A

	LDD 120,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$c2
	STD 120,S

	LDD 81,S
	PSHU D

	LDD #$ccb0
	STD 81,S

	STB 42,S

	LDA #$b9
	STA 122,S

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

	LEAS 39,S

	PULS D,X
	PSHU D,X,S

	LDD #$aa22
	LDX #$d222
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$bb33
	LDX #$d321
	PSHS D,X

	LEAS 40,S

	LDD 80,S
	PSHU D

	LDA #$bb
	ANDB #$F0
	ORB #$0d
	STD 80,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$30
	STA 3,S

	LDD 40,S
	PSHU D

	LDA #$ba
	ANDB #$F0
	ORB #$0d
	STD 40,S

	LDD 42,S
	PSHU D

	LDD 82,S
	PSHU D

	LDD #$109a
	STD 42,S

	LDA #$21
	STD 82,S

	PULS A,X
	PSHU A,X,S

	LDA #$bb
	LDX #$dd0d
	PSHS A,X

	LEAS 120,S

	PULS D,X
	PSHU D,X,S

	LDD #$aacd
	LDX #$23af
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$a0dd
	LDX #$c292
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$0edd
	LDX #$d3ff
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$0ed0
	LDX #$daff
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$ee0d
	LDX #$aaf1
	PSHS D,X

	LEAS 40,S

	LDD 42,S
	PSHU D

	LDA 40,S
	PSHU A

	LDA 120,S
	PSHU A

	LDD 82,S
	PSHU D

	LDA #$01
	ANDB #$0F
	ORB #$00
	STD 82,S

	LDA #$1a
	STA 120,S

	LDA 80,S
	PSHU A

	LDD #$ae1e
	STD 42,S

	LDA #$9a
	STA 80,S

	STA 40,S

	LDD 122,S
	PSHU D

	LDA #$01
	ANDB #$0F
	ORB #$e0
	STD 122,S

	PULS D,X
	PSHU D,X,S

	LDD #$eedd
	LDX #$9af0
	PSHS D,X

	LEAS 260,S

	LDA 60,S
	PSHU A

	ANDA #$F0
	ORA #$01
	STA 60,S

	LDA -100,S
	PSHU A

	LDA -98,S
	PSHU A

	LDA 20,S
	PSHU A

	LDA -60,S
	PSHU A

	LDA -58,S
	PSHU A

	LDA #$e0
	STA -58,S

	LDA #$0e
	STA -98,S

	LDA -20,S
	PSHU A

	LDA #$e1
	STA 20,S

	STA -20,S

	LDA #$11
	STA -100,S

	STA -60,S

	LDA -18,S
	PSHU A,S

	ANDA #$F0
	ORA #$0e
	STA -18,S

	LDA 100,S
	PSHU A

	ANDA #$F0
	ORA #$00
	STA 100,S


	LDS $9F00+2
	STS ERASE_POS_HRR9_2+2
	LDU #ERASE_DATA_HRR9_END

	LEAS 602,S

	LDD 40,S
	PSHU D

	LDA -120,S
	PSHU A

	ANDA #$F0
	ORA #$0c
	STA -120,S

	LDD ,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD 120,S
	PSHU D,S

	LDD #$dd3a
	STD 40,S

	LDB #$ca
	STD ,S

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

	LDD #$ccac
	STD -40,S

	LDB #$aa
	STD 120,S

	LEAS 281,S

	LDD -41,S
	PSHU D

	LDD 38,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD 38,S

	LDD 119,S
	PSHU D

	LDD -81,S
	PSHU D

	LDD 79,S
	PSHU D

	LDD #$dcca
	STD -81,S

	LDB #$cb
	STD -41,S

	LDD -121,S
	PSHU D

	LDD -2,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$dc
	STD -2,S

	LDD 40,S
	PSHU D

	LDA #$ab
	ANDB #$0F
	ORB #$d0
	STD 40,S

	LDA -39,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -39,S

	LDA -79,S
	PSHU A

	ANDA #$0F
	ORA #$c0
	STA -79,S

	LDD ,S
	PSHU D,S

	LDA #$ab
	ANDB #$0F
	ORB #$c0
	STD ,S

	LDA 81,S
	PSHU A

	ANDA #$0F
	ORA #$90
	STA 81,S

	LDD #$ccad
	STD -121,S

	LDD #$dcab
	STD 79,S

	LDA #$dd
	STD 119,S

	LDA 121,S
	PSHU A

	ANDA #$0F
	ORA #$90
	STA 121,S

	LEAS 278,S

	LDD 119,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0a90
	STD 119,S

	LDD -79,S
	PSHU D

	LDD -119,S
	PSHU D

	LDD #$dd2b
	STD -79,S

	LDD 79,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$ad
	STD 79,S

	LDD 81,S
	PSHU D

	LDA -77,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA -77,S

	LDD #$cdba
	STD -119,S

	LDD #$d311
	STD 81,S

	LDD 39,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$ae
	STD 39,S

	LDD 41,S
	PSHU D

	LDA -38,S
	PSHU A

	LDA -117,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA -117,S

	LDD -40,S
	PSHU D

	ANDA #$0F
	ORA #$a0
	LDB #$d0
	STD -40,S

	LDD #$ed22
	STD 41,S

	STB -38,S

	LDD 121,S
	PSHU D

	LDA #$d2
	ANDB #$F0
	ORB #$00
	STD 121,S

	PULS A,X
	PSHU A,X,S

	LDA #$aa
	LDX #$2d22
	PSHS A,X

	LEAS 162,S

	LDD -1,S
	PSHU D,S

	LDA 1,S
	PSHU A

	ANDA #$0F
	ORA #$10
	STA 1,S

	LDD #$dd1a
	STD -1,S

	LEAS 158,S

	LDA 40,S
	PSHU A

	LDA 42,S
	PSHU A

	LDD -40,S
	PSHU D

	LDD -80,S
	PSHU D

	ANDA #$0F
	ORA #$e0
	LDB #$00
	STD -80,S

	LDA -38,S
	PSHU A

	ANDA #$F0
	ORA #$0b
	STA -38,S

	LDA 80,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 80,S

	LDA #$90
	STA 40,S

	LDD -118,S
	PSHU D

	LDA #$e9
	ANDB #$0F
	ORB #$e0
	STD -118,S

	LDA 122,S
	PSHU A

	LDA -77,S
	PSHU A

	ANDA #$0F
	ORA #$e0
	STA -77,S

	LDD #$e9de
	STD -40,S

	LDD -120,S
	PSHU D

	ANDA #$0F
	ORA #$10
	LDB #$cd
	STD -120,S

	LDA 82,S
	PSHU A

	LDA 120,S
	PSHU A

	ANDA #$0F
	ORA #$f0
	STA 120,S

	LDA #$1b
	STA 42,S

	LDA #$fa
	STA 82,S

	STA 122,S

	PULS A,X
	PSHU A,X,S

	LDA #$9a
	LDX #$0dab
	PSHS A,X

	LEAS 280,S

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$e0
	STA -38,S

	LDA 80,S
	PSHU A

	ANDA #$0F
	ORA #$10
	STA 80,S

	LDA -80,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -80,S

	LDA -78,S
	PSHU A

	LDA -120,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -120,S

	LDA 40,S
	PSHU A

	ANDA #$0F
	ORA #$f0
	STA 40,S

	LDA 120,S
	PSHU A,S

	LDA -118,S
	PSHU A

	LDA #$19
	STA -118,S

	LDA #$0e
	STA -78,S

	STA 120,S

SSAV_HRR9
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HRR9
	PSHS U,DP
	STS ERASE_SSAV_HRR9+2

ERASE_POS_HRR9_1
	LDS #$0000
	LDU #ERASE_DATA_HRR9_1

ERASE_CODE_HRR9_1
	PULU A,B,S
	STA 100,S
	STB -18,S

	PULU A,B
	STA -20,S
	STB -58,S

	PULU A,B
	STA -60,S
	STB 20,S

	PULU A,B
	STA -98,S
	STB -100,S

	PULU A
	STA 60,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 122,S

	PULU A,X
	STA 80,S
	STX 82,S

	PULU A,B,X
	STA 120,S
	STB 40,S
	STX 42,S

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

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 82,S
	STX 42,S
	STY 40,S

	PULU A,X
	STA 3,S
	STX 80,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 81,S
	STX 120,S

	PULU A,B,X
	STA 122,S
	STB 42,S
	STX 40,S

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

	PULU A,B,X,Y,S
	STA 41,S
	STB -80,S
	STX -41,S
	STY 39,S

	PULU A,X,Y
	STA 1,S
	STX 80,S
	STY -1,S

ERASE_POS_HRR9_2
	LDS #$0000
	LDU #ERASE_DATA_HRR9_2

ERASE_CODE_HRR9_2
	PULU A,B,S
	STA -118,S
	STB 120,S

	PULU A,B
	STA 40,S
	STB -120,S

	PULU A,B
	STA -78,S
	STB -80,S

	PULU A,B
	STA 80,S
	STB -38,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X
	STA 120,S
	STB 82,S
	STX -120,S

	PULU A,B,X
	STA -77,S
	STB 122,S
	STX -118,S

	PULU A,B,X,Y
	STA 80,S
	STB -38,S
	STX -80,S
	STY -40,S

	PULU A,B
	STA 42,S
	STB 40,S

	PULU A,X,S
	STA 1,S
	STX -1,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 121,S
	STX -40,S

	PULU A,B,X,Y
	STA -117,S
	STB -38,S
	STX 41,S
	STY 39,S

	PULU A,X,Y
	STA -77,S
	STX 81,S
	STY 79,S

	PULU D,X,Y
	STD -119,S
	STX -79,S
	STY 119,S

	PULU A,B,X,S
	STA 121,S
	STB 81,S
	STX ,S

	PULU A,B,X,Y
	STA -79,S
	STB -39,S
	STX 40,S
	STY -2,S

	PULU D,X,Y
	STD -121,S
	STX 79,S
	STY -81,S

	PULU D,X,Y
	STD 119,S
	STX 38,S
	STY -41,S

	PULU D,X,Y,S
	STD 80,S
	STX -80,S
	STY 120,S

	PULU D,X
	STD -40,S
	STX ,S

	PULU A,X
	STA -120,S
	STX 40,S

ERASE_SSAV_HRR9
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HRR9_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRR9_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HRR9_END
