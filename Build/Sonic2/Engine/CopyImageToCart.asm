********************************************************************************  
* Copy an image to cardtridge area
*
* input  REG : [u] pointeur sur l'image a copier  
********************************************************************************    
CopyImageToCart
        pshs  y,x,dp,b,a                    * sauvegarde des registres pour utilisation du stack blast
        sts   CopyImageToCart_a_rts+2
    
        lds   #$1F40                        * init pointeur au bout de la ram a video (ecriture remontante)
CopyImageToCart_a
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a
        cmps  #$0014
        bne   CopyImageToCart_a
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a
        pulu  b,dp,x,y
        pshs  y,x,dp,b
        
        lds   #$3F40                        * init pointeur au bout de la ram b video (ecriture remontante)
CopyImageToCart_b
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a
        cmps  #$2014
        bne   CopyImageToCart_b
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a
        pulu  b,dp,x,y
        pshs  y,x,dp,b
CopyImageToCart_a_rts
        lds   #$0000                        * rechargement de la pile systeme
        puls  a,b,dp,x,y,pc                 * ajout du pc au puls pour economiser le rts (gain: 3c 1o)