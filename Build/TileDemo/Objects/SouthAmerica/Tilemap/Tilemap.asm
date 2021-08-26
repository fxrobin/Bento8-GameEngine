; ---------------------------------------------------------------------------
; Object - Tilemap
;
; Display a background image with a tilemap
; Scroll this background with joypad direction in Rick Dangerous "style"
;
; input REG : [u] pointer to Object Status Table (OST)
; ---------
;
; ---------------------------------------------------------------------------

        INCLUDE "./Engine/Macros.asm"   

* ---------------------------------------------------------------------------
* Object Status Table offsets
* - two variables can share same space if used by two different subtypes
* - take care of words and bytes and space them accordingly
* ---------------------------------------------------------------------------
b_var1             equ ext_variables

Tilemap_Main
        lda   routine,u
        asla
        ldx   #Tilemap_Routines
        jmp   [a,x]

Tilemap_Routines
        fdb   Tilemap_MainInit

Tilemap_MainInit
        rts
