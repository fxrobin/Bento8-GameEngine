# ******************************************************************************
# Définition d'un objet
# ---------------------
# Un objet est défini:
#    - par un code de comportement
#    - par un ensemble d'images converties en code (optionnel)
#    - par un ensemble d'animations (optionnel)
#
# code:
#    param1: code source du comportement de l'objet
#    param2 optionnel: binary will be loaded and executed in RAM (RAM)
#
# sprite:
#    param1: image PNG de type couleurs indexées 8Bits, Index de palette : Transparence=0, couleurs=1-16
#    param2: valeurs séparée par des virgules, plusieurs valeurs possibles
#            NB0  : no flip, background backup / draw / erase compilated sprite, no x offset
#            ND0  : no flip, draw compilated sprite, no x offset
#            NB1  : no flip, background backup / draw / erase compilated sprite, 1px x offset
#            ND1  : no flip, draw compilated sprite, 1px x offset
#            XB0  : x flip, background backup / draw / erase compilated sprite, no x offset 
#            XD0  : x flip, draw compilated sprite, no x offset 
#            XB1  : x flip, background backup / draw / erase compilated sprite, 1px x offset 
#            XD1  : x flip, draw compilated sprite, 1px x offset 
#            YB0  : y flip, background backup / draw / erase compilated sprite, no x offset 
#            YD0  : y flip, draw compilated sprite, no x offset 
#            YB1  : y flip, background backup / draw / erase compilated sprite, 1px x offset 
#            YD1  : y flip, draw compilated sprite, 1px x offset 
#            XYB0 : xy flip, background backup / draw / erase compilated sprite, no x offset 
#            XYD0 : xy flip, draw compilated sprite, no x offset 
#            XYB1 : xy flip, background backup / draw / erase compilated sprite, 1px x offset 
#            XYD1 : xy flip, draw compilated sprite, 1px x offset 
#    param3 optionnel: binary will be loaded and executed in RAM (RAM)
#
# animation:
#    param1: durée en frame de chaque image de l'animation (0=1 frame, 1=2 frames, ...)
#    param2: alias de la planche d'image
#    ...
#    param3: Action de fin (_resetAnim, _goBackNFrames, _goToAnimation, _nextRoutine, _resetAnimAndSubRoutine, _nextSubRoutine)
#    param4: Optionnel: nombre de frames (si param3=_goBackNFrames) ou identifiant d'animation (si param3=_goToAnimation)
#
# ******************************************************************************