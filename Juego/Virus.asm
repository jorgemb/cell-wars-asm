;###########################################;
;Universidad del Valle de Guatemala			;
;Organizaci�n de Computadoras y Assembler	;
;											;
; Contiene toda la l�gica para simular los	;
; virus en pantalla.						;
;											;
;Eddy Omar Castro J�uregui - 11032			;
;Jorge Luis Mart�nez Bonilla - 11237		;
;###########################################;

.DATA
	; Variables de uso general para manejar punto flotante
	FP1					DD		0
	FP2					DD		0
	FP3					DD		0
	FP4					DD		0
	
	; Variable que contiene el m�ximo que se puede mover un
	; virus al azar fuera del centro
	; (Aleatorizar las posiciones iniciales de los virus)
	VIRUS_MAX_DISTANCIA	DD		0.7071067


.CODE
; Verifica si un virus es v�lido o no.
; Deja la ZF activa si el virus no es v�lido.
VIRUS_VALIDO MACRO DIR_VIRUS
	CMP		BYTE PTR VIRUS_PHAGE[DIR_VIRUS], 0FFH
ENDM

; Devuelve la posici�n del virus en los registros dados.
VIRUS_POSICION MACRO DIR_VIRUS, REG_POSX, REG_POSY
	FLD		DWORD PTR VIRUS_X[DIR_VIRUS]
	FISTP	DWORD PTR FP1
	FLD		DWORD PTR VIRUS_Y[DIR_VIRUS]
	FISTP	DWORD PTR FP2
	
	MOV		REG_POSX, WORD PTR FP1
	MOV		REG_POSY, WORD PTR FP2
ENDM

; Devuelve la direcci�n de un virus dado su ID, el ID
; deve de estar en un registro o en memoria (y no puede ser AX)
; Devuelve la direcci�n en BX.
VIRUS_DIRECCION MACRO ID_VIRUS
	; Guarda los registros
	PUSH	AX
	PUSH	DX

	MOV		AX, VIRUS_SIZE
	MUL		ID_VIRUS
	
	LEA		BX, VIRUS
	ADD		BX, AX
	
	; Reestablece los registros
	POP		DX
	POP		AX
ENDM

; Activa el virus dado, posicion�ndolo en el fago fuente y
; asign�ndole el id del fago destino.
; @param [WORD]: Direcci�n del virus a activar
; @param [WORD]: ID del Fago fuente
; @param [WORD]: ID del fago destino
VIRUS_ACTIVAR_UNICO PROC NEAR
	; Prepara la pila
	PUSH	BP
	MOV		BP, SP
	PUSHA

	; Obtener la direcci�n del fago fuente y del virus
	MOV		DX, [BP+6]		; ID fago fuente
	FAGO_DIRECCION DX		; Direcci�n en BX
	MOV		SI, BX
	
	MOV		BX, [BP+4]		; Direcci�n del Virus
	
	; Coeficiente de aleatoridad
	FLD		DWORD PTR VIRUS_MAX_DISTANCIA
	
	; Posicion inicial del virus
	; .. numero al azar
	MOVSX	DX, BYTE PTR PHAGE_RADIUS[SI]
	PUSH	DX
	CALL	RANDOM_RANGE	
	ADD		SP, 2
	
	MOV		WORD PTR FP3, AX
	FILD	WORD PTR FP3				; Valor en rango [-radio, radio]
	FMUL	ST, ST(1)					; Rango * Coeficiente
	
	MOV		AX, WORD PTR PHAGE_X[SI]
	MOV		WORD PTR FP1, AX
	FILD	WORD PTR FP1
	FADD								; X +- Aleatorio
	FSTP	DWORD PTR VIRUS_X[BX]
	
	; .. numero al azar
	MOVSX	DX, BYTE PTR PHAGE_RADIUS[SI]
	PUSH	DX
	CALL	RANDOM_RANGE
	ADD		SP, 2

	MOV		WORD PTR FP3, AX
	FILD	WORD PTR FP3				; Valor en rango [-radio, radio]
	FMUL								; Rango * Coeficiente
	
	MOV		AX, WORD PTR PHAGE_Y[SI]
	MOV		WORD PTR FP1, AX
	FILD	WORD PTR FP1
	FADD								; Y +- Aleatorio
	FSTP	DWORD PTR VIRUS_Y[BX]
	
	; Asignar fago destino
	MOV		AX, [BP+8]					; ID fago destino
	MOV		BYTE PTR VIRUS_PHAGE[BX], AL
	
	; Asignar fago fuente
	MOV		AX, [BP+6]					; ID fago fuente
	MOV		BYTE PTR VIRUS_SOURCE[BX], AL
	
	; Reestablece la pila
	POPA
	POP		BP
	RET
