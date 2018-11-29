;###########################################;
;Universidad del Valle de Guatemala			;
;Organización de computadoras y Assembler	;
;											;
; Librería para manejo de strings.			;
;											;
;Eddy Omar Castro Jáuregui - 11032			;
;Jorge Luis Martínez Bonilla - 11237		;
;###########################################;


; ------------------------------------------------------------- ;
; Esta función recibe un string y regresa el tamaño de la misma
; en caracteres, sin contar el caracter de fin.
; @Param [WORD]: Dirección de inicio del string.
; @return [AX]: Tamaño del string.
; ------------------------------------------------------------- ;
STRLEN PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	DX
	
	; Inicializa los registros
	MOV		BX, [BP + 4]
	MOV		AX, 0
	
	STRLEN_CICLO:
		MOV		DL, [BX]
		CMP		DL, '$'
		JE		STRLEN_FIN_CICLO
		
		INC		AX
		INC		BX
		JMP		STRLEN_CICLO
		
	STRLEN_FIN_CICLO:
	
	; PILA - Regresar al estado inicial
	POP		DX
	POP		BX
	POP		BP
	RET
STRLEN ENDP

; --------------------------------------------------------------------------- ;
; Convierte un string con numeros a numero en decimal sin signo.
; @param [WORD]: Direccion del string
; @return [AX]: Numero convertido (regresa 0 si no se pudo convertir ninguno.
; --------------------------------------------------------------------------- ;
STR_TO_NUMBER	PROC NEAR
	.DATA
		MULTIPLICADOR	DW	10D
	.CODE
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	; Inicializar registros
	MOV		BX, [BP+4]
	MOV		AX, 0
	MOV		CX,	0		; Este funciona como el acumulador del numero
	; Revisa el tamaño del string y si todos son numeros
	STONUM_CICLO:
		; Revisar por fin de cadena
		MOV		AL, [BX]
		CMP		AL, '$'
		JE		STONUM_FIN_COPIAR
		; Primero revisa si es numero
		PUSH	AX
		CALL	ES_NUMERO
		ADD		SP, 2
		
		CMP		AX, 0
		JNE		STONUM_CONVERTIR
		
		MOV		AX, 0
		JMP		STONUM_FIN
		
		STONUM_CONVERTIR:
		; Si sí es número se convierte a decimal. El acumulador se multiplica por 10 y se le suma el numero
		MOV		AX, CX
		MUL		MULTIPLICADOR
		MOV		CX, AX
		
		XOR		AX, AX
		MOV		AL, [BX]
		SUB		AL, 30H
		ADD		CX, AX
		
		INC		BX
		JMP		STONUM_CICLO
		
	STONUM_FIN_COPIAR:
		MOV 	AX, CX
	STONUM_FIN:
	; PILA - Regresar al estado inicial
	POP		BX
	POP		BP
	RET
STR_TO_NUMBER	ENDP

; ---------------------------------------------------------------------- ;
; Convierte un numero sin signo en un string hasta un máximo de 65536
; @param [WORD]: Número a convertir
; @param [WORD]: Dirección de memoria que pueda contener la cadena junto
; con el caracter de terminación (6 caracteres).
; ---------------------------------------------------------------------- ;
NUM_TO_STRING	PROC NEAR
	.DATA
		DIVISOR	DW	10D
	.CODE
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	; Inicializar registros
	MOV		DX, 0
	MOV		CX, [BP + 4]	; Numero
	MOV		BX, [BP + 6]	; Buffer de salida
	
	NTOS_CICLO:
		MOV		AX, CX
		MOV		DX, 0
		DIV		DIVISOR
		
		ADD		DL, 30H
		MOV		[BX], DL
		INC		BX
		
		CMP		AX, 0
		JE		NTOS_FIN
		
		MOV		CX, AX
		JMP		NTOS_CICLO
	
	NTOS_FIN:
	MOV		BYTE PTR [BX], '$'
		
	PUSH	[BP + 6]
	CALL	STRINV
	ADD		SP, 2
	; PILA - Regresar al estado inicial
	POP		BX
	POP		BP
	RET
NUM_TO_STRING 	ENDP

; ------------------------------------------------------------- ;
; Invierte el string dado y lo sobreescribe en el mismo buffer.
; @param [WORD]: Dirección del string a invertir.
; ------------------------------------------------------------- ;
STRINV	PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	; Inicializar registros
	MOV		BX, [BP + 4]
	MOV		CX, 0
	MOV		DX, 0
	MOV		SI, 0
	
	; Obtener el tamaño del string
	PUSH	[BP + 4]
	CALL	STRLEN
	ADD		SP, 2
	
	; Se cicla la mitad del tamaño del string
	MOV		CX, AX
	SHR		CX, 1
	
	MOV		DI, AX
	SUB		DI, 1
	
	STRINV_CICLO:
		; Intercambia los caracteres de BX+SI y BX+DI
		MOV		DL, [BX+SI]
		MOV		DH, [BX+DI]
		MOV		[BX+SI], DH
		MOV		[BX+DI], DL
		
		INC		SI
		DEC		DI
		LOOP	STRINV_CICLO
	; PILA - Regresar al estado inicial
	POP		BX
	POP		BP
	RET
STRINV	ENDP

; ----------------------------------------------------------------- ;
; Copia un string de un buffer a otro. El programador se debe de
; asegurar que el destino tenga el tamaño necesario para que quepa
; lo que se quiere copiar del base más el caracter de terminación.
; @param [WORD]: Dirección del string fuente
; @param [WORD]: Caracteres a copiar
; @param [WORD]: Dirección del string destino
; @return [AX]: Caracteres copiados
; ----------------------------------------------------------------- ;
STRCPY	PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	
	; Inicializar registros
	MOV		SI, [BP + 4]
	MOV		CX, [BP + 6]
	MOV		DI, [BP + 8]
	
	MOV		AX, 0
	MOV		DX, 0
	
	; Copiar los caracteres
	STRCPY_CICLO:
		CMP		BYTE PTR [SI], '$'
		JE		STRCPY_FIN
	
		MOV		DL, [SI]
		MOV		[DI], DL
		
		INC		AX
		INC		SI
		INC		DI
		LOOP	STRCPY_CICLO
		
	STRCPY_FIN:
	MOV		BYTE PTR [DI], '$'
	
	; PILA - Regresar al estado inicial
	POP		BX
	POP		BP
	RET
STRCPY	ENDP

; -------------------------------------------------------- ;
; Recibe un caracter y revisa si es mayúscula.
; @param [BYTE]: Caracter a revisar
; @return [AX]: 0 si no es mayúscula, 1 en caso contrario
; -------------------------------------------------------- ;
ES_MAYUSCULA	PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	
	MOV		AX, 0
	
	CMP		BYTE PTR [BP+4], 41H
	JL		ES_MAYUSCULA_FIN
	CMP		BYTE PTR [BP+4], 5AH
	JG		ES_MAYUSCULA_FIN
	
	MOV		AX, 1
	
	ES_MAYUSCULA_FIN:
	; PILA - Regresar al estado inicial
	POP		BX
	POP		BP
	
	RET
ES_MAYUSCULA	ENDP


; -------------------------------------------------------- ;
; Recibe un caracter y revisa si es minúscula.
; @param [BYTE]: Caracter a revisar
; @return [AX]: 0 si no es minúscula, 1 en caso contrario
; -------------------------------------------------------- ;
ES_MINUSCULA	PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	
	MOV		AX, 0
	
	CMP		BYTE PTR [BP+4], 61H
	JL		ES_MINUSCULA_FIN
	CMP		BYTE PTR [BP+4], 7AH
	JG		ES_MINUSCULA_FIN
	MOV		AX, 1
	
	ES_MINUSCULA_FIN:
	; PILA - Regresar al estado inicial
	POP		BX
	POP		BP
	
	RET
ES_MINUSCULA	ENDP


; -------------------------------------------------------- ;
; Recibe un caracter y revisa si es número.
; @param [BYTE]: Caracter a revisar
; @return [AX]: 0 si no es número, 1 en caso contrario
; -------------------------------------------------------- ;
ES_NUMERO	PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	
	MOV		AX, 0
	
	CMP		BYTE PTR [BP+4], 30H
	JL		ES_NUMERO_FIN
	CMP		BYTE PTR [BP+4], 39H
	JG		ES_NUMERO_FIN
	
	MOV		AX, 1
	
	ES_NUMERO_FIN:
	; PILA - Regresar al estado inicial
	POP		BX
	POP		BP
	
	RET
ES_NUMERO	ENDP

; ---------------------------------------------------------------- ;
; Recibe una cadena de caracteres y convierte todos los caracteres
; en minúscula a mayúscula.
; @param [WORD]: Dirección de la cadena a validar
; @return [AX]: Caracteres convertidos
; ---------------------------------------------------------------- ;
CONV_MAYUSCULA	PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	
	MOV		AX, 0
	MOV		BX, [BP+4]
	
	CONV_MAYUSCULA_CICLO:
	CMP		BYTE PTR [BX], '$'
	JE		CONV_MAYUSCULA_FIN
	
	PUSH	WORD PTR [BX]
	CALL	ES_MINUSCULA
	ADD		SP, 2
	
	CMP		AX, 1
	JNE		CONV_MAYUSCULA_FIN_CICLO
	
	MOV		CL, [BX]
	AND		CL, 11011111B
	MOV		[BX], CL
	INC		AX
	
	CONV_MAYUSCULA_FIN_CICLO:
	INC		BX
	JMP		CONV_MAYUSCULA_CICLO
	
	CONV_MAYUSCULA_FIN:
	; PILA - Regresar al estado inicial
	POP		BX
	POP		BP
	RET
CONV_MAYUSCULA	ENDP

; ---------------------------------------------------------------- ;
; Valida que el string dado contenga solo caracteres o numeros.
; @param [WORD]: Direccion de la cadena a validar.
; @param [WORD]: Tamaño de la cadena
; @return [AX]: 0 si la cadena no es valida, y 1 en caso contrario
; ---------------------------------------------------------------- ;
VALIDAR		PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	; Obtiene direccion de la cadena y tamaño
	MOV		BX, [BP+4]
	MOV		CX, [BP+6]
	
	VALIDAR_CICLO:
	MOV		DX, 0
	; Revisar rango numerico
	PUSH	WORD PTR [BX]
	CALL	ES_NUMERO
	ADD		SP, 2
	OR		DX, AX
	; Revisar rango de minusculas
	VALIDAR_RMIN:
	PUSH	WORD PTR [BX]
	CALL	ES_MINUSCULA
	ADD		SP, 2
	OR		DX, AX
	; Revisar rango de mayusculas
	VALIDAR_RMAY:
	PUSH	WORD PTR [BX]
	CALL	ES_MAYUSCULA
	ADD		SP, 2
	OR		DX, AX
	
	; Revisa por espacio
	VALIDAR_SP:
	CMP		BYTE PTR [BX], 20H
	JNE		VALIDAR_FIN_CICLO
	OR		DX, 1
	
	VALIDAR_FIN_CICLO:
	; Ver si el caracter es valido
	CMP		DX, 0
	JE		VALIDAR_FIN
	INC		BX
	LOOP 	VALIDAR_CICLO
	
	VALIDAR_FIN:
	MOV		AX, DX
	; PILA - Regresar al estado inicial
	POP		BX
	POP		BP
	RET
VALIDAR		ENDP
