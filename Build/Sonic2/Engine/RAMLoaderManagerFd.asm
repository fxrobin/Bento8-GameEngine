********************************************************************************
* Gestionnaire de chargement du RAM Loader (TO8 Thomson) - Benoit Rousseau 07/11/2020
* ------------------------------------------------------------------------------
* 
* A pour role de charger en page 0 le programme de chargement de RAM
* 
* Positionnement de la page 3 a l'ecran
* Positionnement de la page 2 en zone 0000-3FFF
* Positionnement de la page 0a en zone 4000-5FFF
* Copie en page 0a du RAM Loader (dont exomizer) et des index de donnees a charger
* Execution du RAM Loader en page 0a
* Chargement des donnees exomizee en 2 demi-pages depuis la disquette/cartouche vers 0000-3FFF
* Decompression et ecriture de la RAM en A000-DFFF (pages 4-31)
* Decompression et ecriture de la RAM en 6100-9FFF (page 1) Main Engine
* Re-initialisation de la pile systeme a 9FFF
* Branchement en 6100
*
* input REG : [u] GameMode pointer
*
********************************************************************************

        INCLUDE "./GeneratedCode/RAMLoaderFd.glb"
        
        org $0000

RAMLoaderManager

* Positionnement de la page 3 a l'ecran
***********************************************************
RLM_WaitVBL
        tst   $E7E7                    ; le faisceau n'est pas dans l'ecran
        bpl   RLM_WaitVBL              ; tant que le bit est a 0 on boucle
RLM_WaitVBL1
        tst   $E7E7                    ; le faisceau est dans l'ecran
        bmi   RLM_WaitVBL1             ; tant que le bit est a 1 on boucle

        ldb   #$C0                     ; page 3, couleur de cadre 0
        stb   $E7DD                    ; affiche la page a l'ecran
        
* Positionnement de la page 0a en zone 4000-5FFF
***********************************************************
        ldb   $E7C3                    ; charge l'id de la demi-Page 0 en espace ecran
        andb  #$FE                     ; positionne bit0=0 pour page 0 RAMA
        stb   $E7C3                    ; dans l'espace ecran

* Copie en page 0a des donnees du mode a charger
* les groupes de 7 octets sont recopiees a l'envers
* la fin des donnees est marquee par un octet negatif ($FF par exemple)
************************************************************            
        sts   RLM_CopyCode_restore_s+2 ; sauve s
        lds   -2,u                     ; s=destination u=source
        lda   #$FF                     ; ecriture balise de fin
        pshs  a                        ; pour GameModeEngine
RLM_CopyData
        pulu  d,x,y,dp                 ; on lit 7 octets
        pshs  d,x,y,dp                 ; on ecrit 7 octets
        tsta                           ; balise de fin dans REG A
        bpl   RLM_CopyData             ; non => boucle
        leas  7,s                      ; on remote de 7 car le dernier bloc est une balise de fin

* Copie en page 0a du code Game Mode Engine
* les groupes de 7 octets sont recopiees a l'envers, le builder va inverser
* les donnees a l'avance on gagne un leas dans la boucle.
************************************************************    
        ldu   #RAMLoaderBin            ; source
RLM_CopyCode
        pulu  d,x,y,dp                 ; on lit 7 octets
        pshs  d,x,y,dp                 ; on ecrit 7 octets
        cmps  #$4000                   ; fin ?
        bne   RLM_CopyCode             ; non => boucle 5 + 3 cycles
RLM_CopyCode_restore_s
        lds   #0                       ; restaure s
        
* Execution du Game Mode Engine en page 0a
************************************************************         
        jmp   RAMLoader     

* ==============================================================================
* RAMLoader
* ==============================================================================
RAMLoaderBin
        INCLUDEBIN "./GeneratedCode/RAMLoaderFd.bin"
        INCLUDE "./GeneratedCode/BuilderFileIndexFd.asm"
