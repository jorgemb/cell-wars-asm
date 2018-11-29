;###########################################;
;Universidad del Valle de Guatemala			;
;Organización de computadoras y Assembler	;
;											;
; Biblioteca que contiene las funciones para;
; la impresión del menú del juego. Utiliza  ;
; el mouse como entrada						;
;											;
;Eddy Omar Castro Jáuregui - 11032			;
;Jorge Luis Martínez Bonilla - 11237		;
;###########################################;

; ---------------------------------------------------;
; Este procedimiento realiza todo el manejo de menu.
; ---------------------------------------------------;
MOSTRAR_MENU PROC NEAR
	
	.DATA
	
	BANDERA_MOUSE	DB	0D
	
	.CODE
	MENU_ACTIVO:
	PUSH	0010H	; Atributo
	PUSH	184FH	; Esquina inferior derecha (24,79)
	PUSH	0000H	; Esquina superior izquierda (0, 0)
	CALL	CLEAR_SCREEN_SQUARE
	ADD		SP, 6
	
	CALL	IMPRESION_MENU
	CALL	IMPRESION_SELECCION
	CALL	MOSTRAR_CURSOR	
	
	MOV		AX, 4D
	MOV		CX, 380D
	MOV		DX, 96D
	INT		33H
	
	CALL	CICLO_DETERMINAR_MOUSE
	MOV		BANDERA_MOUSE, 0D
	
	JMP		MENU_ACTIVO
		
	RET

MOSTRAR_MENU ENDP


; ---------------------------------------------------;
; Este procedimiento imprime los cuadros de seleccion
; ---------------------------------------------------;
IMPRESION_SELECCION PROC NEAR

	; Contador de lineas
	MOV		DX, 26
	IMPRESION_SELECCION_CICLOX:
		MOV		CX, 03D
		MOV		AX, 10	
		IMPRESION_SELECCION_CICLOY:
			; Mete los registros a la pila para ser recuperados después
			PUSHA
			
			PUSH	AX
			PUSH	DX
			CALL	GOTOXY
			ADD		SP, 4
			
			MOV		AH, 8H
			MOV		BH, 0D
			INT		10H
					
			CALL 	PONER_ESPACIO_ROJO	
				
			; Recupera los registros de la pila
			POPA
			
			INC		AX
			INC		AX
		LOOP	IMPRESION_SELECCION_CICLOY	
		DEC	DX
		CMP	DX, 08
	JNE	IMPRESION_SELECCION_CICLOX
	RET

IMPRESION_SELECCION ENDP


; ---------------------------------------------------;
; Este procedimiento imprime los cuadros de seleccion
; ---------------------------------------------------;
CICLO_DETERMINAR_MOUSE PROC NEAR

	NO_SELECCION:
	CALL	DATOS_MOUSE
	CALL	DETERMINAR_OPCION

	CMP		BANDERA_MOUSE, 0D
	JE		NO_SELECCION
	
	RET

CICLO_DETERMINAR_MOUSE ENDP

; ----------------------------------------------------;
; Este procedimiento determina la opcion seleccionada
; ----------------------------------------------------;
DETERMINAR_OPCION PROC NEAR

	CMP	CLICK_IZQUIERDO, 1D
	JNE	SALIR_DETERMINAR
	CMP	POSICION_X, 26D
	JG	SALIR_DETERMINAR
	CMP	POSICION_X, 09D
	JL	SALIR_DETERMINAR
	CMP	POSICION_Y, 10D
	JE	SELECC_INSTRUC
	CMP	POSICION_Y, 12D
	JE	SELECC_JUGAR	
	CMP	POSICION_Y, 14D
	JE	SELECC_SALIDA

	JNE	SALIR_DETERMINAR

	SELECC_INSTRUC:
	CALL	IMP_INSTRUCCIONES
	MOV		BANDERA_MOUSE, 1D	
	JMP		SALIR_DETERMINAR
	
	SELECC_JUGAR:
	CALL	OCULTAR_CURSOR
	CALL	INICIALIZAR_JUEGO
	CALL	JUGAR
	MOV		BANDERA_MOUSE, 1D
	JMP		SALIR_DETERMINAR
	
	SELECC_SALIDA:
	CALL	SALIR
	
	SALIR_DETERMINAR:
	RET

DETERMINAR_OPCION ENDP

; ----------------------------------------------------------------- ;
; Esta funcion despliega un solo caracter enr pantalla con atributo.
; ----------------------------------------------------------------- ;
PONER_ESPACIO_ROJO	PROC NEAR
	
	MOV	AH, 09H
	;MOV	AL, 00H
	MOV	BH, 0
	MOV	BL, 47H
	MOV	CX, 01H
	INT	10H	
	
PONER_ESPACIO_ROJO ENDP

