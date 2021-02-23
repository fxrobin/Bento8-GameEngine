(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemFront07
	STS SSAV_Img_emblemFront07+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS 3162,S

	LDD #$1111
	LDX #$1111
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$01
	STA -5,S
	LDD #$1111
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$01
	STA -5,S
	LDD #$1111
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$0c
	STA -5,S
	LDD #$cccc
	LDX #$cccc
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$01
	STA -5,S
	LDD #$eeee
	LDX #$eeee
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$01
	STA -5,S
	LDD #$eeee
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$01
	STA -5,S
	LDD #$eeee
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$01
	STA -5,S
	LDD #$eeee
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$01
	STA -5,S
	LDD #$eeee
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$01
	STA -5,S
	LDD #$eeee
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$01
	STA -5,S
	LDD #$eeee
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$01
	STA -5,S
	LDD #$eeee
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$01
	STA -5,S
	LDD #$ee11
	LDX #$1111
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$01
	STA -5,S
	LDD #$ee0c
	LDX #$cccc
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$01
	STA -5,S
	LDD #$eeee
	LDX #$eeec
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$00
	STA -5,S
	LDD #$eeee
	LDX #$eeee
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$00
	STA -5,S
	LDD #$edee
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$00
	STA -5,S
	LDD #$edee
	PSHS D,X
	LEAS -36,S

	LDA #$ee
	PSHS D,X
DYN_POS

	LDS #$0000
	LEAS 3161,S

	LDD ,S
	LDA #$11
	ANDB #$0F
	ORB #$10
	STD ,S
	LDD -40,S
	LDA #$11
	ANDB #$0F
	ORB #$10
	STD -40,S
	LDX #$1111
	PSHS A,X
	LEAS -37,S

	PSHS A,X
	LEAS -35,S

	LDU #$1111
	PSHS A,X,U
	LEAS -35,S

	LDA #$cc
	LDX #$cccc
	LDU #$cccc
	PSHS A,X,U
	LEAS -35,S

	LDA #$ee
	LDX #$eeee
	LDU #$eeec
	PSHS A,X,U
	LEAS -35,S

	PSHS A,X,U
	LEAS -35,S

	PSHS A,X,U
	LEAS -35,S

	PSHS A,X,U
	LEAS -35,S

	LDU #$eee0
	PSHS A,X,U
	LEAS -35,S

	PSHS A,X,U
	LEAS -35,S

	PSHS A,X,U
	LEAS -35,S

	PSHS A,X,U
	LEAS -35,S

	LDX #$1111
	LDU #$1110
	PSHS A,X,U
	LEAS -35,S

	LDD -42,S
	LDA #$ee
	ANDB #$0F
	ORB #$10
	STD -42,S
	LDX #$00cc
	LDU #$0c00
	PSHS A,X,U
	LEAS -37,S

	LDD -40,S
	LDA #$ee
	ANDB #$0F
	ORB #$c0
	STD -40,S
	LDX #$eeee
	PSHS A,X
	LEAS -37,S

	PSHS A,X
	LEAS -35,S

	LDU #$eee1
	PSHS A,X,U
	LEAS -35,S

	PSHS A,X,U
	LEAS -35,S

	LDA #$1e
	LDU #$eeec
	PSHS A,X,U
SSAV_Img_emblemFront07
	LDS #$0000
	RTS

(info)

