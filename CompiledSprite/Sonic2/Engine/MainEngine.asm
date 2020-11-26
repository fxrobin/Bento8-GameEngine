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

Vint_runcount                rmb   $2,0  *@globals
blank_pul_data               rmb   $9,0  *@globals
Normal_palette               rmb   $20,0
MainCharacter_Is_Dead        rmb   $1,0

********************************************************************************
* SST - Table des variables de chaque Objet
********************************************************************************

Gotp_Closest_Player          rmb   $2,0  * ptr objet de MainCharacter ou Sidekick
Gotp_Player_Is_Left          rmb   $1,0  * 0: player left from object, 2: right
Gotp_Player_Is_Above         rmb   $1,0  * 0: player above object, 2: below
Gotp_Player_H_Distance       rmb   $2,0  * closest character's h distance to obj
Gotp_Player_V_Distance       rmb   $2,0  * closest character's v distance to obj 
Gotp_Abs_H_Distance_Mainc    rmb   $2,0  * absolute horizontal distance to main character
Gotp_H_Distance_Sidek        rmb   $2,0  * horizontal distance to sidekick

********************************************************************************
* OST - Table des variables de chaque Objet
********************************************************************************
        
Object_RAM * @globals

Reserved_Object_RAM
MainCharacter                rmb   object_size,0
Sidekick                     rmb   object_size,0
Reserved_Object_RAM_End

Dynamic_Object_RAM           rmb   number_of_dynamic_objects*object_size,0
Dynamic_Object_RAM_End

LevelOnly_Object_RAM
Tails_Tails                  rmb   object_size,0
Sonic_Dust                   rmb   object_size,0
Tails_Dust                   rmb   object_size,0
LevelOnly_Object_RAM_End

Object_RAM_End