; -----------------------------------------------;
; Este procedimiento imprime el menu de opciones.
; -----------------------------------------------;
IMPRESION_MENU PROC NEAR

	.DATA
	MENU		DB	'PHAGE WARS', 0AH
				DB	'     Seleccione la opcion que desea: ', 0AH 
				DB  '     (Para seleccionar presione con el mouse la opcion deseada)$'
	OPCION1		DB	'-> Instrucciones$'
	OPCION2		DB	'-> Jugar$'
	OPCION3		DB	'-> Salir$'
	OPCIONES	DW	OPCION1, OPCION2, OPCION3

	.CODE
	PUSH 	5
	PUSH	5
	CALL 	GOTOXY		; Ir a las coordenadas seleccionadas
	ADD		SP, 4
	
	PUSH	OFFSET MENU
	CALL	COUT		; Imprimir cadena
	ADD		SP, 2
	; Imprimir las opciones del menu
	MOV		CX, 03D
	MOV		BX, OFFSET OPCIONES
	MOV		AX, 10			; Contador de lineas (empieza en la linea 10)
	IMPRESION_MENU_CICLO:
		; Mete los registros a la pila para ser recuperados después
		PUSHA
		
		PUSH	AX
		PUSH	10
		CALL	GOTOXY
		ADD		SP, 4
		
		PUSH	WORD PTR [BX]
		CALL	COUT
		ADD		SP, 2
		; Recupera los registros de la pila
		POPA
		
		INC		AX
		INC		AX
		ADD		BX, 2
		LOOP	IMPRESION_MENU_CICLO
	RET
IMPRESION_MENU ENDP


; ------------------------------------------------------------------------;
; Este procedimiento realiza la impresion de las instrucciones del juego.
; ------------------------------------------------------------------------;
IMP_INSTRUCCIONES PROC NEAR

	.DATA
	
	INSTRUCCIONES	DB	0AH
					DB	'PHAGE WARS:', 0AH, 0AH
					DB	'Este juego cuenta con celulas generadoras de virus. Cada jugador inicia con una '
					DB	'celula y su objetivo es conquistar las celulas neutras y las del oponente.      '
					DB	'Para conquistarlas debe seleccionar una celula fuente que sea de su propiedad y '
					DB	'luego una del oponente o neutral. Esta accion mandara la mitad de los virus que '
					DB	'contiene su celula a la de destino, esa cantidad de virus sera la que tendra una'
					DB	'celula neutral o la que se descontara de una celula del oponente.               '
					DB	0AH
					DB	'Adicionalmente las celulas generan virus dependiendo del tamaño que tengan, por '
					DB	'lo que las celulas grandes generan mas rapido virus. La capacidad de virus que  '
					DB	'puede tener una celula tambien varia dependiendo de su tamaño.                  '
					DB	0AH
					DB	'Al seleccionar una celula, esta se pondra de un color mas claro para que el ju- '
					DB	'gador tenga mayor facilidad de visualizar su eleccion.                          '
					DB	0AH
					DB	'Gana el primer jugador que logre dejar al oponente sin ninguna celula, pero es  '
					DB	'posible terminar el juego en cualquier momento al presionar <esc>.              '
					DB	0AH
					DB	'**Presione una tecla para continuar**$'
	
	.CODE
	
	CALL	OCULTAR_CURSOR
	
	CALL	CLEAR_SCREEN
	
	PUSH	0
	PUSH	0
	CALL	GOTOXY
	ADD		SP, 4	
	
	PUSH	OFFSET INSTRUCCIONES
	CALL	COUT		; Imprimir cadena de instrucciones
	ADD		SP, 2
	
	CALL	PAUSA
	
	RET

IMP_INSTRUCCIONES ENDP

; -------------------------------------------------------;
; Este procedimiento indica quien es el jugador ganador
; @param [WORD]: Posición en y
; -------------------------------------------------------;
MOSTRAR_GANADOR PROC NEAR

	.DATA
	
	VICTORIA	DB	'JUEGO TERMINADO$'
	JUGADOR1	DB 	'¡FELICITACIONES! Ha ganado jugador 1$'
	JUGADOR2	DB 	'¡FELICITACIONES! Ha ganado jugador 2$'
	
	.CODE
	; Preparar la pila
	PUSH 	BP
	MOV		BP, SP
	PUSHA

	PUSH	0101H	; Atributo
	PUSH	184FH	; Esquina inferior derecha (24,79)
	PUSH	0000H	; Esquina superior izquierda (0, 0)
	CALL	CLEAR_SCREEN_SQUARE
	ADD		SP, 6	
	
	PUSH	8
	PUSH	12
	CALL	GOTOXY
	ADD		SP, 4	
	
	PUSH	OFFSET VICTORIA
	CALL	COUT
	ADD		SP, 2
	
	PUSH	10
	PUSH	2
	CALL	GOTOXY
	ADD		SP, 4	
	
	MOV		AX, [BP+4]
	CMP		AX, 0
	JE		NO_GANADOR
	CMP		AX, 1
	JE		GANA1
	CMP		AX, 2
	JE		GANA2
	JMP		NO_GANADOR
	GANA1:
	PUSH	OFFSET JUGADOR1
	CALL	COUT
	ADD		SP, 2
	JMP		NO_GANADOR
	GANA2:
	PUSH	OFFSET JUGADOR2
	CALL	COUT
	ADD		SP, 2
	
	NO_GANADOR:
	CALL	PAUSA
	
	; Regresar la pila
	POPA
	POP	BP
	RET

MOSTRAR_GANADOR ENDP


