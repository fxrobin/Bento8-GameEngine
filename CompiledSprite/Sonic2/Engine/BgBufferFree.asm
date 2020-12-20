; ---------------------------------------------------------------------------
; BgBufferFree
; ------------
; Subroutine to free memory from background buffer
;
; input  REG : [x] cell_start
;              [y] cell_end
; output REG : none
; ---------------------------------------------------------------------------

BgBufferFree
        pshs  d,u
        ldd   #$0000
        std   BBF_SetNewEntryNextentry+1    ; init
        ldb   Glb_Cur_Wrk_Screen_Id         ; read current screen buffer for write operations
        bne   BBF1                          ; branch if buffer 1 is current
        
BBF0
        ldu   rsv_prev_mapping_frame_0
        lda   erase_nb_cell,u
        ldu   Lst_FreeCell_0
        stu   BBF_AddNewEntryAtEnd+4
        ldu   Lst_FreeCellFirstEntry_0      ; load first cell for screen buffer 0
        bra   BBF_Next
        
BBF1        
        ldu   rsv_prev_mapping_frame_1
        lda   erase_nb_cell,u        
        ldu   Lst_FreeCell_1
        stu   BBF_AddNewEntryAtEnd+4        
        ldu   Lst_FreeCellFirstEntry_1      ; load first cell for screen buffer 1
        
BBF_Next                                    ; loop thru all entry        
        beq   BBF_AddNewEntryAtEnd          ; branch if no more entry to expand
        cmpy  cell_start,u                  ; compare current cell_start with input param cell_end
        beq   BBF_ExpandAtStart             ; branch if current cell_start equals input param cell_end
        bhi   BBF_ExpandAtEnd               ; branch if current cell_start < input param cell_end
        ldu   next_entry,u                  ; move to next entry
        bra   BBF_Next
          
BBF_AddNewEntry
        stu   BBF_SetNewEntryNextentry+1
        leau  next_entry,u
BBF_AddNewEntryAtEnd
        stu   BBF_SetNewEntryPrevLink+1        
        ldu   #$0000                        ; Lst_FreeCell_0 or Lst_FreeCell_1
BBF_FindFreeSlot        
        ldb   nb_cells,u
        beq   BBF_SetNewEntry
        leau  entry_size,u
        bra   BBF_FindFreeSlot                 
BBF_SetNewEntry
        sta   nb_cells,u
        stx   cell_start,u
        sty   cell_end,u
BBF_SetNewEntryNextentry        
        ldx   #$0000                        ; use 0000 or current entry
        stx   next_entry,u
BBF_SetNewEntryPrevLink        
        stu   #$0000                        ; init Lst_FreeCellFirstEntry or prev_entry.next_entry

BBF_ExpandAtStart
        implement 5
        bra   BBF_rts        
BBF_Join
        implement 6
        bra   BBF_rts

BBF_ExpandAtEnd
        cmpx  cell_end,u
        bne   BBF_AddNewEntry
        implement 4

BBF_rts
        puls  d,u,pc