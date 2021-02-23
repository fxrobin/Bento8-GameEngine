********************************************************************************
* Boot loader - Benoit Rousseau 05/11/2020
* ------------------------------------------------------------------------------
* 
* Description
* -----------
* Animation de la palette: fondu vers une couleur cible PAL_TO
* Initialisation de la commutation de page pour l'espace Donnees (Mode registre)
* Chargement du code de Game Mode Engine en page 4 sur espace donnees
* Appel du Game Mode Engine
*
********************************************************************************
(main)BOOT
        INCLUD GLOBALS
        org   $6200

********************************************************************************
* Animation de la palette: fondu vers une couleur cible PAL_TO
********************************************************************************
* Ecriture en $E7DB de l'adresse ou sera stockee la couleur.
*
* les adresses vont de deux en deux car il y a deux octets a stocker par couleur.
* couleur: 0, adresse: 00
* couleur: 1, adresse: 02
* couleur: 2, adresse: 04
* ...
*
* Deux ecritures en $E7DA (auto-increment a partir de l'adresse couleur
*                          positionnee en $E7DB) pour la valeur de couleur.
*
*                             V V V V                 R R R R
* Premiere adresse        fondamentale V          fondamentale R
*
* Deuxieme adresse            X X X M                 B B B B
* auto-incrementee        bit de marquage         fondamentale B
*                       (incrustation video)
*
* Attention: les instructions suivantes effectuent une lecture avant l'ecriture
* ASL, ASR, CLR, COM, DEL, INC, LSL, LSR, NEG, ROL, RDR
* un seul appel sur $E7DA va lire $E7DA puis ecrire sur la seconde adresse $E7DA 
* Sur $E7DA il faut donc utiliser l'instruction ST pour ecrire
********************************************************************************   

PalInit
        ldx   #pal_len                 * index limite de chargement pour couleur courante 
        ldy   #pal_from                * chargement pointeur valeur des couleurs actuelles
PalRun
        lda   ,y			           * chargement de la composante verte et rouge
        anda  pal_mask                 * on efface la valeur vert ou rouge par masque
        ldb   #$00                     * composante verte et rouge couleur cible
        andb  pal_mask                 * on efface la valeur vert ou rouge par masque
        stb   pal_buffer               * on stocke la valeur cible pour comparaison
        ldb   #$11                     * preparation de la valeur d'increment de couleur
        andb  pal_mask                 * on efface la valeur non utile par masque
        stb   pal_buffer+1             * on stocke la valeur pour ADD ou SUB ulterieur
        cmpa  pal_buffer               * comparaison de la composante courante et cible
        beq   PalVRSuivante            * si composante est egale a la cible on passe
        bhi   PalVRDec                 * si la composante est superieure on branche
        lda   ,y                       * on recharge la valeur avec vert et rouge
        adda  pal_buffer+1             * on incremente la composante verte ou rouge
        bra   PalVRSave                * on branche pour sauvegarder
PalVRDec
        lda   ,y                       * on recharge la valeur avec vert et rouge
        suba  pal_buffer+1             * on decremente la composante verte ou rouge
PalVRSave                             
        sta   ,y                       * sauvegarde de la nouvelle valeur vert ou rouge
PalVRSuivante                         
        com   pal_mask                 * inversion du masque pour traiter l'autre semioctet
        bmi   PalRun                   * si on traite $F0 on branche sinon on continue
	    
SetPalBleu
        ldb   1,y			           * chargement composante bleue courante
        cmpb  #$00                     * comparaison composante courante et cible
        beq   SetPalNext               * si composante est egale a la cible on passe
        bhi   SetPalBleudec            * si la composante est superieure on branche
        incb                           * on incremente la composante bleue
        bra   SetPalSaveBleu           * on branche pour sauvegarder
SetPalBleudec                       
        decb                           * on decremente la composante bleue
SetPalSaveBleu                         
        stb   1,y                      * sauvegarde de la nouvelle valeur bleue
								       
SetPalNext                             
        lda   pal_idx                  * Lecture index couleur
        sta   $E7DB                    * selectionne l'indice de couleur a ecrire
        adda  #$02                     * increment de l'indice de couleur (x2)
        sta   pal_idx                  * stockage du nouvel index
        lda   ,y                       * chargement de la nouvelle couleur courante
        sta   $E7DA                    * positionne la nouvelle couleur (Vert et Rouge)
        stb   $E7DA                    * positionne la nouvelle couleur (Bleu)
        lda   pal_idx                  * rechargement de l'index couleur
        cmpa  ,x                       * comparaison avec l'index limite pour cette couleur
        bne   SetPalNext               * si inferieur on continue avec la meme couleur
        leay  2,y                      * on avance le pointeur vers la nouvelle couleur
        leax  1,x                      * on avance le pointeur vers la nouvelle limite
        cmpx  #end_pal_len             * test de fin de liste
        bne   PalRun                   * on reboucle si fin de liste pas atteinte
								       
