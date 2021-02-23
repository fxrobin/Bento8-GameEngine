(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemFront01
	STS SSAV_Img_emblemFront01+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS -154,S

	LDD ,S
	LDA #$22
	ANDB #$0F
	ORB #$20
	STD ,S
	LDX #$2222
	LDY #$2222
	LDU #$2222
	PSHS A,X,Y,U
	LDD -34,S
	LDA #$22
	ANDB #$0F
	ORB #$20
	STD -34,S
	PSHS A,X,Y,U
	LEAS -27,S

	PSHS A,X,Y,U
	LDD -34,S
	LDA #$22
	ANDB #$0F
	ORB #$30
	STD -34,S
	PSHS A,X,Y
	LEAS -29,S

	PSHS A,X,Y,U
	LDA #$33
	PSHS A,X
	LEAS -31,S

	LDD #$3322
	LDU #$2233
	PSHS D,X,U
DYN_POS

	LDS #$0000
	LEAS -152,S

	LDA #$22
	LDX #$2222
	LDY #$2222
	LDU #$2222
	PSHS A,X,Y,U
	LDD -9,S
	ANDA #$F0
	ORA #$02
	LDB #$22
	STD -9,S
	PSHS B,X,Y,U
	LEAS -27,S

	PSHS B,X,Y,U
	PSHS X,Y,U
	LEAS -28,S

	LDU #$2233
	PSHS B,X,Y,U
	LDD -37,S
	LDA #$33
	ANDB #$0F
	ORB #$30
	STD -37,S
	LDD #$3222
	PSHS D,X
	LEAS -33,S

	LDA #$33
	LDX #$3222
	PSHS A,X,Y
SSAV_Img_emblemFront01
	LDS #$0000
	RTS

(info)

