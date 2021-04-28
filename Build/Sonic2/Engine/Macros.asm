_ldd MACRO
        ldd   #(\1*256)+\2
 ENDM
 
_ldx MACRO
        ldx   #(\1*256)+\2
 ENDM
 
_ldy MACRO
        ldy   #(\1*256)+\2
 ENDM
 
_ldu MACRO
        ldu   #(\1*256)+\2
 ENDM  
 
_lds MACRO
        lds   #(\1*256)+\2
 ENDM   
 
_SetCartPageA MACRO
 IFDEF T2
        bmi   RAMPage@
        ldb   #$00
        stb   $E7E6
        ldb   #$AA                     ; sequence pour commutation de page T.2
        stb   $0555
        ldb   #$55
        stb   $02AA
        ldb   #$C0
        stb   $0555
        sta   $0555                    ; selection de la page T.2 en zone cartouche
        bra   End@
RAMPage@ sta   $E7E6                    ; selection de la page RAM en zone cartouche
End@    equ  *
 ELSE
        sta   $E7E6                    ; selection de la page RAM en zone cartouche
 ENDC
 ENDM      