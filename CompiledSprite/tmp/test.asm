(main)TEST
   org $9000
   setdp $90
   
constant1 equ $1A
constant2 equ $E9
render_xmirror_mask           equ $01 ; (bit 0) tell display engine to mirror sprite on horizontal axis
render_ymirror_mask           equ $02 ; (bit 1) tell display engine to mirror sprite on vertical axis


        anda  #render_xmirror_mask!render_ymirror_mask
        leax  46,u                              
        leax  58,u
        leax  16,u
        ldu $A000
        ldu $0000
        ldu $0001
        ldu $1001               
        ldu 0
