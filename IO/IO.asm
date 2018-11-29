;###########################################;
;Universidad del Valle de Guatemala			;
;Organización de computadoras y Assembler	;
;											;
;Libreria para manejo de entrada y salida	;
;con consola.								;
;											;
;Eddy Omar Castro Jáuregui - 11032			;
;Jorge Luis Martínez Bonilla - 11237		;
;###########################################;

; ------------------------------------------ ;
; Esta funcion limpia el buffer de teclado.
; ------------------------------------------ ;
LIMPIAR_TECLADO	PROC NEAR

	MOV		AH, 0CH
	MOV		AL, 06H
	INT		21H
	
	RET

LIMPIAR_TECLADO ENDP

; ---------------------------------------------------- ;
; Esta funcion retorna el codigo de rastreo
; @return [AH]: Codigo de rastreo
; @return [AL]: caracter ASCII o 0 en extendido
; ---------------------------------------------------- ;
GET_SCANCODE	PROC NEAR
	
	; Obtener el codigo de rastreo usando la funcion 10H de la interrupcion 16H
	MOV		AH, 10H
	INT		16H
		
	RET
GET_SCANCODE	ENDP

; ---------------------------------------------------- ;
; Esta funcion despliega un solo caracter enr pantalla.
; @param [BYTE]: Caracter a desplegar
; ---------------------------------------------------- ;
PUTC	PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	DX
	
	; Escribir el caracter en pantalla usando la funcion 02H de la interrupcion 21H
	MOV		DX, [BP+4]
	MOV		AH, 02H
	INT		21H
		
	; PILA - Regresar al estado inicial
	POP		DX
	POP		BX
	POP		BP
	RET
PUTC	ENDP

; ----------------------------------------------- ;
; Esta funcion recibe un caracter de la pantalla.
; @param [BYTE]: Echo [1 -> echo; 0 -> no echo]
; @return [AL]: Caracter de entrada
; ----------------------------------------------- ;
GETC	PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	DX

	; Revisa la variable Echo para ver si se imprime echo o no
	MOV		DX, [BP+4]
	CMP		DX, 0
	JE		GETC_SIN_ECHO
	
	GETC_CON_ECHO:
	MOV		AH, 01H
	INT		21H
	JMP		GETC_FIN
	
	GETC_SIN_ECHO:
	MOV		AH, 07H
	INT		21H
	
	; Limpia la parte alta del registro AX para que en AX quede unicamente el caracter de retorno
	GETC_FIN:
	MOV		AH, 0
	
	; PILA - Regresar al estado inicial
	POP		DX
	POP		BX
	POP		BP
	RET
GETC	ENDP

; ----------------------------------------------- ;
; Esta funcion regresa el código de rastreo.
; @param [BYTE]: Tipo [0 -> imprimible; 1 -> extendido]
; @return [AL]: Tecla presionada
; ----------------------------------------------- ;
GETC_EXTENDED	PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	DX

	; Revisa la variable Tiop para ver si se desea caracter imprimible o extendido
	MOV		DX, [BP+4]
	CMP		DX, 0
	JE		GETC_IMPRIMIBLE
	
	MOV		AH, 06H
	MOV		DL, 0FFH
	INT		21H
	
	GETC_IMPRIMIBLE:
	MOV		AH, 06H
	MOV		DL, 0FFH
	INT		21H
	
	MOV		DX, [BP+4]
	CMP		DX, 1
	JE		GETC_EXTENDIDO	
	
	CMP		AL, 0
	JNE		GETC_EXTENDIDO
	MOV		AH, 06H
	MOV		DL, 0FFH
	INT		21H
	
	GETC_EXTENDIDO:
	; Limpia la parte alta del registro AX para que en AX quede unicamente el caracter de retorno
	MOV		AH, 0
	
	; PILA - Regresar al estado inicial
	POP		DX
	POP		BX
	POP		BP
	RET
GETC_EXTENDED	ENDP

; ----------------------------------------------------------- ;
; Muestra un string en pantalla.
; @param [WORD]: Direccion de la primera posicion del string.
; @return [AX]: Cantidad de caracteres escritos
; ----------------------------------------------------------- ;
COUT	PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	CX
	PUSH	DX
	
	; Obtiene la direccion del string
	MOV		AX, 0		; Contador de caracteres
	MOV		BX, [BP+4]
	MOV		CX, [BP+6]
	
	; Muestra el string caracter por caracter
	MOV		DH,	0
	COUT_CICLO:
	MOV		DL, [BX]
	CMP		DL, '$'
	JE		COUT_FIN
	
	PUSH	DX
	CALL	PUTC
	ADD		SP, 2
	
	INC		BX
	INC		AX
	JMP		COUT_CICLO
	
	COUT_FIN:
	; PILA - Regresar al estado inicial
	POP		DX
	POP		CX
	POP		BX
	POP		BP
	
	RET
