;###########################################;
;Universidad del Valle de Guatemala			;
;Organizaci�n de Computadoras y Assembler	;
;											;
; Este lugar contiene el punto de entrada	;
; del juego en s�, junto con el ciclo		;
; del mismo.								;
;											;
;Eddy Omar Castro J�uregui - 11032			;
;Jorge Luis Mart�nez Bonilla - 11237		;
;###########################################;

.DATA
	; Marca cada vez que hay un cambio de un segundo en el tiempo
	TIEMPO_CAMBIO_SEGUNDO		DB	0
	TIEMPO_SEGUNDO_ANTERIOR		DB	0
.CODE

; ------------------------------------------- ;
; Obtiene el tiempo del sistema y pone en AX 
; ------------------------------------------- ;
OBTENER_TIEMPO PROC NEAR
	; Guarda los registros
	PUSH	CX
	PUSH	DX
	
	; .. obtiene el tiempo del sistema en cent�simas de segundo
	MOV		AH, 2CH
	INT		21H
	
	; .. actualiza el cambio de segundo
	CMP		DH, TIEMPO_SEGUNDO_ANTERIOR
	JE		TIEMPO_NO_CAMBIO
	MOV 	TIEMPO_CAMBIO_SEGUNDO, 01H
	JMP		TIEMPO_CAMBIO_FIN
	TIEMPO_NO_CAMBIO:
	MOV		TIEMPO_CAMBIO_SEGUNDO, 00H
	TIEMPO_CAMBIO_FIN:
	MOV		TIEMPO_SEGUNDO_ANTERIOR, DH
	
	; .. calcula la cantidad de cent�simas por los segundos
	MOV		AL, DH		; AL = Segundos
	MOV		AH, 100		;
	MUL		AH			; AX = Segundos * 100
	
	MOV		DH, 0
	ADD		AX, DX		; AX = (Segundos*100) + Centesimas
	
	; Reestablece los registros
	POP		DX
	POP		CX
	RET
OBTENER_TIEMPO ENDP

; ------------------------------------------------- ;
; Actualiza el delta del tiempo para cada Frame.
; DELTA y ANTERIOR son variables de tipo WORD.
; CORRECCION debe de ser un valor inmediato.
; ------------------------------------------------- ;
ACTUALIZAR_TIEMPO MACRO DELTA, ANTERIOR, CORRECCION
	LOCAL   NO_CORREGIR

	; Guarda los registros
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	
	; Obtiene el tiempo actual
	CALL 	OBTENER_TIEMPO
	CMP		AX, ANTERIOR
	JGE		NO_CORREGIR
	
	; ..realizar correcci�n del tiempo
	SUB 	ANTERIOR, CORRECCION
	
	; .. calcula el delta
	NO_CORREGIR:
	MOV		BX, AX
	SUB		BX, ANTERIOR
	MOV		DELTA, BX
	MOV		ANTERIOR, AX
	
	; Reestablece los registros
	POP		DX
	POP		CX
	POP		BX
	POP		AX
ENDM
; ------------------------------------------------- ;

; --------------------------------------- :
; Contiene el punto de entrada del juego.
; --------------------------------------- :
PLAY_GAME PROC NEAR
.DATA
	TIEMPO_CORRECCION	EQU	6000d
.CODE
	; Inicializa el tiempo y variables del juego
	MOV		DELTA_TIME, 1
	MOV		GAME_ACTIVE, 1
	;CALL 	VIRUS_INICIALIZAR
	CALL	CAMBIAR_MODO_GRAFICO
	
	; .. obtiene el tiempo del sistema
	CALL	OBTENER_TIEMPO
	MOV		PREVIOUS_TIME, AX
	
	; Inicio del ciclo
	CICLO_JUGAR:
		
		; Actualiza todos los sistemas
		CALL 	ACTUALIZAR_ENTRADA
		CALL 	ACTUALIZAR_LOGICA
		CALL 	ACTUALIZAR_GRAFICOS
		
		; Calcula el delta del tiempo
		ACTUALIZAR_TIEMPO 	DELTA_TIME, PREVIOUS_TIME, TIEMPO_CORRECCION
		FILD	DELTA_TIME
		FILD	TIME_DIVIDEND
		FDIV
		FSTP	PREVIOUS_TIME_F
		
		; Revisa las condiciones de victoria
		; Si alguien gana entonces se sale del juego
		CALL	REVISAR_VICTORIA
		CMP		AX, 00
		JNE		JUGAR_FIN
		
		CMP		GAME_ACTIVE, 0
		JNE		CICLO_JUGAR
	
	JUGAR_FIN:
	PUSH	AX
	CALL	CLEAN_KEYBOARD
	POP		AX
	
	PUSH	AX
	CALL	SHOW_WINNER
	ADD		SP, 2
	
	CALL	HIDE_CURSOR		
	CALL	CAMBIAR_MODO_TEXTO
	RET
