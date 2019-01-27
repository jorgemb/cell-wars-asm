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
DRAW_LINE PROC NEAR
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
		MOV		DX,	[BP+16]	; Screen width
		MOV		AX, [BP+6]	; y0
		MUL		DX
		ADD		AX, [BP+4]	; AX = (y0*width)+x0
		MOV		DI, AX
		
		MOV		AX, [BP+12]	; Attribute byte
		STOSB
		
		; Next step of cycle
		; if x0 == x1 and y0 == y1 exit
		MOV		AX, [BP+4]	; x0
		XOR		AX, [BP+8]	; x1
		CMP		AX, 0
		JNE		DRAW_LINE_CYCLE_CONTINUE
		MOV		AX, [BP+6]	; y0
		XOR		AX, [BP+10]	; y1
		CMP		AX, 0
		JE		DRAW_LINE_END
		
		DRAW_LINE_CYCLE_CONTINUE:
		MOV		AX, [BX]	; error
		MOV		DX, AX		; error
		SHL		DX, 1		; error*2
		
		MOV		CX,	[BX+4]	; delta y
		NEG		CX
		CMP		DX, CX		; cmp error*2, -deltaY
		JLE		DRAW_LINE_CYCLE_COMPX
		ADD		AX, CX		; error = error - deltaY
		
		MOV		CX, [BP+4]	; x0
		ADD		CX, [BX+6]	; x0 + signX
		MOV		[BP+4], CX
		
		DRAW_LINE_CYCLE_COMPX:
		MOV		CX, [BX+8]	; deltax
		CMP		DX, CX		; cmp error*2, deltaX
		JGE		DRAW_LINE_CYCLE_END
		ADD		AX, CX		; error = error + deltaX
		
		MOV		CX, [BP+6]	; y0
		ADD		CX, [BX+2];	; y0 + signoY
		MOV		[BP+6], CX
		
		DRAW_LINE_CYCLE_END:
		MOV		[BX], AX	; Save the error value
		JMP		DRAW_LINE_CYCLE
		

	DRAW_LINE_END:
	; STACK - Restore
	ADD		SP, 10	; Release local variables
	POPA
	POP		BP
	RET
DRAW_LINE ENDP