Vsync_1                                
        tst   $E7E7                    * le faisceau n'est pas dans l'ecran
        bpl   Vsync_1                  * tant que le bit est a 0 on boucle
Vsync_2                                 
        tst   $E7E7                    * le faisceau est dans l'ecran
        bmi   Vsync_2                  * tant que le bit est a 1 on boucle
								        
        dec   pal_cycles               * decremente le compteur du nombre de frame
        bne   PalInit                  * on reboucle si nombre de frame n'est pas realise
        bra   InitVideo                * saut de la signature de boot
        
pal_buffer                             
        fcb   $42                      * B et buffer de comparaison
        fcb   $41                      * A et buffer de comparaison
        fcb   $53                      * S
        fcb   $49                      * I
        fcb   $43                      * C
        fcb   $32                      * 2
								       
pal_idx                                
        fcb   $00                      * index de la couleur courante dans le traitement
        fcb   $00                      * espace reserve pour somme de controle
   
*-------------------------------------------------------------------------------
* A partir de ce point le code doit commencer a l'adresse $6280
*-------------------------------------------------------------------------------

********************************************************************************  
* Initialisation du mode video
********************************************************************************
InitVideo
        orcc  #$50                     * desactive les interruptions
        lds   #$9FFF                   * positionnement pile systeme
        lda   #$7B                     * passage en mode 160x200x16c
        sta   $E7DC
  
********************************************************************************
* Initialisation de la commutation de page pour l espace Donnees (Mode registre)
********************************************************************************
        ldb   $6081                    * $6081 est l'image "lisible" de $E7E7
        orb   #$10                     * positionne le bit d4 a 1
        stb   $6081                    * maintient une image coherente de $E7E7
        stb   $E7E7                    * bit d4 a 1 pour pages donnees en mode registre
        lda   #$04
        sta   $E7E5                    * selection de la page 04 en RAM Donnees (A000-DFFF)
 
********************************************************************************
* Lecture des donnees depuis la disquette et decompression par exomizer
********************************************************************************
DKLecture
        setdp $60
        lda   #$60
        tfr   a,dp                     * positionne la direct page a 60
        
        ldd   #$0000
        sta   <$6049                   * DK.DRV $00 Lecteur
        std   <$604A                   * DK.TRK $00 Piste
        lda   #$02
        sta   <$604C                   * DK.SEC $02 Secteur
        sta   <$6048                   * DK.OPC $02 Operation - lecture d'un secteur
        lda   #$A0                     * DK.BUF $A000 Destination des donnees lues
        std   <$604F
DKCO
        jsr   $E82A                    * DKCO Appel Moniteur - lecture d'un secteur
        inc   <$604C                   * increment du registre Moniteur DK.SEC
        lda   <$604C                   * chargement de DK.SEC
        cmpa  #$10                     * si DK.SEC est inferieur ou egal a 16
        bls   DKContinue               * on continue le traitement
        lda   #$01                     * sinon on a depasse le secteur 16
        sta   <$604C                   * positionnement du secteur a 1
        inc   <$604B                   * increment du registre Moniteur DK.TRK
        lda   <$604B
        cmpa  #$4F                     * si DK.SEC est inferieur ou egal a 79
        bls   DKContinue               * on continue le traitement
        clr   <$604B                   * positionnement de la piste a 0
        inc   <$6049                   * increment du registre Moniteur DK.DRV
DKContinue                            
        inc   <$604F                   * increment de 256 octets de la zone a ecrire DK.BUF
        ldd   <$604F                   * chargement de la zone a ecrire DK.BUF
dk_dernier_bloc                        
        cmpd  #boot_dernier_bloc       * test debut du dernier bloc de 256 octets a ecrire
        bls   DKCO                     * si DK.BUF inferieur ou egal a la limite alors DKCO
        ldu   #gmboot
        jmp   $A000

* donnees pour le fondu de palette
********************************************************************************

pal_from
        fdb   $0000                    * couleur $00 Noir (Thomson) => 06 change bordure
        fdb   $F00F                    * couleur $0C Turquoise (Bordure ecran)
        fdb   $FF0F                    * couleur $0E Blanc (TO8)
        fdb   $7707                    * couleur $10 Gris (Fond Bas)
        fdb   $AA03                    * couleur $16 Jaune (Interieur case)
        fdb   $330A                    * couleur $18 Mauve (Fond TO8)
								       
pal_len                                
        fcb   $0C                      * pour chaque couleur on defini un index limite
        fcb   $0E                      * (exclu) de chargement. ex: 0C, 0E, ... 
        fcb   $10                      * la premiere couleur de PAL_FROM est chargee
        fcb   $16                      * pour les couleurs 0(00) a 5(0A)
        fcb   $18                      * la seconde couleur de PAL_FORM  est chargee
        fcb   $20                      * pour la couleur 6(0C)
end_pal_len
   
pal_cycles
        fcb   $20                      * nombre de frames de la transition (VSYNC)
								       
pal_mask                               
        fcb   $0F                      * masque pour l'aternance du traitemet vert/rouge

