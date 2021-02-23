(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemFront02
	STS SSAV_Img_emblemFront02+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS 1116,S

	LDA #$33
	LDX #$2222
	LDY #$1122
	LDU #$2222
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$23
	LDX #$0211
	LDY #$1112
	PSHS A,X,Y,U
	LEAS -33,S

	LDA -7,S
	ANDA #$F0
	ORA #$02
	STA -7,S
	LDD #$0011
	LDX #$1111
	LDU #$2221
	PSHS D,X,U
	LEAS -34,S

	LDD #$c010
	LDX #$0011
	LDU #$2211
	PSHS D,X,U
	LEAS -34,S

	LDD #$e006
	LDX #$6601
	PSHS D,X,U
	LEAS -34,S

	LDD #$ee66
	LDX #$6661
	LDU #$2200
	PSHS D,X,U
	LEAS -34,S

	LDX #$6660
	LDU #$0066
	PSHS D,X,U
	LEAS -34,S

	LDX #$6666
	PSHS D,X,U
	LEAS -34,S

	LDX #$6676
	PSHS D,X,U
	LEAS -34,S

	LDB #$11
	LDX #$1777
	LDU #$0177
	PSHS D,X,U
	LEAS -34,S

	LDB #$00
	PSHS D,X,U
	LEAS -34,S

	LDB #$01
	LDX #$1337
	LDU #$0737
	PSHS D,X,U
	LEAS -34,S

	LDX #$1333
	LDU #$0331
	PSHS D,X,U
	LEAS -34,S

	LDB #$13
	LDX #$3707
	PSHS D,X,U
	LEAS -34,S

	LDD #$ec00
	LDX #$0000
	LDU #$1371
	PSHS D,X,U
	LEAS -34,S

	LDA #$e0
	LDX #$00c1
	LDU #$1001
	PSHS D,X,U
	LEAS -34,S

	LDB #$cc
	LDX #$ccc1
	PSHS D,X,U
	LEAS -34,S

	LDA #$e2
	LDX #$cc10
	LDU #$1cc1
	PSHS D,X,U
	LEAS -34,S

	LDA #$22
	LDX #$1100
	PSHS D,X,U
	LEAS -34,S

	PSHS D,X,U
	LEAS -34,S

	LDX #$1111
	LDU #$0ccc
	PSHS D,X,U
	LEAS -34,S

	LDU #$2ccc
	PSHS D,X,U
	LEAS -34,S

	PSHS D,X,U
	LEAS -34,S

	LDB #$dd
	LDX #$ddd1
	LDU #$21cc
	PSHS D,X,U
	LEAS -34,S

	PSHS D,X,U
	LEAS -34,S

	LDU #$22dd
	PSHS D,X,U
	LEAS -34,S

	LDB #$ee
	LDX #$eee1
	PSHS D,X,U
	LEAS -34,S

	LDB #$1e
	PSHS D,X,U
	LEAS -34,S

	LDB #$20
	LDX #$ee02
	LDU #$22ee
	PSHS D,X,U
	LEAS -34,S

	LDA -6,S
	ANDA #$F0
	ORA #$02
	STA -6,S
	LDA #$22
	LDX #$0022
	PSHS A,X,U
	LEAS -35,S

	LDX #$2222
	LDU #$2200
	PSHS A,X,U
	LEAS -35,S

	LDU #$2222
	PSHS A,X,U
DYN_POS

	LDS #$0000
	LEAS 1116,S

	LDA -7,S
	ANDA #$F0
	ORA #$02
	STA -7,S
	LDD #$6122
	LDX #$1111
	LDU #$2222
	PSHS D,X,U
	LEAS -34,S

	PSHS D,X,U
	LEAS -34,S

	PSHS D,X,U
	LEAS -34,S

	LDB #$01
	LDX #$0001
	LDU #$1222
	PSHS D,X,U
	LEAS -34,S

	LDB #$e0
	LDX #$6660
	LDU #$1221
	PSHS D,X,U
	LEAS -34,S

	LDB #$e6
	LDX #$6666
	PSHS D,X,U
	LEAS -34,S

	LDU #$1110
	PSHS D,X,U
	LEAS -34,S

	LDD #$e1e1
	LDU #$1116
	PSHS D,X,U
	LEAS -34,S

	LDX #$6677
	LDU #$1106
	PSHS D,X,U
	LEAS -34,S

	LDD #$6101
	LDX #$1177
	LDU #$1167
	PSHS D,X,U
	LEAS -34,S

	LDB #$00
	LDX #$1133
	LDU #$1177
	PSHS D,X,U
	LEAS -34,S

	LDD #$21e0
	LDU #$1133
	PSHS D,X,U
	LEAS -34,S

	LDU #$1033
	PSHS D,X,U
	LEAS -34,S

	LDB #$ee
	LDX #$7700
	PSHS D,X,U
	LEAS -34,S

	LDA #$22
	LDX #$0000
	LDU #$1060
	PSHS D,X,U
	LEAS -34,S

	LDD #$2301
	LDX #$cccc
	LDU #$1000
	PSHS D,X,U
	LEAS -34,S

	LDB #$00
	LDU #$00cc
	PSHS D,X,U
	LEAS -34,S

	LDB #$2c
	LDX #$ccc1
	PSHS D,X,U
	LEAS -34,S

	LDB #$1c
	LDX #$cc10
	PSHS D,X,U
	LEAS -34,S

	LDX #$cc00
	PSHS D,X,U
	LEAS -34,S

	LDX #$cc11
	LDU #$10cc
	PSHS D,X,U
	LEAS -34,S

	LDU #$12cc
	PSHS D,X,U
	LEAS -34,S

	PSHS D,X,U
	LEAS -34,S

	LDB #$2d
	LDX #$dddd
	PSHS D,X,U
	LEAS -34,S

	PSHS D,X,U
	LEAS -34,S

	LDA -6,S
	ANDA #$F0
	ORA #$03
	STA -6,S
	LDA #$21
	LDU #$12dd
	PSHS A,X,U
	LEAS -35,S

	LDA -6,S
	ANDA #$F0
	ORA #$03
	STA -6,S
	LDA #$22
	LDX #$eeee
	LDU #$221d
	PSHS A,X,U
	LEAS -35,S

	LDA -6,S
	ANDA #$F0
	ORA #$02
	STA -6,S
	LDA #$22
	LDU #$220d
	PSHS A,X,U
	LEAS -35,S

	LDU #$222e
	PSHS A,X,U
	LEAS -35,S

	LDX #$0000
	LDU #$2220
	PSHS A,X,U
	LEAS -35,S

	LDX #$2222
	LDU #$2222
	PSHS A,X,U
	LEAS -35,S

	PSHS X,U
SSAV_Img_emblemFront02
	LDS #$0000
	RTS

(info)

