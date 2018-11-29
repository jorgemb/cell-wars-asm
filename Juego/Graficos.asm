;###########################################;
;Universidad del Valle de Guatemala			;
;Organización de Computadoras y Assembler	;
;											;
; Este lugar maneja los graficos del		;
; juego.									;
;											;
;Eddy Omar Castro Jáuregui - 11032			;
;Jorge Luis Martínez Bonilla - 11237		;
;###########################################;

.DATA

; DATOS PARA LAS IMAGENES (de fagos)-------------------------- ;
; La estructura para las imagenes es de la siguiente manera
;	- byte	Ancho	(en pixeles)
;	- byte	Alto	(en pixeles)
; TOTAL: 2 bytes por imagen

IMAGEN_ANCHO		EQU		0
IMAGEN_ALTO			EQU		1

; ------------------------------------------------------------ ;
FAGO_1			DB	51
				DB	50
				DB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0
				DB	0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0
				DB	0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,,0,0,0,0,0,0
				DB	0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0
				DB	0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
				DB	0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
				DB	0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
				DB	0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
				DB	0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
				DB	0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
				DB	0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
				DB	0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
				DB	0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
				DB	0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
				DB	0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
				DB	0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
				DB	0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
				DB	0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
				DB	0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
				DB	0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0
				DB	0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0
				DB	0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0
				DB	0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0


FAGO_2			DB	33
				DB	31
				DB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0
				DB	0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
				DB	0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
				DB	0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
				DB	0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
				DB	0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
				DB	0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
				DB	0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0
				DB	0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0
				DB	0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0
				DB	0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0
				DB	0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0
				DB	0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0
				DB	0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
				DB	0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
				DB	0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
				DB	0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
				DB	0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0
				DB	0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				
FAGO_3			DB	19
				DB	18
				DB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0
				DB	0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
				DB	0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
				DB	0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0
				DB	0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
				DB	0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
				DB	0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
				DB	0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
				DB	0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
				DB	0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
				DB	0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0
				DB	0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
				DB	0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0
				DB	0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0
				DB	0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0
				DB	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				
COLORES			DB	29H
				DB	2AH	
				DB	2FH
				DB	2DH

BASE			DB	0,	0,	0,	0
				DB  0,	0,	0,	0
				DB  0,	0,  0,	0
				DB  0,	0,	0,	0
				DB  0,	0,	0,	0
				DB  0,	0,	0,	0
				DB  0,	0,	0,	0				

				
CERO			DB	1,	1,	1,	1
				DB  1,	0,	0,	1
				DB  1,	0,  0,	1
				DB  1,	0,	0,	1
				DB  1,	0,	0,	1
				DB  1,	0,	0,	1
				DB  1,	1,	1,	1				
				
UNO				DB	0,	0,	1,	0
				DB  0,	1,	1,	0
				DB  0,	0,  1,	0
				DB  0,	0,	1,	0
				DB  0,	0,	1,	0
				DB  0,	0,	1,	0
				DB  0,	1,	1,	1

				
DOS				DB	1,	1,	1,	1
				DB  0,	0,	0,	1
				DB  0,	0,  0,	1
				DB  1,	1,	1,	1
				DB  1,	0,	0,	0
				DB  1,	0,	0,	0
				DB  1,	1,	1,	1

				
TRES			DB	1,	1,	1,	1
				DB  0,	0,	0,	1
				DB  0,	0,  0,	1
				DB  0,	1,	1,	1
				DB  0,	0,	0,	1
				DB  0,	0,	0,	1
				DB  1,	1,	1,	1


CUATRO			DB	1,	0,	0,	1
				DB  1,	0,	0,	1
				DB  1,	0,  0,	1
				DB  1,	1,	1,	1
				DB  0,	0,	0,	1
				DB  0,	0,	0,	1
				DB  0,	0,	0,	1

				
CINCO			DB	1,	1,	1,	1
				DB  1,	0,	0,	0
				DB  1,	0,  0,	0
				DB  1,	1,	1,	1
				DB  0,	0,	0,	1
				DB  0,	0,	0,	1
				DB  1,	1,	1,	1
				
				
SEIS			DB	1,	1,	1,	1
				DB  1,	0,	0,	0
				DB  1,	0,  0,	0
				DB  1,	1,	1,	1
				DB  1,	0,	0,	1
				DB  1,	0,	0,	1
				DB  1,	1,	1,	1


SIETE			DB	1,	1,	1,	0
				DB  0,	0,	1,	0
				DB  0,	0,  1,	0
				DB  0,	1,	1,	1
				DB  0,	0,	1,	0
				DB  0,	0,	1,	0
				DB  0,	0,	1,	0

				
