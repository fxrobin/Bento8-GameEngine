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
        setdp $62
        lda   #$62
        tfr   a,dp                     * positionne la direct page a 60
        clr   <pal_idx
        ldx   #pal_len                 * index limite de chargement pour couleur courante 
        ldu   #pal_from                * chargement pointeur valeur des couleurs actuelles
PalRun
        lda   ,u			           * chargement de la composante verte et rouge
        anda  pal_mask                 * on efface la valeur vert ou rouge par masque
        ldb   #$FF                     * composante verte et rouge couleur cible
        andb  <pal_mask                * on efface la valeur vert ou rouge par masque
        stb   <pal_buffer              * on stocke la valeur cible pour comparaison
        ldb   #$11                     * preparation de la valeur d'increment de couleur
        andb  <pal_mask                * on efface la valeur non utile par masque
        stb   <pal_buffer+1            * on stocke la valeur pour ADD ou SUB ulterieur
        cmpa  <pal_buffer              * comparaison de la composante courante et cible
        beq   PalVRSuivante            * si composante est egale a la cible on passe
        bhi   PalVRDec                 * si la composante est superieure on branche
        lda   ,u                       * on recharge la valeur avec vert et rouge
        adda  <pal_buffer+1            * on incremente la composante verte ou rouge
        bra   PalVRSave                * on branche pour sauvegarder
PalVRDec
        lda   ,u                       * on recharge la valeur avec vert et rouge
        suba  <pal_buffer+1            * on decremente la composante verte ou rouge
PalVRSave                             
        sta   ,u                       * sauvegarde de la nouvelle valeur vert ou rouge
PalVRSuivante                         
        com   <pal_mask                * inversion du masque pour traiter l'autre semioctet
        bmi   PalRun                   * si on traite $F0 on branche sinon on continue
	    
SetPalBleu
        ldb   1,u			           * chargement composante bleue courante
        cmpb  #$0F                     * comparaison composante courante et cible
        beq   SetPalNext               * si composante est egale a la cible on passe
        bhi   SetPalBleudec            * si la composante est superieure on branche
        incb                           * on incremente la composante bleue
        bra   SetPalSaveBleu           * on branche pour sauvegarder
SetPalBleudec                       
        decb                           * on decremente la composante bleue
SetPalSaveBleu                         
        stb   1,u                      * sauvegarde de la nouvelle valeur bleue
								       
SetPalNext                             
        lda   <pal_idx                 * Lecture index couleur
        sta   $E7DB                    * selectionne l'indice de couleur a ecrire
        adda  #$02                     * increment de l'indice de couleur (x2)
        sta   <pal_idx                 * stockage du nouvel index
        lda   ,u                       * chargement de la nouvelle couleur courante
        sta   $E7DA                    * positionne la nouvelle couleur (Vert et Rouge)
        stb   $E7DA                    * positionne la nouvelle couleur (Bleu)
        lda   <pal_idx                 * rechargement de l'index couleur
        cmpa  ,x                       * comparaison avec l'index limite pour cette couleur
        bne   SetPalNext               * si inferieur on continue avec la meme couleur
        leau  2,u                      * on avance le pointeur vers la nouvelle couleur
        leax  1,x                      * on avance le pointeur vers la nouvelle limite
        cmpx  #end_pal_len             * test de fin de liste
        bne   PalRun                   * on reboucle si fin de liste pas atteinte
								       
Vsync_1                                
        tst   $E7E7                    * le faisceau n'est pas dans l'ecran
        bpl   Vsync_1                  * tant que le bit est a 0 on boucle
Vsync_2                                 
        tst   $E7E7                    * le faisceau est dans l'ecran
        bmi   Vsync_2                  * tant que le bit est a 1 on boucle
								        
        dec   <pal_cycles              * decremente le compteur du nombre de frame
        bne   PalInit                  * on reboucle si nombre de frame n'est pas realise
        bra   InitVideo                * saut de la signature de boot
        rmb   7,0                      * 7 octets de libre
        
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
        fcb   $0F                      * nombre de frames de la transition (VSYNC)
								       
pal_mask                               
        fcb   $0F                      * masque pour l'aternance du traitemet vert/rouge

(include)GLOBALS
* Generated Code

