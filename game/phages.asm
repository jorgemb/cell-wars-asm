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
					DW	OFFSET PHAGE_1		; Image
					DW	0010		; Initial virus amount
					
					; Phage 1
					DW	030, 030	; PosX,PosY
					DB	25, 00		; Radius, Owner
					DW	OFFSET PHAGE_1		; Image
					DW	0010		; Initial virus amount
					
					; Phage 2
					DW	030, 93		; PosX,PosY
					DB	15, 0FFH	; Radius, Owner
					DW	OFFSET PHAGE_2		; Image
					DW	0020		; Initial virus amount
					
					; Phage 3
					DW	160, 20		; PosX,PosY
					DB	10, 0FFH	; Radius, Owner
					DW	OFFSET PHAGE_3		; Image
					DW	0010		; Initial virus amount
					
					; Phage 4
					DW	128, 060	; PosX,PosY
					DB	10, 0FFH	; Radius, Owner
					DW	OFFSET PHAGE_3		; Image
					DW	0010		; Initial virus amount
					
					; Phage 5
					DW	120, 140	; PosX,PosY
					DB	10, 0FFH	; Radius, Owner
					DW	OFFSET PHAGE_3	; Image
					DW	0010		; Initial virus amount
					
					; Phage 6
					DW	200, 140		; PosX,PosY
					DB	10, 0FFH	; Radius, Owner
					DW	OFFSET PHAGE_3	; Image
					DW	0010		; Initial virus amount
					
					; Phage 7
					DW	192, 060		; PosX,PosY
					DB	10, 0FFH	; Radius, Owner
					DW	OFFSET PHAGE_3	; Image
					DW	0010		; Initial virus amount
					
					; Phage 8
					DW	160, 100		; PosX,PosY
					DB	15, 0FFH	; Radius, Owner
					DW	OFFSET PHAGE_2	; Image
					DW	0050		; Initial virus amount
					
					; Phage 9
					DW	290, 107		; PosX,PosY
					DB	15, 0FFH	; Radius, Owner
					DW	OFFSET PHAGE_2	; Image
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

; Verifies if there was a collision with another phage. If the virus
; collides with a phage then AH=01; if collides with target
; phage then AL = FF. If collides with any phage other than the target
; then AL contains the ID of the other phage.
; @param [WORD]: Address of the virus to verify
; @return [AX]: Collision values (see description)
VIRUS_COLLISION_PHAGE_MOUSE PROC NEAR
	; Stack init
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	
	; Registry init
	MOV		AX, 0
	MOV		BX, [BP+4]		; Virus ID
	MOV		SI, BX
	
	; Checks collisions with every phage
	MOV		CX, PHAGE_QUANTITY
	VIRUS_COLLISION_PHAGE_CYCLE_M:
		; Verifies if collision phage is source phage
		MOV		DX, CX
		DEC		DX
		
		CMP		DL, VIRUS_SOURCE[SI]
		JE		VIRUS_COLLISION_PHAGE_ENDCYCLE_M

		; Obtains the direction from the virus to the phage and the distance
		MOV		SI, [BP+4]
		PHAGE_ADDRESS DX	; Phage address 
		
		PUSH	00			; Unnormalized vector
		PUSH	BX			; Phage address
		PUSH	SI			; Virus address
		CALL 	VIRUS_PHAGE_VECTOR
		ADD		SP, 6
		
		PUSH	OFFSET FP1	; Source vector
		CALL	VECTOR_MAGNITUDE
		ADD		SP, 2
		
		; Compares the phage radius with the vector magnitude
		MOVSX	AX, BYTE PTR PHAGE_RADIUS[BX]
		MOV		WORD PTR FP1, AX
		FICOMP	WORD PTR FP1			; CMP Radius distance
		
		FSTSW	AX
		SAHF
		JAE		VIRUS_COLLISION_PHAGE_ENDCYCLE_M
		
		; .. collision!
		MOV		AH, 1
		
		; .. checks if collision is with target
		CMP		DL, VIRUS_PHAGE[SI]
		JE		COLLISION_TARGET_M
		
		MOV		AL, DL
		JMP		VIRUS_COLLISION_PHAGE_END_M
	
		COLLISION_TARGET_M:
		MOV		AL, 0FFH
		JMP		VIRUS_COLLISION_PHAGE_END_M
	
		VIRUS_COLLISION_PHAGE_ENDCYCLE_M:
		MOV		AX, 0
		
		DEC		CX
		JZ		VIRUS_COLLISION_PHAGE_END_M
		JMP		VIRUS_COLLISION_PHAGE_CYCLE_M
	
	VIRUS_COLLISION_PHAGE_END_M:
	
	; Reset stack
	POP		SI
	POP		DX
	POP		CX
	POP		BX
	POP		BP
	RET
