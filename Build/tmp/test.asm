(main)TEST
        org   $A000

ss_z_pos equ 0                         ; sprite distance from camera (z axis)                
angle    equ 0                         ; angle (z axis) 360 degrees = 256, from camera view: $00 right, $40 bottom, $80 left, $c0 top

        ; UNIT TEST INIT      
        ; ----------------------------------------------------------------------
        
        ldu   #SS_Bomb                 ; sprite data array
        ldd   #$0001
        std   ss_z_pos,u
        
        lda   #$00        
        sta   angle,u
                
        lda   #$00
        sta   SSTrack_mapping_frame    ; image id
        
        ldb   #$00
        stb   SSTrack_Orientation
                
        ldx   #SpecialPerspective
        lda   SSTrack_mapping_frame
        asla
        ldd   a,x
        leax  d,x
        stx   SS_CurrentPerspective    ; ptr to perspective data
        
        ; TEST
        ; ----------------------------------------------------------------------    
        
        jsr   SSB_ComputeCoordinates
        bra   *

SSB_ComputeCoordinates                                                    *loc_351A0:
                                                                          *    move.w  d7,-(sp)
                                                                          *    moveq   #0,d2
                                                                          *    moveq   #0,d3
                                                                          *    moveq   #0,d4
                                                                          *    moveq   #0,d5
                                                                          *    moveq   #0,d6
                                                                          *    moveq   #0,d7
        ldx   #SS_CurrentPerspective                                      *    movea.l (SS_CurrentPerspective).w,a1
        ldd   ss_z_pos,u               ; load sprite z position           *    move.w  objoff_30(a0),d0
        beq   SSB_CC_HideSprite        ; 0: sprite is behind camera       *    beq.w   loc_35258
        cmpd  ,x++                     ; read nb of p. data for this img  *    cmp.w   (a1)+,d0
        bgt   SSB_CC_HideSprite        ; sprite is too far, no p. data    *    bgt.w   loc_35258
        subd  #1                       ; each perspective data for an img *    subq.w  #1,d0
        aslb                           ; is stored in groups of 6 bytes
        rola                           ; one group defines perspective    *    add.w   d0,d0
        std   @d1+1                    ; data for a specific distance     *    move.w  d0,d1
        aslb                           ; from camera, first group is
        rola                           ; for ss_z_pos = 1                 *    add.w   d0,d0
@d1     addd  #$0000                   ; (dynamic) d = (ss_z_pos-1)*6     *    add.w   d1,d0
        tfr   d,x
        tst   SSTrack_Orientation                                         *    tst.b   (SSTrack_Orientation).w
        bne   SSB_CC_Flipped           ; branch if image is flipped       *    bne.w   loc_35260
        ldd   4,x                                                         *    move.b  4(a1,d0.w),d6
        sta   @d6+1                                                       *    move.b  5(a1,d0.w),d7
        stb   @d7+1                    ; branch if angle min
        beq   SSB_CC_VisibleArea       ; of visible area is 0             *    beq.s   loc_351E8
        lda   angle,u                  ; load sprite angle                *    move.b  angle(a0),d1
@d6     cmpa  #$00                     ; (dynamic) angle max (incl.)      *    cmp.b   d6,d1
        blo   SSB_CC_VisibleArea       ; of visible area                  *    blo.s   loc_351E8
@d7     cmpa  #$00                     ; (dynamic) angle min (excl.)      *    cmp.b   d7,d1
        blo   SSB_CC_HideSprite        ; of visible area                  *    blo.s   loc_35258
                                                                          *
SSB_CC_VisibleArea                                                        *loc_351E8:
        ldd   ,x                                                          *    move.b  (a1,d0.w),d2
        sta   @xct+2
        stb   @yct+2        
                                                                          *    move.b  2(a1,d0.w),d4
                                                                          *    move.b  3(a1,d0.w),d5
                                                                          *    move.b  1(a1,d0.w),d3                                                              
                                                                          *
loc_351F8                                                                 *loc_351F8:
                                                                          *    bpl.s   loc_35202
                                                                          *    cmpi.b  #$48,d3
                                                                          *    blo.s   loc_35202
                                                                          *    ext.w   d3
                                                                          *
                                                                          *loc_35202:
        ldb   angle,u                                                     *    move.b  angle(a0),d0

        ldy   #Sine_Data                                                  *CalcSine:
        lda   #$00                                                        *    andi.w  #$FF,d0
        aslb                                                              *    add.w   d0,d0
	    rola
	    ldx   d,y
	    stx   @sin+1
        addd  #$80                                                        *    addi.w  #$80,d0
	    ldd   d,y                                                         *    move.w  Sine_Data(pc,d0.w),d1 ; cos
                                                                          *    subi.w  #$80,d0
                                                                          *    move.w  Sine_Data(pc,d0.w),d0 ; sin
                                                                          *; CalcSineEnd
                                                                          
                                                                          *    muls.w  d4,d1
                                                                          *    muls.w  d5,d0
                                                                          *    asr.l   #8,d0
                                                                          *    asr.l   #8,d1
                                                                          *    add.w   d2,d1
                                                                          *    add.w   d3,d0
                                                                          *    move.w  d1,x_pos(a0)
                                                                          *    move.w  d0,y_pos(a0)                                                                          
        cmpd  #$FF00
        bne   @cos1
        ldb   2,x
        fonctionne pas ...
        bra   @xct
@cos1   cmpd  #$0100
        bne   @cos2
        lda   #$00
        ldb   2,x       
        bra   @xct
