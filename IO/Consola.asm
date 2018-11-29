;###########################################;
;Universidad del Valle de Guatemala			;
;Organización de computadoras y Assembler	;
;											;
; Librería con varias utilidades de consola.;
;											;
;Eddy Omar Castro Jáuregui - 11032			;
;Jorge Luis Martínez Bonilla - 11237		;
;###########################################;

; --------------------------------------;
; Este procedimiento limpia la pantalla.
; --------------------------------------;
CLEAR_SCREEN PROC NEAR
	PUSH	0007h	; Utilizar caracteres blancos para fondo negro
	PUSH	184Fh	; Esquina inferior derecha (24,79)
	PUSH	0000h	; Esquina superior izquierda (0, 0)
	CALL	CLEAR_SCREEN_SQUARE
	ADD		SP, 6
	
	RET
CLEAR_SCREEN ENDP

; ---------------------------------------------------------------------------
; Limpia un cuadro en pantalla con los parámetros dados.
; @param [WORD]: Coordenadas de la esquina superior izquierda (fila, columna)
; @param [WORD]: Coordenadas de la esquina inferior derecha (fila, columna)
; @param [BYTE]: Byte de atributo
; ---------------------------------------------------------------------------
CLEAR_SCREEN_SQUARE PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	; Guardar el valor de todos los registros utilizados
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	
	MOV		AX, [BP+8]	; Byte de atributo
	MOV		BH, AL
	MOV		BL, 0
	
	MOV		DX, [BP+6]	; Esquina inferior derecha
	MOV		CX, [BP+4]	; Esquina superior izquierda
	
	MOV		AH,	06H		; Función 06H
	
	MOV		AL, 01d		; Calcular la cantidad de líneas
	ADD		AL, DH
	SUB		AL, CH
	
	INT		10h
	
	; PILA - Regresar al estado inicial
	POP		DX
	POP		CX
	POP		BX
	POP		AX
	
	POP		BP
	RET
CLEAR_SCREEN_SQUARE ENDP

; -----------------------------------------------------------------------------;
; Este procedimiento mueve el cursos hacia un punto determinado de la pantalla.
; @param [BYTE]: Coordenada x
; @param [BYTE]: Coordenada y
;
; -----------------------------------------------------------------------------;
GOTOXY PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	AX
	PUSH	BX
	PUSH	DX

	MOV		AH, 2		; Utiliza función 2 para ir a x,y
	MOV		BH, 0		; Muestra página 0
	MOV		DH, [BP+6]	; Mueve la coordenada y
	MOV		DL, [BP+4]	; Mueve la coordenada x
	INT		10h			; Interrupción de DOS
	
	; PILA - Regresar al estado inicial
	POP		DX
	POP		BX
	POP		AX
	POP		BP
	RET
GOTOXY ENDP

; -------------------------------------------
; Forma el byte de color en el registro AL
; @param [BYTE]: Color fondo (XRGB)
; @param [BYTE]: Color letra (XRGB)
; @return AX: Byte formado
; -------------------------------------------
FORMAR_COLOR	PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	CX
	
	MOV		AX, 0
	MOV		BX, [BP+4]	; Color fondo
	MOV		CL, 4
	SHL		BX, CL
	
	MOV		AL, BL
	
	MOV		BX, [BP+6]	; Color letra
	OR		AL, BL
	
	; Elimina el bit de parpadeo
	AND		AL, 01111111b
	
	; PILA - Regresar al estado inicial
	POP		CX
	POP		BX
	POP		BP
	RET
FORMAR_COLOR	ENDP

; ; ------------------------------------------------------;
; ; Este procedimiento regresa un número aleatorio de 1-6.
; ; @return [AL]: Valor aleatorio generado
; ; ------------------------------------------------------;
; ALEATORIO PROC NEAR
	; ; Leer el reloj de la máquina
	; MOV		AH, 2CH
	; INT		21H
	
	; ; Realizar división dentro de 6
	; MOV 	AX, 0
	; MOV 	AL, DL
	; IDIV	SEIS
	
	; ; Utilizar residuo
	; INC		AH
	; MOV		AL, AH

	; RET
; ALEATORIO ENDP

; ; -------------------------------------------------- ;
; ; Toma un número aleatorio entre 1 y 6, y lo muestra
; ; en pantalla.
; ; @return [AX]: Número aleatorio generado
; ; -------------------------------------------------- ;
; TIRAR_DADO	 PROC NEAR
	; ; PILA - Preparar
	; PUSH	BP
	; MOV		BP, SP
	; PUSH	BX
	
	; CALL	ALEATORIO
	; MOV		AH, 0
	
	; PUSH	AX
	; ADD		AX, 30H
	; PUSH	AX
	; CALL	PUTC
	; ADD		SP, 2
	; POP		AX
	
	; ; PILA - Regresar al estado inicial
	; POP		BX
	; POP		BP
	; RET
; TIRAR_DADO	 ENDP

