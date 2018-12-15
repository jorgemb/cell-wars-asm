;###########################################;
; Logic for phage simulation, plus first 	;
; level definition.							;
;###########################################;

.DATA
	; PHAGE definition.
	;	- byte	PosX
	;	- byte	PosY
	;	- byte	Radius
	;	- byte	Owner (FF = Neutral, 00 or 01 = Jugador1, 02 or 03 = Jugador2)
	;	- word	Image
	;	- word	Virus quantity
	; TOTAL: 8 bytes per phage
	
	; All phage are initialized as default
	; INITIAL_PHAGE		DQ		PHAGE_QUANTITY DUP ( 00000000FF000000H )
	
	PHAGES_INITIAL_DATA	DW	290, 170	; POSX,POSY
					DB	25, 02		; Radius, Owner
					DW	OFFSET FAGO_1		; Image
					DW	0010		; Initial virus amount
					
					; Phage 1
					DW	030, 030	; PosX,PosY
					DB	25, 00		; Radius, Owner
					DW	OFFSET FAGO_1		; Image
					DW	0010		; Initial virus amount
					
					; Phage 2
					DW	030, 93		; PosX,PosY
					DB	15, 0FFH	; Radius, Owner
					DW	OFFSET FAGO_2		; Image
					DW	0020		; Initial virus amount
					
					; Phage 3
					DW	160, 20		; PosX,PosY
					DB	10, 0FFH	; Radius, Owner
					DW	OFFSET FAGO_3		; Image
					DW	0010		; Initial virus amount
					
					; Phage 4
					DW	128, 060	; PosX,PosY
					DB	10, 0FFH	; Radius, Owner
					DW	OFFSET FAGO_3		; Image
					DW	0010		; Initial virus amount
					
					; Phage 5
					DW	120, 140	; PosX,PosY
					DB	10, 0FFH	; Radius, Owner
					DW	OFFSET FAGO_3	; Image
					DW	0010		; Initial virus amount
					
					; Phage 6
					DW	200, 140		; PosX,PosY
					DB	10, 0FFH	; Radius, Owner
					DW	OFFSET FAGO_3	; Image
					DW	0010		; Initial virus amount
					
					; Phage 7
					DW	192, 060		; PosX,PosY
					DB	10, 0FFH	; Radius, Owner
					DW	OFFSET FAGO_3	; Image
					DW	0010		; Initial virus amount
					
					; Phage 8
					DW	160, 100		; PosX,PosY
					DB	15, 0FFH	; Radius, Owner
					DW	OFFSET FAGO_2	; Image
					DW	0050		; Initial virus amount
					
					; Phage 9
					DW	290, 107		; PosX,PosY
					DB	15, 0FFH	; Radius, Owner
					DW	OFFSET FAGO_2	; Image
					DW	0020		; Initial virus amount

.CODE
; --------------------------------------------------- ;
; Initializes phage data.
; --------------------------------------------------- ;
PHAGES_INITIALIZE PROC NEAR
	PUSHA
	
	; Copies phages initial vectors
	MOV		SI, OFFSET PHAGES_INITIAL_DATA
	MOV		DI, OFFSET PHAGES
	
	MOV		CX, PHAGE_TOTAL_BYTES
	PHAGES_INITIALIZE_CYCLE:
		MOV	AL, BYTE PTR [SI]
		MOV BYTE PTR [DI], AL
		INC SI
		INC DI
		LOOP PHAGES_INITIALIZE_CYCLE
	
	POPA
	RET
PHAGES_INITIALIZE ENDP

; Returns the address of a phage given its ID.
; Address must be in a register, cannot be AX.
; Returns address in BX.
PHAGE_ADDRESS MACRO PHAGE_ID
	; Saves registers
	PUSH	AX
	PUSH	DX

	MOV		AX, PHAGE_SIZE
	MUL		BYTE PTR PHAGE_ID
	
	LEA		BX, PHAGES
	ADD		BX, AX
	
	; Restores registers
	POP		DX
	POP		AX
ENDM

