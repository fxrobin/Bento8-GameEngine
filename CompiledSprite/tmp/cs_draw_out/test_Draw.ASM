(main)IMGD.ASM
	ORG $A000
	SETDP $FF
DRAW_test
	STS SSAV_test+1,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS 486,S

	LDD #$eeee
	STD -79,S
	STD -39,S
	LDA 3,S
	ANDA #$0F
	ORA #$e0
	STA 3,S
	LDX #$eeee
	PSHS B,X
	LEAS 40,S

	LDD #$ee1e
	PSHS D,X
	LEAS 40,S

	LDA 39,S
	ANDA #$F0
	ORA #$0e
	LDB #$ee
	STD 39,S
	LDD #$eeee
	PSHS D,X
	LEAS 41,S

	LDA 3,S
	ANDA #$0F
	ORA #$e0
	STA 3,S
	PSHS B,X
	LEAS 38,S

	LDD #$eeed
	LDX #$e1ee
	LDU #$eeee
	PSHS D,X,U
	LEAS 40,S

	LDB #$ee
	PSHS D,X,U
	LEAS 40,S

	LDA 39,S
	ANDA #$F0
	ORA #$0e
	LDB #$ee
	STD 39,S
	LDD #$dede
	LDX #$51ee
	PSHS D,X,U
	LEAS 41,S

	LDA 5,S
	ANDA #$0F
	ORA #$e0
	STA 5,S
	LDA 38,S
	ANDA #$F0
	ORA #$0e
	LDB #$ee
	STD 38,S
	LDA #$d5
	LDX #$5eee
	PSHS A,X,U
	LEAS 40,S

	LDA 5,S
	ANDA #$0F
	ORA #$10
	STA 5,S
	LDA #$e5
	PSHS A,X,U
	LEAS 38,S

	LDA #$ed
	LDX #$ee54
	LDY #$4eee
	PSHS A,X,Y,U
	LEAS 40,S

	PSHS A,X,Y,U
	LEAS 40,S

	LDX #$ee44
	LDU #$eee1
	PSHS B,X,Y,U
	LEAS 40,S

	LDA 6,S
	ANDA #$0F
	ORA #$10
	STA 6,S
	LDD #$eeee
	LDX #$ee4e
	LDU #$eeee
	PSHS D,X,U
	LEAS 39,S

	LDA #$11
	LDX #$eeee
	LDY #$ee4e
	PSHS A,X,Y,U
	LEAS 40,S

	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$1e
	PSHS A,X,Y,U
	LEAS 40,S

	LDY #$eeee
	LDU #$eee1
	PSHS B,X,Y,U
	LEAS 40,S

	LDA 6,S
	ANDA #$0F
	ORA #$10
	STA 6,S
	LDD #$eeee
	PSHS D,X,Y
	LEAS 40,S

	LDA 6,S
	ANDA #$0F
	ORA #$10
	STA 6,S
	PSHS X,Y,U
	LEAS 40,S

	LDA 6,S
	ANDA #$0F
	ORA #$10
	STA 6,S
	PSHS X,Y,U
	LEAS 40,S

	LDD #$eeee
	PSHS D,X,Y
	LEAS 40,S

	PSHS D,X,Y
	LEAS 40,S

	LDU #$eede
	PSHS D,X,U
	LEAS 40,S

	LDX #$eede
	LDU #$eece
	PSHS D,X,U
	LEAS 40,S

	LDA 6,S
	ANDA #$0F
	ORA #$e0
	STA 6,S
	LDD #$eeee
	LDX #$eebd
	PSHS D,X,U
	LEAS 40,S

	LDX #$eeee
	LDY #$0bee
	LDU #$deee
	PSHS A,X,Y,U
	LEAS 40,S

	LDA 7,S
	ANDA #$0F
	ORA #$e0
	STA 7,S
	LDX #$eeeb
	LDY #$00ee
	PSHS B,X,Y,U
	LEAS 40,S

	STB 7,S
	LDU #$eeee
	PSHS B,X,Y,U
	LEAS 40,S

	STB 7,S
	LDX #$eee0
	PSHS B,X,Y,U
	LEAS 40,S

	STB 7,S
	LDX #$eeb0
	PSHS B,X,Y,U
	LEAS 40,S

	STB 7,S
	LDX #$ee00
	PSHS B,X,Y,U
	LEAS 40,S

	STB 7,S
	PSHS B,X,Y,U
	LEAS 40,S

	LDB 7,S
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD 7,S
	LDA #$be
	LDY #$d0ee
	PSHS A,X,Y,U
	LEAS 40,S

	LDB 7,S
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD 7,S
	PSHS A,X,Y,U
	LEAS 40,S

	LDB 7,S
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD 7,S
	LDY #$10ee
	PSHS A,X,Y,U
	LEAS 40,S

	STU 7,S
	LDA #$0b
	PSHS A,X,Y,U
	LEAS 40,S

	LDD #$ee1e
	STD 7,S
	LDA #$0b
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$ee
	STA 7,S
	LDA #$b0
	LDY #$1044
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$ee
	STA 7,S
	LDA #$d0
	LDY #$1040
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$e1
	STA 7,S
	LDA #$e0
	PSHS A,X,Y,U
	LEAS 40,S

	LDA 7,S
	ANDA #$0F
	ORA #$10
	STA 7,S
	LDA 40,S
	ANDA #$F0
	ORA #$00
	LDB #$10
	STD 40,S
	LDA #$e0
	LDX #$bb00
	LDY #$1044
	PSHS A,X,Y,U
	LEAS 42,S

	LDA 5,S
	ANDA #$0F
	ORA #$10
	STA 5,S
	LDA 38,S
	ANDA #$F0
	ORA #$0d
	LDB #$10
	STD 38,S
	LDA #$00
	LDX #$d044
	PSHS A,X,U
	LEAS 40,S

	LDA 38,S
	ANDA #$F0
	ORA #$0e
	LDB #$10
	STD 38,S
	LDA #$00
	LDX #$0045
	PSHS A,X,U
	LEAS 40,S

	LDX #$0044
	PSHS A,X,U
	LEAS 39,S

	LDD #$1400
	LDX #$0444
	PSHS D,X,U
	LEAS 40,S

	LDA #$bd
	LDX #$4454
	PSHS D,X,U
	LEAS 39,S

	LDA 7,S
	ANDA #$0F
	ORA #$e0
	STA 7,S
	LDA #$d1
	LDX #$14b0
	LDY #$4444
	PSHS A,X,Y,U
	LEAS 40,S

	LDA 7,S
	ANDA #$0F
	ORA #$e0
	STA 7,S
	LDA #$10
	LDX #$1444
	PSHS A,X,Y,U
	LEAS 40,S

	LDA 7,S
	ANDA #$0F
	ORA #$e0
	STA 7,S
	LDA 40,S
	ANDA #$F0
	ORA #$01
	LDB #$d4
	STD 40,S
	LDA #$11
	PSHS A,X,Y,U
	LEAS 42,S

	LDA 38,S
	ANDA #$F0
	ORA #$0b
	LDB #$34
	STD 38,S
	LDD #$4444
	LDX #$44ee
	PSHS D,X,U
	LEAS 40,S

	LDA 39,S
	ANDA #$F0
	ORA #$03
	LDB #$44
	STD 39,S
	LDD #$4444
	LDX #$45ee
	PSHS D,X,U
	LEAS 41,S

	LDX #$5eee
	PSHS A,X,U
	LEAS 39,S

	LDX #$31ee
	PSHS D,X,U
	LEAS 40,S

	LDX #$1ee1
	PSHS D,X,U
	LEAS 40,S

	LDA 40,S
	ANDA #$F0
	ORA #$05
	LDB #$31
	STD 40,S
	LDD #$5445
	PSHS D,X,U
	LEAS 42,S

	LDD #$eee5
	PSHS D,U
	LEAS 39,S

	LDA #$33
	LDX #$5e54
	PSHS A,X,U
	LEAS 40,S

	LDA 39,S
	ANDA #$F0
	ORA #$03
	LDB #$54
	STD 39,S
	LDA #$55
	LDX #$4540
	LDU #$11ee
	PSHS A,X,U
	LEAS 41,S

	LDA 38,S
	ANDA #$F0
	ORA #$03
	LDB #$44
	STD 38,S
	LDD #$4440
	PSHS D,U
	LEAS 40,S

	LDA 38,S
	ANDA #$F0
	ORA #$05
	LDB #$44
	STD 38,S
	PSHS Y,U
	LEAS 40,S

	LDD #$4054
	LDX #$511e
	PSHS D,X
	LEAS 38,S

	LDD 5,S
	ANDA #$F0
	ANDB #$0F
	ADDD #$01e0
	STD 5,S
	LDA #$35
	LDX #$4400
	LDU #$3441
	PSHS A,X,U
	LEAS 40,S

	LDA 6,S
	ANDA #$0F
	ORA #$e0
	STA 6,S
	LDA #$35
	LDU #$3445
	PSHS A,X,U
	LEAS 40,S

	LDA 6,S
	ANDA #$0F
	ORA #$10
	STA 6,S
	LDA #$55
	LDX #$4440
	LDU #$1544
	PSHS A,X,U
	LEAS 40,S

	LDA #$54
	LDU #$1344
	PSHS A,Y,U
	LEAS 40,S

	LDU #$e144
	PSHS A,Y,U
	LEAS 40,S

	LDU #$ee44
	PSHS A,Y,U
	LEAS 40,S

	LDA #$44
	PSHS A,Y,U
	LEAS 40,S

	PSHS A,Y,U
	LEAS 41,S

	LDA 42,S
	ANDA #$F0
	ORA #$0e
	LDB #$14
	STD 42,S
	LDA 83,S
	ANDA #$F0
	ORA #$05
	STA 83,S
	LDU #$ee54
	PSHS Y,U
