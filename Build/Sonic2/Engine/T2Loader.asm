        opt   c,ct

********************************************************************************
* T2Loader (TO8 Thomson) - Benoit Rousseau 2021
* ------------------------------------------------------------------------------
* Changement disquette SDDRIVE : Daniel Coulom
*
********************************************************************************

        org   $6100

        lds   #$9FFF                   ; reinit de la pile systeme
        
        lda   #4                       ; page memoire
        sta   $E7E5                    ; selection de la page en RAM Donnees (A000-DFFF)
        
        ERASE    
        
        setdp $60
        lda   #$60
        tfr   a,dp                     ; positionne la direct page a 60

 ; lecture de 4 pistes x 16 secteurs pour une page
 ; 2x64 pistes par disquette = 32 pages chargees
 ; 16 pistes par face inutiles sur chacune des 4 disquettes
 ; lecture des pistes de 0 a 63 face 0 puis 63 a 0 face 1
 ; pour chaque page lecture des secteurs 0,2,4,6,8,10,12,14,1,3,5,7,9,11,13,15
 ; idealement il faudrait determiner sur quel secteur enchainer suite a changement de piste  

ROMLoader_continue
        lda   cur_RPG
        bpl   RL_Continue              ; on a depasse la page 127 => fin
        jmp   RL_END                   ; on lance le mode de jeu en page 1
RL_Continue        
        sta   <dk_secteur              ; secteur (1-16)
        stb   RL_DKDernierBloc+2       ; nombre de secteurs a lire
        
        ldb   ,u+                      ; lecture du lecteur et du secteur
        sex                            ; encodes dans un octet :
        anda  #$01                     ; d7: lecteur (0-1)
        andb  #$7F                     ; d6-d0: piste (0-79)
        sta   <dk_lecteur
        lda   #$00
        std   <dk_piste
        
        ldb   #$00                     ; le buffer DKCO est toujours positionne a $0000
        std   <dk_destination
        
        pulu  d,y                      ; y adresse de fin des donnees de destination
        sta   RL_NegOffset+3           ; nombre d'octets inutilises dans le dernier secteur disquette
        stb   RL_Page+1
        
        pshs  u        

        lda   #$02
        sta   <$6048                   ; DK.OPC $02 Operation - lecture d'un secteur
RL_DKCO
        jsr   $E82A                    ; DKCO Appel Moniteur - lecture d'un secteur
        inc   <dk_secteur              ; increment du registre Moniteur DK.SEC
        lda   <dk_secteur              ; chargement de DK.SEC
        cmpa  #$10                     ; si DK.SEC est inferieur ou egal a 16
        bls   RL_DKContinue            ; on continue le traitement
        lda   #$01                     ; sinon on a depasse le secteur 16
        sta   <dk_secteur              ; positionnement du secteur a 1
        inc   <dk_pisteL               ; increment du registre Moniteur DK.TRK
        lda   <dk_pisteL
        cmpa  #$4F                     ; si DK.SEC est inferieur ou egal a 79
        bls   RL_DKContinue            ; on continue le traitement
        clr   <dk_pisteL               ; positionnement de la piste a 0
        inc   <dk_lecteur              ; increment du registre Moniteur DK.DRV
RL_DKContinue                            
        inc   <$604F                   ; increment de 256 octets de la zone a ecrire DK.BUF
        ldu   <$604F                   ; chargement de la zone a ecrire DK.BUF
RL_DKDernierBloc                        
        cmpu  #0                       ; test debut du dernier bloc de 256 octets a ecrire
        bls   RL_DKCO                  ; si DK.BUF inferieur ou egal a la limite alors DKCO
        lda   RL_NegOffset+3           ; charge l'offset
        beq   RL_Page                     ; on ne traite que si offset > 0
        leau  $0100,u                  ; astuce pour conserver un code de meme taille sur l'instruction ci dessous peu importe la taille du leau
RL_NegOffset        
        leau  $FE00,u                  ; adresse de fin des donnees compressees - offset - 256 (astuce ci dessus)
RL_Page
        lda   #$00                     ; page destination
        ldy   #$A000                   ; debut donnees a copier en ROM
        P16K
        puls  u
        bra   ROMLoader_continue
        
