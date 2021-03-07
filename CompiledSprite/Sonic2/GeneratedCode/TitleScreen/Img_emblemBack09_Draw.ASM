(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemBack09
	STD DYN_POS+2,PCR
	LEAS ,U
	LDU ,Y
	LEAU -1108,U

	LDA 120,U
	ANDA #$0F
	ORA #$10
	STA 120,U
	LDA 80,U
	ANDA #$0F
	ORA #$e0
	STA 80,U
	LDA #$d1
	STA 40,U
	STA ,U
	LDA #$ce
	STA -40,U
	LDA #$cd
	STA -80,U
	LDA #$0c
	STA -120,U
	LEAU -280,U

	STA 120,U
	STA 80,U
	LDA #$00
	STA 40,U
	STA ,U
	LDD -40,U
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD -40,U
	LDD -80,U
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD -80,U
	LDD -120,U
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD -120,U
	LEAU -280,U

	LDD #$00d1
	STD 120,U
	LDA #$c0
	STD 80,U
	LDD #$ecce
	STD 40,U
	STB 1,U
	LDA #$1d
	STA -39,U
	LDA -80,U
	ANDA #$0F
	ORA #$10
	STA -80,U
	LDA #$e1
	STA -120,U
	LEAU -280,U

	LDA #$de
	STA 120,U
	LDA #$cd
	STA 80,U
	LDA #$cc
	STA 40,U
	LDA #$0c
	STA ,U
	LDD -40,U
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD -40,U
	LDD -80,U
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD -80,U
	LDD #$00d1
	STD -120,U
	LEAU -219,U

	LDB #$ce
	STD 59,U
	LDB #$cd
	STD 19,U
	LDB #$0c
	STD -21,U
	STD -61,U
	LEAU -218,U

	LDB #$00
	STD 117,U
	LDD 78,U
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD 78,U
	LDD 38,U
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD 38,U
	STA 77,U
	STA 37,U
	LDX #$00d1
	PSHU A,X
	LEAU -37,U

	LDX #$00ce
	PSHU A,X
	LEAU -37,U

	PSHU A,X
	LEAU -37,U

	LDX #$00cd
	PSHU A,X
	LEAU -37,U

	LDX #$000c
	PSHU A,X
	LEAU -37,U

	PSHU A,X
	LEAU -37,U

	LDX #$0000
	PSHU A,X
	LEAU -37,U

	LDD -41,U
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD -41,U
	LDD -81,U
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD -81,U
	LDD -121,U
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD -121,U
	LDD #$c000
	STD -43,U
	LDA #$ec
	STD -83,U
	LDD -123,U
	ANDA #$F0
	ORA #$01
	LDB #$00
	STD -123,U
	PSHU B,X
	LEAU -196,U

	LDD 38,U
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD 38,U
	LDA #$cc
	STA 37,U
	LDD #$c0d1
	STD -42,U
	LDA #$dc
	STD -82,U
	LDD -122,U
	ANDA #$F0
	ORA #$0e
	LDB #$ce
	STD -122,U
	LDA #$1d
	LDX #$00d1
	PSHU A,X
	LEAU -178,U

	STB 20,U
	STA -20,U
DYN_POS

	LDU #$0000
	LEAU -948,U

	LDA 120,U
	ANDA #$0F
	ORA #$10
	STA 120,U
	LDA 80,U
	ANDA #$0F
	ORA #$e0
	STA 80,U
	LDA #$d1
	STA 40,U
	LDA #$ce
	STA ,U
	LDA #$cd
	STA -40,U
	LDA #$cc
	STA -80,U
	LDA #$0c
	STA -120,U
	LEAU -280,U

	STA 120,U
	LDA #$00
	STA 80,U
	LDD 40,U
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD 40,U
	LDD ,U
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD ,U
	LDD -40,U
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD -40,U
	LDD #$00d1
	STD -80,U
	LDB #$ce
	STD -120,U
	LEAU -279,U

	STD 119,U
	LDB #$cd
	STD 79,U
	LDB #$0c
	STD 39,U
	STD -1,U
	LDA #$c0
	STD -41,U
	LDA #$dc
	STD -81,U
	LDD -121,U
	ANDA #$0F
	ORA #$10
	LDB #$c0
	STD -121,U
	LEAU -280,U

	LDD 119,U
	ANDA #$0F
	ORA #$e0
	LDB #$ec
	STD 119,U
	LDA #$d1
	STA 79,U
	LDA #$ce
	STA 39,U
	LDA #$cd
	STA -1,U
	LDD -81,U
	LDA #$0c
	ANDB #$0F
	ORB #$10
	STD -81,U
	STA -41,U
	LDD #$00e1
	STD -121,U
	LEAU -220,U

	LDB #$de
	STD 59,U
	LDB #$cd
	STD 19,U
	LDB #$cc
	STD -21,U
	LDB #$0c
	STD -61,U
	LEAU -218,U

	LDB #$00
	STD 117,U
	LDD 78,U
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD 78,U
	LDD 38,U
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD 38,U
	STA 77,U
	STA 37,U
	LDX #$00d1
	PSHU A,X
	LEAU -37,U

	LDX #$00ce
	PSHU A,X
	LEAU -37,U

	LDX #$00cd
	PSHU A,X
	LEAU -37,U

	LDX #$000c
	PSHU A,X
	LEAU -37,U

	PSHU A,X
	LEAU -37,U

	LDX #$0000
	PSHU A,X
	LEAU -37,U

	LDD -41,U
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD -41,U
	LDD -81,U
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD -81,U
	STX -43,U
	STX -83,U
	PSHU A,X
	LEAU -116,U

	LDY #$00d1
	PSHU X,Y
	LEAU -36,U

	PSHU X,Y
	LEAU -36,U

	LDD #$cc00
	LDX #$00ce
	PSHU D,X
	LEAU -36,U

	LDA #$1d
	LDX #$00cd
	PSHU D,X
	LEAU -36,U

	LDA #$c0
	PSHU A,X
	LEAU -37,U

	LDB #$0c
	STD -82,U
	LDA #$00
	STD -42,U
	LDA #$ec
	STD -122,U
	LDA -43,U
	ANDA #$F0
	ORA #$0e
	STA -43,U
	LDA #$dc
	LDX #$000c
	PSHU A,X
	LEAU -198,U

	LDD 39,U
	ANDA #$F0
	ORA #$01
	LDB #$00
	STD 39,U
	LDA #$cc
	STA ,U
	LDA #$1d
	STA -40,U
	RTS

(info)

