;Universidad del Valle de Guatemala
;Departamento de Computacion
;
;
;

.MODEL LARGE
.STACK 2048

DBUFFER	SEGMENT
	SCREEN_BUFFER		DB	320*200 DUP(0)
ENDS

.386
.DATA                 
DELTA_TIME		DW		1		; Delta en el tiempo de frame a frame
PREVIOUS_TIME		DW		0		; Contiene el tiempo del frame anterior
GAME_ACTIVE		DB		1		; Cuando se pone en cero entonces el juego acaba.

; DATOS PARA LOS VIRUS --------------------------------------- ;
; La estructura para un virus es de la siguiente manera:
; (Los float equivalen a un dword, es decir 32-bits o 4 bytes)
;	- float PosicionX
;	- float PosicionY
;	- byte FagoDestino
;	- byte FagoFuente
; TOTAL: 10 Bytes por virus
VIRUS_QUANTITY		EQU		1000
VIRUS_SIZE		EQU		10


VIRUS_X				EQU		0
VIRUS_Y				EQU		4
VIRUS_PHAGE			EQU		8
VIRUS_SOURCE		EQU		9
VIRUS				DT		VIRUS_QUANTITY DUP ( 0 )
; ------------------------------------------------------------ ;

; DATOS PARA LOS PHAGES---------------------------------------- ;
; La estructura de los PHAGES es de la siguiente manera
;	- word	PosX
;	- word	PosY
;	- byte	Radio
;	- byte	Jugador Due�o (FF = Neutro, 00 � 01 = Jugador1, 02 � 03 = Jugador2)
;	- word	Imagen
;	- word	Cantidad de Virus
; TOTAL: 10 bytes por fago
PHAGE_QUANTITY		EQU		10
PHAGE_SIZE			EQU		10
PHAGE_TOTAL_BYTES	EQU		PHAGE_QUANTITY*PHAGE_SIZE

PHAGE_X				EQU		0
PHAGE_Y				EQU		2
PHAGE_RADIUS			EQU		4
PHAGE_PLAYER		EQU		5
PHAGE_IMAGE			EQU		6
PHAGE_NVIRUS			EQU		8
PHAGES				DT		PHAGE_QUANTITY DUP ( 00000000FF0000000000H )
; ------------------------------------------------------------ ;

PREVIOUS_TIME_F		DD		0.0
TIME_DIVIDEND		DW		100
VIRUS_VELOCITY		DD		20.0

MOUSE_PSEUDOVIRUS	DT		0		; Pseudo-virus utilizado para mostrar el mouse		
; AGREGAR

.CODE
INCLUDE Random.asm
INCLUDE Juego/Graficos.asm
INCLUDE /Juego/PHAGES.asm
INCLUDE Juego/Virus.asm
INCLUDE Juego/Juego.asm

INCLUDE IO/IO.asm
INCLUDE IO/Mouse.asm
INCLUDE IO/MouseM.asm
INCLUDE	IO/Consola.asm
INCLUDE Vector.asm

; Inicio del codigo
	
INICIALIZAR PROC NEAR
	CALL	FAGOS_INICIALIZAR
	
	; ; FAGO 1
	; MOV		BX, OFFSET PHAGES
	; MOV		WORD PTR PHAGE_X[BX], 30
	; MOV		WORD PTR PHAGE_Y[BX], 30
	; MOV		BYTE PTR PHAGE_RADIUS[BX], 15
	; MOV		BYTE PTR PHAGE_PLAYER[BX], 0
	; MOV		WORD PTR PHAGE_IMAGE[BX], OFFSET FAGO_2
	; MOV		WORD PTR PHAGE_NVIRUS[BX], 10
	
	; ; FAGO 2
	; ADD		BX, PHAGE_SIZE
	; MOV		WORD PTR PHAGE_X[BX], 100
	; MOV		WORD PTR PHAGE_Y[BX], 100
	; MOV		BYTE PTR PHAGE_RADIUS[BX], 15
	; MOV		BYTE PTR PHAGE_PLAYER[BX], 2
	; MOV		WORD PTR PHAGE_IMAGE[BX], OFFSET FAGO_2
	; MOV		WORD PTR PHAGE_NVIRUS[BX], 10
	
	CALL	VIRUS_INICIALIZAR
	
	; Activar 3 virus
	PUSH	1				; Fago Fuente
	PUSH	2				; Fago Destino
	PUSH	1				; Cantidad de virus
	CALL	VIRUS_ACTIVAR
	ADD		SP, 6
	
	PUSH	0
	PUSH	1
	PUSH	1
	CALL	VIRUS_ACTIVAR
	ADD		SP, 6
	
	PUSH	2
	PUSH	1
	PUSH	1
	CALL	VIRUS_ACTIVAR
	ADD		SP, 6
	
	RET
INICIALIZAR ENDP

; ------------------------------ ;
; Salida del programa 
; ------------------------------ ;
EXIT_GAME PROC NEAR
	
	PUSH	0
	PUSH	0
	CALL	GOTOXY
	ADD		SP, 4	
	
	CALL	HIDE_CURSOR	
	
	CALL	CLEAR_SCREEN
	
    MOV AH, 4CH   		;salida al DOS
	INT 21H
	
EXIT_GAME ENDP

; ------------------------------ ;
; Punto de entrada del programa. 
; ------------------------------ ;
MAIN	PROC FAR
	.STARTUP		; otra forma de inicializar el segmento
	FINIT
	
	CALL INICIALIZAR
	CALL PLAY_GAME
	
    MOV AH, 4CH   		;salida al DOS
	INT 21H
	
MAIN	ENDP
END MAIN

