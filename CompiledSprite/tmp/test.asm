(main)TEST
   org $6200
   setdp $90

rsv_priority_next_obj_0 equ 55

        ldx   rsv_priority_next_obj_0,x
        leax  rsv_priority_next_obj_0,x
