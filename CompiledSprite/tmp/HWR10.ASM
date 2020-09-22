(main)IMG.ASM
	ORG $D7BC
DRAW_HWR10
	PSHS U,DP
	STS SSAV_HWR10+2

	LDS $9F00
	STS ERASE_POS_HWR10_1+2
	LDU #ERASE_DATA_HWR10_2
	LEAS 443,S

	LDD -41,S
	PSHU D

	LDD -81,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0aa0
	STD -81,S

	LDD #$ccaa
	STD -41,S

	LDD -1,S
	PSHU D

	LDD #$dcad
	STD -1,S

	LDD 39,S
	PSHU D,S

	LDD #$ddc2
	STD 39,S

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

	LEAS 239,S

	LDD -80,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$d2
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

	LDA #$d2
	ANDB #$0F
	ORB #$a0
	STD -119,S

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

	LDD 80,S
	PSHU D

	LDD 39,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 39,S

	LDD #$ddaa
	STD 80,S

	LDD 41,S
	PSHU D

	LDD 120,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 120,S

	LDA 82,S
	PSHU A

	ANDA #$0F
	ORA #$90
	STA 82,S

	LDD #$aaac
	STD 41,S

	LDA 122,S
	PSHU A

	LDA #$9a
	STA 122,S

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

	LDD 80,S
	PSHU D

	LDD 40,S
	PSHU D

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$20
	STA 42,S

	LDD #$dd32
	STD 40,S

	LDB #$d2
	STD 80,S

	LDA 82,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 82,S

	PULS A,X
	PSHU A,X,S

	LDA #$cd
	LDX #$3220
	PSHS A,X

	LEAS 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$01ba
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$a0
	LDX #$deba
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$0d
	LDX #$13ba
	PSHS A,X

	LEAS 40,S

	LDD 40,S
	PSHU D

	LDD 119,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$d0
	STD 119,S

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 42,S

	LDD 79,S
	PSHU D

	ANDA #$F0
	ORA #$00
	LDB #$cd
	STD 79,S

	LDD 81,S
	PSHU D

	LDA #$31
	ANDB #$0F
	ORB #$a0
	STD 81,S

	LDD #$ed23
	STD 40,S

	LDA 121,S
	PSHU A

	LDA 123,S
	PSHU A

	LDA #$1d
	STA 121,S

	LDA #$f0
	STA 123,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$32ba
	PSHS A,X

	LEAS 281,S

	LDD -2,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0a90
	STD -2,S

	LDD 81,S
	PSHU D

	LDA #$ae
	ANDB #$0F
	ORB #$e0
	STD 81,S

	LDA -118,S
	PSHU A

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA -38,S

	LDD 41,S
	PSHU D

	LDA #$af
	ANDB #$0F
	ORB #$e0
	STD 41,S

	LDD -82,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$ed
	STD -82,S

	LDA -120,S
	PSHU A

	LDA 121,S
	PSHU A

	LDD -122,S
	PSHU D

	ANDA #$F0
	ORA #$01
	LDB #$dc
	STD -122,S

	LDD -42,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$9d
	STD -42,S

	LDA #$d0
	STA -120,S

	LDA 118,S
	PSHU A

	ANDA #$F0
	ORA #$01
	STA 118,S

	LDA #$10
	STA -118,S

	LDA -78,S
	PSHU A

	LDD 1,S
	PSHU D,S

	ANDA #$0F
	ANDB #$0F
	ADDD #$a000
	STD 1,S

	LDD 38,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0190
	STD 38,S

	LDA #$1e
	STA -78,S

	LDA 78,S
	PSHU A

	ANDA #$F0
	ORA #$01
	STA 78,S

	LDA #$91
	STA 121,S

	LEAS 240,S

	LDA -82,S
	PSHU A

	ANDA #$F0
	ORA #$0e
	STA -82,S

	LDA -79,S
	PSHU A

	LDA #$01
	STA -79,S

	LDA -42,S
	PSHU A

	ANDA #$F0
	ORA #$0e
	STA -42,S

	LDA 1,S
	PSHU A

	LDA -39,S
	PSHU A

	LDA #$ee
	STA -39,S

	STA 1,S

	LDA 41,S
	PSHU A,S

	LDA #$e0
	STA 41,S

	LDA 81,S
	PSHU A

	ANDA #$F0
	ORA #$0e
	STA 81,S


	LDS $9F00+2
	STS ERASE_POS_HWR10_2+2
	LDU #ERASE_DATA_HWR10_END

	LEAS 441,S

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDA -79,S
	PSHU A

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$aa
	STD -40,S

	STB -79,S

	LDD 41,S
	PSHU D

	LDD #$dcda
	STD 41,S

	LDB #$3a
	STD 81,S

	STD 121,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$ccdd
	PSHS A,X

	LEAS 280,S

	LDD -79,S
	PSHU D

	LDA -38,S
	PSHU A

	LDD -119,S
	PSHU D

	LDD #$ccad
	STD -79,S

	LDB #$aa
	STD -119,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -40,S

	LDA #$cb
	STA -38,S

	PULS A,X
	PSHU A,X,S

	LDX #$cccb
	PSHS B,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$ccab
	PSHS A,X

	LEAS 40,S

	LDD 81,S
	PSHU D

	LDD 41,S
	PSHU D

	STX 41,S

	STX 81,S

	LDD 121,S
	PSHU D

	LDD #$cccb
	STD 121,S

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
	LDB #$dc
	STD -120,S

	LDD -80,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD -80,S

	LDA -118,S
	PSHU A

	LDA #$b2
	STA -118,S

	LDA -78,S
	PSHU A

	LDA #$22
	STA -78,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$0d
	STD -40,S

	LDA -38,S
	PSHU A

	LDA #$2a
	STA -38,S

	PULS A,X
	PSHU A,X,S

	LDA #$cd
	LDX #$d0aa
	PSHS A,X

	LEAS 40,S

	LDA 42,S
	PSHU A

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$09
	LDB #$d2
	STD 40,S

	LDA #$ab
	STA 42,S

	PULS A,X
	PSHU A,X,S

	LDA #$da
	LDX #$d3aa
	PSHS A,X

	LEAS 80,S

	PULS A,X
	PSHU A,X,S

	LDA #$00
	LDX #$d2bb
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$1a
	LDX #$d3ab
	PSHS A,X

	LEAS 40,S

	LDD 80,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD #$e9dd
	STD 40,S

	LDD #$1a0d
	STD 80,S

	LDA 82,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 82,S

	PULS A,X
	PSHU A,X,S

	LDA #$e9
	LDX #$deaa
	PSHS A,X

	LEAS 120,S

	LDD 42,S
	PSHU D

	ANDA #$F0
	ANDB #$F0
	ADDD #$0d01
	STD 42,S

	LDD 40,S
	PSHU D

	LDA #$ff
	ANDB #$0F
	ORB #$c0
	STD 40,S

	LDA 80,S
	PSHU A

	LDA 3,S
	PSHU A

	ANDA #$F0
	ORA #$0f
	STA 3,S

	LDD 82,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$a1
	STD 82,S

	LDD 122,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$a1
	STD 122,S

	LDA 120,S
	PSHU A

	LDA #$bb
	STA 120,S

	STA 80,S

	PULS A,X
	PSHU A,X,S

	LDA #$f1
	LDX #$dcdd
	PSHS A,X

	LEAS 280,S

	LDA 80,S
	PSHU A

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA 3,S

	LDA ,S
	PSHU A

	LDA #$e1
	STA 80,S

	LDA -40,S
	PSHU A

	LDD -78,S
	PSHU D

	ANDA #$F0
	ORA #$09
	LDB #$10
	STD -78,S

	LDA -80,S
	PSHU A

	LDA -120,S
	PSHU A

	LDA #$ff
	STA -80,S

	STA -120,S

	STA ,S

	STA -40,S

	LDD -38,S
	PSHU D

	ANDA #$F0
	ORA #$09
	LDB #$1e
	STD -38,S

	LDA 40,S
	PSHU A

	LDD -118,S
	PSHU D,S

	ANDA #$F0
	ORA #$09
	LDB #$a9
	STD -118,S

	LDA #$11
	STA 40,S

	LDA 43,S
	PSHU A

	ANDA #$0F
	ORA #$e0
	STA 43,S

	LDA 120,S
	PSHU A

	ANDA #$F0
	ORA #$0e
	STA 120,S

