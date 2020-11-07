********************************************************************************
* Copie Memoire de la zone donnee vers cartouche
* Cycles en fonction de l'implementation
* 256 octets (-128 a 127) x 64  boucles (80457 cy)
* 128 octets (-64  a 63)  x 128 boucles (81673 cy) Active
* 32  octets (-16  a 15)  x 512 boucles (87049 cy)
********************************************************************************
   
MEM_COPY_DATA_TO_CART
   STS MEM_COPY_DATA_TO_CART_S+2  * sauvegarde du pointeur de la pile systeme (auto-modification du code)
   LEAS ,U * remplacement de TFR U,S (Gain: 2c 0o)
MEM_COPY_DATA_TO_CART_LOOP
   PULS	D,X,U	
   STD	-64,Y
   STX	-62,Y
   STU	-60,Y
   PULS	D,X,U	
   STD	-58,Y
   STX	-56,Y
   STU	-54,Y
   PULS	D,X,U	
   STD	-52,Y
   STX	-50,Y
   STU	-48,Y
   PULS	D,X,U	
   STD	-46,Y
   STX	-44,Y
   STU	-42,Y
   PULS	D,X,U	
   STD	-40,Y
   STX	-38,Y
   STU	-36,Y
   PULS	D,X,U	
   STD	-34,Y
   STX	-32,Y
   STU	-30,Y
   PULS	D,X,U	
   STD	-28,Y
   STX	-26,Y
   STU	-24,Y
   PULS	D,X,U	
   STD	-22,Y
   STX	-20,Y
   STU	-18,Y
   PULS	D,X,U	
   STD	-16,Y
   STX	-14,Y
   STU	-12,Y
   PULS	D,X,U	
   STD	-10,Y
   STX	-8,Y
   STU	-6,Y
   PULS	D,X,U	
   STD	-4,Y
   STX	-2,Y
   STU	,Y
   PULS	D,X,U	
   STD	2,Y
   STX	4,Y
   STU	6,Y
   PULS	D,X,U	
   STD	8,Y
   STX	10,Y
   STU	12,Y
   PULS	D,X,U	
   STD	14,Y
   STX	16,Y
   STU	18,Y
   PULS	D,X,U	
   STD	20,Y
   STX	22,Y
   STU	24,Y
   PULS	D,X,U	
   STD	26,Y
   STX	28,Y
   STU	30,Y
   PULS	D,X,U	
   STD	32,Y
   STX	34,Y
   STU	36,Y
   PULS	D,X,U	
   STD	38,Y
   STX	40,Y
   STU	42,Y
   PULS	D,X,U	
   STD	44,Y
   STX	46,Y
   STU	48,Y
   PULS	D,X,U	
   STD	50,Y
   STX	52,Y
   STU	54,Y
   PULS	D,X,U	
   STD	56,Y
   STX	58,Y
   STU	60,Y
   PULS	D	
   STD	62,Y
   LEAY 128,Y
MEM_COPY_DATA_TO_CART_E
   CMPY    #$00C0
   LBNE    MEM_COPY_DATA_TO_CART_LOOP
MEM_COPY_DATA_TO_CART_S
   LDS     #$0000    * Rechargement du pointeur de la pile systeme
   RTS

********************************************************************************
* Effacement memoire Cartouche (27000 cy)
********************************************************************************

* TODO �tude utilisation CC

CLR_CART
    PSHS U,DP
    STS CLR_CART_3+2
    LDS #$4000
    LDU #$0C0C
    LDY #$0C0C
    LDX #$0C0C
    LDD #$0C0C
    TFR A,DP
CLR_CART_2
    PSHS U,Y,X,DP,B,A
    PSHS U,Y,X,DP,B,A
    PSHS U,Y,X,DP,B,A
    PSHS U,Y,X,DP,B,A
    PSHS U,Y,X,DP,B,A
    PSHS U,Y,X,DP,B,A
    PSHS U,Y,X,DP,B,A
    PSHS U,Y,X,DP,B,A
    PSHS U,Y,X,DP,B,A
    PSHS U,Y,X,DP,B,A
    CMPS #$0004
    BNE CLR_CART_2
    PSHS U,Y
CLR_CART_3
    LDS #$0000
    PULS DP,U,PC * Ajout du PC au PULS pour economiser le RTS (Gain: 3c 1o)
    

* copie la valeur de D entre X et X+8191
FILL8K:
   PSHS D,X,Y,U,CC
   ORCC #$50          ; pas d'interruptions ici
   STS  FILL8k3+2,PCR ; sauve S
   LEAS 8192,X        ; fait pointer S en fin des 8ko
   STX  lblCMP+2,PCR  ; met à jour adresse de fin
   TFR  D,X           ; copie D en X
   LEAY ,X            ; copie X en Y
   LEAU ,X            ; copie X en U. Maintenant X=Y=U=D
FILL8k1
   PSHS  D,X,Y,U
   PSHS  D,X,Y,U
   PSHS  D,X,Y,U
   PSHS  D,X,Y,U
   PSHS  D,X,Y,U
   PSHS  D,X,Y,U
   PSHS  D,X,Y,U
   PSHS  D,X,Y,U      ; on écrit 8*8=64 octets à toute vitesse (104 cycles)
FILL8k2               
   CMPS  #0           ; dest de fin ?
   BNE   FILL8k1      ; non => on repart our 64 octets de plus
FILL8k3               
   LDS #0             ; recp S d'entrée puis retour à l'appellant
   PULS D,X,Y,U,CC,PC

* Recopie 8 ko entre X et Y   
COPY8k
   PSHS D,X,Y,U,DP,CC
   ORCC #$50          ; pas d'interruptiuons
   STS  COPY8k3+2,PCR ; sauve S

   LEAU 8192,X        ; adresse de fin de recopie
   STU  COPY8k2+2,PCR ; met a jour test de fin
   
   LDD  ,X++          ; 8192 = 21*390 + 2
   STD  ,Y++          ; on s'occupe des 2 premiers
   
   LEAS 7,Y           ; mets à jour les pointeurs
   LEAU ,X            ; U=source S=dest
COPY8k1
   PULU D,X,Y,DP      ; on lit 7 octets
   PSHS D,X,Y,DP      ; on écrit 7 octets
   LEAS 14,S          ; réajuste S => 12 + 12 + 5 = 29 cycles
   PULU D,X,Y,DP      ;
   PSHS D,X,Y,DP      ;
   LEAS 14,S          ;
   PULU D,X,Y,DP      ;
   PSHS D,X,Y,DP      ;
   LEAS 14,S          ; repété 3 fois = 21 octets recopiés à toute vitesse (87 cycles)
COPY8k2
   CMPU #0            ; fin ?
   BNE  COPY8k1       ; non => boucle 5 + 3 cycles
COPY8k3
   LDS  #0            ; recup S d'entrée
   PULS D,X,Y,DP,CC,PC