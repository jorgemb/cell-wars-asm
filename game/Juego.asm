;###########################################;
; Game entry point and game cycle.			;
;###########################################;

.DATA
	; Keep track if there has been a change in time
	TIME_SECOND_CHANGE		DB	0
	TIME_SECOND_PREVIOUS	DB	0
.CODE

; Gets the system time and puts it in AX.
GET_SYSTEM_TIME PROC NEAR
	; Save registers
	PUSH	CX
	PUSH	DX
	
	; .. retrieves the time to the nearest hundredth of a second
	MOV		AH, 2CH
	INT		21H
	
	; .. updates seconds change
	CMP		DH, TIME_SECOND_PREVIOUS
	JE		GET_SYSTEM_TIME_NO_CHANGE
	MOV 	TIME_SECOND_CHANGE, 01H
	JMP		GET_SYSTEM_TIME_END
	GET_SYSTEM_TIME_NO_CHANGE:
	MOV		TIME_SECOND_CHANGE, 00H
	GET_SYSTEM_TIME_END:
	MOV		TIME_SECOND_PREVIOUS, DH
	
	; .. calculates the number of hundredths times seconds
	MOV		AL, DH		; AL = seconds
	MOV		AH, 100		;
	MUL		AH			; AX = seconds * 100
	
	MOV		DH, 0
	ADD		AX, DX		; AX = (seconds*100) + hundredths
	
	; Restore registers
	POP		DX
	POP		CX
	RET
GET_SYSTEM_TIME ENDP

; Updates the delta time per each frame in the game
; loop.
; CORRECT must be an immediate value.
UPDATE_TIME MACRO DELTA, PREVIOUS, CORRECT
	LOCAL   DONT_CORRECT

	; Save registers
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	
	; Gets current time
	CALL 	GET_SYSTEM_TIME
	CMP		AX, PREVIOUS
	JGE		DONT_CORRECT
	
	; .. do time correction
	SUB 	PREVIOUS, CORRECT
	
	; .. calculates delta
	DONT_CORRECT:
	MOV		BX, AX
	SUB		BX, PREVIOUS
	MOV		DELTA, BX
	MOV		PREVIOUS, AX
	
	; Restore registers
	POP		DX
	POP		CX
	POP		BX
	POP		AX
ENDM

; Game entry point
PLAY_GAME PROC NEAR
.DATA
	TIME_CORRECTION	EQU	6000d
.CODE
	; Initializes time and game variables
	MOV		DELTA_TIME, 1
	MOV		GAME_ACTIVE, 1
	CALL	CHANGE_GRAPHIC_MODE
	
	CALL	GET_SYSTEM_TIME
	MOV		PREVIOUS_TIME, AX
	
	; Game loop
	PLAY_GAME_LOOP:
		
		; Update every system
		CALL 	UPDATE_INPUT
		CALL 	UPDATE_LOGIC
		CALL 	UPDATE_GRAPHICS
		
		; Calculate time delta
		UPDATE_TIME 	DELTA_TIME, PREVIOUS_TIME, TIME_CORRECTION
		FILD	DELTA_TIME
		FILD	TIME_DIVIDEND
		FDIV
		FSTP	PREVIOUS_TIME_F
		
		; Check victory conditions.
		; If somebody wins the game is over.
		CALL	CHECK_VICTORY
		CMP		AX, 00
		JNE		PLAY_GAME_END
		
		CMP		GAME_ACTIVE, 0
		JNE		PLAY_GAME_LOOP
	
	PLAY_GAME_END:
	PUSH	AX
	CALL	CLEAN_KEYBOARD
	POP		AX
	
	PUSH	AX
	CALL	SHOW_WINNER
	ADD		SP, 2
	
	CALL	HIDE_CURSOR		
	CALL	CHANGE_TEXT_MODE
	RET
PLAY_GAME ENDP

; Initialize game data
GAME_INIT PROC NEAR
	; Initialize virus
	CALL	VIRUS_INITIALIZE
	CALL	SHOW_CURSOR
	
	; Initialize phages
	CALL	PHAGES_INITIALIZE
	
	RET
GAME_INIT ENDP

