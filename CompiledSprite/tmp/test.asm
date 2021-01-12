(main)TEST
   org $6200
   setdp $90

Glb_Sprite_RAMA fdb $0000
Glb_Sprite_RAMB fdb $0000
x_pixel equ 16
y_pixel equ 17
(info)

DSP_XYToAddress
        ldb   x_pixel,u                     ; load x position (0-156)
        lsrb                                ; x=x/2, sprites moves by 2 pixels on x axis  
        bcs   DSP_XYToAddressRAMBFirst      ; Branch if write must begin in RAMB first
(info)        
DSP_XYToAddressRAMAFirst
        stb   DSP_dyn1+2
        lda   #$28                          ; 40 bytes per line in RAMA or RAMB
        ldb   y_pixel,u                     ; load y position (0-199)
        mul
DSP_dyn1        
        addd  $0000                         ; (dynamic) RAMA start at $0000
        std   Glb_Sprite_RAMA
        ora   #$20                          ; add $2000 to d register
        std   Glb_Sprite_RAMB        
        bra   DSP_XYToAddressEnd
(info)        
DSP_XYToAddressRAMBFirst
        stb   DSP_dyn2+2
        lda   #$28                          ; 40 bytes per line in RAMA or RAMB
        ldb   y_pixel,u                     ; load y position (0-199)
        mul
DSP_dyn2        
        addd  $2000                         ; (dynamic) RAMB start at $0000
        std   Glb_Sprite_RAMA
        subd  $1FFF
        std   Glb_Sprite_RAMB          
DSP_XYToAddressEnd
(info)
