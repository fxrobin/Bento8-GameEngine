; ---------------------------------------------------------------------------
; ClearObj
; --------
; Subroutine to clear an object data in OST
; -- TODO --
; need optimization : only clear necessary variables
;
; input REG : [u] pointer on objet (OST)
; clear REG : [d]
; ---------------------------------------------------------------------------

ClearObj @globals
        ldd   #$0000
        sta   id,u
        sta   subtype,u
        sta   render_flags,u
        sta   priority,u
        std   anim,u
        sta   anim_frame,u
        sta   anim_frame_duration,u
        std   mapping_frame,u
*        std   x_pos,u
*        sta   x_sub,u
*        std   y_pos,u
*        sta   y_sub,u
*        sta   x_pixel,u
*        sta   y_pixel,u
        sta   routine,u
        sta   routine_secondary,u
        std   ext_variables,u
        std   ext_variables+2,u
        std   ext_variables+4,u
        std   ext_variables+6,u
        std   ext_variables+8,u
        std   ext_variables+10,u
        std   ext_variables+12,u
        std   ext_variables+14,u
        std   ext_variables+16,u
        std   ext_variables+18,u        
        sta   rsv_render_flags,u
        sta   rsv_priority_0,u
        sta   rsv_priority_1,u        
        std   rsv_priority_prev_obj_0,u
        std   rsv_priority_prev_obj_1,u        
        std   rsv_priority_next_obj_0,u
        std   rsv_priority_next_obj_1,u        
        std   rsv_prev_anim,u
        std   rsv_curr_mapping_frame,u
        std   rsv_prev_mapping_frame_0,u
        std   rsv_prev_mapping_frame_1,u
        std   rsv_bgdata_0,u
        std   rsv_bgdata_1,u
        sta   rsv_prev_x_pixel_0,u
        sta   rsv_prev_x_pixel_1,u
        sta   rsv_prev_y_pixel_0,u
        sta   rsv_prev_y_pixel_1,u
    rts