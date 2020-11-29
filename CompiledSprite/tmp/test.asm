(main)TEST
   org $0000
   
constant1 equ $1A
constant2 equ $E9

        ldd   #(constant1*256)+constant2
        sta   $A000
        stb   $B000