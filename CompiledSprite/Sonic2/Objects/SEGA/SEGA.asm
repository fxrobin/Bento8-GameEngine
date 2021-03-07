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
        
Obj_PaletteHandler      equ Object_RAM+(object_size*1)
w_SEGA_time_frame_count equ ext_variables        
        
SEGA
        lda   routine,u
        sta   *+4,pcr
        bra   SEGA_Routines

SEGA_Routines
        lbra  SEGAPlay
        lbra  SEGAPal

SEGAPlay            
        ldy   #Pcm_SEGA *@IgnoreUndefined
        jsr   PlayPCM
        
        lda   $6019                           
        ora   #$20
        sta   $6019                                   ; STATUS register
        andcc #:$10                                   ; tell 6809 to activate irq    
        
        lda   routine,u
        adda  #$03
        sta   routine,u  
        rts      

SEGAPal        
        ldd   w_SEGA_time_frame_count,u
        addd  #1
        std   w_SEGA_time_frame_count,u
        cmpd  #$20
        beq   SEGAPal_fadeOut        
        cmpd  #$60
        beq   SEGAPal_fadeIn
        cmpd  #$A0
        beq   SEGAPal_continue
        rts
        
SEGAPal_fadeOut        
        ldx   #Obj_PaletteHandler
        lda   #ObjID_PaletteHandler
        sta   id,x                 
        clr   subtype,x            
        ldd   #White_palette *@IgnoreUndefined
        std   ext_variables,x
        ldd   #Black_palette *@IgnoreUndefined
        std   ext_variables+2,x
        rts
        
SEGAPal_fadeIn
        ldx   #Obj_PaletteHandler
        lda   #ObjID_PaletteHandler
        sta   id,x                 
        clr   subtype,x            
        ldd   #Black_palette *@IgnoreUndefined
        std   ext_variables,x
        ldd   #Pal_TitleScreen *@IgnoreUndefined
        std   ext_variables+2,x    
        rts    
                
SEGAPal_continue            
        ldd   #$0000
        std   w_SEGA_time_frame_count
        sta   routine,u
        ldd   #(ObjID_TitleScreen<+8)+$03             ; Replace this object with Title Screen Object subtype 3
        std   ,u
        rts                                                 