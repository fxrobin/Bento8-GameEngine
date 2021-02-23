(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_emblemBack01
	STS SSAV_Img_emblemBack01+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS -1013,S

	LDA 120,S
	ANDA #$F0
	ORA #$01
	STA 120,S
	LDA 80,S
	ANDA #$F0
	ORA #$0e
	STA 80,S
	LDA #$1d
	STA 40,S
	LDA #$ec
	STA ,S
	LDA #$dc
	STA -40,S
	LDA #$cc
	STA -80,S
	LDA #$c0
	STA -120,S
	LEAS -280,S

	STA 120,S
	LDD 39,S
	ANDA #$F0
	ORA #$01
	LDB #$00
	STD 39,S
	LDD -1,S
	ANDA #$F0
	ORA #$01
	LDB #$00
	STD -1,S
	LDD -41,S
	ANDA #$F0
	ORA #$0e
	LDB #$00
	STD -41,S
	STB 80,S
	LDD #$1d00
	STD -81,S
	STD -121,S
	LEAS -280,S

	LDA #$ec
	STD 119,S
	LDA #$dc
	STD 79,S
	STD 39,S
	LDA #$c0
	STD -1,S
	LDB #$cc
	STD -41,S
	LDD -81,S
	LDA #$cc
	ANDB #$0F
	ORB #$10
	STD -81,S
	LDD -121,S
	LDA #$cd
	ANDB #$F0
	ORB #$01
	STD -121,S
	LEAS -280,S

	LDA #$ed
	STA 80,S
	LDA #$dc
	STA 40,S
	LDA #$cc
	STA ,S
	LDA #$c0
	STA -40,S
	LDD -81,S
	ANDA #$F0
	ORA #$01
	LDB #$00
	STD -81,S
	LDA #$1e
	STA 120,S
	STD -121,S
	LEAS -220,S

	LDA #$ed
	STD 59,S
	LDA #$dc
	STD 19,S
	LDA #$cc
	STD -21,S
	LDA #$c0
	STD -61,S
	LEAS -219,S

	LDA #$00
	STD 118,S
	STD 78,S
	STD 38,S
	LDA 77,S
	ANDA #$F0
	ORA #$01
	STA 77,S
	LDA 37,S
	ANDA #$F0
	ORA #$0e
	STA 37,S
	LDA #$1d
	LDX #$0000
	PSHS A,X
	LEAS -37,S

	LDA #$ec
	PSHS A,X
	LEAS -37,S

	LDA #$dc
	PSHS A,X
	LEAS -37,S

	LDA #$c0
	PSHS A,X
	LEAS -37,S

	PSHS A,X
	LEAS -37,S

	PSHS A,X
	LEAS -37,S

	PSHS B,X
	LEAS -37,S

	LDA -4,S
	ANDA #$F0
	ORA #$01
	STA -4,S
	PSHS B,X
	LEAS -37,S

	LDA -4,S
	ANDA #$F0
	ORA #$0e
	STA -4,S
	PSHS B,X
	LEAS -37,S

	LDA -4,S
	ANDA #$F0
	ORA #$0e
	STA -4,S
	PSHS B,X
	LEAS -37,S

	LDD #$1d00
	LDX #$000c
	PSHS D,X
	LEAS -36,S

	LDD -42,S
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD -42,S
	LDD #$ec00
	STD -44,S
	LDX #$00ce
	PSHS D,X
	LEAS -77,S

	LDA #$dc
	LDX #$00cc
	PSHS A,X
	LEAS -37,S

	LDD #$c00c
	STD -43,S
	LDB #$cd
	STD -83,S
	LDD -123,S
	LDA #$c0
	ANDB #$0F
	ORB #$e0
	STD -123,S
	LDA #$dc
	LDX #$00d1
	PSHS A,X
	LEAS -180,S

	LDA #$cc
	STA 20,S
	LDA #$ce
	STA -20,S
DYN_POS

	LDS #$0000
	LEAS -1173,S

	LDA 120,S
	ANDA #$F0
	ORA #$01
	STA 120,S
	LDA 80,S
	ANDA #$F0
	ORA #$0e
	STA 80,S
	LDA 40,S
	ANDA #$F0
	ORA #$0e
	STA 40,S
	LDA #$1d
	STA ,S
	LDA #$ec
	STA -40,S
	LDA #$dc
	STA -80,S
	STA -120,S
	LEAS -280,S

	LDA #$c0
	STA 120,S
	STA 80,S
	STA 40,S
	LDD -41,S
	ANDA #$F0
	ORA #$01
	LDB #$00
	STD -41,S
	LDD -81,S
	ANDA #$F0
	ORA #$01
	LDB #$00
	STD -81,S
	LDD -121,S
	ANDA #$F0
	ORA #$0e
	LDB #$00
	STD -121,S
	STB ,S
	LEAS -280,S

	LDD 119,S
	ANDA #$F0
	ORA #$0e
	LDB #$0c
	STD 119,S
	LDD #$1dcd
	STD 79,S
	LDD 39,S
	LDA #$1d
	ANDB #$0F
	ORB #$10
	STD 39,S
	LDA #$ee
	STA -1,S
	LDA -80,S
	ANDA #$F0
	ORA #$01
	STA -80,S
	LDA #$1e
	STA -120,S
	LEAS -280,S

	LDA #$ed
	STA 120,S
	LDA #$dc
	STA 80,S
	LDD -41,S
	ANDA #$F0
	ORA #$01
	LDB #$00
	STD -41,S
	LDD -81,S
	ANDA #$F0
	ORA #$0e
	LDB #$00
	STD -81,S
	LDA #$cc
	STA 40,S
	LDA #$c0
	STA ,S
	LDA #$1d
	STD -121,S
	LEAS -220,S

	LDA #$ec
	STD 59,S
	LDA #$dc
	STD 19,S
	LDA #$c0
	STD -21,S
	STD -61,S
	LEAS -219,S

	LDA #$00
	STD 118,S
	STD 78,S
	STD 38,S
	LDA 77,S
	ANDA #$F0
	ORA #$01
	STA 77,S
	LDA 37,S
	ANDA #$F0
	ORA #$0e
	STA 37,S
	LDA #$1d
	LDX #$0000
	PSHS A,X
	LEAS -37,S

	PSHS A,X
	LEAS -37,S

	LDA #$ec
	PSHS A,X
	LEAS -37,S

	LDA #$dc
	PSHS A,X
	LEAS -37,S

	LDA #$c0
	PSHS A,X
	LEAS -37,S

	PSHS A,X
	LEAS -37,S

	PSHS A,X
	LEAS -37,S

	LDX #$000c
	PSHS B,X
	LEAS -37,S

	LDD -42,S
	LDA #$00
	ANDB #$0F
	ORB #$e0
	STD -42,S
	LDD -44,S
	ANDA #$F0
	ORA #$01
	LDB #$00
	STD -44,S
	STX -83,S
	LDA -84,S
	ANDA #$F0
	ORA #$01
	STA -84,S
	LDA -124,S
	ANDA #$F0
	ORA #$0e
	STA -124,S
	LDD #$00ce
	STD -123,S
	LDX #$00cd
	PSHS A,X
	LEAS -240,S

	LDD 80,S
	LDA #$00
	ANDB #$0F
	ORB #$10
	STD 80,S
	LDA 79,S
	ANDA #$F0
	ORA #$0e
	STA 79,S
	LDD 39,S
	ANDA #$F0
	ORA #$0e
	LDB #$cc
	STD 39,S
	LDD #$1dd1
	STD -1,S
	STA -41,S
	LDA #$ee
	STA -81,S
SSAV_Img_emblemBack01
	LDS #$0000
	RTS

(info)

