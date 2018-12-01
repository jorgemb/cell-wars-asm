;###########################################;
;Universidad del Valle de Guatemala			;
;Organizaci�n de computadoras y Assembler	;
;											;
; Biblioteca que contiene las funciones para;
; el manejo de mouse 						;
;											;
;Eddy Omar Castro J�uregui - 11032			;
;Jorge Luis Mart�nez Bonilla - 11237		;
;###########################################;

; ---------------------------------------------------;
; Este procedimiento inicializa el mouse
; ---------------------------------------------------;
INICIAR_MOUSE PROC NEAR

	PUSHA
	
	MOV	AX, 0
	INT 33H
	
	POPA
	RET

INICIAR_MOUSE ENDP


; ---------------------------------------------------;
; Este procedimiento muestra el cursor
; ---------------------------------------------------;
SHOW_CURSOR PROC NEAR

	PUSHA
	
	MOV	AX, 1
	INT 33H
	
	POPA
	RET

SHOW_CURSOR ENDP


; ---------------------------------------------------;
; Este procedimiento oculta el cursor
; ---------------------------------------------------;
HIDE_CURSOR PROC NEAR

	PUSHA
	
	MOV	AX, 2
	INT 33H
	
	POPA
	RET

HIDE_CURSOR ENDP


; ---------------------------------------------------;
; Este procedimiento obtiene datos del mouse
; ---------------------------------------------------;
MOUSE_DATA PROC NEAR
	
	.DATA
	POSICIONP_X		DW	0D
	POSICIONP_Y		DW	0D
	X_POSITION		DW	0D
	Y_POSITION		DW	0D
	CLICK_DERECHO	DW	0D
	LEFT_CLICK	DW	0D
	
	.CODE

	PUSHA
	
	MOV	AX, 3
	INT 33H
	; almacenar valores de coordenadas en pixeles
	MOV	POSICIONP_X, CX
	MOV	POSICIONP_Y, DX
	
	CALL	VERIFICAR_ESTADO_MOUSE
	CALL	CONVERTIR_COORDENADAS_MOUSE
	
	POPA
	RET

MOUSE_DATA ENDP

; --------------------------------------------------------------;
; Este procedimiento verifica el estado de los botones del mouse
; --------------------------------------------------------------;
VERIFICAR_ESTADO_MOUSE PROC NEAR

	PUSHA
	
	MOV	DX, BX
	AND	DX, 00000001B
	MOV	LEFT_CLICK, DX
	
	MOV	DX, BX
	AND	DX, 00000010B
	SHR	DX, 1
	MOV	CLICK_DERECHO, DX
	
	POPA
	RET

VERIFICAR_ESTADO_MOUSE ENDP

; ---------------------------------------------------;
; Este procedimiento convierte las coodenadas a 80x25
; ---------------------------------------------------;
CONVERTIR_COORDENADAS_MOUSE PROC NEAR

	SHR	DX, 1
	SHR	DX, 1
	SHR	DX, 1
	MOV	Y_POSITION, DX
	
	SHR	CX, 1
	SHR	CX, 1
	SHR	CX, 1
	MOV	X_POSITION, CX

	RET

CONVERTIR_COORDENADAS_MOUSE ENDP
