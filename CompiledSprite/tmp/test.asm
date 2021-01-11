(main)TEST
   org $6200
   setdp $90

        sts   dyn1+2
        stx   dyn2+2        
        ldd   #$0000
        ldx   #$0000
        leay  ,x
        leas  ,x
        leau  object_size,u
        pshu  d,x,y,s
        pshu  d,x,y,s
        pshu  d,x,y,s
        pshu  d,x,y,s
        pshu  d,x,y,s
        pshu  d,x,y,s
        pshu  d,x,y,s
        pshu  d,x,y,s
        pshu  d,x,y,s
        pshu  d,x,y,s
dyn1        
        lds   #$0000
dyn2        
        ldx   #$0000        
        rts
(info)
        
ESP_SubCheckAppearCollision
