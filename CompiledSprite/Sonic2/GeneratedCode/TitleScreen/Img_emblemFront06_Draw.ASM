(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemFront06
	STS SSAV_Img_emblemFront06+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS 2402,S

	LDD #$eeee
	LDX #$eeee
	PSHS D,X
	LEAS -36,S

	PSHS D,X
	LEAS -36,S

	LDA #$1e
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$01
	STA -5,S
	LDD #$c111
	LDX #$11ee
	PSHS D,X
	LEAS -36,S

	LDA -5,S
	ANDA #$F0
	ORA #$01
	STA -5,S
	LDD -42,S
	ANDA #$F0
	ORA #$01
	LDB #$ee
	STD -42,S
	LDD -45,S
	ANDA #$F0
	ORA #$01
	LDB #$11
	STD -45,S
	LDD #$1ccc
	LDX #$ccee
	PSHS D,X
	LEAS -76,S

	LDX #$cc11
	LDU #$11de
	PSHS A,X,U
	LEAS -35,S

	LDA #$11
	LDX #$ee11
	PSHS A,X,U
	LEAS -35,S

	LDD -41,S
	LDA #$ee
	ANDB #$0F
	ORB #$10
	STD -41,S
	LDA #$11
	LDU #$11ee
	PSHS A,X,U
	LEAS -36,S

	LDD #$e1ee
	LDX #$0ccc
	PSHS D,X
	LEAS -34,S

	LDA #$c1
	LDX #$cded
	LDU #$eece
	PSHS D,X,U
	LEAS -34,S

	LDD -41,S
	LDA #$ed
	ANDB #$0F
	ORB #$10
	STD -41,S
	LDA #$1e
	LDX #$d1ee
	LDY #$ccdc
	LDU #$eedc
	PSHS A,X,Y,U
	LEAS -34,S

	LDD #$ece1
	LDX #$eecc
	LDU #$ccee
	PSHS D,X,U
	LEAS -32,S

	LDA #$cd
	STA -8,S
	LDA #$c1
	LDX #$eedc
	LDY #$c0ee
	LDU #$cec1
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$de
	STA -8,S
	LDA #$80
	LDX #$eecc
	LDU #$8cdc
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ec
	STA -8,S
	LDA #$80
	LDX #$edc0
	LDY #$0cee
	LDU #$88dd
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$c8
	STA -8,S
	LDA #$88
	LDX #$dcc0
	LDU #$88ed
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$cc00
	LDY #$0cd1
	LDU #$88ce
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$1111
	LDY #$1110
	LDU #$888c
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$0000
	LDY #$0008
	LDU #$8886
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$66
	STA -8,S
	LDX #$6688
	LDY #$8666
	LDU #$6666
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$77
	STA -8,S
	LDX #$7768
	LDY #$8677
	LDU #$7777
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$7778
	LDY #$6777
	LDU #$7773
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$33
	STA -8,S
	LDX #$3337
	LDY #$2333
	LDU #$3333
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$22
	STA -8,S
	LDX #$2222
	LDY #$6722
	LDU #$2222
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$11
	STA -8,S
	LDA #$22
	LDX #$1111
	LDY #$1111
	LDU #$1111
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDA #$22
	LDX #$1001
	LDY #$1110
	LDU #$0100
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDA #$22
	LDY #$0010
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDA #$22
	LDX #$0011
	LDU #$0010
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDA #$22
	LDX #$0001
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDA #$22
	LDX #$1011
	LDU #$0110
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDA #$22
	LDX #$1001
	LDY #$1110
	LDU #$0100
	PSHS A,X,Y,U
DYN_POS

	LDS #$0000
	LEAS 2403,S

	LDA #$1e
	LDX #$eeee
	LDU #$eeec
	PSHS A,X,U
	LEAS -35,S

	LDA #$01
	LDX #$ceee
	PSHS A,X,U
	LEAS -35,S

	LDA #$10
	PSHS A,X,U
	LEAS -35,S

	LDA #$11
	LDX #$1111
	LDU #$1eec
	PSHS A,X,U
	LEAS -35,S

	LDD #$ceec
	STD -42,S
	STX -45,S
	LDA #$11
	LDX #$0ccc
	LDU #$ceec
	PSHS A,X,U
	LEAS -75,S

	LDA #$cc
	LDX #$1111
	PSHS A,X,U
	LEAS -35,S

	LDA #$ee
	PSHS A,X,U
	LEAS -35,S

	LDU #$0dec
	PSHS A,X,U
	LEAS -35,S

	LDA -6,S
	ANDA #$F0
	ORA #$01
	STA -6,S
	LDD -41,S
	LDA #$ec
	ANDB #$0F
	ORB #$10
	STD -41,S
	LDA #$ee
	LDX #$cccc
	LDU #$dcec
	PSHS A,X,U
	LEAS -36,S

	LDA #$1c
	LDX #$eeee
	LDU #$eece
	PSHS A,X,U
	LEAS -33,S

	LDA #$cd
	LDY #$ddce
	LDU #$ecc1
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$dd
	LDY #$dcce
	LDU #$ecdc
	PSHS A,X,Y,U
	LEAS -33,S

	LDA -8,S
	ANDA #$F0
	ORA #$0e
	STA -8,S
	LDA #$ee
	LDY #$ccce
	LDU #$ecdd
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ec
	STA -8,S
	LDA #$cc
	LDX #$eeed
	LDY #$ccde
	LDU #$18ed
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$cd
	STA -8,S
	LDA #$88
	LDX #$eedc
	LDY #$00de
	LDU #$18ce
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$de
	STA -8,S
	LDA #$88
	LDX #$1ecc
	LDY #$00cd
	LDU #$088c
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ec
	STA -8,S
	LDA #$88
	LDX #$01cc
	LDU #$8888
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$c8
	STA -8,S
	LDA #$88
	LDX #$8011
	LDY #$1111
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$68
	STA -8,S
	LDA #$88
	LDX #$8800
	LDY #$0000
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$66
	STA -8,S
	LDX #$6666
	LDY #$0066
	LDU #$6666
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$77
	STA -8,S
	LDX #$7777
	LDY #$8877
	LDU #$7777
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$37
	STA -8,S
	LDA #$77
	LDY #$6677
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$33
	STA -8,S
	LDX #$3333
	LDY #$2233
	LDU #$3333
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$22
	STA -8,S
	LDX #$2222
	LDY #$2722
	LDU #$2222
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$11
	STA -8,S
	LDX #$2111
	LDY #$1111
	LDU #$1111
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$01
	STA -8,S
	LDA #$00
	LDX #$2010
	LDY #$0000
	LDU #$0101
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$01
	STA -8,S
	LDA #$00
	LDU #$1100
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDA #$11
	LDY #$0110
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$00
	STA -8,S
	LDA #$01
	LDU #$0100
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDA #$11
	LDY #$0111
	LDU #$1100
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$01
	STA -8,S
	LDA #$00
	LDY #$0000
	LDU #$0101
	PSHS A,X,Y,U
SSAV_Img_emblemFront06
	LDS #$0000
	RTS

(info)

