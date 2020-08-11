*********************************************
* Boot loader / Routine de lecture disquette
*********************************************
(main)BOOT
   setdp $60
   org $6200
   
   ldd #$6300                 * Adresse qui sera appellee lors du RTS dans le cas du boot
   std ,s                     * Enregistrement de l adresse dans la pile systeme
DK_lecture                    
   lda #$02                   
   sta <$6048                 * DK.OPC $02 Operation - Lecture d un secteur
DK_piste                      
   ldd #$0000                 
   std <$604A                 * DK.TRK Piste a lire
DK_secteur                    
   lda #$02                   
   sta <$604C                 * DK.SEC Secteur a lire
DK_destination                
   ldd #$6300                 
   std <$604F                 * DK.BUF Destination des donnees lues
   jsr $E82A                  * DKCO Appel 
   inc DK_secteur+1           * Secteur suivant
   lda DK_secteur+1           
   cmpa #$10                  * Si on depasse le secteur 16
   bhi DK_reinit_secteur      * on branche
DK_retour_reinit_secteur      
   inc DK_destination+1       * Increment de 256 octets de la zone a ecrire
   ldd DK_destination+1       * Destination des donnees lues
DK_dernier_bloc_a_ecrire      
   cmpd #$9E00                * Dernier bloc a ecrire (Attention a la pile systeme remontante en 9FFF au boot)
   bls DK_piste               
   rts                        
DK_reinit_secteur             
   lda #$01                   * Positionnement du secteur a 1
   sta DK_secteur+1           
   inc DK_piste+2             * Increment de la piste
   bra DK_retour_reinit_secteur 
