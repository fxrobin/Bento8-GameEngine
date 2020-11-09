* auteur: __sam__
* recopie 8 ko entre x et y

COPY8k
        pshs  d,x,y,u,dp,cc
        sts   copy8k3+2,pcr            ; sauve s

        leau  8192,x                   ; adresse de fin de recopie
        stu   copy8k2+2,pcr            ; met a jour test de fin

        ldd   ,x++                     ; 8192 = 21*390 + 2
        std   ,y++                     ; on s'occupe des 2 premiers

        leas  7,y                      ; mets a jour les pointeurs
        leau  ,x                       ; u=source s=dest
COPY8k1
        pulu  d,x,y,dp                 ; on lit 7 octets
        pshs  d,x,y,dp                 ; on ecrit 7 octets
        leas  14,s                     ; reajuste s => 12 + 12 + 5 = 29 cycles
        pulu  d,x,y,dp                 ;
        pshs  d,x,y,dp                 ;
        leas  14,s                     ;
        pulu  d,x,y,dp                 ;
        pshs  d,x,y,dp                 ;
        leas  14,s                     ; repete 3 fois = 21 octets recopies a toute vitesse (87 cycles)
COPY8k2
        cmpu  #0                       ; fin ?
        bne   copy8k1                  ; non => boucle 5 + 3 cycles
COPY8k3
        lds   #0                       ; recup s d'entree
        puls  d,x,y,dp,cc,pc
