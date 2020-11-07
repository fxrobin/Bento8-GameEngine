********************************************************************************
* Moteur de jeu (TO8 Thomson) - Benoit Rousseau 07/10/2020
* ------------------------------------------------------------------------------
*
*
********************************************************************************

(main)TITLESCR
	org $6000

********************************************************************************
* Routines
********************************************************************************

        INCLUD CONSTANT

********************************************************************************  
* Boucle principale
********************************************************************************
MainLoop
        jsr   WaitVBL
        jsr   ReadJoypads
        jsr   RunObjects
        jsr   BuildSprites
        bra   MainLoop

********************************************************************************
* Routines
********************************************************************************

        INCLUD WAITVBL
        INCLUD READJPDS
        INCLUD RUNOBJCT
        INCLUD BUILDSPR

********************************************************************************
* OST - Table des variables de chaque Objet
********************************************************************************
        
Object_RAM
TtlScr_Object_RAM
IntroSonic                   rmb   object_size
IntroTails                   rmb   object_size
IntroLargeStar
TitleScreenPaletteChanger    rmb   object_size
TitleScreenPaletteChanger3   rmb   object_size
IntroEmblemTop               rmb   object_size
IntroSmallStar1              rmb   object_size
IntroSonicHand               rmb   object_size
IntroTailsHand               rmb   object_size
TitleScreenPaletteChanger2   rmb   object_size
TitleScreenMenu              rmb   object_size
IntroSmallStar2              rmb   object_size
TtlScr_Object_RAM_End
Object_RAM_End