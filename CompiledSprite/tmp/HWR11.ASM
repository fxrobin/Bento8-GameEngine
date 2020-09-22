(main)IMG.ASM
	ORG $ADFF
DRAW_HWR11
	PSHS U,DP
	STS SSAV_HWR11+2

	LDS $9F00
	STS ERASE_POS_HWR11_1+2
	LDU #ERASE_DATA_HWR11_2
	LEAS 483,S

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

	LDD 120,S
	PSHU D

	LDA 82,S
	PSHU A

	ANDA #$0F
	ORA #$10
	STA 82,S

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$20
	STA 42,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$ddd2
	STD 80,S

	LDB #$32
	STD 40,S

	LDB #$01
	STD 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$cd
	LDX #$3220
	PSHS A,X

	LEAS 281,S

	LDD 79,S
	PSHU D

	LDD -41,S
	PSHU D

	LDD -81,S
	PSHU D

	LDD #$fd22
	STD -41,S

	LDD -121,S
	PSHU D

	LDD 119,S
	PSHU D

	LDD #$ad0a
	STD 119,S

	LDA 81,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 81,S

	LDD 39,S
	PSHU D,S

	LDD #$9c2a
	STD 39,S

	LDD -1,S
	PSHU D

	LDD #$9d1a
	STD 79,S

	LDD #$a932
	STD -1,S

	LDA #$ad
	STD -81,S

	LDD #$90de
	STD -121,S

	LDA 41,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 41,S

	LDA 121,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA 121,S

	LEAS 280,S

	LDD -121,S
	PSHU D

	LDD 81,S
	PSHU D

	ANDA #$F0
	ANDB #$0F
	ADDD #$0ae0
	STD 81,S

	LDD #$af09
	STD -121,S

	LDA 2,S
	PSHU A

	ANDA #$0F
	ORA #$f0
	STA 2,S

	LDA 79,S
	PSHU A

	LDD -41,S
	PSHU D

	LDA #$bb
	ANDB #$F0
	ORB #$0d
	STD -41,S

	LDD -81,S
	PSHU D

	LDA #$fb
	ANDB #$F0
	ORB #$0d
	STD -81,S

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$10
	STA 42,S

	LDA 119,S
	PSHU A

	LDA #$ef
	STA 119,S

	LDD 39,S
	PSHU D,S

	LDA #$12
	ANDB #$F0
	ORB #$0d
	STD 39,S

	LDD -1,S
	PSHU D

	LDA #$af
	ANDB #$F0
	ORB #$0d
	STD -1,S

	LDA #$1f
	STA 79,S

	LDA 121,S
	PSHU A

	LDA -119,S
	PSHU A

	ANDA #$0F
	ORA #$a0
	STA -119,S

	LDA #$fa
	STA 121,S

	LEAS 240,S

	LDA 41,S
	PSHU A

	LDA -39,S
	PSHU A

	LDA -81,S
	PSHU A

	ANDA #$F0
	ORA #$0f
	STA -81,S

	LDA 1,S
	PSHU A

	LDA -79,S
	PSHU A

	LDA #$19
	STA 1,S

	LDA #$e0
	STA 41,S

	LDA -41,S
	PSHU A,S

	ANDA #$F0
	ORA #$0e
	STA -41,S

	LDA #$1a
	STA -79,S

	STA -39,S

	LDA 81,S
	PSHU A

	ANDA #$0F
	ORA #$00
	STA 81,S


	LDS $9F00+2
	STS ERASE_POS_HWR11_2+2
	LDU #ERASE_DATA_HWR11_END

	LEAS 481,S

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

	LDD 40,S
	PSHU D

	LDA -78,S
	PSHU A

	LDD 120,S
	PSHU D

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$0a
	LDB #$d3
	STD 80,S

	LDA -38,S
	PSHU A

	LDA #$22
	STA -38,S

	STA -78,S

	LDA -118,S
	PSHU A

	LDD -80,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD -80,S

	LDA #$b2
	STA -118,S

	LDA #$d9
	STD 40,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$0d
	STD -40,S

	LDD #$01d2
	STD 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$cd
	LDX #$d033
	PSHS A,X

	LEAS 160,S

	PULS A,X
	PSHU A,X,S

	LDA #$01
	LDX #$c2aa
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$19
	LDX #$d3bb
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$1a
	LDX #$0ebb
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$19
	LDX #$ddba
	PSHS A,X

	LEAS 40,S

	LDA 42,S
	PSHU A

	LDD 40,S
	PSHU D

	LDA #$91
	ANDB #$0F
	ORB #$d0
	STD 40,S

	LDA #$a9
	STA 42,S

	LDA 80,S
	PSHU A

	ANDA #$F0
	ORA #$0a
	STA 80,S

	LDA 120,S
	PSHU A

	ANDA #$F0
	ORA #$0a
	STA 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$0e
	LDX #$dcba
	PSHS A,X

	LEAS 281,S

	LDD -39,S
	PSHU D

	LDD -79,S
	PSHU D

	LDD 1,S
	PSHU D

	LDD 41,S
	PSHU D

	LDA #$9e
	ANDB #$0F
	ORB #$10
	STD 41,S

	LDD 81,S
	PSHU D,S

	ANDA #$F0
	ANDB #$0F
	ADDD #$0e00
	STD 81,S

	LDD #$aa11
	STD -79,S

	LDA #$9a
	STD -39,S

	LDD #$a91e
	STD 1,S

	LDD -119,S
	PSHU D

	LDA #$da
	ANDB #$F0
	ORB #$01
	STD -119,S

	LDA -121,S
	PSHU A

	ANDA #$F0
	ORA #$00
	STA -121,S

	LDA 121,S
	PSHU A

	ANDA #$F0
	ORA #$0e
	STA 121,S

	LEAS 161,S

	LDA ,S
	PSHU A,S

	ANDA #$F0
	ORA #$00
	STA ,S

