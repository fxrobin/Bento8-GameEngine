(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemBack06
	STS SSAV_Img_emblemBack06+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS -316,S

	LDA #$99
	STA 39,S
	STA 32,S
	STA -8,S
	LDX #$9999
	LDY #$9999
	LDU #$9999
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
DYN_POS

	LDS #$0000
	LEAS -316,S

	LDA 39,S
	ANDA #$F0
	ORA #$09
	STA 39,S
	LDA #$99
	STA 32,S
	STA -8,S
	LDX #$9999
	LDY #$9999
	LDU #$9999
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
SSAV_Img_emblemBack06
	LDS #$0000
	RTS

(info)

