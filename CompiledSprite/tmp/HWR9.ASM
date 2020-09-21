(main)IMG.ASM
	ORG $E8BE
DRAW_HWR9
	PSHS U,DP
	STS SSAV_HWR9+2

	LDS $9F00
	STS ERASE_POS_HWR9_1+2
	LDU #ERASE_DATA_HWR9_2
	LEAS 443,S
	LDD -81,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0aa0
	STD -81,S

	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$d2
	STD 79,S

	LDA 81,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 81,S

	LDD -41,S
	PSHU D,S

	LDD -1,S
	PSHU D

	LDD 39,S
	PSHU D

	LDD #$ccaa
	STD -41,S

	LDD #$dcad
	STD -1,S

	LDD #$ddc2
	STD 39,S

	LEAS 239,S
	LDD -119,S
	PSHU D
	LDA #$d2
	ANDB #$0F
	ORB #$a0
	STD -119,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$d2
	STD -80,S

	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -78,S

	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA -38,S

	LDD -40,S
	PSHU D

	LDD #$ccda
	STD -40,S

	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$aaac
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dc
	LDX #$baca
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dc
	LDX #$aa0c
	PSHS A,X

	LEAS 40,S
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 39,S

	LDD 41,S
	PSHU D
	LDA #$aa
	ANDB #$0F
	ORB #$90
	STD 41,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD 80,S

	LDA 82,S
	PSHU A

	LDA #$9a
	STA 82,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$aaac
	PSHS A,X

	LEAS 120,S
	PULS A,X
	PSHU A,X,S
	LDX #$c229
	PSHS B,X

	LEAS 40,S
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 42,S

	LDD 40,S
	PSHU D

	LDD #$dd32
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$cc
	LDX #$3220
	PSHS A,X

	LEAS 80,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$d2ba
	PSHS A,X

	LEAS 40,S
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$0d
	STD 39,S

	LDD 41,S
	PSHU D
	ANDA #$0F
	ORA #$10
	LDB #$bb
	STD 41,S

	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$dd
	STD 79,S

	LDD 81,S
	PSHU D

	LDD #$33ba
	STD 81,S

	PULS A,X
	PSHU A,X,S
	LDA #$d0
	LDX #$01ba
	PSHS A,X

	LEAS 119,S
	LDA 4,S
	PSHU A
	ANDA #$F0
	ORA #$01
	STA 4,S

	PULS D,X
	PSHU D,X,S
	LDD #$a9dd
	LDX #$11aa
	PSHS D,X

	LEAS 40,S
	LDD 3,S
	PSHU D
	ANDA #$0F
	ORA #$90
	LDB #$10
	STD 3,S

	PULS A,X
	PSHU A,X,S
	LDA #$aa
	LDX #$dd2e
	PSHS A,X

	LEAS 40,S
	LDD 3,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$01
	STD 3,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$09d0
	STD 40,S

	LDA 44,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 44,S

	LDD 81,S
	PSHU D
	LDA #$bc
	ANDB #$0F
	ORB #$d0
	STD 81,S

	LDD 83,S
	PSHU D
	LDA #$ae
	ANDB #$0F
	ORB #$10
	STD 83,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$cc
	STD 120,S

	LDD 123,S
	PSHU D
	LDA #$a1
	ANDB #$0F
	ORB #$10
	STD 123,S

	LDD 42,S
	PSHU D

	LDD #$1daa
	STD 42,S

	PULS A,X
	PSHU A,X,S
	LDA #$99
	LDX #$dd31
	PSHS A,X

	LEAS 280,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$dd
	STD -120,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0fb0
	STD -80,S

	LDD -40,S
	PSHU D
	LDA #$bf
	ANDB #$0F
	ORB #$90
	STD -40,S

	LDA 83,S
	PSHU A
	ANDA #$F0
	ORA #$00
	STA 83,S

	LDA -117,S
	PSHU A

	LDA -77,S
	PSHU A

	LDA -37,S
	PSHU A

	LDA ,S
	PSHU A

	LDA 3,S
	PSHU A

	LDA 40,S
	PSHU A

	LDA 43,S
	PSHU A

	LDA 80,S
	PSHU A,S

	LDA 120,S
	PSHU A

	LDA #$91
	STA -117,S

	LDA #$bb
	STA ,S

	LDA #$e0
	STA 3,S

	LDA #$fb
	STA 40,S

	LDA #$00
	STA 43,S

	LDA #$2a
	STA 80,S

	LDA #$f1
	STA 120,S

	LDA #$e1
	STA -77,S

	STA -37,S

	LEAS 180,S
	LDA 20,S
	PSHU A,S
	ANDA #$0F
	ORA #$10
	STA 20,S

	LDA -20,S
	PSHU A

	LDA #$fe
	STA -20,S


	LDS $9F00+2
	STS ERASE_POS_HWR9_2+2
	LDU #ERASE_DATA_HWR9_END

	LEAS 481,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -40,S

	LDA -119,S
	PSHU A

	LDA -79,S
	PSHU A

	LDA -38,S
	PSHU A

	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDA #$dd
	STA -38,S

	LDD #$ccaa
	STD 121,S

	STB -119,S

	STB -79,S

	LDD #$dc3a
	STD 41,S

	STD 81,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$dcda
	PSHS A,X

	LEAS 280,S
	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -80,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$cc
	STD -40,S

	LDD -119,S
	PSHU D

	LDA -78,S
	PSHU A

	LDA -38,S
	PSHU A

	LDD #$ccad
	STD -119,S

	LDA #$cb
	STA -78,S

	STA -38,S

	PULS A,X
	PSHU A,X,S
	LDA #$cd
	LDX #$ccab
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$ccab
	PSHS A,X

	LEAS 40,S
	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDD #$dcb2
	STD 121,S

	LDD #$cccb
	STD 81,S

	STX 41,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$ccab
	PSHS A,X

	LEAS 280,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dd
	STD -120,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$0d
	STD -80,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$d0
	STD -40,S

	LDA -118,S
	PSHU A

	LDA -78,S
	PSHU A

	LDA -38,S
	PSHU A

	LDA #$3a
	STA -38,S

	LDA #$2a
	STA -118,S

	STA -78,S

	PULS A,X
	PSHU A,X,S
	LDA #$dd
	LDX #$d1ab
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$da
	LDX #$c2ab
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$99
	LDX #$d2aa
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X,S
	LDA #$09
	LDX #$d2a9
	PSHS A,X

	LEAS 40,S
	LDA 3,S
	PSHU A
	ANDA #$F0
	ORA #$01
	STA 3,S

	LDD 42,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$a1
	STD 42,S

	LDD 82,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$a0
	STD 82,S

	LDD 120,S
	PSHU D
	LDA #$a0
	ANDB #$0F
	ORB #$d0
	STD 120,S

	LDD 122,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$ae
	STD 122,S

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$facd
	STD 80,S

	LDA #$f1
	STD 40,S

	PULS A,X
	PSHU A,X,S
	LDA #$ac
	LDX #$c10d
	PSHS A,X

	LEAS 280,S
	LDD -118,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$0e
	STD -118,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 3,S

	LDA 43,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 43,S

	LDA 80,S
	PSHU A
	ANDA #$0F
	ORA #$a0
	STA 80,S

	LDD 119,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0f00
	STD 119,S

	LDA -120,S
	PSHU A

	LDA -80,S
	PSHU A

	LDA -77,S
	PSHU A

	LDA -40,S
	PSHU A

	LDA -37,S
	PSHU A

	LDA ,S
	PSHU A,S

	LDA 40,S
	PSHU A

	LDA #$a0
	STA -120,S

	LDA #$aa
	STA -80,S

	LDA #$ee
	STA -77,S

	LDA #$9a
	STA -40,S

	LDA #$e1
	STA -37,S

	LDA #$1e
	STA ,S

	LDA #$a9
	STA 40,S

	LEAS 199,S
	LDA -40,S
	PSHU A
	ANDA #$F0
	ORA #$0f
	STA -40,S

	LDA ,S
	PSHU A,S
	ANDA #$F0
	ORA #$0f
	STA ,S

	LDA 40,S
	PSHU A
	ANDA #$F0
	ORA #$01
	STA 40,S

