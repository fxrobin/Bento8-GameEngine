        opt   c,ct

********************************************************************************
* T2Loader (TO8 Thomson) - Benoit Rousseau 2021
* ------------------------------------------------------------------------------
* Changement disquettes SDDRIVE : Daniel Coulom
* Lib. MEGAROM T.2 : Prehisto
*
* premiere version tres rudimentaire
* lecture de 4 pistes x 16 secteurs pour une page
* 2x64 pistes par disquette = 32 pages chargees
* il faut donc 4 disquettes pour 128 pages
* 16 pistes par face inutiles sur chacune des 4 disquettes
* lecture des pistes de 1 a 64 face 0 puis 1 a 64 face 1
* la piste 0 contient le boot et ce code de chargement
* pour chaque page lecture des secteurs de 1 a 16
* pas d'entrelacement car les donnees sont chargees depuis SDDRIVE
********************************************************************************

* ===========================================================================
* TO8 Registers
* ===========================================================================

dk_lecteur                    equ $6049
dk_piste                      equ $604A
dk_pisteL                     equ $604B
dk_secteur                    equ $604C
dk_destination                equ $604F

        org   $6300
        lds   #$9FFF                   ; reinit de la pile systeme
        
        lda   #2                       ; page video
        sta   $E7E5                    ; selection de la page en RAM Donnees (A000-DFFF)        
        
        ldx   #$0000
        jsr   ClearDataMem
        
Vsync_1                                
        tst   $E7E7                    * le faisceau n'est pas dans l'ecran utile
        bpl   Vsync_1                  * tant que le bit est a 0 on boucle
Vsync_2                                 
        tst   $E7E7                    * le faisceau est dans l'ecran utile
        bmi   Vsync_2                  * tant que le bit est a 1 on boucle
        
        ; Couleur de la progress bar
        
        lda   #$02
        sta   $E7DB                    * selectionne l'indice de couleur a ecrire
        ldd   #$0444
        stb   $E7DA                    * positionne la nouvelle couleur (Vert et Rouge)
        sta   $E7DA                    * positionne la nouvelle couleur (Bleu)        
        
        ; Couleur du fond de la progress bar
        
        lda   #$04
        sta   $E7DB                    * selectionne l'indice de couleur a ecrire
        ldd   #$0008
        stb   $E7DA                    * positionne la nouvelle couleur (Vert et Rouge)
        sta   $E7DA                    * positionne la nouvelle couleur (Bleu)  
        
        jsr   InitProgress
        
        lda   #$80
        sta   $E7DD                    ; affiche la page 2 a l'ecran        
        
        lda   #4                       ; page memoire buffer pour lecture disquette
        sta   $E7E5                    ; selection de la page en RAM Donnees (A000-DFFF)
        
        jsr   ENM7                     ; rend la MEGAROM T.2 visible
        jsr   ERASE                    ; effacement complet de la MEGAROM T.2
        
        ; Couleur du fond de la progress bar
        
        lda   #$04
        sta   $E7DB                    * selectionne l'indice de couleur a ecrire
        ldd   #$0AAA
        stb   $E7DA                    * positionne la nouvelle couleur (Vert et Rouge)
        sta   $E7DA                    * positionne la nouvelle couleur (Bleu)          
        
        setdp $60
        lda   #$60
        tfr   a,dp                     ; positionne la direct page a 60

        ldd   #$0001                   ; init positionnement lecture disquette
        sta   <dk_lecteur
        std   <dk_piste
        stb   <dk_secteur              ; secteur (1-16)        

RL_Continue
        ldd   #$A000                   ; le buffer DKCO est toujours positionne a $A000
        std   <dk_destination

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
RL_DKContinue                            
        inc   <dk_destination          ; increment de 256 octets de la zone a ecrire DK.BUF
        ldx   <dk_destination          ; chargement de la zone a ecrire DK.BUF
        cmpx  #$DF00                   ; test debut du dernier bloc de 256 octets a ecrire
        bls   RL_DKCO                  ; si DK.BUF inferieur ou egal a la limite alors DKCO
RL_Page
        ldb   #$01                     ; repositionnement pour chargement de la page RAM suivante
        stb   <dk_secteur 

        lda   <dk_pisteL
        cmpa  #$0029
        bne   RL_Copy
        ldd   #$0001
        std   <dk_piste
        inc   <dk_lecteur
        lda   <dk_lecteur
        cmpa  #$04
        bne   RL_Copy
        lda   #$00
        sta   <dk_lecteur
        jsr   MoveToNextDisk           ; on change les deux disquettes par les suivantes
RL_Copy
        lda   cur_ROMPage              ; page destination
        ldy   #$A000                   ; debut donnees a copier en ROM
        jsr   P16K                     ; recopie RAM vers ROM
        
        lda   cur_ROMPage
        jsr   DisplayProgress
        
        inc   cur_ROMPage              ; page ROM suivante
        lda   cur_ROMPage
        
        cmpa  #$03                     ; TODO a rendre dynamique en fonction des pages ROM generees par le builder
        bne   RL_Continue
        *bpl   RL_Continue
        
        bra   RL_END                   ; on a depasse la page 127 => fin   
        
cur_ROMPage fcb   $00

