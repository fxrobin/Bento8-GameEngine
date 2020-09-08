(main) HIR0.ASM
	ORG $CC24
DRAW_HIR0
	PSHS U,DP
	STS SSAV_HIR0+2

	LDS $9F00
	STS ERASE_POS_HIR0_1+2
	LDU #DATA_HIR0_1

 	LEAS 482,S
	LDD -41,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$cc
	STD -41,S

	LDA -39,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -39,S

	LDA -120,S
	PSHU A

	LDA -80,S
	PSHU A

	LDD 0,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD 120,S
	PSHU D

	LDA #$cc
	STA -120,S

	STA -80,S

	LDD #$ddac
	STD 0,S

	LDB #$aa
	STD 40,S

	STD 80,S

	LDA #$cd
	STD 120,S

	LEAS 160,S
	LDD 0,S
	PSHU D

	LDD #$dcca
	STD 0,S

	LEAS 159,S
	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dc
	STD -80,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dc
	STD -40,S

	LDA 123,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 123,S

	PULS A,X
	PSHU A,X
	LDA #$dd
	LDX #$dcbb
	PSHS A,X

	LDD -119,S
	PSHU D

	LDA -78,S
	PSHU A

	LDA -38,S
	PSHU A

	LDD 41,S
	PSHU D

	LDD 81,S
	PSHU D

	LDD 121,S
	PSHU D

	LDD #$dcbc
	STD -119,S

	LDA #$ba
	STA -78,S

	LDA #$bb
	STA -38,S

	STX 41,S

	STX 81,S

	LDD #$ddab
	STD 121,S

	LEAS 281,S
	LDA -118,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA -118,S

	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$dd
	STD -1,S

	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$32
	STD 80,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDA 1,S
	PSHU A

	LDD 40,S
	PSHU D

	LDD 120,S
	PSHU D

	LDD #$dd2b
	STD -120,S

	LDB #$22
	STD -80,S

	LDA #$d0
	STD -40,S

	LDA #$33
	STA 1,S

	LDD #$dd0e
	STD 40,S

	LDD #$c222
	STD 120,S

	LEAS 280,S
	LDD 80,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$0a0d
	STD 80,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$090d
	STD 120,S

	LDD -120,S
	PSHU D

	LDD -80,S
	PSHU D

	LDD -40,S
	PSHU D

	LDD 0,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD #$2322
	STD -120,S

	LDA #$2d
	STD -80,S

	LDD #$3b13
	STD -40,S

	LDD #$eadd
	STD 0,S

	LDD #$d9d0
	STD 40,S

	LEAS 241,S
	LDA -80,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA -80,S

	LDA -40,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA -40,S

	LDA 0,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA 0,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$9a
	STD 39,S

	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$09
	STD 79,S

	LEAS 239,S
	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$aa
	STD -120,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$b0
	STD -80,S

	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA -38,S

	PULS A,X
	PSHU A,X
	LDA #$e1
	LDX #$ffe1
	PSHS A,X

	LDD -40,S
	PSHU D

	LDD #$e1f2
	STD -40,S

	LEAS 40,S
	PULS A,X
	PSHU A,X
	LDA #$e0
	LDX #$ee00
	PSHS A,X

	LDS $9F00+2
	STS ERASE_POS_HIR0_2+2
	LDU #DATA_HIR0_2
 
	LEAS 442,S
	LDA -80,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA -80,S

	LDA 1,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA 1,S

	LDA 41,S
	PSHU A
	ANDA #$F0
	ORA #$0d
	STA 41,S

	LDD -41,S
	PSHU D

	LDD -1,S
	PSHU D

	LDD 39,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$ccac
	STD -41,S

	LDD #$ddda
	STD -1,S

	LDB #$3a
	STD 39,S

	LDD #$2dcd
	STD 80,S

	LEAS 239,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$aa
	STD -40,S

	PULS A,X
	PSHU A,X
	LDA #$cc
	LDX #$aaaa
	PSHS A,X

	LDD -119,S
	PSHU D

	LDD -79,S
	PSHU D

	LDA -38,S
	PSHU A

	LDD #$21ad
	STD -119,S

	LDD #$2aac
	STD -79,S

	STB -38,S

	LEAS 40,S
	PULS A,X
	PSHU A,X
	LDA #$dd
	LDX #$aaaa
	PSHS A,X

	LEAS 40,S
	PULS A,X
	PSHU A,X
	LDA #$dd
	LDX #$aacc
	PSHS A,X

	LEAS 40,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ca
	STD 40,S

	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$c2
	STD 120,S

	PULS A,X
	PSHU A,X
	LDA #$dd
	LDX #$aa0c
	PSHS A,X

	LDA 42,S
	PSHU A

	LDD 81,S
	PSHU D

	LDA 122,S
	PSHU A

	LDA #$00
	STA 42,S

	LDD #$cc00
	STD 81,S

	LDA #$ba
	STA 122,S

	LEAS 160,S
	PULS A,X
	PSHU A,X
	LDA #$cc
	LDX #$3220
	PSHS A,X

	LEAS 40,S
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$30
	STA 42,S

	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$10
	STA 82,S

	PULS A,X
	PSHU A,X
	LDA #$cd
	LDX #$3221
	PSHS A,X

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDA 121,S
	PSHU A

	LDD #$ddd2
	STD 40,S

	LDB #$d1
	STD 80,S

	LDA #$0d
	STA 121,S

	LEAS 282,S
	LDD -121,S
	PSHU D
	LDA #$21
	ANDB #$0F
	ORB #$10
	STD -121,S

	LDD -81,S
	PSHU D
	LDA #$1d
	ANDB #$0F
	ORB #$30
	STD -81,S

	LDD -41,S
	PSHU D
	LDA #$0d
	ANDB #$0F
	ORB #$20
	STD -41,S

	LDD -1,S
	PSHU D
	LDA #$ad
	ANDB #$0F
	ORB #$30
	STD -1,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$bb
	STD 38,S

	LDA 40,S
	PSHU A
	ANDA #$0F
	ORA #$00
	STA 40,S

	LDD 78,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$bb
	STD 78,S

	LDD 118,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ba
	STD 118,S

	LDA 80,S
	PSHU A

	LDA 120,S
	PSHU A

	LDA #$9a
	STA 80,S

	STA 120,S

	LEAS 279,S
	LDD -121,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$aa
	STD -121,S

	LDD -80,S
	PSHU D
	LDA #$ad
	ANDB #$0F
	ORB #$90
	STD -80,S

	LDD -40,S
	PSHU D
	LDA #$9d
	ANDB #$0F
	ORB #$90
	STD -40,S

	LDA 0,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 0,S

	LDA 40,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 40,S

	LDD 80,S
	PSHU D
	LDA #$bb
	ANDB #$0F
	ORB #$a0
	STD 80,S

	LDD 120,S
	PSHU D
	LDA #$aa
	ANDB #$0F
	ORB #$a0
	STD 120,S

	LDA -119,S
	PSHU A

	LDA #$a9
	STA -119,S

	LEAS 240,S
	LDD -80,S
	PSHU D
	LDA #$a1
	ANDB #$0F
	ORB #$10
	STD -80,S

	LDD -40,S
	PSHU D

	LDD 0,S
	PSHU D

	LDD 40,S
	PSHU D

	LDD 80,S
	PSHU D

	LDD #$1a9a
	STD -40,S

	LDD #$aa0e
	STD 0,S

	LDD #$aff1
	STD 40,S

	LDD #$0eee
	STD 80,S

