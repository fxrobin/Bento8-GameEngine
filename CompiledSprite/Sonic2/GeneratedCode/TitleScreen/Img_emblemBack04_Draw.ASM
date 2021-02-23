(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemBack04
	STS SSAV_Img_emblemBack04+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS -2717,S

	LDD ,S
	LDA #$dd
	ANDB #$0F
	ORB #$e0
	STD ,S
	LDA #$dc
	STA -8,S
	LDA #$ce
	LDX #$77c8
	LDY #$8888
	LDU #$e677
	PSHS A,X,Y,U
	LEAS -32,S

	LDD -9,S
	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD -9,S
	LDA #$77
	LDX #$7666
	LDY #$66c7
	LDU #$7ede
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ed
	STA -8,S
	LDA #$e7
	LDX #$7777
	LDY #$7777
	LDU #$ece0
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$0e
	STA -8,S
	LDD -42,S
	LDA #$de
	ANDB #$0F
	ORB #$e0
	STD -42,S
	LDA #$ce
	LDU #$cd0e
	PSHS A,X,Y,U
	LEAS -35,S

	LDD #$d0dc
	LDX #$e777
	LDU #$77ee
	PSHS D,X,U
	LEAS -33,S

	LDA -7,S
	ANDA #$F0
	ORA #$0d
	STA -7,S
	LDD #$edce
	LDX #$eeee
	LDU #$cce0
	PSHS D,X,U
	LEAS -34,S

	LDD -42,S
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -42,S
	LDD #$0edc
	LDX #$cccc
	LDU #$dd0d
	PSHS D,X,U
	LEAS -36,S

	LDD #$d0ed
	LDX #$dddd
	PSHS D,X
	LEAS -35,S

	LDD #$0eee
	LDX #$ee00
	PSHS D,X
	LEAS -37,S

	LDA #$e0
	LDX #$0000
	PSHS A,X
DYN_POS

	LDS #$0000
	LEAS -2715,S

	LDD #$edd7
	STD -9,S
	LDA #$7c
	LDX #$8888
	LDY #$8677
	LDU #$ece0
	PSHS A,X,Y,U
	LEAS -33,S

	LDD #$0eed
	STD -9,S
	LDD -42,S
	LDA #$dd
	ANDB #$0F
	ORB #$e0
	STD -42,S
	LDA #$77
	LDX #$6666
	LDY #$6777
	LDU #$cd0e
	PSHS A,X,Y,U
	LEAS -35,S

	LDA #$d0
	LDX #$ce77
	LDY #$7777
	LDU #$777d
	PSHS A,X,Y,U
	LEAS -32,S

	LDA -8,S
	ANDA #$F0
	ORA #$0d
	STA -8,S
	LDA #$dc
	LDX #$d777
	LDU #$eede
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ed
	LDX #$ee77
	LDY #$777d
	LDU #$cce0
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$0e
	LDX #$ccee
	LDY #$eeee
	LDU #$dd0e
	PSHS A,X,Y,U
	LEAS -34,S

	LDD #$e0ed
	LDX #$cccc
	LDU #$ccee
	PSHS D,X,U
	LEAS -34,S

	LDD -42,S
	LDA #$e0
	ANDB #$0F
	ORB #$e0
	STD -42,S
	LDA #$0e
	LDX #$dddd
	LDU #$de00
	PSHS A,X,U
	LEAS -37,S

	LDA #$d0
	PSHS A,Y
	LEAS -36,S

	LDA #$00
	LDX #$000d
	PSHS A,X
SSAV_Img_emblemBack04
	LDS #$0000
	RTS

(info)