PLAY_GAME ENDP

; ------------------------------ ;
; Inicializa los datos del juego
; ------------------------------ ;
GAME_INIT PROC NEAR
	; Inicializa los virus
	CALL	VIRUS_INICIALIZAR
	CALL	SHOW_CURSOR
	
	; Inicializa los PHAGES
	CALL	PHAGES_INITIALIZE
	
	RET
GAME_INIT ENDP

; Determina si alguno de los dos jugadores ha ganado/perdido
; el juego.
; @return [AX]: Regresa 00 si ninguno ha ganado, 01 si gan�
; el jugador uno y 02 si gan� el jugador dos.
REVISAR_VICTORIA PROC NEAR
	; Guardar registros
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	PUSH	DI
	
	; Itera por cada fago para verificar a qu� jugador
	; pertenece cada uno. Si un jugador no posee ning�n fago
	; entonces pierde.
	MOV		SI, 0			; Jugador 1
	MOV		DI, 0			; Jugador 2
	MOV		CX, PHAGE_QUANTITY
	VICTORIA_CICLO:
		; Obtiene la direcci�n del fago
		MOV		DX, CX
		DEC		DX
		PHAGE_ADDRESS DX		; La direcci�n del fago en BX
		
		; Revisa de qu� jugador es
		MOV			AL, BYTE PTR PHAGE_PLAYER[BX]
		CMP			AL, 0FFH
		JE			VICTORIA_FIN_CICLO
		
		SHR			AL, 1			; Obtiene el ID del jugador
		CMP			AL, 00H
		JNE			VICTORIA_INC_J2
			; Incrementa a Jugador 1
			INC		SI
			JMP		VICTORIA_FIN_CICLO
		
		VICTORIA_INC_J2:
			; Incrementa a Jugador 2
			INC		DI
		
		VICTORIA_FIN_CICLO:
		LOOP	VICTORIA_CICLO
	
	; Compara si alguno tiene cero PHAGES
	MOV		AX, 0
	
	; .. J1
	CMP		SI, 0
	JE		VICTORIA_J2
	
	; .. J2
	CMP		DI, 0
	JE		VICTORIA_J1
	
	JMP		VICTORIA_FIN
	
	VICTORIA_J2:
	MOV		AX, 02
	JMP		VICTORIA_FIN
	
	VICTORIA_J1:
	MOV		AX, 01
	JMP		VICTORIA_FIN
	
	VICTORIA_FIN:
	; Reestablecer registros
	POP		DI
	POP		SI
	POP		DX
	POP		CX
	POP		BX
	RET
REVISAR_VICTORIA ENDP

; ---------------------------------------------------- ;
; Actualiza los elementos de entrada: Mouse y Teclado
; ---------------------------------------------------- ;
ACTUALIZAR_ENTRADA PROC NEAR
	; Verifica el teclado y el mouse
	CALL ACTUALIZAR_TECLADO
	CALL ACTUALIZAR_MOUSE
	
	RET
ACTUALIZAR_ENTRADA ENDP