RL_END
        lda   #$00
        jsr   SETPAG                   * ROM page a 0 pour la voir apres reboot
        lda   #$02
        sta   $E7DB                    * selectionne l'indice de couleur a ecrire
        ldd   #$0080
        stb   $E7DA                    * positionne la nouvelle couleur (Vert et Rouge)
        sta   $E7DA                    * positionne la nouvelle couleur (Bleu)
        lda   #$04
        sta   $E7DB                    * selectionne l'indice de couleur a ecrire
        ldd   #$0080
        stb   $E7DA                    * positionne la nouvelle couleur (Vert et Rouge)
        sta   $E7DA                    * positionne la nouvelle couleur (Bleu)          
        bra   *

* ===========================================================================
* Ext. Libraries
* ===========================================================================

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
  TST   <$57              ;test type de carte 
  LBPL  MoveToNextDisk_SD ;traitement carte SD  

MoveToNextDisk_SDHC
  LDD   <$53           ;poids faible LBA0   
  ADDA  #$14           ;ajout 5120 secteurs
  STD   <$53           ;stockage
  LDD   <$51           ;poids fort LBA0 
  ADCB  #$00           ;ajout retenue 
  ADCA  #$00           ;ajout retenue
  STD   <$51           ;stockage D
  RTS

MoveToNextDisk_SD
  LDD   <$51           ;poids fort LBA0 
  ADDD  #$0028         ;ajout decalage
  STD   <$51           ;stockage D
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
       
* ENM7
* Rend la MEMO7 visible sur TO8/8D/9/9+
* In  : néant
* Out : néant
* Mod : néant

ENM7   EQU    *
       PSHS   A
       LDA    $E7C3
       ANDA   #$FB
       STA    $E7C3

       LDA    $E7E6
       ANDA   #$DF
       STA    $E7E6
       PULS   A,PC       
       
********************************************************************************
* Clear memory in data area
********************************************************************************

ClearDataMem 
        pshs  u,dp
        sts   ClearDataMem_3+2
        lds   #$E000
        leau  ,x
        leay  ,x
        tfr   x,d
        tfr   a,dp
ClearDataMem_2
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp
        cmps  #$A010                        
        bne   ClearDataMem_2
        leau  ,s        
ClearDataMem_3        
        lds   #$0000        ; start of memory should not be written with S as an index because of IRQ        
        pshu  d,x,y         ; saving 12 bytes + (2 bytes * _sr calls) inside IRQ routine
        pshu  d,x,y         ; DEPENDENCY on nb of _sr calls inside IRQ routine (here 16 bytes of margin)
        pshu  d,x
        puls  dp,u,pc      
        
********************************************************************************
* Display progress bar
* a: value btw 0-127
********************************************************************************        
        
DisplayProgress
        ldb   #2                       ; page video
        stb   $E7E5                    ; selection de la page en RAM Donnees (A000-DFFF)        
        
        adda  #$40
        sta   DP_RestoreA+1
        ldb   #$7F
        jsr   DRS_XYToAddress
DP_RestoreA                            ; (dynamic)
        lda   #$00
        lsra
        bcs   DP_Odd   
        lda   ,x
        anda  #$0F
        ora   #$10
        bra   DP_Continue
DP_Odd
        lda   ,x        
        anda  #$F0
        ora   #$01
DP_Continue
        sta   ,x     
        
        lda   #4                       ; page video
        sta   $E7E5                    ; selection de la page en RAM Donnees (A000-DFFF)            
        rts

InitProgress
        ldb   #2                       ; page video
        stb   $E7E5                    ; selection de la page en RAM Donnees (A000-DFFF)
        
        lda   #$00
        sta   progress_value
                
IP_Loop        
        adda  #$40
        sta   IP_RestoreA+1
        ldb   #$7F
        jsr   DRS_XYToAddress
IP_RestoreA                            ; (dynamic)
        lda   #$00
        lsra
        bcs   IP_Odd   
        lda   ,x
        anda  #$0F
        ora   #$20
        bra   IP_Continue
IP_Odd
        lda   ,x        
        anda  #$F0
        ora   #$02
IP_Continue
        sta   ,x     
        
        lda   progress_value
        inca
        sta   progress_value
        bpl   IP_Loop     
        
        lda   #4                       ; page de travail
        sta   $E7E5                    ; selection de la page en RAM Donnees (A000-DFFF)            
        rts
        
progress_value fcb $00        

********************************************************************************
* x_pixel and y_pixel coordinate system
* x coordinates:
*    - off-screen left 00-2F (0-47)
*    - on screen 30-CF (48-207)
*    - off-screen right D0-FF (208-255)
*
* y coordinates:
*    - off-screen top 00-1B (0-27)
*    - on screen 1C-E3 (28-227)
*    - off-screen bottom E4-FF (228-255)
********************************************************************************

DRS_XYToAddress
        suba  #$30
        subb  #$1C                          ; TODO same thing as x for negative case
        lsra                                ; x=x/2, sprites moves by 2 pixels on x axis
        lsra                                ; x=x/2, RAMA RAMB enterlace  
        bcs   DRS_XYToAddressRAM2First      ; Branch if write must begin in RAM2 first
DRS_XYToAddressRAM1First
        sta   DRS_dyn1+2
        lda   #$28                          ; 40 bytes per line in RAMA or RAMB
        mul
DRS_dyn1        
        addd  #$C000                        ; (dynamic)
        tfr   d,x     
        rts
DRS_XYToAddressRAM2First
        sta   DRS_dyn2+2
        lda   #$28                          ; 40 bytes per line in RAMA or RAMB
        mul
DRS_dyn2        
        addd  #$A000                        ; (dynamic)
        tfr   d,x
        rts