GameModeLoader equ $414F
current_game_mode_data equ $41C7
ObjID_SonicAndTailsIn equ 1
ObjID_SEGA equ 2
ObjID_PaletteHandler equ 3
ObjID_TitleScreen equ 4
Glb_Sprite_Screen_Pos_Part1 equ $613F
Glb_Sprite_Screen_Pos_Part2 equ $6141
Object_RAM equ $662D
screen_border_color equ $7188
Vint_runcount equ $71A5
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
Joypads_Held equ $71A9
Dpad_Held equ $71A9
Fire_Held equ $71AA
Joypads_Press equ $71AB
Dpad_Press equ $71AB
Fire_Press equ $71AC
MarkObjGone equ $7216
DisplaySprite_x equ $7218
DisplaySprite equ $721E
AnimateSprite equ $7297
DeleteObject_x equ $735C
DeleteObject equ $7362
ClearObj equ $7424
ClearCartMem equ $7CD4
Refresh_palette equ $7D0F
Cur_palette equ $7D10
Dyn_palette equ $7D12
Black_palette equ $7D32
White_palette equ $7D52
UpdatePalette equ $7D72
PlayPCM equ $7D9A
PSGInit equ $7DF1
PSGPlayNoRepeat equ $7E03
PSGStop equ $7E31
PSGResume equ $7E5A
PSGCancelLoop equ $7EA5
PSGGetStatus equ $7EA9
PSGSetMusicVolumeAttenuation equ $7EAD
PSGSilenceChannels equ $7F0C
PSGRestoreVolumes equ $7F21
PSGSFXPlayLoop equ $7F95
PSGSFXStop equ $7FE1
PSGSFXCancelLoop equ $8057
PSGSFXGetStatus equ $805B
PSGFrame equ $805F
_sendVolume2PSG equ $8119
PSGSFXFrame equ $816C
_SFXsetLoopPoint equ $81C9
Img_SonicAndTailsIn equ $8215
Img_SegaLogo_2 equ $8225
Img_SegaLogo_1 equ $8235
Img_SegaTrails_1 equ $8245
Img_SegaSonic_12 equ $825E
Img_SegaSonic_23 equ $827F
Img_SegaSonic_13 equ $82A0
Img_SegaSonic_32 equ $82C1
Img_SegaSonic_21 equ $82E2
Img_SegaSonic_43 equ $8303
Img_SegaSonic_11 equ $8324
Img_SegaSonic_33 equ $8345
Img_SegaSonic_22 equ $8366
Img_SegaSonic_41 equ $8387
Img_SegaSonic_31 equ $83A8
Img_SegaSonic_42 equ $83C9
Img_SegaTrails_6 equ $83EA
Img_SegaTrails_5 equ $83FA
Img_SegaTrails_4 equ $840A
Img_SegaTrails_3 equ $841A
Img_SegaTrails_2 equ $842A
Img_star_4 equ $8443
Img_star_3 equ $8457
Img_sonicHand equ $846B
Img_star_2 equ $8482
Img_star_1 equ $849D
Img_emblemBack08 equ $84B8
Img_emblemBack07 equ $84C8
Img_emblemBack09 equ $84D8
Img_emblemBack04 equ $84E8
Img_emblemBack03 equ $84F8
Img_emblemBack06 equ $8508
Img_emblemBack05 equ $8518
Img_tails_5 equ $8528
Img_tails_4 equ $853F
Img_tails_3 equ $8553
Img_tails_2 equ $8567
Img_tails_1 equ $857B
Img_tailsHand equ $858F
Img_sonic_1 equ $85A6
Img_sonic_2 equ $85BA
Img_emblemBack02 equ $85CE
Img_emblemBack01 equ $85DE
Img_sonic_5 equ $85EE
Img_sonic_3 equ $8605
Img_sonic_4 equ $8619
Img_emblemFront07 equ $862D
Img_emblemFront08 equ $863D
Img_emblemFront05 equ $864D
Img_emblemFront06 equ $865D
Img_emblemFront03 equ $866D
Img_emblemFront04 equ $867D
Img_emblemFront01 equ $868D
Img_emblemFront02 equ $869D
Ani_SegaSonic_3 equ $86AE
Ani_SegaSonic_2 equ $86B8
Ani_SegaSonic_1 equ $86C2
Ani_smallStar equ $86CC
Ani_largeStar equ $86D2
Ani_tails equ $86DE
Ani_sonic equ $86EA
Glb_Sprite_Screen_Pos_Part1 equ $613F
Glb_Sprite_Screen_Pos_Part2 equ $6141
Object_RAM equ $662D
screen_border_color equ $7188
Vint_runcount equ $71A5
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
Joypads_Held equ $71A9
Dpad_Held equ $71A9
Fire_Held equ $71AA
Joypads_Press equ $71AB
Dpad_Press equ $71AB
Fire_Press equ $71AC
MarkObjGone equ $7216
DisplaySprite_x equ $7218
DisplaySprite equ $721E
AnimateSprite equ $7297
DeleteObject_x equ $735C
DeleteObject equ $7362
ClearObj equ $7424
ClearCartMem equ $7CD4
Refresh_palette equ $7D0F
Cur_palette equ $7D10
Dyn_palette equ $7D12
Black_palette equ $7D32
White_palette equ $7D52
UpdatePalette equ $7D72
PlayPCM equ $7D9A
PSGInit equ $7DF1
PSGPlayNoRepeat equ $7E03
PSGStop equ $7E31
PSGResume equ $7E5A
PSGCancelLoop equ $7EA5
PSGGetStatus equ $7EA9
PSGSetMusicVolumeAttenuation equ $7EAD
PSGSilenceChannels equ $7F0C
PSGRestoreVolumes equ $7F21
PSGSFXPlayLoop equ $7F95
PSGSFXStop equ $7FE1
PSGSFXCancelLoop equ $8057
PSGSFXGetStatus equ $805B
PSGFrame equ $805F
_sendVolume2PSG equ $8119
PSGSFXFrame equ $816C
_SFXsetLoopPoint equ $81C9
Img_SonicAndTailsIn equ $8215
Img_SegaLogo_2 equ $8225
Img_SegaLogo_1 equ $8235
Img_SegaTrails_1 equ $8245
Img_SegaSonic_12 equ $825E
Img_SegaSonic_23 equ $827F
Img_SegaSonic_13 equ $82A0
Img_SegaSonic_32 equ $82C1
Img_SegaSonic_21 equ $82E2
Img_SegaSonic_43 equ $8303
Img_SegaSonic_11 equ $8324
Img_SegaSonic_33 equ $8345
Img_SegaSonic_22 equ $8366
Img_SegaSonic_41 equ $8387
Img_SegaSonic_31 equ $83A8
Img_SegaSonic_42 equ $83C9
Img_SegaTrails_6 equ $83EA
Img_SegaTrails_5 equ $83FA
Img_SegaTrails_4 equ $840A
Img_SegaTrails_3 equ $841A
Img_SegaTrails_2 equ $842A
Img_star_4 equ $8443
Img_star_3 equ $8457
Img_sonicHand equ $846B
Img_star_2 equ $8482
Img_star_1 equ $849D
Img_emblemBack08 equ $84B8
Img_emblemBack07 equ $84C8
Img_emblemBack09 equ $84D8
Img_emblemBack04 equ $84E8
Img_emblemBack03 equ $84F8
Img_emblemBack06 equ $8508
Img_emblemBack05 equ $8518
Img_tails_5 equ $8528
Img_tails_4 equ $853F
Img_tails_3 equ $8553
Img_tails_2 equ $8567
Img_tails_1 equ $857B
Img_tailsHand equ $858F
Img_sonic_1 equ $85A6
Img_sonic_2 equ $85BA
Img_emblemBack02 equ $85CE
Img_emblemBack01 equ $85DE
Img_sonic_5 equ $85EE
Img_sonic_3 equ $8605
Img_sonic_4 equ $8619
Img_emblemFront07 equ $862D
Img_emblemFront08 equ $863D
Img_emblemFront05 equ $864D
Img_emblemFront06 equ $865D
Img_emblemFront03 equ $866D
Img_emblemFront04 equ $867D
Img_emblemFront01 equ $868D
Img_emblemFront02 equ $869D
Ani_SegaSonic_3 equ $86AE
Ani_SegaSonic_2 equ $86B8
Ani_SegaSonic_1 equ $86C2
Ani_smallStar equ $86CC
Ani_largeStar equ $86D2
Ani_tails equ $86DE
Ani_sonic equ $86EA
Pcm_SEGA equ $89F3
Psg_TitleScreen equ $89FE
Pal_SEGA equ $8A38
Pal_TitleScreen equ $8A58
Pal_SEGAMid equ $8A78
Pal_SonicAndTailsIn equ $8A98
Pal_SEGAEnd equ $8AB8
gmboot equ $A20B
boot_dernier_bloc equ $A500