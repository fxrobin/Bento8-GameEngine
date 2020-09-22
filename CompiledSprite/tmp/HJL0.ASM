(main)IMG.ASM
	ORG $A6B9
DRAW_HJL0
	PSHS U,DP
	STS SSAV_HJL0+2

	LDS $9F00
	STS ERASE_POS_HJL0_1+2
	LDU #ERASE_DATA_HJL0_2
	LEAS 543,S

	LDD 19,S
	PSHU D,S

	LDA -20,S
	PSHU A

	LDD #$cccd
	STD 19,S

	STA -20,S

	LEAS 179,S

	LDD -40,S
	PSHU D

	LDA -38,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA -38,S

	LDA -78,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA -78,S

	LDD -80,S
	PSHU D

	LDD -120,S
	PSHU D

	LDD #$cccc
	STD -120,S

	STD -80,S

	STD -40,S

	PULS A,X
	PSHU A,X,S

	LDX #$ccdd
	PSHS B,X

	LEAS 40,S

	LDD 121,S
	PSHU D

	LDD 79,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$ac
	STD 79,S

	LDD 119,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$ba
	STD 119,S

	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD #$cccd
	STD 121,S

	STX 41,S

	LDD 39,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$ac
	STD 39,S

	STX 81,S

	PULS A,X
	PSHU A,X,S

	LDX #$ccdd
	PSHS B,X

	LEAS 199,S

	LDD -38,S
	PSHU D

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$ba
	STD -40,S

	LDD #$cccd
	STD -38,S

	PULS D,X
	PSHU D,X,S

	LDD #$ccba
	LDX #$cccd
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$ccac
	LDX #$cccd
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$ccac
	LDX #$cccd
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$ccac
	LDX #$cccd
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$cccc
	LDX #$cccd
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$cccc
	LDX #$cccd
	PSHS D,X

	LEAS 40,S

	PULS D,X
	PSHU D,X,S

	LDD #$cccc
	LDX #$ccdd
	PSHS D,X

	LEAS 40,S

	LDD 42,S
	PSHU D

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD 40,S

	STX 42,S

	LDD 80,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD 80,S

	LDD 82,S
	PSHU D

	STX 82,S

	LDD 120,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 120,S

	LDD 122,S
	PSHU D

	STX 122,S

	PULS D,X
	PSHU D,X,S

	LDD #$cccc
	LDX #$ccdd
	PSHS D,X

	LEAS 241,S

	LDD 120,S
	PSHU D

	LDD -39,S
	PSHU D

	LDD -81,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -81,S

	LDD 80,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD -79,S
	PSHU D

	STX -79,S

	LDD -41,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -41,S

	LDA 82,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 82,S

	STX -39,S

	LDA 42,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 42,S

	LDD #$dcdd
	STD 40,S

	LDA #$dd
	STD 80,S

	STD 120,S

	PULS A,X
	PSHU A,X,S

	LDA #$cc
	LDX #$cddd
	PSHS A,X

	LEAS 181,S

	LDD -21,S
	PSHU D,S

	LDA 20,S
	PSHU A

	LDD #$dddd
	STD -21,S

	STA 20,S


	LDS $9F00+2
	STS ERASE_POS_HJL0_2+2
	LDU #ERASE_DATA_HJL0_END

	LEAS 522,S

	LDA ,S
	PSHU A,S

	LDA #$cc
	STA ,S

	LEAS 159,S

	LDD -119,S
	PSHU D

	LDA #$cc
	ANDB #$0F
	ORB #$c0
	STD -119,S

	LDA -38,S
	PSHU A

	LDD -79,S
	PSHU D

	LDD #$ccdd
	STD -79,S

	STB -38,S

	LDD -40,S
	PSHU D

	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -40,S

	PULS A,X
	PSHU A,X,S

	LDX #$cccd
	PSHS B,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDX #$cccd
	PSHS B,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDX #$cccc
	PSHS B,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDX #$cccc
	PSHS B,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDX #$cccc
	PSHS B,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$ca
	LDX #$cccc
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$aa
	LDX #$accc
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDA #$ca
	LDX #$cccc
	PSHS A,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDX #$cccc
	PSHS B,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDX #$cccc
	PSHS B,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDX #$cccc
	PSHS B,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDX #$cccc
	PSHS B,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDX #$cccc
	PSHS B,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDX #$cccc
	PSHS B,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDX #$cccc
	PSHS B,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDX #$cccc
	PSHS B,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDX #$cccd
	PSHS B,X

	LEAS 40,S

	LDA 3,S
	PSHU A

	ANDA #$0F
	ORA #$d0
	STA 3,S

	PULS A,X
	PSHU A,X,S

	LDX #$cccd
	PSHS B,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDX #$ccdd
	PSHS B,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$dc
	LDX #$ccdd
	PSHS A,X

	LEAS 40,S

	PULS A,X
	PSHU A,X,S

	LDA #$dd
	LDX #$ccdd
	PSHS A,X

	LEAS 40,S

	LDD 81,S
	PSHU D

	LDA 42,S
	PSHU A

	LDD 121,S
	PSHU D

	LDA #$dd
	ANDB #$0F
	ORB #$d0
	STD 121,S

	STA 42,S

	LDD 40,S
	PSHU D

	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 40,S

	LDD #$dddd
	STD 81,S

	PULS A,X
	PSHU A,X,S

	LDX #$ccdd
	PSHS B,X

	LEAS 161,S

	LDA ,S
	PSHU A,S

	STB ,S

SSAV_HJL0
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HJL0
	PSHS U,DP
	STS ERASE_SSAV_HJL0+2

ERASE_POS_HJL0_1
	LDS #$0000
	LDU #ERASE_DATA_HJL0_1

ERASE_CODE_HJL0_1
	PULU A,X,S
	STA 20,S
	STX -21,S

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA 42,S
	STB 82,S
	STX -41,S
	STY -79,S

	PULU D,X,Y
	STD 40,S
	STX 80,S
	STY -81,S

	PULU D,X
	STD -39,S
	STX 120,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 122,S
	STX 120,S
	STY 82,S

	PULU D,X,Y
	STD 80,S
	STX 40,S
	STY 42,S

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

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD -40,S
	STX -38,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 39,S
	STX 81,S
	STY 41,S

	PULU D,X,Y
	STD 119,S
	STX 79,S
	STY 121,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD -120,S
	STX -80,S

	PULU A,B,X
	STA -78,S
	STB -38,S
	STX -40,S

	PULU A,X,S
	STA -20,S
	STX 19,S

ERASE_POS_HJL0_2
	LDS #$0000
	LDU #ERASE_DATA_HJL0_2

ERASE_CODE_HJL0_2
	PULU A,S
	STA ,S

	PULU B,X,S
	PSHS B,X

	PULU D,X
	STD 40,S
	STX 121,S

	PULU A,X
	STA 42,S
	STX 81,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU A
	STA 3,S

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
	STX -79,S

	PULU A,X
	STA -38,S
	STX -119,S

	PULU A,S
	STA ,S

ERASE_SSAV_HJL0
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HJL0_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJL0_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
ERASE_DATA_HJL0_END
