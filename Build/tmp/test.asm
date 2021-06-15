(main)test
 *	opt c,ct

        org   $A000


        ldd   #$0CDF
WaitPhase        
        exg   a,b
        exg   a,b
        subd  1
        bne   WaitPhase
        exg   a,b
        ldb   #$16                     ; D: $0016 now 


        