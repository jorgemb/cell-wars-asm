;###########################################;
; Input/Output library						;
;###########################################;

; ------------------------------------------ ;
; Cleans keyboard buffer.
; ------------------------------------------ ;
CLEAN_KEYBOARD	PROC NEAR

	MOV		AH, 0CH
	MOV		AL, 06H
	INT		21H
	
	RET

CLEAN_KEYBOARD ENDP

; ---------------------------------------------------- ;
; Returns key scan code.
; @return [AH]: Scan code
; @return [AL]: ASCII character, or 0 in extended.
; ---------------------------------------------------- ;
GET_SCANCODE	PROC NEAR
	
	; Function 10H of the 16H interrupt
	MOV		AH, 10H
	INT		16H
		
	RET
GET_SCANCODE	ENDP

; ---------------------------------------------------- ;
; Displays a single character on the screen.
; @param [BYTE]: Char to display
; ---------------------------------------------------- ;
PUTC	PROC NEAR
	; STACK - Prepare
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	DX
	
	MOV		DX, [BP+4]
	MOV		AH, 02H
	INT		21H
		
	; STACK - Restore
	POP		DX
	POP		BX
	POP		BP
	RET
PUTC	ENDP

; ----------------------------------------------- ;
; Gets a single char from the screen.
; @param [BYTE]: Echo [1 -> echo; 0 -> no echo]
; @return [AL]: Input character
; ----------------------------------------------- ;
GETC	PROC NEAR
	; STACK - Prepare
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	DX

	; Checks the echo variable
	MOV		DX, [BP+4]
	CMP		DX, 0
	JE		GETC_NO_ECHO
	
	GETC_WITH_ECHO:
	MOV		AH, 01H
	INT		21H
	JMP		GETC_FIN
	
	GETC_NO_ECHO:
	MOV		AH, 07H
	INT		21H
	
	; Cleans the upper part of the AX register, so the char is in AL.
	GETC_FIN:
	MOV		AH, 0
	
	; STACK - Restore
	POP		DX
	POP		BX
	POP		BP
	RET
GETC	ENDP

; ----------------------------------------------- ;
; Returns the extended scan code.
; @param [BYTE]: Type [0 -> printable; 1 -> extended]
; @return [AL]: Pressed key
; ----------------------------------------------- ;
GETC_EXTENDED	PROC NEAR
	; STACK - Prepare
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	DX

	; Revisa la variable Tiop para ver si se desea caracter imprimible o extendido
	; Checks the Type variable to look for a printable or extended character.
	MOV		DX, [BP+4]
	CMP		DX, 0
	JE		GETC_PRINTABLE
	
	MOV		AH, 06H
	MOV		DL, 0FFH
	INT		21H
	
	GETC_PRINTABLE:
	MOV		AH, 06H
	MOV		DL, 0FFH
	INT		21H
	
	MOV		DX, [BP+4]
	CMP		DX, 1
	JE		GETC_EXTENDED_ENTRY	
	
	CMP		AL, 0
	JNE		GETC_EXTENDED_ENTRY
	MOV		AH, 06H
	MOV		DL, 0FFH
	INT		21H
	
	GETC_EXTENDED_ENTRY:
	; Cleans the AH part of the register, so AL is the sole part with the character
	MOV		AH, 0
	
	; STACK - Restore
	POP		DX
	POP		BX
	POP		BP
	RET
GETC_EXTENDED	ENDP

; ----------------------------------------------------------- ;
; Prints a string on screen
; @param [WORD]: Address of the first position in the string.
; @return [AX]: Amount of written characters.
; ----------------------------------------------------------- ;
COUT	PROC NEAR
	; STACK - Prepare
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	CX
	PUSH	DX
	
	; Gets the address of the string
	MOV		AX, 0		; Character count
	MOV		BX, [BP+4]
	MOV		CX, [BP+6]
	
	; Print characters, one by one
	MOV		DH,	0
	COUT_CYCLE:
	MOV		DL, [BX]
	CMP		DL, '$'
	JE		COUT_END
	
	PUSH	DX
	CALL	PUTC
	ADD		SP, 2
	
	INC		BX
	INC		AX
	JMP		COUT_CYCLE
	
	COUT_END:
	; STACK - Restore
	POP		DX
	POP		CX
	POP		BX
	POP		BP
	
	RET
