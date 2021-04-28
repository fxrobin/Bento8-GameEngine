********************************************************************************
* LoadGameMode - Charge un nouveau niveau de jeu si requis
* ------------------------------------------------------------------------------
* 
*
********************************************************************************

GameMode         fcb $00
ChangeGameMode   fcb $00

LoadGameMode
        lda   ChangeGameMode
        bne   LoadGameModeNow
        rts
        
LoadGameModeNow

 IFDEF T2
        ldd   #$0000                   ; page 0 et mode cartouche
        stb   $E7E6
        
        ldb   #$AA                     ; sequence pour commutation de page T.2
        stb   $0555
        ldb   #$55
        stb   $02AA
        ldb   #$C0
        stb   $0555
        sta   $0555                    ; selection de la page T.2 en zone cartouche
        
        lda   GameMode
        ldb   Glb_Cur_Game_Mode
        jmp   Build_RAMLoaderManager          
 ELSE
		ldb   #$64                     ; Page 4 contains RAMLoaderManager
        stb   $E7E6
        lda   GameMode
        ldb   Glb_Cur_Game_Mode
        jmp   >$0000          
 ENDC
            