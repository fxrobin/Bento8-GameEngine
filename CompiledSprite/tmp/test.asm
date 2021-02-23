(main)TEST
   org $6200

pal_src fdb $00
pal_cur fdb $00

        ldy   pal_src
        ldx   pal_cur

(info)
        ldy   pal_src
        ldx   pal_cur
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a
        pulu  a,b,dp,x,y
        pshs  y,x,dp,b,a     
        pulu  x,y
        pshs  y,x           
(info)