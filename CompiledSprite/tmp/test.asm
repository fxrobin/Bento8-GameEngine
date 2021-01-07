(main)TEST
   org $6200
   setdp $90

        ldd   9,x            ; load sub entry : rsv_prev_x_pixel_0/1 and rsv_prev_y_pixel_0/1 in one instruction
        cmpa  #10                            ; (dynamic) entry : x_pixel_0/1 + rsv_curr_mapping_frame_0/1.x_size - 1
        blo   ESP_SubCheckAppearCollision
        cmpb  #10                            ; (dynamic) entry : y_pixel_0/1 + rsv_curr_mapping_frame_0/1.y_size - 1
        blo   ESP_SubCheckAppearCollision
        
ESP_SubCheckAppearCollision