OCHO			DB	1,	1,	1,	1
				DB  1,	0,	0,	1
				DB  1,	0,  0,	1
				DB  1,	1,	1,	1
				DB  1,	0,	0,	1
				DB  1,	0,	0,	1
				DB  1,	1,	1,	1


NUEVE			DB	1,	1,	1,	1
				DB  1,	0,	0,	1
				DB  1,	0,  0,	1
				DB  1,	1,	1,	1
				DB  0,	0,	0,	1
				DB  0,	0,	0,	1
				DB  1,	1,	1,	1	
				
NUMEROS			DW	CERO, UNO, DOS, TRES, CUATRO, CINCO, SEIS, SIETE, OCHO, NUEVE
				
.CODE
			
;---------------------------------------------;
; Procedimiento para establecer modo grafico
;---------------------------------------------;
CAMBIAR_MODO_GRAFICO PROC NEAR
	
	; Cambiar a modo grafico
	MOV AX, 0A000H
    MOV ES, AX
    MOV AX, 0013H
    INT 10H
	
	; Cambiar color al fondo [FALTA ESTABLECER EL DEFINITIVO]
	MOV DI, 0
	MOV AL, 0
    MOV CX, 64000
	
	REP STOSB
	
	RET
	
CAMBIAR_MODO_GRAFICO ENDP


;---------------------------------------------;
; Procedimiento para establecer modo grafico
;---------------------------------------------;
CAMBIAR_MODO_GRAFICO_NO_PINTAR PROC NEAR
	
	; Cambiar a modo grafico
	MOV AX, 0A000H
    MOV ES, AX
    MOV AX, 0013H
    INT 10H
	
	RET
	
CAMBIAR_MODO_GRAFICO_NO_PINTAR ENDP

; --------------------------------------------- ;
; Limpia el buffer del tamaño dado con el color
; asignado. El segmento extra se queda asignado
; con la dirección del buffer.
; --------------------------------------------- ;
LIMPIAR_BUFFER MACRO DIR_BUFFER, TAMANO, COLOR
	; Establece el valor del segmento extra
	;MOV		BX, ES
	MOV		AX, DIR_BUFFER
	MOV		ES, AX
	
	; Copia el valor la cantidad de veces dada
	CLD
	MOV		AL, COLOR
	MOV		CX, TAMANO
	MOV		DI, 0
	REP 	STOSB
	
	; Reestablece el segmento extra
	; MOV		ES, BX
ENDM

; ------------------------------------------------- ;
; Copia los elementos de un buffer a otro del 
; mismo tamaño.
; ------------------------------------------------- ;
BLIT_BUFFER MACRO SEG_BUFFER_SRC, SEG_BUFFER_DEST, TAMANO
	; Establece y guarda los segmentos de datos
	MOV		BX, DS
	PUSH	BX
	MOV		BX, ES
	PUSH	BX
	MOV		AX, SEG_BUFFER_SRC
	MOV		DS, AX
	
	MOV		AX, SEG_BUFFER_DEST
	MOV		ES, AX
	
	; Copia los datos
	MOV		SI, 0
	MOV		DI, 0
	MOV		CX, TAMANO
	REP		MOVSB
	
	; Reestablece los segmentos de datos
	POP		AX
	MOV		ES, AX
	POP		AX
	MOV		DS, AX
ENDM

;-----------------------------------------------------------------;
; Macro que permite realizar la impresion de imagenes en pantalla
;-----------------------------------------------------------------;
DIBUJAR_VIRUS MACRO POS_X, POS_Y, ATRIB
	MOV		DX,	320		; Ancho de pantalla
	MOV		AX, POS_Y	; Posicion Y
	MUL		DX
	ADD		AX, POS_X	; AX = (POS_Y*320)+POS_X
	MOV		DI, AX
	
	MOV		AL, ATRIB	; Byte de atributo
	STOSB

ENDM


