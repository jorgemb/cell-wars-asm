;###########################################;
;Universidad del Valle de Guatemala			;
;Organización de computadoras y Assembler	;
;											;
; Librería que contiene las funciones para  ;
; la impresión del menú del juego.			;
;											;
;Eddy Omar Castro Jáuregui - 11032			;
;Jorge Luis Martínez Bonilla - 11237		;
;###########################################;

; -----------------------------------------------;
; Este procedimiento imprime el menu de opciones.
; -----------------------------------------------;
IMPRESION_MENU PROC NEAR
	CALL	CLEAR_SCREEN
	PUSH 	7
	PUSH	27
	CALL 	GOTOXY		; Ir a las coordenadas seleccionadas
	ADD		SP, 4
	
	PUSH	OFFSET MENU
	CALL	COUT		; Imprimir cadena
	ADD		SP, 2
	; Imprimir las opciones del menu
	MOV		CX, 05D
	MOV		BX, OFFSET OPCIONES
	MOV		AX, 9			; Contador de lineas (empieza en la linea 9)
	IMPRESION_MENU_CICLO:
		; Mete los registros a la pila para ser recuperados después
		PUSH	AX
		PUSH	BX
		PUSH	CX
		
		PUSH	AX
		PUSH	23
		CALL	GOTOXY
		ADD		SP, 4
		
		PUSH	[BX]
		CALL	COUT
		ADD		SP, 2
		; Recupera los registros de la pila
		POP		CX
		POP		BX
		POP		AX
		
		INC		AX
		ADD		BX, 2
		LOOP	IMPRESION_MENU_CICLO
	RET
IMPRESION_MENU ENDP

; ---------------------------------------------------------;
; Este procedimiento permite al usuario seleccionar opcion.
; @return [AL]: Valor de la opción seleccionada.
; ---------------------------------------------------------;
SELECCION_MENU PROC NEAR
	PUSH 	15
	PUSH	20
	CALL 	GOTOXY		; Ir a las coordenadas seleccionadas
	ADD		SP, 4
	
	PUSH	OFFSET SELECCION
	CALL	COUT		; Imprimir cadena
	ADD		SP, 2
	
	CAPTURA_OPCION:
	PUSH	0
	CALL	GETC		; Captura de caracter
	ADD		SP, 2
	
	SUB		AL, 30H		; Convertir a decimal
	MOV		SELECCION_MEN, AX
	
	; Verificar que la opción seleccionada sea válida
	PUSH	1
	PUSH	5
	PUSH	AX
	CALL	VERIFICA_CANTIDAD
	ADD		SP, 6
	
	; Repetir en caso que no sea válida
	CMP		AH, 0
	JE		CAPTURA_OPCION
	
	RET
SELECCION_MENU ENDP

; ------------------------------------------------- ;
; Determina la acción que el usuario desea realizar.
; @param [BYTE]: Opción de menu seleccionada.
; ------------------------------------------------- ;
DETERMINAR_SELECCION PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	
	; Determinar la opcion a donde saltar 
	MOV		AX, [BP+4]
	SUB		AX, 1
	SHL		AX, 1
	MOV		BX, OFFSET DET_OPCIONES
	ADD		BX, AX
	JMP		[BX]
	
	OPCION_1:
	CALL 	JUGAR
	JMP		SELECCION_VERIF
	OPCION_2:
	CALL	INSTRUCCIONES
	JMP		SELECCION_VERIF
	OPCION_3:
	CALL	CAMBIO_PASOS
	JMP		SELECCION_VERIF
	OPCION_4:
	CALL	CAMBIO_JUGADORES
	JMP		SELECCION_VERIF
	OPCION_5:
	CALL	SALIDA
	
	SELECCION_VERIF:
	; PILA - Regresar al estado inicial
	POP		BX
	POP		BP
	RET
DETERMINAR_SELECCION ENDP

; -----------------------------------------------------------------------------------------;
; Procedimiento que se realiza cuando el usuario selecciona la opción de cambiar jugadores.
; -----------------------------------------------------------------------------------------;
CAMBIO_JUGADORES PROC NEAR
	CALL	CLEAR_SCREEN
	PUSH 	10
	PUSH	16
	CALL 	GOTOXY		; Ir a las coordenadas seleccionadas
	ADD		SP, 4
	
	PUSH	OFFSET PEDIR_JUGAD
	CALL	COUT		; Imprimir cadena
	ADD		SP, 2
	
	CAPTURA_JUGADOR:
	PUSH	0
	CALL	GETC		; Captura de caracter
	ADD		SP, 2
	
	SUB		AL, 30H		; Convertir a decimal
	MOV		NO_JUGAD, AX
	
	; Verificar que la opción seleccionada sea válida
	PUSH	2
	PUSH	3
	PUSH	AX
	CALL	VERIFICA_CANTIDAD
	ADD		SP, 6
	
	; Repetir en caso que no sea válida
	CMP		AH, 0
	JE		CAPTURA_JUGADOR
	CALL	EXITO_JUGAD		; Caso valido
	RET