cur_DRV fcb   $00
cur_TRK fcb   $00
cur_SEC fcb   $00
cur_ADD fdb   $0000
cur_RPG fcb   $00

cur_PAL fcb   $00

RL_END
        lda   cur_PAL
        sta   $E7DB                    * selectionne l'indice de couleur a ecrire
        adda  #$02                     * increment de l'indice de couleur (x2)
        sta   cur_PAL                  * stockage du nouvel index        
        ldd   #$0000
        sta   $E7DA                    * positionne la nouvelle couleur (Vert et Rouge)
        stb   $E7DA                    * positionne la nouvelle couleur (Bleu)
        lda   cur_PAL                  * rechargement de l'index couleur
        cmpa  #$20                     * comparaison avec l'index limite pour cette couleur
        bne   RL_END                   * si inferieur on continue avec la meme couleur
        bra   *

;------------------------------
; Changement disquette SDDRIVE
; Modifier le LBA0 pour pointer
; quatre faces de disquettes
; plus loin dans la carte SD
; Type de carte : b7 de $6057
; SD_LB0 :  4 octets en $6051
; Decalage 4*80*16=5120 secteurs
; Secteurs : $1400 (pour SDHC)
; Octets   : $280000 (pour SD)
;------------------------------
MoveToNextDisk
  ORG   $6443 
  TST   <$57           ;test type de carte 
  LBPL  $6556          ;traitement carte SD  

;carte SDHC
  LDD   <$53           ;poids faible LBA0   
  ADDA  #$14           ;ajout 5120 secteurs
  STD   <$53           ;stockage
  LDD   <$51           ;poids fort LBA0 
  ADCB  #$00           ;ajout retenue 
  ADCA  #$00           ;ajout retenue
  STD   <$51           ;stockage D
  BRA   $63E5          ;retour lecture secteur

;carte SD
  ORG   $6556
  LDD   <$51           ;poids fort LBA0 
  ADDD  #$0028         ;ajout decalage
  STD   <$51           ;stockage D
  LBRA  $63E5          ;retour lecture secteur
  RTS     

* ERASE
* Effacement complet de la flash
* In  : néant
* Out : CC.N=1 si l'opération a échoué
* Mod : néant

ERASE  EQU    *
       PSHS   A
       LDA    #$AA
       STA    $0555
       LDA    #$55
       STA    $02AA
       LDA    #$80
       STA    $0555
       LDA    #$AA
       STA    $0555
       LDA    #$55
       STA    $02AA
       LDA    #$10
       STA    $0555
     
WAITS  LDA    $0000
       EORA   $0000
       BNE    WAITS
       LDA    $0000
       ASLA
       ASLA
       PULS   A,PC
  
* P16K
* Programme une page sans vérification
* In : A = No. de page
*      Y = ptr vers la source en RAM
* Out: néant
* Mod: néant

P16K   EQU    *
       PSHS   A
       LDA    #$02
       JSR    SETMOD
       PULS   A
       JSR    SETPAG
       PSHS   A,X,Y
       LDX    #$0000

PROG   LDA    #$AA
       STA    $555
       LDA    #$55
       STA    $2AA
       LDA    #$A0
       STA    $555
       LDA    ,Y+
       STA    ,X+

       MUL            Pour attendre
       CMPX   #$4000
       BLO    PROG

       LDA    #$F0
       STA    $0555
       PULS   Y,X,A,PC   
       
* SETMOD
* Sélection du mode de fonctionnement
* In  : A = Mode
* Out : néant
* Mod : néant

SETMOD EQU    *
       PSHS   A
       LDA    #$AA
       STA    $0555
       LDA    #$55
       STA    $02AA
       LDA    #$B0
       STA    $0555
       PULS   A
       STA    $0556
       RTS       
       
* SETPAG
* Sélection de la page entre 0 et 127
* In  : A = No. de page
* Out : néant
* Mod : néant

SETPAG EQU    *
       PSHS   A
       LDA    #$AA
       STA    $0555
       LDA    #$55
       STA    $02AA
       LDA    #$C0
       STA    $0555
       PULS   A
       STA    $0555
       RTS       
       