@cos2   anda  #$80
        sta   @cosxor+1
        lda   2,x
        anda  #$80
@cosxor eora  #$00
        beq   @cosmul
        lda   2,x                      ; x radius is unsigned   
        mul
        nega
        negb
        sbca  #0
        bra   @xct
@cosmul mul                            ; we want to do a signed mul
@xct    addd  #$0000                   ; (dynamic) add x center of ellipse
        std   x_pos,u
          


@sin    ldd   #$0000                   ; (dynamic) sinus
                                                                                                                                        

                                                                          
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          
                                                                          *    move.l  objoff_34(a0),d0
                                                                          *    beq.s   loc_3524E
                                                                          *    movea.l d0,a1 ; a1=object
                                                                          *    move.b  angle(a0),d0
                                                                          *
                                                                          *CalcSine:
        lda   #$00                                                        *    andi.w  #$FF,d0
        aslb                                                              *    add.w   d0,d0
	    rola                                                              
                                                                          *    addi.w  #$80,d0
	    ldy   d,x                      ; x is already loaded to Sine_Data *    move.w  Sine_Data(pc,d0.w),d1 ; cos
        addd  #$80                                                        *    subi.w  #$80,d0
        ldx   d,x                                                         *    move.w  Sine_Data(pc,d0.w),d0 ; sin
                                                                          *; CalcSineEnd
                                                                          *                
                                                                          *    move.w  d4,d7
                                                                          *    lsr.w   #2,d7
                                                                          *    add.w   d7,d4
                                                                          *    muls.w  d4,d1
                                                                          *    move.w  d5,d7
                                                                          *    asr.w   #2,d7
                                                                          *    add.w   d7,d5
                                                                          *    muls.w  d5,d0
                                                                          *    asr.l   #8,d0
                                                                          *    asr.l   #8,d1
                                                                          *    add.w   d2,d1
                                                                          *    add.w   d3,d0
                                                                          *    move.w  d1,x_pos(a1)
                                                                          *    move.w  d0,y_pos(a1)
                                                                          *
                                                                          *loc_3524E:
                                                                          *    ori.b   #$80,render_flags(a0)
                                                                          *
                                                                          *loc_35254:
                                                                          *    move.w  (sp)+,d7
        rts                                                               *    rts                                                      
                                                                          *; ===========================================================================
													                      
SSB_CC_HideSprite                                                         *loc_35258:
                                                                          *    andi.b  #$7F,render_flags(a0)
        rts                                                               *    bra.s   loc_35254
                                                                          *; ===========================================================================  
        
SSB_CC_Flipped                                                            *loc_35260:
                                                                          *    move.b  #$80,d1
                                                                          *    move.b  4(a1,d0.w),d6
                                                                          *    move.b  5(a1,d0.w),d7
                                                                          *    beq.s   loc_35282
                                                                          *    sub.w   d1,d6
                                                                          *    sub.w   d1,d7
                                                                          *    neg.w   d6
                                                                          *    neg.w   d7
                                                                          *    move.b  angle(a0),d1
                                                                          *    cmp.b   d7,d1
                                                                          *    blo.s   loc_35282
                                                                          *    cmp.b   d6,d1
                                                                          *    blo.s   loc_35258
                                                                          *
                                                                          *loc_35282:
                                                                          *    move.b  (a1,d0.w),d2
                                                                          *    move.b  2(a1,d0.w),d4
                                                                          *    move.b  3(a1,d0.w),d5
                                                                          *    subi.w  #$100,d2
                                                                          *    neg.w   d2
                                                                          *    move.b  1(a1,d0.w),d3
                                                                          *    bra.w   loc_351F8
        
SS_Bomb               rmb 3,0
SSTrack_Orientation   fcb $00
SSTrack_mapping_frame fcb $00
SS_CurrentPerspective fdb $0000        

Sine_Data                                                                 *Sine_Data:      BINCLUDE        "misc/sinewave.bin"
        INCLUDEBIN "./Engine/sinewave.bin"                                 
        
        ; -------------------------------------------------------------------------------------------------------------             
        ;
        ; 0000 0006 000c ... 00ff 0100 00ff ... 0006 0000 fffa ... ff01 ff00 ff01 ... fffa 0000 0006 ... 00ff
        ; |______________________________________________________________________________|
        ;  sin values from index $0000 to index $01ff, value range: $ff00 (-256) to $0100 (256) 
        ;                         |_________________________________________________________________________|
        ;                          cos values from index $0080 to index $027f, value range: $ff00 (-256) to $0100 (256)
        ;
        ; -------------------------------------------------------------------------------------------------------------
        
SpecialPerspective
        INCLUDEBIN "./GameMode/SPECIAL_STAGE/Special stage object perspective data.bin" 

        ; -------------------------------------------------------------------------------------------------------------
        ;
        ; 56 words of index offset to each halfpipe images
        ; for each image:
        ;  1 word : n number of z_pos defined for this frame from 1 (camera fron) to n (far away)
        ;  n groups of 6 words : 7b dd b8 e6 00 00   that defines an elipse arc
        ;                        |  |  |  |  |  |___ angle min (excl.) of visible area (0: no invisible area)
        ;                        |  |  |  |  |______ angle max (incl.) of visible area
        ;                        |  |  |  |_________ y radius
        ;                        |  |  |____________ x radius
        ;                        |  |_______________ y origin
        ;                        |__________________ x origin
        ;
        ; -------------------------------------------------------------------------------------------------------------       