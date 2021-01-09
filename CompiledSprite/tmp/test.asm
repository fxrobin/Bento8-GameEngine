(main)TEST
   org $6200
   setdp $90
rsv_ptr_sub_object_erase equ 16
cur_ptr_sub_obj_erase   fdb   $0000
cur_ptr_sub_obj_draw    fdb   $0000

        ldu #$A000
        leax -2,x
        ldx   ,--x   * 8cy
        leax   -2,x
        ldx   ,x   * 8cy
        
ESP_SubCheckAppearCollision
