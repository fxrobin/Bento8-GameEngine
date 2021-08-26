; RAM variables - Special stage
; TODO : split entre variables qui doivent etre globales (restent ici)
; et celles specifiques a l'objet (vont avec le code objet)

* ===========================================================================
* Object Constants
* ===========================================================================

nb_reserved_objects               equ 2
nb_dynamic_objects                equ 38
nb_level_objects                  equ 3
nb_objects                        equ 20 * max 64 total

* ---------------------------------------------------------------------------
* Object Status Table - OST
* ---------------------------------------------------------------------------

; Objects that will be run manually
Tilemap                       fill  0,object_size

Object_RAM 
Reserved_Object_RAM
Reserved_Object_RAM_End

Dynamic_Object_RAM            fill  0,nb_dynamic_objects*object_size
Dynamic_Object_RAM_End

LevelOnly_Object_RAM
LevelOnly_Object_RAM_End
Object_RAM_End
