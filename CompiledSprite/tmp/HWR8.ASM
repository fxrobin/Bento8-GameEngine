(main)IMG.ASM
	ORG $BFEA
DRAW_HWR8
	PSHS U,DP
	STS SSAV_HWR8+2

	LDS $9F00
	STS ERASE_POS_HWR8_1+2
	LDU #ERASE_DATA_HWR8_2
	LEAS 523,S
	LDD -81,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0aa0
	STD -81,S

	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$d2
	STD 79,S

	LDA 81,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 81,S

	LDD -41,S
	PSHU D

	LDD -1,S
	PSHU D

	LDD 39,S
	PSHU D,S

	LDD #$ddc2
	STD 39,S

	LDD #$ccaa
	STD -41,S

	LDD #$dcad
	STD -1,S

	LEAS 239,S
	LDD -119,S
	PSHU D
	LDA #$d2
	ANDB #$0F
	ORB #$a0
	STD -119,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$d2
	STD -80,S

	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -78,S

	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -38,S

	LDD -40,S
	PSHU D

	LDD #$ccda
	STD -40,S

	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$aaac
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dc
	LDX #$baca
	PSHS A,X

	LEAS 40,S
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 39,S

	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA 82,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 120,S

	LDD 41,S
	PSHU D

	LDD 80,S
	PSHU D

	LDA 122,S
	PSHU A

	LDA #$9a
	STA 122,S

	LDA #$aa
	STD 41,S

	LDD #$ddaa
	STD 80,S

	PULS A,X
	PSHU A,X,S
	LDA #$dc
	LDX #$aa0c
	PSHS A,X

	LEAS 160,S
	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$c229
	PSHS A,X

	LEAS 40,S
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$20
	STA 42,S

	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 82,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$d00a
	STD 120,S

	LDD #$dd32
	STD 40,S

	LDB #$d2
	STD 80,S

	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$3220
	PSHS A,X

	LEAS 281,S
	LDA -119,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -119,S

	LDA -79,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA -79,S

	LDA -39,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -39,S

	LDA 1,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 1,S

	LDD 79,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$3d
	STD 79,S

	LDD -121,S
	PSHU D

	LDD -81,S
	PSHU D

	LDD -41,S
	PSHU D

	LDD -1,S
	PSHU D

	LDD 39,S
	PSHU D

	LDD 120,S
	PSHU D,S

	LDD #$d0af
	STD 120,S

	LDD #$9dea
	STD -81,S

	LDD #$cd2a
	STD -41,S

	LDD #$dd3a
	STD -1,S

	LDD #$ad1a
	STD -121,S

	LDD #$dde3
	STD 39,S

	LEAS 278,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$ac
	STD -120,S

	LDD -117,S
	PSHU D
	LDA #$11
	ANDB #$0F
	ORB #$f0
	STD -117,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$cc
	STD -80,S

	LDD -77,S
	PSHU D
	LDA #$11
	ANDB #$0F
	ORB #$00
	STD -77,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$dd
	STD -40,S

	LDD -37,S
	PSHU D
	LDA #$10
	ANDB #$0F
	ORB #$e0
	STD -37,S

	LDD ,S
	PSHU D
	LDA #$9a
	ANDB #$0F
	ORB #$a0
	STD ,S

	LDA 3,S
	PSHU A

	LDA 40,S
	PSHU A

	LDA 43,S
	PSHU A

	LDA 80,S
	PSHU A

	LDA 120,S
	PSHU A,S

	LDA #$1f
	STA 120,S

	LDA #$e1
	STA 43,S

	LDA #$eb
	STA 80,S

	LDA #$0e
	STA 3,S

	LDA #$9a
	STA 40,S

	LEAS 220,S
	LDA -60,S
	PSHU A

	LDA -20,S
	PSHU A

	LDA 20,S
	PSHU A

	LDA 60,S
	PSHU A,S

	LDA #$0e
	STA 60,S

	LDA #$11
	STA -20,S

	LDA #$1f
	STA -60,S

	STA 20,S


	LDS $9F00+2
	STS ERASE_POS_HWR8_2+2
	LDU #ERASE_DATA_HWR8_END

	LEAS 521,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$aa
	STD -40,S

	LDA -79,S
	PSHU A

	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	STA -79,S

	LDA #$dc
	STD 81,S

	STD 121,S

	LDB #$da
	STD 41,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$ccdd
	PSHS A,X

	LEAS 280,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -40,S

	LDD -119,S
	PSHU D

	LDD -79,S
	PSHU D

	LDA -38,S
	PSHU A

	LDA #$cb
	STA -38,S

	LDA #$cc
	STD -119,S

	LDB #$ad
	STD -79,S

	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$cccb
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$ccab
	PSHS A,X

	LEAS 40,S
	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	STD 121,S

	STX 41,S

	STX 81,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$ccab
	PSHS A,X

	LEAS 280,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dd
	STD -120,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD -80,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$0d
	STD -40,S

	LDD 40,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$d1
	STD 40,S

	LDA -118,S
	PSHU A

	LDA -78,S
	PSHU A

	LDA -38,S
	PSHU A

	LDA 42,S
	PSHU A

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDA #$2d
	STD 121,S

	LDA #$22
	STA -78,S

	LDA #$aa
	STA -38,S

	LDA #$ab
	STA 42,S

	LDA #$b2
	STA -118,S

	LDA #$ce
	STD 81,S

	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$d0ab
	PSHS A,X

	LEAS 280,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$dd
	STD -40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$f0
	STA 3,S

	LDD 40,S
	PSHU D
	LDA #$e9
	ANDB #$0F
	ORB #$d0
	STD 40,S

	LDD -119,S
	PSHU D

	LDD -79,S
	PSHU D

	LDA -38,S
	PSHU A

	LDD 42,S
	PSHU D

	LDA 80,S
	PSHU A

	LDD 82,S
	PSHU D

	LDA 120,S
	PSHU A

	LDD 122,S
	PSHU D

	LDD #$e90e
	STD 122,S

	LDD #$d3aa
	STD -79,S

	LDA #$0a
	STA -38,S

	LDD #$ea1f
	STD 42,S

	LDA #$e0
	STA 80,S

	LDD #$ea10
	STD 82,S

	LDD #$32ab
	STD -119,S

	LDA #$1a
	STA 120,S

	PULS A,X
	PSHU A,X,S
	LDA #$fa
	LDX #$cd99
	PSHS A,X

	LEAS 280,S
	LDD -118,S
	PSHU D
	LDA #$e0
	ANDB #$0F
	ORB #$e0
	STD -118,S

	LDA ,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA ,S

	LDA 40,S
	PSHU A
	ANDA #$0F
	ORA #$f0
	STA 40,S

	LDA 80,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 80,S

	LDA 120,S
	PSHU A
	ANDA #$0F
	ORA #$20
	STA 120,S

	LDA -120,S
	PSHU A

	LDA -80,S
	PSHU A

	LDA -78,S
	PSHU A

	LDA -40,S
	PSHU A

	LDA -38,S
	PSHU A,S

	LDA #$01
	STA -38,S

	LDA #$ee
	STA -78,S

	LDA #$b1
	STA -40,S

	LDA #$fa
	STA -120,S

	LDA #$bf
	STA -80,S

	LEAS 160,S
	LDA ,S
	PSHU A,S
	ANDA #$0F
	ORA #$e0
	STA ,S

