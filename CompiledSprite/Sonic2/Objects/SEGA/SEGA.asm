; ---------------------------------------------------------------------------
; Object - SEGA
;
; Play SEGA Sound
;
; input REG : [u] pointer to Object Status Table (OST)
; ---------
;
; Instructions for position-independent code
; ------------------------------------------
; - call to a Main Engine routine (6100 - 9FFF): use a jump (jmp, jsr, rts), do not use branch
; - call to internal object routine: use branch ((l)b__), do not use jump
; - use indexed addressing to access data table: first load table address by using "leax my_table,pcr"
;
; ---------------------------------------------------------------------------
(main)SEGA
        INCLUD GLOBALS
        INCLUD CONSTANT
        org   $A000
        
        ldy   #Pcm_SEGA *@IgnoreUndefined
        jsr   PlayPCM
        clr   ,u                            ; Delete this Object
                                                         