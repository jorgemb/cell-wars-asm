;###########################################;
;Universidad del Valle de Guatemala			;
;Organizaci�n de Computadoras y Assembler	;
;											;
; Contiene toda la l�gica para simular los	;
; PHAGES en pantalla, adem�s de la definici�n;
; del nivel principal.						;
;											;
;Eddy Omar Castro J�uregui - 11032			;
;Jorge Luis Mart�nez Bonilla - 11237		;
;###########################################;

.DATA
	; Definici�n de los PHAGES en el nivel
	; La estructura de los PHAGES es de la siguiente manera
	;	- byte	PosX
	;	- byte	PosY
	;	- byte	Radio
	;	- byte	Jugador Due�o (FF = Neutro, 00 � 01 = Jugador1, 02 � 03 = Jugador2)
	;	- word	Imagen
	;	- word	Cantidad de Virus
	; TOTAL: 8 bytes por fago
	
	; EJEMPLO:
	; 	FAGO	DW	000, 000		; PosX,PosY
	;			DB	00, 0FFH	; Radio, Jugador
	;			DW	0000		; Imagen
	;			DW	0000		; Virus iniciales
	
	; Inicializa todos en default
	; FAGOS_INICIAL		DQ		PHAGE_QUANTITY DUP ( 00000000FF000000H )
	
	FAGOS_INICIAL	DW	290, 170	; POSX,POSY
					DB	25, 02		; Radio, Jugador
					DW	OFFSET FAGO_1		; Imagen
					DW	0010		; Virus iniciales
					
					; Fago 1
					DW	030, 030	; PosX,PosY
					DB	25, 00		; Radio, Jugador
					DW	OFFSET FAGO_1		; Imagen
					DW	0010		; Virus iniciales
					
					; Fago 2
					DW	030, 93		; PosX,PosY
					DB	15, 0FFH	; Radio, Jugador
					DW	OFFSET FAGO_2		; Imagen
					DW	0020		; Virus iniciales
					
					; Fago 3
					DW	160, 20		; PosX,PosY
					DB	10, 0FFH	; Radio, Jugador
					DW	OFFSET FAGO_3		; Imagen
					DW	0010		; Virus iniciales
					
					; Fago 4
					DW	128, 060	; PosX,PosY
					DB	10, 0FFH	; Radio, Jugador
					DW	OFFSET FAGO_3		; Imagen
					DW	0010		; Virus iniciales
					
					; Fago 5
					DW	120, 140	; PosX,PosY
					DB	10, 0FFH	; Radio, Jugador
					DW	OFFSET FAGO_3	; Imagen
					DW	0010		; Virus iniciales
					
					; Fago 6
					DW	200, 140		; PosX,PosY
					DB	10, 0FFH	; Radio, Jugador
					DW	OFFSET FAGO_3	; Imagen
					DW	0010		; Virus iniciales
					
					; Fago 7
					DW	192, 060		; PosX,PosY
					DB	10, 0FFH	; Radio, Jugador
					DW	OFFSET FAGO_3	; Imagen
					DW	0010		; Virus iniciales
					
					; Fago 8
					DW	160, 100		; PosX,PosY
					DB	15, 0FFH	; Radio, Jugador
					DW	OFFSET FAGO_2	; Imagen
					DW	0050		; Virus iniciales
					
					; Fago 9
					DW	290, 107		; PosX,PosY
					DB	15, 0FFH	; Radio, Jugador
					DW	OFFSET FAGO_2	; Imagen
					DW	0020		; Virus iniciales

.CODE
; --------------------------------------------------- ;
; Inicializa los PHAGES con sus datos predeterminados.
; --------------------------------------------------- ;
FAGOS_INICIALIZAR PROC NEAR
	PUSHA
	
	; Copia los datos iniciales al vector de PHAGES
	MOV		SI, OFFSET FAGOS_INICIAL
	MOV		DI, OFFSET PHAGES
	
	MOV		CX, PHAGE_TOTAL_BYTES
	FAGOS_INICIALIZAR_CICLO:
		MOV	AL, BYTE PTR [SI]
		MOV BYTE PTR [DI], AL
		INC SI
		INC DI
		LOOP FAGOS_INICIALIZAR_CICLO
	
	POPA
	RET
FAGOS_INICIALIZAR ENDP

