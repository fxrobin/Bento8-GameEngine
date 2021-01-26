(main)IMGD.ASM
	ORG $A000
	SETDP $FF
BCKDRAW_Img_Sonic_071
	STS SSAV_Img_Sonic_071+2,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS 1124,S

	LDA ,S
	PSHU S,A
	LDA #$ee
	STA ,S
	LEAS 159,S

	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$bb
	STD -80,S
	LDA -78,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA -78,S
	LDA -38,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA -38,S
	LDX -40,S
	PSHU X
	LDD #$ebbb
	STD -40,S
	LDA -119,S
	STB -119,S
	PULS B,X
	PSHU S,X,B,A
	LDA #$bb
	LDX #$bbbe
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$bb
	LDX #$bcbe
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$bb
	LDX #$bdbe
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$bb
	LDX #$b0bb
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$bb
	LDX #$b0bb
	PSHS A,X
	LEAS 40,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$bb
	STD 39,S
	LDD 79,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$bb
	STD 79,S
	LDD 119,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$bb
	STD 119,S
	LDX 41,S
	LDY 81,S
	PSHU Y,X
	LDD 121,S
	PSHU D
	LDD #$bbbe
	STD 81,S
	STD 121,S
	LDD #$bcbb
	STD 41,S
	PULS A,X
	PSHU S,X,A
	LDX #$bdbb
	PSHS B,X
	LEAS 199,S

	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$bb
	STD -40,S
	LDX -38,S
	PSHU X
	LDD #$bbbe
	STD -38,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$ee
	LDX #$bbbb
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$ee
	LDX #$bbbb
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$ee
	LDX #$bbbb
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$ee
	LDX #$bbbb
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$ee
	LDX #$bbdb
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$ee
	LDX #$bbdd
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$ee
	LDX #$ebee
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$ee
	LDX #$bbde
	PSHS A,X
	LEAS 40,S

	LDA 42,S
	LDB 82,S
	PSHU B,A
	ANDB #$0F
	ORB #$e0
	STB 82,S
	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$ee
	STD 40,S
	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$ee
	STD 80,S
	LDA 121,S
	STB 42,S
	STB 121,S
	PULS B,X
	PSHU S,X,B,A
	LDA #$ee
	LDX #$eeee
	PSHS A,X
	LEAS 161,S

	LDA ,S
	PSHU S,A
	LDA #$ee
	STA ,S
DYN_POS

	LDS #$0000
	LEAS 1184,S

	LDD -60,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0ee0
	STD -60,S
	LDX -20,S
	LDD #$ebbe
	STD -20,S
	LDY 20,S
	PSHU Y,X
	LDD 60,S
	PSHU S,D
	LDD #$bbbb
	STD 20,S
	STD 60,S
	LEAS 219,S

	LDA -78,S
	LDB -38,S
	LDX -119,S
	PSHU X,B,A
	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$bb
	STD -80,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0b
	LDB #$bb
	STD -40,S
	LDA #$dc
	STA -78,S
	LDA #$bb
	STD -119,S
	LDA #$0c
	STA -38,S
	PULS A,X
	PSHU S,X,A
	LDA #$eb
	LDX #$bb0d
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$eb
	LDX #$bb0d
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$bb
	LDX #$bb0c
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$bb
	LDX #$bbdb
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$bb
	LDX #$bbbb
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$eb
	LDX #$bbbb
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$bb
	LDX #$bdbb
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$eb
	LDX #$bbbb
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$bb
	LDX #$bbbb
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$eb
	LDX #$bdbb
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$bb
	LDX #$bdbb
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$eb
	LDX #$bdeb
	PSHS A,X
	LEAS 40,S

	LDX 40,S
	LDD #$ebbe
	STD 40,S
	LDY 80,S
	PSHU Y,X
	LDA 42,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 42,S
	LDA 82,S
	PSHU A
	ANDA #$0F
	ORA #$e0
	STA 82,S
	LDD #$eebd
	STD 80,S
	LDX 120,S
	PSHU X
	LDB #$ee
	STD 120,S
	PULS A,X
	PSHU S,X,A
	LDA #$eb
	LDX #$bdde
	PSHS A,X
	LEAS 220,S

	LDX -60,S
	LDY -20,S
	PSHU Y,X
	LDD 20,S
	PSHU D
	LDD #$eeee
	STD -60,S
	STD -20,S
	STD 20,S
	LDD 60,S
	PSHU S,D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0ee0
	STD 60,S
SSAV_Img_Sonic_071
	LDS #$0000
	RTS

