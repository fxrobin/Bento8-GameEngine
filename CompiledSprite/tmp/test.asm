(main)TEST
   org $6200

        STS DYN_S+2,PCR
DYN_S
        LDS   #$0000
(info)

		STY DYN_Y+2,PCR
DYN_Y
        LDS   #$0000
(info)
                
        STU DYN_U+2,PCR
DYN_U
        LDS   #$0000
(info)        
                
        STX DYN_X+2,PCR
DYN_X
        LDS   #$0000
(info)        
                
		STD DYN_D+2,PCR
DYN_D
        LDS   #$0000
(info)        
               		
		STA DYN_A+1,PCR
DYN_A
        LDA   #$00
(info)        
                		
		STB DYN_B+1,PCR
DYN_B
        LDB   #$00	
(info)