(main)TEST
   org $0000
   
constant1 equ $1A
constant2 equ $E9
render_xmirror_mask           equ $01 ; (bit 0) tell display engine to mirror sprite on horizontal axis
render_ymirror_mask           equ $02 ; (bit 1) tell display engine to mirror sprite on vertical axis


        anda  #render_xmirror_mask!render_ymirror_mask