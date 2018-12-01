;###########################################;
; Mouse management for in menu interaction	;
;###########################################;

; ---------------------------------------------------;
; Shows the menu.
; ---------------------------------------------------;
SHOW_MENU PROC NEAR
	
	.DATA
	
	MOUSE_FLAG	DB	0D
	
	.CODE
	MENU_ACTIVE:
	PUSH	0010H	; Attribute
	PUSH	184FH	; Bottom right corner (24,79)
	PUSH	0000H	; Upper left corner (0, 0)
	CALL	CLEAR_SCREEN_SQUARE
	ADD		SP, 6
	
	CALL	PRINT_MENU
	CALL	PRINT_SELECTION
	CALL	SHOW_CURSOR	
	
	MOV		AX, 4D
	MOV		CX, 380D
	MOV		DX, 96D
	INT		33H
	
	CALL	CHECK_MOUSE_CYCLE
	MOV		MOUSE_FLAG, 0D
	
	JMP		MENU_ACTIVE
		
	RET

SHOW_MENU ENDP


; ---------------------------------------------------;
; Prints selection squares.
; ---------------------------------------------------;
PRINT_SELECTION PROC NEAR

	; Line counter
	MOV		DX, 26
	PRINT_SELECTION_CYCLEX:
		MOV		CX, 03D
		MOV		AX, 10	
		PRINT_SELECTION_CYCLEY:
			; Pushes register in the stack for later restore
			PUSHA
			
			PUSH	AX
			PUSH	DX
			CALL	GOTOXY
			ADD		SP, 4
			
			MOV		AH, 8H
			MOV		BH, 0D
			INT		10H
					
			CALL 	PUT_RED_SPACE	
				
			; Restores registers from stack
			POPA
			
			INC		AX
			INC		AX
		LOOP	PRINT_SELECTION_CYCLEY	
		DEC	DX
		CMP	DX, 08
	JNE	PRINT_SELECTION_CYCLEX
	RET

PRINT_SELECTION ENDP


; ---------------------------------------------------;
; Prints selection squares for Y.
; ---------------------------------------------------;
CHECK_MOUSE_CYCLE PROC NEAR

	NO_SELECTION:
	CALL	MOUSE_DATA
	CALL	DETERMINE_OPTION

	CMP		MOUSE_FLAG, 0D
	JE		NO_SELECTION
	
	RET

CHECK_MOUSE_CYCLE ENDP

; ----------------------------------------------------;
; Determines the selected option
; ----------------------------------------------------;
DETERMINE_OPTION PROC NEAR

	CMP	LEFT_CLICK, 1D
	JNE	EXIT_DETERMINE
	CMP	X_POSITION, 26D
	JG	EXIT_DETERMINE
	CMP	X_POSITION, 09D
	JL	EXIT_DETERMINE
	CMP	Y_POSITION, 10D
	JE	SELECT_HELP
	CMP	Y_POSITION, 12D
	JE	SELECT_PLAY	
	CMP	Y_POSITION, 14D
	JE	SELECT_EXIT

	JNE	EXIT_DETERMINE

	SELECT_HELP:
	CALL	PRINT_HELP
	MOV		MOUSE_FLAG, 1D	
	JMP		EXIT_DETERMINE
	
	SELECT_PLAY:
	CALL	HIDE_CURSOR
	CALL	GAME_INIT
	CALL	PLAY_GAME
	MOV		MOUSE_FLAG, 1D
	JMP		EXIT_DETERMINE
	
	SELECT_EXIT:
	CALL	EXIT_GAME
	
	EXIT_DETERMINE:
	RET

DETERMINE_OPTION ENDP

; ----------------------------------------------------------------- ;
; Displays a single character in the screen with the given attribute.
; TODO: Change function name or description.
; ----------------------------------------------------------------- ;
PUT_RED_SPACE	PROC NEAR
	
	MOV	AH, 09H
	;MOV	AL, 00H
	MOV	BH, 0
	MOV	BL, 47H
	MOV	CX, 01H
	INT	10H	
	
PUT_RED_SPACE ENDP

