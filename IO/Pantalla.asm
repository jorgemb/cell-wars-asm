;###########################################;
;Universidad del Valle de Guatemala			;
;Organización de Computadoras y Assembler	;
;											;
; Librería con varias utilidades para		;
; trabajar con los modos gráficos.			;
;											;
;Eddy Omar Castro Jáuregui - 11032			;
;Jorge Luis Martínez Bonilla - 11237		;
;###########################################;

; ----------------------------------------------------------- ;
; Dibuja una linea del punto1 al punto2 (dado). Basado en el
; algoritmo Bresenham para dibujar líneas.
; [WORD]: Posicion x0
; [WORD]: Posicion y0
; [WORD]: Posicion x1
; [WORD]: Posicion y1
; [WORD]: Atributo a color (BYTE)
; [WORD]: Offset de memoria para la pagina.
; [WORD]: Ancho de la pantalla del modo actual.
; ----------------------------------------------------------- ;
DIBUJAR_LINEA PROC NEAR
	; PILA - Preparar
	PUSH	BP
	MOV		BP, SP
	PUSHA
	
	; Preparar las variables necesarias
	; BX + 8 -> deltaX
	; BX + 6 -> signoX
	; BX + 4 -> deltaY
	; BX + 2 -> signoY
	; BX + 0 -> error
	MOV 	CX, 1
	
	; Delta 'x' y signo
	MOV		AX, [BP+8]	; x1
	SUB		AX, [BP+4]	; x0
	CMP		AX, 0
	JGE		NO_CORREGIR_DX
		MOV		CX, -1
		NEG		AX
	
	NO_CORREGIR_DX:
	PUSH	AX
	PUSH	CX
	MOV		DX, AX			; error = dx
	
	; Delta 'y' y signo
	MOV		CX, 1
	MOV		AX, [BP+10]	; y1
	SUB		AX, [BP+6]	; y0
	CMP		AX, 0
	JGE		NO_CORREGIR_DY
		MOV		CX, -1
		NEG		AX
	
	NO_CORREGIR_DY:
	PUSH	AX
	PUSH	CX
	SUB		DX, AX		; error -= dy
	
	; Error
	PUSH	DX
	MOV		BX, SP		; Marca el primer valor de la pila
	
	; Inicializar el registro de segmento y dato a copiar
	MOV		AX, [BP+14] ; Offset de la pantalla
	MOV		ES, AX
	
	DIBUJAR_CICLO_LINEA:
		; Dibujar el pixel
		MOV		DX,	[BP+16]	; Ancho de la pantalla
		MOV		AX, [BP+6]	; y0
		MUL		DX
		ADD		AX, [BP+4]	; AX = (y0*ancho)+x0
		MOV		DI, AX
		
		MOV		AX, [BP+12]	; Byte de atributo
		STOSB
		
		; Avanzar el ciclo
		; if x0 == x1 and y0 == y1 exit
		MOV		AX, [BP+4]	; x0
		XOR		AX, [BP+8]	; x1
		CMP		AX, 0
		JNE		DIBUJAR_CICLO_CONTINUAR
		MOV		AX, [BP+6]	; y0
		XOR		AX, [BP+10]	; y1
		CMP		AX, 0
		JE		DIBUJAR_FINAL
		
		DIBUJAR_CICLO_CONTINUAR:
		MOV		AX, [BX]	; error
		MOV		DX, AX		; error
		SHL		DX, 1		; error*2
		
		MOV		CX,	[BX+4]	; delta y
		NEG		CX
		CMP		DX, CX		; cmp error*2, -deltaY
		JLE		DIBUJAR_CICLO_COMPX
		ADD		AX, CX		; error = error - deltaY
		
		MOV		CX, [BP+4]	; x0
		ADD		CX, [BX+6]	; x0 + signoX
		MOV		[BP+4], CX
		
		DIBUJAR_CICLO_COMPX:
		MOV		CX, [BX+8]	; deltax
		CMP		DX, CX		; cmp error*2, deltaX
		JGE		DIBUJAR_FINAL_CICLO
		ADD		AX, CX		; error = error + deltaX
		
		MOV		CX, [BP+6]	; y0
		ADD		CX, [BX+2];	; y0 + signoY
		MOV		[BP+6], CX
		
		DIBUJAR_FINAL_CICLO:
		MOV		[BX], AX	; Guardar el valor del error
		JMP		DIBUJAR_CICLO_LINEA
		

	DIBUJAR_FINAL:
	; PILA - Regresar al estado inicial
	ADD		SP, 10	; Liberar las variables locales
	POPA
	POP		BP
	RET
DIBUJAR_LINEA ENDP


