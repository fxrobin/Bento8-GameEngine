(main)TEST
   org $6200
   setdp $90
rsv_ptr_sub_object_erase equ 16
cur_ptr_sub_obj_erase   fdb   $0000
cur_ptr_sub_obj_draw    fdb   $0000

        ldd   cur_ptr_sub_obj_erase
        std   rsv_ptr_sub_object_erase,u
        addd  #$02
        std   cur_ptr_sub_obj_erase
        stu   [cur_ptr_sub_obj_erase,pcr]
        
        ldx   cur_ptr_sub_obj_erase
        stx   rsv_ptr_sub_object_erase,u
        stu   2,x++
        stx   cur_ptr_sub_obj_erase        
        
ESP_SubCheckAppearCollision
