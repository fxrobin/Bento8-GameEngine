(main)GMENGINE
        INCGLB
        INCLUD CONSTANT
        org $4000
        INCLUD EXOMIZER

dk_lecteur           equ   $6049
dk_piste             equ   $604A
dk_secteur           equ   $604C
dk_destination       equ   $604F
dk_destination_fin   equ   DK_Dernier_Bloc+2
        
* Chargement des donnees du Mode depuis la disquette vers 0000-3FFF (buffer)
************************************************************
        setdp $60
        lda   #$60
        tfr   a,dp                     * positionne la direct page a 60
        
        sts   GME_01+2,pcr
        lds   [current_game_mode]
        puls  a,b,x,y,u
        sta   dk_lecteur
        stx   dk_piste
        stb   dk_secteur
        sty   dk_destination
        stu   dk_destination_fin

DKLecture                             * point d'entree 
        lda   #$02
        sta   <$6048                   * DK.OPC $02 Operation - lecture d'un secteur
DKCO
        jsr   $E82A                    * DKCO Appel Moniteur - lecture d'un secteur
        inc   <$604C                   * increment du registre Moniteur DK.SEC
        lda   <$604C                   * chargement de DK.SEC
        cmpa  #$10                     * si DK.SEC est inferieur ou egal a 16
        bls   DK_Continue,pcr          * on continue le traitement
        lda   #$01                     * sinon on a depasse le secteur 16
        sta   <$604C                   * positionnement du secteur a 1
        inc   <$604B                   * increment du registre Moniteur DK.TRK
DKContinue                            
        inc   <$604F                   * increment de 256 octets de la zone a ecrire DK.BUF
        ldd   <$604F                   * chargement de la zone a ecrire DK.BUF
DKDernierBloc                        
        cmpd  #$A000                   * test debut du dernier bloc de 256 octets a ecrire
        bls   DKCO,pcr                 * si DK.BUF inferieur ou egal a la limite alors DKCO
        
GME_01
        lds   #$0000

        jmp   $6000
        
        pad pour multiple de 7 octets
        
current_game_mode_data @global