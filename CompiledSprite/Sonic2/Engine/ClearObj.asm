* ---------------------------------------------------------------------------
* ClearObj
* --------
* Subroutine to clear an object data in OST
*
* input REG : [u] pointer on objet (OST)
* clear REG : [d,y]
* ---------------------------------------------------------------------------

ClearObj *@globals
        sts   CLO_1+2
        stx   CLO_2+1        
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
        pshu  d,x,y,s
        pshu  d         ; DEPENDENCY on object_size definition
CLO_1        
        lds   #$0000
CLO_2        
        ldx   #$0000        
        rts