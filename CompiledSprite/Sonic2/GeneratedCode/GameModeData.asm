* Generated Code

* structure: sector, nb sector, drive (bit 7) track (bit 6-0), end offset, ram dest page, ram dest end addr. hb, ram dest end addr. lb
gm_TITLESCR
        fdb   current_game_mode_data+372
gmboot * @globals
        fcb   $05,$01,$00,$04,$05,$DF,$F4 * PaletteHandler Object code
        fcb   $0E,$01,$00,$F0,$05,$DF,$5A * Img_star_4 BckDraw
        fcb   $0F,$01,$00,$63,$05,$DD,$A9 * Img_star_4 Erase
        fcb   $10,$01,$00,$13,$05,$DD,$18 * Img_star_3 BckDraw
        fcb   $01,$00,$01,$68,$05,$DC,$18 * Img_star_3 Erase
        fcb   $01,$03,$01,$21,$06,$DF,$38 * Img_sonicHand BckDraw
        fcb   $04,$01,$01,$2E,$05,$DB,$BE * Img_sonicHand Erase
        fcb   $05,$00,$01,$94,$05,$D9,$F2 * Img_star_2 BckDraw
        fcb   $05,$00,$01,$D2,$05,$D9,$83 * Img_star_2 Erase
        fcb   $05,$01,$01,$1D,$05,$D9,$59 * Img_star_1 BckDraw
        fcb   $06,$00,$01,$53,$05,$D9,$08 * Img_star_1 Erase
        fcb   $06,$02,$01,$4A,$05,$D8,$E8 * Img_emblemBack08 Draw
        fcb   $08,$02,$01,$1E,$05,$D4,$C9 * Img_emblemBack07 Draw
        fcb   $0A,$01,$01,$EB,$05,$D1,$3E * Img_emblemBack09 Draw
        fcb   $0B,$02,$01,$0B,$05,$CD,$C7 * Img_emblemBack04 Draw
        fcb   $0D,$01,$01,$D0,$05,$CC,$31 * Img_emblemBack03 Draw
        fcb   $0E,$01,$01,$27,$05,$C8,$9A * Img_emblemBack06 Draw
        fcb   $0F,$01,$01,$BC,$05,$C6,$D0 * Img_emblemBack05 Draw
        fcb   $10,$07,$01,$CE,$07,$D7,$E5 * Img_tails_5 BckDraw
        fcb   $07,$02,$02,$82,$05,$C3,$03 * Img_tails_5 Erase
        fcb   $09,$07,$02,$1C,$07,$C8,$FC * Img_tails_4 BckDraw
        fcb   $10,$01,$02,$C2,$05,$BE,$8F * Img_tails_4 Erase
        fcb   $01,$07,$03,$32,$07,$BA,$BF * Img_tails_3 BckDraw
        fcb   $08,$01,$03,$E7,$05,$BA,$52 * Img_tails_3 Erase
        fcb   $09,$06,$03,$D7,$07,$AC,$63 * Img_tails_2 BckDraw
        fcb   $0F,$02,$03,$33,$05,$B5,$EB * Img_tails_2 Erase
        fcb   $01,$05,$04,$19,$06,$D9,$E5 * Img_tails_1 BckDraw
        fcb   $06,$01,$04,$29,$05,$B2,$3E * Img_tails_1 Erase
        fcb   $07,$01,$04,$51,$05,$AE,$D4 * Img_tailsHand BckDraw
        fcb   $08,$00,$04,$D2,$05,$AD,$42 * Img_tailsHand Erase
        fcb   $08,$04,$04,$7B,$08,$DD,$C4 * Img_sonic_1 BckDraw
        fcb   $0C,$01,$04,$6C,$06,$CE,$73 * Img_sonic_1 Erase
        fcb   $0D,$05,$04,$B5,$08,$CF,$2B * Img_sonic_2 BckDraw
        fcb   $02,$01,$05,$D9,$06,$CA,$48 * Img_sonic_2 Erase
        fcb   $03,$02,$05,$B8,$05,$AC,$A4 * Img_emblemBack02 Draw
        fcb   $05,$02,$05,$8B,$05,$A9,$10 * Img_emblemBack01 Draw
        fcb   $07,$05,$05,$0A,$08,$BE,$A3 * Img_sonic_5 BckDraw
        fcb   $0C,$01,$05,$0B,$06,$C5,$9F * Img_sonic_5 Erase
        fcb   $0D,$04,$05,$AF,$08,$AF,$8E * Img_sonic_3 BckDraw
        fcb   $01,$01,$06,$A2,$06,$C1,$5C * Img_sonic_3 Erase
        fcb   $02,$05,$06,$0C,$09,$AE,$DD * Img_sonic_4 BckDraw
        fcb   $07,$01,$06,$08,$06,$BC,$FC * Img_sonic_4 Erase
        fcb   $08,$00,$06,$CD,$05,$A5,$A1 * Img_emblemFront07 Draw
        fcb   $08,$03,$06,$1E,$06,$B8,$CB * Img_emblemFront08 Draw
        fcb   $0B,$02,$06,$4D,$06,$B4,$2D * Img_emblemFront05 Draw
        fcb   $0D,$02,$06,$67,$06,$AF,$9E * Img_emblemFront06 Draw
        fcb   $0F,$02,$06,$26,$06,$AB,$6E * Img_emblemFront03 Draw
        fcb   $01,$01,$07,$C0,$05,$A3,$99 * Img_emblemFront04 Draw
        fcb   $02,$01,$07,$4E,$05,$A0,$AC * Img_emblemFront01 Draw
        fcb   $03,$01,$07,$D8,$06,$A7,$7B * Img_emblemFront02 Draw
        fcb   $04,$03,$07,$B5,$06,$A4,$A3 * TitleScreen Object code
        fcb   $07,$09,$07,$9C,$01,$7D,$B5 * TITLESCR Main Engine code
        fcb   $FF