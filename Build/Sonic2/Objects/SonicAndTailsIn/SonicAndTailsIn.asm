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
        
        INCLUDE "./Engine/Macros.asm"      
        
Obj_PaletteFade      equ Object_RAM+(object_size*1)        
        
SonicAndTailsIn
        lda   routine,u
        sta   *+4,pcr
        bra   SATI_Routines

SATI_Routines
        lbra  SATI_clearScreen
        lbra  SATI_fadeIn
        lbra  SATI_fadeOut        
        lbra  SATI_Wait
        lbra  SATI_End
 
SATI_clearScreen
        ldx   #$0000
        jsr   ClearDataMem        
        
        ldd   #Img_SonicAndTailsIn
        std   image_set,u
        
        ldd   #$807F
        std   xy_pixel,u
        
        lda   render_flags,u
        ora   #render_overlay_mask
        sta   render_flags,u   
        
        ldb   #1
        stb   priority,u     
        
        lda   routine,u
        adda  #$03
        sta   routine,u   

        jmp   DisplaySprite

SATI_fadeIn
        ldx   #$0000
        jsr   ClearDataMem        

        ldx   #Obj_PaletteFade
        lda   #ObjID_PaletteFade
        sta   id,x                 
        ldd   Cur_palette *@IgnoreUndefined
        std   ext_variables,x
        ldd   #Pal_SonicAndTailsIn *@IgnoreUndefined
        std   ext_variables+2,x    
        
        lda   routine,u
        adda  #$03
        sta   routine,u    
           
        ldd   #$0000
        std   Vint_runcount           
              
        jmp   DisplaySprite    
                
SATI_fadeOut
        ldd   Vint_runcount
        cmpd  #3*50 ; 3 seconds
        beq   SATI_fadeOut_continue
        rts

SATI_fadeOut_continue        
        ldx   #Obj_PaletteFade
        lda   #ObjID_PaletteFade
        sta   id,x                 
        ldd   Cur_palette *@IgnoreUndefined
        std   ext_variables,x
        ldd   #Black_palette *@IgnoreUndefined
        std   ext_variables+2,x  
          
        lda   routine,u
        adda  #$03
        sta   routine,u    
        rts                
                
SATI_Wait
        ldx   #Obj_PaletteFade
        tst   ,x
        beq   SATI_clearScreen_end
        rts
        
SATI_clearScreen_end
        ldx   #$FFFF
        jsr   ClearDataMem
        
        lda   $E7DD                    * set border color
        anda  #$F0
        adda  #$01                     ; color 1
        sta   $E7DD
        anda  #$01                     ; color 1
        adda  #$80
        sta   screen_border_color+1    * maj WaitVBL
                     
        lda   routine,u
        adda  #$03
        sta   routine,u    
        rts            
                
SATI_End
        ldx   #$FFFF
        jsr   ClearDataMem  
        jsr   DeleteObject                    
        _ldd  ObjID_TitleScreen,$03                   ; Replace this object with Title Screen Object subtype 3
        std   ,u
        ldu   #Obj_PaletteFade
        jsr   ClearObj        
        rts  
                        