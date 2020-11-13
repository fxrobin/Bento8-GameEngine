********************************************************************************
* Chargement du mode de jeu (TO8 Thomson) - Benoit Rousseau 10/11/2020
* ------------------------------------------------------------------------------
*
* Charge les donnees d'un mode de jeu selectionne en RAM
* Donnees b: DRV/TRK, b: SEC, b: nb SEC, b: offset de fin, b: dest Page, w: dest Adresse
* on termine par l'ecriture en page 1 des donnees 0000-0100 puis derniere ligne 7x$FF
* Remarque:
* ---------
* Les donnees sur la disquette sont continues. Lorsque des donnees se terminent a moitie
* sur un secteur, les donnees de fin sont ignorees par l'offset. Si les donnees commencent
* en milieu de secteur, c'est l'exomizer qui s'arretera. On optimise ainsi l'espace disquette
* il n'y a pas de separateur ni de blanc entre les donnees.
*
********************************************************************************

(main)GMENGINE
        INCLUD CONSTANT
        org $4000
        setdp $40
        INCLUD EXOMIZER  

        ldu   #current_game_mode_data
        pshs  u
        
GameModeEngine
        setdp $60
        lda   #$60
        tfr   a,dp                     * positionne la direct page a 60
        
        ldb   ,u+                      * lecture du lecteur et du secteur
        sex                            * encodes dans un octet :
        anda  #$01                     * d7: lecteur (0-1)
        andb  #$80                     * d6-d0: piste (0-79)
        sta   <dk_lecteur
        lda   #$00
        std   <dk_piste
        
        ldb   #$00                     * le buffer DKCO est toujours positionne a $0000
        std   <dk_destination
        
        ldd   ,u++
        bpl   GMEContinue              * valeur negative de secteur signifie fin du tableau de donnee
        jmp   $6000                    * on lance le mode de jeu en page 1
GMEContinue        
        sta   <dk_secteur              * secteur (1-16)
        stb   DKDernierBloc+2          * nombre de secteurs a lire
        
        pulu  d,y                      * y adresse de fin des donnees de destination
        sta   NegOffset+2              * nombre d'octets inutilises dans le dernier secteur disquette
        stb   Page+1
        
        pshs  u        

DKLecture
        lda   #$02
        sta   <$6048                   * DK.OPC $02 Operation - lecture d'un secteur
DKCO
        jsr   $E82A                    * DKCO Appel Moniteur - lecture d'un secteur
        inc   <$604C                   * increment du registre Moniteur DK.SEC
        lda   <$604C                   * chargement de DK.SEC
        cmpa  #$10                     * si DK.SEC est inferieur ou egal a 16
        bls   DKContinue               * on continue le traitement
        lda   #$01                     * sinon on a depasse le secteur 16
        sta   <$604C                   * positionnement du secteur a 1
        inc   <$604B                   * increment du registre Moniteur DK.TRK
DKContinue                            
        inc   <$604F                   * increment de 256 octets de la zone a ecrire DK.BUF
        ldu   <$604F                   * chargement de la zone a ecrire DK.BUF
DKDernierBloc                        
        cmpu  #0                       * test debut du dernier bloc de 256 octets a ecrire
        bls   DKCO                     * si DK.BUF inferieur ou egal a la limite alors DKCO
NegOffset
        leau  $FF00,u                  * adresse de fin des donnees compressees - offset
Page
        lda   #0                       * page memoire
        sta   $E7E5                    * selection de la page en RAM Donnees (A000-DFFF)
        jsr   exo2                     * decompresse les donnees
        puls  u
        bra   GameModeEngine
fill        
        rmb   (fill-exo2)+((fill-exo2)%7),0 * le code est un multilpe de 7 octets (pour la copie)
        
current_game_mode_data