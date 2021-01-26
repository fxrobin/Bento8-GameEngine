(main)IMGD.ASM
	ORG $A000
	SETDP $FF
BCKDRAW_Img_Sonic_065
	STS SSAV_Img_Sonic_065+2,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS 922,S

	LDD -79,S
	PSHU D
	LDA #$bb
	ANDB #$0F
	ORB #$b0
	STD -79,S
	LDA -119,S
	LDB -38,S
	PSHU B,A
	ANDB #$0F
	ORB #$b0
	STB -38,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0b
	LDB #$bb
	STD -40,S
	STB -119,S
	PULS A,X
	PSHU S,X,A
	LDX #$bbbb
	PSHS B,X
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
	LDX #$bbdb
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
	LDA #$eb
	LDX #$bb0d
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$bb
	LDX #$bb0d
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$eb
	LDX #$bb0c
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$bb
	LDX #$bbdb
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$eb
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
	LDA #$bb
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
	LDA #$bb
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
	LDA #$eb
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
	LDA #$be
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
	LDA #$be
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
	LDA #$ee
	LDX #$bbbb
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$ee
	LDX #$ebbb
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$ee
	LDX #$bebb
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$ee
	LDX #$ebee
	PSHS A,X
	LEAS 40,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0b
	LDB #$ee
	STD 40,S
	LDD 81,S
	PSHU D
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD 81,S
	LDA 121,S
	LDB 42,S
	PSHU B,A
	ANDB #$0F
	ORB #$e0
	STB 42,S
	LDA #$be
	STA 121,S
	PULS A,X
	PSHU S,X,A
	LDA #$ce
	LDX #$eebb
	PSHS A,X
DYN_POS

	LDS #$0000
	LEAS 884,S

	LDD -81,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0bb0
	STD -81,S
	LDX -41,S
	LDY -1,S
	PSHU Y,X
	LDD 39,S
	LDX 79,S
	PSHU X,D
	LDD #$bbbb
	STD -41,S
	STD -1,S
	STD 39,S
	STD 79,S
	LDA 81,S
	PSHU S,A
	ANDA #$0F
	ORA #$b0
	STA 81,S
	LEAS 238,S

	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$bb
	STD -120,S
	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$bb
	STD -80,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$bb
	STD -40,S
	LDX -38,S
	PSHU X
	LDD -118,S
	PSHU D
	LDA #$bb
	ANDB #$0F
	ORB #$b0
	STD -118,S
	LDD -78,S
	PSHU D
	LDA #$bb
	ANDB #$0F
	ORB #$b0
	STD -78,S
	LDD #$bbbb
	STD -38,S
	PULS X,Y
	PSHU S,Y,X
	LDA #$eb
	LDX #$bcbb
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$eebb
	LDX #$bdbb
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$eebb
	LDX #$b0bb
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$ebbb
	LDX #$b0bb
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$eebb
	LDX #$bdbb
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$ebbb
	LDX #$bcbb
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$eebb
	LDX #$bbbb
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$eebb
	LDX #$bbbb
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$eebb
	LDX #$bbbb
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$eebb
	LDX #$bbbb
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$eebb
	LDX #$bbbb
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$bebb
	LDX #$bbbb
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$ceeb
	LDX #$bbbb
	PSHS D,X
	LEAS 40,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0e
	LDB #$bb
	STD 40,S
	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$0b
	LDB #$bb
	STD 80,S
	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$0c
	LDB #$bb
	STD 120,S
	LDX 42,S
	LDY 82,S
	PSHU Y,X
	LDD 122,S
	PSHU D
	LDA #$ee
	ANDB #$0F
	ORB #$b0
	STD 122,S
	LDD #$bbbb
	STD 42,S
	STD 82,S
	PULS X,Y
	PSHU S,Y,X
	LDA #$be
	LDX #$bbbb
	PSHS D,X
	LEAS 241,S

	LDX -80,S
	LDY -40,S
	PSHU Y,X
	LDD ,S
	LDX 40,S
	PSHU X,D
	LDD #$eebb
	STD -80,S
	LDB #$ee
	STD -40,S
	STD ,S
	LDA #$ce
	STD 40,S
	LDD 80,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0be0
	STD 80,S
	LDA -78,S
	PSHU S,A
	ANDA #$0F
	ORA #$e0
	STA -78,S
SSAV_Img_Sonic_065
	LDS #$0000
	RTS

