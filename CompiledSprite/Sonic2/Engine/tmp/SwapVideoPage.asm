********************************************************************************
* SWAP_CART_PAGE_0_2 - Benoit Rousseau 07/10/2020
* ------------------------------------------------------------------------------
* 
* Fonction
* --------
* Entrée:      SCRC
* Description: Attends la fin du prochain rafraichissement de l'écran.
*              Inverse les pages 0 et 3 qui sont montées das l'espace cartouche
*              et dans l'espace écran.
* Registres:   IN  N/A
*              RST [B]
*              OUT N/A
*
* Informations Techniques
* -----------------------
*
* Changement de page ESPACE CARTOUCHE (ecriture dans buffer invisible)
*	$E7E6 determine la page affichee dans ESPACE CARTOUCHE (0000 a 3FFF)
*   D5 : 1 = espace cartouche recouvert par de la RAM
*   D4 : 0 = CAS1N valide : banques 0-15 / 1 = CAS2N valide : banques 16-31
*	D5=1 D4=0 D3=0 D2=0 D1=0 D0=0 (#$60) : page 0
*   ...
*	D5=1 D4=0 D3=1 D2=1 D1=1 D0=1 (#$6F) : page 15
*	D5=1 D4=1 D3=0 D2=0 D1=0 D0=0 (#$70) : page 16
*   ...
*	D5=1 D4=1 D3=1 D2=1 D1=1 D0=1 (#$7F) : page 31
*
* Changement de page ESPACE ECRAN (affichage du buffer visible)
*	$E7DD determine la page affichee dans ESPACE ECRAN (4000 a 5FFF)
*	D7=0 D6=0 D5=0 D4=0 (#$0_) : page 0
*	D7=0 D6=1 D5=0 D4=0 (#$4_) : page 1
*	D7=1 D6=0 D5=0 D4=0 (#$8_) : page 2
*	D7=1 D6=1 D5=0 D4=0 (#$C_) : page 3
*   D3 D2 D1 D0  (#$_0 a #$_F) : couleur du cadre
*   Remarque : D5 et D4 utilisable uniquement en mode MO
*
********************************************************************************
(main)SWAP
   ORG    $61BF

SCRC
********************************************************************************
* Attente VBL
********************************************************************************
VSYNC_1
   TST    $E7E7             * le faisceau n'est pas dans l'écran
   BPL    VSYNC_1           * tant que le bit est à 0 on boucle
VSYNC_2
   TST    $E7E7             * le faisceau est dans l'écran
   BMI    VSYNC_2           * tant que le bit est à 1 on boucle
	
********************************************************************************
* Inversion de page Cartouche et Ecran (pages 0 et 3)
********************************************************************************
   LDB    SCRC0+1           * charge la valeur du LDB suivant SCRC0
   ANDB   #$80              * permute #$00 ou #$80 / fond couleur 0
   STB    $E7DD             * changement page dans ESPACE ECRAN
   COM    SCRC0+1           * alterne 00 et FF sur le LDB suivant SCRC0
SCRC0
   LDB    #$00
   ANDB   #$03              * permute #$60 ou #$63
   ORB    #$60              * espace cartouche recouvert par RAM D5=1
   STB    $E7E6             * changement page dans ESPACE CARTOUCHE
   RTS