* ---------------------------------------------------------------------------
* Subroutine to calculate sine and cosine of an angle
*
* input REG : [b] byte = angle (360 degrees == 256)
* output VAR : [y] word = 255 * sine(angle)
*              [x] word = 255 * cosine(angle)
* ---------------------------------------------------------------------------

                                                      *; ---------------------------------------------------------------------------
                                                      *; Subroutine to calculate sine and cosine of an angle
                                                      *; d0 = input byte = angle (360 degrees == 256)
                                                      *; d0 = output word = 255 * sine(angle)
                                                      *; d1 = output word = 255 * cosine(angle)
                                                      *; ---------------------------------------------------------------------------
                                                      *
                                                      *; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
                                                      *
                                                      *; sub_33B6:
CalcSine                                              *CalcSine:
        lda   #$00                                    *        andi.w  #$FF,d0
        aslb                                          *        add.w   d0,d0
	rola
                                                      *        addi.w  #$80,d0
        ldx   #Sine_Data
	ldy   d,x                                     *        move.w  Sine_Data(pc,d0.w),d1 ; cos
        addd  #$80                                    *        subi.w  #$80,d0
        ldx   d,x                                     *        move.w  Sine_Data(pc,d0.w),d0 ; sin
        rts                                           *        rts
                                                      *; End of function CalcSine
                                                      *
                                                      *; ===========================================================================
                                                      *; word_33CE:
Sine_Data                                             *Sine_Data:      BINCLUDE        "misc/sinewave.bin"
        INCLUDEBIN "./Engine/sinewave.bin"