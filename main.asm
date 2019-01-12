; Universidad del Valle de Guatemala
; Computer Science Department
;
; Authors:
;	Eddy Omar Castro
;	Jorge Luis Martínez
;
; Translation to English:
;	Jorge Luis Martínez
;
;	Clone of the online game Phage Wars by Armor Games.
;	https://armorgames.com/play/2675/phage-wars

.MODEL LARGE
.STACK 10024

; Segment for double buffering
DBUFFER	SEGMENT
	SCREEN_BUFFER		DB	320*200 DUP(0)
ENDS

.386
.DATA                    
; ------------------------------------------------------------ ;
; DATA DEFINITION
; ------------------------------------------------------------ ;

; VIRUS DATA ------------------------------------------------- ;
; Floats are the size of a dword (32 bits or 4 bytes)
;	- float PosX
;	- float PosY
;	- byte TargetPhage
;	- byte SourcePhage
; TOTAL: 10 Bytes per virus
VIRUS_QUANTITY		EQU		1000
VIRUS_SIZE		EQU		10


VIRUS_X				EQU		0
VIRUS_Y				EQU		4
VIRUS_PHAGE			EQU		8
VIRUS_SOURCE		EQU		9
VIRUS				DT		VIRUS_QUANTITY DUP ( 0 )
; ------------------------------------------------------------ ;

; PHAGE DATA ------------------------------------------------- ;
;	- word	PosX
;	- word	PosY
;	- byte	Radius
;	- byte	Owner (FF = Neutral, 00 or 01 = Player1, 02 or 03 = Player2)
;	- word	Image
;	- word	Virus Quantity
; TOTAL: 10 bytes per fago
PHAGE_QUANTITY		EQU		10
PHAGE_SIZE			EQU		10
PHAGE_TOTAL_BYTES	EQU		PHAGE_QUANTITY*PHAGE_SIZE

PHAGE_X				EQU		0
PHAGE_Y				EQU		2
PHAGE_RADIUS		EQU		4
PHAGE_PLAYER		EQU		5
PHAGE_IMAGE			EQU		6
PHAGE_NVIRUS		EQU		8
PHAGES				DT		PHAGE_QUANTITY DUP ( 00000000FF0000000000H )
; ------------------------------------------------------------ ;

; Time data
DELTA_TIME			DW		1		; Time delta from frame to frame
PREVIOUS_TIME		DW		0		; Time of the last frame
PREVIOUS_TIME_F		DD		0.0		; Time of the last frame in floating point format
TIME_DIVIDEND		DW		100

; Control variables
VIRUS_VELOCITY		DD		20.0		; Virus velocity, in pixels per second.
GAME_ACTIVE			DB		1			; Game ends when this reaches zero.

MOUSE_PSEUDOVIRUS	DT		01516FFFFFFFFFFFFFFFFH		; Pseudovirus for mouse display.

.CODE
; ------------------------------------------------------------ ;
; CODE START
; ------------------------------------------------------------ ;

; External libraries
INCLUDE random.asm
INCLUDE	/IO/mouse_m.asm
INCLUDE	/IO/console.asm
INCLUDE	/IO/IO.asm
INCLUDE /IO/mouse.asm

INCLUDE vector.asm

INCLUDE /game/phages.asm
INCLUDE /game/Virus.asm
INCLUDE /game/graphics.asm
INCLUDE /game/Juego.asm

; ------------------------------ ;
; Program exit
; ------------------------------ ;
EXIT_GAME PROC NEAR
	
	PUSH	0
	PUSH	0
	CALL	GOTOXY
	ADD		SP, 4	
	
	CALL	HIDE_CURSOR	
	
	CALL	CLEAR_SCREEN
	
    MOV AH, 4CH   		;exit to DOS
	INT 21H
	
EXIT_GAME ENDP
	
; ------------------------------ ;
; Game entry point				 ;
; ------------------------------ ;
MAIN	PROC FAR
	.STARTUP
	
	CALL	SHOW_MENU	
	
MAIN	ENDP

END MAIN