; -----------------------------------------------;
; Prints options menu.
; -----------------------------------------------;
PRINT_MENU PROC NEAR

	.DATA
	MENU		DB	'CELL WARS', 0AH
				DB	'     Click on selected option: $', 0AH 
				DB	'(Use mouse for selection)$'
	OPTION1		DB	'-> Help$'
	OPTION2		DB	'-> Play$'
	OPTION3		DB	'-> Exit$'
	MENU_OPTIONS	DW	OPTION1, OPTION2, OPTION3

	.CODE
	PUSH 	5
	PUSH	5
	CALL 	GOTOXY		; Go to selected coordinates
	ADD		SP, 4
	
	PUSH	OFFSET MENU
	CALL	COUT		; Print
	ADD		SP, 2
	; Print menu options
	MOV		CX, 03D
	MOV		BX, OFFSET MENU_OPTIONS
	MOV		AX, 10			; Line counter (starts at line 10)
	PRINT_MENU_CYCLE:
		; Pushes registers to the stack
		PUSHA
		
		PUSH	AX
		PUSH	10
		CALL	GOTOXY
		ADD		SP, 4
		
		PUSH	WORD PTR [BX]
		CALL	COUT
		ADD		SP, 2
		; Restores registers from stack
		POPA
		
		INC		AX
		INC		AX
		ADD		BX, 2
		LOOP	PRINT_MENU_CYCLE
	RET
PRINT_MENU ENDP


; ------------------------------------------------------------------------;
; Prints game help.
; ------------------------------------------------------------------------;
PRINT_HELP PROC NEAR

	.DATA
	
	INSTRUCTIONS	DB	0AH
					DB	'CELL WARS:', 0AH, 0AH
					DB  'This games starts with cells that can reproduce virus. Each player starts with  '
					DB	'one cell and the goal is to conquer neutral or enemy cells, while protecting his'
					DB	'or her own. To transfer viruses you must first select the source cell, which you'
					DB	'own, and then select the target cell. This action will send half of the virus in'
					DB	'the source cell to the target, which will be added to the count if the target is'
					DB	'owned by you or substracted from the count if is and enemy or netral cell.      '
					DB	'If a neutral or enemy cell virus count reaches zero the cell is conquered by the'
					DB	'player.																		 '
					DB	0AH
					DB	'Each owned cell generates virus at a rate dependent of its size, so bigger      '
					DB	'cells generate viruses more rapidly than smaller cells. Also, maximum virus     '
					DB	'capacity is also determined by cell size.										 '
					DB	0AH
					DB	'When a cell is selected its color changes to a lighter tone, making it easier   '
					DB  'for a player to determine which cell is selected.								 '
					DB	0AH
					DB	'The first player that manages to conquer all enemy cells wins. However, the game'
					DB	'can also end at any moment by pressing <ESC>.                                   '
					DB	0AH
					DB	'**Press any key to continue**$'
	
	.CODE
	
	CALL	HIDE_CURSOR
	
	CALL	CLEAR_SCREEN
	
	PUSH	0
	PUSH	0
	CALL	GOTOXY
	ADD		SP, 4	
	
	PUSH	OFFSET INSTRUCTIONS
	CALL	COUT		; Print instructions
	ADD		SP, 2
	
	CALL	PAUSE
	
	RET

PRINT_HELP ENDP

; -------------------------------------------------------;
; Determines the player that won.
; @param [WORD]: Position in Y
; -------------------------------------------------------;
SHOW_WINNER PROC NEAR

	.DATA
	
	VICTORY		DB	'Game Finished$'
	PLAYER1		DB 	'Congratulations! Player 1 has won!$'
	PLAYER2		DB 	'Congratulations! Player 2 has won!$'
	
	.CODE
	; Stack preparation
	PUSH 	BP
	MOV		BP, SP
	PUSHA

	PUSH	0101H	; Attribute
	PUSH	184FH	; Bottom right corner (24,79)
	PUSH	0000H	; Upper left corner (0, 0)
	CALL	CLEAR_SCREEN_SQUARE
	ADD		SP, 6	
	
	PUSH	8
	PUSH	12
	CALL	GOTOXY
	ADD		SP, 4	
	
	PUSH	OFFSET VICTORY
	CALL	COUT
	ADD		SP, 2
	
	PUSH	10
	PUSH	2
	CALL	GOTOXY
	ADD		SP, 4	
	
	MOV		AX, [BP+4]
	CMP		AX, 0
	JE		NO_WINNER
	CMP		AX, 1
	JE		WINS1
	CMP		AX, 2
	JE		WINS2
	JMP		NO_WINNER
	WINS1:
	PUSH	OFFSET PLAYER1
	CALL	COUT
	ADD		SP, 2
	JMP		NO_WINNER
	WINS2:
	PUSH	OFFSET PLAYER2
	CALL	COUT
	ADD		SP, 2
	
	NO_WINNER:
	CALL	PAUSE
	
	; Restores stack
	POPA
	POP	BP
	RET

SHOW_WINNER ENDP


