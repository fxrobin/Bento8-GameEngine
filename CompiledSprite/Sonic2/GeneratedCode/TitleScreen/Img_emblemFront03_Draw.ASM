(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemFront03
	STS SSAV_Img_emblemFront03+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS 1124,S

	LDA #$22
	STA -8,S
	LDX #$2222
	LDY #$2722
	LDU #$2222
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$11
	STA -8,S
	LDA #$22
	LDY #$2222
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$11
	STA -8,S
	LDA #$12
	LDX #$2211
	LDY #$2211
	LDU #$2211
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$11
	STA -8,S
	LDY #$2111
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDA #$11
	LDU #$1211
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$66
	STA -8,S
	LDA #$11
	LDX #$2200
	LDY #$2100
	LDU #$1210
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$66
	STA -8,S
	LDA #$01
	LDX #$2666
	LDY #$1166
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$66
	STA -8,S
	LDA #$61
	LDX #$0066
	LDU #$1010
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$66
	STA -8,S
	LDY #$1186
	LDU #$1016
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$77
	STA -8,S
	LDA #$76
	LDY #$1686
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$77
	STA -8,S
	LDX #$0077
	LDY #$1666
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDA #$33
	LDX #$1077
	LDY #$1777
	LDU #$1017
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$13
	STA -8,S
	LDA #$33
	LDX #$1033
	LDY #$1377
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$01
	STA -8,S
	LDA #$33
	LDY #$3333
	LDU #$1013
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$1000
	LDY #$7063
	LDU #$1017
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDA #$cc
	LDY #$0000
	LDU #$1010
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDA #$cc
	LDX #$10cc
	LDY #$0cc0
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDA #$cc
	LDY #$cccc
	LDU #$101c
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDA #$cc
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDA #$cc
	LDX #$00cc
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$11
	STA -8,S
	LDA #$cc
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$11
	STA -8,S
	LDA #$cc
	LDU #$121c
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$11
	STA -8,S
	LDA #$cc
	LDX #$22cc
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$c1cc
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$dd
	STA -8,S
	LDY #$c2cc
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDA #$cd
	LDX #$22dd
	LDY #$d2dd
	LDU #$121d
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$dd
	STA -8,S
	LDA #$c0
	LDY #$12dd
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ee
	STA -8,S
	LDA #$e2
	LDY #$22dd
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ee
	STA -8,S
	LDA #$02
	LDX #$22ee
	LDY #$22ee
	LDU #$121e
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ee
	STA -8,S
	LDA #$22
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDA #$22
	LDX #$2200
	LDY #$2200
	LDU #$0220
	PSHS A,X,Y,U
DYN_POS

	LDS #$0000
	LEAS 1124,S

	LDA #$22
	STA -8,S
	LDX #$2222
	LDY #$2272
	LDU #$2222
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$11
	STA -8,S
	LDA #$12
	LDY #$2262
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$11
	STA -8,S
	LDX #$2261
	LDY #$1111
	LDU #$1122
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDA #$11
	LDX #$1211
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$66
	STA -8,S
	LDA #$00
	LDX #$1210
	LDY #$0110
	LDU #$0022
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$66
	STA -8,S
	LDX #$1116
	LDY #$0108
	LDU #$6622
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$0106
	LDU #$6600
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDY #$6166
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$77
	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$1117
	LDY #$6177
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$11
	STA -8,S
	LDA #$33
	LDX #$7117
	LDY #$7177
	LDU #$7700
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDA #$33
	LDX #$3113
	LDY #$7133
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDA #$33
	LDY #$3133
	LDU #$3300
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDA #$36
	LDX #$6113
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDA #$10
	LDX #$6116
	LDY #$7100
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDA #$10
	LDX #$0110
	LDY #$0000
	LDU #$0000
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDA #$0c
	LDX #$c11c
	LDY #$00cc
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$10
	STA -8,S
	LDA #$0c
	LDX #$011c
	LDY #$ccc1
	LDU #$cc00
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$10
	STA -8,S
	LDA #$0c
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$11
	STA -8,S
	LDA #$0c
	LDX #$c11c
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$11
	STA -8,S
	LDA #$1c
	LDY #$cc11
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$c1
	STA -8,S
	LDA #$1c
	LDU #$cc22
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$cc
	STA -8,S
	LDX #$111c
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$121c
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$dd
	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$221d
	LDY #$dd11
	LDU #$dd22
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ee
	STA -8,S
	LDY #$dd21
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$221e
	LDY #$ee21
	LDU #$ee22
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDA #$00
	LDY #$e122
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDA #$22
	LDX #$2200
	LDY #$0222
	LDU #$0022
	PSHS A,X,Y,U
SSAV_Img_emblemFront03
	LDS #$0000
	RTS

(info)