; Determines if one of the players was won/lost.
; @return [AX]: Returns 00 if no player has won, 01 if player one wins
; and 02 if player two won.
CHECK_VICTORY PROC NEAR
	; Save registers
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	PUSH	DI
	
	; Loops on every phage to check which player owns it.
	; If a player owns no phage then loses.
	MOV		SI, 0			; Player 1
	MOV		DI, 0			; Player 2
	MOV		CX, PHAGE_QUANTITY
	CHECK_VICTORY_CYCLE:
		; Get phage address
		MOV		DX, CX
		DEC		DX
		PHAGE_ADDRESS DX		; Address in BX
		
		; Check who owns the phage
		MOV			AL, BYTE PTR PHAGE_PLAYER[BX]
		CMP			AL, 0FFH
		JE			CHECK_VICTORY_CYCLE_END
		
		SHR			AL, 1			; Get player ID
		CMP			AL, 00H
		JNE			CHECK_VICTORY_INC_P2
			; Increments player 1
			INC		SI
			JMP		CHECK_VICTORY_CYCLE_END
		
		CHECK_VICTORY_INC_P2:
			; Increments player 2
			INC		DI
		
		CHECK_VICTORY_CYCLE_END:
		LOOP	CHECK_VICTORY_CYCLE
	
	; Checks if one of the players has zero phages
	MOV		AX, 0
	
	; .. P1
	CMP		SI, 0
	JE		VICTORY_P2
	
	; .. P2
	CMP		DI, 0
	JE		VICTORY_P1
	
	JMP		CHECK_VICTORY_END
	
	VICTORY_P2:
	MOV		AX, 02
	JMP		CHECK_VICTORY_END
	
	VICTORY_P1:
	MOV		AX, 01
	JMP		CHECK_VICTORY_END
	
	CHECK_VICTORY_END:
	; Restor registers
	POP		DI
	POP		SI
	POP		DX
	POP		CX
	POP		BX
	RET
CHECK_VICTORY ENDP

; Updates Mouse and Keyboard input
UPDATE_INPUT PROC NEAR
	; Verifies mouse and keyboard
	CALL UPDATE_KEYBOARD
	CALL UPDATE_MOUSE
	
	RET
UPDATE_INPUT ENDP

; Acts according to the pressed keys for Player 1.
UPDATE_KEYBOARD PROC NEAR
	PUSHA

	; Verify keyboard state
	PUSH	0
	CALL	GETC_EXTENDED
	ADD		SP, 2
	
	CMP		AL, 0
	JE		UPDATE_KEYBOARD_END
	
	; ESCAPE - Ends the game
	CMP		AL, 27
	JNE		UPDATE_KEYBOARD_ESCAPE
	MOV		GAME_ACTIVE, 0	
	JMP		UPDATE_KEYBOARD_END
	
	UPDATE_KEYBOARD_ESCAPE:
	
	MOV		DH, 0
	MOV		DL, AL
	
	; Checks if the pressed key is a number
	BP2:
	PUSH	30H		; Menor
	PUSH	39H		; Mayor
	PUSH	DX		; Tecla
	CALL	VERIFY_VALUE
	ADD		SP, 6
	
	CMP		AH, 0
	JE		UPDATE_KEYBOARD_SHIFT
	
	; A number was pressed without shift, so a phage is selected.
	SUB		DX, 30H
	PUSH	DX
	PUSH	0
	CALL	PHAGE_SELECT
	ADD		SP, 4
	JMP		UPDATE_KEYBOARD_END
	
	UPDATE_KEYBOARD_SHIFT:
	; Verifies shift codes
	PUSH	20H		; Minor
	PUSH	29H		; Mayor
	PUSH	DX		; Key
	CALL	VERIFY_VALUE
	ADD		SP, 6
	
	CMP		AH, 0
	JNE		UPDATE_KEYBOARD_SEND
	
	; Check special cases for 7 and 0
	CMP		DL, 2FH
	JNE		UPDATE_KEYBOARD_CASE0
	MOV		DL, 27H
	JMP		UPDATE_KEYBOARD_SEND
	
	UPDATE_KEYBOARD_CASE0:
	CMP		DL, 3DH
	JNE		UPDATE_KEYBOARD_END
	MOV		DL, 20H
	JMP		UPDATE_KEYBOARD_SEND
	
	; Sends the viruses to the selected phage
	UPDATE_KEYBOARD_SEND:
	SUB		DL, 20H
	
	PUSH	0
	CALL	PHAGE_GET_SELECTED
	ADD		SP, 2
	
	CMP		AX, 0FFH
	JE		UPDATE_KEYBOARD_END
	CMP		AX, DX
	JE		UPDATE_KEYBOARD_END
	
	PUSH	DX
	PUSH	AX
	CALL	PHAGES_MOVILIZE_VIRUS
	ADD		SP, 4

	UPDATE_KEYBOARD_END:
	POPA
	RET
UPDATE_KEYBOARD ENDP

