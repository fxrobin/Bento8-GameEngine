(main)IMG.ASM
	ORG $CA4D
DRAW_HJL2
	PSHS U,DP
	STS SSAV_HJL2+2

	LDS $9F00
	STS ERASE_POS_HJL2_1+2
	LDU #ERASE_DATA_HJL2_2
	LEAS 604,S
	LDA ,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA ,S

	LDA 40,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 40,S

	LDA 80,S
	PSHU A
	ANDA #$F0
	ORA #$0c
	STA 80,S

	LDA -81,S
	PSHU A

	LDA -41,S
	PSHU A

	LDD -2,S
	PSHU D

	LDD 38,S
	PSHU D

	LDD 78,S
	PSHU D,S

	LDD #$dacc
	STD -2,S

	LDD #$aacd
	STD 38,S

	STD 78,S

	STA -81,S

	STA -41,S

	LEAS 238,S
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

	LDD #$accc
	STD -80,S

	LDD #$dccd
	STD -40,S

	LDA #$aa
	STD -120,S

	PULS A,X
	PSHU A,X,S
	LDA #$ad
	LDX #$cccc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ba
	LDX #$cddc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ba
	LDX #$ccdd
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ba
	LDX #$cddd
	PSHS A,X

	LEAS 40,S
	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 82,S

	LDA 122,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 122,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$bccd
	STD 80,S

	LDD #$23dd
	STD 120,S

	LDA #$ba
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$ba
	LDX #$ccdd
	PSHS A,X

	LEAS 160,S
	PULS A,X
	PSHU A,X,S
	LDA #$2a
	LDX #$dddc
	PSHS A,X

	LEAS 40,S
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$a9
	STD 39,S

	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$bb
	STD 79,S

	LDD 81,S
	PSHU D
	LDA #$dd
	ANDB #$F0
	ORB #$0d
	STD 81,S

	LDD 119,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$aa
	STD 119,S

	LDD 121,S
	PSHU D
	LDA #$dd
	ANDB #$F0
	ORB #$0d
	STD 121,S

	LDD 41,S
	PSHU D

	LDD #$dddd
	STD 41,S

	PULS A,X
	PSHU A,X,S
	LDA #$ba
	LDX #$dddd
	PSHS A,X

	LEAS 280,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$aa
	STD -121,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$99
	STD -81,S

	LDD -41,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$010a
	STD -41,S

	LDA -119,S
	PSHU A

	LDA -79,S
	PSHU A

	LDA -39,S
	PSHU A

	LDD ,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D,S

	LDA #$9c
	STA -39,S

	LDD #$1a9d
	STD 40,S

	LDB #$dd
	STD 80,S

	LDD #$f90d
	STD ,S

	LDA #$cc
	STA -119,S

	STA -79,S

	LDA #$99
	STD 120,S

	LEAS 181,S
	LDA 20,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 20,S

	LDD -21,S
	PSHU D,S

	LDD #$e0ed
	STD -21,S


	LDS $9F00+2
	STS ERASE_POS_HJL2_2+2
	LDU #ERASE_DATA_HJL2_END

	LEAS 602,S
	LDA -80,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA -80,S

	LDD -40,S
	PSHU D

	LDD ,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D,S

	LDD #$aaaa
	STD -40,S

	LDD #$cccc
	STD ,S

	LDD #$dddd
	STD 80,S

	LDA #$dc
	STD 40,S

	LEAS 239,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$dd
	STD -120,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$dd
	STD -80,S

	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA -78,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$dd
	STD -40,S

	LDA -118,S
	PSHU A

	LDA -38,S
	PSHU A

	STB -118,S

	LDA #$cc
	STA -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$ccdc
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ac
	LDX #$ccdd
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$ccdd
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 3,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$cc
	STD 40,S

	LDD 42,S
	PSHU D
	LDA #$dd
	ANDB #$0F
	ORB #$d0
	STD 42,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$cc
	STD 80,S

	LDD 82,S
	PSHU D
	LDA #$dd
	ANDB #$0F
	ORB #$d0
	STD 82,S

	PULS A,X
	PSHU A,X,S
	LDA #$da
	LDX #$ccdd
	PSHS A,X

	LEAS 120,S
	PULS A,X
	PSHU A,X,S
	LDA #$92
	LDX #$3cdd
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$21
	STD 40,S

	LDA 42,S
	PSHU A

	LDA #$dd
	STA 42,S

	PULS A,X
	PSHU A,X,S
	LDA #$02
	LDX #$23dd
	PSHS A,X

	LEAS 80,S
	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$3ddd
	PSHS A,X

	LEAS 40,S
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 42,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$9d
	STD 80,S

	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 82,S

	LDD 40,S
	PSHU D

	LDD #$9aac
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$9b
	LDX #$1ddd
	PSHS A,X

	LEAS 120,S
	LDD 40,S
	PSHU D
	ANDA #$0F
	ORA #$20
	LDB #$0c
	STD 40,S

	LDA 42,S
	PSHU A

	LDA #$dd
	STA 42,S

	PULS A,X
	PSHU A,X,S
	LDA #$f9
	LDX #$d3dd
	PSHS A,X

	LEAS 80,S
	LDA 42,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA 42,S

	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 82,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$e0
	STD 120,S

	LDA 122,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 122,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$1fa9
	STD 40,S

	LDD #$e19a
	STD 80,S

	PULS A,X
	PSHU A,X,S
	LDA #$ff
	LDX #$dadd
	PSHS A,X

	LEAS 201,S
	LDD -40,S
	PSHU D
	LDA #$1e
	ANDB #$0F
	ORB #$d0
	STD -40,S

	LDA ,S
	PSHU A

	LDA 40,S
	PSHU A,S

	LDA #$ee
	STA ,S

	LDA #$00
	STA 40,S

