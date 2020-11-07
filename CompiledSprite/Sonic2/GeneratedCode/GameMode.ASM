********************************************************************************
* Gestion des modes de jeu (TO8 Thomson) - Benoit Rousseau 07/10/2020
* ------------------------------------------------------------------------------
*
* Permet de gerer les differents etats/modes d'un jeu
* - introduction
* - ecran de titre
* - ecran d'options
* - niveaux de jeu
* - animation de fin
* - ...
* 
* A pour role de charger un etat memoire par rapport a une configuration
* Les donnees sont chargees depuis la disquette puis decompressees par exomizer
* ------------------------------------------------------------------------------
* 
* Chargement de la page 3 a l'ecran
* Chargement de la page 2 en zone 0000-3FFF
* Chargement de la page 0a en zone 4000-5FFF
* Copie en page 0a du moteur Game Mode et des donnees du mode a charger
* Execution du moteur Game Mode en page 0a
* Chargement des donnees du Mode depuis la disquette vers 0000-3FFF (buffer)
* Decompression et ecriture de la RAM en A000-DFFF (pages 5-31)
* Chargement du programme principal du nouveau Mode en page 1 a 6000
* (effectue en dernier car ecrase les registres moniteurs necessaires a la
* gestion disque)
* Re-initialisation du pointeur S a 9FFF
* Branchement en 6000
*
********************************************************************************

(main)GAMEMODE
        org $A000
        INCLUD CONSTANT

* ==============================================================================
* Boucle principale
* ==============================================================================
GameModeEngineLoader

* Chargement de la page 3 a l'ecran
***********************************************************
WaitVBL
        tst   $E7E7                    * le faisceau n'est pas dans l'ecran
        bpl   WaitVBL                  * tant que le bit est a 0 on boucle
WaitVBL_01
        tst   $E7E7                    * le faisceau est dans l'ecran
        bmi   WaitVBL_01               * tant que le bit est a 1 on boucle
SwapVideoPage
        ldb   #$C0                     * page 3, couleur de cadre 0
        stb   $E7DD                    * affiche la page a l'ecran
        
* Chargement de la page 2 en zone 0000-3FFF
***********************************************************
        ldb   #$62                     * changement page 2
        stb   $E7E6                    * visible dans l'espace cartouche
        
* Chargement de la page 0a en zone 4000-5FFF
***********************************************************
        ldb   $E7C3                    * charge l'id de la demi-Page 0 en espace ecran
        andb  #$FE                     * positionne bit0=0 pour page 0 RAMA
        stb   $E7C3                    * dans l'espace ecran

* Copie en page 0a du moteur Game Mode et des donnees du mode a charger
************************************************************     
        ldx   #GameModeEngine          * source
        ldy   #$4000                   * destination   
        jsr   COPY8k                   * copie
        
        jmp   $4000        
        
GameModeEngine

GameModeEngine_End
        rmb   $2000-(GameModeEngine_End-GameModeEngine),0
   
*        lda   game_mode
*        ldx   GameModesArray
*        ldu   a,x
        
*GameModesArray
*        fdb   gm_data_intro
*        fdb   gm_data_title_screen
*        fdb   gm_data_level
*        fdb   gm_data_ending_sequence 
        
*game_mode          fdb $00      
*gm_intro           equ $00
*gm_title_screen    equ $02
*gm_level           equ $04
*gm_ending_sequence equ $06
        
*gm_data_intro
*        fdb   $0000
        
*gm_data_title_screen
*        fdb   $0000
        
*gm_data_level
*        fdb   $0000
        
*gm_data_ending_sequence
*        fdb   $0000         
        


* ==============================================================================
* Routines
* ==============================================================================
        INCLUD COPY8K


(include)CONSTANT
* ---------------------------------------------------------------------------
* Physics Constants
* ---------------------------------------------------------------------------

gravity                       equ $38 ; Gravite: 56 sub-pixels par frame

* ===========================================================================
* Object Constants
* ===========================================================================

number_of_reserved_objects       equ 2
number_of_dynamic_objects        equ 45
number_of_level_objects          equ 3

* ---------------------------------------------------------------------------
* Object Status Table offsets
* ---------------------------------------------------------------------------

object_size                   equ $1F ; the size of an object
next_object                   equ object_size
			                  
id                            equ $00 ; and $01 object ID ($0000: free slot, $A000: Object1 code Adress, $B000: Object2 code Adress, ...).
render_flags                  equ $02 ; bitfield
x_pos                         equ $03 ; and $04 ... some objects use subpixel as well when extra precision is required (see ObjectMove)
x_sub                         equ $05 ; subpixel ; doit suivre x_pos, second octet supprime car inutile en 6809
y_pos                         equ $05 ; and $06 ... some objects use subpixel as well when extra precision is required
y_sub                         equ $07 ; subpixel ; doit suivre y_pos, second octet supprime car inutile en 6809
x_pixel                       equ x_pos
y_pixel                       equ x_pos+2
priority                      equ $08 ; $09 ; $00 priority 0 (front), $80 priority 1, ..., $380 priority 7
width_pixels                  equ $0A
mapping_frame                 equ $0B
x_vel                         equ $0B ; and $0C ; horizontal velocity
y_vel                         equ $0D ; and $0E ; vertical velocity
y_radius                      equ $0F ; collision height / 2
x_radius                      equ $10 ; collision width / 2
anim_frame                    equ $11
anim                          equ $12
prev_anim                     equ $13
anim_frame_duration           equ $14 ; range: 00-7F (0-127)
status                        equ $15 ; note: exact meaning depends on the object...
routine                       equ $16
routine_secondary             equ $17
objoff_01                     equ $18 ; variables specifiques aux objets
objoff_02                     equ $19
objoff_03                     equ $1A
objoff_04                     equ $1B
objoff_05                     equ $1C
collision_flags               equ $1D
subtype                       equ $1E