SSAV_HWR10
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HWR10
	PSHS U,DP
	STS ERASE_SSAV_HWR10+2

ERASE_POS_HWR10_1
	LDS #$0000
	LDU #ERASE_DATA_HWR10_1

ERASE_CODE_HWR10_1
	PULU A,B,S
	STA 81,S
	STB 41,S

	PULU A,B
	STA -39,S
	STB 1,S

	PULU A,B
	STA -42,S
	STB -79,S

	PULU A
	STA -82,S

	PULU A,X,Y,S
	STA 78,S
	STX 38,S
	STY 1,S

	PULU A,B,X,Y
	STA -78,S
	STB 118,S
	STX -42,S
	STY -122,S

	PULU A,B,X,Y
	STA 121,S
	STB -120,S
	STX -82,S
	STY 41,S

	PULU A,B,X,Y
	STA -38,S
	STB -118,S
	STX 81,S
	STY -2,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA 123,S
	STB 121,S
	STX 81,S
	STY 79,S

	PULU A,X,Y
	STA 42,S
	STX 119,S
	STY 40,S

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
	STX 40,S
	STY 80,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA 122,S
	STB 82,S
	STX 120,S
	STY 41,S

	PULU D,X
	STD 39,S
	STX 80,S

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

	PULU A,X,Y,S
	STA 81,S
	STX 79,S
	STY 39,S

	PULU D,X,Y
	STD -1,S
	STX -81,S
	STY -41,S

ERASE_POS_HWR10_2
	LDS #$0000
	LDU #ERASE_DATA_HWR10_2

ERASE_CODE_HWR10_2
	PULU A,B,X,S
	STA 120,S
	STB 43,S
	STX -118,S

	PULU A,X
	STA 40,S
	STX -38,S

	PULU A,B,X
	STA -120,S
	STB -80,S
	STX -78,S

	PULU A,B
	STA -40,S
	STB ,S

	PULU A,B
	STA 3,S
	STB 80,S

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA 120,S
	STX 122,S
	STY 82,S

	PULU A,B,X,Y
	STA 3,S
	STB 80,S
	STX 40,S
	STY 42,S

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA 82,S
	STX 40,S
	STY 80,S

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

	PULU A,X
	STA -38,S
	STX -40,S

	PULU A,B,X,Y
	STA -78,S
	STB -118,S
	STX -80,S
	STY -120,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 121,S
	STX 41,S
	STY 81,S

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

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 41,S
	STX -40,S

	PULU A,X,Y
	STA -79,S
	STX 121,S
	STY 81,S

ERASE_SSAV_HWR10
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HWR10_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWR10_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWR10_END
