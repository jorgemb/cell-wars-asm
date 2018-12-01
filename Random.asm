; ------------------------------------------------------- ;
; Random number generator.
; Based on source code found in:
; http://www.daniweb.com/software-development/assembly/
;	threads/292225/random-number-generating-in-assembly#
; ------------------------------------------------------- ;

; ---------------------------------------- ;
; Random number between 0 and 65535
; @return [AX]: Random value
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
; Returns random value in the range [-r, r]
; @param [WORD]: Range (r)
; @return [AX]: Random value
; -------------------------------------------------------- ;
RANDOM_RANGE PROC NEAR
	; Stack preparation
	PUSH	BP
	MOV		BP, SP
	PUSH	CX
	PUSH	DX

	CALL	RANDOM
	
	; Restrict value to range [0, 2r]
	MOV		DX, 0
	MOV		CX, [BP+4]		; Range
	SHL		CX, 1
	INC		CX
	
	DIV		CX
	
	; Residue is substracted to the range so it becomes [-r, r]
	MOV		CX, [BP+4]		; Range
	SUB		DX, CX
	
	MOV		AX, DX
	
	; Stack restore
	POP		DX
	POP		CX
	POP		BP
	RET
RANDOM_RANGE ENDP
