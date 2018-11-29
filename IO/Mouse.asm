;###########################################;
;Universidad del Valle de Guatemala			;
;Organización de computadoras y Assembler	;
;											;
; Biblioteca que contiene las funciones para;
; el manejo de mouse 						;
;											;
;Eddy Omar Castro Jáuregui - 11032			;
;Jorge Luis Martínez Bonilla - 11237		;
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
MOSTRAR_CURSOR PROC NEAR

	PUSHA
	
	MOV	AX, 1
	INT 33H
	
	POPA
	RET

MOSTRAR_CURSOR ENDP


; ---------------------------------------------------;
; Este procedimiento oculta el cursor
; ---------------------------------------------------;
OCULTAR_CURSOR PROC NEAR

	PUSHA
	
	MOV	AX, 2
	INT 33H
	
	POPA
	RET

OCULTAR_CURSOR ENDP


; ---------------------------------------------------;
; Este procedimiento obtiene datos del mouse
; ---------------------------------------------------;
DATOS_MOUSE PROC NEAR
	
	.DATA
	POSICIONP_X		DW	0D
	POSICIONP_Y		DW	0D
	POSICION_X		DW	0D
	POSICION_Y		DW	0D
	CLICK_DERECHO	DW	0D
	CLICK_IZQUIERDO	DW	0D
	
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

DATOS_MOUSE ENDP

; --------------------------------------------------------------;
; Este procedimiento verifica el estado de los botones del mouse
; --------------------------------------------------------------;
VERIFICAR_ESTADO_MOUSE PROC NEAR

	PUSHA
	
	MOV	DX, BX
	AND	DX, 00000001B
	MOV	CLICK_IZQUIERDO, DX
	
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
	MOV	POSICION_Y, DX
	
	SHR	CX, 1
	SHR	CX, 1
	SHR	CX, 1
	MOV	POSICION_X, CX

	RET

CONVERTIR_COORDENADAS_MOUSE ENDP