DYN_POS

	LDS #$0000
	LEAS 447,S

	LDA #$ee
	STA -39,S
	LDX #$eeee
	PSHS A,X
	LEAS 40,S

	LDA 39,S
	ANDA #$F0
	ORA #$0e
	LDB #$ec
	STD 39,S
	STX 41,S
	LDA 43,S
	ANDA #$0F
	ORA #$e0
	STA 43,S
	LDA #$e1
	PSHS A,X
	LEAS 79,S

	LDA #$ee
	LDX #$deee
	LDU #$eeee
	PSHS A,X,U
	LEAS 40,S

	LDX #$e5ee
	PSHS A,X,U
	LEAS 40,S

	LDA 39,S
	ANDA #$F0
	ORA #$0e
	LDB #$ee
	STD 39,S
	LDA #$ee
	PSHS A,X,U
	LEAS 41,S

	LDA 4,S
	ANDA #$0F
	ORA #$e0
	STA 4,S
	LDD #$55ee
	PSHS D,U
	LEAS 38,S

	LDA #$ed
	LDX #$ee54
	LDY #$eeee
	PSHS A,X,Y,U
	LEAS 40,S

	LDX #$ee44
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$de
	PSHS A,X,Y,U
	LEAS 40,S

	LDA 39,S
	ANDA #$F0
	ORA #$0e
	LDB #$ee
	STD 39,S
	LDU #$eee1
	PSHS B,X,Y,U
	LEAS 41,S

	LDA 5,S
	ANDA #$0F
	ORA #$10
	STA 5,S
	LDA 38,S
	ANDA #$F0
	ORA #$0e
	LDB #$ee
	STD 38,S
	LDX #$441e
	PSHS B,X,Y
	LEAS 40,S

	PSHS B,X,Y
	LEAS 38,S

	LDA 39,S
	ANDA #$F0
	ORA #$01
	LDB #$ed
	STD 39,S
	LDX #$eeee
	LDY #$441e
	LDU #$eeee
	PSHS B,X,Y,U
	LEAS 41,S

	LDY #$e4ee
	LDU #$eee1
	PSHS X,Y,U
	LEAS 38,S

	LDA #$11
	STA 7,S
	LDY #$eeee
	LDU #$eeee
	PSHS B,X,Y,U
	LEAS 40,S

	LDA 7,S
	ANDA #$0F
	ORA #$10
	STA 7,S
	LDX #$deee
	PSHS B,X,Y,U
	LEAS 40,S

	LDX #$eeee
	PSHS B,X,Y,U
	LEAS 40,S

	LDU #$eee1
	PSHS B,X,Y,U
	LEAS 40,S

	LDU #$ee11
	PSHS B,X,Y,U
	LEAS 40,S

	PSHS B,X,Y,U
	LEAS 40,S

	PSHS B,X,Y,U
	LEAS 40,S

	LDA 40,S
	ANDA #$F0
	ORA #$0e
	LDB #$ee
	STD 40,S
	PSHS B,X,Y,U
	LEAS 42,S

	LDA 38,S
	ANDA #$F0
	ORA #$0e
	LDB #$ee
	STD 38,S
	LDU #$ed11
	PSHS B,X,U
	LEAS 40,S

	LDA 38,S
	ANDA #$F0
	ORA #$0e
	LDB #$ee
	STD 38,S
	LDX #$edee
	LDU #$ece1
	PSHS B,X,U
	LEAS 40,S

	LDX #$bbee
	LDU #$ecee
	PSHS B,X,U
	LEAS 38,S

	LDA 7,S
	ANDA #$0F
	ORA #$e0
	STA 7,S
	LDX #$eeee
	LDY #$b0ee
	LDU #$edee
	PSHS B,X,Y,U
	LEAS 40,S

	STB 7,S
	LDY #$00de
	PSHS B,X,Y,U
	LEAS 40,S

	STB 7,S
	LDY #$00be
	LDU #$eeee
	PSHS B,X,Y,U
	LEAS 40,S

	STB 7,S
	LDY #$000e
	PSHS B,X,Y,U
	LEAS 40,S

	LDB 7,S
	LDA #$ee
	ANDB #$0F
	ORB #$e0
	STD 7,S
	LDA #$ee
	LDY #$000d
	PSHS A,X,Y,U
	LEAS 40,S

	STX 7,S
	LDA #$ed
	LDY #$bd0b
	PSHS A,X,Y,U
	LEAS 40,S

	STX 7,S
	LDY #$d10b
	PSHS A,X,Y,U
	LEAS 40,S

	STX 7,S
	LDX #$eeeb
	LDY #$b10b
	PSHS A,X,Y,U
	LEAS 40,S

	STU 7,S
	LDA 40,S
	ANDA #$F0
	ORA #$0d
	LDB #$ee
	STD 40,S
	LDA #$ed
	LDY #$bd0b
	PSHS A,X,Y,U
	LEAS 42,S

	LDA 38,S
	ANDA #$F0
	ORA #$0d
	LDB #$ee
	STD 38,S
	LDA #$e0
	LDX #$bb0b
	LDY #$eeee
	PSHS A,X,Y,U
	LEAS 40,S

	LDA 38,S
	ANDA #$F0
	ORA #$0e
	LDB #$ee
	STD 38,S
	LDA #$e0
	LDX #$0d0b
	PSHS A,X,Y,U
	LEAS 40,S

	LDA 38,S
	ANDA #$F0
	ORA #$0e
	LDB #$be
	STD 38,S
	LDA #$b0
	LDX #$010b
	PSHS A,X,Y,U
	LEAS 40,S

	LDY #$5eee
	LDU #$eee1
	PSHS A,X,Y,U
	LEAS 39,S

	LDA 7,S
	ANDA #$0F
	ORA #$10
	STA 7,S
	LDA #$be
	LDX #$0001
	LDY #$0b45
	LDU #$eeee
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$01
	LDY #$0444
	PSHS A,X,Y,U
	LEAS 40,S

	LDX #$000b
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$0b
	LDX #$0000
	LDY #$4444
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$00
	LDU #$eee1
	PSHS A,X,Y,U
	LEAS 40,S

	LDA 6,S
	ANDA #$0F
	ORA #$e0
	STA 6,S
	LDY #$0044
	LDU #$44ee
	PSHS X,Y,U
	LEAS 40,S

	LDA #$b0
	LDY #$4444
	LDU #$eeee
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$e0
	LDX #$4000
	LDY #$4445
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$11
	LDX #$4404
	LDY #$454e
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$01
	LDX #$4444
	LDY #$444e
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$11
	LDY #$445e
	PSHS A,X,Y,U
	LEAS 40,S

	LDY #$44ee
	PSHS A,X,Y,U
	LEAS 40,S

	LDA #$db
	PSHS A,X,Y,U
	LEAS 41,S

	LDY #$441e
	PSHS X,Y,U
	LEAS 40,S

	LDY #$44ee
	PSHS X,Y,U
	LEAS 40,S

	LDA 6,S
	ANDA #$0F
	ORA #$e0
	STA 6,S
	LDD #$5544
	LDX #$53ee
	PSHS D,X,U
	LEAS 41,S

	LDA 5,S
	ANDA #$0F
	ORA #$e0
	STA 5,S
	LDX #$33ee
	PSHS B,X,U
	LEAS 40,S

	LDA 5,S
	ANDA #$0F
	ORA #$e0
	STA 5,S
	LDA #$55
	LDX #$3eee
	LDU #$1eee
	PSHS A,X,U
	LEAS 40,S

	LDA 5,S
	ANDA #$0F
	ORA #$e0
	STA 5,S
	LDA #$11
	LDX #$55ee
	LDU #$51ee
	PSHS A,X,U
	LEAS 40,S

	LDA #$13
	LDX #$ee41
	LDU #$eeee
	PSHS D,X,U
	LEAS 40,S

	LDA #$55
	LDX #$5e45
	LDU #$1eee
	PSHS D,X,U
	LEAS 40,S

	LDX #$4e04
	LDU #$11ee
	PSHS D,X,U
	LEAS 40,S

	LDA #$54
	LDX #$4544
	PSHS D,X,U
	LEAS 40,S

	LDA #$1e
	STA 5,S
	LDA #$54
	LDX #$0544
	PSHS D,X
	LEAS 40,S

	LDA 5,S
	ANDA #$F0
	ORA #$01
	STA 5,S
	LDD #$4444
	LDX #$0444
	PSHS D,X
	LEAS 40,S

	LDX #$4444
	PSHS D,X
	LEAS 40,S

	LDA 4,S
	ANDA #$0F
	ORA #$50
	STA 4,S
	LDD #$4444
	PSHS D,X
	LEAS 40,S

	LDA 4,S
	ANDA #$0F
	ORA #$40
	STA 4,S
	LDU #$4454
	PSHS X,U
	LEAS 40,S

	LDU #$3445
	PSHS B,X,U
	LEAS 40,S

	LDU #$1544
	PSHS B,X,U
	LEAS 40,S

	LDA 40,S
	ANDA #$F0
	ORA #$04
	LDB #$44
	STD 40,S
	LDX #$4445
	LDU #$e344
	PSHS B,X,U
	LEAS 42,S

	LDB 41,S
	LDA #$ee
	ANDB #$0F
	ORB #$40
	STD 41,S
	LDA 82,S
	ANDA #$0F
	ORA #$40
	STA 82,S
	LDA #$45
	LDX #$ee44
	PSHS A,X
SSAV_test
	LDS #$0000
	RTS