SSAV_HIR0
    LDS #$0000
    PULS DP,U,PC

DATA_HIR0_2
DATA_HIR0_1
ERASE_HIR0
    PSHS U,DP
    STS ERASE_SSAV_HIR0+2

ERASE_POS_HIR0_1
       LDS #$0000
       LDU #ERASE_DATA_HIR0_1
ERASE_CODE_HIR0_1
    LEAS -1,S
    LDA #$e0
    LDX #$ee00
    PSHS X,A
    LEAS -37,S
    LDA #$e1
    LDX #$ffe1
    PSHS X,A
    LDA #$10
    STA -38,S
    LDX #$e1f2
    STX -40,S
    LDA #$b0
    STA -79,S
    LDA #$01
    STA -80,S
    LDA #$aa
    STA -119,S
    LDA #$00
    STA -120,S
    LEAS -158,S
    LDA #$09
    STA -1,S
    LDA #$09
    STA -2,S
    LDA #$9a
    STA -41,S
    LDA #$0a
    STA -42,S
    LDA #$0d
    STA -81,S
    LDA #$0d
    STA -121,S
    LEAS -161,S
    LDA #$0d
    STA ,S
    LDA #$0d
    STA -40,S
    LDA #$09
    STA -41,S
    LDA #$0d
    STA -80,S
    LDA #$0a
    STA -81,S
    LDX #$d9d0
    STX -121,S
    LEAS -159,S
    LDX #$eadd
    STX -2,S
    LDX #$3b13
    STX -42,S
    LDX #$2d22
    STX -82,S
    LDX #$2322
    STX -122,S
    LEAS -160,S
    LDX #$c222
    STX -2,S
    LDA #$32
    STA -41,S
    LDA #$0d
    STA -42,S
    LDX #$dd0e
    STX -82,S
    LDX #$dd33
    STX -122,S
    LDA #$0c
    STA -123,S
    LEAS -160,S
    LDX #$d022
    STX -2,S
    LDX #$dd22
    STX -42,S
    LDA #$00
    STA -80,S
    LDX #$dd2b
    STX -82,S
    LDA #$00
    STA -120,S
    LDX #$ddab
    STX -122,S
    LEAS -160,S
    LDX #$dcbb
    STX -2,S
    LDX #$dcbb
    STX -42,S
    LEAS -80,S
    LDA #$dd
    LDX #$dcbb
    PSHS X,A
    LDX #$dcbb
    STX -39,S
    LDA #$0d
    STA -40,S
    LDX #$dcba
    STX -79,S
    LDA #$0c
    STA -80,S
    LDX #$dcbc
    STX -119,S
    LEAS -157,S
    LDX #$dcca
    STX -2,S
    LDX #$cdaa
    STX -42,S
    LDX #$ddaa
    STX -82,S
    LDX #$ddaa
    STX -122,S
    LEAS -160,S
    LDX #$ddac
    STX -2,S
    LDA #$c0
    STA -41,S
    LDA #$cc
    STA -42,S
    LDA #$0d
    STA -43,S
    LDA #$cc
    STA -82,S
    LDA #$cc
    STA -122,S
    LEAS -483,S

