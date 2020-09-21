(main)IMG.ASM
	ORG $C8DE
DRAW_HJL4
	PSHS U,DP
	STS SSAV_HJL4+2

	LDS $9F00
	STS ERASE_POS_HJL4_1+2
	LDU #ERASE_DATA_HJL4_2
	LEAS 643,S
	LDA -121,S
	PSHU A
	ANDA #$F0
	ORA #$0a
	STA -121,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$0c0a
	STD -81,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ac
	STD 38,S

	LDD 78,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ac
	STD 78,S

	LDD 118,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ac
	STD 118,S

	LDD 120,S
	PSHU D
	LDA #$cd
	ANDB #$0F
	ORB #$d0
	STD 120,S

	LDD -41,S
	PSHU D

	LDD -1,S
	PSHU D

	LDA 40,S
	PSHU A

	LDD 80,S
	PSHU D,S

	LDD #$accc
	STD -1,S

	LDB #$ac
	STD -41,S

	LDD #$cdcd
	STD 80,S

	STA 40,S

	LEAS 279,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ac
	STD -121,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ac
	STD -81,S

	LDD -79,S
	PSHU D
	LDA #$dd
	ANDB #$F0
	ORB #$0d
	STD -79,S

	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ba
	STD -41,S

	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ba
	STD -1,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ba
	STD 39,S

	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ac
	STD 79,S

	LDD 119,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ac
	STD 119,S

	LDA -119,S
	PSHU A

	LDD -39,S
	PSHU D

	LDD 1,S
	PSHU D

	LDD 41,S
	PSHU D,S

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDD #$ad90
	STD 81,S

	LDD #$dddd
	STD -39,S

	STD 1,S

	STA -119,S

	LDA #$cd
	STD 41,S

	LDB #$9e
	STD 121,S

	LEAS 180,S
	LDD -21,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$ac
	STD -21,S

	LDD 19,S
	PSHU D,S
	ANDA #$F0
	ORA #$0a
	LDB #$cc
	STD 19,S

	LDD -19,S
	PSHU D

	LDD 21,S
	PSHU D

	LDD #$2dae
	STD 21,S

	LDA #$3d
	STD -19,S

	LEAS 180,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -121,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ORA #$03
	LDB #$cc
	STD -81,S

	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cd
	STD -41,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$9a
	STD 39,S

	LDD -119,S
	PSHU D

	LDD -79,S
	PSHU D

	LDD -39,S
	PSHU D

	LDD 41,S
	PSHU D

	LDD #$23ae
	STD -119,S

	LDD #$c1aa
	STD -79,S

	LDD #$a99a
	STD -39,S

	LDD #$2af1
	STD 41,S

	PULS A,X
	PSHU A,X,S
	LDA #$da
	LDX #$3a1a
	PSHS A,X

	LEAS 80,S
	PULS A,X
	PSHU A,X,S
	LDA #$ca
	LDX #$2af1
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	LDA #$cc
	ANDB #$F0
	ORB #$09
	STD 40,S

	LDD 80,S
	PSHU D
	LDA #$dc
	ANDB #$F0
	ORB #$0a
	STD 80,S

	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 82,S

	LDA 122,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 122,S

	LDA 42,S
	PSHU A

	LDA #$1e
	STA 42,S

	PULS A,X
	PSHU A,X,S
	LDA #$ca
	LDX #$1a11
	PSHS A,X

	LEAS 181,S
	LDA -20,S
	PSHU A,S
	ANDA #$F0
	ORA #$0f
	STA -20,S

	LDA 20,S
	PSHU A

	LDA #$f1
	STA 20,S


	LDS $9F00+2
	STS ERASE_POS_HJL4_2+2
	LDU #ERASE_DATA_HJL4_END

	LEAS 562,S
	LDA -40,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -40,S

	LDD ,S
	PSHU D
	ANDA #$0F
	ORA #$c0
	LDB #$cd
	STD ,S

	LDD 39,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$a0d0
	STD 39,S

	LDA 41,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 41,S

	LDA 80,S
	PSHU A,S
	ANDA #$0F
	ORA #$d0
	STA 80,S

	LDA -80,S
	PSHU A

	LDA #$aa
	STA -80,S

	LEAS 239,S
	LDD -80,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$dc
	STD -80,S

	LDA -38,S
	PSHU A
	ANDA #$F0
	ORA #$0c
	STA -38,S

	LDA -119,S
	PSHU A

	LDD -40,S
	PSHU D

	LDA #$da
	STA -119,S

	LDD #$cadc
	STD -40,S

	PULS A,X
	PSHU A,X,S
	LDA #$ca
	LDX #$accd
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$ca
	LDX #$acdd
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
	LDX #$ccda
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
	LDX #$ccac
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
	LDX #$cacc
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
	LDX #$ccdc
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$ca
	LDX #$ccd3
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$ccdc
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$c2d0
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$c290
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$c3aa
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$dcaa
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$ada9
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$aaa0
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$03
	STD 40,S

	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$90
	STA 42,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$9a
	STD 80,S

	LDD 121,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$090f
	STD 121,S

	LDA 82,S
	PSHU A

	LDA #$0f
	STA 82,S

	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$aaa0
	PSHS A,X

	LEAS 202,S
	LDD -41,S
	PSHU D,S
	ANDA #$F0
	ORA #$00
	LDB #$f1
	STD -41,S

	LDA 40,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 40,S

	LDA ,S
	PSHU A

	LDA #$2e
	STA ,S

