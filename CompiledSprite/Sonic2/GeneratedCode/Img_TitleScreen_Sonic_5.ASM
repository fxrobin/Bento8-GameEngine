(main)IMG.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_TitleScreen_Sonic_5
	STS SSAV_Img_TitleScreen_Sonic_5+2,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS 4299,S

	LDX -79,S
	LDY -39,S
	PSHU Y,X
	LDD #$ffff
	STD -39,S
	LDD #$cccc
	STD -79,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$f0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDX #$ffff
	PSHS B,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$ff3f
	LDX #$ffff
	PSHS D,X
	LEAS 40,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ff
	STD 39,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$ffff
	LDX #$ffff
	PSHS D,X
	LEAS 41,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$ff
	LDX #$ffff
	PSHS A,X
	LEAS 38,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$cffe
	LDX #$f3ff
	LDY #$fffc
	PSHS D,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ffff
	LDX #$f3ff
	LDY #$ffff
	PSHS D,X,Y
	LEAS 40,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ff
	STD 39,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$efef
	LDX #$63ff
	LDY #$ffff
	PSHS D,X,Y
	LEAS 41,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$ff
	STD 38,S
	LDA 5,S
	PSHU A
	ANDA #$0F
	ORA #$f0
	STA 5,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$e6
	LDX #$6fff
	LDY #$ffff
	PSHS A,X,Y
	LEAS 40,S

	LDA 5,S
	PSHU A
	ANDA #$0F
	ORA #$30
	STA 5,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$f6
	LDX #$6fff
	LDY #$fffc
	PSHS A,X,Y
	LEAS 38,S

	LDA 6,S
	PSHU A
	LDA #$cc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ceff
	LDX #$655f
	LDY #$fffc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$cc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$feff
	LDX #$655f
	LDY #$cfcc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$c3
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$efff
	LDX #$555f
	LDY #$cccc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	ANDA #$0F
	ORA #$30
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ffff
	LDX #$ff5f
	LDY #$cccc
	PSHS D,X,Y
	LEAS 39,S

	LDA 6,S
	PSHU A
	LDA #$cc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$33ff
	LDX #$ffff
	LDY #$5fcc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$cc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$33ff
	LDX #$ffff
	LDY #$5fcc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$cc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$3cff
	LDX #$ffff
	LDY #$5fcc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$c3
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$cfff
	LDX #$ffff
	LDY #$ffcc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	ANDA #$0F
	ORA #$30
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$cfff
	LDX #$ffff
	LDY #$ffcc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	ANDA #$0F
	ORA #$30
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ffff
	LDX #$ffff
	LDY #$ffc3
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	ANDA #$0F
	ORA #$30
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ffff
	LDX #$ffff
	LDY #$fff3
	PSHS D,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ffff
	LDX #$ffff
	LDY #$fffc
	PSHS D,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ffff
	LDX #$ffff
	LDY #$ffff
	PSHS D,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ffff
	LDX #$ffff
	LDY #$ffef
	PSHS D,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ffff
	LDX #$ff1c
	LDY #$ffef
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ffff
	LDX #$ff01
	LDY #$ffef
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$ff
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ffff
	LDX #$ffa0
	LDY #$ffef
	PSHS D,X,Y
	LEAS 40,S

	LDD 6,S
	PSHU D
	LDA #$ff
	ANDB #$0F
	ORB #$c0
	STD 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ffff
	LDX #$f0aa
	LDY #$ffef
	PSHS D,X,Y
	LEAS 40,S

	LDX 6,S
	PSHU X
	LDD #$fffc
	STD 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ffff
	LDX #$f0aa
	LDY #$ffff
	PSHS D,X,Y
	LEAS 40,S

	LDX 6,S
	PSHU X
	LDD #$ffff
	STD 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ffff
	LDX #$faaa
	LDY #$ffff
	PSHS D,X,Y
	LEAS 40,S

	LDX 6,S
	PSHU X
	LDD #$ffff
	STD 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ffff
	LDX #$0aaa
	LDY #$ffff
	PSHS D,X,Y
	LEAS 40,S

	LDX 6,S
	PSHU X
	LDD #$cfff
	STD 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ffff
	LDX #$aaaa
	LDY #$ffff
	PSHS D,X,Y
	LEAS 40,S

	LDX 6,S
	PSHU X
	LDD #$cfff
	STD 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ffff
	LDX #$aaaa
	LDY #$ffff
	PSHS D,X,Y
	LEAS 40,S

	LDX 6,S
	PSHU X
	LDD #$cfff
	STD 6,S
	LDA 8,S
	PSHU A
	ANDA #$0F
	ORA #$f0
	STA 8,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$0fff
	LDX #$aa1a
	LDY #$ffff
	PSHS D,X,Y
	LEAS 40,S

	LDX 6,S
	PSHU X
	LDD #$ccff
	STD 6,S
	LDA 8,S
	PSHU A
	ANDA #$0F
	ORA #$f0
	STA 8,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$0fff
	LDX #$aa1a
	LDY #$ffff
	PSHS D,X,Y
	LEAS 40,S

	LDX 6,S
	PSHU X
	LDD #$ccfc
	STD 6,S
	LDA 8,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 8,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$0fff
	LDX #$aa3a
	LDY #$ffff
	PSHS D,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$a0ff
	LDX #$aa3a
	LDY #$ffff
	PSHS D,X,Y
	LEAS 6,S

	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$cccc
	PSHS A,X
	LEAS 34,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$a0ff
	LDX #$aa3a
	LDY #$ffff
	PSHS D,X,Y
	LEAS 6,S

	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$cc3c
	PSHS A,X
	LEAS 34,S

	LDX 6,S
	PSHU X
	LDD #$cccc
	STD 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$0aff
	LDX #$aa3a
	LDY #$55ff
	PSHS D,X,Y
	LEAS 40,S

	LDX 6,S
	PSHU X
	LDD #$cccc
	STD 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$eafc
	LDX #$aa3a
	LDY #$5aff
	PSHS D,X,Y
	LEAS 40,S

	LDX 6,S
	PSHU X
	LDD #$ccc3
	STD 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$fafc
	LDX #$aa3a
	LDY #$5aff
	PSHS D,X,Y
	LEAS 40,S

	LDD 6,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$30
	STD 6,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0a
	LDB #$3a
	STD 40,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$fa00
	LDX #$aa3a
	LDY #$55ff
	PSHS D,X,Y
	LEAS 42,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$3a
	STD 38,S
	LDA 5,S
	PSHU A
	ANDA #$0F
	ORA #$30
	STA 5,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$aa
	LDX #$1a55
	LDY #$cfcc
	PSHS A,X,Y
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$3a
	STD 38,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$aa
	LDX #$aa56
	LDY #$cfcc
	PSHS A,X,Y
	LEAS 40,S

	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$aa
	LDX #$aa55
	LDY #$cccc
	PSHS A,X,Y
	LEAS 39,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$35aa
	LDX #$a555
	LDY #$cccc
	PSHS D,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$01aa
	LDX #$5565
	LDY #$cccc
	PSHS D,X,Y
	LEAS 39,S

	LDD 6,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$c0
	STD 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$1335
	LDX #$0a55
	LDY #$55cc
	PSHS D,X,Y
	LEAS 40,S

	LDD 6,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$c0
	STD 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$3a35
	LDX #$5555
	LDY #$55cc
	PSHS D,X,Y
	LEAS 40,S

	LDD 6,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$f0
	STD 6,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$03
	LDB #$15
	STD 40,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$3335
	LDX #$5555
	LDY #$55cc
	PSHS D,X,Y
	LEAS 42,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$00
	LDB #$85
	STD 38,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$5555
	LDX #$55cc
	LDY #$ccfc
	PSHS D,X,Y
	LEAS 40,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$08
	LDB #$55
	STD 39,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$5555
	LDX #$56cc
	LDY #$ccfc
	PSHS D,X,Y
	LEAS 41,S

	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$55
	LDX #$6ccc
	LDY #$ccff
	PSHS A,X,Y
	LEAS 39,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$5555
	LDX #$83cc
	LDY #$cccf
	PSHS D,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$5555
	LDX #$3cc3
	LDY #$cccf
	PSHS D,X,Y
	LEAS 40,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$06
	LDB #$83
	STD 40,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$6556
	LDX #$3fc3
	LDY #$cccf
	PSHS D,X,Y
	LEAS 42,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$ffc6
	LDX #$cccc
	PSHS D,X
	LEAS 39,S

	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$88
	LDX #$6f65
	LDY #$cccc
	PSHS A,X,Y
	LEAS 40,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$08
	LDB #$65
	STD 39,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$66
	LDX #$565a
	LDY #$33cc
	PSHS A,X,Y
	LEAS 41,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$08
	LDB #$55
	STD 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$555a
	LDX #$33cc
	PSHS D,X
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$06
	LDB #$55
	STD 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$5555
	LDX #$33cc
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$5a65
	LDX #$633c
	PSHS D,X
	LEAS 38,S

	LDD 5,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$03c0
	STD 5,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$86
	LDX #$55aa
	LDY #$8553
	PSHS A,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 6,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$86
	LDX #$55aa
	LDY #$8556
	PSHS A,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	ANDA #$0F
	ORA #$30
	STA 6,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$66
	LDX #$555a
	LDY #$3655
	PSHS A,X,Y
	LEAS 40,S

	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$65
	LDX #$5555
	LDY #$3855
	PSHS A,X,Y
	LEAS 40,S

	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$65
	LDX #$5555
	LDY #$c355
	PSHS A,X,Y
	LEAS 40,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$08
	LDB #$55
	STD 39,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$65
	LDX #$5555
	LDY #$fc55
	PSHS A,X,Y
	LEAS 41,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$08
	LDB #$55
	STD 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$5555
	LDX #$fc55
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$5555
	LDX #$fc55
	PSHS D,X
	LEAS 40,S

	LDD 42,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$35
	STD 42,S
	LDA 83,S
	PSHU A
	ANDA #$F0
	ORA #$06
	STA 83,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$5555
	LDX #$cc65
	PSHS D,X
