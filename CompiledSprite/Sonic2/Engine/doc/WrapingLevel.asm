WrapingLevels :


For S2 at least, there is a better way to fix that bug: in ScrollVerti, find this:
Code (Text):
ScrollVerti:
    moveq    #0,d1
    move.w  y_pos(a0),d0
    sub.w   (a1),d0     ; subtract camera Y pos
    cmpi.w  #-$100,(Camera_Min_Y_pos).w ; does the level wrap vertically?
    bne.s   +       ; if not, branch
    andi.w  #$7FF,d0
+
and change it to this:
Code (Text):
ScrollVerti:
    moveq    #0,d1
    move.w  y_pos(a0),d0
    sub.w   (a1),d0     ; subtract camera Y pos
    cmpi.w  #-$100,(Camera_Min_Y_pos).w ; does the level wrap vertically?
    bne.s   +       ; if not, branch
    andi.w  #$7FF,d0
    move.w  #$FC00,d1
    add.w   d1,d0
    eor.w   d1,d0
+
What this does is to convert the distance from the top of the screen from non-wrapping to wrapping; how it does that, I will let you guys figure out :v:


EDIT: Okay, I have an answer.


Anyway, let's work this out. For this example, let's say Sonic is at y_pos $05EC.



Code (ASM):
    sub.w   (a1),d0             ; Minus Camera_Y_pos from d0

When Sonic is at #$5EC, the camera is at #$58C.

#$5EC - #$58C = #$60

So d0 is now #$60.



Code (ASM):
    tst.w   (Camera_Min_Y_pos).w        ; Does this level y-wrap?
    bpl.s   loc_D78E            ; If not, branch and skip looping

Already explained. In y-wrap levels, the Camera_Min_Y_pos is always #-$100. In non-y-wrap levels, it's always #0 or more. So, is Camera_Min_Y_pos at #0 or more? If so, branch, it's not a y-wrap level. Otherwise, it must be less than #0, so it's obviously a y-wrap level.



Code (ASM):
    andi.w  #$7FF,d0            ; Loop Sonic's y_pos

This is to make sure that d0 never goes past #$800. Otherwise, the camera will think Sonic will be miles high or below when Sonic crosses the y-wrap. So, let's take this into account. Let's change Sonic's current y_pos (#$0567) and #$7FF in question, into bits:

Code (Text):
#$07FF = 0000 0111 1111 1111
 
#$0060 = 0000 0000 0110 0000

Because $7FF is a word, we will treat it as $07FF. Now, we put each of these bits on top of another, if the top is 0, then the bottom will be changed to a 0. If the top is 1, then the bottom will not change. And the result?

Code (Text):
#$07FF = 0000 0111 1111 1111
#$0060 = 0000 0000 0110 0000
         equals
#$0060 = 0000 0000 0110 0000

So, nothing changes. Basically, in #$07FF, the 0 will keep Sonic's y_pos first bit always at 0, and the 7 will always keep it as 7 or less (not letting it be 8 or more). Anything that is 8 or more will go to 0 or more instead. The F and the other F will never change anything.



Code (ASM):
    move.w  #$FC00,d1           ; Move #-$400 to d1

d1 is now set at #-$400.



Code (ASM):
    add.w   d1,d0               ; Add d1 (#-$400) to d0

Seeming as d0 is still #$60, with #-$400 added, d0 is now #$FC60.



Code (ASM):
    eor.w   d1,d0               ; Exclusive OR d0 with #-$400

Let's change them into bits again.

Code (Text):
#$FC00 (#-$400) = 1111 1100 0000 0000
 
#$FC60 = 1111 1100 0110 0000

Now, we put each of these bits on top of another, If the top is 0, then the bottom will not change. If the top is 1, then the bottom bit will reverse (0 becomes 1 and 1 becomes 0). And the result?

Code (Text):
#$FC00 = 1111 1100 0000 0000
#$FC60 = 1111 1100 0110 0000
         equals
#$0060 = 0000 0000 0110 0000




So basically, the EOR instruction is keeping the first byte at 00. If Sonic looks down fully, then immediately jumps, above the camera, his new y_pos will be in the FFXX's instead of 07XX's. That way, Sonic can never make it go to 07 like he used to. Because it's now at FF, he technically hasn't crossed the y-wrap, and the camera still thinks Sonic is close by, so everything is normal.


Am I right?



May I suggest though, wouldn't

Since the data is in a register, using eori won't make a difference -- the assembler will still convert it into an eor in the end.

You are close, but you are wrong about the operation sequence keeping the top byte zero; what the sequence of operations does is this:
Code (Text):
    andi.w  #$7FF,d0        ; Discard bits above bit 10, including sign bit
    move.w  #$FC00,d1   ; Move into register for speed
    add.w   d1,d0       ; If bit 10 is set, bits 10-15 will be clear; if bit 10 was clear, bits 10-15 will be set
    eor.w   d1,d0       ; Flip bits 10-15, so that they are set or clear according to what bit 10 was before the add
So basically, it copies bit 10 to bits 11-15. So if bit 10 was set, the number becomes negative, while if bit 10 was clear, the number becomes positive; so bit 10 effectively becomes the sign bit. This means: a sign extension from bit 10.

If you make the computation, the largest positive 10-bit number (bits 0-9 set, all else clear) is $3FF, while the largest negative 10-bit number is $FC00 = -$400. Both of these are half of the height of a wrapping level ($7FF) rounded down to -infinity.

There is still the issue of why does this sign extension works. Simply put, it adds back the sign that the andi stripped. A distance higher than $3FF right after the andi represents a smaller distance on the other direction (a negative distance). Given the way numbers are stored (two's complement), the sign extension will do the work.

That's what I meant by when he jumps above the camera, his new y_pos will be in the FFXX's instead of 07XX's. You just explained it in a lot more technical way =P


Although, your way definitely works better. Ending result, it works the same way as mine except the camera can still move at it's original speed. And that's better, obviously.



As for the eor thing, I learn something new everyday. I didn't know that, thanks for the tip.