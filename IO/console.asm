;###########################################;
; Console utilities.						;
;###########################################;

; --------------------------------------;
; Clears the screen
; --------------------------------------;
CLEAR_SCREEN PROC NEAR
	PUSH	0007h	; White characters in black background
	PUSH	184Fh	; Lower right corner (24,79)
	PUSH	0000h	; Upper left corner (0, 0)
	CALL	CLEAR_SCREEN_SQUARE
	ADD		SP, 6
	
	RET
CLEAR_SCREEN ENDP

; ---------------------------------------------------------------------------
; Cleans a square on the screen
; @param [WORD]: Upper left corner (row, column)
; @param [WORD]: Lower right corner (row, column)
; @param [BYTE]: Attribute byte
; ---------------------------------------------------------------------------
CLEAR_SCREEN_SQUARE PROC NEAR
	; Stack - prepare
	PUSH	BP
	MOV		BP, SP
	; Save registers
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	
	MOV		AX, [BP+8]	; Attribute byte
	MOV		BH, AL
	MOV		BL, 0
	
	MOV		DX, [BP+6]	; Lower right corner
	MOV		CX, [BP+4]	; Upper left corner
	
	MOV		AH,	06H		; 06H Function
	
	MOV		AL, 01d		; Line amount
	ADD		AL, DH
	SUB		AL, CH
	
	INT		10h
	
	; STACK - Restore
	POP		DX
	POP		CX
	POP		BX
	POP		AX
	
	POP		BP
	RET
CLEAR_SCREEN_SQUARE ENDP

; -----------------------------------------------------------------------------;
; Moves the cursor to given coordinates.
; @param [BYTE]: X coordinate
; @param [BYTE]: Y coordinate
; -----------------------------------------------------------------------------;
GOTOXY PROC NEAR
	; STACK - Prepare
	PUSH	BP
	MOV		BP, SP
	PUSH	AX
	PUSH	BX
	PUSH	DX

	MOV		AH, 2		; Function 2 to move
	MOV		BH, 0		; Shows page 0
	MOV		DH, [BP+6]	; Y coordinate
	MOV		DL, [BP+4]	; X coordinate
	INT		10h			; DOS interrupt
	
	; STACK - Restore
	POP		DX
	POP		BX
	POP		AX
	POP		BP
	RET
GOTOXY ENDP

; -------------------------------------------
; Color byte in AL register
; @param [BYTE]: Background color (XRGB)
; @param [BYTE]: Foreground color (XRGB)
; @return AX: Formed byte
; -------------------------------------------
FORM_COLOR	PROC NEAR
	; STACK - Prepare
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	CX
	
	MOV		AX, 0
	MOV		BX, [BP+4]	; Background
	MOV		CL, 4
	SHL		BX, CL
	
	MOV		AL, BL
	
	MOV		BX, [BP+6]	; Foreground
	OR		AL, BL
	
	; Eliminates blinking bit
	AND		AL, 01111111b
	
	; STACK - Restore
	POP		CX
	POP		BX
	POP		BP
	RET
FORM_COLOR	ENDP

; ---------------------------------------------------------- ;
; Writes one character several times.
; @param [BYTE]: Character
; @param [WORD]: Times to be written
; ---------------------------------------------------------- ;
CHAR_FILL PROC NEAR
	; STACK - Prepare
	PUSH	BP
	MOV		BP, SP
	PUSH	BX

	PUSH	WORD PTR [BP+6]	; Times to be written
	MOV		SI, SP
	PUSH	WORD PTR [BP+4]	; Character
	
	CHAR_FILL_CYCLE:
		CALL 	PUTC
		
		DEC 	WORD PTR [SI]
		CMP		WORD PTR [SI], 0
		JNE		CHAR_FILL_CYCLE
	
	ADD		SP, 4
		
	; STACK - Restore
	POP		BX
	POP		BP
	RET
