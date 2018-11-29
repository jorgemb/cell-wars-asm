; Universidad del Valle de Guatemala
; Departamento de Computacion
;
; Autores:
;	Eddy Omar Castro
;	Jorge Luis Martínez
;
; Proyecto 1 - Taller de Assembler
;	Este proyecto consiste en un juego basado en el juego online
;	llamado Phage Wars (https://armorgames.com/play/2675/phage-wars).
;

.MODEL LARGE
.STACK 10024

; Segmento que contiene los datos para hacer Double Buffering.
DBUFFER	SEGMENT
	BUFFER_PANTALLA		DB	320*200 DUP(0)
ENDS

.386
.DATA                    
; ------------------------------------------------------------ ;
; DEFINICION DE DATOS
; ------------------------------------------------------------ ;

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
;	- byte	Jugador Due�o (FF = Neutro, 00 � 01 = Jugador1, 02 � 03 = Jugador2)
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

; Datos de tiempo
TIEMPO_DELTA		DW		1		; Delta en el tiempo de frame a frame
TIEMPO_ANTERIOR		DW		0		; Contiene el tiempo del frame anterior
TIEMPO_DELTA_F		DD		0.0		; Contiene el delta del tiempo en formato de punto flotante.
TIEMPO_DIVISOR		DW		100

; Variables de control
VIRUS_VELOCIDAD		DD		20.0		; Contiene la velocidad de los virus (en pixeles por segundo).
JUEGO_ACTIVO		DB		1			; Cuando se pone en cero entonces el juego acaba.

MOUSE_PSEUDOVIRUS	DT		01516FFFFFFFFFFFFFFFFH		; Pseudo-virus utilizado para mostrar el mouse		

.CODE
; ------------------------------------------------------------ ;
; INICIO DEL C�DIGO
; ------------------------------------------------------------ ;

; Librer�as externas
INCLUDE Random.asm
INCLUDE	/IO/MouseM.asm
INCLUDE	/IO/Consola.asm
INCLUDE	/IO/IO.asm
INCLUDE /IO/Mouse.asm

INCLUDE Vector.asm

INCLUDE /Juego/Fagos.asm
INCLUDE /Juego/Virus.asm
INCLUDE /Juego/Graficos.asm
INCLUDE /Juego/Juego.asm

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
	
	CALL	MOSTRAR_MENU	
	
MAIN	ENDP

END MAIN
