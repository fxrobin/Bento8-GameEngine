(main)TEST
   org $6200

	LDD #$ffff
	LDX #$ffff
	LDY #$ffff
	LDU #$ffff
	PSHS D,X,Y,U
(info)

	LDD #$ffff
	STD 40,S
	STD 57,S
	STD 57,S
	STD 57,S
(info)