(main)TEST
   org $6200
   setdp $90

Glb_Sprite_Screen_Pos_PartA           equ $0001 ; (bit 0) tell display engine to mirror sprite on horizontal axis
Glb_Sprite_Screen_Pos_PartB           equ $0002 ; (bit 1) tell display engine to mirror sprite on vertical axis

        ldy   #Glb_Sprite_Screen_Pos_PartA  ; Glb_Sprite_Screen_Pos_PartB must follow PartA
        ldd   Glb_Sprite_Screen_Pos_PartB   

   std dyn+2,pcr
   lds ,y
   
dyn 
