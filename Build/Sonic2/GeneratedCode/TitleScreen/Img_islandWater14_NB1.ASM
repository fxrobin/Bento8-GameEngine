(main)IMGD.ASM
	ORG $A000
	SETDP $FF
BCKDRAW_Img_islandWater14
	STS SSAV_Img_islandWater14+1,PCR

	STD DYN_POS+1,PCR
	LEAS ,U
	LDU ,Y
	LEAU 1195,U

	LDD ,U
	PSHS U,D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD ,U
DYN_POS

	LDU #$0000
	LEAU ,S
SSAV_Img_islandWater14
	LDS #$0000
	RTS

(info)

