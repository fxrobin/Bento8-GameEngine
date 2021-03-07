(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_test
	STD DYN_POS+2,PCR
	LEAS ,U
	LDU ,Y
	LEAU 3250,U

	LDA 79,U
	ANDA #$F0
	ORA #$05
	STA 79,S
	LDD 38,U
	ANDA #$F0
	ORA #$0e
	LDB #$14
	STD 38,S
	LDD #$4444
	LDX #$ee54
	PSHU D,X
	LEAU -36,U

	LDX #$4444
	LDY #$ee44
	PSHU A,X,Y
	LEAU -35,U

	PSHU A,X,Y
	LEAU -35,U

	LDA #$54
	PSHU A,X,Y
	LEAU -35,U

	LDY #$e144
	PSHU A,X,Y
	LEAU -35,U

	LDA -39,U
	ANDA #$0F
	ORA #$10
	STA -39,S
	LDA #$54
	LDY #$1344
	PSHU A,X,Y
	LEAU -35,U

	LDA -39,U
	ANDA #$0F
	ORA #$e0
	STA -39,S
	LDA #$55
	LDX #$4440
	LDY #$1544
	PSHU A,X,Y
	LEAU -35,U

	LDD -40,U
	ANDA #$F0
	ANDB #$0F
	ADDD #$01e0
	STD -40,S
	LDA #$35
	LDX #$4400
	LDY #$3445
	PSHU A,X,Y
	LEAU -35,U

	LDY #$3441
	PSHU A,X,Y
	LEAU -34,U

	LDA -6,U
	ANDA #$F0
	ORA #$05
	STA -6,S
	LDA #$44
	LDX #$4054
	LDY #$511e
	PSHU A,X,Y
	LEAU -35,U

	LDA -6,U
	ANDA #$F0
	ORA #$03
	STA -6,S
	LDA #$44
	LDX #$4444
	LDY #$11ee
	PSHU A,X,Y
	LEAU -35,U

	LDA -6,U
	ANDA #$F0
	ORA #$03
	STA -6,S
	LDA #$54
	LDX #$4440
	PSHU A,X,Y
	LEAU -35,U

	LDA #$55
	LDX #$4540
	PSHU A,X,Y
	LEAU -35,U

	LDA #$33
	LDX #$5e54
	LDY #$eeee
	PSHU A,X,Y
	LEAU -35,U

	LDA -6,U
	ANDA #$F0
	ORA #$05
	STA -6,S
	LDA #$31
	LDX #$eee5
	PSHU A,X,Y
	LEAU -35,U

	LDD #$5445
	LDX #$1ee1
	PSHU D,X,Y
	LEAU -34,U

	LDD #$4444
	PSHU D,X,Y
	LEAU -34,U

	LDX #$31ee
	PSHU D,X,Y
	LEAU -34,U

	LDA -7,U
	ANDA #$F0
	ORA #$03
	STA -7,S
	LDD #$4444
	LDX #$5eee
	PSHU D,X,Y
	LEAU -34,U

	LDD -8,U
	ANDA #$F0
	ORA #$0b
	LDB #$34
	STD -8,S
	LDD #$4444
	LDX #$45ee
	PSHU D,X,Y
	LEAU -34,U

	LDD -8,U
	ANDA #$F0
	ORA #$01
	LDB #$d4
	STD -8,S
	LDD -42,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -42,S
	LDD #$4444
	LDX #$44ee
	PSHU D,X,Y
	LEAU -36,U

	LDD -40,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -40,S
	LDD #$1114
	LDX #$4444
	LDY #$44ee
	PSHU D,X,Y
	LEAU -34,U

	LDD -40,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -40,S
	LDD #$1014
	PSHU D,X,Y
	LEAU -34,U

	LDA #$d1
	LDX #$b044
	PSHU D,X,Y
	LEAU -33,U

	LDD #$bd00
	LDX #$4454
	LDY #$eeee
	PSHU D,X,Y
	LEAU -34,U

	LDA #$14
	LDX #$0444
	PSHU D,X,Y
	LEAU -34,U

	LDA -7,U
	ANDA #$F0
	ORA #$0e
	STA -7,S
	LDD #$1000
	LDX #$0044
	PSHU D,X,Y
	LEAU -34,U

	LDA -7,U
	ANDA #$F0
	ORA #$0d
	STA -7,S
	LDD -41,U
	LDA #$ee
	ANDB #$0F
	ORB #$10
	STD -41,S
	LDD #$1000
	LDX #$0045
	PSHU D,X,Y
	LEAU -35,U

	LDA -6,U
	ANDA #$F0
	ORA #$00
	STA -6,S
	LDD -40,U
	LDA #$ee
	ANDB #$0F
	ORB #$10
	STD -40,S
	LDA #$10
	LDX #$00d0
	LDY #$44ee
	PSHU A,X,Y
	LEAU -35,U

	LDD #$e0bb
	LDX #$0010
	PSHU D,X,Y
	LEAU -32,U

	LDB #$ee
	STD -8,U
	LDD #$0010
	LDX #$40ee
	LDY #$eee1
	PSHU D,X,Y
	LEAU -34,U

	LDD #$d0ee
	STD -8,U
	LDD #$0010
	LDY #$eeee
	PSHU D,X,Y
	LEAU -34,U

	LDD #$b0ee
	STD -8,U
	LDD #$0010
	LDX #$44ee
	PSHU D,X,Y
	LEAU -33,U

	LDD #$10ee
	LDX #$eeee
	LDY #$ee1e
	PSHU D,X,Y
	LDA #$0b
	LDX #$ee00
	PSHU A,X
	LEAU -31,U

	LDA #$10
	LDX #$eeee
	LDY #$eeee
	PSHU D,X,Y
	LDD -36,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -36,S
	LDA #$0b
	LDX #$ee00
	PSHU A,X
	LEAU -33,U

	LDA #$be
	STA -7,U
	LDD -40,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -40,S
	LDD #$ee00
	LDX #$10ee
	PSHU D,X,Y
	LEAU -34,U

	LDA #$be
	STA -7,U
	LDD -40,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -40,S
	LDD #$ee00
	LDX #$d0ee
	PSHU D,X,Y
	LEAU -34,U

	LDA #$be
	STA -7,U
	LDA #$ee
	PSHU D,X,Y
	LEAU -33,U

	STY -8,U
	LDA #$00
	LDX #$eeee
	PSHU D,X,Y
	LEAU -34,U

	STX -8,U
	PSHU D,X,Y
	LEAU -34,U

	STX -8,U
	LDA #$b0
	PSHU D,X,Y
	LEAU -34,U

	STX -8,U
	LDA #$e0
	PSHU D,X,Y
	LEAU -34,U

	STX -8,U
	LDD -42,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -42,S
	LDD #$eb00
	PSHU D,X,Y
	LEAU -36,U

	LDD #$eeee
	LDX #$eb00
	LDY #$eede
	PSHU D,X,Y
	LEAU -33,U

	STA -7,U
	LDD -42,U
	LDA #$ce
	ANDB #$0F
	ORB #$e0
	STD -42,S
	LDD #$eeee
	LDX #$0bee
	LDY #$deee
	PSHU D,X,Y
	LEAU -36,U

	LDX #$eeee
	LDY #$bdee
	PSHU A,X,Y
	LEAU -34,U

	LDX #$eede
	LDY #$eece
	PSHU D,X,Y
	LEAU -34,U

	LDX #$eeee
	LDY #$eede
	PSHU D,X,Y
	LEAU -34,U

	LDY #$eeee
	PSHU D,X,Y
	LEAU -34,U

	LDD -41,U
	LDA #$e1
	ANDB #$0F
	ORB #$10
	STD -41,S
	LDD #$eeee
	PSHU D,X,Y
	LEAU -35,U

	LDD -40,U
	LDA #$e1
	ANDB #$0F
	ORB #$10
	STD -40,S
	LDA #$ee
	PSHU A,X,Y
	LEAU -35,U

	LDD -40,U
	LDA #$ee
	ANDB #$0F
	ORB #$10
	STD -40,S
	PSHU A,X,Y
	LEAU -35,U

	PSHU A,X,Y
	LEAU -33,U

	STA -7,U
	LDD #$eeee
	LDY #$eee1
	PSHU D,X,Y
	LEAU -34,U

	LDA #$1e
	STA -7,U
	LDA #$ee
	LDX #$ee4e
	LDY #$eeee
	PSHU D,X,Y
	LEAU -34,U

	LDA #$11
	STA -7,U
	LDA #$ee
	PSHU D,X,Y
	LEAU -34,U

	LDA #$11
	STA -7,U
	LDD -41,U
	LDA #$ee
	ANDB #$0F
	ORB #$10
	STD -41,S
	LDD #$eeee
	PSHU D,X,Y
	LEAU -35,U

	LDX #$eeee
	LDY #$4eee
	PSHU A,X,Y
	LEAU -33,U

	LDA #$de
	STA -7,U
	LDD #$ee44
	LDX #$4eee
	LDY #$eee1
	PSHU D,X,Y
	LEAU -34,U

	LDA #$ed
	STA -7,U
	LDD #$ee54
	LDY #$eeee
	PSHU D,X,Y
	LEAU -34,U

	LDA #$ed
	STA -7,U
	LDD -41,U
	LDA #$ee
	ANDB #$0F
	ORB #$10
	STD -41,S
	LDD #$ee54
	PSHU D,X,Y
	LEAU -35,U

	LDA -6,U
	ANDA #$F0
	ORA #$0e
	STA -6,S
	LDD -40,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -40,S
	LDX #$e55e
	PSHU A,X,Y
	LEAU -35,U

	LDA -6,U
	ANDA #$F0
	ORA #$0e
	STA -6,S
	LDA #$ee
	LDX #$d55e
	PSHU A,X,Y
	LEAU -34,U

	LDD #$dede
	LDX #$51ee
	PSHU D,X,Y
	LEAU -34,U

	LDD #$eeee
	LDX #$e1ee
	PSHU D,X,Y
	LEAU -34,U

	LDD -42,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -42,S
	LDD #$eeed
	PSHU D,X,Y
	LEAU -36,U

	LDA -4,U
	ANDA #$F0
	ORA #$0e
	STA -4,S
	LDA #$ee
	PSHU A,Y
	LEAU -36,U

	LDB #$ee
	PSHU D,Y
	LEAU -36,U

	STD -44,U
	STD -83,U
	STD -123,U
	LDD -42,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -42,S
	LDD #$ee1e
	PSHU D,Y
DYN_POS

	LDU #$0000
	LEAU 3251,U

	LDA 79,U
	ANDA #$0F
	ORA #$40
	STA 79,S
	LDA -5,U
	ANDA #$F0
	ORA #$04
	STA -5,S
	LDD 38,U
	LDA #$ee
	ANDB #$0F
	ORB #$40
	STD 38,S
	LDD #$4445
	LDX #$ee44
	PSHU D,X
	LEAU -36,U

	LDX #$4445
	LDY #$e344
	PSHU A,X,Y
	LEAU -35,U

	LDX #$4444
	LDY #$1544
	PSHU A,X,Y
	LEAU -35,U

	LDD -42,U
	LDA #$54
	ANDB #$0F
	ORB #$40
	STD -42,S
	LDA #$44
	LDY #$3445
	PSHU A,X,Y
	LEAU -37,U

	LDD -40,U
	LDA #$44
	ANDB #$0F
	ORB #$50
	STD -40,S
	PSHU A,X
	LEAU -37,U

	PSHU A,X
	LEAU -36,U

	LDA -39,U
	ANDA #$F0
	ORA #$01
	STA -39,S
	LDD #$4444
	PSHU D,X
	LEAU -36,U

	LDA #$1e
	STA -39,U
	LDY #$0444
	PSHU X,Y
	LEAU -36,U

	LDA #$54
	LDX #$0544
	PSHU D,X
	LEAU -34,U

	LDX #$4544
	LDY #$11ee
	PSHU D,X,Y
	LEAU -34,U

	LDA #$55
	LDX #$4e04
	PSHU D,X,Y
	LEAU -34,U

	LDX #$5e45
	LDY #$1eee
	PSHU D,X,Y
	LEAU -34,U

	LDD -42,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -42,S
	LDD #$1344
	LDX #$ee41
	LDY #$eeee
	PSHU D,X,Y
	LEAU -36,U

	LDD -40,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -40,S
	LDD #$1155
	LDX #$ee51
	PSHU D,X
	LEAU -36,U

	LDD -40,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -40,S
	LDD #$553e
	LDX #$ee1e
	PSHU D,X
	LEAU -36,U

	LDD -40,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -40,S
	LDD #$4433
	PSHU D,Y
	LEAU -36,U

	LDA #$55
	LDX #$4453
	PSHU A,X,Y
	LEAU -34,U

	LDD #$4444
	LDX #$44ee
	PSHU D,X,Y
	LEAU -34,U

	LDX #$441e
	PSHU D,X,Y
	LEAU -34,U

	LDA #$db
	STA -7,U
	LDA #$44
	LDX #$44ee
	PSHU D,X,Y
	LEAU -34,U

	LDA #$11
	STA -7,U
	LDA #$44
	PSHU D,X,Y
	LEAU -34,U

	LDA #$11
	STA -7,U
	LDA #$44
	LDX #$445e
	PSHU D,X,Y
	LEAU -34,U

	LDA #$01
	STA -7,U
	LDA #$44
	LDX #$444e
	PSHU D,X,Y
	LEAU -34,U

	LDA #$11
	STA -7,U
	LDD #$4404
	LDX #$454e
	PSHU D,X,Y
	LEAU -34,U

	LDA #$e0
	STA -7,U
	LDD #$4000
	LDX #$4445
	PSHU D,X,Y
	LEAU -34,U

	LDA #$b0
	STA -7,U
	LDD -42,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -42,S
	LDD #$0000
	LDX #$4444
	PSHU D,X,Y
	LEAU -36,U

	LDX #$0000
	LDY #$4444
	PSHU A,X,Y
	LEAU -33,U

	STA -7,U
	LDX #$4444
	LDY #$eee1
	PSHU D,X,Y
	LEAU -34,U

	LDA #$0b
	STA -7,U
	LDA #$00
	LDY #$eeee
	PSHU D,X,Y
	LEAU -34,U

	LDA #$01
	STA -7,U
	LDD #$000b
	LDX #$0444
	PSHU D,X,Y
	LEAU -34,U

	LDA #$01
	STA -7,U
	LDD -41,U
	LDA #$ee
	ANDB #$0F
	ORB #$10
	STD -41,S
	LDD #$0001
	PSHU D,X,Y
	LEAU -35,U

	LDD #$be00
	LDX #$010b
	LDY #$45ee
	PSHU D,X,Y
	LEAU -32,U

	LDB #$b0
	STD -8,U
	LDA -9,U
	ANDA #$F0
	ORA #$0e
	STA -9,S
	LDD #$010b
	LDX #$5eee
	LDY #$eee1
	PSHU D,X,Y
	LEAU -34,U

	LDD #$eeb0
	STD -8,U
	LDA -9,U
	ANDA #$F0
	ORA #$0e
	STA -9,S
	LDD #$010b
	LDX #$eeee
	LDY #$eeee
	PSHU D,X,Y
	LEAU -34,U

	LDD #$eee0
	STD -8,U
	LDA -9,U
	ANDA #$F0
	ORA #$0d
	STA -9,S
	LDD #$0d0b
	PSHU D,X,Y
	LEAU -34,U

	LDD #$eee0
	STD -8,U
	LDA -9,U
	ANDA #$F0
	ORA #$0d
	STA -9,S
	LDD #$bb0b
	PSHU D,X,Y
	LEAU -34,U

	LDA #$bd
	PSHU D,X,Y
	LDA #$ed
	LDX #$eeeb
	PSHU A,X
	LEAU -31,U

	LDA #$b1
	LDX #$eeee
	PSHU D,X,Y
	LDA #$ed
	LDX #$eeeb
	PSHU A,X
	LEAU -31,U

	LDA #$d1
	LDX #$eeee
	PSHU D,X,Y
	LDA #$ed
	PSHU A,X
	LEAU -31,U

	LDA #$bd
	PSHU D,X,Y
	LDD -36,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -36,S
	LDA #$ed
	PSHU A,X
	LEAU -33,U

	LDA #$ee
	STA -7,U
	LDD #$eeee
	LDX #$000d
	PSHU D,X,Y
	LEAU -33,U

	STD -8,U
	LDB #$00
	LDX #$0eee
	PSHU D,X,Y
	LEAU -34,U

	STY -8,U
	LDX #$beee
	PSHU D,X,Y
	LEAU -34,U

	STY -8,U
	LDD -42,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -42,S
	LDD #$ee00
	LDX #$deed
	PSHU D,X,Y
	LEAU -36,U

	LDB #$ee
	LDX #$eeb0
	LDY #$eeed
	PSHU D,X,Y
	LEAU -33,U

	LDA -7,U
	ANDA #$F0
	ORA #$0e
	STA -7,S
	LDD #$eeee
	LDX #$bbee
	LDY #$ecee
	PSHU D,X,Y
	LEAU -34,U

	LDA -7,U
	ANDA #$F0
	ORA #$0e
	STA -7,S
	LDD #$eeee
	LDX #$edee
	LDY #$ece1
	PSHU D,X,Y
	LEAU -34,U

	LDA -7,U
	ANDA #$F0
	ORA #$0e
	STA -7,S
	LDD #$eeee
	LDX #$eeee
	LDY #$ed11
	PSHU D,X,Y
	LEAU -34,U

	STA -7,U
	LDY #$ee11
	PSHU D,X,Y
	LEAU -34,U

	STA -7,U
	PSHU D,X,Y
	LEAU -34,U

	STA -7,U
	PSHU D,X,Y
	LEAU -34,U

	STA -7,U
	PSHU D,X,Y
	LEAU -34,U

	STA -7,U
	LDY #$eee1
	PSHU D,X,Y
	LEAU -34,U

	STA -7,U
	LDD -41,U
	LDA #$ee
	ANDB #$0F
	ORB #$10
	STD -41,S
	LDD #$eeee
	LDY #$eeee
	PSHU D,X,Y
	LEAU -35,U

	LDB #$de
	PSHU D,X,Y
	LEAU -32,U

	STX -8,U
	LDB #$ee
	LDY #$ee11
	PSHU D,X,Y
	LEAU -34,U

	LDD -8,U
	ANDA #$F0
	ORA #$01
	LDB #$ed
	STD -8,S
	LDD #$eeee
	LDX #$e4ee
	LDY #$eee1
	PSHU D,X,Y
	LEAU -34,U

	STA -7,U
	LDX #$441e
	LDY #$eeee
	PSHU D,X,Y
	LEAU -34,U

	LDA -7,U
	ANDA #$F0
	ORA #$0e
	STA -7,S
	LDD -41,U
	LDA #$ee
	ANDB #$0F
	ORB #$10
	STD -41,S
	LDD #$eeee
	PSHU D,X,Y
	LEAU -35,U

	LDA -6,U
	ANDA #$F0
	ORA #$0e
	STA -6,S
	LDX #$ee44
	LDY #$1eee
	PSHU B,X,Y
	LEAU -33,U

	STB -7,U
	LDD #$ee44
	LDX #$eeee
	LDY #$eee1
	PSHU D,X,Y
	LEAU -34,U

	LDA #$de
	STA -7,U
	LDA #$ee
	LDY #$eeee
	PSHU D,X,Y
	LEAU -34,U

	LDA #$ed
	STA -7,U
	LDA #$ee
	PSHU D,X,Y
	LEAU -34,U

	LDA #$ed
	STA -7,U
	LDD -42,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -42,S
	LDD #$ee54
	PSHU D,X,Y
	LEAU -36,U

	LDA -5,U
	ANDA #$F0
	ORA #$0e
	STA -5,S
	LDD #$ee55
	PSHU D,X
	LEAU -35,U

	LDX #$e5ee
	PSHU A,X,Y
	LEAU -35,U

	PSHU A,X,Y
	LEAU -35,U

	LDD -42,U
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD -42,S
	LDD #$ecee
	STD -44,U
	LDA -45,U
	ANDA #$F0
	ORA #$0e
	STA -45,S
	LDX #$deee
	PSHU B,X,Y
	LEAU -76,U

	LDA #$e1
	PSHU A,Y
	LEAU -37,U

	STB -42,U
	PSHU B,Y
	RTS

(info)

