(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemFront06
	STD DYN_POS+2,PCR
	LEAS ,U
	LDU ,Y
	LEAU 2402,U

	LDD #$eeee
	LDX #$eeee
	PSHU D,X
	LEAU -36,U

	PSHU D,X
	LEAU -36,U

	LDA #$1e
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$01
	STA -5,U
	LDD #$c111
	LDX #$11ee
	PSHU D,X
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$01
	STA -5,U
	LDD -42,U
	ANDA #$F0
	ORA #$01
	LDB #$ee
	STD -42,U
	LDD -45,U
	ANDA #$F0
	ORA #$01
	LDB #$11
	STD -45,U
	LDD #$1ccc
	LDX #$ccee
	PSHU D,X
	LEAU -76,U

	LDX #$cc11
	LDY #$11de
	PSHU A,X,Y
	LEAU -35,U

	LDA #$11
	LDX #$ee11
	PSHU A,X,Y
	LEAU -35,U

	LDD -41,U
	LDA #$ee
	ANDB #$0F
	ORB #$10
	STD -41,U
	LDA #$11
	LDY #$11ee
	PSHU A,X,Y
	LEAU -36,U

	LDD #$e1ee
	LDX #$0ccc
	PSHU D,X
	LEAU -34,U

	LDA #$c1
	LDX #$cded
	LDY #$eece
	PSHU D,X,Y
	LEAU -34,U

	LDA #$1e
	STA -7,U
	LDD -41,U
	LDA #$ed
	ANDB #$0F
	ORB #$10
	STD -41,U
	LDD #$d1ee
	LDX #$ccdc
	LDY #$eedc
	PSHU D,X,Y
	LEAU -35,U

	LDD #$ece1
	LDX #$eecc
	LDY #$ccee
	PSHU D,X,Y
	LEAU -32,U

	LDD #$cdc1
	STD -8,U
	LDD #$eedc
	LDX #$c0ee
	LDY #$cec1
	PSHU D,X,Y
	LEAU -34,U

	LDD #$de80
	STD -8,U
	LDD #$eecc
	LDY #$8cdc
	PSHU D,X,Y
	LEAU -34,U

	LDD #$ec80
	STD -8,U
	LDD #$edc0
	LDX #$0cee
	LDY #$88dd
	PSHU D,X,Y
	LEAU -34,U

	LDD #$c888
	STD -8,U
	LDD #$dcc0
	LDY #$88ed
	PSHU D,X,Y
	LEAU -34,U

	LDD #$8888
	STD -8,U
	LDD #$cc00
	LDX #$0cd1
	LDY #$88ce
	PSHU D,X,Y
	LEAU -34,U

	LDD #$8888
	STD -8,U
	LDD #$1111
	LDX #$1110
	LDY #$888c
	PSHU D,X,Y
	LEAU -34,U

	LDD #$8888
	STD -8,U
	LDD #$0000
	LDX #$0008
	LDY #$8886
	PSHU D,X,Y
	LEAU -34,U

	LDD #$6666
	STD -8,U
	LDB #$88
	LDX #$8666
	LDY #$6666
	PSHU D,X,Y
	LEAU -34,U

	LDD #$7777
	STD -8,U
	LDB #$68
	LDX #$8677
	LDY #$7777
	PSHU D,X,Y
	LEAU -34,U

	STY -8,U
	LDB #$78
	LDX #$6777
	LDY #$7773
	PSHU D,X,Y
	LEAU -34,U

	LDD #$3333
	STD -8,U
	LDB #$37
	LDX #$2333
	LDY #$3333
	PSHU D,X,Y
	LEAU -34,U

	LDD #$2222
	STD -8,U
	LDX #$6722
	LDY #$2222
	PSHU D,X,Y
	LEAU -34,U

	LDA #$11
	STD -8,U
	LDB #$11
	LDX #$1111
	LDY #$1111
	PSHU D,X,Y
	LEAU -34,U

	LDD #$0022
	STD -8,U
	LDD #$1001
	LDX #$1110
	LDY #$0100
	PSHU D,X,Y
	LEAU -34,U

	LDD #$0022
	STD -8,U
	LDD #$1001
	LDX #$0010
	PSHU D,X,Y
	LEAU -34,U

	LDD #$0022
	STD -8,U
	LDB #$11
	LDY #$0010
	PSHU D,X,Y
	LEAU -34,U

	LDB #$22
	STD -8,U
	LDB #$01
	PSHU D,X,Y
	LEAU -34,U

	LDB #$22
	STD -8,U
	LDD #$1011
	LDY #$0110
	PSHU D,X,Y
	LEAU -34,U

	LDD #$0022
	STD -8,U
	LDD #$1001
	LDX #$1110
	LDY #$0100
	PSHU D,X,Y
DYN_POS

	LDU #$0000
	LEAU 2403,U

	LDA #$1e
	LDX #$eeee
	LDY #$eeec
	PSHU A,X,Y
	LEAU -35,U

	LDA #$01
	LDX #$ceee
	PSHU A,X,Y
	LEAU -35,U

	LDA #$10
	PSHU A,X,Y
	LEAU -35,U

	LDA #$11
	LDX #$1111
	LDY #$1eec
	PSHU A,X,Y
	LEAU -35,U

	LDD #$ceec
	STD -42,U
	STX -45,U
	LDA #$11
	LDX #$0ccc
	LDY #$ceec
	PSHU A,X,Y
	LEAU -75,U

	LDA #$cc
	LDX #$1111
	PSHU A,X,Y
	LEAU -35,U

	LDA #$ee
	PSHU A,X,Y
	LEAU -35,U

	LDY #$0dec
	PSHU A,X,Y
	LEAU -35,U

	LDA -6,U
	ANDA #$F0
	ORA #$01
	STA -6,U
	LDD -41,U
	LDA #$ec
	ANDB #$0F
	ORB #$10
	STD -41,U
	LDA #$ee
	LDX #$cccc
	LDY #$dcec
	PSHU A,X,Y
	LEAU -36,U

	LDA #$1c
	LDX #$eeee
	LDY #$eece
	PSHU A,X,Y
	LEAU -33,U

	LDA #$cd
	STA -7,U
	LDD #$eeee
	LDX #$ddce
	LDY #$ecc1
	PSHU D,X,Y
	LEAU -34,U

	LDA #$dd
	STA -7,U
	LDA #$ee
	LDX #$dcce
	LDY #$ecdc
	PSHU D,X,Y
	LEAU -34,U

	LDD -8,U
	ANDA #$F0
	ORA #$0e
	LDB #$ee
	STD -8,U
	LDD #$eeee
	LDX #$ccce
	LDY #$ecdd
	PSHU D,X,Y
	LEAU -34,U

	LDD #$eccc
	STD -8,U
	LDD #$eeed
	LDX #$ccde
	LDY #$18ed
	PSHU D,X,Y
	LEAU -34,U

	LDD #$cd88
	STD -8,U
	LDD #$eedc
	LDX #$00de
	LDY #$18ce
	PSHU D,X,Y
	LEAU -34,U

	LDD #$de88
	STD -8,U
	LDD #$1ecc
	LDX #$00cd
	LDY #$088c
	PSHU D,X,Y
	LEAU -34,U

	LDD #$ec88
	STD -8,U
	LDD #$01cc
	LDY #$8888
	PSHU D,X,Y
	LEAU -34,U

	LDD #$c888
	STD -8,U
	LDD #$8011
	LDX #$1111
	PSHU D,X,Y
	LEAU -34,U

	LDD #$6888
	STD -8,U
	LDD #$8800
	LDX #$0000
	PSHU D,X,Y
	LEAU -34,U

	LDD #$6666
	STD -8,U
	LDX #$0066
	LDY #$6666
	PSHU D,X,Y
	LEAU -34,U

	LDD #$7777
	STD -8,U
	LDX #$8877
	LDY #$7777
	PSHU D,X,Y
	LEAU -34,U

	LDA #$37
	STD -8,U
	LDA #$77
	LDX #$6677
	PSHU D,X,Y
	LEAU -34,U

	LDD #$3333
	STD -8,U
	LDX #$2233
	LDY #$3333
	PSHU D,X,Y
	LEAU -34,U

	LDD #$2222
	STD -8,U
	LDX #$2722
	LDY #$2222
	PSHU D,X,Y
	LEAU -34,U

	LDD #$1111
	STD -8,U
	LDA #$21
	LDX #$1111
	LDY #$1111
	PSHU D,X,Y
	LEAU -34,U

	LDD #$0100
	STD -8,U
	LDD #$2010
	LDX #$0000
	LDY #$0101
	PSHU D,X,Y
	LEAU -34,U

	LDD #$0100
	STD -8,U
	LDD #$2010
	LDY #$1100
	PSHU D,X,Y
	LEAU -34,U

	LDD #$0011
	STD -8,U
	LDD #$2010
	LDX #$0110
	PSHU D,X,Y
	LEAU -34,U

	LDD #$0001
	STD -8,U
	LDD #$2010
	LDY #$0100
	PSHU D,X,Y
	LEAU -34,U

	LDD #$0111
	STD -8,U
	LDD #$2010
	LDX #$0111
	LDY #$1100
	PSHU D,X,Y
	LEAU -34,U

	LDD #$0100
	STD -8,U
	LDD #$2010
	LDX #$0000
	LDY #$0101
	PSHU D,X,Y
	RTS

(info)

