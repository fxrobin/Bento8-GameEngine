To further improve the speed of the scattered rings object, read this post! This is separate to the guide within this post.




Warning: This guide is for Sonic 2, and I am using the Xenowhirl 2007 disassembly. For Sonic 1 and/or other disassemblies, it shouldn't be too hard still if you follow this guide. ALSO, REMEMBER TO BACK-UP BEFORE MAKING ANY CHANGES. I'm not held responsible for any screw-ups to your hack.

Also: If you want your scattered rings to act if they're underwater like Sonic does, it is best to follow this guide first (by me).

If you want to use the tables I've supplied in this guide, again, you WILL need to follow this guide first


I bought you the underwater scattered rings guide and SpirituInsanum told us how to speed up the ring loss process. Together, we bring you "How to speed up the ring loss process with underwater".

Code (ASM):
loc_120BA:
    _move.b #$37,0(a1) ; load obj37
    addq.b  #2,routine(a1)
    move.b  #8,y_radius(a1)
    move.b  #8,x_radius(a1)
    move.w  x_pos(a0),x_pos(a1)
    move.w  y_pos(a0),y_pos(a1)
    move.l  #Obj25_MapUnc_12382,mappings(a1)
    move.w  #$26BC,art_tile(a1)
    bsr.w   Adjust2PArtPointer2
    move.b  #$84,render_flags(a1)
    move.b  #3,priority(a1)
    move.b  #$47,collision_flags(a1)
    move.b  #8,width_pixels(a1)
    move.b  #-1,(Ring_spill_anim_counter).w
    tst.w   d4
    bmi.s   loc_12132
    move.w  d4,d0
    bsr.w   JmpTo4_CalcSine
    move.w  d4,d2
    lsr.w   #8,d2
    asl.w   d2,d0
    asl.w   d2,d1
    move.w  d0,d2
    move.w  d1,d3
    addi.b  #$10,d4
    bcc.s   loc_12132
    subi.w  #$80,d4
    bcc.s   loc_12132
    move.w  #$288,d4
 
loc_12132:
 
    move.w  d2,x_vel(a1)
    move.w  d3,y_vel(a1)
    neg.w   d2
    neg.w   d4
    dbf d5,loc_120B2

This is part of the scattered rings code. This code repeats itself a maximum of 32 times; each time for each ring (and like said, it will make you scatter a max of 32 rings, but still set your counter to 0). What this code does, is works out how high and how far to scatter a ring, then then whether to make it fly left or right. Once it's done that, it does it again for another ring, and then another, and then another until it either reaches your ring count, or 32. Whilst it's doing this, nothing else can be done. It's not much of a problem when there's not much about, but if you lose a lot of rings when there's so many other objects about and/or in water, it can go slow for a second.



Anyway, This is quite big and slow, and I'm about to show you how to reduce it significantly; speeding the ring loss process, freeing the processor for other work. Instead of doing lots of calculations on the fly over and over, we will use a pre-made table to insert how high, how far and which way we want our rings to go. This will be a lot quicker as we already have the calculations done this way.


