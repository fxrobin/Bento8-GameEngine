********************************************************************************
* Sprite_Table_Input - Table des Objets candidats à l'affichage
********************************************************************************

Sprite_Table_Input           rmb   sprite_table_nb_el*2*8+8
        
********************************************************************************  
* Ordre des niveaux de jeu
* Octet 1: Zone (niveau de jeu qui nécessite un chargement disquette)
* Octet 2: Acte (sous-niveau de jeu qui ne nécessite pas d'accès disquette)
********************************************************************************
LEVEL_ORDER                 * level.order=AIZ:0;AIZ:1;MZ:0
   FDB    $0000
   FDB    $0001
   FDB    $0100

********************************************************************************
* Sprite loading adress
********************************************************************************
* déclarer un tableau qui liste les infos ci dessous pour chaque sprite
obAniPage (ajout):  HERO_ANIMATION_PAG		FCB $00		* Animation courante - Pointeur Page actif
obAniDraw (ajout):  HERO_ANIMATION_DRW		FDB $0000	* Animation courante - Pointeur Dessin
obAniDel  (ajout):  HERO_ANIMATION_DEL		FDB $0000	* Animation courante - Pointeur Effacement

********************************************************************************
* collision response list
********************************************************************************
$E380	Number of objects currently in collision response list, multiplied by 2.
$E382-$E3FF	Collision response list. The format is one word per object, where the word is the starting address of the object's status table. Only objects in this list are processed by the collision response routine.

********************************************************************************
* Object respawn table
* --------------------
* Each object which is part of a level's object placement gets an entry in this
* table, and whenever the objects manager creates a new object, it sets bit 7 of
* the object's entry in the object respawn table. While bit 7 is set, the object
* will not be loaded again by the objects manager. The other seven bits of the
* entry are free for use by the object - for example, monitors set bit 0 to
* signify a broken monitor. Since every object which is part of the level's
* object placement has an entry in this table, the maximum number of objects
* any level can have in its object placement is 256
* Object.respawn_index: contient l'index sur cette table pour l'objet concerné
* Contenu des données respawn :
*
********************************************************************************
Object_Respawn_Table:
Obj_respawn_index:		rmb 2		; respawn table indices of the next objects when moving left or right for the first player
Obj_respawn_data:		rmb $100	; Maximum possible number of respawn entries that S2 can handle; for stock S2, $80 is enough
Obj_respawn_data_End:

; Gestion camera et taille des niveaux :

; The origin point (0,0) of a level is at its top left corner, so Camera_min_X_pos and Camera_max_X_pos correspond to the left and right level boundaries, where as Camera_min_Y_pos and Camera_max_Y_pos correspond to the top and bottom level boundaries, respectively. When a level is first loaded, these addresses are initialized to the values in the LevelSizes data structure:

;                       xstart  xend    ystart  yend    ; Level
LevelSizes:     dc.w    $1308,  $6000,  $0,     $390    ; AIZ1
;                dc.w    $0,     $4640,  $0,     $590    ; AIZ2
;                dc.w    $0,     $6000,  $0,     $1000   ; HCZ1
;                dc.w    $0,     $6000,  $0,     $1000   ; HCZ2
;                dc.w    $0,     $6000,  -$100,  $1000   ; MGZ1
;                dc.w    $0,     $6000,  $0,     $1000   ; MGZ2
;                dc.w    $0,     $6000,  $0,     $B20    ; CNZ1
;                dc.w    $0,     $6000,  $580,   $1000   ; CNZ2
;                dc.w    $0,     $2E60,  $0,     $B00    ; FBZ1
;                dc.w    $0,     $6000,  $0,     $B00    ; FBZ2

; It should be noted that all the camera positions stored in these addresses correspond to the pixel displayed at the top left corner of the screen. That means in order to figure out the actual level dimensions, you need to add the screen's width (320 pixels) to the max X position, and the screen's height (224 pixels) to the max Y position.
;                dc.w    $60,    $60,    $0,     $240    ; Gumball
;                dc.w    $60,    $60,    $0,     $240    ; Gumball
;                dc.w    $0,     $140,   $0,     $F00    ; Pachinko
;                dc.w    $0,     $140,   $0,     $F00    ; Pachinko
; For instance, in the pachinko/glowing spheres stage, although Camera_max_X_pos is set to $140 (320 pixels), since there are already 320 pixels horizontally on screen when Camera_X_pos is zero, scrolling to the right reveals another 320 pixels, for a total level width of 640 pixels. On the flipside, despite Camera_min_X_pos and Camera_max_X_pos both being set to $60, the gumball stage's width isn't actually zero. It just can't scroll horizontally. However, at the very least it's still as wide as the screen, so the actual level width is 320 pixels.
	
	


