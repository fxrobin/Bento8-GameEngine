********************************************************************************
* Gestion des modes de jeu (TO8 Thomson) - Benoit Rousseau 07/11/2020
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
        INCLUD CONSTANT
        INCLUD GLOBALS
        org $A000

* ==============================================================================
* GameModeEngineLoader
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

* Copie en page 0a des donnees du mode a charger (adaptation du code COPY8k de __sam__)
* les groupes de 7 octets sont recopiees a l'envers, on termine par l'ecriture
* en page 1 des donnees 0000-0100 puis derniere ligne 7x$FF
************************************************************            
        sts   CopyCode3+2              ; sauve s
        lda   current_game_mode
        ldx   GameModesArray
        ldu   a,x++                    ; u=source
        lds   a,x++                    ; s=longueur des donnees
        ldy   a,x                      ; adresse de fin de lecture de la source
        sty   CopyData2+2              ; met a jour test de fin
        leas  current_game_mode_data,s ; s=dest
CopyData1
        pulu  d,x,y,dp                 ; on lit 7 octets
        pshs  d,x,y,dp                 ; on ecrit 7 octets
CopyData2
        cmpu  #0                       ; fin ?
        bne   CopyData1                ; non => boucle 5 + 3 cycles

* Copie en page 0a du code Game Mode Engine
* les groupes de 7 octets sont recopiees a l'envers, le builder va inverser
* les donnees a l'avance on gagne un leas dans la boucle.
* le builder ajoute des donnees pour que le code soit un multiple de 7 octets
************************************************************     
        ldu   #GameModeEngineBin       * source
CopyCode1
        pulu  d,x,y,dp                 ; on lit 7 octets
        pshs  d,x,y,dp                 ; on ecrit 7 octets
CopyCode2
        cmps  #$4000                   ; fin ?
        bne   CopyCode1                ; non => boucle 5 + 3 cycles
CopyCode3
        lds   #0                       ; recup s d'entree
        puls  dp
        
* Execution du Game Mode Engine en page 0a
************************************************************         
        jmp   $4000      

* ==============================================================================
* GameModeEngine
* ==============================================================================
GameModeEngineBin
        INCLUD GMENGINE
        INCLUD GMEDATA


(include)CONSTANT
* ===========================================================================
* TO8 Registers
* ===========================================================================

dk_lecteur           equ   $6049
dk_piste             equ   $604A
dk_secteur           equ   $604C
dk_destination       equ   $604F

* ===========================================================================
* Physics Constants
* ===========================================================================

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
			                  
id                            equ $00 ; object ID ($00: free slot, $01: Object1, ...).
render_flags                  equ $02 ; bitfield
x_pos                         equ $03 ; and $04 ... some objects use subpixel as well when extra precision is required (see ObjectMove)
x_sub                         equ $05 ; subpixel ; doit suivre x_pos, second octet supprime car inutile en 6809
y_pos                         equ $05 ; and $06 ... some objects use subpixel as well when extra precision is required
y_sub                         equ $07 ; subpixel ; doit suivre y_pos, second octet supprime car inutile en 6809
x_pixel                       equ x_pos
y_pixel                       equ x_pos+2
priority                      equ $08 ; $09 ; $00 priority 0 (front), $80 priority 1, ..., $380 priority 7
width_pixels                  equ $0A
x_vel                         equ $0B ; and $0C ; horizontal velocity
y_vel                         equ $0D ; and $0E ; vertical velocity
y_radius                      equ $0F ; collision height / 2
x_radius                      equ $10 ; collision width / 2
anim                          equ $12 ; equ $13 ; address of the current animation script
prev_anim                     equ $13 ; equ $14 ; address of the previous animation script. This is used to detect external changes to the current animation.
anim_frame_duration           equ $14 ; duration of each image in animation script (anim), range: 00-7F (0-127), 0 means display only during one frame
anim_frame                    equ $11 ; index of current image in animation script (anim)
mapping_frame                 equ $0B ; $0C ; value read at current animation script index (anim_frame), is an address that point to sprite compiled draw and erase code
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

(include)GLOBALS
* Generated Code
current_game_mode_data equ $41B2