But how do we come up with our table? Well, I'm about to show you. But first, in this guide, I will be using two pre-made tables myself. These are for a max of 20 rings above water, and 8 rings below water. Also, the ring spill underwater will be using the effect from my other guide. If you're happy to do the same as me, skip ahead to step 4 (although you might want to read the first couple of steps so you know what's going on).





Step 1 - Change the max amount of rings to spill

In the scattered rings object, go to "loc_120A2:" and the first line you should see is this:

Code (ASM):
    moveq   #$20,d0
This is hexadecimal for 32, this is the max number of rings it will spill. Take the $ sign out (so it's not hexadecimal anymore), and then change the number to the amount of rings you want it to spill at maximum. If you want it to lose a max of 44 rings for example, then simply change the 20 to 44. If you want to change the number of max rings spill for when underwater (as things get slower underwater) we can add a check to see if underwater and if so, to change the number. Say you want to lose 20 rings over water but only 8 when in the water, you would do this:

Code (ASM):
loc_120A2:
    moveq   #20,d0          ; lose a max of 20 rings
    lea (MainCharacter).w,a2    ; a2=character
    btst    #6,status(a2)       ; is Sonic underwater?
    beq.s   +           ; if not, branch
    moveq   #8,d0           ; lose a max of 8 rings when underwater
+
    cmp.w   d0,d5
    bcs.s   loc_120AA
    move.w  d0,d5
Make sure the Maincharacter is loaded to a2, otherwise it may interrupt with the rest of our work or the original code.

You DON'T have to change the max for underwater, but it is advisable, because things get very slow underwater. The more rings there are, the slower things will get, because more processing power goes in to making them bounce and etc. That's purely the only reason.





Step 2 - Make our tables for pre-calculated figures

go to "loc_120AA:" and change this:

Code (ASM):
loc_120AA:
    subq.w  #1,d5
    move.w  #$288,d4
    bra.s   loc_120BA
to this:

Code (ASM):
loc_120AA:
    subq.w  #1,d5
    move.w  #$288,d4
    lea ($FFFFAA00).l,a4    ; Load $FFFFAA00 to a4
    bra.s   loc_120BA
$FFFFAA00 is nemesis's decompression buffer's RAM. It's not used during gameplay, so we can use this. All we've done is copied the RAM address to a4.


Then go to "loc_12132:" and change this:

Code (ASM):
loc_12132:
    move.w  d2,x_vel(a1)
    move.w  d3,y_vel(a1)
    neg.w   d2
    neg.w   d4
    dbf d5,loc_120B2
to this:

Code (ASM):
loc_12132:
    move.w  d2,x_vel(a1)
    move.w  d3,y_vel(a1)
    neg.w   d2
    neg.w   d4
    move.w  d2,(a4)+    ; Move d2 to a4 then increment a4 by a word
    move.w  d3,(a4)+    ; Move d3 to a4 then increment a4 by a word
    dbf d5,loc_120B2
Just added two lines here. Basically, once one ring has calculated it's x_vel and y_vel when it's going to spill out, it's copied it's values to a4, then a4 has incremented so that the next value can be added. The code repeats itself for the next ring and again, once it's got it's calculations, it's then copied to a4, and keeps doing this for all rings spilled.





Step 3 - Build and test. Let's get our new table!

Save, build and test. Should be no errors. Now, using your emulator (I reccomend Regen), go to the RAM viewer (Tools > RAM viewer) and go to $FFFFAA00. Load any level up. During level loading, the numbers at this RAM address will go crazy, but once the title cards have gone away, it should stop and not do anything (there will still be numbers there).

Now, collect the max number of rings (or more) and then get hurt and lose your rings. They'll scatter everywhere as usual, but all it's values has just been moved to $FFFFAA00. Ta-dah! There's our new table! What you need to do now is open notepad and write your new values in using words. Give it a label too! Here is a guide on how to do it (mine is a max of 20 rings):

Code (ASM):
; ===========================================================================
; ---------------------------------------------------------------------------
; Ring Spawn Array
; ---------------------------------------------------------------------------
 
SpillRingData:  dc.w    $00C4,$FC14, $FF3C,$FC14, $0238,$FCB0, $FDC8,$FCB0 ; 4
                dc.w    $0350,$FDC8, $FCB0,$FDC8, $03EC,$FF3C, $FC14,$FF3C ; 8
                dc.w    $03EC,$00C4, $FC14,$00C4, $0350,$0238, $FCB0,$0238 ; 12
                dc.w    $0238,$0350, $FDC8,$0350, $00C4,$03EC, $FF3C,$03EC ; 16
                dc.w    $0062,$FE0A, $FF9E,$FE0A, $011C,$FE58, $FEE4,$FE58 ; 20
                even
; ===========================================================================
It goes x_vel, y_vel, x_vel, y_vel, x_vel, y_vel, x_vel, y_vel, etc, etc.


REMEMBER, if you're doing less rings for underwater, you need to get the max number of rings again, go underwater then get hurt. You'll get another new table. For my underwater, the max is 8. And again, I'm using the underwater scattered rings guide. Here's a guide for 8 rings.

Code (ASM):
; ===========================================================================
; ---------------------------------------------------------------------------
; Ring Spawn Array Underwater
; ---------------------------------------------------------------------------
 
SpillRingDataU: dc.w    $0064,$FE08, $FF9C,$FE08, $011C,$FE58, $FEE4,$FE58 ; 4
                dc.w    $01A8,$FEE4, $FE58,$FEE4, $01F8,$FF9C, $FE08,$FF9C ; 8
                even
; ===========================================================================
; ===========================================================================
Notice I've changed the label for the underwater table. I've just stuck a U after it. You will need to insert these (or your own, whatever) into your ASM file. A good place to put it, find "BranchTo5_DeleteObject" and stick it after

Code (ASM):
BranchTo5_DeleteObject
    bra.w   DeleteObject




Step 4 - Loading our new tables

Now we've got our new tables, let's use them.

Go back to "loc_120A2:". This is where we will make it load our new tables. The tables will load into a3. Change it to make it look like this:

Code (ASM):
loc_120A2:
    lea SpillRingData,a3    ; load the address of the array in a3
    moveq   #20,d0          ; lose a max of 20 rings
    lea (MainCharacter).w,a2    ; a2=character
    btst    #6,status(a2)       ; is Sonic underwater?
    beq.s   +           ; if not, branch
    lea    SpillRingDataU,a3    ; load the UNDERWATER address of the array in a3
    moveq   #8,d0           ; lose a max of 8 rings underwater
+
    cmp.w   d0,d5
    bcs.s   loc_120AA
    move.w  d0,d5
Basically, it will load the overwater table and make 20 the max rings. It then checks if your underwater and if so, load the underwater table and change the max to 8. If not underwater, it will skip doing that bit and carry on with normal. REMEMBER to change the label and max rings to whatever you gave it. It only does this once every time you lose rings, it doesn't repeat itself unlike the calculations below it.


Go to "loc_120AA:" and change this:

Code (ASM):
loc_120AA:
    subq.w  #1,d5
    move.w  #$288,d4
    lea ($FFFFAA00).l,a4    ; Load $FFFFAA00 to a4
    bra.s   loc_120BA
to this:

Code (ASM):
loc_120AA:
    subq.w  #1,d5
    bra.s   loc_120BA
The Nemesis RAM bit isn't needed anymore; that was just for creating our tables. The "move.w #$288,d4" isn't needed anymore either as that's part of the calculations of spilling the rings.





Step 5 - Using the data from our new tables

Go to "loc_120BA:"

Code (ASM):
loc_120BA:
    _move.b #$37,0(a1) ; load obj37
    addq.b  #2,routine(a1)
    move.b  #8,y_radius(a1)
    move.b  #8,x_radius(a1)
    move.w  x_pos(a0),x_pos(a1)
    move.w  y_pos(a0),y_pos(a1)
    move.l  #Obj25_MapUnc_12382,mappings(a1)
    move.w  #$26BC,art_tile(a1)
    bsr.w   Adjust2PArtPointer2
    move.b  #$84,render_flags(a1)
    move.b  #3,priority(a1)
    move.b  #$47,collision_flags(a1)
    move.b  #8,width_pixels(a1)
    move.b  #-1,(Ring_spill_anim_counter).w
    tst.w   d4      ; DELETE ME
    bmi.s   loc_12132   ; DELETE ME
    move.w  d4,d0       ; DELETE ME
    bsr.w   JmpTo4_CalcSine ; DELETE ME
    move.w  d4,d2       ; DELETE ME
    lsr.w   #8,d2       ; DELETE ME
    asl.w   d2,d0       ; DELETE ME
    asl.w   d2,d1       ; DELETE ME
    move.w  d0,d2       ; DELETE ME
    move.w  d1,d3       ; DELETE ME
    addi.b  #$10,d4     ; DELETE ME
    bcc.s   loc_12132   ; DELETE ME
    subi.w  #$80,d4     ; DELETE ME
    bcc.s   loc_12132   ; DELETE ME
    move.w  #$288,d4    ; DELETE ME
 
loc_12132:          ; DELETE ME
    move.w  d2,x_vel(a1)    ; DELETE ME
    move.w  d3,y_vel(a1)    ; DELETE ME
    neg.w   d2      ; DELETE ME
    neg.w   d4      ; DELETE ME
    move.w  d2,(a4)+    ; DELETE ME ; Move d2 to a4 then increment a4 by a word
    move.w  d3,(a4)+    ; DELETE ME ; Move d3 to a4 then increment a4 by a word
    dbf d5,loc_120B2
See where it says "DELETE ME"? Do what it says. These are not needed anymore! This is what slows the ring loss down! This calculates the ring loss speeds and etc. Instead, we using our tables. Now, where you just deleted that table, insert this instead:

Code (ASM):
    move.w  (a3)+,x_vel(a1)     ; move the data contained in the array to the x velocity and increment the address in a3
    move.w  (a3)+,y_vel(a1)     ; move the data contained in the array to the y velocity and increment the address in a3
So, you have something looking like this:

Code (ASM):
loc_120BA:
    _move.b #$37,0(a1) ; load obj37
    addq.b  #2,routine(a1)
    move.b  #8,y_radius(a1)
    move.b  #8,x_radius(a1)
    move.w  x_pos(a0),x_pos(a1)
    move.w  y_pos(a0),y_pos(a1)
    move.l  #Obj25_MapUnc_12382,mappings(a1)
    move.w  #$26BC,art_tile(a1)
    bsr.w   Adjust2PArtPointer2 ; This is only needed for two player
    move.b  #$84,render_flags(a1)
    move.b  #3,priority(a1)
    move.b  #$47,collision_flags(a1)
    move.b  #8,width_pixels(a1)
    move.b  #-1,(Ring_spill_anim_counter).w
    move.w  (a3)+,x_vel(a1)     ; move the data contained in the array to the x velocity and increment the address in a3
    move.w  (a3)+,y_vel(a1)     ; move the data contained in the array to the y velocity and increment the address in a3
    dbf d5,loc_120B2
ALL DONE! Phew! Let me explain though. What it does now, is load a word from a3 (the table) and inserts it into x_vel, and then increment a3 by a word. Then it loads a word from a3 again (which has been incremented, so it won't be the same word) and inserts it into y_vel, then increment a3 again. Now one ring has it's speeds. It now knows how high to jump, how far to jump and which way to go, a hell of a lot quicker then doing all them calculations!

If you have used my tables I've supplied, then when out of water, you can only lose a max of 20 rings, and when in water, you can only lose a max of 8 rings, and it will act if like they're in water.


The ring loss process will now be much faster! And if in water, it shouldn't slow down (as much)


Any questions/comments/etc, reply!

Enjoy!


Credits

SpirituInsanum - For the idea and speed loss patterns guide (SSRG only). Also for helping me come up with this guide.
Me - For underwater scattered rings.



EDIT: Here is a ROM of Sonic 2 with this guide and my underwater guide combined.