; Act�a conforme se presionen las teclas del jugador 
; uno para enviar virus de un fago a otro.
ACTUALIZAR_TECLADO PROC NEAR
	PUSHA
	; Verifica el estado del teclado
	PUSH	0
	CALL	GETC_EXTENDED
	ADD		SP, 2
	
	CMP		AL, 0
	JE		ACTUALIZAR_TECLADO_FIN
	
	; ESCAPE - Finaliza el juego
	CMP		AL, 27
	JNE		ACTUALIZAR_ENTRADA_ESC
	MOV		GAME_ACTIVE, 0	
	JMP		ACTUALIZAR_TECLADO_FIN
	
	ACTUALIZAR_ENTRADA_ESC:
	
	MOV		DH, 0
	MOV		DL, AL
	
	; Determina si la tecla que se presion� es un n�mero
	BP2:
	PUSH	30H		; Menor
	PUSH	39H		; Mayor
	PUSH	DX		; Tecla
	CALL	VERIFY_VALUE
	ADD		SP, 6
	
	CMP		AH, 0
	JE		ACTUALIZAR_TECLADO_SHIFT
	
	; Lo que se presiono es un n�mero sin shift
	; .. selecciona el fago
	SUB		DX, 30H
	PUSH	DX
	PUSH	0
	CALL	FAGO_SELECCIONAR
	ADD		SP, 4
	JMP		ACTUALIZAR_TECLADO_FIN
	
	ACTUALIZAR_TECLADO_SHIFT:
	; Verifica si los c�digos son los de shift
	PUSH	20H		; Menor
	PUSH	29H		; Mayor
	PUSH	DX		; Tecla
	CALL	VERIFY_VALUE
	ADD		SP, 6
	
	CMP		AH, 0
	JNE		ACTUALIZAR_TECLADO_ENVIAR
	
	; ..revisar los casos especiales de 7 y 0
	CMP		DL, 2FH
	JNE		TECLADO_CASO_CERO
	MOV		DL, 27H
	JMP		ACTUALIZAR_TECLADO_ENVIAR
	
	TECLADO_CASO_CERO:
	CMP		DL, 3DH
	JNE		ACTUALIZAR_TECLADO_FIN
	MOV		DL, 20H
	JMP		ACTUALIZAR_TECLADO_ENVIAR
	
	; .. manda los virus al fago objetivo
	ACTUALIZAR_TECLADO_ENVIAR:
	SUB		DL, 20H
	
	PUSH	0
	CALL	FAGO_OBTENER_SELECCIONADO
	ADD		SP, 2
	
	CMP		AX, 0FFH
	JE		ACTUALIZAR_TECLADO_FIN
	CMP		AX, DX
	JE		ACTUALIZAR_TECLADO_FIN
	
	PUSH	DX
	PUSH	AX
	CALL	FAGOS_MOVILIZAR_VIRUS
	ADD		SP, 4

	ACTUALIZAR_TECLADO_FIN:
	POPA
	RET
ACTUALIZAR_TECLADO ENDP

; Actualiza el mouse en pantalla, y act�a si se presiona
; clic izquierdo o derecho sobre un fago.
ACTUALIZAR_MOUSE PROC NEAR
	; Guardar registros
	PUSHA

	CALL	MOUSE_DATA
	
	; Se guardan los datos del mouse en su pseudo-virus
	MOV		BX, OFFSET MOUSE_PSEUDOVIRUS
	MOV		AX, WORD PTR PIXELPOS_X
	SHR		AX, 1
	MOV		WORD PTR PIXELPOS_X, AX
	FILD	WORD PTR PIXELPOS_X
	FSTP	DWORD PTR VIRUS_X[BX]
	
	FILD	WORD PTR PIXELPOS_Y
	FSTP	DWORD PTR VIRUS_Y[BX]
	
	; Verificar estado de los botones
	; .. mouse izquierdo
	CMP		LEFT_CLICK, 01H
	JNE		ACTUALIZAR_MOUSE_DERECHO
	
	PUSH	OFFSET MOUSE_PSEUDOVIRUS
	CALL	VIRUS_COLISION_FAGO_MOUSE
	ADD		SP, 2
	
	CMP		AH, 01
	JNE		ACTUALIZAR_MOUSE_DERECHO
	
	; .. selecciona el fago para el jugador 2
	MOV		AH, 0
	PUSH	AX
	PUSH	1
	CALL 	FAGO_SELECCIONAR
	ADD		SP, 4
	
	ACTUALIZAR_MOUSE_DERECHO:
	; .. verifica el clic derecho
	CMP		RIGHT_CLICK, 01H
	JNE		ACTUALIZAR_MOUSE_FIN
	
	PUSH	OFFSET MOUSE_PSEUDOVIRUS
	CALL	VIRUS_COLISION_FAGO_MOUSE
	ADD		SP, 2
	
	CMP		AH, 01
	JNE		ACTUALIZAR_MOUSE_FIN
	
	; .. env�a virus del fago seleccionado al objetivo
	MOV		AH, 0
	MOV		DX, AX		; DX contiene el fago destino
	
	PUSH	1
	CALL	FAGO_OBTENER_SELECCIONADO
	ADD		SP, 2
	
	; .. revisa que no sea el mismo fago el fuente/destino
	CMP		AX, DX
	JE		ACTUALIZAR_MOUSE_FIN
	
	; .. revisa que exista un fago seleccionado
	CMP		AX, 0FFH
	JE		ACTUALIZAR_MOUSE_FIN
	
	; .. activa los virus
	PUSH	DX
	PUSH	AX
	CALL	FAGOS_MOVILIZAR_VIRUS
	ADD		SP, 4
	
	ACTUALIZAR_MOUSE_FIN:
	; Reestablecer registros
	POPA
	RET