VIRUS_ACTIVAR_UNICO ENDP

; ------------------------------------------ ;
; Inicializa todos los virus como inactivos.
; ------------------------------------------ ;
VIRUS_INICIALIZAR PROC NEAR
	PUSHA
	
	MOV		CX, VIRUS_QUANTITY
	VIRUS_INICIALIZAR_CICLO:
		VIRUS_DIRECCION CX
		SUB		BX, VIRUS_SIZE	; Correcci�n
		
		MOV		BYTE PTR VIRUS_PHAGE[BX], 0FFH
		LOOP	VIRUS_INICIALIZAR_CICLO
	
	POPA
	RET
VIRUS_INICIALIZAR ENDP

; Activa una cantidad especificada de virus para que se salgan del fago
; dado y se dirijan al objetivo.
; @param [WORD]: Cantidad de virus a activar
; @param [WORD]: ID fago destino
; @param [WORD]: ID fago fuente
VIRUS_ACTIVAR PROC NEAR
	; Prepara la pila
	PUSH	BP
	MOV		BP, SP
	PUSHA
	
	; .. direcci�n del fago fuente
	MOV		AX, [BP+8]
	MOV		DX, PHAGE_SIZE
	MUL		DX
	LEA		SI, PHAGES
	ADD		SI, AX
	
	MOV		DX, [BP+4]			; Cantidad de virus a activar
	MOV		CX, VIRUS_QUANTITY	
	
	VIRUS_ACTIVAR_CICLO:
		; Revisa si el virus actual es v�lido
		VIRUS_DIRECCION CX
		SUB		BX, VIRUS_SIZE	; Correcci�n ya que CX est� en el rango [1, 1000]
		
		VIRUS_VALIDO BX
		JNZ 	VIRUS_ACTIVAR_CICLO_FIN
		
		; Activa el virus actual
		PUSH	WORD PTR [BP+6]		; ID fago destino
		PUSH	WORD PTR [BP+8]		; ID fago fuente
		PUSH	BX					; Direcci�n virus
		CALL	VIRUS_ACTIVAR_UNICO
		ADD		SP, 6
		
		DEC		DX
		JZ		VIRUS_ACTIVAR_FIN
		
		VIRUS_ACTIVAR_CICLO_FIN:
		LOOP VIRUS_ACTIVAR_CICLO
	
	VIRUS_ACTIVAR_FIN:
	
	; Reestablece la pila
	POPA
	POP		BP
	RET
VIRUS_ACTIVAR ENDP

