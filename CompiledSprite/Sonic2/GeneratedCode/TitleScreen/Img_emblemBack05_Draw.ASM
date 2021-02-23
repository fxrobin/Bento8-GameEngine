(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemBack05
	STS SSAV_Img_emblemBack05+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS -1436,S

	LDA #$99
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
	LDU #$999e
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDU #$999c
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDU #$99ed
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$e9
	STA -8,S
	LDA #$99
	LDU #$99cd
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ce
	STA -8,S
	LDA #$99
	LDU #$99de
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$dc
	STA -8,S
	LDA #$99
	LDU #$99dc
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$dd
	STA -8,S
	LDA #$99
	LDU #$9ee8
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ed
	STA -8,S
	LDA #$99
	LDU #$ecc8
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$0e
	STA -8,S
	LDA #$e9
	LDU #$cd88
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$80
	STA -8,S
	LDA #$ce
	LDU #$dd88
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$88
	STA -8,S
	LDA #$dc
	LDY #$999e
	LDU #$de81
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$88
	STA -8,S
	LDA #$ed
	LDX #$ee99
	LDY #$99ec
	LDU #$e08c
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$88
	STA -8,S
	LDA #$0e
	LDX #$ccee
	LDY #$eecd
	LDU #$088c
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$88
	STA -8,S
	LDA #$80
	LDX #$ddcc
	LDY #$ccde
	LDU #$888e
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$88
	STA -8,S
	LDX #$eedd
	LDY #$dde0
	LDU #$881c
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$00ee
	LDY #$ee08
	LDU #$8888
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$8800
	LDY #$0088
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$8888
	LDY #$8888
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$8188
	LDU #$8886
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$8c88
	LDY #$8881
	LDU #$8867
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$68
	STA -8,S
	LDA #$88
	LDX #$1c88
	LDY #$888c
	LDU #$8877
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$76
	STA -8,S
	LDA #$88
	LDX #$e888
	LDY #$881c
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$77
	STA -8,S
	LDA #$88
	LDX #$e188
	LDY #$88ee
	LDU #$867e
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$d7
	STA -8,S
	LDA #$68
	LDX #$cc88
	LDY #$88ec
	LDU #$67ec
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ed
	STA -8,S
	LDA #$76
	LDX #$e888
	LDY #$88e8
	LDU #$77cd
	PSHS A,X,Y,U
DYN_POS

	LDS #$0000
	LEAS -1436,S

	LDA #$99
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

	LDA #$e9
	STA -8,S
	LDA #$99
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$c9
	STA -8,S
	LDA #$99
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$de
	STA -8,S
	LDA #$99
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$dc
	STA -8,S
	LDA #$99
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$dd
	STA -8,S
	LDA #$99
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ed
	STA -8,S
	LDA #$99
	LDU #$999e
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ce
	STA -8,S
	LDA #$99
	LDU #$99ec
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$8c
	STA -8,S
	LDA #$e9
	LDU #$99cd
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$88
	STA -8,S
	LDA #$ce
	LDU #$99de
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$88
	STA -8,S
	LDA #$dc
	LDU #$9ed0
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$81
	STA -8,S
	LDA #$ed
	LDX #$e999
	LDU #$ece8
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$8c
	STA -8,S
	LDA #$0e
	LDX #$ce99
	LDU #$cd08
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$1c
	STA -8,S
	LDA #$80
	LDX #$dc99
	LDY #$99ee
	LDU #$dd88
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$e8
	STA -8,S
	LDA #$88
	LDX #$ddee
	LDY #$eecc
	LDU #$ee88
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$e1
	STA -8,S
	LDA #$88
	LDX #$eecc
	LDY #$ccdd
	LDU #$0088
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$cc
	STA -8,S
	LDA #$88
	LDX #$00dd
	LDY #$ddde
	LDU #$8888
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$e8
	STA -8,S
	LDA #$88
	LDX #$88ee
	LDY #$eee0
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$c8
	STA -8,S
	LDA #$88
	LDX #$8800
	LDY #$0008
	PSHS A,X,Y,U
	LEAS -33,S

	STA -8,S
	LDX #$8888
	LDY #$8888
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$68
	STA -8,S
	LDA #$88
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$76
	STA -8,S
	LDA #$88
	LDX #$1888
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$77
	STA -8,S
	LDA #$88
	LDX #$c888
	LDY #$8881
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$77
	STA -8,S
	LDA #$88
	LDX #$c188
	LDY #$888c
	LDU #$8886
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$d7
	STA -8,S
	LDA #$68
	LDX #$8e88
	LDU #$8867
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ed
	STA -8,S
	LDA #$76
	LDX #$1e88
	LDY #$888e
	LDU #$8877
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$ce
	STA -8,S
	LDA #$77
	LDX #$cc88
	LDY #$881c
	LDU #$1677
	PSHS A,X,Y,U
	LEAS -33,S

	LDA #$dc
	STA -8,S
	LDA #$77
	LDX #$6e88
	LDY #$8888
	LDU #$677e
	PSHS A,X,Y,U
SSAV_Img_emblemBack05
	LDS #$0000
	RTS

(info)

