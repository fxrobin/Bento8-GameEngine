* ---------------------------------------------------------------------------
* UpdatePalette
* -------------
* Subroutine to update palette
* should be called just after WaitVBL
*
* input REG : none
* reset REG : [d] [x] [y]
* ---------------------------------------------------------------------------

Refresh_palette fcb   $FF            *@globals
Cur_palette     fdb   Dyn_palette    *@globals
Dyn_palette     rmb   $20,0          *@globals
Black_palette   rmb   $20,0          *@globals
White_palette   fdb   $ff0f          *@globals
                fdb   $ff0f
                fdb   $ff0f
                fdb   $ff0f
                fdb   $ff0f
                fdb   $ff0f
                fdb   $ff0f
                fdb   $ff0f
                fdb   $ff0f               
                fdb   $ff0f
                fdb   $ff0f
                fdb   $ff0f
                fdb   $ff0f
                fdb   $ff0f
                fdb   $ff0f
                fdb   $ff0f

UpdatePalette *@globals
        tst   Refresh_palette
        bne   UPP_return
        
        ldy   #0405                    * 3328 (52 lignes) - 88 (cycles apres VBL)
UPP_Tempo        
        leay  -1,y
        bne   UPP_Tempo                * tempo pour etre dans la bordure invisible        
        ldb   #$E7
        tfr   B,DP        
    	ldx   Cur_palette
    	clr   <$DB                     * indice couleur a 0
        LDY   #$0010			       * init cpt
UPP_SetColor
    	ldd   ,x++			           * chargement de la couleur et increment du poiteur x
    	sta   <$DA			           * set de la couleur Vert et Rouge
    	stb   <$DA                     * set de la couleur Bleu
    	leay  -1,y
    	bne   UPP_SetColor             * on reboucle si fin de liste pas atteinte
    	com   Refresh_palette          * update flag, next run this routine will be ignored if no pal update is requested
UPP_return
        rts

        
        