ACTUALIZAR_MOUSE ENDP

; ---------------------------------------------------- ;
; Actualiza toda la simulaci�n de los elementos del
; juego.
; ---------------------------------------------------- ;
ACTUALIZAR_LOGICA PROC NEAR
	; Actualiza los virus
	; Actualiza los virus
	CALL 	VIRUS_ACTUALIZAR
	
	; Actualiza los PHAGES cada segundo
	CMP		TIEMPO_CAMBIO_SEGUNDO, 00H
	JE		LOGICA_NO_FAGOS
	CALL	FAGOS_ACTUALIZAR
	LOGICA_NO_FAGOS:
	
	RET
ACTUALIZAR_LOGICA ENDP

; ---------------------------------------------------- ;
; Pinta la pantalla para actualizar los objetos del
; juego a sus nuevas posiciones.
; ---------------------------------------------------- ;
ACTUALIZAR_GRAFICOS PROC NEAR
	PUSHA

	; Borra lo que hab�a en pantalla
	; MOV		AX, 00H
	; MOV		DI, 0000H
	; MOV		CX, 64000
	; REP		STOSB
	LIMPIAR_BUFFER DBUFFER, 64000, 0FFH
	; LIMPIAR_BUFFER 0A000H, 64000, 0FFH
	
	; Itera por cada uno de los virus y los dibuja
	MOV		CX, VIRUS_QUANTITY
	ACTUALIZAR_GRAFICOS_CICLO:	
		; Obtiene la direcci�n del virus
		VIRUS_DIRECCION	CX
		SUB		BX, VIRUS_SIZE	; Correcci�n de posici�n
		; Verifica si el virus es v�lido
		VIRUS_VALIDO BX
		JZ		ACTUALIZAR_GRAFICOS_CICLO_FIN
		MOVZX	DX, BYTE PTR VIRUS_SOURCE[BX]
		
		; Obtiene la posici�n del virus, copia PosX en BX y PosY en AX
		VIRUS_POSICION BX, BX, AX
		
		; .. DIBUJAR ACA
		PUSH	BX
		PHAGE_ADDRESS DX		
		MOVZX	DX, BYTE PTR PHAGE_PLAYER[BX]
		POP		BX	
		SHR		DX, 1
		CMP		DX, 0
		JE		JUG_1
		DIBUJAR_VIRUS BX, AX, 2FH
		JMP ACTUALIZAR_GRAFICOS_CICLO_FIN
		JUG_1:
		DIBUJAR_VIRUS BX, AX, 29H
		
		ACTUALIZAR_GRAFICOS_CICLO_FIN:
	LOOP ACTUALIZAR_GRAFICOS_CICLO
	
	; Dibuja los PHAGES
	MOV		CX, PHAGE_QUANTITY
	ACTUALIZAR_FAGOS_CICLO:
		; Obtiene la direcci�n del fago
		PHAGE_ADDRESS	CX
		SUB		BX, PHAGE_SIZE	; Correcci�n de posici�n
	
		; Verificar si el fago se debe de dibujar
		CMP		WORD PTR PHAGE_IMAGE[BX], 0
		JE		ACTUALIZAR_FAGO_NO_DIBUJO
	
		MOVZX	DX, BYTE PTR PHAGE_PLAYER[BX]
		PUSH	DX
		PUSH	WORD PTR PHAGE_Y[BX]
		PUSH	WORD PTR PHAGE_X[BX]
		PUSH 	WORD PTR PHAGE_IMAGE[BX]
		CALL	DIBUJAR_FAGO
		ADD		SP, 8
			
		PUSH	WORD PTR PHAGE_Y[BX]
		PUSH	WORD PTR PHAGE_X[BX]
		PUSH 	WORD PTR PHAGE_NVIRUS[BX]
		CALL	IMPRIMIR_CANTIDAD_VIRUS
		ADD		SP, 6		
	
		ACTUALIZAR_FAGO_NO_DIBUJO:
	LOOP ACTUALIZAR_FAGOS_CICLO	
	
	; Dibuja la posici�n del mouse utilizando su pseudo-virus
	MOV		BX, OFFSET MOUSE_PSEUDOVIRUS	
	; ..Obtiene la posici�n del virus, copia PosX en BX y PosY en AX
	VIRUS_POSICION BX, BX, AX
	DIBUJAR_VIRUS BX, AX, 64H
	
	
	; Copiar los datos del buffer (Double Buffering)
	BLIT_BUFFER DBUFFER, 0A000H, 64000
	
	POPA
	RET
ACTUALIZAR_GRAFICOS ENDP


