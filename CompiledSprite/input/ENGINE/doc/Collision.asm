Fix collisions with the lava collision maker object

The Bug:
The way object collisions work, it's impossible to collide with two objects at once unless the object itself does the collision checks. That's what we're going to do here.

The Fix:
We're going to be editing object 31, the lava collision maker. First locate the label Obj31_Init (loc_20E02):
Code (ASM):
; byte_20DFE:
Obj31_CollisionFlagsBySubtype:
    dc.b $96    ; 0
    dc.b $94    ; 1
    dc.b $95    ; 2
    dc.b   0    ; 3
; ===========================================================================
; loc_20E02:
Obj31_Init:
    addq.b  #2,routine(a0) ; => Obj31_Main
    moveq   #0,d0
    move.b  subtype(a0),d0
    move.b  Obj31_CollisionFlagsBySubtype(pc,d0.w),collision_flags(a0)  ; <-------
    move.l  #Obj31_MapUnc_20E6C,mappings(a0)
    tst.w   (Debug_placement_mode).w
    beq.s   +
    move.l  #Obj31_MapUnc_20E74,mappings(a0)
+
    move.w  #make_art_tile(ArtTile_ArtNem_Powerups,0,1),art_tile(a0)
    move.b  #$84,render_flags(a0)
    move.b  #$80,width_pixels(a0)
    move.b  #4,priority(a0)
    move.b  subtype(a0),mapping_frame(a0)
Now, we replace the data table Obj31_CollisionFlagsBySubtype and the line that uses it with the following:
Code (ASM):
Obj31_Widths:
    dc.b $20    ; 0
    dc.b $40    ; 1
    dc.b $80    ; 2
    dc.b   4    ; 3
; ===========================================================================
 
    (...)
    move.b  Obj31_Widths(pc,d0.w),x_radius(a0)
Next, we need to add our own collision check. Here's the routine, place it anywhere close to the object's code. I put it between Obj31_Main and the object's mappings.
Code (ASM):
Obj31_TestCollisions:
    lea (MainCharacter).w,a1
    bsr.s   +
    lea (Sidekick).w,a1
+
    ; test horizontal
    moveq   #0,d1
    move.b  x_radius(a0),d1
    ; left edge
    move.w  x_pos(a1),d0
    sub.w   x_pos(a0),d0
    add.w   d1,d0
    bmi.s   Obj31_NoCollision
    ; right edge
    add.w   d1,d1
    cmp.w   d1,d0
    bcc.s   Obj31_NoCollision
    ; test vertical
    moveq   #$20,d1 ; we assume a constant y_radius of 32 pixels
    add.b   y_radius(a1),d1
    ; top edge
    move.w  y_pos(a1),d0
    sub.w   y_pos(a0),d0
    add.w   d1,d0
    bmi.s   Obj31_NoCollision
    ; bottom edge
    add.w   d1,d1
    cmp.w   d1,d0
    bcc.s   Obj31_NoCollision
    ; hurt player
    move.l  a0,-(sp)    ; save object address
    exg a0,a1       ; switch object and player addresses
    jsr Touch_ChkHurt
    movea.l (sp)+,a0 ; load 0bj address
 
Obj31_NoCollision:
    rts
; ===========================================================================
Now we need the object to call this routine. Right after the label Obj31_Main, add this:
Code (ASM):
    tst.w   (Debug_placement_mode).w
    bne.s   +       ; skip collision checks if in object placement mode mode
    bsr.s   Obj31_TestCollisions
+
Done.

Now, I'm no expert on coding bounding box checks, so if someone can come up with a better collision checking routine that uses less cycles, post away. This does have the potential to slow the game down a little, so every little bit helps.
What really helps is s3k's collision checking routine. Instead of going through the entire object list, it only checks objects that add themselves to a specific list. This means objects that have no collisions or ones that do the checks themselves will be skipped.
The fix for the ARZ leaf makers should work the same way, but I'd need to check first to be sure.






-------------------------------------------------------------------------------------------------





Objects have a field called collision flags. This field controls both the size of an object's hitbox as well as how the collision is processed. If the collision flags are zero, there is no collision. Most objects have zero in their collision flags.

In S1/SCD/S2, this means a lot of time is spent going through the object slots checking collision flags, and skipping all those with zero collision flags (which includes those empty object slots). This is done twice in S2, for Sonic and for Tails, and consumes a few thousands of cycles per character per frame when all objects are skipped.

S3/S&K/S3&K have a buffer in RAM with the addresses of all objects that are touchable, with a count at the beginning of the buffer. Each object is responsible for adding itself to the list, and the list is "cleared" after the code for Sonic and Tails code has finished executing and before all other objects execute their own coffee; this is done by setting the number of objects in the list to zero. The collision code only checks objects on that list, which avoids uselessly processing a lot of objects.

The amount of cycles saved this way is spent by having shields also check projectile deflections against all objects in this list. Hyper Sonic's hyper dash, Hyper Knuckles' for into wall, and Super Tails' flickies also use the list for checking targets.




--------------------------------------------------------------------------------------------------



object/terrain collision: This is a superset of what I described in the above posts; I focused on characters, and other objects tend to do it a bit differently: generally, they don't care about terrain at all, and those that do only cast one or two sensor rays at most. Except for S1 and SCD, all other games have a lookup table in the function that locates the required tile for speeding up the collision checks. Relevant functions:
Find_Tile: lower level function which locates the tile at the input position. No object calls this directly.
FindFloor, Ring_FindFloor, FindWall: calls Find_Tile, potentially finds another tile further away, inspects collision from the tiles, and returns distance until/inside terrain. No objects call these directly.
Any other functions that call the above functions: these are directly called by objects, and they generally just use the distance returned.
object/object collision: These are platform and solid objects: objects you can stand on, push on (or be pushed by), or bump into them from below. Basically, objects where it matters which side you collided with, and which eject you out of their collision box. I am writing something this group of collisions, but I am still tabulating the information from the several games, and I am still thinking on how to make it digestible. SCD optimizes for size, and combines all object/object collision into one single function which checks the type of collision in the routine. The others tend to optimize for speed, and split off into different routines for different types of collision.
Relevant functions: SolidObject, SolidObject_Always, SlopedSolid, SolidObject45, PlatformObject, SlopedPlatform, PlatformObject2, PlatformObjectD5, etc.
object/object touch: This is a different kind of collision, which uses a different collision box, the hitbox. In a nutshell, any object which does not care the direction from which you collide with it, and which neither ejects you out of its collision box, nor carries you on top. Examples include badniks, rings in S1/SCD, all bumpers in S1/SCD, some bumpers in S2/S3/S&K/S3&K, attracted rings in S3/S&k/S3&K, etc. S3/S&K/S3&K have a subscription-based model: touchable objects add themselves to a list, and the characters check collision only with objects on the list. In S1/S2/SCD, on the other hand, check against every other object loaded. In all games, the check stops as soon as something is touched. Relevant function: TouchResponse.
object/ring touch: In S1/SCD, rings are objects, and just use object/object touch. In S2/S3/S&K/S3&K, rings have their own separate per-level data for their positions, and the games check collision of each character with all rings in a certain range. Relevant function: Touch_Rings.
object/special collision: S2/S3/S&K/S3&K also have routines for collision with special bumpers; I think some rocks in Lava Reef in S&K/S3&K are also not normal objects, but Neo/Tiddles probably know more. Relevant function: Check_CNZ_bumpers.