SSAV_HWR9
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_HWR9
	PSHS U,DP
	STS ERASE_SSAV_HWR9+2

ERASE_POS_HWR9_1
	LDS #$0000
	LDU #ERASE_DATA_HWR9_1

ERASE_CODE_HWR9_1
	PULU A,B,S
	STA -20,S
	STB 20,S

	PULU A,B,S
	STA 120,S
	STB 80,S

	PULU A,B
	STA 43,S
	STB 40,S

	PULU A,B
	STA 3,S
	STB ,S

	PULU A,B
	STA -37,S
	STB -77,S

	PULU A,B,X,Y
	STA -117,S
	STB 83,S
	STX -40,S
	STY -80,S

	PULU D
	STD -120,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 42,S
	STX 123,S
	STY 120,S

	PULU D,X
	STD 83,S
	STX 81,S

	PULU A,X,Y
	STA 44,S
	STX 40,S
	STY 3,S

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 3,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 4,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 81,S
	STX 79,S
	STY 41,S

	PULU D
	STD 39,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D
	STD 40,S

	PULU A
	STA 42,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,X,Y
	STA 82,S
	STX 80,S
	STY 41,S

	PULU D
	STD 39,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU D
	STD -40,S

	PULU A,B,X,Y
	STA -38,S
	STB -78,S
	STX -80,S
	STY -119,S

	PULU D,X,Y,S
	STD 39,S
	STX -1,S
	STY -41,S

	PULU A,X,Y
	STA 81,S
	STX 79,S
	STY -81,S

ERASE_POS_HWR9_2
	LDS #$0000
	LDU #ERASE_DATA_HWR9_2

ERASE_CODE_HWR9_2
	PULU A,B,S
	STA 40,S
	STB ,S

	PULU A
	STA -40,S

	PULU A,B,S
	STA 40,S
	STB ,S

	PULU A,B
	STA -37,S
	STB -40,S

	PULU A,B
	STA -77,S
	STB -80,S

	PULU A,X
	STA -120,S
	STX 119,S

	PULU A,B
	STA 80,S
	STB 43,S

	PULU A,X
	STA 3,S
	STX -118,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 80,S
	STX 40,S
	STY 122,S

	PULU D,X,Y
	STD 120,S
	STX 82,S
	STY 42,S

	PULU A
	STA 3,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,B
	STA -38,S
	STB -78,S

	PULU A,X,Y
	STA -118,S
	STX -40,S
	STY -80,S

	PULU D
	STD -120,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 121,S
	STX 81,S
	STY 41,S

	PULU B,X,S
	PSHS B,X

	PULU B,X,S
	PSHS B,X

	PULU A,B,X,Y
	STA -38,S
	STB -78,S
	STX -119,S
	STY -40,S

	PULU D
	STD -80,S

	PULU B,X,S
	PSHS B,X

	PULU D,X,Y
	STD 121,S
	STX 81,S
	STY 41,S

	PULU A,B
	STA -38,S
	STB -79,S

	PULU A,X
	STA -119,S
	STX -40,S

ERASE_SSAV_HWR9
	LDS #$0000
	PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)

ERASE_DATA_HWR9_1
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FCB $00
ERASE_DATA_HWR9_2
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FDB $0000
	FCB $00
ERASE_DATA_HWR9_END