; Updates the mouse on the screen, and acts if left or right
; clic is pressed.
UPDATE_MOUSE PROC NEAR
	; Save registers
	PUSHA

	CALL	MOUSE_DATA
	
	; Mouse data is saved in a pseudo-virus
	MOV		BX, OFFSET MOUSE_PSEUDOVIRUS
	MOV		AX, WORD PTR PIXELPOS_X
	SHR		AX, 1
	MOV		WORD PTR PIXELPOS_X, AX
	FILD	WORD PTR PIXELPOS_X
	FSTP	DWORD PTR VIRUS_X[BX]
	
	FILD	WORD PTR PIXELPOS_Y
	FSTP	DWORD PTR VIRUS_Y[BX]
	
	; Verifies button status
	; .. left clic
	CMP		LEFT_CLICK, 01H
	JNE		UPDATE_MOUSE_RIGHTCLICK
	
	PUSH	OFFSET MOUSE_PSEUDOVIRUS
	CALL	VIRUS_COLLISION_PHAGE_MOUSE
	ADD		SP, 2
	
	CMP		AH, 01
	JNE		UPDATE_MOUSE_RIGHTCLICK
	
	; Selects the phage for player 2
	MOV		AH, 0
	PUSH	AX
	PUSH	1
	CALL 	PHAGE_SELECT
	ADD		SP, 4
	
	UPDATE_MOUSE_RIGHTCLICK:
	; Verifies right click
	CMP		RIGHT_CLICK, 01H
	JNE		UPDATE_MOUSE_END
	
	PUSH	OFFSET MOUSE_PSEUDOVIRUS
	CALL	VIRUS_COLLISION_PHAGE_MOUSE
	ADD		SP, 2
	
	CMP		AH, 01
	JNE		UPDATE_MOUSE_END
	
	; Sends virus to the selected phage
	MOV		AH, 0
	MOV		DX, AX		; DX has target phage
	
	PUSH	1
	CALL	PHAGE_GET_SELECTED
	ADD		SP, 2
	
	; Check that source and destination is not the same phage
	CMP		AX, DX
	JE		UPDATE_MOUSE_END
	
	; Checks that the selected phage exists
	CMP		AX, 0FFH
	JE		UPDATE_MOUSE_END
	
	; Activates the viruses
	PUSH	DX
	PUSH	AX
	CALL	PHAGES_MOVILIZE_VIRUS
	ADD		SP, 4
	
	UPDATE_MOUSE_END:
	; Restore registers
	POPA
	RET
UPDATE_MOUSE ENDP

; Updates all the game simulation.
UPDATE_LOGIC PROC NEAR
	CALL 	UPDATE_VIRUSES
	
	; Updates the phages on every second
	CMP		TIME_SECOND_CHANGE, 00H
	JE		UPDATE_LOGIC_NOPHAGE
	CALL	UPDATE_PHAGES
	UPDATE_LOGIC_NOPHAGE:
	
	RET
UPDATE_LOGIC ENDP

; ---------------------------------------------------- ;
; Pinta la pantalla para actualizar los objetos del
; juego a sus nuevas posiciones.
; ---------------------------------------------------- ;
UPDATE_GRAPHICS PROC NEAR
	PUSHA

	; Borra lo que hab�a en pantalla
	; MOV		AX, 00H
	; MOV		DI, 0000H
	; MOV		CX, 64000
	; REP		STOSB
	CLEAN_BUFFER DBUFFER, 64000, 0FFH
	; CLEAN_BUFFER 0A000H, 64000, 0FFH
	
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
		DRAW_POINT BX, AX, 2FH
		JMP ACTUALIZAR_GRAFICOS_CICLO_FIN
		JUG_1:
		DRAW_POINT BX, AX, 29H
		
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
		CALL	DRAW_IMAGE
		ADD		SP, 8
			
		PUSH	WORD PTR PHAGE_Y[BX]
		PUSH	WORD PTR PHAGE_X[BX]
		PUSH 	WORD PTR PHAGE_NVIRUS[BX]
		CALL	PRINT_VIRUS_QUANTITY
		ADD		SP, 6		
	
		ACTUALIZAR_FAGO_NO_DIBUJO:
	LOOP ACTUALIZAR_FAGOS_CICLO	
	
	; Dibuja la posici�n del mouse utilizando su pseudo-virus
	MOV		BX, OFFSET MOUSE_PSEUDOVIRUS	
	; ..Obtiene la posici�n del virus, copia PosX en BX y PosY en AX
	VIRUS_POSICION BX, BX, AX
	DRAW_POINT BX, AX, 64H
	
	
	; Copiar los datos del buffer (Double Buffering)
	BLIT_BUFFER DBUFFER, 0A000H, 64000
	
	POPA
	RET
UPDATE_GRAPHICS ENDP


