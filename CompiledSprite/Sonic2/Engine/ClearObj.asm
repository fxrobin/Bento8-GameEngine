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
    
    
Mem  Code  Cycles Running Total     Assembly Code (Mnemonics)
4000 8E2010 [3]     3               LDX    #$2000+16
4003 CE0000 [3]     6               LDU    #$0000
4006 CC0020 [3]     9               LDD    #$0020
* This loop is 103 cycles to write 32 bytes
* We cycle through the loop 256 times so the calculation is
* 256 * 103 = 26,368 CPU Cycles
4009 EF10   [5+1]   6           !   STU    -16,X
400B EF12   [5+1]   12              STU    -14,X
400D EF14   [5+1]   18              STU    -12,X
400F EF16   [5+1]   24              STU    -10,X
4011 EF18   [5+1]   30              STU    -8,X
4013 EF1A   [5+1]   36              STU    -6,X
4015 EF1C   [5+1]   42              STU    -4,X
4017 EF1E   [5+1]   48              STU    -2,X
4019 EF84   [5+0]   53              STU    ,X
401B EF02   [5+1]   59              STU    2,X
401D EF04   [5+1]   65              STU    4,X
401F EF06   [5+1]   71              STU    6,X
4021 EF08   [5+1]   77              STU    8,X
4023 EF0A   [5+1]   83              STU    10,X
4025 EF0C   [5+1]   89              STU    12,X
4027 EF0E   [5+1]   95              STU    14,X
4029 3A     [3]     98              ABX
402A 4A     [2]     100             DECA
402B 26DC   [3]     103             BNE    <    
    
    Mem  Code   Cycles Running Total            Assembly Code (Mnemonics)
4073 CC0000   [3]                             LDD     #$0000
4076 8E0000   [3]                             LDX     #$0000
4079 3184     [4+0]                           LEAY    ,X
407B CE4000   [3]                             LDU     #$2000+$2000
* This loop is 70 cycles to write 32 bytes
* We cycle through the loop 256 times so the calculation is
* 256 * 70 = 17,920 CPU Cycles
407E 3636     [5+6]   11      !               PSHU    D,X,Y
4080 3636     [5+6]   22                      PSHU    D,X,Y
4082 3636     [5+6]   33                      PSHU    D,X,Y
4084 3636     [5+6]   44                      PSHU    D,X,Y
4086 3636     [5+6]   55                      PSHU    D,X,Y
4088 3606     [5+2]   62                      PSHU    D
408A 11832000 [5]     67                      CMPU    #$2000
408E 22EE     [3]     70                      BHI             <



