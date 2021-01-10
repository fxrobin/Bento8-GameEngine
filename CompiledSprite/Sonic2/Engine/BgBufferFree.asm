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
        std   BBF_SetNewEntryNextentry+1    ; init next entry of new entry to 0000
        ldb   Glb_Cur_Wrk_Screen_Id         ; read current screen buffer for write operations
        bne   BBF1                          ; branch if buffer 1 is current
        
BBF0
        ldu   rsv_prev_mapping_frame_0,u    ; get sprite last image for this buffer
        lda   erase_nb_cell,u               ; get nb of cell to free
        ldu   Lst_FreeCell_0                ; get cell table for this buffer
        stu   BBF_AddNewEntryAtEnd+4        ; auto-modification to access cell table later
        ldu   Lst_FreeCellFirstEntry_0      ; load first cell for screen buffer 0
        bra   BBF_Next
        
BBF1        
        ldu   rsv_prev_mapping_frame_1,u
        lda   erase_nb_cell,u        
        ldu   Lst_FreeCell_1
        stu   BBF_AddNewEntryAtEnd+4        
        ldu   Lst_FreeCellFirstEntry_1
        
BBF_Next                                    ; loop thru all entry        
        beq   BBF_AddNewEntryAtEnd          ; branch if no more entry to expand
        cmpy  cell_start,u                  ; compare current cell_start with input param cell_end
        beq   BBF_ExpandAtStart             ; branch if current cell_start equals input param cell_end
        bhi   BBF_ExpandAtEnd               ; branch if current cell_start < input param cell_end
        ldu   next_entry,u                  ; move to next entry
        bra   BBF_Next
          
BBF_AddNewEntry
        stu   BBF_SetNewEntryNextentry+1
        leau  next_entry,u                  ; there is a previous entry, save next_entry adress to store new entry
BBF_AddNewEntryAtEnd
        stu   BBF_SetNewEntryPrevLink+1     ; if no previous entry we will be using Lst_FreeCellFirstEntry from BBF
        ldu   #$0000                        ; Lst_FreeCell_0 or Lst_FreeCell_1
BBF_FindFreeSlot        
        ldb   nb_cells,u                    ; read Lst_FreeCell
        beq   BBF_SetNewEntry               ; branch if empty entry
        leau  entry_size,u                  ; move to next entry
        bra   BBF_FindFreeSlot              ; loop     
BBF_SetNewEntry
        sta   nb_cells,u                    ; store released cells
        stx   cell_start,u                  ; store cell start adress
        sty   cell_end,u                    ; store cell end adress
BBF_SetNewEntryNextentry        
        ldx   #$0000                        ; value is dynamically set
        stx   next_entry,u                  ; link to 0000 if no more entry or next_entry
BBF_SetNewEntryPrevLink        
        stu   #$0000                        ; set Lst_FreeCellFirstEntry or prev_entry.next_entry with new entry
        bra   BBF_rts

BBF_ExpandAtStart
        stx   cell_start,u
        adda  nb_cells,u
        sta   nb_cells,u
        ldy   next_entry,u
        beq   BBF_rts        
BBF_Join
        cmpx  cell_end,y
        bne   BBF_rts
        ldd   cell_start,y
        std   cell_start,u
        lda   nb_cells,y
        adda  nb_cells,u
        sta   nb_cells,u
        clr   nb_cells,y                    ; delete next entry
        ldd   next_entry,y
        std   next_entry,u                  ; join
        bra   BBF_rts

BBF_ExpandAtEnd
        cmpx  cell_end,u
        bne   BBF_AddNewEntry
        sty   cell_end,u
        adda  nb_cells,u
        sta   nb_cells,u
        
BBF_rts
        puls  d,u,pc