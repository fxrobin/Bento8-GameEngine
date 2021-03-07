(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemFront04
	STD DYN_POS+2,PCR
	LEAS ,U
	LDU ,Y
	LEAU 1131,U

	LDA #$22
	STA -7,U
	LDD #$2221
	LDX #$1122
	LDY #$1722
	PSHU D,X,Y
	LEAU -35,U

	LDB #$22
	LDX #$1111
	LDY #$1217
	PSHU D,X,Y
	LEAU -34,U

	LDA #$11
	LDX #$1100
	PSHU D,X,Y
	LEAU -34,U

	LDX #$1166
	LDY #$0117
	PSHU D,X,Y
	LEAU -34,U

	LDX #$1066
	LDY #$61e7
	PSHU D,X,Y
	LEAU -34,U

	LDA #$00
	LDX #$0666
	LDY #$6117
	PSHU D,X,Y
	LEAU -34,U

	LDD #$6601
	LDX #$6666
	PSHU D,X,Y
	LEAU -34,U

	LDX #$6777
	LDY #$6017
	PSHU D,X,Y
	LEAU -34,U

	LDX #$7777
	LDY #$7011
	PSHU D,X,Y
	LEAU -34,U

	LDX #$3311
	LDY #$3011
	PSHU D,X,Y
	LEAU -34,U

	LDA #$76
	LDX #$3300
	PSHU D,X,Y
	LEAU -34,U

	LDA #$77
	LDY #$1017
	PSHU D,X,Y
	LEAU -34,U

	LDA #$37
	LDX #$0000
	LDY #$1e17
	PSHU D,X,Y
	LEAU -34,U

	LDA #$33
	LDY #$1e12
	PSHU D,X,Y
	LEAU -34,U

	LDX #$cc00
	LDY #$1e13
	PSHU D,X,Y
	LEAU -34,U

	LDA #$07
	LDY #$e013
	PSHU D,X,Y
	LEAU -34,U

	LDA #$00
	LDY #$0013
	PSHU D,X,Y
	LEAU -34,U

	LDA #$c0
	LDY #$0213
	PSHU D,X,Y
	LEAU -34,U

	LDA #$cc
	LDY #$1213
	PSHU D,X,Y
	LEAU -34,U

	LDX #$cc12
	LDY #$1233
	PSHU D,X,Y
	LEAU -34,U

	LDB #$00
	LDX #$cc11
	PSHU D,X,Y
	LEAU -34,U

	LDB #$22
	LDX #$ccc1
	LDY #$c133
	PSHU D,X,Y
	LEAU -34,U

	LDX #$cccc
	PSHU D,X,Y
	LEAU -34,U

	LDX #$dddd
	LDY #$d133
	PSHU D,X,Y
	LEAU -34,U

	LDY #$dd33
	PSHU D,X,Y
	LEAU -34,U

	LDY #$dd32
	PSHU D,X,Y
	LEAU -34,U

	LDD -42,U
	LDA #$ee
	ANDB #$0F
	ORB #$30
	STD -42,U
	LDD #$dd22
	LDX #$0eee
	LDY #$ee32
	PSHU D,X,Y
	LEAU -36,U

	LDD -40,U
	LDA #$00
	ANDB #$0F
	ORB #$20
	STD -40,U
	LDD #$dd22
	LDX #$20ee
	PSHU D,X
	LEAU -36,U

	LDX #$22ee
	PSHU D,X
	LEAU -35,U

	LDA #$ee
	LDX #$2222
	LDY #$0022
	PSHU A,X,Y
	LEAU -35,U

	LDY #$2222
	PSHU A,X,Y
	LEAU -36,U

	LDA #$00
	PSHU D,X
DYN_POS

	LDU #$0000
	LEAU 1131,U

	LDA #$22
	STA -7,U
	LDD #$2222
	LDX #$1111
	LDY #$2233
	PSHU D,X,Y
	LEAU -34,U

	STA -7,U
	LDD -42,U
	LDA #$00
	ANDB #$0F
	ORB #$20
	STD -42,U
	LDD #$2222
	LDY #$2232
	PSHU D,X,Y
	LEAU -36,U

	LDA #$11
	LDX #$2221
	LDY #$1101
	PSHU A,X,Y
	LEAU -34,U

	LDX #$1100
	LDY #$6000
	PSHU D,X,Y
	LEAU -34,U

	LDB #$12
	LDX #$1166
	LDY #$66c0
	PSHU D,X,Y
	LEAU -34,U

	LDA #$00
	LDY #$66ec
	PSHU D,X,Y
	LEAU -34,U

	LDD #$6610
	LDY #$66ee
	PSHU D,X,Y
	LEAU -34,U

	LDX #$1677
	LDY #$76ee
	PSHU D,X,Y
	LEAU -34,U

	LDX #$1777
	LDY #$77ee
	PSHU D,X,Y
	LEAU -34,U

	LDX #$1771
	LDY #$73ee
	PSHU D,X,Y
	LEAU -34,U

	LDA #$77
	LDX #$1330
	LDY #$13ee
	PSHU D,X,Y
	LEAU -34,U

	LDX #$1310
	LDY #$03ee
	PSHU D,X,Y
	LEAU -34,U

	LDA #$33
	LDX #$3610
	LDY #$01ee
	PSHU D,X,Y
	LEAU -34,U

	LDX #$0010
	LDY #$00ee
	PSHU D,X,Y
	LEAU -34,U

	LDX #$0c10
	PSHU D,X,Y
	LEAU -34,U

	LDA #$00
	LDX #$cc10
	LDY #$000e
	PSHU D,X,Y
	LEAU -34,U

	LDX #$ccc0
	LDY #$0002
	PSHU D,X,Y
	LEAU -34,U

	LDA #$cc
	LDX #$ccc1
	LDY #$0022
	PSHU D,X,Y
	LEAU -34,U

	LDX #$1cc1
	LDY #$0222
	PSHU D,X,Y
	LEAU -34,U

	LDX #$1ccc
	LDY #$2122
	PSHU D,X,Y
	LEAU -34,U

	LDY #$1122
	PSHU D,X,Y
	LEAU -34,U

	LDB #$12
	PSHU D,X,Y
	LEAU -34,U

	LDY #$cc22
	PSHU D,X,Y
	LEAU -34,U

	LDX #$21dd
	LDY #$dd22
	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	LDX #$22dd
	PSHU D,X,Y
	LEAU -34,U

	LDA #$dd
	LDX #$22ee
	LDY #$ee22
	PSHU D,X,Y
	LEAU -34,U

	PSHU D,X,Y
	LEAU -34,U

	LDX #$2200
	LDY #$e022
	PSHU D,X,Y
	LEAU -34,U

	LDA #$ee
	LDX #$2222
	LDY #$0222
	PSHU D,X,Y
	LEAU -35,U

	LDX #$1222
	LDY #$2222
	PSHU A,X,Y
	LEAU -35,U

	LDA #$00
	LDX #$0222
	PSHU A,X,Y
	RTS

(info)