ERASE_POS_HIR0_2
    LDS #$0000
    LDU #ERASE_DATA_HIR0_2
ERASE_CODE_HIR0_2
    LEAS -2,S
    LDX #$0eee
    STX -2,S
    LDX #$aff1
    STX -42,S
    LDX #$aa0e
    STX -82,S
    LDX #$1a9a
    STX -122,S
    LEAS -161,S
    LDA #$10
    STA ,S
    LDA #$a1
    STA -1,S
    LDA #$a0
    STA -40,S
    LDA #$aa
    STA -41,S
    LDA #$a0
    STA -80,S
    LDA #$bb
    STA -81,S
    LDA #$d0
    STA -121,S
    LEAS -161,S
    LDA #$d0
    STA ,S
    LDA #$90
    STA -39,S
    LDA #$9d
    STA -40,S
    LDA #$90
    STA -79,S
    LDA #$ad
    STA -80,S
    LDX #$aaa9
    STX -120,S
    LDA #$0d
    STA -121,S
    LEAS -158,S
    LDX #$ba9a
    STX -2,S
    LDA #$0d
    STA -3,S
    LDX #$bb9a
    STX -42,S
    LDA #$0d
    STA -43,S
    LDA #$00
    STA -81,S
    LDA #$bb
    STA -82,S
    LDA #$0c
    STA -83,S
    LDA #$30
    STA -121,S
    LDA #$ad
    STA -122,S
    LEAS -161,S
    LDA #$20
    STA ,S
    LDA #$0d
    STA -1,S
    LDA #$30
    STA -40,S
    LDA #$1d
    STA -41,S
    LDA #$10
    STA -80,S
    LDA #$21
    STA -81,S
    LDA #$0d
    STA -121,S
    LEAS -160,S
    LDA #$10
    STA ,S
    LDX #$ddd1
    STX -2,S
    LDA #$30
    STA -40,S
    LDX #$ddd2
    STX -42,S
    LEAS -79,S
    LDA #$cd
    LDX #$3221
    PSHS X,A
    LEAS -37,S
    LDA #$cc
    LDX #$3220
    PSHS X,A
    LDX #$c2ba
    STX -39,S
    LDA #$0c
    STA -40,S
    LDX #$cc00
    STX -79,S
    LDX #$ca00
    STX -119,S
    LDA #$0d
    STA -120,S
    LEAS -157,S
    LDA #$dd
    LDX #$aa0c
    PSHS X,A
    LEAS -37,S
    LDA #$dd
    LDX #$aacc
    PSHS X,A
    LEAS -37,S
    LDA #$dd
    LDX #$aaaa
    PSHS X,A
    LEAS -37,S
    LDA #$cc
    LDX #$aaaa
    PSHS X,A
    LDX #$aaac
    STX -39,S
    LDA #$0c
    STA -40,S
    LDX #$2aac
    STX -79,S
    LDX #$21ad
    STX -119,S
    LEAS -157,S
    LDX #$2dcd
    STX -2,S
    LDA #$0d
    STA -41,S
    LDX #$dd3a
    STX -43,S
    LDA #$0d
    STA -81,S
    LDX #$ddda
    STX -83,S
    LDX #$ccac
    STX -123,S
    LEAS -162,S
    LDA #$c0
    STA ,S
    LEAS -396,S

ERASE_SSAV_HIR0
	LDS #$0000
	PULS DP,U,PC

ERASE_DATA_HIR0_2
ERASE_DATA_HIR0_1
