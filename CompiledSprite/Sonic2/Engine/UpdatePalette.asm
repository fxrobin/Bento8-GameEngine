********************************************************************************
* Mise a jour de la palette
********************************************************************************
* TODO ajout systeme de refresh pour ne pas update la palette a chaque passage
* ou integrer le refresh palette en debut d'overscan avant que le faisceau entre en visu
* palette doit etre refresh avant le tracage avec les donnees de la precedente frame pas la nouvelle

cpt            fcb   $00
Ptr_palette    fdb   Black_palette  *@globals
Black_palette  rmb   $20,0          *@globals
White_palette  rmb   $20,$FF        *@globals

UpdatePalette
    	ldx   Ptr_palette
    	clr   cpt                      * compteur couleur a 0
        lda   cpt			           *
SetColor
    	asla				           * multiplication par deux de A 
    	sta   $E7DB			           * determine l'indice de couleur (x2): 0=0, 1=2, 2=4, .. 15=30
    	ldd   ,x++			           * chargement de la couleur et increment du poiteur Y
    	sta   $E7DA			           * set de la couleur Vert et Rouge
    	stb   $E7DA                    * set de la couleur Bleu
    	inc   cpt			           * et increment de A
    	lda   cpt
    	cmpa  #$10                     * test fin de liste
    	bne   SetColor                 * on reboucle si fin de liste pas atteinte
        rts
