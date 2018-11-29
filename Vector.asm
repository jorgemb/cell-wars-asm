;###########################################;
;Universidad del Valle de Guatemala			;
;Organización de computadoras y Assembler	;
;											;
; Librería para manejo de vectores en dos	;
; dimensiones, utilizando variables de 		;
; punto flotante de 32-bits (4 bytes).		;
;											;
;Eddy Omar Castro Jáuregui - 11032			;
;Jorge Luis Martínez Bonilla - 11237		;
;###########################################;

; Pone en cero el vector dado.
; @param [WORD]: Dirección del vector
VECTOR_CERO	PROC NEAR
	; Inicializa la pila
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	
	; Ingresa el valor cero a la pila y luego lo copia
	; a los dos vectores destino
	fldz
	
	MOV		BX, [BP+4]
	fst		DWORD PTR [BX]
	fstp	DWORD PTR [BX+4]
	
	
	POP		BX
	POP		BP
	RET
VECTOR_CERO ENDP


; Suma dos vectores y los pone en la posición indicada.
; @param [WORD]: Dirección del primer operando
; @param [WORD]: Dirección del segundo operando
; @param [WORD]: Destino de la suma
VECTOR_SUMAR PROC NEAR
	; Inicializa la pila
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	SI
	PUSH	DI
	
	; Asigna los operandos a cada registro
	MOV		BX, [BP+4]	; Primer operando
	MOV		SI,	[BP+6]	; Segundo operando
	MOV		DI, [BP+8]	; Resultado
	
	; Realiza la suma de ambos vectores
	; .. X
	FLD		DWORD PTR [BX]
	FADD	DWORD PTR [SI]
	FSTP	DWORD PTR [DI]
	
	; .. Y
	FLD		DWORD PTR [BX+4]
	FADD	DWORD PTR [SI+4]
	FSTP	DWORD PTR [DI+4]
	
	POP		DI
	POP		SI
	POP		BX
	POP		BP
	RET
VECTOR_SUMAR ENDP


; Resta el segundo vector del primero, dando así un
; vector que va del segundo al primero.
; @param [WORD]: Dirección del minuendo
; @param [WORD]: Dirección del sustraendo
; @param [WORD]: Destino de la resta
VECTOR_RESTAR PROC NEAR
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	SI
	PUSH	DI
	
	; Asigna los operandos a cada registro
	MOV		BX, [BP+4]	; Minuendo
	MOV		SI,	[BP+6]	; Sustraendo
	MOV		DI, [BP+8]	; Resultado
	
	; Realiza la resta de los vectores
	; .. X
	FLD		DWORD PTR [BX]
	FSUB	DWORD PTR [SI]
	FSTP	DWORD PTR [DI]
	
	; .. Y
	FLD		DWORD PTR [BX+4]
	FSUB	DWORD PTR [SI+4]
	FSTP	DWORD PTR [DI+4]
	
	POP		DI
	POP		SI
	POP		BX
	POP		BP
	RET
VECTOR_RESTAR ENDP

; Calcula la magnitud del vector dado
; @param[WORD]: Dirección del vector a calcular
; ret [ST(0)]: Devuelve la magnitud en la pila
VECTOR_MAGNITUD	PROC NEAR
	; Inicializa la pila
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	
	; Asigna el operando al registro
	MOV		BX, [BP+4]
	
	; Calcula el cuadrado de los componentes
	FLD		DWORD PTR [BX]		; x
	FMUL	DWORD PTR [BX]		; x*x
	
	FLD		DWORD PTR [BX+4]	; y
	FMUL	DWORD PTR [BX+4]	; y*y
	
	FADD						; x*x + y*y
	FSQRT						; sqrt( x*x + y*y )
	
	POP		BX
	POP		BP
	RET
VECTOR_MAGNITUD ENDP

; Calcula el producto escalar de un vector
; @param [WORD]: Dirección del vector a multiplicar
; @param [WORD]: Dirección donde se encuentra el escalar [en punto flotante]
; @param [WORD]: Dirección del vector destino
VECTOR_ESCALAR PROC NEAR
	; Inicializa la pila
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	
	; Mueve el escalar a la pila y lo multiplica por cada componente
	MOV		BX, [BP+6]		; Dirección del escalar
	FLD		DWORD PTR [BX]
	
	;.. ST(1) = X, ST(0) = Y
	MOV		BX, [BP+4]		; Dirección del vector fuente
	FLD		DWORD PTR [BX]
	FLD		DWORD PTR [BX+4]
	
	MOV		BX, [BP+8]		; Dirección del vector destino
	FMUL	ST, ST(2)
	FSTP	DWORD PTR [BX+4]			; Guarda la componente Y

	FMUL
	FSTP	DWORD PTR [BX]			; Guarda la componente X
	
	POP		BX
	POP		BP
	RET
VECTOR_ESCALAR ENDP

; Normaliza el vector dado.
; @param[WORD]: Dirección del vector fuente
; @param[WORD]: Dirección del vector destino
VECTOR_NORMALIZAR PROC NEAR
	; Inicializa la pila
	PUSH	BP
	MOV		BP, SP
	PUSH	AX
	PUSH	BX
	PUSH	DI
	
	; Asigna la dirección de los operandos a los registros
	MOV		BX, [BP+4]	; Fuente
	MOV		DI, [BP+6]	; Destino
	
	; Calcula la magnitud del vector
	PUSH	BX
	CALL	VECTOR_MAGNITUD
	ADD		SP, 2
	
	; .. compara que la magnitud no sea cero
	FTST
	FSTSW	AX
	SAHF
	JNE		VECTOR_NORMALIZAR_CONTINUAR
	
	; Copia los valores al destino
	FLD		DWORD PTR [BX]
	FSTP	DWORD PTR [DI]
	FLD		DWORD PTR [BX+4]
	FSTP	DWORD PTR [DI+4]
	JMP		VECTOR_NORMALIZAR_FIN
	
	VECTOR_NORMALIZAR_CONTINUAR:
	; Divide cada uno de los componentes entre la magnitud
	; ..X
	FLD		DWORD PTR [BX]
	FDIV	ST, ST(1)		; x / |vector|
	FSTP	DWORD PTR [DI]
	
	; ..Y
	FLD		DWORD PTR [BX+4]
	FXCH					; Esta operación se hace para que la siguiente elimine la magnitud
							; de la pila.
	FDIVP	ST(1), ST		; y / |vector|
	FSTP	DWORD PTR [DI+4]
	
	VECTOR_NORMALIZAR_FIN:
	
	POP		DI
	POP 	BX
	POP		AX
	POP		BP
	RET
VECTOR_NORMALIZAR ENDP

; Calcula el producto punto de dos vectores
; @param [WORD]: Dirección al primer vector
; @param [WORD]: Dirección al segundo vector
; @return [ST]: Valor del producto punto
VECTOR_PUNTO PROC NEAR
	; Preparar pila
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	SI
	
	; Asigna la dirección de los operandos
	MOV		BX, [BP+4]	; Primer vector
	MOV		SI, [BP+6]	; Segundo vector
	
	; Calcula el producto de cada uno de los componentes y los suma
	FLD		DWORD PTR [BX]
	FLD		DWORD PTR [SI]
	FMUL					; V1x*V2x
	
	FLD		DWORD PTR [BX+4]
	FLD		DWORD PTR [SI+4]
	FMUL					; V1y*V2y
	
	FADD					; V1y*V2y + V1x*V2x
	
	POP		SI
	POP		BX
	POP		BP
	RET
VECTOR_PUNTO ENDP
