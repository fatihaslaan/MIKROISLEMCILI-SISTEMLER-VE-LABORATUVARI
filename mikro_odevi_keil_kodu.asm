ORG 0000H
	SJMP YAZDIR
ORG 0030H
YAZDIR:	
	SETB P1.0
	BUTTONLOOP:JB P1.0,BUTTONLOOP ;buttona basilmiyorken loopta
	LOOP:
		MOV R2,#15   ;1 saniyeye yaklasmak i�in timeri 15 kez�agiriyoruz
		L1:LCALL BEKLEYAZDIR  ;hem bekle hem yazdir
		DJNZ R2,L1		   ;r2 0 degile 1 azalt ve tekrar et
    CONT: 
	    MOV P2,#7FH    ;ledin birsey g�stermesini engelliyoruz
	    MOV R3,#15
		L2:LCALL BEKLE
	    DJNZ R3,L2
	    ACALL YAZDIR   ;basa d�n�s
		   
AGAIN: MOV A,#00H    ;ak�y� temizliyoruz
	   MOVC A,@A+DPTR  ;ak�ye deger atadik
	   MOV P2,A  ;�nce hangi ledin yanicagini
	   INC DPTR  ;dizimizin indexini arttirdik
	   MOV A,#00H
	   MOVC A,@A+DPTR
	   MOV P3,A   ;ardindan ledde ne g�sterileceginin bilgisini ak�den veriyoruz
	   INC DPTR
	   MOV A,#00H
	   MOVC A,@A+DPTR
	   RET


BEKLE:
	MOV TMOD, #01h ; T0 Mod 1�de �alistirilacak
	MOV TH0, #00h ; baslangi� degerleri y�kleniyor (y�ksek kismi)
	MOV TL0, #00h ; baslangi� degerleri y�kleniyor (d�s�k kismi)
	SETB TR0
	BEKLEDEVAM:
		JNB TF0,BEKLEDEVAM   ;tasma olana kadar tekrar
		CLR TF0
		CLR TR0  ;timeri ve tasma tagini temizleme 
		RET

BEKLEYAZDIR:
	MOV TMOD, #01h ; 
	MOV TH0, #00h ; 
	MOV TL0, #00h ; 
	SETB TR0	
	BEKLEYAZDIRDEVAM:
		MOV DPTR,#500H
		ACALL AGAIN   ;hem yazip hem beklemek (1.led )
		LCALL DELAY  ;kisa gecikmeler
		ACALL AGAIN   ;(2.led)
		LCALL DELAY
		ACALL AGAIN   ;(3.led)
		LCALL DELAY
		ACALL AGAIN ;(4.led)
		LCALL DELAY	
		JNB TF0,BEKLEYAZDIRDEVAM  
		CLR TF0
		CLR TR0
		RET
	
DELAY: 
	MOV R6,#3D
    MOV R7,#3D
	LOOP1: DJNZ R6,LOOP1
	LOOP2: DJNZ R7,LOOP1
    RET

ORG 500H
	DB 7EH,71H,7DH,5FH,7BH,5BH,77H,5FH
END
