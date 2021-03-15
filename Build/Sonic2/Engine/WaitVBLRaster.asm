********************************************************************************
* ESSAI en cours .. rien a voir ici pour le moment ;-)
*
********************************************************************************
WaitVBL
        tst   $E7E7              * le faisceau n'est pas dans l'ecran
        bpl   WaitVBL            * tant que le bit est a 0 on boucle
WaitVBL_01
        tst   $E7E7              * le faisceau est dans l'ecran
        bmi   WaitVBL_01         * tant que le bit est a 1 on boucle
                        
SwapVideoPage
        ldb   am_SwapVideoPage+1 * charge la valeur du ldb suivant am_SwapVideoPage
        andb  #$40               * alterne bit6=0 et bit6=1 (suivant la valeur B $00 ou $FF)
screen_border_color *@globals       
        orb   #$80               * bit7=1, bit3 a bit0=couleur de cadre (ici 0)
        stb   $E7DD              * changement page (2 ou 3) affichee a l'ecran
        com   am_SwapVideoPage+1 * alterne $00 et $FF sur le ldb suivant am_SwapVideoPage
am_SwapVideoPage
        ldb   #$00
        andb  #$01               * alterne bit0=0 et bit0=1 (suivant la valeur B $00 ou $FF)
        stb   Glb_Cur_Wrk_Screen_Id
        orb   #$62               * bit6=1, bit5=1, bit1=1
        stb   $E7E6              * changement page (2 ou 3) visible dans l'espace cartouche
        ldb   $E7C3              * charge l'identifiant de la demi-page 0 configuree en espace ecran
        eorb  #$01               * alterne bit0 = 0 ou 1 changement demi-page de la page 0 visible dans l'espace ecran
        stb   $E7C3
        
        ldd   Vint_runcount
        addd  #1
        std   Vint_runcount        
        rts
        
Vint_runcount rmb   $2,0 *@globals

        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0c00 * 0-131
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0e00 * 132-147
        fdb   $0b10	* 148-154
        fdb   $0b10	* 148-154
        fdb   $0b10	* 148-154
        fdb   $0b10	* 148-154
        fdb   $0b10	* 148-154
        fdb   $0b10	* 148-154
        fdb   $0b10	* 148-154
        fdb   $0c10	* 155-157
        fdb   $0c10	* 155-157
        fdb   $0c10	* 155-157
        fdb   $0a21	* 158-161
        fdb   $0a21	* 158-161
		fdb   $0a21	* 158-161
		fdb   $0a21	* 158-161
        fdb   $0b41	* 162-164
		fdb   $0b41	* 162-164
		fdb   $0b41	* 162-164
        fdb   $0a52	* 165-167
		fdb   $0a52	* 165-167
		fdb   $0a52	* 165-167
        fdb   $0b74	* 168-171
		fdb   $0b74	* 168-171
		fdb   $0b74	* 168-171
		fdb   $0b74	* 168-171
        fdb   $0b97	* 172-174
		fdb   $0b97	* 172-174
		fdb   $0b97	* 172-174
        fdb   $0bbb	* 175-180
		fdb   $0bbb	* 175-180
		fdb   $0bbb	* 175-180
		fdb   $0bbb	* 175-180
		fdb   $0bbb	* 175-180
		fdb   $0bbb	* 175-180
        fdb   $0c00	* 181-199
        fdb   $0c00	* 181-199
        fdb   $0c00	* 181-199
        fdb   $0c00	* 181-199
        fdb   $0c00	* 181-199
        fdb   $0c00	* 181-199
        fdb   $0c00	* 181-199
        fdb   $0c00	* 181-199
        fdb   $0c00	* 181-199
        fdb   $0c00	* 181-199
        fdb   $0c00	* 181-199
        fdb   $0c00	* 181-199
        fdb   $0c00	* 181-199
        fdb   $0c00	* 181-199
        fdb   $0c00	* 181-199
        fdb   $0c00	* 181-199
        fdb   $0c00	* 181-199
        fdb   $0c00	* 181-199
        fdb   $0c00	* 181-199                
G