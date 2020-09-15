(main)IMG.ASM
	ORG $BFC6
DRAW_HWL8
	PSHS U,DP
	STS SSAV_HWL8+2

	LDS $9F00
	STS ERASE_POS_HWL8_1+2
	LDU #ERASE_DATA_HWL8_2
	LEAS 522,S
	LDD -39,S
	PSHU D
	LDA #$aa
	ANDB #$0F
	ORB #$c0
	STD -39,S

	LDA -79,S
	PSHU A

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDA #$aa
	STA -79,S

	LDD #$adcd
	STD 40,S

	LDA #$a3
	STD 80,S

	STD 120,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$ccdd
	PSHS A,X

	LEAS 280,S
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

	LDD #$aacc
	STD -120,S

	LDA #$da
	STD -80,S

	LDA #$bc
	STD -40,S

	PULS A,X
	PSHU A,X,S
	LDA #$bc
	LDX #$cccc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ba
	LDX #$ccdd
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$bacc
	STD 40,S

	STD 80,S

	LDD #$bccd
	STD 120,S

	PULS A,X
	PSHU A,X,S
	LDA #$ba
	LDX #$ccdd
	PSHS A,X

	LEAS 280,S
	LDA -118,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -118,S

	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -78,S

	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -38,S

	LDA 42,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA 42,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$2bdd
	STD -120,S

	LDA #$22
	STD -80,S

	LDD #$aad0
	STD -40,S

	LDD #$ba1d
	STD 40,S

	LDD #$bbec
	STD 80,S

	LDB #$d2
	STD 120,S

	PULS A,X
	PSHU A,X,S
	LDA #$ba
	LDX #$0ddc
	PSHS A,X

	LEAS 281,S
	LDA -39,S
	PSHU A
	ANDA #$0F
	ORA #$f0
	STA -39,S

	LDD -2,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$99
	STD -2,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$9e
	STD 40,S

	LDD -121,S
	PSHU D

	LDD -81,S
	PSHU D

	LDD -41,S
	PSHU D

	LDD ,S
	PSHU D

	LDD 38,S
	PSHU D

	LDD 78,S
	PSHU D

	LDA 81,S
	PSHU A

	LDD 118,S
	PSHU D

	LDA 121,S
	PSHU A,S

	LDD #$ba23
	STD -121,S

	LDD #$aa3d
	STD -81,S

	LDD #$a0dd
	STD -41,S

	LDD #$dcaf
	STD ,S

	LDD #$f1ae
	STD 38,S

	LDA #$01
	STD 78,S

	LDA #$0e
	STA 81,S

	LDD #$e09e
	STD 118,S

	LDA #$a1
	STA 121,S

	LEAS 280,S
	LDD -122,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$0e
	STD -122,S

	LDA 1,S
	PSHU A
	ANDA #$F0
	ORA #$0b
	STA 1,S

	LDA 41,S
	PSHU A
	ANDA #$F0
	ORA #$0f
	STA 41,S

	LDA 81,S
	PSHU A
	ANDA #$F0
	ORA #$01
	STA 81,S

	LDA 121,S
	PSHU A
	ANDA #$F0
	ORA #$02
	STA 121,S

	LDA -119,S
	PSHU A

	LDA -81,S
	PSHU A

	LDA -79,S
	PSHU A

	LDA -41,S
	PSHU A

	LDA -39,S
	PSHU A,S

	LDA #$af
	STA -119,S

	LDA #$ee
	STA -81,S

	LDA #$fb
	STA -79,S

	LDA #$10
	STA -41,S

	LDA #$1b
	STA -39,S

	LEAS 161,S
	LDA ,S
	PSHU A,S
	ANDA #$F0
	ORA #$0e
	STA ,S


	LDS $9F00+2
	STS ERASE_POS_HWL8_2+2
	LDU #ERASE_DATA_HWL8_END

	LEAS 523,S
	LDD -81,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0aa0
	STD -81,S

	LDD 78,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$2d
	STD 78,S

	LDA 80,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 80,S

	LDD -41,S
	PSHU D

	LDD -1,S
	PSHU D

	LDD 39,S
	PSHU D,S

	LDD #$aacc
	STD -41,S

	LDD #$dacd
	STD -1,S

	LDD #$2cdd
	STD 39,S

	LEAS 238,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$2d
	STD -120,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$2d
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
	LDB #$ad
	STD -40,S

	LDA -38,S
	PSHU A

	LDA #$cc
	STA -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$ca
	LDX #$aacc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ac
	LDX #$abcd
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$c0
	LDX #$aacd
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$aa
	STD 40,S

	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 82,S

	LDA 42,S
	PSHU A

	LDD 80,S
	PSHU D

	LDA #$dd
	STA 42,S

	LDD #$a9cc
	STD 80,S

	PULS A,X
	PSHU A,X,S
	LDA #$ca
	LDX #$aadd
	PSHS A,X

	LEAS 120,S
	PULS A,X
	PSHU A,X,S
	LDA #$92
	LDX #$2ccc
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$02
	LDB #$23
	STD 40,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$2d
	STD 80,S

	LDA 42,S
	PSHU A

	LDA 82,S
	PSHU A

	LDD 121,S
	PSHU D

	LDA #$dd
	STA 42,S

	STA 82,S

	LDD #$a00d
	STD 121,S

	PULS A,X
	PSHU A,X,S
	LDA #$02
	LDX #$23cc
	PSHS A,X

	LEAS 280,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$a1
	STD -120,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0b
	LDB #$ae
	STD -80,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$a2
	STD -40,S

	LDD ,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$a3
	STD ,S

	LDD 81,S
	PSHU D
	LDA #$d3
	ANDB #$F0
	ORB #$0d
	STD 81,S

	LDA -118,S
	PSHU A

	LDA -78,S
	PSHU A

	LDA -38,S
	PSHU A

	LDA 2,S
	PSHU A

	LDD 41,S
	PSHU D

	LDD 120,S
	PSHU D,S

	LDA #$da
	STA -118,S

	LDA #$d9
	STA -78,S

	LDA #$dc
	STA -38,S

	LDA #$dd
	STA 2,S

	LDD #$3edd
	STD 41,S

	LDD #$fa0d
	STD 120,S

	LEAS 281,S
	LDD -122,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$11
	STD -122,S

	LDD -119,S
	PSHU D
	LDA #$ca
	ANDB #$0F
	ORB #$f0
	STD -119,S

	LDD -82,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$11
	STD -82,S

	LDD -79,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$10
	STD -79,S

	LDD -42,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$01
	STD -42,S

	LDD -39,S
	PSHU D
	LDA #$dd
	ANDB #$0F
	ORB #$10
	STD -39,S

	LDD 1,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$a9
	STD 1,S

	LDA -1,S
	PSHU A

	LDA 39,S
	PSHU A

	LDA 42,S
	PSHU A

	LDA 82,S
	PSHU A

	LDA 122,S
	PSHU A,S

	LDA #$e0
	STA -1,S

	LDA #$1e
	STA 39,S

	STB 42,S

	LDA #$be
	STA 82,S

	LDA #$f1
	STA 122,S

	LEAS 222,S
	LDA -60,S
	PSHU A

	LDA -20,S
	PSHU A

	LDA 20,S
	PSHU A

	LDA 60,S
	PSHU A,S

	LDA #$f1
	STA -60,S

	LDA #$11
	STA -20,S

	LDA #$f1
	STA 20,S

	LDA #$e0
	STA 60,S

