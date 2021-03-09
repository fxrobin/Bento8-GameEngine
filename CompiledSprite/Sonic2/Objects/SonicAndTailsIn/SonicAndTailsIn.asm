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
(main)SATI
        INCLUD GLOBALS
        INCLUD CONSTANT
        org   $A000
        
Obj_PaletteHandler      equ Object_RAM+(object_size*1)        
        
SonicAndTailsIn
        lda   routine,u
        sta   *+4,pcr
        bra   SATI_Routines

SATI_Routines
        lbra  SATI_fadeIn
        lbra  SATI_fadeOut        
        lbra  SATI_Wait
 
SATI_fadeIn
        ldx   #$0000
        *jsr   ClearCartMem        
        
        ldd   #Img_SonicAndTailsIn
        std   image_set,u

        ldx   #Obj_PaletteHandler
        lda   #ObjID_PaletteHandler
        sta   id,x                 
        ldd   #Black_palette *@IgnoreUndefined
        std   ext_variables,x
        ldd   #Pal_SonicAndTailsIn *@IgnoreUndefined
        std   ext_variables+2,x    
        lda   routine,u
        adda  #$03
        sta   routine,u          
SATI_fadeIn_return        
        rts    
                
SATI_fadeOut
        ldd   Vint_runcount
        cmpd  #3*50 ; 3 seconds
        bne   SATI_fadeOut_continue
        rts

SATI_fadeOut_continue        
        ldx   #Obj_PaletteHandler
        lda   #ObjID_PaletteHandler
        sta   id,x                 
        ldd   #Pal_SonicAndTailsIn *@IgnoreUndefined
        std   ext_variables,x
        ldd   #Black_palette *@IgnoreUndefined
        std   ext_variables+2,x  
          
        lda   routine,u
        adda  #$03
        sta   routine,u    
        rts                
                
SATI_Wait
        ldx   #Obj_PaletteHandler
        tst   ,x
        beq   SATI_Wait_continue
        rts
        
SATI_Wait_continue
        jsr   ClearObj                    
        ldd   #(ObjID_TitleScreen<+8)+$03             ; Replace this object with Title Screen Object subtype 3
        std   ,u
        rts  
                        