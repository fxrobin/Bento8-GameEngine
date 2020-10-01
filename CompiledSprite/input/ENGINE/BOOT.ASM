*********************************************
* Boot loader / Routine de lecture disquette
* 6100-61B2 exomizer (179 octets)
* 6200-6263 espace bootloader (100 octets)
* 6264-62FF biba de l'exomizer (156 octets)
*********************************************
(main)BOOT
   setdp $60
   org $6200
   
boot1
   cmpa   >$fff0         * Error if not
   beq    DK_lecture     * TO8 Touche B
   ldb    #$ff-$10       * TO8 Touche C
   andb   <$6081         * PIA switch
   stb    <$6081         * RAM mode
   stb    >$e7e7
DK_lecture               * routine de lecture disquette
   lda #$02                        
   sta <$6048            * DK.OPC $02 Operation - Lecture d un secteur
DK_destinationPage
   ldb #$04              * Page
   stb $E7E5             * Selection de la page en RAM Donnees (A000-DFFF)
DK_piste                 
   ldd #$0000            * Numero de la piste de depart
   std <$604A            * DK.TRK Piste a lire
DK_secteur               
   lda #$02              * Numero du secteur de depart
   sta <$604C            * DK.SEC Secteur a lire
DK_destination           
   ldd #$A000            * Debut de la zone memoire cible
   std <$604F            * DK.BUF Destination des donnees lues
   jsr $E82A             * DKCO Appel 
   inc DK_secteur+1      * Secteur suivant
   lda DK_secteur+1      
   cmpa #$10             * Si on depasse le secteur 16
   bhi DK_reinit_secteur * on branche
DK_retour_reinit_secteur 
   inc DK_destination+1  * Increment de 256 octets de la zone a ecrire
   ldd DK_destination+1  * Destination des donnees lues
DK_dernier_bloc          * Dernier bloc a ecrire (Attention a la pile systeme remontante en 9FFF au boot)
   cmpd #$A000           * 2B fin de la zone memoire cible, debut du dernier bloc de 256 octets
   bls DK_piste
dyn_rts
   nop
load_exomize
   lda #$39
   sta dyn_rts
   ldy #$6321            * paramètre destination (fin) !!! a rendre dynamique (taille+1)
   ldu #$A03A            * paramètre source (fin) !!! a rendre dynamique
   ldd #$6100            * emplacement du code exomizer
   std DK_destination+1
   std DK_dernier_bloc+2
   std ,s                * Enregistrement de l adresse qui sera appellee lors du RTS dans la pile systeme
   jsr DK_lecture
	          
DK_reinit_secteur        
   lda #$01              * Positionnement du secteur a 1
   sta DK_secteur+1      
   inc DK_piste+2        * Increment de la piste
   bra DK_retour_reinit_secteur
(info)
