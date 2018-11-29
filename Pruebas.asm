;Universidad del Valle de Guatemala
;Departamento de Computacion
;
;
;

.MODEL LARGE
.STACK 2048

DBUFFER	SEGMENT
	BUFFER_PANTALLA		DB	320*200 DUP(0)
ENDS

.386
.DATA                 
TIEMPO_DELTA		DW		1		; Delta en el tiempo de frame a frame
TIEMPO_ANTERIOR		DW		0		; Contiene el tiempo del frame anterior
JUEGO_ACTIVO		DB		1		; Cuando se pone en cero entonces el juego acaba.

; DATOS PARA LOS VIRUS --------------------------------------- ;
; La estructura para un virus es de la siguiente manera:
; (Los float equivalen a un dword, es decir 32-bits o 4 bytes)
;	- float PosicionX
;	- float PosicionY
;	- byte FagoDestino
;	- byte FagoFuente
; TOTAL: 10 Bytes por virus
CANTIDAD_VIRUS		EQU		1000
TAMANO_VIRUS		EQU		10


VIRUS_X				EQU		0
VIRUS_Y				EQU		4
VIRUS_FAGO			EQU		8
VIRUS_FUENTE		EQU		9
VIRUS				DT		CANTIDAD_VIRUS DUP ( 0 )
; ------------------------------------------------------------ ;

; DATOS PARA LOS FAGOS---------------------------------------- ;
; La estructura de los fagos es de la siguiente manera
;	- word	PosX
;	- word	PosY
;	- byte	Radio
;	- byte	Jugador Dueño (FF = Neutro, 00 ó 01 = Jugador1, 02 ó 03 = Jugador2)
;	- word	Imagen
;	- word	Cantidad de Virus
; TOTAL: 10 bytes por fago
CANTIDAD_FAGOS		EQU		10
TAMANO_FAGO			EQU		10
FAGOS_TOTAL_BYTES	EQU		CANTIDAD_FAGOS*TAMANO_FAGO

FAGO_X				EQU		0
FAGO_Y				EQU		2
FAGO_RADIO			EQU		4
FAGO_JUGADOR		EQU		5
FAGO_IMAGEN			EQU		6
FAGO_NVIRUS			EQU		8
FAGOS				DT		CANTIDAD_FAGOS DUP ( 00000000FF0000000000H )
; ------------------------------------------------------------ ;

TIEMPO_DELTA_F		DD		0.0
TIEMPO_DIVISOR		DW		100
VIRUS_VELOCIDAD		DD		20.0

MOUSE_PSEUDOVIRUS	DT		0		; Pseudo-virus utilizado para mostrar el mouse		
; AGREGAR

.CODE
INCLUDE Random.asm
INCLUDE Juego/Graficos.asm
INCLUDE /Juego/Fagos.asm
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
	; MOV		BX, OFFSET FAGOS
	; MOV		WORD PTR FAGO_X[BX], 30
	; MOV		WORD PTR FAGO_Y[BX], 30
	; MOV		BYTE PTR FAGO_RADIO[BX], 15
	; MOV		BYTE PTR FAGO_JUGADOR[BX], 0
	; MOV		WORD PTR FAGO_IMAGEN[BX], OFFSET FAGO_2
	; MOV		WORD PTR FAGO_NVIRUS[BX], 10
	
	; ; FAGO 2
	; ADD		BX, TAMANO_FAGO
	; MOV		WORD PTR FAGO_X[BX], 100
	; MOV		WORD PTR FAGO_Y[BX], 100
	; MOV		BYTE PTR FAGO_RADIO[BX], 15
	; MOV		BYTE PTR FAGO_JUGADOR[BX], 2
	; MOV		WORD PTR FAGO_IMAGEN[BX], OFFSET FAGO_2
	; MOV		WORD PTR FAGO_NVIRUS[BX], 10
	
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
SALIR PROC NEAR
	
	PUSH	0
	PUSH	0
	CALL	GOTOXY
	ADD		SP, 4	
	
	CALL	OCULTAR_CURSOR	
	
	CALL	CLEAR_SCREEN
	
    MOV AH, 4CH   		;salida al DOS
	INT 21H
	
SALIR ENDP

; ------------------------------ ;
; Punto de entrada del programa. 
; ------------------------------ ;
MAIN	PROC FAR
	.STARTUP		; otra forma de inicializar el segmento
	FINIT
	
	CALL INICIALIZAR
	CALL JUGAR
	
    MOV AH, 4CH   		;salida al DOS
	INT 21H
	
MAIN	ENDP
END MAIN