; Devuelve la direcci�n de un fago dado su ID, el ID
; deve de estar en un registro o en memoria (y no puede ser AX)
; Devuelve la direcci�n en BX.
FAGO_DIRECCION MACRO ID_FAGO
	; Guarda los registros
	PUSH	AX
	PUSH	DX

	MOV		AX, PHAGE_SIZE
	MUL		BYTE PTR ID_FAGO
	
	LEA		BX, PHAGES
	ADD		BX, AX
	
	; Reestablece los registros
	POP		DX
	POP		AX
ENDM

; Obtiene la direcci�n de un virus al fago dado. El vector es guardado
; en las posici�n de memoria FP1 y FP2.
; @param [WORD]: Direcci�n en memoria del virus
; @param [WORD]: Direcci�n en memoria del fago
; @param [WORD]: Booleano, 1 si se quiere la direcci�n normalizada,
; 0 si se quiere con magnitud
; [Pierde los valores de FP1 y FP2]
VIRUS_VECTOR_FAGO PROC NEAR
	; Preparar la pila
	PUSH	BP
	MOV		BP, SP
	PUSHA
	
	; Guarda la posici�n del fago en memoria y lo convierte a punto flotante
	MOV		BX, [BP+6]		; Direcci�n en memoria del fago
	
	MOV		AX, WORD PTR PHAGE_X[BX]		; ..X
	MOV		WORD PTR FP1, AX
	FILD	WORD PTR FP1
	FSTP	DWORD PTR FP1
	
	MOV		AX, WORD PTR PHAGE_Y[BX]		; ..Y
	MOV		WORD PTR FP2, AX
	FILD	WORD PTR FP2
	FSTP	DWORD PTR FP2
	
	; Obtener la direcci�n del virus al fago
	MOV		SI, [BP+4]		; Direcci�n en memoria del virus
	
	; Prueba (empuja la direcci�n del virus a la pila)
	; FLD		DWORD PTR VIRUS_X[SI]
	; FLD		DWORD PTR VIRUS_Y[SI]
	ADD		SI, VIRUS_X		; SI apunta ahora a la Posici�n X
	
	PUSH	OFFSET FP1					; Destino
	PUSH	SI							; Sustraendo
	PUSH	OFFSET FP1					; Minuendo
	CALL	VECTOR_RESTAR
	ADD		SP, 6
	
	CMP		WORD PTR [BP+8], 01		; Comprobar si se quiere normalizar
	JNE		VIRUS_VECTOR_FAGO_FIN
	
	; Normaliza el vector
	PUSH	OFFSET FP1					; Destino
	PUSH	OFFSET FP1					; Fuente
	CALL	VECTOR_NORMALIZAR
	ADD		SP, 4
	
	; Reestablecer la pila
	VIRUS_VECTOR_FAGO_FIN:
	POPA
	POP		BP
	RET
VIRUS_VECTOR_FAGO ENDP

; ------------------------------------------------------------------------- ;
; Verifica si hubo una colisi�n con alg�n fago. Si el virus
; colisiona con otro virus regresa en AH = 01. Si colisiona con
; el virus destion entonces AL = FF, si colisiona con otro entonces
; en AL se guarda el ID del fago.
; El virus no reporta colisiones cuando esta se realiza con su fago fuente.
; @param [WORD]: Direcci�n del virus a verificar
; @return [AX]: Valores de colisi�n (ver descripci�n).
; ------------------------------------------------------------------------- ;
VIRUS_COLISION_FAGO PROC NEAR
	; Preparar pila
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	
	; Inicializa los registros
	MOV		AX, 0
	MOV		BX, [BP+4]		; ID del virus
	MOV		SI, BX
	
	; Revisa colisiones con cada fago
	MOV		CX, PHAGE_QUANTITY
	VIRUS_COLISION_FAGO_CICLO:
		; Revisa que el fago no sea el fago fuente
		MOV		DX, CX
		DEC		DX
		
		CMP		DL, VIRUS_SOURCE[SI]
		JE		VIRUS_COLISION_FAGO_FINCICLO

		; Obtiene la direcci�n del virus al fago y la distancia entre ellos
		MOV		SI, [BP+4]
		FAGO_DIRECCION DX	; La direcci�n del fago est� en BX
		
		PUSH	00			; Vector sin normalizar
		PUSH	BX			; Direcci�n del fago
		PUSH	SI			; Direcci�n del virus
		CALL 	VIRUS_VECTOR_FAGO
		ADD		SP, 6
		
		PUSH	OFFSET FP1	; Vector fuente
		CALL	VECTOR_MAGNITUD
		ADD		SP, 2
		
		; Compara el radio con la magnitud del vector
		MOVSX	AX, BYTE PTR PHAGE_RADIUS[BX]
		MOV		WORD PTR FP1, AX
		FICOMP	WORD PTR FP1			; CMP Distancia con Radio
		; FILD	WORD PTR FP1
		; FCOMPP						; COMP Radio con Distancia
		
		FSTSW	AX
		SAHF
		JAE		VIRUS_COLISION_FAGO_FINCICLO
		
		; .. hay colisi�n
		MOV		AH, 1
		
		; .. revisa si la colisi�n es con el destino
		CMP		DL, VIRUS_PHAGE[SI]
		JE		COLISION_DESTINO
		
		MOV		AL, VIRUS_PHAGE[SI]
		JMP		VIRUS_COLISION_FAGO_FIN
	
		COLISION_DESTINO:
		MOV		AL, 0FFH
		JMP		VIRUS_COLISION_FAGO_FIN
	
		VIRUS_COLISION_FAGO_FINCICLO:
		MOV		AX, 0
		
		DEC		CX
		JZ		VIRUS_COLISION_FAGO_FIN
		JMP		VIRUS_COLISION_FAGO_CICLO
	
	VIRUS_COLISION_FAGO_FIN:
	
	; Regresa la pila a su estado inicial
	POP		SI
	POP		DX
	POP		CX
	POP		BX
	POP		BP
	RET
