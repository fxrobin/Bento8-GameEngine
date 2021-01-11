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
        ldx   DPS_buffer_0
        ldd   #Lst_Priority_Unset_0+2
        bra   UDP_Process
UDP_B1  
        ldx   DPS_buffer_1
        ldd   #Lst_Priority_Unset_1+2
        
UDP_Process
        std   UDP_InitList+1                                    
        ldu   buf_Lst_Priority_Unset,x++   
        stu   UDP_CheckEnd+1
UDP_CheckEnd        
        cmpx  #$0000                        ; (dynamic) end of priority unset list
        bne   UDP_Unset
UDP_InitList        
        ldx   #$0000                        ; (dynamic) load Lst_Priority_Unset_0/1 adress +2 
        stx   -2,x                          ; set Lst_Priority_Unset_0/1 index
        rts
           
UDP_Unset
        ldu   buf_Lst_Priority_Unset+2,x++
        ...
        bra   UDP_Next
        
        