(include)GLOBALS
* Generated Code

GameModeLoader equ $414F
current_game_mode_data equ $41C7
ObjID_PaletteHandler equ 1
ObjID_TitleScreen equ 2
Object_RAM equ $65C5
screen_border_color equ $6D3C
Vint_runcount equ $6D59
c1_button_up_mask equ $0001
c1_button_down_mask equ $0002
c1_button_left_mask equ $0004
c1_button_right_mask equ $0008
c2_button_up_mask equ $0010
c2_button_down_mask equ $0020
c2_button_left_mask equ $0040
c2_button_right_mask equ $0080
c1_button_A_mask equ $0040
c2_button_A_mask equ $0080
Dpad_Held equ $6D5B
Fire_Held equ $6D5C
Dpad_Press equ $6D5D
Fire_Press equ $6D5E
MarkObjGone equ $6DBF
DisplaySprite_x equ $6DC1
DisplaySprite equ $6DC7
AnimateSprite equ $6E40
DeleteObject_x equ $6F01
DeleteObject equ $6F07
ClearObj equ $6FC9
Img_star_4 equ $77CB
Img_star_3 equ $77D9
Img_sonicHand equ $77E7
Img_star_2 equ $77F5
Img_star_1 equ $7803
Img_emblemBack08 equ $7811
Img_emblemBack07 equ $781F
Img_emblemBack09 equ $782D
Img_emblemBack04 equ $783B
Img_emblemBack03 equ $7849
Img_emblemBack06 equ $7857
Img_emblemBack05 equ $7865
Img_tails_5 equ $7873
Img_tails_4 equ $7881
Img_tails_3 equ $788F
Img_tails_2 equ $789D
Img_tails_1 equ $78AB
Img_tailsHand equ $78B9
Img_sonic_1 equ $78C7
Img_sonic_2 equ $78D5
Img_emblemBack02 equ $78E3
Img_emblemBack01 equ $78F1
Img_sonic_5 equ $78FF
Img_sonic_3 equ $790D
Img_sonic_4 equ $791B
Img_emblemFront07 equ $7929
Img_emblemFront08 equ $7937
Img_emblemFront05 equ $7945
Img_emblemFront06 equ $7953
Img_emblemFront03 equ $7961
Img_emblemFront04 equ $796F
Img_emblemFront01 equ $797D
Img_emblemFront02 equ $798B
Ani_smallStar equ $799A
Ani_largeStar equ $79A0
Ani_tails equ $79AC
Ani_sonic equ $79B8
Object_RAM equ $65C5
screen_border_color equ $6D3C
Vint_runcount equ $6D59
c1_button_up_mask equ $0001
c1_button_down_mask equ $0002
c1_button_left_mask equ $0004
c1_button_right_mask equ $0008
c2_button_up_mask equ $0010
c2_button_down_mask equ $0020
c2_button_left_mask equ $0040
c2_button_right_mask equ $0080
c1_button_A_mask equ $0040
c2_button_A_mask equ $0080
Dpad_Held equ $6D5B
Fire_Held equ $6D5C
Dpad_Press equ $6D5D
Fire_Press equ $6D5E
MarkObjGone equ $6DBF
DisplaySprite_x equ $6DC1
DisplaySprite equ $6DC7
AnimateSprite equ $6E40
DeleteObject_x equ $6F01
DeleteObject equ $6F07
ClearObj equ $6FC9
Img_star_4 equ $77CB
Img_star_3 equ $77D9
Img_sonicHand equ $77E7
Img_star_2 equ $77F5
Img_star_1 equ $7803
Img_emblemBack08 equ $7811
Img_emblemBack07 equ $781F
Img_emblemBack09 equ $782D
Img_emblemBack04 equ $783B
Img_emblemBack03 equ $7849
Img_emblemBack06 equ $7857
Img_emblemBack05 equ $7865
Img_tails_5 equ $7873
Img_tails_4 equ $7881
Img_tails_3 equ $788F
Img_tails_2 equ $789D
Img_tails_1 equ $78AB
Img_tailsHand equ $78B9
Img_sonic_1 equ $78C7
Img_sonic_2 equ $78D5
Img_emblemBack02 equ $78E3
Img_emblemBack01 equ $78F1
Img_sonic_5 equ $78FF
Img_sonic_3 equ $790D
Img_sonic_4 equ $791B
Img_emblemFront07 equ $7929
Img_emblemFront08 equ $7937
Img_emblemFront05 equ $7945
Img_emblemFront06 equ $7953
Img_emblemFront03 equ $7961
Img_emblemFront04 equ $796F
Img_emblemFront01 equ $797D
Img_emblemFront02 equ $798B
Ani_smallStar equ $799A
Ani_largeStar equ $79A0
Ani_tails equ $79AC
Ani_sonic equ $79B8
Pal_TitleScreen equ $7D32
Ptr_palette equ $7D53
Black_palette equ $7D55
White_palette equ $7D75
gmboot equ $A20B
boot_dernier_bloc equ $A300