VIRUS_COLISION_FAGO ENDP

; ------------------------------------------------------------------------- ;
; Verifica si hubo una colisi�n con alg�n fago. Si el virus
; colisiona con otro virus regresa en AH = 01. Si colisiona con
; el virus destion entonces AL = FF, si colisiona con otro entonces
; en AL se guarda el ID del fago.
; El virus no reporta colisiones cuando esta se realiza con su fago fuente.
; @param [WORD]: Direcci�n del virus a verificar
; @return [AX]: Valores de colisi�n (ver descripci�n).
; ------------------------------------------------------------------------- ;
VIRUS_COLISION_FAGO_MOUSE PROC NEAR
	; Preparar pila
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	
	; Inicializa los registros
	MOV		AX, 0
	MOV		BX, [BP+4]		; ID del virus
	MOV		SI, BX
	
	; Revisa colisiones con cada fago
	MOV		CX, PHAGE_QUANTITY
	VIRUS_COLISION_FAGO_CICLO_M:
		; Revisa que el fago no sea el fago fuente
		MOV		DX, CX
		DEC		DX
		
		CMP		DL, VIRUS_SOURCE[SI]
		JE		VIRUS_COLISION_FAGO_FINCICLO_M

		; Obtiene la direcci�n del virus al fago y la distancia entre ellos
		MOV		SI, [BP+4]
		FAGO_DIRECCION DX	; La direcci�n del fago est� en BX
		
		PUSH	00			; Vector sin normalizar
		PUSH	BX			; Direcci�n del fago
		PUSH	SI			; Direcci�n del virus
		CALL 	VIRUS_VECTOR_FAGO
		ADD		SP, 6
		
		PUSH	OFFSET FP1	; Vector fuente
		CALL	VECTOR_MAGNITUD
		ADD		SP, 2
		
		; Compara el radio con la magnitud del vector
		MOVSX	AX, BYTE PTR PHAGE_RADIUS[BX]
		MOV		WORD PTR FP1, AX
		FICOMP	WORD PTR FP1			; CMP Distancia con Radio
		; FILD	WORD PTR FP1
		; FCOMPP						; COMP Radio con Distancia
		
		FSTSW	AX
		SAHF
		JAE		VIRUS_COLISION_FAGO_FINCICLO_M
		
		; .. hay colisi�n
		MOV		AH, 1
		
		; .. revisa si la colisi�n es con el destino
		CMP		DL, VIRUS_PHAGE[SI]
		JE		COLISION_DESTINO_M
		
		MOV		AL, DL
		JMP		VIRUS_COLISION_FAGO_FIN_M
	
		COLISION_DESTINO_M:
		MOV		AL, 0FFH
		JMP		VIRUS_COLISION_FAGO_FIN_M
	
		VIRUS_COLISION_FAGO_FINCICLO_M:
		MOV		AX, 0
		
		DEC		CX
		JZ		VIRUS_COLISION_FAGO_FIN_M
		JMP		VIRUS_COLISION_FAGO_CICLO_M
	
	VIRUS_COLISION_FAGO_FIN_M:
	
	; Regresa la pila a su estado inicial
	POP		SI
	POP		DX
	POP		CX
	POP		BX
	POP		BP
	RET
