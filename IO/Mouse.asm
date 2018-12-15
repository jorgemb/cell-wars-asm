;###########################################;
; Mouse utilities. 							;
;###########################################;

; ---------------------------------------------------;
; Mouse initialization
; ---------------------------------------------------;
MOUSE_INIT PROC NEAR

	PUSHA
	
	MOV	AX, 0
	INT 33H
	
	POPA
	RET

MOUSE_INIT ENDP


; ---------------------------------------------------;
; Shows the cursor on the screen
; ---------------------------------------------------;
SHOW_CURSOR PROC NEAR

	PUSHA
	
	MOV	AX, 1
	INT 33H
	
	POPA
	RET

SHOW_CURSOR ENDP


; ---------------------------------------------------;
; Hides the cursor
; ---------------------------------------------------;
HIDE_CURSOR PROC NEAR

	PUSHA
	
	MOV	AX, 2
	INT 33H
	
	POPA
	RET

HIDE_CURSOR ENDP


; ---------------------------------------------------;
; Returns mouse data like position and click status.
; ---------------------------------------------------;
MOUSE_DATA PROC NEAR
	
	.DATA
	PIXELPOS_X		DW	0D
	PIXELPOS_Y		DW	0D
	POSITION_X		DW	0D
	POSITION_Y		DW	0D
	RIGHT_CLICK		DW	0D
	LEFT_CLICK		DW	0D
	
	.CODE

	PUSHA
	
	MOV	AX, 3
	INT 33H

	; Saves pixel coordinates
	MOV	PIXELPOS_X, CX
	MOV	PIXELPOS_Y, DX
	
	CALL	CHECK_MOUSE_STATUS
	CALL	CONVERT_MOUSE_COORDINATES
	
	POPA
	RET

MOUSE_DATA ENDP

; --------------------------------------------------------------;
; Verifies mouse buttons status.
; --------------------------------------------------------------;
CHECK_MOUSE_STATUS PROC NEAR

	PUSHA
	
	MOV	DX, BX
	AND	DX, 00000001B
	MOV	LEFT_CLICK, DX
	
	MOV	DX, BX
	AND	DX, 00000010B
	SHR	DX, 1
	MOV	RIGHT_CLICK, DX
	
	POPA
	RET

CHECK_MOUSE_STATUS ENDP

; ---------------------------------------------------;
; Converts mouse coordinates to a 80x25 resolution.
; ---------------------------------------------------;
CONVERT_MOUSE_COORDINATES PROC NEAR

	SHR	DX, 1
	SHR	DX, 1
	SHR	DX, 1
	MOV	POSITION_Y, DX
	
	SHR	CX, 1
	SHR	CX, 1
	SHR	CX, 1
	MOV	POSITION_X, CX

	RET

CONVERT_MOUSE_COORDINATES ENDP