SSAV_HJL4
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HJL4
	PSHS U,DP
	STS ERASE_SSAV_HJL4+2

ERASE_POS_HJL4_1
	LDS #$0000
	LDU #ERASE_DATA_HJL4_1

ERASE_CODE_HJL4_1
	PULU A,B,S
	STA 20,S
	STB -20,S

	PULU B,X,S
	PSHS B,X

	PULU A,B
	STA 42,S
	STB 122,S

	PULU A,X,Y
	STA 82,S
	STX 80,S
	STY 40,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 41,S
	STX -39,S
	STY -79,S

	PULU D,X,Y
	STD -119,S
	STX 39,S
	STY -41,S

	PULU D,X
	STD -81,S
	STX -121,S

	PULU D,X,Y,S
	STD 21,S
	STX -19,S
	STY 19,S

	PULU D
	STD -21,S

	PULU D,X,Y,S
	STD 121,S
	STX 81,S
	STY 41,S

	PULU D,X
	STD 1,S
	STX -39,S

	PULU A,X,Y
	STA -119,S
	STX 119,S
	STY 79,S

	PULU D,X,Y
	STD 39,S
	STX -1,S
	STY -41,S

	PULU D,X,Y
	STD -79,S
	STX -81,S
	STY -121,S

	PULU D,S
	STD 80,S

	PULU A,X,Y
	STA 40,S
	STX -1,S
	STY -41,S

	PULU D,X,Y
	STD 120,S
	STX 118,S
	STY 78,S

	PULU D,X
	STD 38,S
	STX -81,S

	PULU A
	STA -121,S

ERASE_POS_HJL4_2
	LDS #$0000
	LDU #ERASE_DATA_HJL4_2

ERASE_CODE_HJL4_2
	PULU A,B,X,S
	STA ,S
	STB 40,S
	STX -41,S

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA 82,S
	STX 121,S
	STY 80,S

	PULU A,X
	STA 42,S
	STX 40,S

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

	PULU D
	STD -40,S

	PULU A,B,X
	STA -119,S
	STB -38,S
	STX -80,S

	PULU A,B,S
	STA -80,S
	STB 80,S

	PULU A,X,Y
	STA 41,S
	STX 39,S
	STY ,S

	PULU A
	STA -40,S

ERASE_SSAV_HJL4
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HJL4_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJL4_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
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
ERASE_DATA_HJL4_END
