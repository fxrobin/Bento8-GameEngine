(main)IMG.ASM
	ORG $C799
DRAW_HWR7
	PSHS U,DP
	STS SSAV_HWR7+2

	LDS $9F00
	STS ERASE_POS_HWR7_1+2
	LDU #ERASE_DATA_HWR7_2
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

	LDD #$ccaa
	STD -41,S

	LDD #$dcad
	STD -1,S

	LDD #$ddc2
	STD 39,S

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
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD 39,S

	LDD 41,S
	PSHU D

	LDD #$aa0c
	STD 41,S

	PULS A,X
	PSHU A,X,S
	LDA #$dc
	LDX #$baca
	PSHS A,X

	LEAS 80,S
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA 42,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 80,S

	LDD 40,S
	PSHU D

	LDA 82,S
	PSHU A

	LDD #$ddaa
	STD 40,S

	LDA #$9a
	STA 82,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$aaac
	PSHS A,X

	LEAS 120,S
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

	LDD #$dd32
	STD 40,S

	LDB #$d2
	STD 80,S

	LDB #$a1
	STD 120,S

	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$3220
	PSHS A,X

	LEAS 281,S
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

	LDA 80,S
	PSHU A

	LDA 120,S
	PSHU A,S

	LDD #$adbe
	STD -121,S

	LDD #$1aa3
	STD -1,S

	LDD #$d031
	STD 39,S

	LDA #$10
	STA 80,S

	LDA #$da
	STA 120,S

	LDD #$2bb3
	STD -41,S

	LDA #$9a
	STD -81,S

	LEAS 280,S
	LDA -120,S
	PSHU A
	ANDA #$F0
	ORA #$09
	STA -120,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$e9
	STD -81,S

	LDD -2,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$bd
	STD -2,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$bd
	STD 38,S

	LDD 40,S
	PSHU D
	LDA #$e1
	ANDB #$0F
	ORB #$f0
	STD 40,S

	LDD 78,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$ab
	STD 78,S

	LDD 80,S
	PSHU D
	LDA #$0a
	ANDB #$0F
	ORB #$10
	STD 80,S

	LDD 118,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$00a0
	STD 118,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$1f
	STD 120,S

	LDD -41,S
	PSHU D

	LDA ,S
	PSHU A,S

	LDD #$a0e0
	STD -41,S

	LDA #$ee
	STA ,S

	LEAS 219,S
	LDD -61,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$ff
	STD -61,S

	LDD -21,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$f2
	STD -21,S

	LDA -58,S
	PSHU A

	LDA -18,S
	PSHU A

	LDA 20,S
	PSHU A

	LDA 60,S
	PSHU A,S

	LDA #$11
	STA -58,S

	LDA #$ff
	STA 20,S

	LDA #$ee
	STA -18,S

	STA 60,S


	LDS $9F00+2
	STS ERASE_POS_HWR7_2+2
	LDU #ERASE_DATA_HWR7_END

	LEAS 522,S
	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -1,S

	LDA -80,S
	PSHU A

	LDD -41,S
	PSHU D

	LDA 1,S
	PSHU A

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D,S

	LDA #$dd
	STA 1,S

	LDD #$dcda
	STD 40,S

	LDB #$3a
	STD 80,S

	LDD #$ccaa
	STD -41,S

	STB -80,S

	LEAS 239,S
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

	LDD #$dc3a
	STD -119,S

	LDD #$ccaa
	STD -79,S

	LDA #$ad
	STA -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$cccb
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$cccb
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 40,S

	LDA 42,S
	PSHU A

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDD #$ccab
	STD 81,S

	STD 121,S

	STB 42,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$ccab
	PSHS A,X

	LEAS 240,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dd
	STD -40,S

	LDD -79,S
	PSHU D

	LDA -38,S
	PSHU A

	LDD #$dccb
	STD -79,S

	LDA #$b2
	STA -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$dd22
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ab
	STD 40,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$bb
	STD 120,S

	LDA 42,S
	PSHU A

	LDA 81,S
	PSHU A

	LDA #$33
	STA 42,S

	STB 81,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$0b22
	PSHS A,X

	LEAS 281,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$aa
	STD -121,S

	LDA -119,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -119,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$9a
	STD -81,S

	LDD ,S
	PSHU D
	LDA #$dd
	ANDB #$0F
	ORB #$d0
	STD ,S

	LDD 40,S
	PSHU D
	LDA #$dc
	ANDB #$0F
	ORB #$90
	STD 40,S

	LDD 80,S
	PSHU D
	LDA #$0d
	ANDB #$0F
	ORB #$a0
	STD 80,S

	LDD 119,S
	PSHU D
	ANDA #$0F
	ORA #$e0
	LDB #$cd
	STD 119,S

	LDA 121,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 121,S

	LDA -79,S
	PSHU A

	LDD -40,S
	PSHU D,S

	LDA #$dc
	STA -79,S

	LDD #$d90d
	STD -40,S

	LEAS 279,S
	LDD -120,S
	PSHU D
	LDA #$1e
	ANDB #$0F
	ORB #$d0
	STD -120,S

	LDD -80,S
	PSHU D
	LDA #$1a
	ANDB #$0F
	ORB #$d0
	STD -80,S

	LDA 82,S
	PSHU A
	ANDA #$F0
	ORA #$0e
	STA 82,S

	LDD 120,S
	PSHU D
	LDA #$af
	ANDB #$0F
	ORB #$f0
	STD 120,S

	LDA -118,S
	PSHU A

	LDA -78,S
	PSHU A

	LDA -40,S
	PSHU A

	LDA -38,S
	PSHU A

	LDA ,S
	PSHU A

	LDA 2,S
	PSHU A

	LDA 40,S
	PSHU A

	LDA 42,S
	PSHU A

	LDA 80,S
	PSHU A,S

	LDA #$9a
	STA -118,S

	LDA #$ea
	STA -78,S

	LDA #$aa
	STA -38,S

	LDA #$19
	STA ,S

	LDA #$a1
	STA 2,S

	LDA #$91
	STA 42,S

	LDA #$ab
	STA 80,S

	LDA #$1a
	STA -40,S

	STA 40,S

	LEAS 180,S
	LDD -20,S
	PSHU D

	LDD 20,S
	PSHU D,S

	LDD #$afff
	STD -20,S

	LDD #$0011
	STD 20,S

