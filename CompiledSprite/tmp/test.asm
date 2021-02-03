(main)TEST
   org $6200
   setdp $90

Glb_Cur_Wrk_Screen_Id fcb $00

        lda   Glb_Cur_Wrk_Screen_Id
        eora  #1
        sta   Glb_Cur_Wrk_Screen_Id
(info)
        lda   #$01
        eora  Glb_Cur_Wrk_Screen_Id

(info)