(main)IMG.ASM
	ORG $A000
	SETDP $FF
DRAW_Img_TitleScreen_Tails_1
	STS SSAV_Img_TitleScreen_Tails_1+2,PCR

	STD DYN_POS+2,PCR
	LDS ,Y
	LEAS 4561,S

	LDA -60,S
	PSHU A
	ANDA #$F0
	ORA #$06
	STA -60,S
	LDD 59,S
	PSHU D
	ANDA #$F0
	ORA #$06
	LDB #$4d
	STD 59,S
	LDA -20,S
	LDB 20,S
	PSHU S,B,A
	LDA #$67
	STA -20,S
	LDA #$94
	STA 20,S
	LEAS 218,S

	LDX -119,S
	LDD #$69db
	STD -119,S
	LDY -79,S
	PSHU Y,X
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$06
	LDB #$94
	STD -40,S
	LDD #$99bb
	STD -79,S
	LDA -38,S
	STB -38,S
	PULS B,X
	PSHU S,X,B,A
	LDA #$69
	LDX #$4dab
	PSHS A,X
	LEAS 40,S

	LDX 41,S
	PSHU X
	LDD #$99ba
	STD 41,S
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$06
	LDB #$99
	STD 39,S
	PULS A,X
	PSHU S,X,A
	LDX #$96ba
	PSHS B,X
	LEAS 79,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$6999
	LDX #$99ab
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$9999
	LDX #$99ad
	PSHS D,X
	LEAS 40,S

	LDA 38,S
	PSHU A
	ANDA #$F0
	ORA #$04
	STA 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$9999
	LDX #$99bd
	PSHS D,X
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$07
	LDB #$46
	STD 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$7999
	LDX #$996d
	PSHS D,X
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$69
	STD 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$7999
	LDX #$999d
	PSHS D,X
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$99
	STD 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$9999
	LDX #$9996
	PSHS D,X
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$99
	STD 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$7999
	LDX #$9999
	PSHS D,X
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$06
	LDB #$44
	STD 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$7999
	LDX #$9999
	PSHS D,X
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$06
	LDB #$b9
	STD 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$7999
	LDX #$9999
	PSHS D,X
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$99
	STD 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$79bb
	LDX #$9999
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$99aa
	LDX #$9996
	PSHS D,X
	LEAS 38,S

	LDD 40,S
	PSHU D
	ANDA #$0F
	ORA #$90
	LDB #$b9
	STD 40,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$6444
	LDX #$99aa
	LDY #$9996
	PSHS D,X,Y
	LEAS 42,S

	LDD 38,S
	PSHU D
	ANDA #$0F
	ORA #$40
	LDB #$99
	STD 38,S
	LDA 4,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 4,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$99aa
	LDX #$9996
	PSHS D,X
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$06
	LDB #$99
	STD 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$99aa
	LDX #$9996
	PSHS D,X
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$49
	STD 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$99aa
	LDX #$a966
	PSHS D,X
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$46
	STD 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$a9aa
	LDX #$a96d
	PSHS D,X
	LEAS 40,S

	LDD 38,S
	PSHU D
	LDA #$64
	ANDB #$F0
	ORB #$06
	STD 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$a9aa
	LDX #$a66b
	PSHS D,X
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$0F
	ANDB #$F0
	ADDD #$6006
	STD 38,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$a9
	LDX #$aaa6
	LDY #$dbdd
	PSHS A,X,Y
	LEAS 40,S

	LDA 4,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 4,S
	LDA 38,S
	PSHU A
	ANDA #$0F
	ORA #$40
	STA 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$aa7a
	LDX #$a6bb
	PSHS D,X
	LEAS 40,S

	LDA 38,S
	PSHU A
	ANDA #$0F
	ORA #$40
	STA 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$aa73
	LDX #$a6ba
	PSHS D,X
	LEAS 40,S

	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$9a
	LDX #$7ba6
	LDY #$aadd
	PSHS A,X,Y
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$9a9a
	LDX #$abaa
	PSHS D,X
	LEAS 40,S

	LDA 4,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 4,S
	LDA 38,S
	PSHU A
	ANDA #$F0
	ORA #$06
	STA 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$93aa
	LDX #$bbaa
	PSHS D,X
	LEAS 40,S

	LDA 4,S
	PSHU A
	ANDA #$0F
	ORA #$b0
	STA 4,S
	LDA 38,S
	PSHU A
	ANDA #$F0
	ORA #$06
	STA 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$6baa
	LDX #$aaaa
	PSHS D,X
	LEAS 40,S

	LDA 38,S
	PSHU A
	ANDA #$F0
	ORA #$04
	STA 38,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$6a
	LDX #$aaaa
	LDY #$aabd
	PSHS A,X,Y
	LEAS 40,S

	LDA 38,S
	PSHU A
	ANDA #$F0
	ORA #$04
	STA 38,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$66
	LDX #$aaaa
	LDY #$aadd
	PSHS A,X,Y
	LEAS 40,S

	LDA 38,S
	PSHU A
	ANDA #$F0
	ORA #$04
	STA 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$66aa
	LDX #$aaab
	PSHS D,X
	LEAS 40,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0b
	LDB #$aa
	STD 39,S
	LDA 4,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 4,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$baab
	LDX #$aaab
	PSHS D,X
	LEAS 41,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$aa
	STD 38,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$ad
	LDX #$aabb
	PSHS A,X
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$0F
	ORA #$b0
	LDB #$aa
	STD 38,S
	PULS A,X
	PSHU S,X,A
	LDX #$aabd
	PSHS B,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$aa
	LDX #$aad4
	PSHS A,X
	LEAS 39,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$aa
	STD 39,S
	LDA 4,S
	PSHU A
	ANDA #$0F
	ORA #$40
	STA 4,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$aaaa
	LDX #$aa44
	PSHS D,X
	LEAS 41,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$aa
	STD 38,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$60
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDX #$aa46
	PSHS B,X
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$ba
	STD 38,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$60
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$aa
	LDX #$ab66
	PSHS A,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$aabb
	LDX #$6b64
	PSHS D,X
	LEAS 39,S

	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$bb
	LDX #$bbbd
	LDY #$ba64
	PSHS A,X,Y
	LEAS 40,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$0d
	LDB #$dd
	STD 39,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$bb
	LDX #$ddd6
	LDY #$ba64
	PSHS A,X,Y
	LEAS 41,S

	LDD 39,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$6d
	STD 39,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$44d6
	LDX #$aa64
	PSHS D,X
	LEAS 41,S

	PULS A,X
	PSHU S,X,A
	LDA #$dd
	LDX #$aa94
	PSHS A,X
	LEAS 39,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$9dbb
	LDX #$aa94
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$9dbb
	LDX #$aa94
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$96aa
	LDX #$aa94
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$9daa
	LDX #$aa94
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$9daa
	LDX #$aa94
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$94aa
	LDX #$aa64
	PSHS D,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$60
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$96
	LDX #$aaaa
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$60
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$99
	LDX #$aaaa
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$60
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$99
	LDX #$aaaa
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$40
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$99
	LDX #$baab
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$40
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$99
	LDX #$bbbb
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$40
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$99
	LDX #$bbbb
	PSHS A,X
	LEAS 40,S

	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$40
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$69
	LDX #$bbbd
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$69
	LDX #$bbbd
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$49
	LDX #$dbdd
	PSHS A,X