SSAV_HWR7
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HWR7
	PSHS U,DP
	STS ERASE_SSAV_HWR7+2

ERASE_POS_HWR7_1
	LDS #$0000
	LDU #ERASE_DATA_HWR7_1

ERASE_CODE_HWR7_1
	PULU A,S
	STA 60,S
	PULU A
	STA 20,S
	PULU A
	STA -18,S
	PULU A
	STA -58,S
	PULU D
	STD -21,S
	PULU D
	STD -61,S
	PULU A,S
	STA ,S
	PULU D
	STD -41,S
	PULU D
	STD 120,S
	PULU D
	STD 118,S
	PULU D
	STD 80,S
	PULU D
	STD 78,S
	PULU D
	STD 40,S
	PULU D
	STD 38,S
	PULU D
	STD -2,S
	PULU D
	STD -81,S
	PULU A
	STA -120,S
	PULU A,S
	STA 120,S
	PULU A
	STA 80,S
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
	STA 82,S
	PULU D
	STD 40,S
	PULU D
	STD 80,S
	PULU A
	STA 42,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 41,S
	PULU D
	STD 39,S
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
ERASE_POS_HWR7_2
	LDS #$0000
	LDU #ERASE_DATA_HWR7_2

ERASE_CODE_HWR7_2
	PULU D,S
	STD 20,S
	PULU D
	STD -20,S
	PULU A,S
	STA 80,S
	PULU A
	STA 42,S
	PULU A
	STA 40,S
	PULU A
	STA 2,S
	PULU A
	STA ,S
	PULU A
	STA -38,S
	PULU A
	STA -40,S
	PULU A
	STA -78,S
	PULU A
	STA -118,S
	PULU D
	STD 120,S
	PULU A
	STA 82,S
	PULU D
	STD -80,S
	PULU D
	STD -120,S
	PULU D,S
	STD -40,S
	PULU A
	STA -79,S
	PULU A
	STA 121,S
	PULU D
	STD 119,S
	PULU D
	STD 80,S
	PULU D
	STD 40,S
	PULU D
	STD ,S
	PULU D
	STD -81,S
	PULU A
	STA -119,S
	PULU D
	STD -121,S
	PULU A,X,S
	PSHS A,X
	PULU A
	STA 81,S
	PULU A
	STA 42,S
	PULU D
	STD 120,S
	PULU D
	STD 40,S
	PULU A,X,S
	PSHS A,X
	PULU A
	STA -38,S
	PULU D
	STD -79,S
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
	PULU D
	STD 40,S
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
	PULU D,S
	STD 80,S
	PULU D
	STD 40,S
	PULU A
	STA 1,S
	PULU D
	STD -41,S
	PULU A
	STA -80,S
	PULU D
	STD -1,S
ERASE_SSAV_HWR7
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HWR7_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWR7_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWR7_END
