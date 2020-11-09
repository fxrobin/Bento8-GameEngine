********************************************************************************
* Gestion des modes de jeu (TO8 Thomson) - Benoit Rousseau 07/10/2020
* ------------------------------------------------------------------------------
*
* Permet de gerer les differents etats/modes d'un jeu
* - introduction
* - ecran de titre
* - ecran d'options
* - niveaux de jeu
* - animation de fin
* - ...
* 
* A pour role de charger un etat memoire par rapport a une configuration
* Les donnees sont chargees depuis la disquette puis decompressees par exomizer
* ------------------------------------------------------------------------------
* 
* Chargement de la page 3 a l'ecran
* Chargement de la page 2 en zone 0000-3FFF
* Chargement de la page 0a en zone 4000-5FFF
* Copie en page 0a du moteur Game Mode et des donnees du mode a charger
* Execution du moteur Game Mode en page 0a
* Chargement des donnees du Mode depuis la disquette vers 0000-3FFF (buffer)
* Decompression et ecriture de la RAM en A000-DFFF (pages 5-31)
* Chargement du programme principal du nouveau Mode en page 1 a 6000
* (effectue en dernier car ecrase les registres moniteurs necessaires a la
* gestion disque)
* Re-initialisation du pointeur S a 9FFF
* Branchement en 6000
*
********************************************************************************

(main)GAMEMODE
        org $A000
        
dk_lecteur           equ   $6049
dk_piste             equ   $604A
dk_secteur           equ   $604C
dk_destination       equ   $604F
dk_destination_fin   equ   DK_Dernier_Bloc+2

* ==============================================================================
* GameModeEngineLoader
* ==============================================================================

GameModeEngineLoader

* Chargement de la page 3 a l'ecran
***********************************************************
WaitVBL
        tst   $E7E7                    * le faisceau n'est pas dans l'ecran
        bpl   WaitVBL                  * tant que le bit est a 0 on boucle
WaitVBL_01
        tst   $E7E7                    * le faisceau est dans l'ecran
        bmi   WaitVBL_01               * tant que le bit est a 1 on boucle
SwapVideoPage
        ldb   #$C0                     * page 3, couleur de cadre 0
        stb   $E7DD                    * affiche la page a l'ecran
        
* Chargement de la page 2 en zone 0000-3FFF
***********************************************************
        ldb   #$62                     * changement page 2
        stb   $E7E6                    * visible dans l'espace cartouche
        
* Chargement de la page 0a en zone 4000-5FFF
***********************************************************
        ldb   $E7C3                    * charge l'id de la demi-Page 0 en espace ecran
        andb  #$FE                     * positionne bit0=0 pour page 0 RAMA
        stb   $E7C3                    * dans l'espace ecran

* Copie en page 0a du moteur Game Mode et des donnees du mode a charger
************************************************************     
        ldx   #GameModeEngine          * source
        ldy   #$4000                   * destination   
        jsr   COPY8k                   * copie

* Execution du moteur Game Mode en page 0a
************************************************************         
        jmp   $4000        

* ==============================================================================
* GameModeEngine
* ==============================================================================

GameModeEngine
        
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

DK_Lecture                             * point d'entree 
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
DK_Continue                            
        inc   <$604F                   * increment de 256 octets de la zone a ecrire DK.BUF
        ldd   <$604F                   * chargement de la zone a ecrire DK.BUF
DK_Dernier_Bloc                        
        cmpd  #$A000                   * test debut du dernier bloc de 256 octets a ecrire
        bls   DKCO,pcr                 * si DK.BUF inferieur ou egal a la limite alors DKCO
        
GME_01
        lds   #$0000
        
        
        

        
        jmp   $6000

GameModeEngine_End
        rmb   $1E00-(GameModeEngine_End-GameModeEngine),0
        *INCBIN EXOMIZER

* ==============================================================================
* Donnees de chargement pour chaque etat du jeu
* ==============================================================================

current_game_mode
        fdb   $0000

* au build : recuperer l'adresse des modes pour la positionner comme equ dans constants

gm_data
        fdb   $0000 * lecteur, secteur, piste, dest, dest_fin : 8 octets + prevoir page
gm_data_title_screen
        fdb   $0000
gm_data_level_AIZ
        fdb   $0000
gm_data_ending_sequence    

* ==============================================================================
* Routines
* ==============================================================================
        INCLUD COPY8K


(include)COPY8K
* Recopie 8 ko entre X et Y   
COPY8k
   PSHS D,X,Y,U,DP,CC
   STS  COPY8k3+2,PCR ; sauve S

   LEAU 8192,X        ; adresse de fin de recopie
   STU  COPY8k2+2,PCR ; met a jour test de fin
   
   LDD  ,X++          ; 8192 = 21*390 + 2
   STD  ,Y++          ; on s'occupe des 2 premiers
   
   LEAS 7,Y           ; mets a jour les pointeurs
   LEAU ,X            ; U=source S=dest
COPY8k1
   PULU D,X,Y,DP      ; on lit 7 octets
   PSHS D,X,Y,DP      ; on ecrit 7 octets
   LEAS 14,S          ; reajuste S => 12 + 12 + 5 = 29 cycles
   PULU D,X,Y,DP      ;
   PSHS D,X,Y,DP      ;
   LEAS 14,S          ;
   PULU D,X,Y,DP      ;
   PSHS D,X,Y,DP      ;
   LEAS 14,S          ; repete 3 fois = 21 octets recopies a toute vitesse (87 cycles)
COPY8k2
   CMPU #0            ; fin ?
   BNE  COPY8k1       ; non => boucle 5 + 3 cycles
COPY8k3
   LDS  #0            ; recup S d'entree
   PULS D,X,Y,DP,CC,PC
   