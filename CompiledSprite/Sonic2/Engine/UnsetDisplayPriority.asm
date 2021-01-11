* ---------------------------------------------------------------------------
* UnsetDisplayPriority
* --------------------
* Subroutine to unset sprites in Display Sprite Priority structure
* Read Lst_Priority_Unset_0/1
*
* input REG : none
* ---------------------------------------------------------------------------
									   
UnsetDisplayPriority

UDP_Start
        lda   Glb_Cur_Wrk_Screen_Id         ; read current screen buffer for write operations
        bne   UDP_B1
        
UDP_B0                                    
        ldx   #Lst_Priority_Unset_0+2
UDP_CheckEndB0        
        cmpx  Lst_Priority_Unset_0          ; end of priority unset list
        bne   UDP_CheckPrioPrevB0
UDP_InitListB0      
        ldx   #Lst_Priority_Unset_0+2 
        stx   Lst_Priority_Unset_0          ; set Lst_Priority_Unset_0 index
        rts
UDP_CheckPrioPrevB0
        ldu   ,x++
        ldd   rsv_priority_prev_obj_0,u
        bne   UDP_ChainPrevB0
        lda   rsv_priority_0,u
        ldy   Tbl_Priority_First_Entry_0
        leay
        bra   UDP_CheckPrioNextB0        
UDP_ChainPrevB0

UDP_CheckPrioNextB0       
        ldd   rsv_priority_next_obj_0,u
        bne   UDP_ChainNextB0

        bra   UDP_CheckDeleteB0        
UDP_ChainNextB0

UDP_CheckDeleteB0

        bra   UDP_Next
UDP_SetNewPrioB0
 
        bra   UDP_Next        






UDP_B1  
...        
