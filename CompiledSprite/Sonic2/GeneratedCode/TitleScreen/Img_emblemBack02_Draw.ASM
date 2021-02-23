(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemBack02
	STS SSAV_Img_emblemBack02+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS -1444,S

	LDA #$00
	STA -8,S
	LDX #$0000
	LDY #$dd81
	LDU #$88e9
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$ed8c
	LDU #$88c9
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$1e
	STA -8,S
	LDA #$c0
	LDY #$cd8e
	LDU #$88de
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ed
	STA -8,S
	LDA #$00
	LDY #$cd1c
	LDU #$18dc
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$dc
	STA -8,S
	LDA #$00
	LDY #$0e68
	LDU #$88ed
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$cc
	STA -8,S
	LDA #$00
	LDY #$0e78
	LDU #$88cd
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$c0
	STA -8,S
	LDA #$00
	LDY #$0c78
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$0c76
	LDU #$888e
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$00e7
	LDU #$888c
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDU #$8888
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$00c7
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$00de
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$00dc
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$00ed
	LDU #$6818
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$00cd
	LDU #$78c8
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDU #$76c1
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$000e
	LDU #$778e
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$00cc
	LDU #$e71e
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDD #$ce8e
	STD -42,S
	LDD -44,S
	LDA #$cd
	ANDB #$F0
	ORB #$0e
	STD -44,S
	LDA #$00
	LDY #$0ced
	LDU #$e7cc
	PSHS A,X,Y,U
	LEAS -37,S

	LDD #$dc6c
	STD -38,S
	LDD #$0000
	PSHS D,X
	LEAS -36,S

	LDD #$dd76
	STD -38,S
	LDU #$000c
	PSHS X,U
	LEAS -36,S

	LDD #$ed77
	STD -38,S
	LDU #$00ce
	PSHS X,U
	LEAS -37,S

	LDA #$cd
	STD -37,S
	LDA #$00
	LDX #$000c
	PSHS A,X
	LEAS -37,S

	LDD #$dee7
	STD -37,S
	STX -43,S
	LDD #$ecce
	STD -77,S
	STU -83,S
	LDD -117,S
	ANDA #$F0
	ORA #$0e
	LDB #$dc
	STD -117,S
	LDA #$0c
	STA -123,S
	LDA #$00
	PSHS A,U
	LEAS -193,S

	LDA #$dd
	STA 40,S
	LDA #$cd
	STA 33,S
	LDA #$ce
	STA -40,S
	LDA #$ed
	STA ,S
	LDA -7,S
	ANDA #$0F
	ORA #$e0
	STA -7,S
DYN_POS

	LDS #$0000
	LEAS -1444,S

	LDA #$00
	STA -8,S
	LDX #$0000
	LDY #$0c78
	LDU #$81ed
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$0078
	LDU #$8ccd
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$00e6
	LDU #$1c8e
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$cc
	STA -8,S
	LDA #$dc
	LDY #$00e7
	LDU #$ee8e
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$e1
	STA -8,S
	LDA #$cc
	LDY #$00c7
	LDU #$ec8c
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$1e
	STA -8,S
	LDA #$c0
	LDY #$00d7
	LDU #$e888
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ed
	STA -8,S
	LDA #$00
	LDY #$00de
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$dc
	STA -8,S
	LDA #$00
	LDU #$c888
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$cc
	STA -8,S
	LDA #$00
	LDY #$00dc
	LDU #$8888
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$c0
	STA -8,S
	LDA #$00
	LDY #$00ed
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$00cd
	LDU #$6888
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDU #$7888
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$000e
	LDU #$7688
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$000c
	LDU #$7788
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$0000
	LDU #$e788
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDU #$c788
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDU #$ce88
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDU #$de88
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDU #$dc68
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDD #$cd77
	STD -42,S
	LDD -44,S
	LDA #$0c
	ANDB #$0F
	ORB #$10
	STD -44,S
	LDA #$00
	LDY #$00cc
	LDU #$ed76
	PSHS A,X,Y,U
	LEAS -37,S

	LDD #$de77
	STD -38,S
	LDD #$0000
	PSHS D,X
	LEAS -35,S

	LDD #$ece7
	STD -39,S
	LDA #$00
	LDU #$00ce
	PSHS A,X,U
	LEAS -36,S

	LDD -38,S
	ANDA #$F0
	ORA #$0d
	LDB #$cd
	STD -38,S
	LDU #$000c
	PSHS X,U
	LEAS -36,S

	LDD -38,S
	ANDA #$F0
	ORA #$0e
	LDB #$de
	STD -38,S
	LDU #$00ce
	PSHS X,U
	LEAS -37,S

	LDA #$dc
	STA -36,S
	LDA #$00
	LDX #$000c
	PSHS A,X
	LEAS -37,S

	LDA #$ed
	STA -36,S
	STX -43,S
	LDA #$cd
	STA -76,S
	STU -83,S
	STB -116,S
	LDD -123,S
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD -123,S
	PSHS A,U
	LEAS -177,S

	LDA #$ec
	STA 24,S
	LDA #$cc
	STA 17,S
	LDA -16,S
	ANDA #$F0
	ORA #$0e
	STA -16,S
	LDA #$d1
	STA -23,S
SSAV_Img_emblemBack02
	LDS #$0000
	RTS

(info)

