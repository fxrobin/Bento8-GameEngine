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

PalInit
        setdp $62
        lda   #$62
        tfr   a,dp                     * positionne la direct page a 62
        
Vsync_1
        clr   <pal_idx
        ldx   #pal_len                 * index limite de chargement pour couleur courante 
        ldu   #pal_from                * chargement pointeur valeur des couleurs actuelles
                                
        tst   $E7E7                    * le faisceau n'est pas dans l'ecran utile
        bpl   Vsync_1                  * tant que le bit est a 0 on boucle
Vsync_2                                 
        tst   $E7E7                    * le faisceau est dans l'ecran utile
        bmi   Vsync_2                  * tant que le bit est a 1 on boucle
        
        ldy   #0320                    * 40 lignes * 8 cycles
Tempo        
        leay  -1,y
        bne   Tempo                    * tempo pour etre dans la bordure invisible   
								        
        dec   <pal_cycles              * decremente le compteur du nombre de frame
        beq   InitVideo                * si termine
        
PalRun
        lda   ,u			           * chargement de la composante verte et rouge
        anda  <pal_mask                * on efface la valeur vert ou rouge par masque
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
        bra   Vsync_1
        
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
        fcb   $10                      * nombre de frames de la transition (VSYNC)
								       
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
Glb_Sprite_Screen_Pos_Part1 equ $6122
Glb_Sprite_Screen_Pos_Part2 equ $6124
Object_RAM equ $6610
screen_border_color equ $7162
Vint_runcount equ $7188
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
Joypads_Held equ $718C
Dpad_Held equ $718C
Fire_Held equ $718D
Joypads_Press equ $718E
Dpad_Press equ $718E
Fire_Press equ $718F
MarkObjGone equ $71F9
DisplaySprite_x equ $71FB
DisplaySprite equ $7201
AnimateSprite equ $727A
DeleteObject_x equ $733F
DeleteObject equ $7345
ClearObj equ $7407
ClearCartMem equ $7CB7
Refresh_palette equ $7CF1
Cur_palette equ $7CF2
Dyn_palette equ $7CF4
Black_palette equ $7D14
White_palette equ $7D34
UpdatePalette equ $7D54
PlayPCM equ $7D7C
PSGInit equ $7DD3
PSGPlayNoRepeat equ $7DE5
PSGStop equ $7E13
PSGResume equ $7E3C
PSGCancelLoop equ $7E87
PSGGetStatus equ $7E8B
PSGSetMusicVolumeAttenuation equ $7E8F
PSGSilenceChannels equ $7EEE
PSGRestoreVolumes equ $7F03
PSGSFXPlayLoop equ $7F77
PSGSFXStop equ $7FC3
PSGSFXCancelLoop equ $8039
PSGSFXGetStatus equ $803D
PSGFrame equ $8041
_sendVolume2PSG equ $80FB
PSGSFXFrame equ $814E
_SFXsetLoopPoint equ $81AB
irq_routine equ $6027
irq_timer_ctrl equ $E7C5
irq_timer equ $E7C6
irq_one_frame equ $4DFF
Irq_Raster_Page equ $81F7
Irq_Raster_Start equ $81F9
Irq_Raster_End equ $81FB
IrqOn equ $81FD
IrqOff equ $8208
IrqSync equ $8213
IrqPsg equ $8232
IrqPsgRaster equ $8241
Img_SonicAndTailsIn equ $8278
Img_SegaLogo_2 equ $8288
Img_SegaLogo_1 equ $8298
Img_SegaTrails_1 equ $82A8
Img_SegaSonic_12 equ $82C1
Img_SegaSonic_23 equ $82E2
Img_SegaSonic_13 equ $8303
Img_SegaSonic_32 equ $8324
Img_SegaSonic_21 equ $8345
Img_SegaSonic_43 equ $8366
Img_SegaSonic_11 equ $8387
Img_SegaSonic_33 equ $83A8
Img_SegaSonic_22 equ $83C9
Img_SegaSonic_41 equ $83EA
Img_SegaSonic_31 equ $840B
Img_SegaSonic_42 equ $842C
Img_SegaTrails_6 equ $844D
Img_SegaTrails_5 equ $845D
Img_SegaTrails_4 equ $846D
Img_SegaTrails_3 equ $847D
Img_SegaTrails_2 equ $848D
Img_star_4 equ $84A6
Img_star_3 equ $84BA
Img_sonicHand equ $84CE
Img_star_2 equ $84E5
Img_star_1 equ $8500
Img_emblemBack08 equ $851B
Img_emblemBack07 equ $852B
Img_emblemBack09 equ $853B
Img_emblemBack04 equ $854B
Img_emblemBack03 equ $855B
Img_emblemBack06 equ $856B
Img_emblemBack05 equ $857B
Img_tails_5 equ $858B
Img_tails_4 equ $85A2
Img_tails_3 equ $85B6
Img_tails_2 equ $85CA
Img_tails_1 equ $85DE
Img_tailsHand equ $85F2
Img_island equ $8609
Img_sonic_1 equ $861D
Img_sonic_2 equ $8631
Img_emblemBack02 equ $8645
Img_emblemBack01 equ $8655
Img_sonic_3 equ $8665
Img_sonic_4 equ $8679
Img_emblemFront07 equ $8690
Img_emblemFront08 equ $86A0
Img_emblemFront05 equ $86B0
Img_emblemFront06 equ $86C0
Img_emblemFront03 equ $86D0
Img_emblemFront04 equ $86E0
Img_emblemFront01 equ $86F0
Img_emblemFront02 equ $8700
Ani_SegaSonic_3 equ $8711
Ani_SegaSonic_2 equ $871B
Ani_SegaSonic_1 equ $8725
Ani_smallStar equ $872F
Ani_largeStar equ $8735
Ani_tails equ $8741
Ani_sonic equ $874D
Glb_Sprite_Screen_Pos_Part1 equ $6122
Glb_Sprite_Screen_Pos_Part2 equ $6124
Object_RAM equ $6610
screen_border_color equ $7162
Vint_runcount equ $7188
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
Joypads_Held equ $718C
Dpad_Held equ $718C
Fire_Held equ $718D
Joypads_Press equ $718E
Dpad_Press equ $718E
Fire_Press equ $718F
MarkObjGone equ $71F9
DisplaySprite_x equ $71FB
DisplaySprite equ $7201
AnimateSprite equ $727A
DeleteObject_x equ $733F
DeleteObject equ $7345
ClearObj equ $7407
ClearCartMem equ $7CB7
Refresh_palette equ $7CF1
Cur_palette equ $7CF2
Dyn_palette equ $7CF4
Black_palette equ $7D14
White_palette equ $7D34
UpdatePalette equ $7D54
PlayPCM equ $7D7C
PSGInit equ $7DD3
PSGPlayNoRepeat equ $7DE5
PSGStop equ $7E13
PSGResume equ $7E3C
PSGCancelLoop equ $7E87
PSGGetStatus equ $7E8B
PSGSetMusicVolumeAttenuation equ $7E8F
PSGSilenceChannels equ $7EEE
PSGRestoreVolumes equ $7F03
PSGSFXPlayLoop equ $7F77
PSGSFXStop equ $7FC3
PSGSFXCancelLoop equ $8039
PSGSFXGetStatus equ $803D
PSGFrame equ $8041
_sendVolume2PSG equ $80FB
PSGSFXFrame equ $814E
_SFXsetLoopPoint equ $81AB
irq_routine equ $6027
irq_timer_ctrl equ $E7C5
irq_timer equ $E7C6
irq_one_frame equ $4DFF
Irq_Raster_Page equ $81F7
Irq_Raster_Start equ $81F9
Irq_Raster_End equ $81FB
IrqOn equ $81FD
IrqOff equ $8208
IrqSync equ $8213
IrqPsg equ $8232
IrqPsgRaster equ $8241
Img_SonicAndTailsIn equ $8278
Img_SegaLogo_2 equ $8288
Img_SegaLogo_1 equ $8298
Img_SegaTrails_1 equ $82A8
Img_SegaSonic_12 equ $82C1
Img_SegaSonic_23 equ $82E2
Img_SegaSonic_13 equ $8303
Img_SegaSonic_32 equ $8324
Img_SegaSonic_21 equ $8345
Img_SegaSonic_43 equ $8366
Img_SegaSonic_11 equ $8387
Img_SegaSonic_33 equ $83A8
Img_SegaSonic_22 equ $83C9
Img_SegaSonic_41 equ $83EA
Img_SegaSonic_31 equ $840B
Img_SegaSonic_42 equ $842C
Img_SegaTrails_6 equ $844D
Img_SegaTrails_5 equ $845D
Img_SegaTrails_4 equ $846D
Img_SegaTrails_3 equ $847D
Img_SegaTrails_2 equ $848D
Img_star_4 equ $84A6
Img_star_3 equ $84BA
Img_sonicHand equ $84CE
Img_star_2 equ $84E5
Img_star_1 equ $8500
Img_emblemBack08 equ $851B
Img_emblemBack07 equ $852B
Img_emblemBack09 equ $853B
Img_emblemBack04 equ $854B
Img_emblemBack03 equ $855B
Img_emblemBack06 equ $856B
Img_emblemBack05 equ $857B
Img_tails_5 equ $858B
Img_tails_4 equ $85A2
Img_tails_3 equ $85B6
Img_tails_2 equ $85CA
Img_tails_1 equ $85DE
Img_tailsHand equ $85F2
Img_island equ $8609
Img_sonic_1 equ $861D
Img_sonic_2 equ $8631
Img_emblemBack02 equ $8645
Img_emblemBack01 equ $8655
Img_sonic_3 equ $8665
Img_sonic_4 equ $8679
Img_emblemFront07 equ $8690
Img_emblemFront08 equ $86A0
Img_emblemFront05 equ $86B0
Img_emblemFront06 equ $86C0
Img_emblemFront03 equ $86D0
Img_emblemFront04 equ $86E0
Img_emblemFront01 equ $86F0
Img_emblemFront02 equ $8700
Ani_SegaSonic_3 equ $8711
Ani_SegaSonic_2 equ $871B
Ani_SegaSonic_1 equ $8725
Ani_smallStar equ $872F
Ani_largeStar equ $8735
Ani_tails equ $8741
Ani_sonic equ $874D
Pcm_SEGA equ $8A56
Psg_TitleScreen equ $8A61
Pal_SEGA equ $8A9B
Pal_TitleScreen equ $8ABB
Pal_SEGAMid equ $8ADB
Pal_SonicAndTailsIn equ $8AFB
Pal_SEGAEnd equ $8B1B
gmboot equ $A20B
boot_dernier_bloc equ $A500