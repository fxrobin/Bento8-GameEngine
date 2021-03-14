* ---------------------------------------------------------------------------
* UpdatePalette
* -------------
* Subroutine to update palette
* should be called quickly after WaitVBL
*
* input REG : none
* reset REG : [d] [x]
* ---------------------------------------------------------------------------

cpt             fcb   $00
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
    	ldx   Cur_palette
    	clr   cpt                      * compteur couleur a 0
        lda   cpt			           *
UPP_SetColor
    	asla				           * multiplication par deux de A 
    	sta   $E7DB			           * determine l'indice de couleur (x2): 0=0, 1=2, 2=4, .. 15=30
    	ldd   ,x++			           * chargement de la couleur et increment du poiteur Y
    	sta   $E7DA			           * set de la couleur Vert et Rouge
    	stb   $E7DA                    * set de la couleur Bleu
    	inc   cpt			           * et increment de A
    	lda   cpt
    	cmpa  #$10                     * test fin de liste
    	bne   UPP_SetColor             * on reboucle si fin de liste pas atteinte
    	com   Refresh_palette          * update flag, next run this routine will be ignored if no pal update is requested
UPP_return
        rts
