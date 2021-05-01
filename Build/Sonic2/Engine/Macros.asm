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
        bpl   RAMPg@
        sta   Glb_Page
        
        lda   $E7E6
        anda  #$DF                     ; passe le bit5 a 0 pour cartouche au lieu de 1 pour RAM
        sta   $E7E6                    ; TODO eventuellement a remplacer par un clr au lieu des trois instr.
        
        lda   #$AA                     ; sequence pour commutation de page T.2
        sta   $0555
        lda   #$55
        sta   $02AA
        lda   #$C0
        sta   $0555
        lda   Glb_Page
        sta   $0555                    ; selection de la page T.2 en zone cartouche
        bra   End@
RAMPg@  sta   $E7E6                    ; selection de la page RAM en zone cartouche (bit 5 integre au numero de page)
        sta   Glb_Page
End@    equ   *
 ELSE
        sta   $E7E6                    ; selection de la page RAM en zone cartouche
 ENDC
 ENDM      
 
_GetCartPageA MACRO
 IFDEF T2
        lda   Glb_Page
 ELSE
        lda   $E7E6
 ENDC
 ENDM      