;-------------------------------------------------------------------------;
; Procedimiento que permite realizar la impresion de imagenes en pantalla
; @param [WORD]: Dirección de la imagen
; @param [WORD]: Posición en X
; @param [WORD]: Posición en y
; @param [WORD]: Dato de jugador
;-------------------------------------------------------------------------;
DIBUJAR_FAGO PROC NEAR
    
	.DATA	
	CANTIDAD_FILAS	DB	0D
	CONTADOR		DB	0D
	POSICIONY		DW	0D
	POSICIONX		DW	0D
	POSICIONX_ORIG	DW	0D
	VERIFICADOR		DW	0D
	COLOR			DW	0D
	
	.CODE
	
	; Preparar la pila
	PUSH 	BP
	MOV		BP, SP
	PUSHA
	; Cargar datos de la imagen
	MOV	BX, [BP+4]
	MOV	VERIFICADOR, BX
	ADD	VERIFICADOR, 2
	MOV	DL, IMAGEN_ALTO[BX]
	MOV	CANTIDAD_FILAS, DL
	; Calcula la posicion en la que debe dibujar
	PUSH	WORD PTR [BP+4]
	MOV		DX, WORD PTR [BP+8]
	PUSH	DX
	MOV		DX, WORD PTR [BP+6]
	PUSH	DX		
	CALL	AJUSTE_POSICION
	ADD		SP, 6
	; Preparar ciclo
	MOV CX, 0
	MOV CL, IMAGEN_ANCHO[BX]
	; Determinar el color a usar
	MOVZX	AX, [BP+10]
	PUSH	AX
	CALL	DETERMINAR_COLOR
	ADD		SP, 2
	; Impresion de cada una de las filas
	DIBUJAR_FAGO_IMPRIME:
		PUSH	BX
		MOV		BX, VERIFICADOR
		CMP		BYTE PTR [BX], 0
		JE		TRANSPARENTE
		MOV		DX,	320					; Ancho de pantalla
		MOV		AX, POSICIONY			; Posicion Y
		MUL		DX
		ADD		AX, POSICIONX			; AX = (POS_Y*320)+POS_X
		MOV		DI, AX
		MOV		AL, BYTE PTR COLOR		; Byte de atributo		
		STOSB
		TRANSPARENTE:
		INC		VERIFICADOR		
		INC		POSICIONX
		POP		BX
	LOOP DIBUJAR_FAGO_IMPRIME
	; Inicializar una nueva fila
	INC	POSICIONY
	MOV DX, POSICIONX_ORIG
	MOV	POSICIONX, DX
	MOV CL, IMAGEN_ANCHO[BX]
	DEC CANTIDAD_FILAS
	JNZ DIBUJAR_FAGO_IMPRIME               
	DIBUJAR_FAGO_FIN:
	; Regresar la pila
	POPA
	POP	BP
	RET
	
DIBUJAR_FAGO ENDP

;------------------------------------------------------------;
; Procedimiento para colocar al FAGO en la posicion correcta
; @param [WORD]: Posicion x
; @param [WORD]: Posicion y
; @param [WORD]: Direccion de la imagen
;------------------------------------------------------------;
AJUSTE_POSICION PROC	NEAR

	; Preparar la pila
	PUSH 	BP
	MOV		BP, SP
	PUSHA	
	
	MOV		DX, 0
	
	; Posicion en x
	MOV		AX, WORD PTR [BP+4]
	MOV		BX, WORD PTR [BP+8]
	MOV		DL, IMAGEN_ANCHO[BX]
	SHR		DX, 1
	SUB		AX, DX
	MOV		POSICIONX, AX
	MOV		POSICIONX_ORIG, AX

	; Posicion en y 
	MOV		AX, WORD PTR [BP+6]
	MOV		BX, WORD PTR [BP+8]
	MOV		DL, IMAGEN_ALTO[BX]	
	SHR		DX, 1
	SUB		AX, DX
	MOV		POSICIONY, AX

	; Regresar la pila
	POPA
	POP	BP
	RET

AJUSTE_POSICION ENDP


;-------------------------------------------------------------------------;
; Procedimiento que permite realizar la impresion de la cantidad de virus
; @param [WORD]: Cantidad de virus
; @param [WORD]: Posición en X
; @param [WORD]: Posición en y
;-------------------------------------------------------------------------;
IMPRIMIR_CANTIDAD_VIRUS PROC NEAR

	.DATA

	UNIDADES	DB	0D
	DECENAS		DB	0D
	
	.CODE
	; Preparar la pila
	PUSH 	BP
	MOV		BP, SP
	PUSHA

	MOV		DL, 10
	MOV		AX, WORD PTR [BP+4]
	DIV		DL
	MOV		UNIDADES, AH
	MOV		DECENAS, AL
	
	PUSH	WORD PTR [BP+8]
	PUSH	WORD PTR [BP+6]
	MOVZX	DX, DECENAS
	PUSH	DX
	CALL	IMPRIMIR_DECENAS
	ADD		SP, 6
	
	PUSH	WORD PTR [BP+8]
	PUSH	WORD PTR [BP+6]
	MOVZX	DX, UNIDADES
	PUSH	DX
	CALL	IMPRIMIR_UNIDADES
	ADD		SP, 6
	
	; Regresar la pila
	POPA
	POP	BP
	RET

IMPRIMIR_CANTIDAD_VIRUS ENDP