SSAV_HJL2
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HJL2
	PSHS U,DP
	STS ERASE_SSAV_HJL2+2

ERASE_POS_HJL2_1
	LDS #$0000
	LDU #ERASE_DATA_HJL2_1

ERASE_CODE_HJL2_1
	PULU D,S
	STD -21,S
	PULU A
	STA 20,S
	PULU D,S
	STD 120,S
	PULU D
	STD 80,S
	PULU D
	STD 40,S
	PULU D
	STD ,S
	PULU A
	STA -39,S
	PULU A
	STA -79,S
	PULU A
	STA -119,S
	PULU D
	STD -41,S
	PULU D
	STD -81,S
	PULU D
	STD -121,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 41,S
	PULU D
	STD 121,S
	PULU D
	STD 119,S
	PULU D
	STD 81,S
	PULU D
	STD 79,S
	PULU D
	STD 39,S
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 120,S
	PULU D
	STD 80,S
	PULU D
	STD 40,S
	PULU A
	STA 122,S
	PULU A
	STA 82,S
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
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
	PULU D,S
	STD 78,S
	PULU D
	STD 38,S
	PULU D
	STD -2,S
	PULU A
	STA -41,S
	PULU A
	STA -81,S
	PULU A
	STA 80,S
	PULU A
	STA 40,S
	PULU A
	STA ,S
ERASE_POS_HJL2_2
	LDS #$0000
	LDU #ERASE_DATA_HJL2_2

ERASE_CODE_HJL2_2
	PULU A,S
	STA 40,S
	PULU A
	STA ,S
	PULU D
	STD -40,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 80,S
	PULU D
	STD 40,S
	PULU A
	STA 122,S
	PULU D
	STD 120,S
	PULU A
	STA 82,S
	PULU A
	STA 42,S
	PULU A,X,S
	PSHS A,X
	PULU A
	STA 42,S
	PULU D
	STD 40,S
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 40,S
	PULU A
	STA 82,S
	PULU D
	STD 80,S
	PULU A
	STA 42,S
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU A
	STA 42,S
	PULU D
	STD 40,S
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU D
	STD 82,S
	PULU D
	STD 80,S
	PULU D
	STD 42,S
	PULU D
	STD 40,S
	PULU A
	STA 3,S
	PULU A,X,S
	PSHS A,X
	PULU A
	STA 3,S
	PULU A,X,S
	PSHS A,X
	PULU A,X,S
	PSHS A,X
	PULU A
	STA -38,S
	PULU A
	STA -118,S
	PULU D
	STD -40,S
	PULU A
	STA -78,S
	PULU D
	STD -80,S
	PULU D
	STD -120,S
	PULU D,S
	STD 80,S
	PULU D
	STD 40,S
	PULU D
	STD ,S
	PULU D
	STD -40,S
	PULU A
	STA -80,S
ERASE_SSAV_HJL2
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HJL2_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJL2_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJL2_END
