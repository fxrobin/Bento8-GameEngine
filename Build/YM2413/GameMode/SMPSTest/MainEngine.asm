        opt   c,ct

********************************************************************************
* Game Engine (TO8 Thomson) - Benoit Rousseau 2020-2021
* ------------------------------------------------------------------------------
*
*
********************************************************************************

        INCLUDE "./Engine/Constants.asm"
        INCLUDE "./Engine/Macros.asm"        
        org   $6100

        jsr   InitSoundDriver
        jsr   IrqSet50Hz
                
        jsr   YM2413_DrumModeOn
        ldx   #Smps_MCZ
        jsr   PlayMusic 

* ==============================================================================
* Main Loop
* ==============================================================================
LevelMainLoop
        jsr   WaitVBL    
        bra   LevelMainLoop
        
* ---------------------------------------------------------------------------
* Engine
* ---------------------------------------------------------------------------

Glb_Page                      fcb   $00
Glb_Address                   fdb   $0000

* ---------------------------------------------------------------------------
* Display
* ---------------------------------------------------------------------------

Glb_Cur_Wrk_Screen_Id         fcb   $00   ; screen buffer set to write operations (0 or 1)

* ==============================================================================
* Routines
* ==============================================================================
        INCLUDE "./Engine/Graphics/WaitVBL.asm"
        INCLUDE "./Engine/Joypad/ReadJoypads.asm"
        INCLUDE "./Engine/Sound/Smps.asm"
        INCLUDE "./Engine/Irq/IrqSmpsJoypad.asm"	