;-------------------------------------------------------------------------;
; Procedimiento que permite realizar la impresion de la cantidad de virus
; @param [WORD]: Numero
; @param [WORD]: Posición en X
; @param [WORD]: Posición en y
;-------------------------------------------------------------------------;
IMPRIMIR_DECENAS PROC NEAR
	; Preparar la pila
	PUSH 	BP
	MOV		BP, SP
	PUSHA
	
	MOV		BX, OFFSET NUMEROS
	MOV		CX, [BP+4]
	SHL		CX, 1
	ADD		BX, CX
	
	MOV		DX, [BP+6]
	SUB		DX, 4D
	
	MOV		AX, [BP+8]
	SUB		AX, 4D
	
	PUSH	AX
	PUSH	DX
	PUSH	WORD PTR [BX]
	CALL DIBUJAR_NUMERO
	ADD	SP, 6
	
	; Regresar la pila
	POPA
	POP	BP
	RET
IMPRIMIR_DECENAS ENDP	

;-------------------------------------------------------------------------;
; Procedimiento que permite realizar la impresion de la cantidad de virus
; @param [WORD]: Numero
; @param [WORD]: Posición en X
; @param [WORD]: Posición en y
;-------------------------------------------------------------------------;
IMPRIMIR_UNIDADES PROC NEAR
	; Preparar la pila
	PUSH 	BP
	MOV		BP, SP
	PUSHA

	MOV		BX, OFFSET NUMEROS
	MOV		CX, [BP+4]
	SHL		CX, 1
	ADD		BX, CX
	
	MOV		DX, [BP+6]
	ADD		DX, 1D
	
	MOV		AX, [BP+8]
	SUB		AX, 4D
	
	PUSH	AX
	PUSH	DX
	PUSH	WORD PTR [BX]
	CALL DIBUJAR_NUMERO
	ADD	SP, 6	
	
	; Regresar la pila
	POPA
	POP	BP
	RET
IMPRIMIR_UNIDADES ENDP

;-----------------------------------------------------------------;
; Procedimiento que permite realizar la impresion de la cantidad de virus
; @param [WORD]: OFFSET de numero
; @param [WORD]: Posición en X
; @param [WORD]: Posición en y
;-----------------------------------------------------------------;
DIBUJAR_NUMERO	PROC NEAR

	.DATA
	
	CORDX	DW 0
	CORDY	DW 0
	VAL		DW 0
		
	.CODE
	PUSH 	BP
	MOV		BP, SP
	PUSHA
	
	; Preparar ciclo
	MOV	AX, [BP+6]
	MOV CORDX, AX
	MOV	AX, [BP+8]
	MOV	CORDY, AX
	MOV AX, [BP+4]
	MOV	VAL, AX
	MOV CX, 0
	MOV CL, 4
	MOV	BX, 7
	; Impresion de cada una de las filas
	NUMERO_IMPRIME:
		PUSH	BX
		MOV		BX, VAL
		CMP		BYTE PTR [BX], 0
		JE		NO_IMPRIMIR
		MOV		DX,	320					; Ancho de pantalla
		MOV		AX, CORDY				; Posicion Y
		MUL		DX
		ADD		AX, CORDX				; AX = (POS_Y*320)+POS_X
		MOV		DI, AX
		MOV		AL, 23H					; Byte de atributo		
		STOSB
		NO_IMPRIMIR:
		INC		VAL		
		INC		CORDX
		POP		BX
	LOOP NUMERO_IMPRIME
	; Inicializar una nueva fila
	INC	CORDY
	MOV	AX, [BP+6]
	MOV CORDX, AX
	;SUB	CORDX, 4
	MOV CL, 4
	DEC BX
	JNZ NUMERO_IMPRIME               

	; Regresar la pila
	POPA
	POP	BP
	RET
DIBUJAR_NUMERO ENDP


;---------------------------------------------------;
; Procedimiento para detemrinar el color a pintar
; @param [WORD]: Numero de jugador (selec/no selec)
;---------------------------------------------------;
DETERMINAR_COLOR PROC	NEAR

	; Preparar la pila
	PUSH 	BP
	MOV		BP, SP
	PUSHA
	
	CMP	BYTE PTR [BP+4], 0FFH
	JE	NEUTRO
	MOV	BX, OFFSET COLORES
	ADD	BX, [BP+4]
	MOV	DX, [BX]
	MOV	COLOR, DX
	JMP	DETERMINADO
	
	NEUTRO:
	MOV	COLOR, 1
	
	DETERMINADO:
	
	; Regresar la pila
	POPA
	POP	BP
	RET
	
DETERMINAR_COLOR ENDP

;---------------------------------------------;
; Procedimiento para establecer modo texto
;---------------------------------------------;
CAMBIAR_MODO_TEXTO PROC NEAR
	
	MOV AL,03H
	MOV AH,00H
	INT 10H
	
	RET

CAMBIAR_MODO_TEXTO ENDP

