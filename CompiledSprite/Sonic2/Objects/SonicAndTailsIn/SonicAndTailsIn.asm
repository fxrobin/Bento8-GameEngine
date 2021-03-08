; ---------------------------------------------------------------------------
; Object - SonicAndTailsIn
;
; Display Sonic And Tails In ... message
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
        
Obj_PaletteHandler      equ SegaScr_Object_RAM+(object_size*1)        
        
SonicAndTailsIn
        lda   routine,u
        sta   *+4,pcr
        bra   SEGA_Routines

SATI_Routines
        lbra  SATI_fadeOut
        lbra  SATI_fadeIn
        lbra  SATI_Wait
 
SATI_fadeOut        
        ldx   #Obj_PaletteHandler
        lda   #ObjID_PaletteHandler
        sta   id,x                 
        clr   routine,x            
        ldd   #Pal_SEGA *@IgnoreUndefined
        std   ext_variables,x
        ldd   #Black_palette *@IgnoreUndefined
        std   ext_variables+2,x
        
        lda   routine,u
        adda  #$03
        sta   routine,u  
        rts
        
SATI_fadeIn
        ldx   #Obj_PaletteHandler
        tst   ,x
        bne   SATI_fadeIn_return
        
        ldx   #$0000
        jsr   ClearCartMem        
        
        ldd   #Img_SonicAndTailsIn
        std   imageset,u

        ldx   #Obj_PaletteHandler
        lda   #ObjID_PaletteHandler
        sta   id,x                 
        clr   routine,x            
        ldd   #Black_palette *@IgnoreUndefined
        std   ext_variables,x
        ldd   #Pal_SonicAndTailsIn *@IgnoreUndefined
        std   ext_variables+2,x    
        lda   routine,u
        adda  #$03
        sta   routine,u          
SATI_fadeIn_return        
        rts    
                
SATI_Wait
        ldd   Vint_runcount
        cmpd  #3*50 ; 3 seconds
        beq   SATI_continue
        rts                
                
SATI_continue            
        ldd   #(ObjID_TitleScreen<+8)+$03             ; Replace this object with Title Screen Object subtype 3
        std   ,u
        rts  
                        