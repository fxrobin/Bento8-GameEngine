        org   $A000
        opt   c,ct
        
   sts toto+2
toto   
   lds #$0000
   rts
   
   pshs u
   puls u,pc 