* ---------------------------------------------------------------------------
* render_flags bitfield variables
render_xmirror_mask           equ $01 ; bit 0 This is the horizontal mirror flag. If set, the object will be flipped on its horizontal axis.
render_ymirror_mask           equ $02 ; bit 1 This is the vertical mirror flag.
render_coordinate1_mask       equ $04 ; bit 2,3 These are the coordinate system. If 0, the object will be positioned by absolute screen coordinates. This is used for things like the HUD and menu options. If 1, the object will be positioned by the playfield coordinates, i.e. where it is in a level. If 2 or 3, the object will be aligned to the background somehow (perhaps this was used for those MZ UFOs).
render_coordinate2_mask       equ $08 ;
render_ycheckonscreen_mask    equ $10 ; bit 4 This is the assume height flag. The object will be drawn if it is vertically within x pixels of the screen where x is #$20 if this flag is clear or y-radius if it is set.
render_staticmappings_mask    equ $20 ; bit 5 This is the raw mappings flag. If set, just 5 bytes will be read from the object's mappings offset when the BuildSprites routine draws the object, and these will be interpreted in the normal manner to display a single Mega Drive sprite. This format is used for objects such as breakable wall fragments. If set, this indicates that the mappings pointer for this object points directly to the pieces data for this frame, and implies that the object consists of only one sprite piece.
render_subobjects_mask        equ $40 ; bit 6 If set, this indicates that the current object's status table also contains information about other child sprites which need to be drawn using the current object's mappings, and also signifies that certain bytes of its status table have different meanings
render_onscreen_mask          equ $80 ; bit 7 This is the on-screen flag. It will be set if the object is on-screen, and clear otherwise.

* ---------------------------------------------------------------------------
* status bitfield variables
status_leftfacing_mask        equ $01 ; bit 0 Object: X Orientation. Clear is left and set is right.                | Sonic: Orientation. Set is left and clear is right.
status_inair_mask             equ $02 ; bit 1 Object: Y Orientation. Clear is right-side up, and set is upside-down | Sonic: Set if Sonic is in the air
status_spinning_mask          equ $04 ; bit 2 Object: Unknown or unused.                                            | Sonic: Set if jumping or rolling.
status_onobject_mask          equ $08 ; bit 3 Object: Set if Sonic is standing on this object.                      | Sonic: Set if Sonic isn't on the ground but shouldn't fall. (Usually when he is on a object that should stop him falling, like a platform or a bridge.)
status_rolljumping_mask       equ $10 ; bit 4 Object: Set if Tails is standing on this object.                      | Sonic: Set if Sonic is jumping after rolling on the ground. (Used mainly to lock horizontal controls.)
status_pushing_mask           equ $20 ; bit 5 Object: Set if Sonic is pushing on this object.                       | Sonic: Set if pushing something.
status_underwater_mask        equ $40 ; bit 6 Object: Set if Tails is pushing on this object.                       | Sonic: Set if underwater.
status_tobedeleted_mask       equ $80 ; bit 7 Object: Set if Object should be deleted from screen and from object list

* ---------------------------------------------------------------------------
* status_secondary bitfield variables
status_sec_hasShield_mask     equ $01 ; bit 0 Sonic: Shield flag. Can be set to create the effect of having a shield, though the graphics will not be loaded.
status_sec_isInvincible_mask  equ $02 ; bit 1 Sonic: Sets invincibility. Behaves like you would expect. No graphics are loaded when set manually.
status_sec_hasSpeedShoes_mask equ $04 ; bit 2 Sonic: Speed Shoes flag. (Doesn't have visible effect in game)
status_sec_3_mask             equ $08 ; bit 3 Sonic: Unused
status_sec_4_mask             equ $10 ; bit 4 Sonic: Unused
status_sec_5_mask             equ $20 ; bit 5 Sonic: Unused
status_sec_6_mask             equ $40 ; bit 6 Sonic: Unused
status_sec_isSliding_mask     equ $80 ; bit 7 Sonic: Sets infinite inertia. While Sonic is in collision with the ground, he will continue moving in the same direction and at the same speed that he was moving before (even if that speed was zero). You can still jump and control him in midair. (A few movement routines are skipped if it's set, which produces this effect).

(include)COPY8K
* Recopie 8 ko entre X et Y   
COPY8k
   PSHS D,X,Y,U,DP,CC
   STS  COPY8k3+2,PCR ; sauve S

   LEAU 8192,X        ; adresse de fin de recopie
   STU  COPY8k2+2,PCR ; met a jour test de fin
   
   LDD  ,X++          ; 8192 = 21*390 + 2
   STD  ,Y++          ; on s'occupe des 2 premiers
   
   LEAS 7,Y           ; mets a jour les pointeurs
   LEAU ,X            ; U=source S=dest
COPY8k1
   PULU D,X,Y,DP      ; on lit 7 octets
   PSHS D,X,Y,DP      ; on ecrit 7 octets
   LEAS 14,S          ; reajuste S => 12 + 12 + 5 = 29 cycles
   PULU D,X,Y,DP      ;
   PSHS D,X,Y,DP      ;
   LEAS 14,S          ;
   PULU D,X,Y,DP      ;
   PSHS D,X,Y,DP      ;
   LEAS 14,S          ; repete 3 fois = 21 octets recopies a toute vitesse (87 cycles)
COPY8k2
   CMPU #0            ; fin ?
   BNE  COPY8k1       ; non => boucle 5 + 3 cycles
COPY8k3
   LDS  #0            ; recup S d'entree
   PULS D,X,Y,DP,CC,PC
   