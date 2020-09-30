	ORCC #$50
	LDS  #$60CC
	lda    #*<-8    
	tfr    a,dp     
	ldu    #biba    
	leay   ,u       
	clrb            
	stb    <bitbuf+1
nxt	clra            
	pshs   a,b      
	bitb   #$0f     
	bne    skp      
	ldx    #$0001   
skp	ldb    #4       
	bsr    getbits  
	stb    ,u+      
	comb            
	roll   rol    ,s       
	rola            
	incb            
	bmi    roll     
	ldb    ,s       
	stx    ,u++     
	leax   d,x      
	puls   a,b      
	incb            
	cmpb   #52      
	bne    nxt      
go     ldu    #DEB+LEN 
mloop  ldb    #1       
	bsr    getbits  
	bne    cpy      
	stb    <idx+1   
	fcb    $8c      
rbl    inc    <idx+1   
	incb            
	bsr    getbits  
	beq    rbl      
idx    ldb    #$00     
	cmpb   #$10     
	lbeq   EXE      
	blo    coffs    
	decb            
	bsr    getbits  
cpy    tfr    d,x      
cpyl   lda    ,-y      
	sta    ,-u      
	leax   -1,x     
	bne    cpyl     
	bra    mloop    
coffs  bsr    cook     
	pshs   d        
	ldx    #tab1    
	cmpd   #$03     
	bhs    scof     
	abx             
scof   bsr    getbix   
	addb   3,x      
	bsr    cook     
	std    <offs+2  
	puls   x        
cpy2   leau   -1,u     
offs   lda    $5555,u  
	sta    ,u       
	leax   -1,x     
	bne    cpy2     
	bra    mloop    
getbix ldb    ,x       
getbits clr   ,-s      
	clr    ,-s      
bitbuf lda    #$55     
	bra    get3     
get1   lda    ,-y      
get2   rora            
	beq    get1     
	rol    1,s      
	rol    ,s       
get3   decb            
	bpl    get2     
	sta    <bitbuf+1
	ldd    ,s++     
	rts             
cook   ldx    #biba    
	abx             
	aslb            
	abx             
	bsr    getbix   
	addd   1,x      
	rts             
tab1   fcb    4,2,4    
	fcb    16,48,32 
incdat FILE.exo 
biba   rmb    156      