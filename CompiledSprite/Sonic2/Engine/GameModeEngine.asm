(main)GMENGINE
        * INCGLB !!!
        * INCLUD CONSTANT !!!
        org $4000
        setdp $40
        INCLUD EXOMIZER

dk_lecteur           equ   $6049
dk_piste             equ   $604A
dk_secteur           equ   $604C
dk_destination       equ   $604F
        
* Chargement des donnees du Mode depuis la disquette vers 0000-3FFF (buffer)
* ------------------------------------------------------------------------------   
*
* Donnees b: DRV/TRK, b: SEC, b: nb SEC, b: offset de fin, b: dest Page, w: dest Adresse
* on termine par l'ecriture en page 1 des donnees 0000-0100 puis derniere ligne 7x$FF
* Remarque:
* ---------
* Les donnees sur la disquette sont continues. Lorsque des donnees se terminent a moitie
* sur un secteur, les donnees de fin sont ignorees par l'offset. Si les donnees commencent
* en milieu de secteur, c'est l'exomizer qui s'arretera. On optimise ainsi l'espace disquette
* il n'y a pas de separateur ni de blanc entre les donnees.
************************************************************     

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
        
current_game_mode_data *@global !!!

(include)EXOMIZER
* Exomizer2 algorithm, backward with litterals for 6809
* by Fool-DupleX, PrehisTO and Sam from PULS (www.pulsdemos.com)
*
* This routine decrunches data compressed with Exomizer2 in raw mode,
* backward with litterals.
* This routine was developed and tested on a Thomson MO5 in July 2011.

   
* The Exomizer2 decruncher starts here.
* call with a JSR exo2 or equivalent.
*
* Input    : U = pointer to end of compressed data
*            Y = pointer to end of output buffer
* Output   : Y = pointer to first byte of decompressed data
* Modifies : Y.
*
* All registers are preserved except Y.
* This code self modifies and cannot be run in ROM.
* This code must be contained within a single page (makes use of DP), but may
* be located anywhere in RAM.

exo2    pshs    u,y,x,dp,d,cc           * Save context
        tfr     pc,d                    * Set direct page
        tfr     a,dp
        leay    biba,pcr                * Set ptr to bits and base table
        clrb
        stb     <bitbuf+1               * Init bit buffer

nxt     clra
        pshs    a,b
        bitb    #$0f                    * if (i&15==0)
        bne     skp
        ldx     #$0001                  * b2 = 1
skp     ldb     #4                      * Fetch 4 bits
        bsr     getbits
        stb     ,y+                     * bits[i] = b1
        comb                            * CC=1
roll    rol     ,s
        rola
        incb
        bmi     roll
        ldb     ,s         
        stx     ,y++                    * base[i] = b2
        leax    d,x                     * b2 += accu1
        puls    a,b
        incb   
        cmpb    #52                     * 52 times ?
        bne     nxt
   
go      ldy     6,s                     * Y = ptr to output
mloop   ldb     #1                      * for(**)
        bsr     getbits                 * Fetch 1 bit
        bne     cpy                     * is 1 ?
        stb     <idx+1                  * B always 0 here
        fcb     $8c                     * (CMPX) to skip first iteration
rbl     inc     <idx+1                  * Compute index
        incb
        bsr     getbits
        beq     rbl

idx     ldb     #$00                    * Self-modified code
        cmpb    #$10                    * index = 16 ?
        beq     endr
        blo     coffs                   * index < 16 ?
        decb                            * index = 17
        bsr     getbits                 * Get size

cpy     tfr     d,x                     * Copy litteral
cpyl    lda     ,-u
        sta     ,-y
        leax    -1,x
        bne     cpyl
        bra     mloop

coffs   bsr     cook                    * Compute length
        pshs    d
        leax    <tab1,pcr
        cmpd    #$03
        bhs     scof
        abx
scof    bsr     getbix
        addb    3,x
        bsr     cook
        std     <offs+2
        puls    x

cpy2    leay    -1,y                    * Copy non litteral
offs    lda     $1234,y                 * Self-modified code
        sta     ,y
        leax    -1,x
        bne     cpy2
        bra     mloop

endr    sty     6,s                     * End
        puls    cc,d,dp,x,y,u,pc        * Restore context and set Y

* getbits  : get 0 to 16 bits from input stream
* Input    : B = bit count, U points to input buffer
* Output   : D = bits
* Modifies : D,U.

getbix  ldb     ,x
getbits clr     ,-s                     * Clear local bits
        clr     ,-s         
bitbuf  lda     #$12                    * Self-modified code
        bra     get3
get1    lda     ,-u
get2    rora
        beq     get1                    * Bit buffer = 1 ?
        rol     1,s
        rol     ,s
get3    decb
        bpl     get2
        sta     <bitbuf+1               * Save buffer
        ldd     ,s++
        rts                             * Retrieve bits and return
   
* cook     : computes base[index] + readbits(&in, bits[index])
* Input    : B = index
* Output   : D = base[index] + readbits(&in, bits[index])
* Modifies : D,X,U.

cook    leax    biba,pcr
        abx                             * bits+base = 3 bytes
        aslb                            * times 2
        abx
        bsr     getbix                  * fetch base[index] and read bits
        addd    1,x                     * add base[index]
        rts

* Values used in the switch (index)   
tab1    fcb     4,2,4
        fcb     16,48,32

biba    rmb     156,0                   * Bits and base are interleaved