COUT	ENDP

; ------------------------------------------------------------------------------ ;
; Receives input from the console, from the first character until the buffer is
; full or the user presses <return>.
; @param [WORD]: Output buffer address
; @param [WORD]: Amount of characters to read
; @return [AX]: Read characters
; ------------------------------------------------------------------------------ ;
CIN		PROC NEAR
	; STACK - Prepare
	PUSH	BP
	MOV		BP, SP
	PUSH	BX

	; BX=output address, CX=amount of characters
	MOV		BX, [BP + 4]
	MOV		CX, [BP + 6]
	
	PUSH	0	; Show ECHO with GETC
	CIN_CYCLE:
	CALL 	GETC
	CMP		AL, 0DH
	JE		CIN_END_CYCLE
	
	CMP		AL, 08H
	JNE		CIN_NO_BACKSPACE
	
	CMP		CX, [BP+6]		; If char amount is zero nothing is erased
	JE		CIN_CYCLE
	PUSH	AX
	CALL	PUTC
	ADD		SP, 2
	
	INC		CX
	DEC		BX
	JMP		CIN_CYCLE
	; Echo character if not backspace or return.
	CIN_NO_BACKSPACE:
	PUSH	AX
	CALL	PUTC
	ADD		SP, 2
	
	; Add new character
	MOV		[BX], AL
	INC		BX
	LOOP	CIN_CYCLE
	
	CIN_END_CYCLE:
	ADD		SP, 2	; Removes GETC parameters

	; Calculates amount of read characters and adds the end character.
	MOV		AX, [BP+6]
	SUB		AX, CX
	MOV		[BX], BYTE PTR '$'
	; STACK - Restore
	POP		BX
	POP		BP
	RET
CIN		ENDP


; ------------------------------- ;
; Puts a return char in the console.
; ------------------------------- ;
PUT_ENTER	PROC NEAR
	PUSH	0DH
	CALL	PUTC
	
	PUSH	0AH
	CALL	PUTC
	
	ADD		SP, 4
	RET
PUT_ENTER	ENDP


; ---------------------------------------------------------------------------------;
; Verifies that the value is inside a given range.
; @param [BYTE]: Value
; @param [BYTE]: Upper limit
; @param [BYTE]: Lower limit
; @return [AH]: 0 in case of invalid value, 1 otherwise
; ---------------------------------------------------------------------------------;
VERIFY_VALUE	PROC NEAR
	; STACK - Prepare
	PUSH	BP
	MOV		BP, SP
	PUSH	DX

	MOV		AH, 1
	; Upper limit
	MOV		DL, BYTE PTR [BP+6]
	CMP		BYTE PTR [BP+4], DL
	JG		INVALID
	
	; Lower limit
	MOV	DL, BYTE PTR [BP+8]
	CMP		BYTE PTR [BP+4], DL
	JL		INVALID
	
	JMP		VALID
	
	INVALID:
	MOV		AH, 0
	
	VALID:
	; STACK - Restore
	POP		DX
	POP		BP
	
	RET
VERIFY_VALUE	ENDP

; ---------------------------------------------------------- ;
; Asks the user to enter a digit, checking that is inside
; the specified range. Always returns a valid value.
; @param[BYTE]: Upper limit
; @param[BYTE]: Lower limit
; @return[AX]: Amount entered
; ---------------------------------------------------------- ;
NUMERIC_ENTRY	PROC NEAR
	; STACK - Prepare
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	ENTRY_VALIDATION:
			MOV		AX, 0
			PUSH	0
			CALL	GETC
			ADD		SP, 2
			SUB		AL, 30H
			
			PUSH	WORD PTR [BP+6]
			PUSH	WORD PTR [BP+4]
			PUSH	AX
			CALL	VERIFY_VALUE
			ADD		SP, 6
			
			CMP		AH, 0
			JE		ENTRY_VALIDATION

	MOV		AH, 0	
	PUSH	AX
	
	; Echo the entered value
	ADD		AX, 30H
	PUSH	AX
	CALL	PUTC
	ADD		SP, 2
	
	POP		AX
	; STACK - Restore
	POP		BX
	POP		BP
	RET
NUMERIC_ENTRY	ENDP
