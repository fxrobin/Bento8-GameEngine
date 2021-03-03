* ---------------------------------------------------------------------------
* PlayPCM
* ------------
* Subroutine to play a PCM sample at 16kHz
* This will freeze anything running
* DAC Init from Mission: Liftoff (merci Prehisto ;-))
*
* input REG : [y] Pcm_ index to play
* reset REG : [d] [x] [y]
* ---------------------------------------------------------------------------

PlayPCM *@globals


       * SAUVER la page !!!!!!!!!!


        ldd   #$fb3f  ! Mute by CRA to 
        anda  $e7cf   ! avoid sound when 
        sta   $e7cf   ! $e7cd written
        stb   $e7cd   ! Full sound line
        ora   #$04    ! Disable mute by
        sta   $e7cf   ! CRA and sound
        
PlayPCM_ReadChunk
        lda   pcm_page,y                    ; load memory page
        cmpa  #$FF
        beq   PlayPCM_End
        sta   $E7E5                         ; mount page in A000-DFFF                
        ldx   pcm_start_addr,y              ; Chunk start addr
       
PlayPCM_Loop      
        cmpx  pcm_end_addr,y
        beq   PlayPCM_NextChunk
        lda   ,x+
        sta   $e7cd                         ; send byte to DAC
        mul                                 ; tempo for 16hHz
        mul
        mul
        ldd   #$0000
        bra   PlayPCM_Loop                  ; loop is 62 cycles instead of 62,5
         
PlayPCM_NextChunk
        leay  pcm_meta_size,y
        ldd   #$0000                        ; tempo for 16kHz
        ldd   #$0000
        ldd   #$0000
        ldd   #$0000
        bra   PlayPCM_ReadChunk
        
PlayPCM_End        
        ldd   #$fbfc  ! Mute by CRA to
        anda  $e7cf   ! avoid sound when
        sta   $e7cf   ! $e7cd is written
        andb  $e7cd   ! Activate
        stb   $e7cd   ! joystick port
        ora   #$04    ! Disable mute by
        sta   $e7cf   ! CRA + joystick
        
        * AJOUTER RECHARGEMENT de la page initialement chargée !!!!
        
        rts   
