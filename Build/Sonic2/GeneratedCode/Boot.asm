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
ObjID_PaletteFade equ 1
ObjID_RasterFade equ 2
ObjID_SonicAndTailsIn equ 3
ObjID_SEGA equ 4
ObjID_TitleScreen equ 5
Glb_Sprite_Screen_Pos_Part1 equ $6122
Glb_Sprite_Screen_Pos_Part2 equ $6124
Object_RAM equ $6660
screen_border_color equ $7536
Vint_runcount equ $755C
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
Joypads_Held equ $7560
Dpad_Held equ $7560
Fire_Held equ $7561
Joypads_Press equ $7562
Dpad_Press equ $7562
Fire_Press equ $7563
MarkObjGone equ $75CD
DisplaySprite_x equ $75CF
DisplaySprite equ $75D5
AnimateSprite equ $764E
DeleteObject_x equ $7713
DeleteObject equ $7719
ClearObj equ $77DB
ClearCartMem equ $808B
Refresh_palette equ $80C5
Cur_palette equ $80C6
Dyn_palette equ $80C8
Black_palette equ $80E8
White_palette equ $8108
UpdatePalette equ $8128
PlayPCM equ $8150
PSGInit equ $81A7
PSGPlayNoRepeat equ $81B9
PSGStop equ $81E7
PSGResume equ $8210
PSGCancelLoop equ $825B
PSGGetStatus equ $825F
PSGSetMusicVolumeAttenuation equ $8263
PSGSilenceChannels equ $82C2
PSGRestoreVolumes equ $82D7
PSGSFXPlayLoop equ $834B
PSGSFXStop equ $8397
PSGSFXCancelLoop equ $840D
PSGSFXGetStatus equ $8411
PSGFrame equ $8415
_sendVolume2PSG equ $84CF
PSGSFXFrame equ $8522
_SFXsetLoopPoint equ $857F
irq_routine equ $6027
irq_timer_ctrl equ $E7C5
irq_timer equ $E7C6
irq_one_frame equ $4DFF
Irq_Raster_Page equ $85CB
Irq_Raster_Start equ $85CD
Irq_Raster_End equ $85CF
IrqOn equ $85D1
IrqOff equ $85DC
IrqSync equ $85E7
IrqPsg equ $8606
IrqPsgRaster equ $8615
Img_SonicAndTailsIn equ $8656
Img_SegaLogo_2 equ $8666
Img_SegaLogo_1 equ $8676
Img_SegaTrails_1 equ $8686
Img_SegaSonic_12 equ $869F
Img_SegaSonic_23 equ $86C0
Img_SegaSonic_13 equ $86E1
Img_SegaSonic_32 equ $8702
Img_SegaSonic_21 equ $8723
Img_SegaSonic_43 equ $8744
Img_SegaSonic_11 equ $8765
Img_SegaSonic_33 equ $8786
Img_SegaSonic_22 equ $87A7
Img_SegaSonic_41 equ $87C8
Img_SegaSonic_31 equ $87E9
Img_SegaSonic_42 equ $880A
Img_SegaTrails_6 equ $882B
Img_SegaTrails_5 equ $883B
Img_SegaTrails_4 equ $884B
Img_SegaTrails_3 equ $885B
Img_SegaTrails_2 equ $886B
Img_tails_5 equ $8884
Img_tails_4 equ $889B
Img_tails_3 equ $88AF
Img_tails_2 equ $88C3
Img_tails_1 equ $88D7
Img_islandWater15 equ $88EB
Img_islandWater14 equ $8906
Img_islandWater13 equ $8921
Img_islandWater12 equ $893C
Img_islandWater11 equ $8957
Img_islandMask_1 equ $8972
Img_islandWater10 equ $8982
Img_emblemBack02 equ $899D
Img_emblemBack01 equ $89AD
Img_islandMask_2 equ $89BD
Img_islandWater09 equ $89CD
Img_islandWater08 equ $89E8
Img_islandWater07 equ $8A03
Img_islandWater06 equ $8A1E
Img_islandWater05 equ $8A39
Img_islandWater04 equ $8A54
Img_islandWater03 equ $8A6F
Img_islandWater02 equ $8A8A
Img_star_4 equ $8AA5
Img_islandWater01 equ $8AB9
Img_star_3 equ $8AD4
Img_sonicHand equ $8AE8
Img_star_2 equ $8AFF
Img_star_1 equ $8B1A
Img_emblemBack08 equ $8B35
Img_emblemBack07 equ $8B45
Img_emblemBack09 equ $8B55
Img_emblemBack04 equ $8B65
Img_emblemBack03 equ $8B75
Img_emblemBack06 equ $8B85
Img_emblemBack05 equ $8B95
Img_tailsHand equ $8BA5
Img_island equ $8BBC
Img_sonic_1 equ $8BD7
Img_sonic_2 equ $8BEB
Img_sonic_5 equ $8BFF
Img_sonic_3 equ $8C16
Img_emblemFront07 equ $8C2A
Img_emblemFront08 equ $8C3A
Img_emblemFront05 equ $8C4A
Img_emblemFront06 equ $8C5A
Img_emblemFront03 equ $8C6A
Img_emblemFront04 equ $8C7A
Img_emblemFront01 equ $8C8A
Img_emblemFront02 equ $8C9A
Ani_SegaSonic_3 equ $8CAB
Ani_SegaSonic_2 equ $8CB5
Ani_SegaSonic_1 equ $8CBF
Ani_smallStar equ $8CC9
Ani_largeStar equ $8CCF
Ani_tails equ $8CDB
Ani_sonic equ $8CE7
Glb_Sprite_Screen_Pos_Part1 equ $6122
Glb_Sprite_Screen_Pos_Part2 equ $6124
Object_RAM equ $6660
screen_border_color equ $7536
Vint_runcount equ $755C
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
Joypads_Held equ $7560
Dpad_Held equ $7560
Fire_Held equ $7561
Joypads_Press equ $7562
Dpad_Press equ $7562
Fire_Press equ $7563
MarkObjGone equ $75CD
DisplaySprite_x equ $75CF
DisplaySprite equ $75D5
AnimateSprite equ $764E
DeleteObject_x equ $7713
DeleteObject equ $7719
ClearObj equ $77DB
ClearCartMem equ $808B
Refresh_palette equ $80C5
Cur_palette equ $80C6
Dyn_palette equ $80C8
Black_palette equ $80E8
White_palette equ $8108
UpdatePalette equ $8128
PlayPCM equ $8150
PSGInit equ $81A7
PSGPlayNoRepeat equ $81B9
PSGStop equ $81E7
PSGResume equ $8210
PSGCancelLoop equ $825B
PSGGetStatus equ $825F
PSGSetMusicVolumeAttenuation equ $8263
PSGSilenceChannels equ $82C2
PSGRestoreVolumes equ $82D7
PSGSFXPlayLoop equ $834B
PSGSFXStop equ $8397
PSGSFXCancelLoop equ $840D
PSGSFXGetStatus equ $8411
PSGFrame equ $8415
_sendVolume2PSG equ $84CF
PSGSFXFrame equ $8522
_SFXsetLoopPoint equ $857F
irq_routine equ $6027
irq_timer_ctrl equ $E7C5
irq_timer equ $E7C6
irq_one_frame equ $4DFF
Irq_Raster_Page equ $85CB
Irq_Raster_Start equ $85CD
Irq_Raster_End equ $85CF
IrqOn equ $85D1
IrqOff equ $85DC
IrqSync equ $85E7
IrqPsg equ $8606
IrqPsgRaster equ $8615
Img_SonicAndTailsIn equ $8656
Img_SegaLogo_2 equ $8666
Img_SegaLogo_1 equ $8676
Img_SegaTrails_1 equ $8686
Img_SegaSonic_12 equ $869F
Img_SegaSonic_23 equ $86C0
Img_SegaSonic_13 equ $86E1
Img_SegaSonic_32 equ $8702
Img_SegaSonic_21 equ $8723
Img_SegaSonic_43 equ $8744
Img_SegaSonic_11 equ $8765
Img_SegaSonic_33 equ $8786
Img_SegaSonic_22 equ $87A7
Img_SegaSonic_41 equ $87C8
Img_SegaSonic_31 equ $87E9
Img_SegaSonic_42 equ $880A
Img_SegaTrails_6 equ $882B
Img_SegaTrails_5 equ $883B
Img_SegaTrails_4 equ $884B
Img_SegaTrails_3 equ $885B
Img_SegaTrails_2 equ $886B
Img_tails_5 equ $8884
Img_tails_4 equ $889B
Img_tails_3 equ $88AF
Img_tails_2 equ $88C3
Img_tails_1 equ $88D7
Img_islandWater15 equ $88EB
Img_islandWater14 equ $8906
Img_islandWater13 equ $8921
Img_islandWater12 equ $893C
Img_islandWater11 equ $8957
Img_islandMask_1 equ $8972
Img_islandWater10 equ $8982
Img_emblemBack02 equ $899D
Img_emblemBack01 equ $89AD
Img_islandMask_2 equ $89BD
Img_islandWater09 equ $89CD
Img_islandWater08 equ $89E8
Img_islandWater07 equ $8A03
Img_islandWater06 equ $8A1E
Img_islandWater05 equ $8A39
Img_islandWater04 equ $8A54
Img_islandWater03 equ $8A6F
Img_islandWater02 equ $8A8A
Img_star_4 equ $8AA5
Img_islandWater01 equ $8AB9
Img_star_3 equ $8AD4
Img_sonicHand equ $8AE8
Img_star_2 equ $8AFF
Img_star_1 equ $8B1A
Img_emblemBack08 equ $8B35
Img_emblemBack07 equ $8B45
Img_emblemBack09 equ $8B55
Img_emblemBack04 equ $8B65
Img_emblemBack03 equ $8B75
Img_emblemBack06 equ $8B85
Img_emblemBack05 equ $8B95
Img_tailsHand equ $8BA5
Img_island equ $8BBC
Img_sonic_1 equ $8BD7
Img_sonic_2 equ $8BEB
Img_sonic_5 equ $8BFF
Img_sonic_3 equ $8C16
Img_emblemFront07 equ $8C2A
Img_emblemFront08 equ $8C3A
Img_emblemFront05 equ $8C4A
Img_emblemFront06 equ $8C5A
Img_emblemFront03 equ $8C6A
Img_emblemFront04 equ $8C7A
Img_emblemFront01 equ $8C8A
Img_emblemFront02 equ $8C9A
Ani_SegaSonic_3 equ $8CAB
Ani_SegaSonic_2 equ $8CB5
Ani_SegaSonic_1 equ $8CBF
Ani_smallStar equ $8CC9
Ani_largeStar equ $8CCF
Ani_tails equ $8CDB
Ani_sonic equ $8CE7
Pcm_SEGA equ $8FF0
Psg_TitleScreen equ $8FFB
Pal_Island equ $9035
Pal_SEGA equ $9055
Pal_TitleScreen equ $9075
Pal_SEGAMid equ $9095
Pal_SonicAndTailsIn equ $90B5
Pal_SEGAEnd equ $90D5
gmboot equ $A20B
boot_dernier_bloc equ $A700