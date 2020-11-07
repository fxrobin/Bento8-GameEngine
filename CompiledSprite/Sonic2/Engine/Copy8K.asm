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
   