SSAV_HWR11
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HWR11
	PSHS U,DP
	STS ERASE_SSAV_HWR11+2

ERASE_POS_HWR11_1
	LDS #$0000
	LDU #ERASE_DATA_HWR11_1

ERASE_CODE_HWR11_1
	PULU A,B,S
	STA 81,S
	STB -41,S

	PULU A,B
	STA -79,S
	STB 1,S

	PULU A,B
	STA -81,S
	STB -39,S

	PULU A
	STA 41,S

	PULU A,B,X,Y,S
	STA -119,S
	STB 121,S
	STX -1,S
	STY 39,S

	PULU A,B,X,Y
	STA 119,S
	STB 42,S
	STX -81,S
	STY -41,S

	PULU A,B,X,Y
	STA 79,S
	STB 2,S
	STX 81,S
	STY -121,S

	PULU A,B,X,Y,S
	STA 121,S
	STB 41,S
	STX -1,S
	STY 39,S

	PULU A,X,Y
	STA 81,S
	STX 119,S
	STY -121,S

	PULU D,X,Y
	STD -81,S
	STX -41,S
	STY 79,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 80,S
	STX 40,S

	PULU A,B,X
	STA 42,S
	STB 82,S
	STX 120,S

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

ERASE_POS_HWR11_2
	LDS #$0000
	LDU #ERASE_DATA_HWR11_2

ERASE_CODE_HWR11_2
	PULU A,S
	STA ,S

	PULU A,B,X,Y,S
	STA 121,S
	STB -121,S
	STX -119,S
	STY 81,S

	PULU D,X,Y
	STD 41,S
	STX 1,S
	STY -79,S

	PULU D
	STD -39,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X
	STA 120,S
	STB 80,S
	STX 40,S

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

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -40,S
	STX -80,S

	PULU A,B,X,Y
	STA -118,S
	STB -38,S
	STX 80,S
	STY 120,S

	PULU A,X,Y
	STA -78,S
	STX 40,S
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

ERASE_SSAV_HWR11
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HWR11_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HWR11_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWR11_END