; Calculates the direction from the given virus to the given phage.
; Vector is saved in memory position FP1 and FP2.
; @param [WORD]: Virus address
; @param [WORD]: Phage address
; @param [WORD]: Boolean, 1 returns normalized address and 0 unnormalized.
VIRUS_PHAGE_VECTOR PROC NEAR
	; Stack init
	PUSH	BP
	MOV		BP, SP
	PUSHA
	
	; Phage position is converted to floating point.
	MOV		BX, [BP+6]		; Phage address
	
	MOV		AX, WORD PTR PHAGE_X[BX]		; ..X
	MOV		WORD PTR FP1, AX
	FILD	WORD PTR FP1
	FSTP	DWORD PTR FP1
	
	MOV		AX, WORD PTR PHAGE_Y[BX]		; ..Y
	MOV		WORD PTR FP2, AX
	FILD	WORD PTR FP2
	FSTP	DWORD PTR FP2
	
	; Calculates virus vector
	MOV		SI, [BP+4]		; Virus address
	ADD		SI, VIRUS_X		; SI has X position
	
	PUSH	OFFSET FP1					; Target
	PUSH	SI							; Subtrahend
	PUSH	OFFSET FP1					; Minuend
	CALL	VECTOR_SUBTRACT
	ADD		SP, 6
	
	CMP		WORD PTR [BP+8], 01		; Check if normalization is required
	JNE		VIRUS_PHAGE_VECTOR_END
	
	; Normalizes the direction
	PUSH	OFFSET FP1					; Target
	PUSH	OFFSET FP1					; Source
	CALL	VECTOR_NORMALIZE
	ADD		SP, 4
	
	; Stack restore
	VIRUS_PHAGE_VECTOR_END:
	POPA
	POP		BP
	RET
VIRUS_PHAGE_VECTOR ENDP

; Verifies if there has been a collision with a phage. If collision is with
; other phage, AH = 01 and AL = PHAGE ID; if is with target phage, AL = FF. 
; Collisions are not reported if is with source phage.
; @param [WORD]: Virus address
; @return [AX]: Collision 
; ------------------------------------------------------------------------- ;
VIRUS_PHAGE_COLLISION PROC NEAR
	; Stack init
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	
	; Initializes the registers
	MOV		AX, 0
	MOV		BX, [BP+4]		; Virus ID
	MOV		SI, BX
	
	; Check collisions with each phage
	MOV		CX, PHAGE_QUANTITY
	VIRUS_PHAGE_COLLISION_CYCLE:
		; Check if phage is source phage
		MOV		DX, CX
		DEC		DX
		
		CMP		DL, VIRUS_SOURCE[SI]
		JE		VIRUS_PHAGE_COLLISION_ENDCYCLE

		; Calculates virus-phage direction and distance.
		MOV		SI, [BP+4]
		PHAGE_ADDRESS DX	; Phage direction is in BX
		
		PUSH	00			; Unnormalized vector
		PUSH	BX			; Phage address
		PUSH	SI			; Virus address
		CALL 	VIRUS_PHAGE_VECTOR
		ADD		SP, 6
		
		PUSH	OFFSET FP1	; Source vector
		CALL	VECTOR_MAGNITUDE
		ADD		SP, 2
		
		; Compares radius with distance
		MOVSX	AX, BYTE PTR PHAGE_RADIUS[BX]
		MOV		WORD PTR FP1, AX
		FICOMP	WORD PTR FP1			; CMP Distance with radiuse
		
		FSTSW	AX
		SAHF
		JAE		VIRUS_PHAGE_COLLISION_ENDCYCLE
		
		; There is collision!
		MOV		AH, 1
		
		; .. check if collision is with target
		CMP		DL, VIRUS_PHAGE[SI]
		JE		COLLISION_TARGET
		
		MOV		AL, VIRUS_PHAGE[SI]
		JMP		VIRUS_PHAGE_COLLISION_END
	
		COLLISION_TARGET:
		MOV		AL, 0FFH
		JMP		VIRUS_PHAGE_COLLISION_END
	
		VIRUS_PHAGE_COLLISION_ENDCYCLE:
		MOV		AX, 0
		
		DEC		CX
		JZ		VIRUS_PHAGE_COLLISION_END
		JMP		VIRUS_PHAGE_COLLISION_CYCLE
	
	VIRUS_PHAGE_COLLISION_END:
	
	; Restore
	POP		SI
	POP		DX
	POP		CX
	POP		BX
	POP		BP
	RET
VIRUS_PHAGE_COLLISION ENDP

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
	; Stack init
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
		PHAGE_ADDRESS DX	; La direcci�n del fago est� en BX
		
		PUSH	00			; Vector sin normalizar
		PUSH	BX			; Direcci�n del fago
		PUSH	SI			; Direcci�n del virus
		CALL 	VIRUS_PHAGE_VECTOR
		ADD		SP, 6
		
		PUSH	OFFSET FP1	; Vector fuente
		CALL	VECTOR_MAGNITUDE
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
	PHAGE_ADDRESS DX		; Direcci�n en BX
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
		PHAGE_ADDRESS DX	; La direcci�n del fago se guarda en BX
		
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
	; Stack init
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
		PHAGE_ADDRESS DX	; Direcci�n en BX
		
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
	; Stack init
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
	PHAGE_ADDRESS DX		; Direccion en BX
	
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
		PHAGE_ADDRESS DX	; Direccion en BX
		
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