DYN_POS

	LDS #$0000
	LEAS 4260,S

	LDA -39,S
	PSHU A
	LDA #$cc
	STA -39,S
	PULS A,X
	PSHU S,X,A
	LDA #$cc
	LDX #$ffff
	PSHS A,X
	LEAS 40,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$fe
	STD 39,S
	LDX 41,S
	PSHU X
	LDD #$ffff
	STD 41,S
	LDA 43,S
	PSHU A
	ANDA #$0F
	ORA #$f0
	STA 43,S
	PULS A,X
	PSHU S,X,A
	LDA #$f3
	LDX #$ffff
	PSHS A,X
	LEAS 79,S

	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$cf
	LDX #$efff
	LDY #$fffc
	PSHS A,X,Y
	LEAS 40,S

	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$ff
	LDX #$f6ff
	LDY #$ffff
	PSHS A,X,Y
	LEAS 40,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ff
	STD 39,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDX #$f6ff
	LDY #$ffff
	PSHS B,X,Y
	LEAS 41,S

	LDA 4,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 4,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$66ff
	LDX #$ffff
	PSHS D,X
	LEAS 38,S

	LDA 6,S
	PSHU A
	LDA #$fc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ceff
	LDX #$65ff
	LDY #$ffff
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$fc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$feff
	LDX #$55cf
	LDY #$ffff
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$cc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$efff
	LDX #$55cf
	LDY #$ffff
	PSHS D,X,Y
	LEAS 40,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$ff
	STD 39,S
	LDA 6,S
	PSHU A
	LDA #$c3
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ffff
	LDX #$55cc
	LDY #$ffcc
	PSHS D,X,Y
	LEAS 41,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$ff
	STD 38,S
	LDA 5,S
	PSHU A
	ANDA #$0F
	ORA #$30
	STA 5,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDX #$553c
	LDY #$ffcc
	PSHS B,X,Y
	LEAS 40,S

	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$ff
	LDX #$553c
	LDY #$cccc
	PSHS A,X,Y
	LEAS 38,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$03
	LDB #$fe
	STD 39,S
	LDA 6,S
	PSHU A
	LDA #$cc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$cfff
	LDX #$ff55
	LDY #$3ccc
	PSHS D,X,Y
	LEAS 41,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ffff
	LDX #$f5fc
	LDY #$ccc3
	PSHS D,X,Y
	LEAS 38,S

	LDX 6,S
	PSHU X
	LDD #$cc33
	STD 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ccff
	LDX #$ffff
	LDY #$fffc
	PSHS D,X,Y
	LEAS 40,S

	LDD 6,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$30
	STD 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ccef
	LDX #$ffff
	LDY #$fffc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$cc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ccff
	LDX #$ffff
	LDY #$fffc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$c3
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$cfff
	LDX #$ffff
	LDY #$fffc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$33
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$cfff
	LDX #$ffff
	LDY #$ffff
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$33
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$cfff
	LDX #$ffff
	LDY #$ffff
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$33
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$cfff
	LDX #$ffff
	LDY #$ffff
	PSHS D,X,Y
	LEAS 40,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$ff
	STD 40,S
	LDA 6,S
	PSHU A
	LDA #$33
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$cfff
	LDX #$ffff
	LDY #$ffff
	PSHS D,X,Y
	LEAS 42,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$ff
	STD 38,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDX #$ffff
	LDY #$fe33
	PSHS B,X,Y
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$ff
	STD 38,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDX #$f1ff
	LDY #$fef3
	PSHS B,X,Y
	LEAS 40,S

	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$ff
	LDX #$00ff
	LDY #$feff
	PSHS A,X,Y
	LEAS 38,S

	LDD 6,S
	PSHU D
	LDA #$ff
	ANDB #$0F
	ORB #$c0
	STD 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$cfff
	LDX #$ff0a
	LDY #$cffe
	PSHS D,X,Y
	LEAS 40,S

	LDX 6,S
	PSHU X
	LDD #$fffc
	STD 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$cfff
	LDX #$ffaa
	LDY #$1ffe
	PSHS D,X,Y
	LEAS 40,S

	LDX 6,S
	PSHU X
	LDD #$fcff
	STD 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$cfff
	LDX #$ffaa
	LDY #$0cff
	PSHS D,X,Y
	LEAS 40,S

	LDX 6,S
	PSHU X
	LDD #$fcff
	STD 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$cfff
	LDX #$ffaa
	LDY #$acff
	PSHS D,X,Y
	LEAS 40,S

	LDX 6,S
	PSHU X
	LDD #$fcff
	STD 6,S
	LDA 8,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 8,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$cfff
	LDX #$ffaa
	LDY #$a1ff
	PSHS D,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$c1ff
	LDX #$ff01
	LDY #$a0ff
	PSHS D,X,Y
	LEAS 6,S

	PULS A,X
	PSHU S,X,A
	LDA #$fc
	LDX #$fffc
	PSHS A,X
	LEAS 34,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$c1ff
	LDX #$fc13
	LDY #$a0ff
	PSHS D,X,Y
	LEAS 6,S

	PULS A,X
	PSHU S,X,A
	LDA #$fc
	LDX #$ffff
	PSHS A,X
	LEAS 34,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$c1ff
	LDX #$f003
	LDY #$a0ff
	PSHS D,X,Y
	LEAS 6,S

	PULS A,X
	PSHU S,X,A
	LDA #$fc
	LDX #$ffff
	PSHS A,X
	LEAS 34,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$c1ff
	LDX #$f001
	LDY #$a0ff
	PSHS D,X,Y
	LEAS 6,S

	LDD 34,S
	PSHU D
	ANDA #$F0
	ORA #$01
	LDB #$ff
	STD 34,S
	PULS A,X
	PSHU S,X,A
	LDA #$fc
	LDX #$ffff
	PSHS A,X
	LEAS 36,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$ff
	STD 38,S
	LDA 6,S
	PSHU A
	LDA #$cc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$ca00
	LDX #$a0ff
	LDY #$fcff
	PSHS D,X,Y
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$ff
	STD 38,S
	LDA 6,S
	PSHU A
	LDA #$cc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$caa1
	LDX #$a0ff
	LDY #$fccc
	PSHS D,X,Y
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0f
	LDB #$0f
	STD 38,S
	LDA 6,S
	PSHU A
	LDA #$cc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$0aa3
	LDX #$a0ff
	LDY #$fccc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$c3
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$0aa3
	LDX #$a06f
	LDY #$fccc
	PSHS D,X,Y
	LEAS 39,S

	LDD 6,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$30
	STD 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$0faa
	LDX #$a3a0
	LDY #$56fc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$cc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$a3aa
	LDX #$a3a5
	LDY #$55cc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$cc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$a3aa
	LDX #$a0a5
	LDY #$55cc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$cc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$a0aa
	LDX #$aa55
	LDY #$55cc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$c3
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$aaaa
	LDX #$aa55
	LDY #$55cc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$aaaa
	LDX #$aa55
	LDY #$55cc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$cc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$0aaa
	LDX #$aa55
	LDY #$55cc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$fc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$fa5a
	LDX #$aa55
	LDY #$56cc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$ff
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$3355
	LDX #$a556
	LDY #$5ccc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$cf
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$a355
	LDX #$5555
	LDY #$5ccc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$cf
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$3355
	LDX #$5555
	LDY #$6ccc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$cc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$3355
	LDX #$5555
	LDY #$cccc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	LDA #$cc
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$1055
	LDX #$5555
	LDY #$cccc
	PSHS D,X,Y
	LEAS 41,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$5555
	LDX #$553c
	LDY #$cccc
	PSHS D,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$5555
	LDX #$55cc
	LDY #$cccc
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 6,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$6655
	LDX #$68ff
	LDY #$cccc
	PSHS D,X,Y
	LEAS 41,S

	LDA 5,S
	PSHU A
	ANDA #$0F
	ORA #$c0
	STA 5,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$55
	LDX #$88ff
	LDY #$cccc
	PSHS A,X,Y
	LEAS 40,S

	LDA 5,S
	PSHU A
	ANDA #$0F
	ORA #$f0
	STA 5,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$66
	LDX #$8fff
	LDY #$3ccc
	PSHS A,X,Y
	LEAS 40,S

	LDA 5,S
	PSHU A
	ANDA #$0F
	ORA #$f0
	STA 5,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$33
	LDX #$66ff
	LDY #$63cc
	PSHS A,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$3855
	LDX #$ff53
	LDY #$ccfc
	PSHS D,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$6655
	LDX #$6f56
	LDY #$3ccc
	PSHS D,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$6655
	LDX #$5fa5
	LDY #$33cf
	PSHS D,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$6555
	LDX #$5655
	LDY #$33cf
	PSHS D,X,Y
	LEAS 40,S

	LDA 5,S
	PSHU A
	LDA #$3c
	STA 5,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$6555
	LDX #$a655
	PSHS D,X
	LEAS 40,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$08
	LDB #$55
	STD 39,S
	LDA 5,S
	PSHU A
	ANDA #$F0
	ORA #$03
	STA 5,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$5555
	LDX #$a555
	PSHS D,X
	LEAS 41,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$06
	LDB #$55
	STD 38,S
	PULS A,X
	PSHU S,X,A
	LDX #$5555
	PSHS B,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$60
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$55
	LDX #$5555
	PSHS A,X
	LEAS 38,S

	LDA 5,S
	PSHU A
	ANDA #$0F
	ORA #$50
	STA 5,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$88
	LDX #$5555
	LDY #$5565
	PSHS A,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$6855
	LDX #$5555
	LDY #$8556
	PSHS D,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$6855
	LDX #$5555
	LDY #$3655
	PSHS D,X,Y
	LEAS 40,S

	LDD 41,S
	PSHU D
	ANDA #$F0
	ORA #$05
	LDB #$55
	STD 41,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$6855
	LDX #$5556
	LDY #$c855
	PSHS D,X,Y
	LEAS 43,S

	LDD 41,S
	PSHU D
	LDA #$cc
	ANDB #$0F
	ORB #$50
	STD 41,S
	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$50
	STA 82,S
	PULS A,X
	PSHU S,X,A
	LDA #$56
	LDX #$cc55
	PSHS A,X