DYN_POS

	LDS #$0000
	LEAS 4542,S

	LDD -1,S
	PSHU D
	ANDA #$F0
	ORA #$06
	LDB #$94
	STD -1,S
	LDA -40,S
	LDX 39,S
	PSHU S,X,A
	LDA #$64
	STA -40,S
	LDA #$67
	STD 39,S
	LEAS 198,S

	LDX -119,S
	LDY -79,S
	PSHU Y,X
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$06
	LDB #$4d
	STD -40,S
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$06
	LDB #$99
	STD 39,S
	LDD #$9994
	STD -119,S
	LDA #$94
	STD -79,S
	LDX 41,S
	PSHU X
	LDA #$bb
	STD 41,S
	LDA -38,S
	STB -38,S
	PULS B,X
	PSHU S,X,B,A
	LDA #$69
	LDX #$db94
	PSHS A,X
	LEAS 79,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$6999
	LDX #$ba94
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$9999
	LDX #$bb94
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$9999
	LDX #$6b94
	PSHS D,X
	LEAS 40,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$06
	LDB #$99
	STD 39,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$9999
	LDX #$9694
	PSHS D,X
	LEAS 41,S

	LDD 37,S
	PSHU D
	LDA #$44
	ANDB #$F0
	ORB #$09
	STD 37,S
	PULS A,X
	PSHU S,X,A
	LDA #$99
	LDX #$9994
	PSHS A,X
	LEAS 39,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$9999
	LDX #$9994
	PSHS D,X
	LEAS 38,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$9969
	LDX #$9999
	LDY #$9994
	PSHS D,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$4967
	LDX #$9999
	LDY #$9964
	PSHS D,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$b69a
	LDX #$9999
	LDY #$9964
	PSHS D,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$699a
	LDX #$9999
	LDY #$9964
	PSHS D,X,Y
	LEAS 40,S

	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$9977
	LDX #$9999
	LDY #$9964
	PSHS D,X,Y
	LEAS 40,S

	LDA 5,S
	PSHU A
	ANDA #$0F
	ORA #$60
	STA 5,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$94
	LDX #$7799
	LDY #$9999
	PSHS A,X,Y
	LEAS 40,S

	LDA 5,S
	PSHU A
	ANDA #$0F
	ORA #$60
	STA 5,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$4b
	LDX #$7999
	LDY #$a999
	PSHS A,X,Y
	LEAS 40,S

	LDA 5,S
	PSHU A
	ANDA #$0F
	ORA #$60
	STA 5,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$49
	LDX #$9999
	LDY #$a999
	PSHS A,X,Y
	LEAS 40,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$06
	LDB #$94
	STD 39,S
	PULS D,X,Y
	PSHU S,Y,X,D
	LDD #$9999
	LDX #$99ab
	LDY #$994d
	PSHS D,X,Y
	LEAS 41,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$06
	LDB #$49
	STD 38,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$99
	LDX #$99aa
	LDY #$99db
	PSHS A,X,Y
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ANDB #$F0
	ADDD #$0409
	STD 38,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$99
	LDX #$99aa
	LDY #$99bd
	PSHS A,X,Y
	LEAS 40,S

	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$99
	STD 39,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDX #$99a3
	LDY #$99bd
	PSHS B,X,Y
	LEAS 41,S

	LDD 37,S
	PSHU D
	ANDA #$0F
	ORA #$40
	LDB #$64
	STD 37,S
	LDA 3,S
	PSHU A
	ANDA #$0F
	ORA #$d0
	STA 3,S
	PULS A,X
	PSHU S,X,A
	LDA #$99
	LDX #$ba99
	PSHS A,X
	LEAS 39,S

	LDD 38,S
	PSHU D
	ANDA #$0F
	ANDB #$0F
	ADDD #$4090
	STD 38,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$99
	LDX #$993a
	LDY #$96dd
	PSHS A,X,Y
	LEAS 40,S

	LDD 39,S
	PSHU D
	ANDA #$0F
	ORA #$90
	LDB #$69
	STD 39,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$99
	LDX #$99aa
	LDY #$96bb
	PSHS A,X,Y
	LEAS 41,S

	LDD 38,S
	PSHU D
	ANDA #$0F
	ORA #$40
	LDB #$69
	STD 38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$99aa
	LDX #$6dbd
	PSHS D,X
	LEAS 40,S

	LDD 37,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0640
	STD 37,S
	LDD 39,S
	PSHU D
	ANDA #$F0
	ORA #$06
	LDB #$79
	STD 39,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$79aa
	LDX #$6bdd
	PSHS D,X
	LEAS 41,S

	LDD 36,S
	PSHU D
	ANDA #$F0
	ANDB #$0F
	ADDD #$0640
	STD 36,S
	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$06
	LDB #$a3
	STD 38,S
	PULS A,X
	PSHU S,X,A
	LDA #$aa
	LDX #$babb
	PSHS A,X
	LEAS 40,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$06
	LDB #$d3
	STD 38,S
	LDA 36,S
	PSHU A
	ANDA #$F0
	ORA #$04
	STA 36,S
	PULS A,X
	PSHU S,X,A
	LDA #$ba
	LDX #$aaab
	PSHS A,X
	LEAS 40,S

	LDA 36,S
	PSHU A
	ANDA #$F0
	ORA #$04
	STA 36,S
	PULS A,X
	PSHU S,X,A
	LDA #$aa
	LDX #$aaab
	PSHS A,X
	LEAS 39,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$3baa
	LDX #$aabb
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$aaaa
	LDX #$aabd
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$aaaa
	LDX #$aabb
	PSHS D,X
	LEAS 39,S

	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$bb
	LDX #$aaaa
	LDY #$aabb
	PSHS A,X,Y
	LEAS 40,S

	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$bb
	LDX #$aaaa
	LDY #$aadd
	PSHS A,X,Y
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$bbaa
	LDX #$aaaa
	PSHS D,X
	LEAS 40,S

	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$db
	LDX #$aaaa
	LDY #$ab44
	PSHS A,X,Y
	LEAS 40,S

	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$ba
	LDX #$aaaa
	LDY #$ab66
	PSHS A,X,Y
	LEAS 40,S

	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$db
	LDX #$aaaa
	LDY #$bda9
	PSHS A,X,Y
	LEAS 40,S

	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$db
	LDX #$aaaa
	LDY #$b4b6
	PSHS A,X,Y
	LEAS 40,S

	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$da
	LDX #$aaab
	LDY #$d4ba
	PSHS A,X,Y
	LEAS 40,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$0b
	LDB #$dd
	STD 40,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$da
	LDX #$bbbb
	LDY #$46bb
	PSHS A,X,Y
	LEAS 42,S

	LDD 38,S
	PSHU D
	ANDA #$F0
	ORA #$0b
	LDB #$46
	STD 38,S
	PULS A,X
	PSHU S,X,A
	LDA #$dd
	LDX #$6dbb
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$dd
	LDX #$dbab
	PSHS A,X
	LEAS 38,S

	LDD 40,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$99
	STD 40,S
	PULS A,X,Y
	PSHU S,Y,X,A
	LDA #$db
	LDX #$69bb
	LDY #$bba4
	PSHS A,X,Y
	LEAS 42,S

	LDD 38,S
	PSHU D
	ANDA #$0F
	ORA #$d0
	LDB #$77
	STD 38,S
	PULS A,X
	PSHU S,X,A
	LDA #$db
	LDX #$baa4
	PSHS A,X
	LEAS 40,S

	PULS A,X
	PSHU S,X,A
	LDA #$ab
	LDX #$aaba
	PSHS A,X
	LEAS 39,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$77ab
	LDX #$aaba
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$97da
	LDX #$aaaa
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$69aa
	LDX #$aaab
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$69aa
	LDX #$aaab
	PSHS D,X
	LEAS 40,S

	LDD 40,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$ba
	STD 40,S
	LDD 80,S
	PSHU D
	ANDA #$F0
	ORA #$09
	LDB #$bb
	STD 80,S
	LDD 120,S
	PSHU D
	ANDA #$F0
	ORA #$06
	LDB #$4b
	STD 120,S
	LDX 42,S
	LDY 82,S
	PSHU Y,X
	LDD 122,S
	PSHU D
	LDD #$aab6
	STD 42,S
	STD 82,S
	STD 122,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$69ba
	LDX #$aaab
	PSHS D,X
	LEAS 280,S

	LDD -120,S
	PSHU D
	ANDA #$F0
	ORA #$04
	LDB #$4b
	STD -120,S
	LDD -80,S
	PSHU D
	ANDA #$F0
	ORA #$04
	LDB #$6b
	STD -80,S
	LDD -40,S
	PSHU D
	ANDA #$F0
	ORA #$04
	LDB #$9b
	STD -40,S
	LDX -118,S
	LDY -78,S
	PSHU Y,X
	LDD -38,S
	PSHU D
	LDD #$bad6
	STD -118,S
	LDA #$bb
	STD -78,S
	LDB #$46
	STD -38,S
	PULS X,Y
	PSHU S,Y,X
	LDD #$4494
	LDX #$bb46
	PSHS D,X
	LEAS 40,S

	PULS X,Y
	PSHU S,Y,X
	LDD #$6496
	LDX #$bd44
	PSHS D,X
