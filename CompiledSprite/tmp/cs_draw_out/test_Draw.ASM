(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_test
	STS SSAV_test+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS 486,S

	LDD #$ffff
	STD -39,S
	LDD #$cccc
	STD -79,S
	LDA 3,S
	ANDA #$0F
	ORA #$f0
	STA 3,S
	LDX #$ffff
	PSHS B,X
	LEAS 40,S

	LDD #$ff3f
	PSHS D,X
	LEAS 40,S

	LDA 39,S
	ANDA #$F0
	ORA #$0c
	LDB #$ff
	STD 39,S
	LDD #$ffff
	PSHS D,X
	LEAS 41,S

	LDA 3,S
	ANDA #$0F
	ORA #$c0
	STA 3,S
	PSHS B,X
	LEAS 38,S

	LDD #$cffe
	LDX #$f3ff
	LDU #$fffc
	PSHS D,X,U
	LEAS 40,S

	LDD #$ffff
	LDU #$ffff
	PSHS D,X,U
	LEAS 40,S

	LDA 39,S
	ANDA #$F0
	ORA #$0c
	LDB #$ff
	STD 39,S
	LDD #$efef
	LDX #$63ff
	PSHS D,X,U
	LEAS 41,S

	LDA 5,S
	ANDA #$0F
	ORA #$f0
	STA 5,S
	LDA 38,S
	ANDA #$F0
	ORA #$0f
	LDB #$ff
	STD 38,S
	LDA #$e6
	LDX #$6fff
	PSHS A,X,U
	LEAS 40,S

	LDA 5,S
	ANDA #$0F
	ORA #$30
	STA 5,S
	LDA #$f6
	LDU #$fffc
	PSHS A,X,U
	LEAS 38,S

	LDA #$ce
	LDX #$ff65
	LDY #$5fff
	LDU #$fccc
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$fe
	LDY #$5fcf
	LDU #$cccc
	PSHS A,X,Y,U
	LEAS 40,S

	LDX #$ff55
	LDY #$5fcc
	LDU #$ccc3
	PSHS B,X,Y,U
	LEAS 40,S

	LDA 6,S
	ANDA #$0F
	ORA #$30
	STA 6,S
	LDD #$ffff
	LDX #$ff5f
	LDU #$cccc
	PSHS D,X,U
	LEAS 39,S

	LDA #$33
	LDX #$ffff
	LDY #$ff5f
	PSHS A,X,Y,U
	LEAS 40,S

	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$3c
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$cf
	LDY #$ffff
	LDU #$ccc3
	PSHS A,X,Y,U
	LEAS 40,S

	LDA 6,S
	ANDA #$0F
	ORA #$30
	STA 6,S
	LDD #$cfff
	LDU #$ffcc
	PSHS D,X,U
	LEAS 40,S

	LDA 6,S
	ANDA #$0F
	ORA #$30
	STA 6,S
	LDU #$ffc3
	PSHS X,Y,U
	LEAS 40,S

	LDA 6,S
	ANDA #$0F
	ORA #$30
	STA 6,S
	LDU #$fff3
	PSHS X,Y,U
	LEAS 40,S

	LDU #$fffc
	PSHS X,Y,U
	LEAS 40,S

	LDD #$ffff
	PSHS D,X,Y
	LEAS 40,S

	LDU #$ffef
	PSHS D,X,U
	LEAS 40,S

	LDX #$ff1c
	PSHS D,X,U
	LEAS 40,S

	LDA 6,S
	ANDA #$0F
	ORA #$c0
	STA 6,S
	LDD #$ffff
	LDX #$ff01
	PSHS D,X,U
	LEAS 40,S

	LDX #$ffff
	LDY #$a0ff
	LDU #$efff
	PSHS A,X,Y,U
	LEAS 40,S

	LDA 7,S
	ANDA #$0F
	ORA #$c0
	STA 7,S
	LDX #$fff0
	LDY #$aaff
	PSHS B,X,Y,U
	LEAS 40,S

	LDA #$fc
	STA 7,S
	LDU #$ffff
	PSHS B,X,Y,U
	LEAS 40,S

	STB 7,S
	LDX #$fffa
	PSHS B,X,Y,U
	LEAS 40,S

	STB 7,S
	LDX #$ff0a
	PSHS B,X,Y,U
	LEAS 40,S

	STB 7,S
	LDX #$ffaa
	LDU #$ffcf
	PSHS B,X,Y,U
	LEAS 40,S

	STB 7,S
	PSHS B,X,Y,U
	LEAS 40,S

	LDB 7,S
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD 7,S
	LDA #$0f
	LDY #$1aff
	PSHS A,X,Y,U
	LEAS 40,S

	LDB 7,S
	LDA #$ff
	ANDB #$0F
	ORB #$f0
	STD 7,S
	LDU #$ffcc
	PSHS A,X,Y,U
	LEAS 40,S

	LDB 7,S
	LDA #$fc
	ANDB #$0F
	ORB #$c0
	STD 7,S
	LDY #$3aff
	PSHS A,X,Y,U
	LEAS 40,S

	LDD #$cccc
	STD 7,S
	LDA #$a0
	PSHS A,X,Y,U
	LEAS 40,S

	LDD #$cc3c
	STD 7,S
	LDA #$a0
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$cc
	STA 7,S
	LDA #$0a
	LDY #$3a55
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$cc
	STA 7,S
	LDA #$ea
	LDX #$fcaa
	LDY #$3a5a
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$c3
	STA 7,S
	LDA #$fa
	PSHS A,X,Y,U
	LEAS 40,S

	LDA 7,S
	ANDA #$0F
	ORA #$30
	STA 7,S
	LDA 40,S
	ANDA #$F0
	ORA #$0a
	LDB #$3a
	STD 40,S
	LDA #$fa
	LDX #$00aa
	LDY #$3a55
	PSHS A,X,Y,U
	LEAS 42,S

	LDA 5,S
	ANDA #$0F
	ORA #$30
	STA 5,S
	LDA 38,S
	ANDA #$F0
	ORA #$0e
	LDB #$3a
	STD 38,S
	LDA #$aa
	LDX #$1a55
	LDU #$cfcc
	PSHS A,X,U
	LEAS 40,S

	LDA 38,S
	ANDA #$F0
	ORA #$0f
	LDB #$3a
	STD 38,S
	LDA #$aa
	LDX #$aa56
	PSHS A,X,U
	LEAS 40,S

	LDX #$aa55
	LDU #$cccc
	PSHS A,X,U
	LEAS 39,S

	LDD #$35aa
	LDX #$a555
	PSHS D,X,U
	LEAS 40,S

	LDA #$01
	LDX #$5565
	PSHS D,X,U
	LEAS 39,S

	LDA 7,S
	ANDA #$0F
	ORA #$c0
	STA 7,S
	LDA #$13
	LDX #$350a
	LDY #$5555
	PSHS A,X,Y,U
	LEAS 40,S

	LDA 7,S
	ANDA #$0F
	ORA #$c0
	STA 7,S
	LDA #$3a
	LDX #$3555
	PSHS A,X,Y,U
	LEAS 40,S

	LDA 7,S
	ANDA #$0F
	ORA #$f0
	STA 7,S
	LDA 40,S
	ANDA #$F0
	ORA #$03
	LDB #$15
	STD 40,S
	LDA #$33
	PSHS A,X,Y,U
	LEAS 42,S

	LDA 38,S
	ANDA #$F0
	ORA #$00
	LDB #$85
	STD 38,S
	LDD #$5555
	LDX #$55cc
	LDU #$ccfc
	PSHS D,X,U
	LEAS 40,S

	LDA 39,S
	ANDA #$F0
	ORA #$08
	LDB #$55
	STD 39,S
	LDD #$5555
	LDX #$56cc
	PSHS D,X,U
	LEAS 41,S

	LDX #$6ccc
	LDU #$ccff
	PSHS A,X,U
	LEAS 39,S

	LDX #$83cc
	LDU #$cccf
	PSHS D,X,U
	LEAS 40,S

	LDX #$3cc3
	PSHS D,X,U
	LEAS 40,S

	LDA 40,S
	ANDA #$F0
	ORA #$06
	LDB #$83
	STD 40,S
	LDD #$6556
	LDX #$3fc3
	PSHS D,X,U
	LEAS 42,S

	LDD #$ffc6
	LDX #$cccc
	PSHS D,X
	LEAS 39,S

	LDA #$88
	LDX #$6f65
	LDU #$cccc
	PSHS A,X,U
	LEAS 40,S

	LDA 39,S
	ANDA #$F0
	ORA #$08
	LDB #$65
	STD 39,S
	LDA #$66
	LDX #$565a
	LDU #$33cc
	PSHS A,X,U
	LEAS 41,S

	LDA 38,S
	ANDA #$F0
	ORA #$08
	LDB #$55
	STD 38,S
	LDD #$555a
	PSHS D,U
	LEAS 40,S

	LDA 38,S
	ANDA #$F0
	ORA #$06
	LDB #$55
	STD 38,S
	PSHS Y,U
	LEAS 40,S

	LDD #$5a65
	LDX #$633c
	PSHS D,X
	LEAS 38,S

	LDD 5,S
	ANDA #$F0
	ANDB #$0F
	ADDD #$03c0
	STD 5,S
	LDA #$86
	LDX #$55aa
	LDU #$8553
	PSHS A,X,U
	LEAS 40,S

	LDA 6,S
	ANDA #$0F
	ORA #$c0
	STA 6,S
	LDA #$86
	LDU #$8556
	PSHS A,X,U
	LEAS 40,S

	LDA 6,S
	ANDA #$0F
	ORA #$30
	STA 6,S
	LDA #$66
	LDX #$555a
	LDU #$3655
	PSHS A,X,U
	LEAS 40,S

	LDA #$65
	LDU #$3855
	PSHS A,Y,U
	LEAS 40,S

	LDU #$c355
	PSHS A,Y,U
	LEAS 40,S

	LDU #$fc55
	PSHS A,Y,U
	LEAS 40,S

	LDA #$55
	PSHS A,Y,U
	LEAS 40,S

	PSHS A,Y,U
	LEAS 41,S

	LDA 42,S
	ANDA #$F0
	ORA #$0c
	LDB #$35
	STD 42,S
	LDA 83,S
	ANDA #$F0
	ORA #$06
	STA 83,S
	LDU #$cc65
	PSHS Y,U
DYN_POS

	LDS #$0000
	LEAS 447,S

	LDA #$cc
	STA -39,S
	LDX #$ffff
	PSHS A,X
	LEAS 40,S

	LDA 39,S
	ANDA #$F0
	ORA #$0c
	LDB #$fe
	STD 39,S
	STX 41,S
	LDA 43,S
	ANDA #$0F
	ORA #$f0
	STA 43,S
	LDA #$f3
	PSHS A,X
	LEAS 79,S

	LDA #$cf
	LDX #$efff
	LDU #$fffc
	PSHS A,X,U
	LEAS 40,S

	LDA #$ff
	LDX #$f6ff
	LDU #$ffff
	PSHS A,X,U
	LEAS 40,S

	LDA 39,S
	ANDA #$F0
	ORA #$0c
	LDB #$ff
	STD 39,S
	LDA #$ff
	PSHS A,X,U
	LEAS 41,S

	LDA 4,S
	ANDA #$0F
	ORA #$c0
	STA 4,S
	LDD #$66ff
	PSHS D,U
	LEAS 38,S

	LDA #$ce
	LDX #$ff65
	LDY #$ffff
	LDU #$fffc
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$fe
	LDX #$ff55
	LDY #$cfff
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$ef
	LDU #$ffcc
	PSHS A,X,Y,U
	LEAS 40,S

	LDA 39,S
	ANDA #$F0
	ORA #$0c
	LDB #$ff
	STD 39,S
	LDY #$ccff
	LDU #$ccc3
	PSHS B,X,Y,U
	LEAS 41,S

	LDA 5,S
	ANDA #$0F
	ORA #$30
	STA 5,S
	LDA 38,S
	ANDA #$F0
	ORA #$0f
	LDB #$ff
	STD 38,S
	LDX #$553c
	LDU #$ffcc
	PSHS B,X,U
	LEAS 40,S

	LDU #$cccc
	PSHS B,X,U
	LEAS 38,S

	LDA 39,S
	ANDA #$F0
	ORA #$03
	LDB #$fe
	STD 39,S
	LDA #$cf
	LDX #$ffff
	LDY #$553c
	PSHS A,X,Y,U
	LEAS 41,S

	LDY #$f5fc
	LDU #$ccc3
	PSHS X,Y,U
	LEAS 38,S

	LDA #$33
	STA 7,S
	LDA #$cc
	LDY #$ffff
	LDU #$fccc
	PSHS A,X,Y,U
	LEAS 40,S

	LDA 7,S
	ANDA #$0F
	ORA #$30
	STA 7,S
	LDA #$cc
	LDX #$efff
	PSHS A,X,Y,U
	LEAS 40,S

	LDX #$ffff
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$cf
	LDU #$fcc3
	PSHS A,X,Y,U
	LEAS 40,S

	LDU #$ff33
	PSHS A,X,Y,U
	LEAS 40,S

	PSHS A,X,Y,U
	LEAS 40,S

	PSHS A,X,Y,U
	LEAS 40,S

	LDA 40,S
	ANDA #$F0
	ORA #$0f
	LDB #$ff
	STD 40,S
	LDA #$cf
	PSHS A,X,Y,U
	LEAS 42,S

	LDA 38,S
	ANDA #$F0
	ORA #$0f
	LDB #$ff
	STD 38,S
	LDU #$fe33
	PSHS B,X,U
	LEAS 40,S

	LDA 38,S
	ANDA #$F0
	ORA #$0f
	LDB #$ff
	STD 38,S
	LDX #$f1ff
	LDU #$fef3
	PSHS B,X,U
	LEAS 40,S

	LDX #$00ff
	LDU #$feff
	PSHS B,X,U
	LEAS 38,S

	LDA 7,S
	ANDA #$0F
	ORA #$c0
	STA 7,S
	LDA #$cf
	LDX #$ffff
	LDY #$0acf
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$fc
	STA 7,S
	LDA #$cf
	LDY #$aa1f
	PSHS A,X,Y,U
	LEAS 40,S

	STB 7,S
	LDY #$aa0c
	LDU #$fffc
	PSHS A,X,Y,U
	LEAS 40,S

	STB 7,S
	LDY #$aaac
	PSHS A,X,Y,U
	LEAS 40,S

	LDB 7,S
	LDA #$ff
	ANDB #$0F
	ORB #$c0
	STD 7,S
	LDY #$aaa1
	PSHS A,X,Y,U
	LEAS 40,S

	STU 7,S
	LDA #$c1
	LDY #$01a0
	PSHS A,X,Y,U
	LEAS 40,S

	STX 7,S
	LDX #$fffc
	LDY #$13a0
	PSHS A,X,Y,U
	LEAS 40,S

	LDD #$ffff
	STD 7,S
	LDA #$c1
	LDX #$fff0
	LDY #$03a0
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$ff
	STD 7,S
	LDA 40,S
	ANDA #$F0
	ORA #$01
	LDB #$ff
	STD 40,S
	LDA #$c1
	LDY #$01a0
	PSHS A,X,Y,U
	LEAS 42,S

	LDA 38,S
	ANDA #$F0
	ORA #$0e
	LDB #$ff
	STD 38,S
	LDA #$ca
	LDX #$00a0
	LDY #$fffc
	LDU #$ffcc
	PSHS A,X,Y,U
	LEAS 40,S

	LDA 38,S
	ANDA #$F0
	ORA #$0f
	LDB #$ff
	STD 38,S
	LDA #$ca
	LDX #$a1a0
	LDU #$cccc
	PSHS A,X,Y,U
	LEAS 40,S

	LDA 38,S
	ANDA #$F0
	ORA #$0f
	LDB #$0f
	STD 38,S
	LDA #$0a
	LDX #$a3a0
	PSHS A,X,Y,U
	LEAS 40,S

	LDY #$6ffc
	LDU #$ccc3
	PSHS A,X,Y,U
	LEAS 39,S

	LDA 7,S
	ANDA #$0F
	ORA #$30
	STA 7,S
	LDA #$0f
	LDX #$aaa3
	LDY #$a056
	LDU #$fccc
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$a3
	LDY #$a555
	LDU #$cccc
	PSHS A,X,Y,U
	LEAS 40,S

	LDX #$aaa0
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$a0
	LDX #$aaaa
	LDY #$5555
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$aa
	LDU #$ccc3
	PSHS A,X,Y,U
	LEAS 40,S

	LDA 6,S
	ANDA #$0F
	ORA #$c0
	STA 6,S
	LDY #$aa55
	LDU #$55cc
	PSHS X,Y,U
	LEAS 40,S

	LDA #$0a
	LDY #$5555
	LDU #$cccc
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$fa
	LDX #$5aaa
	LDY #$5556
	LDU #$ccfc
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$33
	LDX #$55a5
	LDY #$565c
	LDU #$ccff
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$a3
	LDX #$5555
	LDY #$555c
	LDU #$cccf
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$33
	LDY #$556c
	PSHS A,X,Y,U
	LEAS 40,S

	LDY #$55cc
	LDU #$cccc
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$10
	PSHS A,X,Y,U
	LEAS 41,S

	LDY #$553c
	PSHS X,Y,U
	LEAS 40,S

	LDY #$55cc
	PSHS X,Y,U
	LEAS 40,S

	LDA 6,S
	ANDA #$0F
	ORA #$c0
	STA 6,S
	LDD #$6655
	LDX #$68ff
	PSHS D,X,U
	LEAS 41,S

	LDA 5,S
	ANDA #$0F
	ORA #$c0
	STA 5,S
	LDX #$88ff
	PSHS B,X,U
	LEAS 40,S

	LDA 5,S
	ANDA #$0F
	ORA #$f0
	STA 5,S
	LDA #$66
	LDX #$8fff
	LDU #$3ccc
	PSHS A,X,U
	LEAS 40,S

	LDA 5,S
	ANDA #$0F
	ORA #$f0
	STA 5,S
	LDA #$33
	LDX #$66ff
	LDU #$63cc
	PSHS A,X,U
	LEAS 40,S

	LDA #$38
	LDX #$ff53
	LDU #$ccfc
	PSHS D,X,U
	LEAS 40,S

	LDA #$66
	LDX #$6f56
	LDU #$3ccc
	PSHS D,X,U
	LEAS 40,S

	LDX #$5fa5
	LDU #$33cf
	PSHS D,X,U
	LEAS 40,S

	LDA #$65
	LDX #$5655
	PSHS D,X,U
	LEAS 40,S

	LDA #$3c
	STA 5,S
	LDA #$65
	LDX #$a655
	PSHS D,X
	LEAS 40,S

	LDA 5,S
	ANDA #$F0
	ORA #$03
	STA 5,S
	LDD #$5555
	LDX #$a555
	PSHS D,X
	LEAS 40,S

	LDX #$5555
	PSHS D,X
	LEAS 40,S

	LDA 4,S
	ANDA #$0F
	ORA #$60
	STA 4,S
	LDD #$5555
	PSHS D,X
	LEAS 40,S

	LDA 4,S
	ANDA #$0F
	ORA #$50
	STA 4,S
	LDU #$5565
	PSHS X,U
	LEAS 40,S

	LDU #$8556
	PSHS B,X,U
	LEAS 40,S

	LDU #$3655
	PSHS B,X,U
	LEAS 40,S

	LDA 40,S
	ANDA #$F0
	ORA #$05
	LDB #$55
	STD 40,S
	LDX #$5556
	LDU #$c855
	PSHS B,X,U
	LEAS 42,S

	LDB 41,S
	LDA #$cc
	ANDB #$0F
	ORB #$50
	STD 41,S
	LDA 82,S
	ANDA #$0F
	ORA #$50
	STA 82,S
	LDA #$56
	LDX #$cc55
	PSHS A,X
SSAV_test
	LDS #$0000
	RTS

