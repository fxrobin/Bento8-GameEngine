(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemFront04
	STS SSAV_Img_emblemFront04+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS 1131,S

	LDA #$22
	LDX #$2221
	LDY #$1122
	LDU #$1722
	PSHS A,X,Y,U
	LEAS -34,S

	LDD #$2222
	LDX #$1111
	LDU #$1217
	PSHS D,X,U
	LEAS -34,S

	LDA #$11
	LDX #$1100
	PSHS D,X,U
	LEAS -34,S

	LDX #$1166
	LDU #$0117
	PSHS D,X,U
	LEAS -34,S

	LDX #$1066
	LDU #$61e7
	PSHS D,X,U
	LEAS -34,S

	LDA #$00
	LDX #$0666
	LDU #$6117
	PSHS D,X,U
	LEAS -34,S

	LDD #$6601
	LDX #$6666
	PSHS D,X,U
	LEAS -34,S

	LDX #$6777
	LDU #$6017
	PSHS D,X,U
	LEAS -34,S

	LDX #$7777
	LDU #$7011
	PSHS D,X,U
	LEAS -34,S

	LDX #$3311
	LDU #$3011
	PSHS D,X,U
	LEAS -34,S

	LDA #$76
	LDX #$3300
	PSHS D,X,U
	LEAS -34,S

	LDA #$77
	LDU #$1017
	PSHS D,X,U
	LEAS -34,S

	LDA #$37
	LDX #$0000
	LDU #$1e17
	PSHS D,X,U
	LEAS -34,S

	LDA #$33
	LDU #$1e12
	PSHS D,X,U
	LEAS -34,S

	LDX #$cc00
	LDU #$1e13
	PSHS D,X,U
	LEAS -34,S

	LDA #$07
	LDU #$e013
	PSHS D,X,U
	LEAS -34,S

	LDA #$00
	LDU #$0013
	PSHS D,X,U
	LEAS -34,S

	LDA #$c0
	LDU #$0213
	PSHS D,X,U
	LEAS -34,S

	LDA #$cc
	LDU #$1213
	PSHS D,X,U
	LEAS -34,S

	LDX #$cc12
	LDU #$1233
	PSHS D,X,U
	LEAS -34,S

	LDB #$00
	LDX #$cc11
	PSHS D,X,U
	LEAS -34,S

	LDB #$22
	LDX #$ccc1
	LDU #$c133
	PSHS D,X,U
	LEAS -34,S

	LDX #$cccc
	PSHS D,X,U
	LEAS -34,S

	LDX #$dddd
	LDU #$d133
	PSHS D,X,U
	LEAS -34,S

	LDU #$dd33
	PSHS D,X,U
	LEAS -34,S

	LDU #$dd32
	PSHS D,X,U
	LEAS -34,S

	LDD -42,S
	LDA #$ee
	ANDB #$0F
	ORB #$30
	STD -42,S
	LDD #$dd22
	LDX #$0eee
	LDU #$ee32
	PSHS D,X,U
	LEAS -36,S

	LDD -40,S
	LDA #$00
	ANDB #$0F
	ORB #$20
	STD -40,S
	LDD #$dd22
	LDX #$20ee
	PSHS D,X
	LEAS -36,S

	LDX #$22ee
	PSHS D,X
	LEAS -35,S

	LDA #$ee
	LDX #$2222
	LDU #$0022
	PSHS A,X,U
	LEAS -35,S

	LDU #$2222
	PSHS A,X,U
	LEAS -36,S

	LDA #$00
	PSHS D,X
DYN_POS

	LDS #$0000
	LEAS 1131,S

	LDA #$22
	LDX #$2222
	LDY #$1111
	LDU #$2233
	PSHS A,X,Y,U
	LEAS -33,S

	LDD -42,S
	LDA #$00
	ANDB #$0F
	ORB #$20
	STD -42,S
	LDA #$22
	LDU #$2232
	PSHS A,X,Y,U
	LEAS -35,S

	LDA #$11
	LDX #$2221
	LDU #$1101
	PSHS A,X,U
	LEAS -34,S

	LDD #$1122
	LDX #$1100
	LDU #$6000
	PSHS D,X,U
	LEAS -34,S

	LDB #$12
	LDX #$1166
	LDU #$66c0
	PSHS D,X,U
	LEAS -34,S

	LDA #$00
	LDU #$66ec
	PSHS D,X,U
	LEAS -34,S

	LDD #$6610
	LDU #$66ee
	PSHS D,X,U
	LEAS -34,S

	LDX #$1677
	LDU #$76ee
	PSHS D,X,U
	LEAS -34,S

	LDX #$1777
	LDU #$77ee
	PSHS D,X,U
	LEAS -34,S

	LDX #$1771
	LDU #$73ee
	PSHS D,X,U
	LEAS -34,S

	LDA #$77
	LDX #$1330
	LDU #$13ee
	PSHS D,X,U
	LEAS -34,S

	LDX #$1310
	LDU #$03ee
	PSHS D,X,U
	LEAS -34,S

	LDA #$33
	LDX #$3610
	LDU #$01ee
	PSHS D,X,U
	LEAS -34,S

	LDX #$0010
	LDU #$00ee
	PSHS D,X,U
	LEAS -34,S

	LDX #$0c10
	PSHS D,X,U
	LEAS -34,S

	LDA #$00
	LDX #$cc10
	LDU #$000e
	PSHS D,X,U
	LEAS -34,S

	LDX #$ccc0
	LDU #$0002
	PSHS D,X,U
	LEAS -34,S

	LDA #$cc
	LDX #$ccc1
	LDU #$0022
	PSHS D,X,U
	LEAS -34,S

	LDX #$1cc1
	LDU #$0222
	PSHS D,X,U
	LEAS -34,S

	LDX #$1ccc
	LDU #$2122
	PSHS D,X,U
	LEAS -34,S

	LDU #$1122
	PSHS D,X,U
	LEAS -34,S

	LDB #$12
	PSHS D,X,U
	LEAS -34,S

	LDU #$cc22
	PSHS D,X,U
	LEAS -34,S

	LDX #$21dd
	LDU #$dd22
	PSHS D,X,U
	LEAS -34,S

	PSHS D,X,U
	LEAS -34,S

	LDX #$22dd
	PSHS D,X,U
	LEAS -34,S

	LDA #$dd
	LDX #$22ee
	LDU #$ee22
	PSHS D,X,U
	LEAS -34,S

	PSHS D,X,U
	LEAS -34,S

	LDX #$2200
	LDU #$e022
	PSHS D,X,U
	LEAS -34,S

	LDA #$ee
	LDX #$2222
	LDU #$0222
	PSHS D,X,U
	LEAS -35,S

	LDX #$1222
	LDU #$2222
	PSHS A,X,U
	LEAS -35,S

	LDA #$00
	LDX #$0222
	PSHS A,X,U
SSAV_Img_emblemFront04
	LDS #$0000
	RTS

(info)

