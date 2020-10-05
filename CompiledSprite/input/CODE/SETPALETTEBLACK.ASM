********************************************************************************  
* Initialisation de la palette en noir
********************************************************************************
	LDD #$00FF
SETBLACKPALETTE
	STA $E7DB	* determine l'indice de couleur
	STB $E7DA	* set de la couleur Vert et Rouge
	STB $E7DA   * set de la couleur Bleu
	ADDA #$02	* increment de l'indice de couleur (x2)
	CMPA #$20	* si on atteint 32 sortie
	BNE	SETBLACKPALETTE