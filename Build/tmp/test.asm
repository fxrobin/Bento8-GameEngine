        org   $A000
        opt   c,ct
        
routine equ 1        
        
RasterFade
        lda   routine,u
        sta   *+4,pcr
        bra   RasterFade_Routines
 
RasterFade_Routines
        lbra  >RasterFade_SubtypeInit
        lbra  >RasterFade_InInit
        lbra  >RasterFade_OutInit
        lbra  >RasterFade_Main
        lbra  >RasterCycle_Main
        
RasterFade_SubtypeInit
RasterFade_InInit
RasterFade_OutInit
RasterFade_Main
RasterCycle_Main

RasterFade1
        lda   routine,u
        asla
        ldx   #RasterFade_Routines1
        jmp   [a,x]
 
RasterFade_Routines1
        fdb   RasterFade_SubtypeInit1
        fdb   RasterFade_InInit1
        fdb   RasterFade_OutInit1
        fdb   RasterFade_Main1
        fdb   RasterCycle_Main1
        
RasterFade_SubtypeInit1
RasterFade_InInit1
RasterFade_OutInit1
RasterFade_Main1
RasterCycle_Main1

   inc toto

   lda toto
   adda #2
   sta toto

toto fcb $00