;###########################################;
; Library with utilities for graphic mode	;
; work.										;
;###########################################;

; Draws a line from point 1 to point 2. Based on Bresenham 
; algorithm for line drawing.
; [WORD]: x0 
; [WORD]: y0 
; [WORD]: x1
; [WORD]: y1
; [WORD]: Color attribute(BYTE)
; [WORD]: Memory offset for page.
; [WORD]: Screen width in current mode.
; ----------------------------------------------------------- ;
DIBUJAR_LINEA PROC NEAR
	; STACK - Prepare
	PUSH	BP
	MOV		BP, SP
	PUSHA
	
	; Prepare necesary variables
	; BX + 8 -> deltaX
	; BX + 6 -> signX
	; BX + 4 -> deltaY
	; BX + 2 -> signY
	; BX + 0 -> error
	MOV 	CX, 1
	
	; Delta 'x' and sign
	MOV		AX, [BP+8]	; x1
	SUB		AX, [BP+4]	; x0
	CMP		AX, 0
	JGE		DRAW_LINE_NO_DX_CORRECTION
		MOV		CX, -1
		NEG		AX
	
	DRAW_LINE_NO_DX_CORRECTION:
	PUSH	AX
	PUSH	CX
	MOV		DX, AX			; error = dx
	
	; Delta 'y' and sign
	MOV		CX, 1
	MOV		AX, [BP+10]	; y1
	SUB		AX, [BP+6]	; y0
	CMP		AX, 0
	JGE		DRAW_LINE_NO_DY_CORRECTION
		MOV		CX, -1
		NEG		AX
	
	DRAW_LINE_NO_DY_CORRECTION:
	PUSH	AX
	PUSH	CX
	SUB		DX, AX		; error -= dy
	
	; Error
	PUSH	DX
	MOV		BX, SP		; Marks the first value of the stack.
	
	; Initializes the segment register and data to copy
	MOV		AX, [BP+14] ; Screen offset
	MOV		ES, AX
	
	DRAW_LINE_CYCLE:
		; Draw the pixel
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
		JMP		DRAW_LINE_CYCLE
		

	DIBUJAR_FINAL:
	; STACK - Restore
	ADD		SP, 10	; Liberar las variables locales
	POPA
	POP		BP
	RET
DIBUJAR_LINEA ENDP