SSAV_HWL8
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HWL8
	PSHS U,DP
	STS ERASE_SSAV_HWL8+2

ERASE_POS_HWL8_1
	LDS #$0000
	LDU #ERASE_DATA_HWL8_1

ERASE_CODE_HWL8_1
	PULU A,S
	STA ,S
	PULU A,S
	STA -39,S
	PULU A
	STA -41,S
	PULU A
	STA -79,S
	PULU A
	STA -81,S
	PULU A
	STA -119,S
	PULU A
	STA 121,S
	PULU A
	STA 81,S
	PULU A
	STA 41,S
	PULU A
	STA 1,S
	PULU D
	STD -122,S
	PULU A,S
	STA 121,S
	PULU D
	STD 118,S
	PULU A
	STA 81,S
	PULU D
	STD 78,S
	PULU D
	STD 38,S
	PULU D
	STD ,S
	PULU D
	STD -41,S
	PULU D
	STD -81,S
	PULU D
	STD -121,S
	PULU D
	STD 40,S
	PULU D
	STD -2,S
	PULU A
	STA -39,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 120,S
	PULU D
	STD 80,S
	PULU D
	STD 40,S
	PULU D
	STD -40,S
	PULU D
	STD -80,S
	PULU D
	STD -120,S
	PULU A
	STA 42,S
	PULU A
	STA -38,S
	PULU A
	STA -78,S
	PULU A
	STA -118,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 120,S
	PULU D
	STD 80,S
	PULU D
	STD 40,S
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU D
	STD -40,S
	PULU D
	STD -80,S
	PULU D
	STD -120,S
	PULU A
	STA -38,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 120,S
	PULU D
	STD 80,S
	PULU D
	STD 40,S
	PULU A
	STA -79,S
	PULU D
	STD -39,S
ERASE_POS_HWL8_2
	LDS #$0000
	LDU #ERASE_DATA_HWL8_2

ERASE_CODE_HWL8_2
	PULU A,S
	STA 60,S
	PULU A
	STA 20,S
	PULU A
	STA -20,S
	PULU A
	STA -60,S
	PULU A,S
	STA 122,S
	PULU A
	STA 82,S
	PULU A
	STA 42,S
	PULU A
	STA 39,S
	PULU A
	STA -1,S
	PULU D
	STD 1,S
	PULU D
	STD -39,S
	PULU D
	STD -42,S
	PULU D
	STD -79,S
	PULU D
	STD -82,S
	PULU D
	STD -119,S
	PULU D
	STD -122,S
	PULU D,S
	STD 120,S
	PULU D
	STD 41,S
	PULU A
	STA 2,S
	PULU A
	STA -38,S
	PULU A
	STA -78,S
	PULU A
	STA -118,S
	PULU D
	STD 81,S
	PULU D
	STD ,S
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
	PULU A
	STA 82,S
	PULU A
	STA 42,S
	PULU D
	STD 80,S
	PULU D
	STD 40,S
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 80,S
	PULU A
	STA 42,S
	PULU A
	STA 82,S
	PULU D
	STD 40,S
	PULU A
	STA 3,S
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU A
	STA -38,S
	PULU D
	STD -40,S
	PULU A
	STA -78,S
	PULU D
	STD -80,S
	PULU D
	STD -120,S
	PULU D,S
	STD 39,S
	PULU D
	STD -1,S
	PULU D
	STD -41,S
	PULU A
	STA 80,S
	PULU D
	STD 78,S
	PULU D
	STD -81,S
ERASE_SSAV_HWL8
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HWL8_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWL8_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HWL8_END