VIRUS_COLISION_FAGO_MOUSE ENDP

; Moviliza la mitad de los virus del fago fuente al fago destino.
; @param [WORD]: ID del fago fuente
; @param [WORD]: ID del fago destino
FAGOS_MOVILIZAR_VIRUS PROC NEAR
.DATA
	; Minima cantidad de virus que tiene que tener
	; un fago para poder mandar virus
	MINIMO_VIRUS 	DW	5
.CODE
	; Prepara la pila
	PUSH	BP
	MOV		BP, SP
	PUSHA

	; Obtiene la direcci�n del fago 
	MOV		DX, [BP+4]		; ID del fago fuente
	FAGO_DIRECCION DX		; Direcci�n en BX
	MOV		SI, BX
	
	; Obtiene la mitad de los PHAGES del fuente y los activa
	MOV		AX, PHAGE_NVIRUS[SI]
	;.. compara que tenga una cantidad m�nima de virus
	CMP		AX, MINIMO_VIRUS
	JL		FAGOS_MOVILIZAR_VIRUS_FIN
	
	SHR		AX, 1
	
	SUB		WORD PTR PHAGE_NVIRUS[SI], AX
	
	PUSH	WORD PTR [BP+4]			; ID Fago fuente
	PUSH	WORD PTR [BP+6]			; ID Fago destino
	PUSH	AX				; Cantidad de virus a activar
	CALL	VIRUS_ACTIVAR
	ADD		SP, 6
	
	FAGOS_MOVILIZAR_VIRUS_FIN:
	
	; Reestablece la pila
	POPA
	POP		BP
	RET
FAGOS_MOVILIZAR_VIRUS ENDP

; Actualiza los PHAGES al aumentarles la cantidad de
; virus que tienen. Los virus aumentan a una raz�n
; de 1/5 radio por segundo.
FAGOS_ACTUALIZAR PROC NEAR
.DATA
	FAGOS_AUMENTO	DW		5
.CODE
	; Guarda los registros
	PUSHA
	
	; Itera por cada fago
	MOV		CX, PHAGE_QUANTITY
	FAGOS_ACTUALIZAR_CICLO:
		MOV		DX, CX
		DEC		DX			; ID del fago actual
		FAGO_DIRECCION DX	; La direcci�n del fago se guarda en BX
		
		; Revisa que el fago pertenezca a un jugador
		CMP		BYTE PTR PHAGE_PLAYER[BX], 0FFH
		JE		FAGOS_CICLO_FIN
		
		; Aumenta la cantidad de virus en el fago
		MOVZX	AX, BYTE PTR PHAGE_RADIUS[BX]
		MOV		DX, 0
		DIV		WORD PTR FAGOS_AUMENTO
		
		ADD		PHAGE_NVIRUS[BX], AX
		
		; .. comparar que la cantidad de virus no sea mayor
		; a dos veces el radio del fago
		MOVSX	AX, BYTE PTR PHAGE_RADIUS[BX]
		SHL		AX, 1
		CMP		AX, WORD PTR PHAGE_NVIRUS[BX]
		JG		FAGOS_CICLO_FIN
		MOV		WORD PTR PHAGE_NVIRUS[BX], AX
		
		FAGOS_CICLO_FIN:
		LOOP	FAGOS_ACTUALIZAR_CICLO
	
	; Reestablece los registros
	POPA
	RET
FAGOS_ACTUALIZAR ENDP