VIRUS_COLLISION_PHAGE_MOUSE ENDP

; Moves half the viruses in a phage to the target phage
; @param [WORD]: ID of source phage
; @param [WORD]: ID of target phage
PHAGES_MOVILIZE_VIRUS PROC NEAR
.DATA
	; Minimum amount of virus that a phage must have
	; in order to be able to send viruses
	MINIMO_VIRUS 	DW	5
.CODE
	; Prepares the stack
	PUSH	BP
	MOV		BP, SP
	PUSHA

	; Retrieves the phage address
	MOV		DX, [BP+4]		; Source phage ID
	PHAGE_ADDRESS DX		; Address in BX
	MOV		SI, BX
	
	; Gets half the viruses in the source and activates them
	MOV		AX, PHAGE_NVIRUS[SI]
	;.. checks mimimum amount of viruses
	CMP		AX, MINIMO_VIRUS
	JL		PHAGES_MOVILIZE_VIRUS_END
	
	SHR		AX, 1
	
	SUB		WORD PTR PHAGE_NVIRUS[SI], AX
	
	PUSH	WORD PTR [BP+4]			; ID Source phage
	PUSH	WORD PTR [BP+6]			; ID Target phage
	PUSH	AX				; Amount of viruses to activate
	CALL	VIRUS_ACTIVATE
	ADD		SP, 6
	
	PHAGES_MOVILIZE_VIRUS_END:
	
	; Restores the stack
	POPA
	POP		BP
	RET
PHAGES_MOVILIZE_VIRUS ENDP

; Updates the phages' virus count. The ratio used is 
; 1/5 of the radius per second.
UPDATE_PHAGES PROC NEAR
.DATA
	PHAGES_INCREASE	DW		5
.CODE
	; Saves registers
	PUSHA
	
	; Loops on every phage
	MOV		CX, PHAGE_QUANTITY
	PHAGES_UPDATE_CYCLE:
		MOV		DX, CX
		DEC		DX			; ID of current phage
		PHAGE_ADDRESS DX	; Address in BX
		
		; Checks that the phage belongs to a player
		CMP		BYTE PTR PHAGE_PLAYER[BX], 0FFH
		JE		PHAGES_UPDATE_CYCLE_END
		
		; Increases the amount of viruses in the phage
		MOVZX	AX, BYTE PTR PHAGE_RADIUS[BX]
		MOV		DX, 0
		DIV		WORD PTR PHAGES_INCREASE
		
		ADD		PHAGE_NVIRUS[BX], AX
		
		; .. checks that the amount of viruses is not greater
		; than twice its radius.
		MOVSX	AX, BYTE PTR PHAGE_RADIUS[BX]
		SHL		AX, 1
		CMP		AX, WORD PTR PHAGE_NVIRUS[BX]
		JG		PHAGES_UPDATE_CYCLE_END
		MOV		WORD PTR PHAGE_NVIRUS[BX], AX
		
		PHAGES_UPDATE_CYCLE_END:
		LOOP	PHAGES_UPDATE_CYCLE
	
	; Restore registers
	POPA
	RET
UPDATE_PHAGES ENDP

