********************************************************************************
* Boot loader / Routine de lecture disquette
* ------------------------------------------
* 6100-61B9 exomizer (186 octets)
* 6200-6263 espace bootloader (100 octets)
* 6264-62FF biba de l'exomizer (156 octets)
*
* Paramètres DK_lecture
* Registres:
*  A: nombre de blocs de 256 octets a charger (A0:1, A1:2, ..., 9F:80)
*  X: lecteur (0 à 3), 0
*  Y: piste (0 à 79), secteur (1-16)
*
* Le numéro de piste est incrémenté a chaque changement de secteur de 16 à 1
* Il n'y a pas de changement de lecteur une fois arrivé à la fin de la piste 79
********************************************************************************
(main)BOOT
   setdp $60
   org $6200

init
   ldd #$6300            * Emplacement du MAIN
   std ,s                * Enregistrement de l adresse qui sera appellee lors du premier RTS (lancement MAIN)
   ldu data              * Chargement des données d'initialisation lecteur, piste, secteur
   pulu a,x,y
DK_lecture               * Point d'entrée pour exécution de lecture disquette et exomizer
   ldu #$604C            * Chargement des données d'entrée DK.DRV, DK.TRK, DK.SEC
   pshu x,y              * X: lecteur,0 Y: piste,secteur
   sta DK_dernier_bloc+2 * utilisation de cette valeur pour le nombre de blocs de 256 octets
   ldd #$6100            * Emplacement Exomizer
   pshs d                * Enregistrement de l'adresse qui sera appellee lors du RTS (Exomizer)
   lda #$02              * A la fois code opération et code page tmp          
   sta <$6048            * DK.OPC $02 Operation - Lecture d un secteur
DK_destinationPage
   ldb $E7E5             * identification de la page en espace données
   stb $61B9             * Sauvegarde de la page
   sta $E7E5             * Selection de la page en RAM Donnees (A000-DFFF)
DK_destination
   ldd #$A000            * Debut de la zone memoire cible
   std <$604F            * DK.BUF Destination des donnees lues
DKCO
   jsr $E82A             * DKCO Appel 
   inc <$604C            * Secteur suivant
   lda <$604C            * Chargement de DK.SEC
   cmpa #$10
   bls DK_continue      
   lda #$01              * Si on depasse le secteur 16
   sta <$604C            * Positionnement du secteur a 1
   inc <$604B            * Increment de la piste
DK_continue 
   inc <$604F            * Increment de 256 octets de la zone a ecrire DK.BUF
   ldd <$604F            * Chargement de la zone a ecrire DK.BUF
DK_dernier_bloc          * Dernier bloc a ecrire
   cmpd #$A000           * TODO !!! dynamique Fin de la zone memoire cible, debut du dernier bloc de 256 octets
   bls DKCO
dyn_rts
   nop                   * TODO !!! passages suivants comment renseigner Y et U ?
   nop
load_exomize             * Auto-modification de code positionne deux rts en place des deux nop
   ldd #$3939            * Au boot permet de charger le code exomizer
   std dyn_rts           * Aux passages suivants, permet d'enchainer DKCO et EXO
fin_donnees_comp   
   ldy #$6324            * paramètre destination (fin) !!! a rendre dynamique (taille+1)
fin_donnees_decomp
   ldu #$A03D            * paramètre source (fin) !!! a rendre dynamique (taille+1)
   ldd #$6100            * emplacement d'écriture du code exomizer
   std <$604F            * renseignement DK.BUF
   std DK_dernier_bloc+2 * renseignement limite de fin a écrire (1 seul bloc de 256 octets ici)
   jsr DKCO
   
data fcb $A0,0,0,0,2     * lecteur, 0, piste, secteur
(info)