COUT	ENDP

; ------------------------------------------------------------------------------ ;
; Recibe entrada desde la consola, desde el primer caracter hasta que el usuario
; presione enter o llene la cantidad maxima de caracteres a utilizar.
; @param [WORD]: Direccion del buffer de salida
; @param [WORD]: Cantidad de datos a leer
; @return [AX]: Cantidad de caracteres leidos
; ------------------------------------------------------------------------------ ;
CIN		PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	; Carga la direccion de salida en BX y la cantidad de caracteres en CX
	MOV		BX, [BP + 4]
	MOV		CX, [BP + 6]
	
	PUSH	0	; Para mostrar echo en la funcion GETC
	CIN_CICLO:
	CALL 	GETC
	CMP		AL, 0DH
	JE		CIN_FIN_CICLO
	
	CMP		AL, 08H
	JNE		CIN_NO_BACKSPACE
	
	CMP		CX, [BP+6]		; Si la cantidad de caracteres es cero entonces no se borra nada
	JE		CIN_CICLO
	PUSH	AX
	CALL	PUTC
	ADD		SP, 2
	
	INC		CX
	DEC		BX
	JMP		CIN_CICLO
	; Hacer eco del caracter en la pantalla (Solo si no es enter o backspace)
	CIN_NO_BACKSPACE:
	PUSH	AX
	CALL	PUTC
	ADD		SP, 2
	
	; Agrega el nuevo caracter
	MOV		[BX], AL
	INC		BX
	LOOP	CIN_CICLO
	
	CIN_FIN_CICLO:
	ADD		SP, 2	; Quita los parametros de GETC
	; Calcula la cantidad de caracteres leidos y agrega el caracter de fin de string
	MOV		AX, [BP+6]
	SUB		AX, CX
	MOV		[BX], BYTE PTR '$'
	; PILA - Regresar al estado inicial
	POP		BX
	POP		BP
	RET
CIN		ENDP


; ------------------------------- ;
; Ingresa un enter en la consola.
; ------------------------------- ;
PUT_ENTER	PROC NEAR
	; Pone en pantalla los caracteres de carriage return y line feed.
	PUSH	0DH
	CALL	PUTC
	
	PUSH	0AH
	CALL	PUTC
	
	ADD		SP, 4
	RET
PUT_ENTER	ENDP


; ---------------------------------------------------------------------------------;
; Esta funcion verifica que la cantidad seleccionada se encuentre dentro del rango.
; @param [BYTE]: Cantidad a comparar.
; @param [BYTE]: Cantidad mayor.
; @param [BYTE]: Cantidad menor.
; @return [AH]: 0 si la cadena no es valida, y 1 en caso contrario
; ---------------------------------------------------------------------------------;
VERIFICA_CANTIDAD	PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	DX

	MOV		AH, 1
	; Verificar que es menor a 5
	MOV		DL, BYTE PTR [BP+6]
	CMP		BYTE PTR [BP+4], DL
	JG		NO_VALIDO
	
	; Verificar que es mayor a 1
	MOV	DL, BYTE PTR [BP+8]
	CMP		BYTE PTR [BP+4], DL
	JL		NO_VALIDO
	
	JMP		SI_VALIDO
	
	NO_VALIDO:
	MOV		AH, 0
	
	SI_VALIDO:
	; PILA - Regresar al estado inicial
	POP		DX
	POP		BP
	
	RET
VERIFICA_CANTIDAD	ENDP

; ---------------------------------------------------------- ;
; Pide un ingreso al usuario de un dígito, asegurándose que
; se encuentre en un rango numérico dado. Siempre devuelve
; un valor correcto.
; @param[BYTE]: Cantidad mayor.
; @param[BYTE]: Cantidad menor.
; @return[AX]: Valor ingresado
; ---------------------------------------------------------- ;
ENTRADA_NUMERICA	PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	ENTRADA_VALIDAR:
			MOV		AX, 0
			PUSH	0
			CALL	GETC
			ADD		SP, 2
			SUB		AL, 30H
			
			PUSH	WORD PTR [BP+6]
			PUSH	WORD PTR [BP+4]
			PUSH	AX
			CALL	VERIFICA_CANTIDAD
			ADD		SP, 6
			
			CMP		AH, 0
			JE		ENTRADA_VALIDAR
	; Copia el valor en AL y limpia AH
	MOV		AH, 0	
	PUSH	AX
	
	; Realiza un eco del caracter ingresado
	ADD		AX, 30H
	PUSH	AX
	CALL	PUTC
	ADD		SP, 2
	
	POP		AX
	; PILA - Regresar al estado inicial
	POP		BX
	POP		BP
	RET
ENTRADA_NUMERICA	ENDP