; Returns the ID of the selected phage.
; @param [WORD]: ID of the player(0 = Player 1, 1 = Player 2)
; @return [AX]: ID of selected phage
; 		( FF0 if no phage is selected)
; ------------------------------------------------------------ ;
PHAGE_GET_SELECTED PROC NEAR
	; Stack init
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	CX
	PUSH	DX
	
	MOV		AX, [BP+4]		; Player ID
	SHL		AX, 1			; Corrects ID (0 = P1 y 2 = P2)
	
	; Loops on every phage
	MOV		CX, PHAGE_QUANTITY
	PHAGE_GET_SELECTED_CYCLE:
		MOV		DX, CX
		DEC		DX			; Position correction
		
		; Get phage address
		PHAGE_ADDRESS DX	; Address in BX
		
		; Checks if the phage belongs to the player
		MOVZX		DX, BYTE PTR PHAGE_PLAYER[BX]
		SHR			DX, 1
		SHL			DX, 1
		CMP			DX, AX
		JNE			PHAGE_GET_S_CYCLE_END
		
		; Verificar si el fago est� seleccionado
		CMP			DL, BYTE PTR PHAGE_PLAYER[BX]
		JE			PHAGE_GET_S_CYCLE_END

		; .. if not the same means it was selected
		MOV			AX, CX
		DEC			AX
		JMP			PHAGE_GET_S_END
		
		PHAGE_GET_S_CYCLE_END:
		LOOP PHAGE_GET_SELECTED_CYCLE
	
	MOV		AX, 0FFH			; No phage found
	JMP		PHAGE_GET_S_END
	
	PHAGE_GET_S_END:
	; Restore stack
	POP		DX
	POP		CX
	POP		BX
	POP		BP
	RET
PHAGE_GET_SELECTED ENDP

; Tries to select a phage for a player, but only if the player
; owns the phage. Deselects any other phage of the player.
; @param [WORD]: ID of the player (P1 = 0, P2 = 1)
; @param [WORD]: ID of the phage to select
; --------------------------------------------------------------- ;
PHAGE_SELECT PROC NEAR
	; Stack init
	PUSH	BP
	MOV		BP, SP
	PUSHA
	
	; Deselects all the phages of the player
	PUSH	WORD PTR [BP+4] 		; ID of the player
	CALL	PHAGE_DESELECT
	ADD		SP, 2
	
	; Determines if the phage belongs to the player
	MOV		AX, [BP+4]		; ID of the player
	SHL		AX, 1			; Player ID correction (P1 = 0, P2 = 2)
	
	MOV		DX, [BP+6]		; ID of the phage
	PHAGE_ADDRESS DX		; Address in BX
	
	CMP		AL, BYTE PTR PHAGE_PLAYER[BX]
	JNE		PHAGE_SELECT_END
	
	; .. selecciona el fago objetivo
	INC		AL
	MOV		BYTE PTR PHAGE_PLAYER[BX], AL
	
	PHAGE_SELECT_END:
	; Restores the stack
	POPA
	POP		BP
	RET
PHAGE_SELECT ENDP

; Deselects any phage selected by a player.
; @param [WORD]: ID of the player (P1 = 0, P2 = 1)
PHAGE_DESELECT PROC NEAR
	; Prepares the stack
	PUSH	BP
	MOV		BP, SP
	PUSHA
	
	MOV		AX, [BP+4]		; ID of the player
	SHL		AX, 1			; Corrects the ID of the player (P1=0,P2=1)
	
	; Loops on every phage
	MOV		CX, PHAGE_QUANTITY
	PHAGE_DESELECT_CYCLE:
		MOV		DX, CX
		DEC		DX			; Position correction
		
		; Gets the address of the phage and its player
		PHAGE_ADDRESS DX	; Address in BX
		
		MOVZX	DX, BYTE PTR PHAGE_PLAYER[BX]
		SHR		DX, 1
		SHL		DX, 1	; Remove selection bit
		CMP		AX, DX
		JNE		PHAGE_DESELECT_CYCLE_END
		
		; Deselecciona el fago
		MOV		BYTE PTR PHAGE_PLAYER[BX], AL
		
		PHAGE_DESELECT_CYCLE_END:
		LOOP PHAGE_DESELECT_CYCLE
	
	; Restores the stack
	POPA
	POP		BP
	RET
PHAGE_DESELECT ENDP


