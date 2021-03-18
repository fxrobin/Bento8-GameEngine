; ---------------------------------------------------------------------------
; Object - RasterFade
;
; input REG : [u] pointeur sur l'objet (SST)
;
; ---------------------------------------------------------------------------
								       
(main)MAIN
        INCLUD GLOBALS
        INCLUD CONSTANT
        org   $A000     

* ---------------------------------------------------------------------------
* Subtypes
* ---------------------------------------------------------------------------
Sub_RasterFadeInColor  equ 3 
Sub_RasterFadeOutColor equ 3 
Sub_RasterFadeInPal    equ 3
Sub_RasterFadeOutPal   equ 3
Sub_RasterMain         equ 6

* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------
raster_pal_src   equ ext_variables                  * ptr to source pal
raster_pal_dst   equ ext_variables+1                * ptr to destination pal
* +2 and +3 free
raster_color     equ ext_variables+4                * src or dst color
raster_cycles    equ ext_variables+6                * nb of frames
raster_inc       equ ext_variables+7                * increment value
raster_inc_      equ ext_variables+8                * increment value
raster_frames    equ ext_variables+9                * fame duration
raster_cur_frame equ ext_variables+10               * fame counter
raster_nb_colors equ ext_variables+11               * number of colors or lines

RasterFade
        lda   routine,u
        sta   *+4,pcr
        bra   RasterFade_Routines
 
RasterFade_Routines
        lbra  RasterFade_SubtypeInit
        lbra  RasterFade_InInit
        lbra  RasterFade_Main

RasterFade_SubtypeInit
        lda   subtype,u
        sta   routine,u
        bra   RasterFade 

RasterFade_InInit
        lda   routine,u
        adda  #$03
        sta   routine,u 
        
        lda   #Sub_RasterMain
        sta   routine,u 
        
        lda   raster_frames,u
        sta   raster_cur_frame,u
        
        lda   $E7E5
        sta   Irq_Raster_Page
        
        leax  pal_RasterCurrent,pcr                   ; calcul des adresses de debut et de fin
        stx   Irq_Raster_Start                        ; pour les donnees de palette
        stx   RFA_InitColor_endloop1+1,pcr
        lda   #$03                                    ; affectation aux variables globales de
        ldb   raster_nb_colors,u                      ; la routine Irq Raster
        mul
        leax  d,x
        stx   Irq_Raster_End
        stx   RFA_InitColor_endloop2+1,pcr
        stx   RFA_end+2,pcr        
        
        lda   raster_inc,u                            ; precalcul de l'increment
        asla                                          ; 1 devient 11, A devient AA ...
        asla
        asla
        asla
        adda  raster_inc,u
        sta   raster_inc_,u
        
        ldd   raster_color,u                          ; positionne la couleur de depart sur un tableau raster
RFA_InitColor_loop1
        leax  -3,x
        std   1,x
RFA_InitColor_endloop1        
        cmpx  #$0000
        bne   RFA_InitColor_loop1

        lda   raster_pal_dst,u                        ; recopie les index de couleur cible dans le tableau raster
        leay  Pal_Index,pcr
        ldd   a,y
        leay  d,y
RFA_InitColor_loop2
        lda   ,y
        leay  3,y
        sta   ,x
        leax  3,x
RFA_InitColor_endloop2        
        cmpx  #$0000
        bne   RFA_InitColor_loop2  
        rts                                                                                                                
                                                 
RasterFade_Main
        dec   raster_cur_frame,u
        beq   RFA_Continue   
        rts  
RFA_Continue
        lda   raster_frames,u
        sta   raster_cur_frame,u
        
        lda   raster_pal_dst,u                        ; recopie les index de couleur cible dans le tableau raster
        leax  Pal_Index,pcr
        ldd   a,x
        addd  #1
        leax  d,x
        leay  pal_RasterCurrent+1,pcr
        dec   raster_cycles,u          * decremente le compteur du nombre de frame
        bne   RFA_Loop                 * on reboucle si nombre de frame n'est pas realise
        jmp   ClearObj                 * auto-destruction de l'objet
        
RFA_Loop
        lda   1,y	                   * chargement de la composante verte et rouge
        anda  pal_mask,pcr             * on efface la valeur vert ou rouge par masque
        ldb   1,x                      * composante verte et rouge couleur cible
        andb  pal_mask,pcr             * on efface la valeur vert ou rouge par masque
        stb   pal_buffer,pcr           * on stocke la valeur cible pour comparaison
        ldb   raster_inc_,u            * preparation de la valeur d'increment de couleur
        andb  pal_mask,pcr             * on efface la valeur non utile par masque
        stb   pal_buffer+1,pcr         * on stocke la valeur pour ADD ou SUB ulterieur
        cmpa  pal_buffer,pcr           * comparaison de la composante courante et cible
        beq   RFA_VRSuivante           * si composante est egale a la cible on passe
        bhi   RFA_VRDec                * si la composante est superieure on branche
        lda   1,y                      * on recharge la valeur avec vert et rouge
        adda  pal_buffer+1,pcr         * on incremente la composante verte ou rouge
        bra   RFA_VRSave               * on branche pour sauvegarder