CAMBIO_JUGADORES ENDP

; -------------------------------------------------------------------------------------;
; Procedimiento que se realiza cuando el usuario selecciona la opción de cambiar pasos.
; -------------------------------------------------------------------------------------;
EXITO_JUGAD PROC NEAR
	PUSH 	15
	PUSH	20
	CALL 	GOTOXY		; Ir a las coordenadas seleccionadas
	ADD		SP, 4
	
	PUSH	OFFSET EXITO_JUGADOR
	CALL	COUT		; Imprimir cadena
	ADD		SP, 2

	; Realizar pausa
	XOR AH,AH
	INT 16H	
	RET
EXITO_JUGAD ENDP
	
; -------------------------------------------------------------------------------------;
; Procedimiento que se realiza cuando el usuario selecciona la opción de cambiar pasos.
; -------------------------------------------------------------------------------------;
CAMBIO_PASOS PROC NEAR
	CALL	CLEAR_SCREEN
	PUSH 	10
	PUSH	3
	CALL 	GOTOXY		; Ir a las coordenadas seleccionadas
	
	PUSH	OFFSET PEDIR_PASOS
	CALL	COUT		; Imprimir cadena
	PUSH	2
	PUSH	OFFSET TEMP_PASOS
	CALL	CIN
	
	; Convetir a número
	PUSH 	OFFSET	TEMP_PASOS
	CALL	STR_TO_NUMBER
	ADD		SP, 12				; Limpiar la pila de las últimas llamadas
	
	; Verificar error
	CMP		AX, 0
	JE		NO_NUM
	MOV		TEMP_PASOS_NUM, AX
	
	; Verificar que las pasos ingresados sean válidos
	PUSH	15
	PUSH	70
	PUSH	AX
	CALL	VERIFICA_CANTIDAD
	ADD		SP, 6
	
	CMP		AH, 0
	JE		NO_NUM
	JMP		SI_NUM
	NO_NUM:						; Accion en caso de ser número válido
	CALL	ERROR_PASOS
	JMP		TERMINA
	SI_NUM:						; Accion en caso de no ser número válido
	CALL	GUARDA_PASOS
	TERMINA:
	RET
CAMBIO_PASOS ENDP

; ----------------------------------------------------------------------------------------------------------;
; Procedimiento que muestra un mensaje de error en caso de que no sea correcto el número de pasos ingresado.
; ----------------------------------------------------------------------------------------------------------;
ERROR_PASOS PROC NEAR
	
	PUSH 	15
	PUSH	10
	CALL 	GOTOXY		; Ir a las coordenadas seleccionadas
	ADD		SP, 4
	
	PUSH	OFFSET ERROR_PASOS_MEN
	CALL	COUT		; Imprimir cadena
	ADD		SP, 2
	
	; Realizar pausa
	XOR AH,AH
	INT 16H
	
	RET
ERROR_PASOS	ENDP

; -------------------------------------------------------------------;
; Procedimiento que almacena el número de pasos en el lugar correcto.
; -------------------------------------------------------------------;
GUARDA_PASOS PROC NEAR
	
	; Almacenar el número de pasos ingresados
	MOV		AX, TEMP_PASOS_NUM
	MOV		NO_PASOS, AX
	
	PUSH 	15
	PUSH	20
	CALL 	GOTOXY		; Ir a las coordenadas seleccionadas
	ADD		SP, 4
	
	PUSH	OFFSET EXITO_PASOS
	CALL	COUT		; Imprimir cadena
	ADD		SP, 2
	
	; Realizar pausa
	XOR AH,AH
	INT 16H
	
	RET
GUARDA_PASOS ENDP

; -----------------------------------------------;
; Este procedimiento imprime el menu de opciones.
; -----------------------------------------------;
INSTRUCCIONES PROC NEAR
	CALL	CLEAR_SCREEN
	PUSH 	5
	PUSH	32
	CALL 	GOTOXY		; Ir a las coordenadas seleccionadas
	ADD		SP, 4
	
	PUSH	OFFSET INSTRUC
	CALL	COUT		; Imprimir cadena
	ADD		SP, 2
	; Imprimir las instrucciones
	MOV		CX, 09D
	MOV		BX, OFFSET INSTRUCCION
	MOV		AX, 7			; Contador de lineas (empieza en la linea 7)
	INSTRUCCIONES_CICLO:
		; Mete los registros a la pila para ser recuperados después
		PUSH	AX
		PUSH	BX
		PUSH	CX
		
		PUSH	AX
		PUSH	0
		CALL	GOTOXY
		ADD		SP, 4
		
		PUSH	[BX]
		CALL	COUT
		ADD		SP, 2
		; Recupera los registros de la pila
		POP		CX
		POP		BX
		POP		AX
		
		INC		AX
		ADD		BX, 2
		LOOP	INSTRUCCIONES_CICLO
	; Realizar pausa
	XOR AH,AH
	INT 16H	
	RET
INSTRUCCIONES ENDP

