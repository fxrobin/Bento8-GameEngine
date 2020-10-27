gotp_closest_player        fdb   $0000     * ptr objet de MainCharacter ou Sidekick
gotp_player_is_left        fcb   $00       * 0: player left from object, 2: right
gotp_player_is_above       fcb   $00       * 0: player above object, 2: below
gotp_player_h_distance     fdb   $0000     * closest character's h distance to obj
gotp_player_v_distance     fdb   $0000     * closest character's v distance to obj 
gotp_abs_h_distance_mainc  fdb   $0000     * absolute horizontal distance to main character
gotp_h_distance_sidek      fdb   $0000     * horizontal distance to sidekick