;###########################################;
;Universidad del Valle de Guatemala			;
;Organizaci�n de computadoras y Assembler	;
;											;
; Librer�a con varias utilidades de consola.;
;											;
;Eddy Omar Castro J�uregui - 11032			;
;Jorge Luis Mart�nez Bonilla - 11237		;
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
; Limpia un cuadro en pantalla con los par�metros dados.
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
	
	MOV		AH,	06H		; Funci�n 06H
	
	MOV		AL, 01d		; Calcular la cantidad de l�neas
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

	MOV		AH, 2		; Utiliza funci�n 2 para ir a x,y
	MOV		BH, 0		; Muestra p�gina 0
	MOV		DH, [BP+6]	; Mueve la coordenada y
	MOV		DL, [BP+4]	; Mueve la coordenada x
	INT		10h			; Interrupci�n de DOS
	
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
; ; Este procedimiento regresa un n�mero aleatorio de 1-6.
; ; @return [AL]: Valor aleatorio generado
; ; ------------------------------------------------------;
; ALEATORIO PROC NEAR
	; ; Leer el reloj de la m�quina
	; MOV		AH, 2CH
	; INT		21H
	
	; ; Realizar divisi�n dentro de 6
	; MOV 	AX, 0
	; MOV 	AL, DL
	; IDIV	SEIS
	
	; ; Utilizar residuo
	; INC		AH
	; MOV		AL, AH

	; RET
; ALEATORIO ENDP

; ; -------------------------------------------------- ;
; ; Toma un n�mero aleatorio entre 1 y 6, y lo muestra
; ; en pantalla.
; ; @return [AX]: N�mero aleatorio generado
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
; Dibuja un cuadro relleno en la posici�n dada, del tama�o dado.
; @param [WORD]: Posici�n x
; @param [WORD]: Posici�n y
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
							; para cada l�nea.
	MOV		CX, [BP+10]		; L�neas a escribir
	
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
; Dibuja un cuadro vac�o en la posici�n dada.
; @param [WORD]: Posici�n x
; @param [WORD]: Posici�n y
; @param [WORD]: Longitud
; @param [WORD]: Altura
; @param [BYTE]: Caracter a utilizar
; --------------------------------------------------------------- ;
DIBUJAR_CUADRO_VACIO	PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	
	; Dibuja un cuadro relleno primero del tama�o
	PUSH	WORD PTR [BP+12]
	PUSH	WORD PTR [BP+10]
	PUSH	WORD PTR [BP+8]
	PUSH	WORD PTR [BP+6]
	PUSH	WORD PTR [BP+4]
	CALL	DIBUJAR_CUADRO_RELLENO
	
	; Dibuja un cuadro con espacios del tama�o (n-2) en la posicion (x+1, y+1)
	MOV		SI, SP
	MOV		WORD PTR [SI+8], ' '
	SUB		WORD PTR [SI+6], 2		; Altura-2
	SUB		WORD PTR [SI+4], 2		; Longitud-2
	ADD		WORD PTR [SI+2], 1		; Posici�n y+1
	ADD		WORD PTR [SI], 1		; Posici�n x+1
	CALL	DIBUJAR_CUADRO_RELLENO
	
	ADD		SP, 10
	
	; PILA - Regresar al estado inicial
	POP		BX
	POP		BP
	RET
DIBUJAR_CUADRO_VACIO	ENDP

; ------------------------------- ;
; Esta funci�n realiza una pausa.
; ------------------------------- ;
PAUSA	PROC NEAR
	XOR AH,AH
	INT 16H	
	RET
PAUSA	ENDP

; --------------------------------------------------------- ;
; Restringe un valor a los l�mites dados. Las comparaciones
; son realizadas con signo.
; @param [WORD]: Valor
; @param [WORD]: L�mite inferior
; @param [WORD]: L�mite superior
; @return [AX]: Valor restringido
; --------------------------------------------------------- ;
RESTRINGIR_VALOR	PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	
	MOV		AX, [BP+4]		; Coloca el valor en AX
	
	; Compara el l�mite inferior
	CMP		AX, [BP+6]
	JL		RESTRINGIR_INFERIOR
	
	; Compara el l�mite superior
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

