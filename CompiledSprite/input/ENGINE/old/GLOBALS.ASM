DEBUTECRANA 	EQU $0014 * test pour fin stack blasting
FINECRANA   	EQU $1F40 * fin de la RAM A video
DEBUTECRANB 	EQU $2014 * test pour fin stack blasting
FINECRANB   	EQU $3F40 * fin de la RAM B video

JOY_BD 			EQU $05 * Bas Droite
JOY_HD 			EQU $06 * Haut Droite
JOY_D  			EQU $07 * Droite
JOY_BG 			EQU $09 * Bas Gauche
JOY_HG 			EQU $0A * Haut Gauche
JOY_G  			EQU $0B * Gauche
JOY_B  			EQU $0D * Bas
JOY_H  			EQU $0E * Haut
JOY_C  			EQU $0F * Centre
JOY_A  			EQU $40 * Bouton

********************************************************************************
* OBJECT Variables
********************************************************************************

* TODO mettre ces données en tableau générique pour la position des objets

HERO_POS EQU $9F00 * Emplacement memoire pour stockage HERO Position
HERO_X_POS	FCB $0f	* Horizontal Position
HERO_Y_POS	FCB $72	* Vertical Position (TODO Bug si position Y=00)
	
HERO_ANIMATION_ADR		FDB $0000	* Animation courante - Pointeurs Adresse
HERO_ANIMATION_ADR_OLD	FDB $0000	* Sauvegarde ancienne animation
HERO_ANIMATION_RTN_ADR	FDB $0000	* Animation courante - Pointeur Adresse Retour Animation apellante
HERO_ANIMATION_PAG		FCB $00		* Animation courante - Pointeur Page actif
HERO_ANIMATION_PAG_REF	FCB $00		* Animation courante - Pointeur Page de reference
HERO_ANIMATION_PAG_DEL	FCB $00		* Animation courante - Pointeur Page Effacement img-1
						FCB $00		* Animation courante - Pointeur Page Effacement
HERO_ANIMATION_DEL		FDB $0000	* Animation courante - Pointeur Effacement img-1
						FDB $0000	* Animation courante - Pointeur Effacement
HERO_ANIMATION_DRW		FDB $0000	* Animation courante - Pointeur Dessin
HERO_ANIMATION_IMC		FCB $00		* Animation courante - Image courante (doit etre suivi de RTN_IMC)
HERO_ANIMATION_RTN_IMC	FCB $00		* Animation courante - Image courante Retourn Animation apellante (doit etre precede de IMC)
HERO_ANIMATION_FRR		FCB $00		* Animation courante - Frames restante
	
