********************************************************************************
* Clear memory in cardtridge area
********************************************************************************

ClearCartMem
        pshs  u,dp
        sts   ClearCartMem_3+2
        lds   #$4000
        leau  ,x
        leay  ,x
        tfr   x,d
        tfr   a,dp
ClearCartMem_2
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        pshs  u,y,x,dp,b,a
        cmps  #$0004                        
        bne   ClearCartMem_2
        pshs  u,y
ClearCartMem_3
        lds   #$0000
        puls  dp,u,pc
