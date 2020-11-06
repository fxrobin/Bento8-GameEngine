La structure des graphismes

Par exemple, vous pourrez toujours chercher les graphismes des sprites en m�moire, vous ne les y trouverez pas. Parce que tous ces graphismes ont �t� convertis en code. Chaque point de couleur est appliqu� "� la main" sans passer par une matrice. Par exemple, une partie du code de l'affichage du jetpack (X contient le pointeur �cran, B contient #$F0 (soit 240, pour passer les lignes)):

Code:
       ...
       SOUNDA
       abx   
       lda    #$f0
       anda   ,x
       adda   #$09
       sta    ,x
       lda    #$f0
       anda   40,x
       adda   #$04
       sta    40,x
       lda    #$44
       sta    -120,x
       sta    -80,x
       sta    -40,x
       abx   
       sta    80,x
       lda    #$a3
       ...

... ce qui est la fa�on la plus rapide d'afficher.


Les bruitages

Pour ce qui est du son 3 voies, il a bien �videmment fallu mixer les diff�rents sons qui doivent �tre g�n�r�s (2 banques de donn�es, l'une apparaissant en espace cartouche, l'autre en espace RAM et le code traitant en espace non commutable) et �crire le r�sultat en m�moire de page directe pour un acc�s plus rapide. Voici la macro (X contient le pointeur sur le son 1, Y le pointeur sur le son 2, U le pointeur sur le son 3 et DP permet d'acc�der au buffer de mixage):

Code:
SNDADD macro
       ldd    -SNDOFFS+\0,x Read voice 0
       addd   -SNDOFFS+\0,y Add voice 1
       addd   -SNDOFFS+\0,u Add voice 2
       std    <sndbuf+\0 Write buffer
       endm

Ainsi, les 156 octets n�cessaires pour g�n�rer le son pendant une frame sont remplis en 2156x2 cycles.


La lecture du joystick

Un probl�me de taille s'est aussi pos� : la lecture du joystick interf�rait avec la ligne du son, puisqu'utilisant les m�mes registres hardware. Il a fallu donc trouver une astuce pour lire le joystick sans provoquer de hoquet sonore. Je vous livre ici la routine utilis�e :

Code:
*---------------------------------------
* Get joystick parameters
*---------------------------------------
       ldx    #$e7cf  Joystick register
       ldy    #$e7cd  Joystick register
       ldu    #joydir-5 Joystick table
       brn    *       - tempo -
(info)
       SNDSA  sndbuf+19 Generate sound
       ldd    #$fbfc  ! Mute by CRA to
       anda   ,x      ! avoid sound when
       sta    ,x      ! $e7cd is written
       andb   ,y       ! Activate
       stb    ,y       ! joystick port
       ora    #$04    ! Disable mute by
       sta    ,x      ! CRA + joystick
       ldd    #$400f  !
       andb   >$e7cc  Read position
       ldb    b,u     Read orientation
       stb    <astrol+GAORIE1 Orient.
       anda   ,y      ! Read button
       eora   #$40    ! status
       sta    <joybtn Joystick button
       ldd    #$fb3f  ! Mute by CRA to
       anda   ,x      ! avoid sound when
       sta    ,x      ! $e7cd written
       stb    ,y      Full sound line
       ora    #$04    ! Disable mute by
       sta    ,x      ! CRA and sound



La collision entre sprites

Pour les tests de collision entre sprites, j'utilise ce genre de routine (qui est tr�s rapide et tr�s efficace), ici la routine pour la collision entre la fus�e et l'astronaute :

Code:
       ...
* Check if astronaut touched rocket
       ldd    <astrol+GYA  Read XY astronaut
AX0    set    3  Area right offset
AY0    set    3  Area top offset
AX1    set    3  Area left offset
AY1    set    3  Area bottom offset
AW     set    ASTW-AX0-AX1
AH     set    ASTH-AY0-AY1
BX0    set    4  Area right offset
BY0    set    14 Area top offset
BX1    set    4  Area left offset
BY1    set    4  Area bottom offset
BW     set    RKTW-BX0-BX1
BH     set    RKTH-BY0-BY1
       suba   #RKTY     -Y rocket
       subb   #RKTX     -X rocket
       adda   #AY0+AH-1-BY0  ! Compute
       addb   #AX0+AW-1-BX0  ! zones
       cmpa   #AH+BH-1  ! Skip if no
       bhs    clar3     ! vertical collision
       cmpb   #AW+BW-1   ! Skip if no
       bhs    clar4      ! horizontal collision
       ...

�videmment, cette routine n'est qu'une routine de collision entre rectangles et varie selon la nature des sprites. Les suba/subb en imm�diat sont g�n�ralement remplac�s par des adressages index�s ou directs quand les deux sprites sont mouvants, et ici le "suba #RKTY" est int�gr� � l'adda cons�cutif, mais j'ai d�velopp� un peu le code pour plus de clart�.


La collision avec les plateaux et les bords d'�cran

Pour les collisions avec les plateaux ou les bords d'�cran, j'utilise une routine sp�ciale (puisque les plateaux et les bords d'�crans sont immobiles) qui rep�re la collision en fonction de la direction prise par le sprite. Ici la collision des monstres avec les plateaux et les bords d'�cran (je n'ai conserv� que la routine sans mouvement et la routine pour la direction Est, mais les routines pour les autres directions sont du m�me acabit) :
Code:
*---------------------------------------
* Check ennemy/bar+screen collision
*---------------------------------------
ebar   fdb    nmebar  $00 NOMOVE
       fdb    eeebar  $02 E
       fdb    wwebar  $04 W
       fdb    nmebar  $06 (E-W)
       fdb    ssebar  $08 S
       fdb    seebar  $0A S-E
       fdb    swebar  $0C S-W
       fdb    nmebar  $0E (E-W-S)
       fdb    nnebar  $10 N
       fdb    neebar  $12 N-E
       fdb    nwebar  $14 N-W
*---------------------------------------
* Enemy/Bar collision (no move)
* XXX 46
nmebar equ    *
       mul            - tempo -
       mul            - tempo -
       mul            - tempo -
       leax   0,u     - tempo -
       ldd    #(ALIVE<8)+NOMOVE
       rts
(info)
*---------------------------------------
* Enemy/Bar collision (east)
* XXX 38
eeebar equ    *
       exg    a,a     - tempo -
       ldd    ,u      Read coords
(info)
* bar 1 ----------------------
       cmpb   #X0BAR1-ENEW
eb0    equ    *-1
       bne    eeeb0
       exg    a,a     - tempo -
       nop            - tempo -
       cmpa   #Y0BAR1-ENEH
eb1    equ    *-1
       bls    eeeb3
       cmpa   #Y1BAR1+1
eb2    equ    *-1
       bhs    eeeb4
       ldd    #(TOUCHED<8)+WEST
       rts
(info)
* bar 2 ----------------------
eeeb0  cmpb   #X0BAR2-ENEW
eb3    equ    *-1
       bne    eeeb1
       leax   0,x     - tempo -
       cmpa   #Y0BAR2-ENEH
eb4    equ    *-1
       bls    eeeb3
       cmpa   #Y1BAR2+1
eb5    equ    *-1
       bhs    eeeb4
       ldd    #(TOUCHED<8)+WEST
       rts
(info)
* bar 3 ----------------------
eeeb1  cmpb   #X0BAR3-ENEW
eb6    equ    *-1
       bne    eeeb2
       cmpa   #Y0BAR3-ENEH
eb7    equ    *-1
       bls    eeeb3
       cmpa   #Y1BAR3+1
eb8    equ    *-1
       bhs    eeeb4
       ldd    #(TOUCHED<8)+WEST
       rts
(info)
*--- Continue
eeeb2  leax   0,x     - tempo -
eeeb3  leax   0,x     - tempo -
eeeb4  ldd    #(ALIVE<8)+EAST
       rts
(info)

Toutes les valeurs marqu�es par une �tiquette eb? sont mises � jour pour chaque �cran de niveau.