SSAV_HWR8
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HWR8
	PSHS U,DP
	STS ERASE_SSAV_HWR8+2

ERASE_POS_HWR8_1
	LDS #$0000
	LDU #ERASE_DATA_HWR8_1

ERASE_CODE_HWR8_1
	PULU A,S
	STA 60,S
	PULU A
	STA 20,S
	PULU A
	STA -20,S
	PULU A
	STA -60,S
	PULU A,S
	STA 120,S
	PULU A
	STA 80,S
	PULU A
	STA 43,S
	PULU A
	STA 40,S
	PULU A
	STA 3,S
	PULU D
	STD ,S
	PULU D
	STD -37,S
	PULU D
	STD -40,S
	PULU D
	STD -77,S
	PULU D
	STD -80,S
	PULU D
	STD -117,S
	PULU D
	STD -120,S
	PULU D,S
	STD 120,S
	PULU D
	STD 39,S
	PULU D
	STD -1,S
	PULU D
	STD -41,S
	PULU D
	STD -81,S
	PULU D
	STD -121,S
	PULU D
	STD 79,S
	PULU A
	STA 1,S
	PULU A
	STA -39,S
	PULU A
	STA -79,S
	PULU A
	STA -119,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 120,S
	PULU D
	STD 80,S
	PULU D
	STD 40,S
	PULU A
	STA 82,S
	PULU A
	STA 42,S
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU A
	STA 122,S
	PULU D
	STD 80,S
	PULU D
	STD 41,S
	PULU D
	STD 120,S
	PULU A
	STA 82,S
	PULU D
	STD 39,S
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU D
	STD -40,S
	PULU A
	STA -38,S
	PULU A
	STA -78,S
	PULU D
	STD -80,S
	PULU D
	STD -119,S
	PULU D,S
	STD 39,S
	PULU D
	STD -1,S
	PULU D
	STD -41,S
	PULU A
	STA 81,S
	PULU D
	STD 79,S
	PULU D
	STD -81,S
ERASE_POS_HWR8_2
	LDS #$0000
	LDU #ERASE_DATA_HWR8_2

ERASE_CODE_HWR8_2
	PULU A,S
	STA ,S
	PULU A,S
	STA -38,S
	PULU A
	STA -40,S
	PULU A
	STA -78,S
	PULU A
	STA -80,S
	PULU A
	STA -120,S
	PULU A
	STA 120,S
	PULU A
	STA 80,S
	PULU A
	STA 40,S
	PULU A
	STA ,S
	PULU D
	STD -118,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 122,S
	PULU A
	STA 120,S
	PULU D
	STD 82,S
	PULU A
	STA 80,S
	PULU D
	STD 42,S
	PULU A
	STA -38,S
	PULU D
	STD -79,S
	PULU D
	STD -119,S
	PULU D
	STD 40,S
	PULU A
	STA 3,S
	PULU D
	STD -40,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 121,S
	PULU D
	STD 81,S
	PULU A
	STA 42,S
	PULU A
	STA -38,S
	PULU A
	STA -78,S
	PULU A
	STA -118,S
	PULU D
	STD 40,S
	PULU D
	STD -40,S
	PULU D
	STD -80,S
	PULU D
	STD -120,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 121,S
	PULU D
	STD 81,S
	PULU D
	STD 41,S
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU A
	STA -38,S
	PULU D
	STD -79,S
	PULU D
	STD -119,S
	PULU D
	STD -40,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 121,S
	PULU D
	STD 81,S
	PULU D
	STD 41,S
	PULU A
	STA -79,S
	PULU D
	STD -40,S
ERASE_SSAV_HWR8
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HWR8_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWR8_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
	FCB $00
ERASE_DATA_HWR8_END
