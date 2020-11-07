* Transition d'une palette à une autre

SETINITPALETTE
    LDX #PALETTEINDEX
	LDY #PALETTEFROM
	LDU #PALETTETO
SETPAL
	LDA ,Y			    * chargement de la composante rouge courante
	ANDA PALETTEMASK
	LDB ,U              * chargement de la composante rouge cible
	ANDB PALETTEMASK
	STB TMPBUFFER
	LDB #$11
	ANDB PALETTEMASK
	STB TMPBUFFER+1
	CMPA TMPBUFFER     * comparaison de la composante rouge courante et cible
    BEQ SETPALVERT
    BHI SETPALROUGEDEC
    LDA ,Y
    ADDA TMPBUFFER+1
    BRA SETPALSAVEROUGE
SETPALROUGEDEC
    LDA ,Y
    SUBA TMPBUFFER+1
SETPALSAVEROUGE
    STA ,Y              * sauvegarde de la nouvelle valeur rouge
       
SETPALVERT
    COM PALETTEMASK
    BMI SETPAL
	    
SETPALBLEU
	LDB 1,Y			    * chargement de la composante bleue courante
	CMPB 1,U++           * comparaison de la composante bleue courante et cible
    BEQ SETPALNEXT
    BHI SETPALBLEUDEC
    INCB
    BRA SETPALSAVEBLEU
SETPALBLEUDEC
    DECB
SETPALSAVEBLEU
    STB 1,Y              * sauvegarde de la nouvelle valeur bleue
    
SETPALNEXT
	LDA ,X+				* Lecture index couleur
	STA $E7DB			* determine l'indice de couleur
	LDA ,Y++		    * chargement de la nouvelle couleur courante
	STA $E7DA			* set de la nouvelle couleur (Vert et Rouge)
	STB $E7DA           * set de la nouvelle couleur (Bleu)
	CMPX #ENDPALETTEINDEX * test fin de liste numéro de couleur
	BNE	SETPAL      * on reboucle si fin de liste pas atteinte
	
VSYNC_1
	TST	$E7E7   * le faisceau n'est pas dans l'écran
	BPL	VSYNC_1 * tant que le bit est à 0 on boucle
VSYNC_2
	TST	$E7E7   * le faisceau est dans l'écran
	BMI	VSYNC_2 * tant que le bit est à 1 on boucle
	
	DEC PALETTECYCLES
	BNE	SETINITPALETTE      * on reboucle si le nombre de cycles n'est pas réalisé
	RTS
	
TMPBUFFER
   fdb $0000

PALETTECYCLES
   fcb $10
   
PALETTEMASK
   fcb $0F

PALETTEINDEX
   fcb $00
   fcb $0C
   fcb $0E
   fcb $10
   fcb $16
   fcb $18
ENDPALETTEINDEX

PALETTEFROM
   fdb $0000
   fdb $F00F
   fdb $FF0F
   fdb $7707
   fdb $AA03
   fdb $330A
ENDPALETTEFROM

PALETTETO
   fdb $FF0F
   fdb $FF0F
   fdb $FF0F
   fdb $FF0F
   fdb $FF0F
   fdb $FF0F
ENDPALETTETO