; ------------------------------------------------------------ ;
; Devuelve el ID del fago seleccionado por un jugador
; @param [WORD]: ID del jugador (0 = Jugador 1, 1 = Jugador 2)
; @return [AX]: ID del fago seleccionado 
; 		( FF0 si ning�n fago est� seleccionado)
; ------------------------------------------------------------ ;
FAGO_OBTENER_SELECCIONADO PROC NEAR
	; Preparar pila
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	CX
	PUSH	DX
	
	MOV		AX, [BP+4]		; ID del jugador
	SHL		AX, 1			; Corrige el ID (0 = J1 y 2 = J2)
	
	; Itera por cada uno de los PHAGES
	MOV		CX, PHAGE_QUANTITY
	FAGO_OBTENER_S_CICLO:
		MOV		DX, CX
		DEC		DX			; Correcci�n de posici�n
		
		; Obtener la direcci�n del fago
		FAGO_DIRECCION DX	; Direcci�n en BX
		
		; Verificar si el fago pertenece al jugador
		MOVZX		DX, BYTE PTR PHAGE_PLAYER[BX]
		SHR			DX, 1
		SHL			DX, 1
		CMP			DX, AX
		JNE			FAGO_OBTENER_S_CICLO_FIN
		
		; Verificar si el fago est� seleccionado
		CMP			DL, BYTE PTR PHAGE_PLAYER[BX]
		JE			FAGO_OBTENER_S_CICLO_FIN
		; .. si no son iguales, significa que estaba seleccionado
		MOV			AX, CX
		DEC			AX
		JMP			FAGO_OBTENER_S_FIN
		
		FAGO_OBTENER_S_CICLO_FIN:
		LOOP FAGO_OBTENER_S_CICLO
	
	MOV		AX, 0FFH			; Ning�n fago encontrado
	JMP		FAGO_OBTENER_S_FIN
	
	FAGO_OBTENER_S_FIN:
	; Restaurar pila
	POP		DX
	POP		CX
	POP		BX
	POP		BP
	RET
FAGO_OBTENER_SELECCIONADO ENDP

; --------------------------------------------------------------- ;
; Trata de seleccionar un fago para un jugador, siempre y cuando
; el jugador sea due�o del fago. Deselecciona cualquier otro fago
; del jugador.
; @param [WORD]: ID del jugador (J1 = 0, J2 = 1)
; @param [WORD]: ID del fago a seleccionar
; --------------------------------------------------------------- ;
FAGO_SELECCIONAR PROC NEAR
	; Inicializa la pila
	PUSH	BP
	MOV		BP, SP
	PUSHA
	
	; Deselecciona todos los PHAGES del jugador
	PUSH	WORD PTR [BP+4] 		; ID del jugador
	CALL	FAGO_DESELECCIONAR
	ADD		SP, 2
	
	; Determina si el fago objetivo es del jugador
	MOV		AX, [BP+4]		; ID del jugador
	SHL		AX, 1			; Corrige el ID del jugador (J1 = 0, J2 = 2)
	
	MOV		DX, [BP+6]		; ID del fago
	FAGO_DIRECCION DX		; Direccion en BX
	
	CMP		AL, BYTE PTR PHAGE_PLAYER[BX]
	JNE		FAGO_SELECCIONAR_FIN
	
	; .. selecciona el fago objetivo
	INC		AL
	MOV		BYTE PTR PHAGE_PLAYER[BX], AL
	
	FAGO_SELECCIONAR_FIN:
	; Restaura la pila
	POPA
	POP		BP
	RET
FAGO_SELECCIONAR ENDP

; ------------------------------------------------------------ ;
; Deselecciona cualquier fago seleccionado por alg�n jugador.
; @param [WORD]: ID del jugador (J1 = 0, J2 = 1)
; ------------------------------------------------------------ ;
FAGO_DESELECCIONAR PROC NEAR
	; Prepara la pila
	PUSH	BP
	MOV		BP, SP
	PUSHA
	
	MOV		AX, [BP+4]		; ID del jugador
	SHL		AX, 1			; Corrige el ID del jugador (J1 = 0, J2 = 2)
	
	; Itera por cada uno de los PHAGES
	MOV		CX, PHAGE_QUANTITY
	FAGO_DESELECCIONAR_CICLO:
		MOV		DX, CX
		DEC		DX			; Correcci�n de posici�n
		
		; Obtiene la direcci�n del fago y el jugador del mismo
		FAGO_DIRECCION DX	; Direccion en BX
		
		MOVZX	DX, BYTE PTR PHAGE_PLAYER[BX]
		SHR		DX, 1
		SHL		DX, 1	; Elimina el bit de seleccion
		CMP		AX, DX
		JNE		FAGO_DESELECCIONAR_CICLO_FIN
		
		; Deselecciona el fago
		MOV		BYTE PTR PHAGE_PLAYER[BX], AL
		
		FAGO_DESELECCIONAR_CICLO_FIN:
		LOOP FAGO_DESELECCIONAR_CICLO
	
	; Restaura la pila
	POPA
	POP		BP
	RET
FAGO_DESELECCIONAR ENDP


