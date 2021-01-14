********************************************************************************
* Mise a jour de la palette
********************************************************************************
* TODO ajout systeme de refresh pour ne pas update la palette a chaque passage
* ou integrer le refresh palette en debut d'overscan avant que le faisceau entre en visu
* palette doit etre refresh avant le tracage avec les donnees de la precedente frame pas la nouvelle

cpt            fcb   $00
Ptr_palette    equ   Normal_palette
Normal_palette rmb   $20,0   *@globals
Black_palette  rmb   $20,0   *@globals
White_palette  rmb   $20,$FF *@globals

UpdatePalette
    	ldy   [Ptr_palette]
    	ldx   [Ptr_palette]
    	leax  $20,x
    	clr   cpt                      * registre A a 0
SetColor
        lda   cpt			           * sauvegarde A
    	asla				           * multiplication par deux de A 
    	sta   $E7DB			           * determine l'indice de couleur (x2): 0=0, 1=2, 2=4, .. 15=30
    	ldd   ,y++			           * chargement de la couleur et increment du poiteur Y
    	stb   $E7DA			           * set de la couleur Vert et Rouge
    	sta   $E7DA                    * set de la couleur Bleu
    	inc   cpt			           * et increment de A
    	cmpy  ,x                       * test fin de liste
    	bne   SetColor                 * on reboucle si fin de liste pas atteinte
        rts
