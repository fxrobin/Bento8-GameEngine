********************************************************************************
* LoadGameMode - Charge un nouveau niveau de jeu si requis
* ------------------------------------------------------------------------------
* 
*
********************************************************************************

GameMode         fcb $00

LoadGameMode
        lda   GameMode                 * Game Mode to call
        bne   LoadGameModeNow
        rts
        
LoadGameModeNow
		ldb   #$64                     * Page 4 contains RAMLoaderManager
        stb   $E7E6                    *
        jmp   >$0000                   * Call RAMLoaderManager           