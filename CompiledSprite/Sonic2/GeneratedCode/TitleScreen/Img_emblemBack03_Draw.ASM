(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemBack03
	STS SSAV_Img_emblemBack03+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS 49,S

	LDA 60,S
	ANDA #$F0
	ORA #$01
	STA 60,S
	LDA 20,S
	ANDA #$F0
	ORA #$0e
	STA 20,S
	LDA #$1d
	STA -20,S
	LDA #$ec
	STA -60,S
	LEAS -217,S

	LDD 117,S
	LDA #$dc
	ANDB #$0F
	ORB #$00
	STD 117,S
	LDD #$c000
	STD 77,S
	LDA #$00
	STD 37,S
	LDA -4,S
	ANDA #$F0
	ORA #$01
	STA -4,S
	LDX #$000c
	PSHS B,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$0e
	STA -5,S
	LDD #$0000
	LDX #$0c88
	PSHS D,X
	LEAS -35,S

	LDA #$1d
	LDX #$000c
	LDU #$8888
	PSHS D,X,U
	LEAS -32,S

	LDA #$ec
	STA -8,S
	LDY #$8888
	LDU #$d999
	PSHS B,X,Y,U
	LEAS -33,S

	LDA #$dc
	STA -8,S
	PSHS B,X,Y,U
	LEAS -33,S

	LDA #$c0
	STA -8,S
	PSHS B,X,Y,U
	LEAS -33,S

	STA -8,S
	LDA #$c1
	LDX #$cc0c
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$cc
	STA -8,S
	LDA #$1e
	LDX #$c00c
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$d1
	STA -8,S
	LDA #$1d
	LDX #$000c
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ec
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$dc
	LDY #$8818
	PSHS A,X,Y,U
	LEAS -33,S

	LDA -8,S
	ANDA #$F0
	ORA #$01
	STA -8,S
	LDA #$c0
	LDY #$88c8
	PSHS A,X,Y,U
	LEAS -33,S

	LDA -8,S
	ANDA #$F0
	ORA #$0e
	STA -8,S
	PSHS B,X,Y,U
	LEAS -33,S

	LDA #$1d
	STA -8,S
	LDY #$88e8
	PSHS B,X,Y,U
	LEAS -33,S

	LDA #$ec
	STA -8,S
	LDY #$81c1
	PSHS B,X,Y,U
	LEAS -33,S

	LDA #$dc
	STA -8,S
	LDY #$8888
	PSHS B,X,Y,U
	LEAS -33,S

	LDA #$c0
	STA -8,S
	LDU #$de99
	PSHS B,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	LDX #$0000
	LDY #$6888
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	LDY #$7888
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	LDU #$ed99
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	LDY #$e888
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	LDU #$cd99
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	LDY #$e688
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	LDY #$e788
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	LDY #$d788
	LDU #$8e99
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	LDY #$de88
	LDU #$8c99
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	LDY #$dd88
	LDU #$8899
	PSHS B,X,Y,U
DYN_POS

	LDS #$0000
	LEAS 70,S

	LDA 40,S
	ANDA #$0F
	ORA #$e0
	STA 40,S
	LDA ,S
	ANDA #$0F
	ORA #$d0
	STA ,S
	LDA -40,S
	ANDA #$0F
	ORA #$c0
	STA -40,S
	LEAS -198,S

	LDD 117,S
	ANDA #$F0
	ORA #$01
	LDB #$c0
	STD 117,S
	LDD 77,S
	ANDA #$F0
	ORA #$0e
	LDB #$00
	STD 77,S
	LDD #$1d00
	STD 37,S
	LDA #$dc
	STD -43,S
	LDD -41,S
	LDA #$00
	ANDB #$0F
	ORB #$d0
	STD -41,S
	LDA #$ec
	LDX #$0000
	PSHS A,X
	LEAS -75,S

	LDA #$c0
	LDU #$de88
	PSHS A,X,U
	LEAS -34,S

	LDD #$c000
	LDX #$00de
	LDU #$888e
	PSHS D,X,U
	LEAS -33,S

	LDX #$0000
	LDY #$de88
	LDU #$8e99
	PSHS B,X,Y,U
	LEAS -33,S

	LDA -8,S
	ANDA #$F0
	ORA #$01
	STA -8,S
	PSHS B,X,Y,U
	LEAS -33,S

	LDA -8,S
	ANDA #$F0
	ORA #$0e
	STA -8,S
	PSHS B,X,Y,U
	LEAS -33,S

	LDA -8,S
	ANDA #$F0
	ORA #$0e
	STA -8,S
	LDA #$0c
	LDX #$ed00
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$1d
	STA -8,S
	LDA #$ce
	LDX #$dc00
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ec
	STA -8,S
	LDA #$cc
	PSHS D,Y,U
	LEAS -34,S

	LDA -7,S
	ANDA #$F0
	ORA #$01
	STA -7,S
	LDD #$c000
	PSHS D,Y,U
	LEAS -34,S

	LDA #$1e
	LDX #$0000
	LDY #$de18
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ed
	LDY #$dec8
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$dc
	LDY #$dec1
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$cc
	LDY #$deee
	PSHS A,X,Y,U
	LEAS -33,S

	LDA -8,S
	ANDA #$F0
	ORA #$01
	STA -8,S
	LDA #$c0
	LDY #$dece
	PSHS A,X,Y,U
	LEAS -33,S

	LDA -8,S
	ANDA #$F0
	ORA #$0e
	STA -8,S
	LDY #$de8e
	PSHS B,X,Y,U
	LEAS -33,S

	LDA #$1d
	STA -8,S
	PSHS B,X,Y,U
	LEAS -33,S

	LDA #$ec
	STA -8,S
	LDY #$de8c
	LDU #$8c99
	PSHS B,X,Y,U
	LEAS -33,S

	LDA #$dc
	STA -8,S
	LDY #$ed88
	PSHS B,X,Y,U
	LEAS -33,S

	LDA #$cc
	STA -8,S
	PSHS B,X,Y,U
	LEAS -33,S

	LDA #$c0
	STA -8,S
	PSHS B,X,Y,U
	LEAS -33,S

	STA -8,S
	LDU #$8899
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	LDY #$cd88
	LDU #$88e9
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	LDU #$88d9
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	LDY #$0e88
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	LDU #$88de
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	LDY #$0c68
	LDU #$88dd
	PSHS B,X,Y,U
	LEAS -33,S

	STB -8,S
	LDY #$0c78
	LDU #$88ed
	PSHS B,X,Y,U
SSAV_Img_emblemBack03
	LDS #$0000
	RTS

(info)