; Mueve un virus en la direcci�n tangente al fago dado. Este se calcula
; con la siguiente formula: Vx/Vy * Tx = -Ty donde Tx se especifica
; con un valor arbitrario y V es el vector direcci�n normalizado del
; virus al fago.
; @param [WORD]: Direcci�n del virus a mover
; @param [WORD]: ID del fago que se desea bordear
VIRUS_MOVER_TANGENTE PROC NEAR
	; Preparar pila
	PUSH	BP
	MOV		BP, SP
	PUSHA
	
	; Se obtiene el vector direcci�n del virus al fago dado
	MOV		SI, [BP+4]		; Direcci�n en memoria del Virus
	MOV		DL, [BP+6]		; ID del fago
	FAGO_DIRECCION DL		; Direcci�n en memoria del Fago (en BX)
	
	PUSH	01			; Vector normalizado
	PUSH	BX			; Direcci�n fago
	PUSH	SI			; Direcci�n virus
	CALL VIRUS_VECTOR_FAGO
	ADD		SP, 6
	
	; Se empujan los componentes a la pila y se dividen Vx/Vy
	FLD		DWORD PTR FP1
	FLD		DWORD PTR FP2
	FDIV
	
	; .. y se le cambia el signo
	; Distribuir de forma 1/2 y 1/2
	MOV		AX, [BP+4]		; Direcci�n del virus
	MOV		DX, 0
	MOV		BX, 4
	DIV		BX
	CMP		DX, 2
	JAE		TANGENTE_REVES
	FCHS
	FLD1
	JMP TANGENTE_REVES_FIN
	TANGENTE_REVES:
	FLD1
	FCHS
	TANGENTE_REVES_FIN:
	
	; Con ello se obtienen para Tx=1 y Ty=-Vx/Vy
	
	FSTP	DWORD PTR FP1
	FSTP	DWORD PTR FP2
	
	; Ahora se normaliza y se avanza al virus en esa direcci�n
	PUSH	OFFSET FP1			; Destino
	PUSH	OFFSET FP1			; Fuente
	CALL	VECTOR_NORMALIZAR
	ADD		SP, 4
	
	; .. multiplicar por la velocidad
	FLD		PREVIOUS_TIME_F
	FLD		VIRUS_VELOCITY
	FMUL
	FSTP	FP3
	
	PUSH	OFFSET FP1				; Destino
	PUSH	OFFSET FP3				; Escalar
	PUSH	OFFSET FP1				; Fuente
	CALL	VECTOR_ESCALAR
	ADD		SP, 6
	
	MOV		DI, SI
	ADD		DI, VIRUS_X			; DI contiene la direcci�n posici�n del virus

	PUSH	DI					; Destino
	PUSH	OFFSET FP1			; Operando
	PUSH	DI					; Operando
	CALL	VECTOR_SUMAR
	ADD		SP, 6
	
	; Reestablecer pila
	POPA
	POP		BP
	RET
VIRUS_MOVER_TANGENTE ENDP

; Resuelve la situaci�n de un virus al colisionar con otro fago, a manera
; tal que le aumente o le disminuya la cantidad de virus dependiendo
; del due�o del mismo. Se asume que el virus colision� con su fago
; destino.
; @param [WORD]: Direcci�n del virus a resolver
VIRUS_EVOLUCION_COLISION_FAGO PROC NEAR
	; Preparar pila
	PUSH	BP
	MOV		BP, SP
	PUSHA

	; Se obtiene el ID del fago destino y del fuente
	MOV		BX, [BP+4]						; Direcci�n del virus
	MOVZX	SI, BYTE PTR VIRUS_SOURCE[BX]	; ID fago fuente
	MOVZX	DI, BYTE PTR VIRUS_PHAGE[BX]		; ID fago destino
	
	; Se obtiene el ID del jugador del fago fuente y destino
	; ..fuente
	FAGO_DIRECCION SI		; Direcci�n en BX
	MOV		SI, BX
	MOVZX	AX, BYTE PTR PHAGE_PLAYER[SI]
	
	; ..destino
	FAGO_DIRECCION DI		; Direcci�n en BX
	MOV		DI, BX
	MOVZX	DX, BYTE PTR PHAGE_PLAYER[DI]
	
	SHR		AX, 1		; Corrige ID fago 1
	SHR		DX, 1		; Corrige ID fago 2
	CMP		AX, DX
	JE		EVOLUCION_MISMO_JUGADOR
		; Los jugadores son distintos
		; Se disminuye en una unidad los virus del fago
		DEC		WORD PTR PHAGE_NVIRUS[DI]
		CMP		WORD PTR PHAGE_NVIRUS[DI], 0
		JG		VIRUS_EVOLUCION_FIN
		
		; Si la cantidad de virus es cero, entonces el fago
		; se convierte del otro jugador (due�o del fago fuente)
		MOV		AH, BYTE PTR PHAGE_PLAYER[SI]
		SHR		AH, 1
		SHL		AH, 1		; Corrige el ID del jugador (para quitar la selecci�n)
		MOV		BYTE PTR PHAGE_PLAYER[DI], AH
		MOV		WORD PTR PHAGE_NVIRUS[DI], 1
		JMP		VIRUS_EVOLUCION_FIN
	
	EVOLUCION_MISMO_JUGADOR:
		; Los jugadores son iguales
		; Se aumenta en una unidad la cantidad de virus del fago
		INC		WORD PTR PHAGE_NVIRUS[DI]
	
	VIRUS_EVOLUCION_FIN:
	
	; ..desactivar el virus
	MOV		BX, [BP+4]			; Direcci�n del virus
	MOV		BYTE PTR VIRUS_PHAGE[BX], 0FFH
	
	; Reestablecer pila
	POPA
	POP		BP
	RET
