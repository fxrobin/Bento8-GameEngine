(main)TEST
   org $6200
   setdp $90

render_xmirror_mask           equ $0001 ; (bit 0) tell display engine to mirror sprite on horizontal axis
render_ymirror_mask           equ $0002 ; (bit 1) tell display engine to mirror sprite on vertical axis


           lda render_xmirror_mask
           ldb #render_ymirror_mask