SSAV_Img_TitleScreen_Sonic_5
	LDS #$0000
	RTS

ERASE_Img_TitleScreen_Sonic_5
	STS ERASE_SSAV_Img_TitleScreen_Sonic_5+2,PCR

ERASE_CODE_Img_TitleScreen_Sonic_5_1
	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 82,S
	STX 41,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 41,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 5,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 38,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 5,S
	STX 39,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 5,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 5,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 5,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 5,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 6,S
	STX 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 6,S
	STX 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 6,S
	STX 38,S

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 34,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 8,S
	STX 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 6,S
	STX 40,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 6,S
	STX 39,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X
	STA 5,S
	STX 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 6,S
	STX 39,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 4,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 39,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,S
	PSHS A,X

	PULU A,X,Y
	STA 43,S
	STX 41,S
	STY 39,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA -39,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 83,S
	STX 42,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 39,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 6,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 6,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 5,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 39,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 40,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 39,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X
	STD 40,S
	STX 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X
	STA 5,S
	STX 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X
	STD 40,S
	STX 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,S
	PSHS A,X

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 8,S
	STX 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 8,S
	STX 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X
	STA 8,S
	STX 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A
	STA 6,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 5,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X
	STA 5,S
	STX 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 39,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 39,S

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,Y
	STA 3,S
	STX -79,S
	STY -39,S

ERASE_SSAV_Img_TitleScreen_Sonic_5
	LDS #$0000
	RTS