; ---------------------------------------------------------- ;
; Escribe la cantidad de veces en la pista el caracter dado.
; @param [BYTE]: Caracter a utilizar
; @param [WORD]: Cantidad de veces a escribir
; ---------------------------------------------------------- ;
RELLENO_CARACTER PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX

	PUSH	WORD PTR [BP+6]	; Veces a escribir
	MOV		SI, SP
	PUSH	WORD PTR [BP+4]	; Caracter a escribir
	
	RELLENO_CARACTER_CICLO:
		CALL 	PUTC
		
		DEC 	WORD PTR [SI]
		CMP		WORD PTR [SI], 0
		JNE		RELLENO_CARACTER_CICLO
	
	ADD		SP, 4
		
	; PILA - Regresar al estado inicial
	POP		BX
	POP		BP
	RET
RELLENO_CARACTER ENDP

; -------------------------------------------------------------- ;
; Dibuja un cuadro relleno en la posición dada, del tamaño dado.
; @param [WORD]: Posición x
; @param [WORD]: Posición y
; @param [WORD]: Longitud
; @param [WORD]: Altura
; @param [BYTE]: Caracter a utilizar
; -------------------------------------------------------------- ;
DIBUJAR_CUADRO_RELLENO	PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	; Rellena las siguientes n lineas con el caracter dado
	PUSH	WORD PTR [BP+6] 	; Coordenada y
	PUSH	WORD PTR [BP+4]	; Coordenada x
	MOV		SI, SP
	ADD		SI, 2			; Apunta a la coordenada y, que es la que cambia
							; para cada línea.
	MOV		CX, [BP+10]		; Líneas a escribir
	
	DIBUJAR_CUADRO_RELLENO_CICLO:
		CALL	GOTOXY
		PUSH	SI
		PUSH	CX
		
		MOV		AX, [BP+8] 	; Ancho de la pista
		PUSH	AX
		PUSH	WORD PTR [BP+12]
		CALL	RELLENO_CARACTER
		ADD		SP, 4
		
		POP		CX
		POP		SI
		INC		WORD PTR [SI]
		LOOP	DIBUJAR_CUADRO_RELLENO_CICLO
	ADD		SP, 4
	
	; PILA - Regresar al estado inicial
	POP		BX
	POP		BP
	RET
DIBUJAR_CUADRO_RELLENO	ENDP

; --------------------------------------------------------------- ;
; Dibuja un cuadro vacío en la posición dada.
; @param [WORD]: Posición x
; @param [WORD]: Posición y
; @param [WORD]: Longitud
; @param [WORD]: Altura
; @param [BYTE]: Caracter a utilizar
; --------------------------------------------------------------- ;
DIBUJAR_CUADRO_VACIO	PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	
	; Dibuja un cuadro relleno primero del tamaño
	PUSH	WORD PTR [BP+12]
	PUSH	WORD PTR [BP+10]
	PUSH	WORD PTR [BP+8]
	PUSH	WORD PTR [BP+6]
	PUSH	WORD PTR [BP+4]
	CALL	DIBUJAR_CUADRO_RELLENO
	
	; Dibuja un cuadro con espacios del tamaño (n-2) en la posicion (x+1, y+1)
	MOV		SI, SP
	MOV		WORD PTR [SI+8], ' '
	SUB		WORD PTR [SI+6], 2		; Altura-2
	SUB		WORD PTR [SI+4], 2		; Longitud-2
	ADD		WORD PTR [SI+2], 1		; Posición y+1
	ADD		WORD PTR [SI], 1		; Posición x+1
	CALL	DIBUJAR_CUADRO_RELLENO
	
	ADD		SP, 10
	
	; PILA - Regresar al estado inicial
	POP		BX
	POP		BP
	RET
DIBUJAR_CUADRO_VACIO	ENDP

; ------------------------------- ;
; Esta función realiza una pausa.
; ------------------------------- ;
PAUSA	PROC NEAR
	XOR AH,AH
	INT 16H	
	RET
PAUSA	ENDP

; --------------------------------------------------------- ;
; Restringe un valor a los límites dados. Las comparaciones
; son realizadas con signo.
; @param [WORD]: Valor
; @param [WORD]: Límite inferior
; @param [WORD]: Límite superior
; @return [AX]: Valor restringido
; --------------------------------------------------------- ;
RESTRINGIR_VALOR	PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	
	MOV		AX, [BP+4]		; Coloca el valor en AX
	
	; Compara el límite inferior
	CMP		AX, [BP+6]
	JL		RESTRINGIR_INFERIOR
	
	; Compara el límite superior
	CMP		AX, [BP+8]
	JG		RESTRINGIR_SUPERIOR
	JMP		RESTRINGIR_FIN
	
	RESTRINGIR_INFERIOR:
		MOV		AX, [BP+6]
		JMP		RESTRINGIR_FIN
		
	RESTRINGIR_SUPERIOR:
		MOV		AX, [BP+8]
	
	RESTRINGIR_FIN:
	
	; PILA - Regresar al estado inicial
	POP		BX
	POP		BP
	RET
RESTRINGIR_VALOR	ENDP

