* Generated Code

gm_TITLESCR equ $00
current_game_mode
        fcb   gm_TITLESCR
gm_data_TITLESCR
        fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF
gm_dataEnd
GameModesArray
        fdb   gm_data_TITLESCR,gm_dataEnd-gm_data_TITLESCR