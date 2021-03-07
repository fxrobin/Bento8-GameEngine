(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemBack01
	STD DYN_POS+2,PCR
	LEAS ,U
	LDU ,Y
	LEAU -1013,U

	LDA 120,U
	ANDA #$F0
	ORA #$01
	STA 120,U
	LDA 80,U
	ANDA #$F0
	ORA #$0e
	STA 80,U
	LDA #$1d
	STA 40,U
	LDA #$ec
	STA ,U
	LDA #$dc
	STA -40,U
	LDA #$cc
	STA -80,U
	LDA #$c0
	STA -120,U
	LEAU -280,U

	STA 120,U
	LDD 39,U
	ANDA #$F0
	ORA #$01
	LDB #$00
	STD 39,U
	LDD -1,U
	ANDA #$F0
	ORA #$01
	LDB #$00
	STD -1,U
	LDD -41,U
	ANDA #$F0
	ORA #$0e
	LDB #$00
	STD -41,U
	STB 80,U
	LDD #$1d00
	STD -81,U
	STD -121,U
	LEAU -280,U

	LDA #$ec
	STD 119,U
	LDA #$dc
	STD 79,U
	STD 39,U
	LDA #$c0
	STD -1,U
	LDB #$cc
	STD -41,U
	LDD -81,U
	LDA #$cc
	ANDB #$0F
	ORB #$10
	STD -81,U
	LDD -121,U
	LDA #$cd
	ANDB #$F0
	ORB #$01
	STD -121,U
	LEAU -280,U

	LDA #$ed
	STA 80,U
	LDA #$dc
	STA 40,U
	LDA #$cc
	STA ,U
	LDA #$c0
	STA -40,U
	LDD -81,U
	ANDA #$F0
	ORA #$01
	LDB #$00
	STD -81,U
	LDA #$1e
	STA 120,U
	STD -121,U
	LEAU -220,U

	LDA #$ed
	STD 59,U
	LDA #$dc
	STD 19,U
	LDA #$cc
	STD -21,U
	LDA #$c0
	STD -61,U
	LEAU -219,U

	LDA #$00
	STD 118,U
	STD 78,U
	STD 38,U
	LDA 77,U
	ANDA #$F0
	ORA #$01
	STA 77,U
	LDA 37,U
	ANDA #$F0
	ORA #$0e
	STA 37,U
	LDA #$1d
	LDX #$0000
	PSHU A,X
	LEAU -37,U

	LDA #$ec
	PSHU A,X
	LEAU -37,U

	LDA #$dc
	PSHU A,X
	LEAU -37,U

	LDA #$c0
	PSHU A,X
	LEAU -37,U

	PSHU A,X
	LEAU -37,U

	PSHU A,X
	LEAU -37,U

	PSHU B,X
	LEAU -37,U

	LDA -4,U
	ANDA #$F0
	ORA #$01
	STA -4,U
	PSHU B,X
	LEAU -37,U

	LDA -4,U
	ANDA #$F0
	ORA #$0e
	STA -4,U
	PSHU B,X
	LEAU -37,U

	LDA -4,U
	ANDA #$F0
	ORA #$0e
	STA -4,U
	PSHU B,X
	LEAU -37,U

	LDD #$1d00
	LDX #$000c
	PSHU D,X
	LEAU -36,U

	LDD -42,U
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD -42,U
	LDD #$ec00
	STD -44,U
	LDX #$00ce
	PSHU D,X
	LEAU -77,U

	LDA #$dc
	LDX #$00cc
	PSHU A,X
	LEAU -37,U

	LDD #$c00c
	STD -43,U
	LDB #$cd
	STD -83,U
	LDD -123,U
	LDA #$c0
	ANDB #$0F
	ORB #$e0
	STD -123,U
	LDA #$dc
	LDX #$00d1
	PSHU A,X
	LEAU -180,U

	LDA #$cc
	STA 20,U
	LDA #$ce
	STA -20,U
DYN_POS

	LDU #$0000
	LEAU -1173,U

	LDA 120,U
	ANDA #$F0
	ORA #$01
	STA 120,U
	LDA 80,U
	ANDA #$F0
	ORA #$0e
	STA 80,U
	LDA 40,U
	ANDA #$F0
	ORA #$0e
	STA 40,U
	LDA #$1d
	STA ,U
	LDA #$ec
	STA -40,U
	LDA #$dc
	STA -80,U
	STA -120,U
	LEAU -280,U

	LDA #$c0
	STA 120,U
	STA 80,U
	STA 40,U
	LDD -41,U
	ANDA #$F0
	ORA #$01
	LDB #$00
	STD -41,U
	LDD -81,U
	ANDA #$F0
	ORA #$01
	LDB #$00
	STD -81,U
	LDD -121,U
	ANDA #$F0
	ORA #$0e
	LDB #$00
	STD -121,U
	STB ,U
	LEAU -280,U

	LDD 119,U
	ANDA #$F0
	ORA #$0e
	LDB #$0c
	STD 119,U
	LDD #$1dcd
	STD 79,U
	LDD 39,U
	LDA #$1d
	ANDB #$0F
	ORB #$10
	STD 39,U
	LDA #$ee
	STA -1,U
	LDA -80,U
	ANDA #$F0
	ORA #$01
	STA -80,U
	LDA #$1e
	STA -120,U
	LEAU -280,U

	LDA #$ed
	STA 120,U
	LDA #$dc
	STA 80,U
	LDD -41,U
	ANDA #$F0
	ORA #$01
	LDB #$00
	STD -41,U
	LDD -81,U
	ANDA #$F0
	ORA #$0e
	LDB #$00
	STD -81,U
	LDA #$cc
	STA 40,U
	LDA #$c0
	STA ,U
	LDA #$1d
	STD -121,U
	LEAU -220,U

	LDA #$ec
	STD 59,U
	LDA #$dc
	STD 19,U
	LDA #$c0
	STD -21,U
	STD -61,U
	LEAU -219,U

	LDA #$00
	STD 118,U
	STD 78,U
	STD 38,U
	LDA 77,U
	ANDA #$F0
	ORA #$01
	STA 77,U
	LDA 37,U
	ANDA #$F0
	ORA #$0e
	STA 37,U
	LDA #$1d
	LDX #$0000
	PSHU A,X
	LEAU -37,U

	PSHU A,X
	LEAU -37,U

	LDA #$ec
	PSHU A,X
	LEAU -37,U

	LDA #$dc
	PSHU A,X
	LEAU -37,U

	LDA #$c0
	PSHU A,X
	LEAU -37,U

	PSHU A,X
	LEAU -37,U

	PSHU A,X
	LEAU -37,U

	LDX #$000c
	PSHU B,X
	LEAU -37,U

	LDD -42,U
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD -42,U
	LDD -44,U
	ANDA #$F0
	ORA #$01
	LDB #$00
	STD -44,U
	STX -83,U
	LDA -84,U
	ANDA #$F0
	ORA #$01
	STA -84,U
	LDA -124,U
	ANDA #$F0
	ORA #$0e
	STA -124,U
	LDD #$00ce
	STD -123,U
	LDX #$00cd
	PSHU A,X
	LEAU -240,U

	LDD 80,U
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD 80,U
	LDA 79,U
	ANDA #$F0
	ORA #$0e
	STA 79,U
	LDD 39,U
	ANDA #$F0
	ORA #$0e
	LDB #$cc
	STD 39,U
	LDD #$1dd1
	STD -1,U
	STA -41,U
	LDA #$ee
	STA -81,U
	RTS

(info)

