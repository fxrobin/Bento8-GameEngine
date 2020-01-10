********************************************************************************
* Copie Memoire de la zone donnee vers cartouche
* Cycles en fonction de l'implementation
* 256 octets (-128 a 127) x 64  boucles (80457 cy)
* 128 octets (-64  a 63)  x 128 boucles (81673 cy) Active
* 32  octets (-16  a 15)  x 512 boucles (87049 cy)
********************************************************************************
*MEM_COPY_DATA_TO_CART
*   PULS X,U	
*   STX	-128,Y
*   STU	-126,Y
*   PULS	D,X,U	
*   STD	-124,Y
*   STX	-122,Y
*   STU	-120,Y
*   PULS	D,X,U	
*   STD	-118,Y
*   STX	-116,Y
*   STU	-114,Y
*   PULS	D,X,U	
*   STD	-112,Y
*   STX	-110,Y
*   STU	-108,Y
*   PULS	D,X,U	
*   STD	-106,Y
*   STX	-104,Y
*   STU	-102,Y
*   PULS	D,X,U	
*   STD	-100,Y
*   STX	-98,Y
*   STU	-96,Y
*   PULS	D,X,U	
*   STD	-94,Y
*   STX	-92,Y
*   STU	-90,Y
*   PULS	D,X,U	
*   STD	-88,Y
*   STX	-86,Y
*   STU	-84,Y
*   PULS	D,X,U	
*   STD	-82,Y
*   STX	-80,Y
*   STU	-78,Y
*   PULS	D,X,U	
*   STD	-76,Y
*   STX	-74,Y
*   STU	-72,Y
*   PULS	D,X,U	
*   STD	-70,Y
*   STX	-68,Y
*   STU	-66,Y
*   PULS	D,X,U	
*   STD	-64,Y
*   STX	-62,Y
*   STU	-60,Y
*   PULS	D,X,U	
*   STD	-58,Y
*   STX	-56,Y
*   STU	-54,Y
*   PULS	D,X,U	
*   STD	-52,Y
*   STX	-50,Y
*   STU	-48,Y
*   PULS	D,X,U	
*   STD	-46,Y
*   STX	-44,Y
*   STU	-42,Y
*   PULS	D,X,U	
*   STD	-40,Y
*   STX	-38,Y
*   STU	-36,Y
*   PULS	D,X,U	
*   STD	-34,Y
*   STX	-32,Y
*   STU	-30,Y
*   PULS	D,X,U	
*   STD	-28,Y
*   STX	-26,Y
*   STU	-24,Y
*   PULS	D,X,U	
*   STD	-22,Y
*   STX	-20,Y
*   STU	-18,Y
*   PULS	D,X,U	
*   STD	-16,Y
*   STX	-14,Y
*   STU	-12,Y
*   PULS	D,X,U	
*   STD	-10,Y
*   STX	-8,Y
*   STU	-6,Y
*   PULS	D,X,U	
*   STD	-4,Y
*   STX	-2,Y
*   STU	,Y
*   PULS	D,X,U	
*   STD	2,Y
*   STX	4,Y
*   STU	6,Y
*   PULS	D,X,U	
*   STD	8,Y
*   STX	10,Y
*   STU	12,Y
*   PULS	D,X,U	
*   STD	14,Y
*   STX	16,Y
*   STU	18,Y
*   PULS	D,X,U	
*   STD	20,Y
*   STX	22,Y
*   STU	24,Y
*   PULS	D,X,U	
*   STD	26,Y
*   STX	28,Y
*   STU	30,Y
*   PULS	D,X,U	
*   STD	32,Y
*   STX	34,Y
*   STU	36,Y
*   PULS	D,X,U	
*   STD	38,Y
*   STX	40,Y
*   STU	42,Y
*   PULS	D,X,U	
*   STD	44,Y
*   STX	46,Y
*   STU	48,Y
*   PULS	D,X,U	
*   STD	50,Y
*   STX	52,Y
*   STU	54,Y
*   PULS	D,X,U	
*   STD	56,Y
*   STX	58,Y
*   STU	60,Y
*   PULS	D,X,U	
*   STD	62,Y
*   STX	64,Y
*   STU	66,Y
*   PULS	D,X,U	
*   STD	68,Y
*   STX	70,Y
*   STU	72,Y
*   PULS	D,X,U	
*   STD	74,Y
*   STX	76,Y
*   STU	78,Y
*   PULS	D,X,U	
*   STD	80,Y
*   STX	82,Y
*   STU	84,Y
*   PULS	D,X,U	
*   STD	86,Y
*   STX	88,Y
*   STU	90,Y
*   PULS	D,X,U	
*   STD	92,Y
*   STX	94,Y
*   STU	96,Y
*   PULS	D,X,U	
*   STD	98,Y
*   STX	100,Y
*   STU	102,Y
*   PULS	D,X,U	
*   STD	104,Y
*   STX	106,Y
*   STU	108,Y
*   PULS	D,X,U	
*   STD	110,Y
*   STX	112,Y
*   STU	114,Y
*   PULS	D,X,U	
*   STD	116,Y
*   STX	118,Y
*   STU	120,Y
*   PULS	D,X,U	
*   STD	122,Y
*   STX	124,Y
*   STU	126,Y
*   LEAY 256,Y
*MEM_COPY_DATA_TO_CART_E
*   CMPY    #$0180
*   LBNE     MEM_COPY_DATA_TO_CART
*MEM_COPY_DATA_TO_CART_S
*   LDS     #$0000    * Rechargement du pointeur de la pile systeme
*   RTS
   
MEM_COPY_DATA_TO_CART
   STS MEM_COPY_DATA_TO_CART_S+2  * sauvegarde du pointeur de la pile systeme (auto-modification du code)
   TFR U,S
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

*MEM_COPY_DATA_TO_CART
*   PULS    D,X,U
*   STD     -16,Y
*   STX     -14,Y
*   STU     -12,Y
*   PULS    D,X,U
*   STD     -10,Y
*   STX     -8,Y
*   STU     -6,Y
*   PULS    D,X,U
*   STD     -4,Y
*   STX     -2,Y
*   STU     ,Y
*   PULS    D,X,U
*   STD     2,Y
*   STX     4,Y
*   STU     6,Y
*   PULS    D,X
*   STD     8,Y
*   STX     10,Y
*   PULS    D,X
*   STD     12,Y
*   STX     14,Y
*   LEAY    32,Y
*MEM_COPY_DATA_TO_CART_E
*   CMPY    #$0030
*   BNE     MEM_COPY_DATA_TO_CART
*MEM_COPY_DATA_TO_CART_S
*   LDS     #$0000    * Rechargement du pointeur de la pile systeme
*   RTS