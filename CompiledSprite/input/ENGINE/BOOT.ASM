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
   
exomizer equ $6100
main     equ $6300

init
   ldd #main             * Emplacement du MAIN
   std ,s                * Enregistrement de l adresse qui sera appellee lors du premier RTS (lancement MAIN)
   ldu #data             * Chargement des données d'initialisation
   pulu x,y
DK_lecture               * Point d'entrée pour exécution de lecture disquette et exomizer
   ldu #$604D            * Chargement des données d'entrée DK.DRV, (poids fort) DK_dernier_bloc, (poids faible) DK.TRK, DK.SEC
   pshu x,y
   lda <$604A            * Chargement d'une donnée tmp depuis DK.TRK (poids fort)
   sta DK_dernier_bloc+2 * utilisation de cette valeur pour le nombre de blocs de 256 octets
   clr <$604A            * positionnement de l'octet fort de DK.TRK a zéro
   lda #$02              * A la fois code opération et code page tmp          
   sta <$6048            * DK.OPC $02 Operation - Lecture d'un secteur
DK_destinationPage
   ldb $E7E5             * identification de la page en espace données
   stb load_page+1       * Sauvegarde de la page
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
   cmpd #$A000           * test debut du dernier bloc de 256 octets a écrire
   bls DKCO
   bra load_exomize
dyn_exo
load_page
   lda #$00              * Numero de page
   sta $E7E5             * Recharge de la page d'appel
dyn_rts
   nop
load_exomize
   lda #$39
   sta dyn_rts           * Auto-modification de code positionne un rts
   lda #$BD              * Aux passages suivants, permet d'enchainer DKCO et EXO
   ldx #exomizer
   ldu dyn_exo
   pshu a,x              * Auto-modification de code positionne un appel à exomizer
   stx <$604F            * Emplacement d'écriture du code exomizer Renseignement DK.BUF
   jsr $E82A
   jsr exomizer
   rts

* A partir de ce point le code pourra être effacé au premier run exo par biba (position max $6264)
data fcb 0,$A0,0,2     * DK.DRV, poids fort DK_dernier_bloc, poids faible DK.TRK, DK.SEC

(info)