RFA_VRDec
        lda   1,y                      * on recharge la valeur avec vert et rouge
        suba  pal_buffer+1,pcr         * on decremente la composante verte ou rouge
RFA_VRSave                             
        sta   1,y                      * sauvegarde de la nouvelle valeur vert ou rouge
RFA_VRSuivante                         
        com   pal_mask,pcr             * inversion du masque pour traiter l'autre semioctet
        bmi   RFA_Loop                 * si on traite $F0 on branche sinon on continue
	    
RFA_SetPalBleu
        ldb   ,y                       * chargement composante bleue courante
        cmpb  ,x                       * comparaison composante courante et cible
        beq   RFA_SetPalNext           * si composante est egale a la cible on passe
        bhi   RFA_SetPalBleudec        * si la composante est superieure on branche
        subb  raster_inc,u             * on incremente la composante bleue
        bra   RFA_SetPalSaveBleu       * on branche pour sauvegarder
RFA_SetPalBleudec                       
        subb  raster_inc,u             * on decremente la composante bleue
RFA_SetPalSaveBleu                         
        stb   ,y                       * sauvegarde de la nouvelle valeur bleue
								       
RFA_SetPalNext                             
        leay  3,y                      * on avance le pointeur vers la nouvelle couleur source
        leax  3,x                      * on avance le pointeur vers la nouvelle couleur dest
RFA_end        
        cmpy  #$0000
        blo   RFA_Loop                 * on reboucle si fin de liste pas atteinte
        rts     
        
* ---------------------------------------------------------------------------
* Local data
* ---------------------------------------------------------------------------
        
pal_mask     fcb $0F                   * masque pour l'aternance du traitemet vert/rouge
pal_buffer   fdb $00                   * buffer de comparaison
pal_RasterCurrent rmb 600,0

Pal_Index    fdb Pal_TitleScreenRaster-Pal_Index           
Pal_TitleScreenRaster
        fcb   $1e
        fdb   $0e00 * 132-147
        fcb   $1e        
        fdb   $0c00	* 181-131
        fcb   $1e        
        fdb   $0c00	* 181-131
        fcb   $1e        
        fdb   $0e00 * 132-147
        fcb   $1e
        fdb   $0c00	* 181-131
        fcb   $1e
        fdb   $0e00 * 132-147
        fcb   $1e
        fdb   $0e00 * 132-147
        fcb   $1e
        fdb   $0e00 * 132-147
        fcb   $1e
        fdb   $0e00 * 132-147
        fcb   $1e
        fdb   $0e00 * 132-147
        fcb   $1e
        fdb   $0e00 * 132-147
        fcb   $1e
        fdb   $0b10	* 148-154
        fcb   $1e
        fdb   $0e00 * 132-147
        fcb   $1e
        fdb   $0b10	* 148-154
        fcb   $1e
        fdb   $0b10	* 148-154
        fcb   $1e
        fdb   $0e00 * 132-147
        fcb   $1e
        fdb   $0b10	* 148-154
        fcb   $1e
        fdb   $0b10	* 148-154
        fcb   $1e
        fdb   $0b10	* 148-154
        fcb   $1e
        fdb   $0b10	* 148-154
        fcb   $1e
        fdb   $0b10	* 148-154
        fcb   $1e
        fdb   $0c10	* 155-157
        fcb   $1e
        fdb   $0b10	* 148-154
        fcb   $1e
        fdb   $0c10	* 155-157
        fcb   $1e
        fdb   $0a21	* 158-161
        fcb   $1e
        fdb   $0c10	* 155-157
        fcb   $1e
        fdb   $0a21	* 158-161
        fcb   $1e
        fdb   $0a21	* 158-161
        fcb   $1e
        fdb   $0b41	* 162-164
        fcb   $1e
		fdb   $0a21	* 158-161
        fcb   $1e
        fdb   $0b41	* 162-164
        fcb   $1e
        fdb   $0a52	* 165-167
        fcb   $1e
		fdb   $0b41	* 162-164
        fcb   $1e
        fdb   $0a52	* 165-167
        fcb   $1e
        fdb   $0b74	* 168-171
        fcb   $1e
		fdb   $0a52	* 165-167
        fcb   $1e
        fdb   $0b74	* 168-171
        fcb   $1e
		fdb   $0b74	* 168-171
        fcb   $1e
        fdb   $0b97	* 172-174
        fcb   $1e
		fdb   $0b74	* 168-171
        fcb   $1e
        fdb   $0b97	* 172-174
        fcb   $1e
        fdb   $0bbb	* 175-180
        fcb   $1e
		fdb   $0b97	* 172-174
        fcb   $1e
        fdb   $0bbb	* 175-180
        fcb   $1e
		fdb   $0bbb	* 175-180
        fcb   $1e
		fdb   $0bbb	* 175-180
        fcb   $1e
		fdb   $0bbb	* 175-180
        fcb   $1e
		fdb   $0bbb	* 175-180
        fcb   $1e
		fdb   $0bbb	* 175-180
        fcb   $1e
        fdb   $0c00	* 181-131
Pal_TitleScreenRaster_end                