CHAR_FILL ENDP

; -------------------------------------------------------------- ;
; Draws a filled rectangle in the given positions.
; @param [WORD]: X
; @param [WORD]: Y
; @param [WORD]: Length
; @param [WORD]: Height
; @param [BYTE]: Character
; -------------------------------------------------------------- ;
DRAW_FILLED_RECT	PROC NEAR
	; STACK - Prepare
	PUSH	BP
	MOV		BP, SP
	PUSH	BX

	; Fills the lines with the given character
	PUSH	WORD PTR [BP+6] ; y
	PUSH	WORD PTR [BP+4]	; x
	MOV		SI, SP
	ADD		SI, 2			; Y coordinate changes for every line
	MOV		CX, [BP+10]		; Total lines
	
	DRAW_FILLED_RECT_CYCLE:
		CALL	GOTOXY
		PUSH	SI
		PUSH	CX
		
		MOV		AX, [BP+8] 	; Width
		PUSH	AX
		PUSH	WORD PTR [BP+12]
		CALL	CHAR_FILL
		ADD		SP, 4
		
		POP		CX
		POP		SI
		INC		WORD PTR [SI]
		LOOP	DRAW_FILLED_RECT_CYCLE
	ADD		SP, 4
	
	; STACK - Restore
	POP		BX
	POP		BP
	RET
DRAW_FILLED_RECT	ENDP

; --------------------------------------------------------------- ;
; Draws an unfilled rect at the given position.
; TODO: This was a lazy approach, in reality is a smaller black rect
; inside another rect.
; @param [WORD]: X
; @param [WORD]: Y
; @param [WORD]: Length
; @param [WORD]: Height
; @param [BYTE]: Character
; --------------------------------------------------------------- ;
DRAW_EMPTY_RECT	PROC NEAR
	; STACK - Prepare
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	
	; Draws a filled rect of the given size
	PUSH	WORD PTR [BP+12]
	PUSH	WORD PTR [BP+10]
	PUSH	WORD PTR [BP+8]
	PUSH	WORD PTR [BP+6]
	PUSH	WORD PTR [BP+4]
	CALL	DRAW_FILLED_RECT
	
	; Draws a smaller rect inside with the background
	MOV		SI, SP
	MOV		WORD PTR [SI+8], ' '
	SUB		WORD PTR [SI+6], 2		; Height-2
	SUB		WORD PTR [SI+4], 2		; Length-2
	ADD		WORD PTR [SI+2], 1		; Position y+1
	ADD		WORD PTR [SI], 1		; Position x+1
	CALL	DRAW_FILLED_RECT
	
	ADD		SP, 10
	
	; STACK - Restore
	POP		BX
	POP		BP
	RET
DRAW_EMPTY_RECT	ENDP

; ------------------------------- ;
; Make a pause
; ------------------------------- ;
PAUSE	PROC NEAR
	XOR AH,AH
	INT 16H	
	RET
PAUSE	ENDP

; --------------------------------------------------------- ;
; Clamps a value to the given range
; @param [WORD]: Value
; @param [WORD]: Upper limit
; @param [WORD]: Lower limit
; @return [AX]: Clamped value
; --------------------------------------------------------- ;
CLAMP_VALUE	PROC NEAR
	; STACK - Prepare
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	
	MOV		AX, [BP+4]		; Value in AX
	
	; Compares lower limit
	CMP		AX, [BP+6]
	JL		CLAMP_LOWER
	
	; Compares upper limit
	CMP		AX, [BP+8]
	JG		CLAMP_UPPER
	JMP		CLAMP_END
	
	CLAMP_LOWER:
		MOV		AX, [BP+6]
		JMP		CLAMP_END
		
	CLAMP_UPPER:
		MOV		AX, [BP+8]
	
	CLAMP_END:
	
	; STACK - Restore
	POP		BX
	POP		BP
	RET
CLAMP_VALUE	ENDP

