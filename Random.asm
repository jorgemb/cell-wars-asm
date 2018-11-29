; ------------------------------------------------------- ;
; Contiene una función para generar números aleatorios.
; Basado en el código fuente encontrado en:
; http://www.daniweb.com/software-development/assembly/
;	threads/292225/random-number-generating-in-assembly#
; ------------------------------------------------------- ;

; ---------------------------------------- ;
; Genera un valor al azar entre 0 y 65535
; @return [AX]: Valor aleatorio
; ---------------------------------------- ;
RANDOM PROC NEAR
	; Lehmer linear congruential random number generator
    ; z= (a*z+b) mod m = (31*z+13)%19683
    ; Rules for a, b, m by D. Knuth:
    ; 1. b and m must be relatively prime
    ; 2. a-1 must be divisible without remainder by all prime factors of m (19683 = 3^9), (31-1)%3=0
    ; 3. if m is divisible by 4, a-1 must also be divisible by 4, 19683%4 != 0, ok
    ; 4. if conditions 1 to 3 met, period of {z1, z2, z3,...} is m-1 = 19682 (Donald says)
	
.DATA
	RANDOM_SEED		DW		0ABBAH
	RANDOM_ANT		DW		0ABBAH
.CODE
	
	; save used registers
	push dx
	push bx
	
	mov ax, RANDOM_SEED  ; set new initial value z 
	mov dx, 0
	
	mov bx, 001FH		; 31D 
	mul bx				; 31 * z
						; result dx:ax, higher value in dx, lower value in ax
	add ax, 000DH		; +13
	;mov bx, 4CE3H		; 19683D
	mov bx, 0E6A9H		; 59049D
	div bx				; div by 19683D
						; result ax:dx, quotient in ax, remainder in dx (this is the rnz)	
	
	mov	RANDOM_SEED, dx
	
	mov ax, dx
	
	; restore used registers
	pop bx
	pop dx
	ret
RANDOM ENDP

; -------------------------------------------------------- ;
; Devuelve un valor aleatorio en el rango dado por [-r, r]
; @param [WORD]: Rango (r)
; @return [AX]: Valor aleatorio
; -------------------------------------------------------- ;
RANDOM_RANGO PROC NEAR
	; Preparar pila
	PUSH	BP
	MOV		BP, SP
	PUSH	CX
	PUSH	DX

	CALL	RANDOM
	
	; Restringe el valor aleatorio entre [0, 2r]
	MOV		DX, 0
	MOV		CX, [BP+4]		; Rango
	SHL		CX, 1
	INC		CX
	
	DIV		CX
	
	; El valor del residuo (DX) se le resta el rango
	; para que así sea [-r,r]
	MOV		CX, [BP+4]		; Rango
	SUB		DX, CX
	
	MOV		AX, DX
	
	; Reestablecer pila
	POP		DX
	POP		CX
	POP		BP
	RET
RANDOM_RANGO ENDP
