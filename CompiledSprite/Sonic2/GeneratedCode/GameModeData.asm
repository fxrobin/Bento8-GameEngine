* Generated Code

* structure: sector, nb sector, drive (bit 7) track (bit 6-0), end offset, ram dest page, ram dest end addr. hb, ram dest end addr. lb
gm_TITLESCR
        fdb   current_game_mode_data+456
gmboot * @globals
        fcb   $05,$33,$00,$41,$0A,$DF,$F6 * Pcm_SEGA0 Sound
        fcb   $08,$1B,$03,$E6,$09,$DF,$74 * Pcm_SEGA1 Sound
        fcb   $03,$01,$05,$1A,$05,$DF,$9A * SEGA Object code
        fcb   $10,$00,$05,$F3,$05,$DF,$83 * PaletteHandler Object code
        fcb   $0D,$01,$06,$16,$05,$DE,$A2 * Img_star_4 NB0 Draw
        fcb   $0E,$00,$06,$8D,$05,$DC,$EF * Img_star_4 NB0 Erase
        fcb   $0E,$01,$06,$41,$05,$DC,$5A * Img_star_3 NB0 Draw
        fcb   $0F,$00,$06,$99,$05,$DB,$58 * Img_star_3 NB0 Erase
        fcb   $0F,$02,$06,$B3,$05,$D9,$29 * Img_sonicHand ND0 Draw
        fcb   $01,$03,$07,$6E,$06,$DD,$45 * Img_sonicHand NB0 Draw
        fcb   $04,$01,$07,$7A,$05,$DA,$FA * Img_sonicHand NB0 Erase
        fcb   $05,$00,$07,$E2,$05,$D4,$E1 * Img_star_2 NB1 Draw
        fcb   $05,$01,$07,$24,$05,$D4,$72 * Img_star_2 NB1 Erase
        fcb   $06,$00,$07,$8F,$05,$D5,$80 * Img_star_2 NB0 Draw
        fcb   $06,$00,$07,$D1,$05,$D5,$0F * Img_star_2 NB0 Erase
        fcb   $06,$01,$07,$1F,$05,$D3,$CD * Img_star_1 NB1 Draw
        fcb   $07,$00,$07,$5A,$05,$D3,$7C * Img_star_1 NB1 Erase
        fcb   $07,$00,$07,$AA,$05,$D4,$44 * Img_star_1 NB0 Draw
        fcb   $07,$00,$07,$E5,$05,$D3,$F1 * Img_star_1 NB0 Erase
        fcb   $07,$02,$07,$C9,$05,$D3,$58 * Img_emblemBack08 ND0 Draw
        fcb   $09,$02,$07,$7F,$05,$CE,$CA * Img_emblemBack07 ND0 Draw
        fcb   $0B,$02,$07,$47,$05,$CB,$30 * Img_emblemBack09 ND0 Draw
        fcb   $0D,$01,$07,$68,$05,$C7,$C1 * Img_emblemBack04 ND0 Draw
        fcb   $0E,$02,$07,$31,$05,$C6,$24 * Img_emblemBack03 ND0 Draw
        fcb   $10,$00,$07,$80,$05,$C2,$44 * Img_emblemBack06 ND0 Draw
        fcb   $10,$02,$07,$0D,$05,$C0,$87 * Img_emblemBack05 ND0 Draw
        fcb   $02,$05,$08,$D8,$07,$D0,$E2 * Img_tails_5 ND0 Draw
        fcb   $07,$07,$08,$E9,$07,$DF,$CE * Img_tails_5 NB0 Draw
        fcb   $0E,$02,$08,$A4,$05,$BC,$CF * Img_tails_5 NB0 Erase
        fcb   $10,$07,$08,$43,$08,$DB,$C4 * Img_tails_4 NB0 Draw
        fcb   $07,$01,$09,$F3,$05,$B8,$58 * Img_tails_4 NB0 Erase
        fcb   $08,$07,$09,$6A,$08,$CD,$83 * Img_tails_3 NB0 Draw
        fcb   $0F,$02,$09,$20,$06,$D7,$F1 * Img_tails_3 NB0 Erase
        fcb   $01,$06,$0A,$10,$07,$C6,$6D * Img_tails_2 NB0 Draw
        fcb   $07,$01,$0A,$6F,$05,$B4,$19 * Img_tails_2 NB0 Erase
        fcb   $08,$05,$0A,$55,$07,$BA,$08 * Img_tails_1 NB0 Draw
        fcb   $0D,$01,$0A,$6A,$05,$B0,$68 * Img_tails_1 NB0 Erase
        fcb   $0E,$01,$0A,$37,$05,$AA,$C2 * Img_tailsHand ND0 Draw
        fcb   $0F,$01,$0A,$64,$05,$AC,$FA * Img_tailsHand NB0 Draw
        fcb   $10,$00,$0A,$EA,$05,$AB,$66 * Img_tailsHand NB0 Erase
        fcb   $10,$04,$0A,$97,$08,$BF,$25 * Img_sonic_1 NB0 Draw
        fcb   $04,$01,$0B,$8C,$06,$D3,$86 * Img_sonic_1 NB0 Erase
        fcb   $05,$05,$0B,$D7,$08,$B0,$8A * Img_sonic_2 NB0 Draw
        fcb   $0A,$01,$0B,$FE,$06,$CF,$57 * Img_sonic_2 NB0 Erase
        fcb   $0B,$02,$0B,$D2,$05,$A9,$BD * Img_emblemBack02 ND0 Draw
        fcb   $0D,$02,$0B,$9E,$05,$A6,$1D * Img_emblemBack01 ND0 Draw
        fcb   $0F,$04,$0B,$AA,$07,$AE,$94 * Img_sonic_5 ND0 Draw
        fcb   $03,$05,$0C,$2D,$09,$BD,$F6 * Img_sonic_5 NB0 Draw
        fcb   $08,$01,$0C,$32,$06,$CA,$AA * Img_sonic_5 NB0 Erase
        fcb   $09,$04,$0C,$DC,$0B,$AF,$90 * Img_sonic_3 NB0 Draw
        fcb   $0D,$01,$0C,$D3,$06,$C6,$63 * Img_sonic_3 NB0 Erase
        fcb   $0E,$05,$0C,$40,$09,$AE,$DF * Img_sonic_4 NB0 Draw
        fcb   $03,$01,$0D,$41,$06,$C1,$FF * Img_sonic_4 NB0 Erase
        fcb   $04,$00,$0D,$FD,$05,$A2,$B7 * Img_emblemFront07 ND0 Draw
        fcb   $04,$03,$0D,$3E,$06,$BD,$CA * Img_emblemFront08 ND0 Draw
        fcb   $07,$02,$0D,$72,$06,$B9,$1F * Img_emblemFront05 ND0 Draw
        fcb   $09,$02,$0D,$91,$06,$B4,$58 * Img_emblemFront06 ND0 Draw
        fcb   $0B,$02,$0D,$4A,$06,$B0,$1F * Img_emblemFront03 ND0 Draw
        fcb   $0D,$01,$0D,$D9,$06,$AC,$17 * Img_emblemFront04 ND0 Draw
        fcb   $0E,$01,$0D,$5D,$05,$A0,$B0 * Img_emblemFront01 ND0 Draw
        fcb   $0F,$01,$0D,$D9,$06,$A9,$00 * Img_emblemFront02 ND0 Draw
        fcb   $10,$03,$0D,$E0,$06,$A6,$08 * Psg_TitleScreen0 Sound
        fcb   $03,$04,$0E,$03,$07,$A5,$40 * TitleScreen Object code
        fcb   $07,$0C,$0E,$1E,$01,$88,$4C * TITLESCR Main Engine code
        fcb   $FF