(include)GMENGINE

        fcb   $34
        fcb   $7F
        fcb   $1F
        fcb   $50
        fcb   $1F
        fcb   $8B
        fcb   $31
        fcb   $8D
        fcb   $00
        fcb   $A9
        fcb   $5F
        fcb   $D7
        fcb   $8D
        fcb   $4F
        fcb   $34
        fcb   $06
        fcb   $C5
        fcb   $0F
        fcb   $26
        fcb   $03
        fcb   $8E
        fcb   $00
        fcb   $01
        fcb   $C6
        fcb   $04
        fcb   $8D
        fcb   $6D
        fcb   $E7
        fcb   $A0
        fcb   $53
        fcb   $69
        fcb   $E4
        fcb   $49
        fcb   $5C
        fcb   $2B
        fcb   $FA
        fcb   $E6
        fcb   $E4
        fcb   $AF
        fcb   $A1
        fcb   $30
        fcb   $8B
        fcb   $35
        fcb   $06
        fcb   $5C
        fcb   $C1
        fcb   $34
        fcb   $26
        fcb   $DC
        fcb   $10
        fcb   $AE
        fcb   $66
        fcb   $C6
        fcb   $01
        fcb   $8D
        fcb   $50
        fcb   $26
        fcb   $15
        fcb   $D7
        fcb   $45
        fcb   $8C
        fcb   $0C
        fcb   $45
        fcb   $5C
        fcb   $8D
        fcb   $46
        fcb   $27
        fcb   $F9
        fcb   $C6
        fcb   $00
        fcb   $C1
        fcb   $10
        fcb   $27
        fcb   $37
        fcb   $25
        fcb   $0F
        fcb   $5A
        fcb   $8D
        fcb   $39
        fcb   $1F
        fcb   $01
        fcb   $A6
        fcb   $C2
        fcb   $A7
        fcb   $A2
        fcb   $30
        fcb   $1F
        fcb   $26
        fcb   $F8
        fcb   $20
        fcb   $D9
        fcb   $8D
        fcb   $44
        fcb   $34
        fcb   $06
        fcb   $30
        fcb   $8C
        fcb   $4B
        fcb   $10
        fcb   $83
        fcb   $00
        fcb   $03
        fcb   $24
        fcb   $01
        fcb   $3A
        fcb   $8D
        fcb   $1B
        fcb   $EB
        fcb   $03
        fcb   $8D
        fcb   $32
        fcb   $DD
        fcb   $77
        fcb   $35
        fcb   $10
        fcb   $31
        fcb   $3F
        fcb   $A6
        fcb   $A9
        fcb   $12
        fcb   $34
        fcb   $A7
        fcb   $A4
        fcb   $30
        fcb   $1F
        fcb   $26
        fcb   $F4
        fcb   $20
        fcb   $B3
        fcb   $10
        fcb   $AF
        fcb   $66
        fcb   $35
        fcb   $FF
        fcb   $E6
        fcb   $84
        fcb   $6F
        fcb   $E2
        fcb   $6F
        fcb   $E2
        fcb   $86
        fcb   $12
        fcb   $20
        fcb   $09
        fcb   $A6
        fcb   $C2
        fcb   $46
        fcb   $27
        fcb   $FB
        fcb   $69
        fcb   $61
        fcb   $69
        fcb   $E4
        fcb   $5A
        fcb   $2A
        fcb   $F6
        fcb   $97
        fcb   $8D
        fcb   $EC
        fcb   $E1
        fcb   $39
        fcb   $30
        fcb   $8D
        fcb   $00
        fcb   $0E
        fcb   $3A
        fcb   $58
        fcb   $3A
        fcb   $8D
        fcb   $DC
        fcb   $E3
        fcb   $01
        fcb   $39
        fcb   $04
        fcb   $02
        fcb   $04
        fcb   $10
        fcb   $30
        fcb   $20
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $CE
        fcb   $41
        fcb   $B2
        fcb   $34
        fcb   $40
        fcb   $86
        fcb   $60
        fcb   $1F
        fcb   $8B
        fcb   $E6
        fcb   $C0
        fcb   $1D
        fcb   $84
        fcb   $01
        fcb   $C4
        fcb   $80
        fcb   $97
        fcb   $49
        fcb   $86
        fcb   $00
        fcb   $DD
        fcb   $4A
        fcb   $C6
        fcb   $00
        fcb   $DD
        fcb   $4F
        fcb   $EC
        fcb   $C1
        fcb   $2A
        fcb   $02
        fcb   $0E
        fcb   $00
        fcb   $97
        fcb   $4C
        fcb   $F7
        fcb   $41
        fcb   $99
        fcb   $37
        fcb   $26
        fcb   $B7
        fcb   $41
        fcb   $9F
        fcb   $F7
        fcb   $41
        fcb   $A2
        fcb   $34
        fcb   $40
        fcb   $86
        fcb   $02
        fcb   $97
        fcb   $48
        fcb   $BD
        fcb   $E8
        fcb   $2A
        fcb   $0C
        fcb   $4C
        fcb   $96
        fcb   $4C
        fcb   $81
        fcb   $10
        fcb   $23
        fcb   $06
        fcb   $86
        fcb   $01
        fcb   $97
        fcb   $4C
        fcb   $0C
        fcb   $4B
        fcb   $0C
        fcb   $4F
        fcb   $DE
        fcb   $4F
        fcb   $11
        fcb   $83
        fcb   $00
        fcb   $00
        fcb   $23
        fcb   $E5
        fcb   $33
        fcb   $C9
        fcb   $FF
        fcb   $00
        fcb   $86
        fcb   $00
        fcb   $B7
        fcb   $E7
        fcb   $E5
        fcb   $BD
        fcb   $40
        fcb   $00
        fcb   $35
        fcb   $40
        fcb   $20
        fcb   $A7
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00
        fcb   $00

(include)GMEDATA
* Generated Code

gm_TITLESCR equ $00
current_game_mode
        fcb   gm_TITLESCR
gm_data_TITLESCR
        fcb   $FF,$FF,$FF,$FF,$FF,$FF,$FF
gm_dataEnd
GameModesArray
        fdb   gm_data_TITLESCR,gm_dataEnd-gm_data_TITLESCR