SSAV_Img_TitleScreen_Tails_1
	LDS #$0000
	RTS

ERASE_Img_TitleScreen_Tails_1
	STS ERASE_SSAV_Img_TitleScreen_Tails_1+2,PCR

ERASE_CODE_Img_TitleScreen_Tails_1_1
	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD -38,S
	STX -118,S
	STY -78,S

	PULU D,X,Y
	STD -40,S
	STX -80,S
	STY -120,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,Y
	STD 122,S
	STX 42,S
	STY 82,S

	PULU D,X,Y
	STD 120,S
	STX 80,S
	STY 40,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 40,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 40,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X,S
	PSHS D,X

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 36,S

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 36,S
	STX 38,S

	PULU A,X,S
	PSHS A,X

	PULU D,X
	STD 38,S
	STX 36,S

	PULU D,X,S
	PSHS D,X

	PULU D,X
	STD 39,S
	STX 37,S

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

	PULU D
	STD 38,S

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 3,S
	STX 37,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 39,S

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

	PULU D
	STD 39,S

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

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 37,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 39,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU A,B,X,S
	PSHS B,X
	STA -38,S

	PULU D,X,Y
	STD 41,S
	STX 39,S
	STY -40,S

	PULU D,X
	STD -119,S
	STX -79,S

	PULU A,X,S
	STA -40,S
	STX 39,S

	PULU D
	STD -1,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU A,X,S
	PSHS A,X

	PULU A
	STA 3,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 39,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 39,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 3,S
	STX 38,S

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 3,S
	STX 38,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 4,S
	STX 39,S

	PULU A,X,S
	PSHS A,X

	PULU A,X,S
	PSHS A,X

	PULU D
	STD 38,S

	PULU A,X,S
	PSHS A,X

	PULU A,X
	STA 3,S
	STX 38,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 4,S
	STX 39,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 38,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU A
	STA 38,S

	PULU D,X,S
	PSHS D,X

	PULU A,B
	STA 38,S
	STB 4,S

	PULU D,X,S
	PSHS D,X

	PULU A,B
	STA 38,S
	STB 4,S

	PULU D,X,S
	PSHS D,X

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 38,S

	PULU D,X,S
	PSHS D,X

	PULU A,B
	STA 38,S
	STB 4,S

	PULU A,X,Y,S
	PSHS A,X,Y

	PULU D
	STD 38,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU D,X,S
	PSHS D,X

	PULU A,X
	STA 4,S
	STX 38,S

	PULU D,X,Y,S
	PSHS D,X,Y

	PULU D
	STD 40,S

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

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU D,X,S
	PSHS D,X

	PULU D
	STD 38,S

	PULU D,X,S
	PSHS D,X

	PULU A
	STA 38,S

	PULU D,X,S
	PSHS D,X

	PULU D,X,S
	PSHS D,X

	PULU A,X,S
	PSHS A,X

	PULU D,X
	STD 39,S
	STX 41,S

	PULU A,B,X,S
	PSHS B,X
	STA -38,S

	PULU D,X,Y
	STD -40,S
	STX -119,S
	STY -79,S

	PULU A,B,S
	STA -20,S
	STB 20,S

	PULU D
	STD 59,S

	PULU A
	STA -60,S

ERASE_SSAV_Img_TitleScreen_Tails_1
	LDS #$0000
	RTS

