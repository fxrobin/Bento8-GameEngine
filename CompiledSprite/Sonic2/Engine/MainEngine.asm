********************************************************************************
* Moteur de jeu (TO8 Thomson) - Benoit Rousseau 07/10/2020
* ------------------------------------------------------------------------------
*
*
********************************************************************************

(main)MAIN
        INCLUD CONSTANT
        org   $6000

********************************************************************************  
* Boucle principale
********************************************************************************
LevelMainLoop
        jsr   WaitVBL
        jsr   ReadJoypads
        jsr   RunObjects
        jsr   BuildSprites
        bra   LevelMainLoop

* ==============================================================================
* Routines
* ==============================================================================
        INCLUD WAITVBL
        INCLUD READJPDS
        INCLUD RUNOBJTS
        INCLUD BUILDSPR

* ==============================================================================
* Donnees globales
* ==============================================================================

Normal_palette               rmb   $20

MainCharacter_Is_Dead        fcb   $00

********************************************************************************
* SST - Table des variables de chaque Objet
********************************************************************************

Gotp_Closest_Player          fdb   $0000     * ptr objet de MainCharacter ou Sidekick
Gotp_Player_Is_Left          fcb   $00       * 0: player left from object, 2: right
Gotp_Player_Is_Above         fcb   $00       * 0: player above object, 2: below
Gotp_Player_H_Distance       fdb   $0000     * closest character's h distance to obj
Gotp_Player_V_Distance       fdb   $0000     * closest character's v distance to obj 
Gotp_Abs_H_Distance_Mainc    fdb   $0000     * absolute horizontal distance to main character
Gotp_H_Distance_Sidek        fdb   $0000     * horizontal distance to sidekick

********************************************************************************
* OST - Table des variables de chaque Objet
********************************************************************************
        
Object_RAM * @globals

Reserved_Object_RAM
MainCharacter                rmb   object_size
Sidekick                     rmb   object_size
Reserved_Object_RAM_End

Dynamic_Object_RAM           rmb   number_of_dynamic_objects*object_size
Dynamic_Object_RAM_End

LevelOnly_Object_RAM
Tails_Tails                  rmb   object_size
Sonic_Dust                   rmb   object_size
Tails_Dust                   rmb   object_size
LevelOnly_Object_RAM_End

Object_RAM_End