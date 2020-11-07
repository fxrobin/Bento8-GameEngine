********************************************************************************
* Read Disk - Benoit Rousseau 06/11/2020
* ------------------------------------------------------------------------------
* 
* Description
* -----------
* Chargement d'une suite de secteurs depuis la disquette
*
********************************************************************************
(main)READDISK

dk_lecteur           equ   $6049
dk_piste             equ   $604A
dk_secteur           equ   $604C
dk_destination       equ   $604F
dk_destination_fin   equ   DK_Dernier_Bloc+2

DK_Lecture                             * point d'entree
        setdp $60
        lda   #$60
        tfr   a,dp                     * positionne la direct page a 60
        
        lda   #$02
        sta   <$6048                   * DK.OPC $02 Operation - lecture d'un secteur
DKCO
        jsr   $E82A                    * DKCO Appel Moniteur - lecture d'un secteur
        inc   <$604C                   * increment du registre Moniteur DK.SEC
        lda   <$604C                   * chargement de DK.SEC
        cmpa  #$10                     * si DK.SEC est inferieur ou egal a 16
        bls   DK_Continue              * on continue le traitement
        lda   #$01                     * sinon on a depasse le secteur 16
        sta   <$604C                   * positionnement du secteur a 1
        inc   <$604B                   * increment du registre Moniteur DK.TRK
DK_Continue                            
        inc   <$604F                   * increment de 256 octets de la zone a ecrire DK.BUF
        ldd   <$604F                   * chargement de la zone a ecrire DK.BUF
DK_Dernier_Bloc                        
        cmpd  #$A000                   * test debut du dernier bloc de 256 octets a ecrire
        bls   DKCO                     * si DK.BUF inferieur ou egal a la limite alors DKCO
        rts
(info)