VIRUS_EVOLUCION_COLISION_FAGO ENDP

; Mueve el virus especificado en la direcci�n dada por
; el fago objetivo.
; @param [WORD]: Direcci�n del virus a mover
VIRUS_MOVER PROC NEAR
	.DATA
	; Este vector contiene lo que se mueve el virus en esta iteraci�n
	VECTOR_MOVIMIENTO	DQ	?	

	.CODE
	; Preparar pila
	PUSH	BP
	MOV		BP, SP
	PUSHA
	
	; Obtener la direcci�n del fago al virus (Se posiciona en FP1 y FP2)
	MOV		SI, [BP+4]					; Dir virus
	FAGO_DIRECCION VIRUS_PHAGE[SI]		; Dir fago en BX
	
	PUSH	01			; Vector normalizado
	PUSH	BX			; Direcci�n del fago
	PUSH	SI			; Direcci�n del virus
	CALL	VIRUS_VECTOR_FAGO
	ADD		SP, 6
	
	; Obtener el escalar de velocidad
	FLD		PREVIOUS_TIME_F
	FLD		VIRUS_VELOCITY
	FMUL
	FSTP	DWORD PTR FP3
	
	PUSH	OFFSET VECTOR_MOVIMIENTO		; Destino
	PUSH	OFFSET FP3						; Escalar
	PUSH	OFFSET FP1						; Fuente
	CALL	VECTOR_ESCALAR
	ADD		SP, 6
	
	; Sumar la direcci�n al vector posicion del virus
	MOV		DI, SI
	ADD		DI, VIRUS_X		; DI contiene la direcci�n POSX del virus
	
	PUSH	DI								; Destino
	PUSH	OFFSET VECTOR_MOVIMIENTO		; Operando
	PUSH	DI								; Operando
	CALL	VECTOR_SUMAR
	ADD		SP, 6
	
	; Revisar colisiones
	MOV		SI, [BP+4]		; Direcci�n del virus a mover
	PUSH	SI
	CALL	VIRUS_COLISION_FAGO
	ADD		SP, 2
	
	CMP		AH, 0
	JE		VIRUS_MOVER_FIN
	
	CMP		AL, 0FFH
	JNE		VIRUS_MOVER_COLISION
		; Disminuir/aumentar la cantidad de virus en el fago destino
		PUSH	SI			; Direcci�n del virus
		CALL	VIRUS_EVOLUCION_COLISION_FAGO
		ADD		SP, 2
		
	JMP		VIRUS_MOVER_FIN
	
	VIRUS_MOVER_COLISION:
	; El virus colision� con otro fago
	; .. se le resta lo que avanz� al virus
	PUSH	DI							; Destino (VIRUS_POSICION)
	PUSH	OFFSET VECTOR_MOVIMIENTO	; Sustraendo
	PUSH	DI							; Minuendo
	CALL	VECTOR_RESTAR
	ADD		SP, 6
	
	PUSH	AX				; ID del fago a bordear
	PUSH	SI				; Direcci�n del virus
	CALL	VIRUS_MOVER_TANGENTE
	ADD		SP, 4
	
	VIRUS_MOVER_FIN:
	POPA
	POP		BP
	RET
VIRUS_MOVER ENDP

; Itera por cada uno de los virus y mueve todo aquel que
; sea v�lido hacia su posici�n.
VIRUS_ACTUALIZAR PROC NEAR
	; Guardar registros
	PUSHA

	MOV		CX, VIRUS_QUANTITY
	ACTUALIZAR_VIRUS_CICLO:
		; Posici�n en memoria del virus actual
		VIRUS_DIRECCION CX
		SUB		BX, VIRUS_SIZE	; Correcci�n ya que CX est� en el rango [1, 1000]
		
		; Verificar si el virus es v�lido
		VIRUS_VALIDO BX
		JZ		ACTUALIZAR_VIRUS_CICLO_FIN
		
		; Mueve el virus hacia la posici�n objetivo
		PUSH 	BX
		CALL 	VIRUS_MOVER
		ADD		SP, 2
		
		ACTUALIZAR_VIRUS_CICLO_FIN:
		LOOP ACTUALIZAR_VIRUS_CICLO
	
	; Reestablecer registros
	POPA
	RET
VIRUS_ACTUALIZAR ENDP

