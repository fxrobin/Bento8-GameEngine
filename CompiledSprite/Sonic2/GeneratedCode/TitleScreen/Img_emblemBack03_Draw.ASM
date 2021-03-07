(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemBack03
	STD DYN_POS+2,PCR
	LEAS ,U
	LDU ,Y
	LEAU 49,U

	LDA 60,U
	ANDA #$F0
	ORA #$01
	STA 60,U
	LDA 20,U
	ANDA #$F0
	ORA #$0e
	STA 20,U
	LDA #$1d
	STA -20,U
	LDA #$ec
	STA -60,U
	LEAU -217,U

	LDD 117,U
	LDA #$dc
	ANDB #$0F
	ORB #$00
	STD 117,U
	LDD #$c000
	STD 77,U
	LDA #$00
	STD 37,U
	LDA -4,U
	ANDA #$F0
	ORA #$01
	STA -4,U
	LDX #$000c
	PSHU B,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0e
	STA -5,U
	LDD #$0000
	LDX #$0c88
	PSHU D,X
	LEAU -35,U

	LDA #$1d
	LDX #$000c
	LDY #$8888
	PSHU D,X,Y
	LEAU -32,U

	LDA #$ec
	STD -8,U
	LDD #$000c
	LDX #$8888
	LDY #$d999
	PSHU D,X,Y
	LEAU -34,U

	LDD #$dc00
	STD -8,U
	LDD #$000c
	PSHU D,X,Y
	LEAU -34,U

	LDD #$c000
	STD -8,U
	LDD #$000c
	PSHU D,X,Y
	LEAU -34,U

	LDD #$c0c1
	STD -8,U
	LDD #$cc0c
	PSHU D,X,Y
	LEAU -34,U

	LDB #$1e
	STD -8,U
	LDD #$c00c
	PSHU D,X,Y
	LEAU -34,U

	LDD #$d11d
	STD -8,U
	LDD #$000c
	PSHU D,X,Y
	LEAU -34,U

	LDA #$ec
	STA -7,U
	LDA #$00
	PSHU D,X,Y
	LEAU -34,U

	LDA #$dc
	STA -7,U
	LDA #$00
	LDX #$8818
	PSHU D,X,Y
	LEAU -34,U

	LDD -8,U
	ANDA #$F0
	ORA #$01
	LDB #$c0
	STD -8,U
	LDD #$000c
	LDX #$88c8
	PSHU D,X,Y
	LEAU -34,U

	LDD -8,U
	ANDA #$F0
	ORA #$0e
	LDB #$00
	STD -8,U
	LDD #$000c
	PSHU D,X,Y
	LEAU -34,U

	LDD #$1d00
	STD -8,U
	LDD #$000c
	LDX #$88e8
	PSHU D,X,Y
	LEAU -34,U

	LDD #$ec00
	STD -8,U
	LDD #$000c
	LDX #$81c1
	PSHU D,X,Y
	LEAU -34,U

	LDD #$dc00
	STD -8,U
	LDD #$000c
	LDX #$8888
	PSHU D,X,Y
	LEAU -34,U

	LDD #$c000
	STD -8,U
	LDD #$000c
	LDY #$de99
	PSHU D,X,Y
	LEAU -34,U

	LDD #$c000
	STD -8,U
	LDD #$000c
	PSHU D,X,Y
	LEAU -34,U

	LDB #$00
	STD -8,U
	LDX #$6888
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$7888
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDY #$ed99
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$e888
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDY #$cd99
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$e688
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$e788
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$d788
	LDY #$8e99
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$de88
	LDY #$8c99
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$dd88
	LDY #$8899
	PSHU D,X,Y
DYN_POS

	LDU #$0000
	LEAU 70,U

	LDA 40,U
	ANDA #$0F
	ORA #$e0
	STA 40,U
	LDA ,U
	ANDA #$0F
	ORA #$d0
	STA ,U
	LDA -40,U
	ANDA #$0F
	ORA #$c0
	STA -40,U
	LEAU -198,U

	LDD 117,U
	ANDA #$F0
	ORA #$01
	LDB #$c0
	STD 117,U
	LDD 77,U
	ANDA #$F0
	ORA #$0e
	LDB #$00
	STD 77,U
	LDD #$1d00
	STD 37,U
	LDA #$dc
	STD -43,U
	LDD -41,U
	LDA #$00
	ANDB #$0F
	ORB #$d0
	STD -41,U
	LDA #$ec
	LDX #$0000
	PSHU A,X
	LEAU -75,U

	LDA #$c0
	LDY #$de88
	PSHU A,X,Y
	LEAU -34,U

	LDD #$c000
	LDX #$00de
	LDY #$888e
	PSHU D,X,Y
	LEAU -33,U

	STB -7,U
	LDA #$00
	LDX #$de88
	LDY #$8e99
	PSHU D,X,Y
	LEAU -34,U

	LDD -8,U
	ANDA #$F0
	ORA #$01
	LDB #$00
	STD -8,U
	LDD #$0000
	PSHU D,X,Y
	LEAU -34,U

	LDD -8,U
	ANDA #$F0
	ORA #$0e
	LDB #$00
	STD -8,U
	LDD #$0000
	PSHU D,X,Y
	LEAU -34,U

	LDD -8,U
	ANDA #$F0
	ORA #$0e
	LDB #$0c
	STD -8,U
	LDD #$ed00
	PSHU D,X,Y
	LEAU -34,U

	LDD #$1dce
	STD -8,U
	LDD #$dc00
	PSHU D,X,Y
	LEAU -34,U

	LDA #$ec
	STA -8,U
	LDA #$cc
	PSHU D,X,Y
	LEAU -34,U

	LDA -7,U
	ANDA #$F0
	ORA #$01
	STA -7,U
	LDD #$c000
	PSHU D,X,Y
	LEAU -34,U

	LDA #$1e
	STA -7,U
	LDA #$00
	LDX #$de18
	PSHU D,X,Y
	LEAU -34,U

	LDA #$ed
	STA -7,U
	LDA #$00
	LDX #$dec8
	PSHU D,X,Y
	LEAU -34,U

	LDA #$dc
	STA -7,U
	LDA #$00
	LDX #$dec1
	PSHU D,X,Y
	LEAU -34,U

	LDA #$cc
	STA -7,U
	LDA #$00
	LDX #$deee
	PSHU D,X,Y
	LEAU -34,U

	LDD -8,U
	ANDA #$F0
	ORA #$01
	LDB #$c0
	STD -8,U
	LDD #$0000
	LDX #$dece
	PSHU D,X,Y
	LEAU -34,U

	LDD -8,U
	ANDA #$F0
	ORA #$0e
	LDB #$00
	STD -8,U
	LDD #$0000
	LDX #$de8e
	PSHU D,X,Y
	LEAU -34,U

	LDA #$1d
	STD -8,U
	LDA #$00
	PSHU D,X,Y
	LEAU -34,U

	LDA #$ec
	STD -8,U
	LDA #$00
	LDX #$de8c
	LDY #$8c99
	PSHU D,X,Y
	LEAU -34,U

	LDA #$dc
	STD -8,U
	LDA #$00
	LDX #$ed88
	PSHU D,X,Y
	LEAU -34,U

	LDA #$cc
	STD -8,U
	LDA #$00
	PSHU D,X,Y
	LEAU -34,U

	LDA #$c0
	STD -8,U
	LDA #$00
	PSHU D,X,Y
	LEAU -34,U

	LDA #$c0
	STD -8,U
	LDA #$00
	LDY #$8899
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$cd88
	LDY #$88e9
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDY #$88d9
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$0e88
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDY #$88de
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$0c68
	LDY #$88dd
	PSHU D,X,Y
	LEAU -34,U

	STD -8,U
	LDX #$0c78
	LDY #$88ed
	PSHU D,X,Y
	RTS

(info)

