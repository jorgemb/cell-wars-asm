;###########################################;
; Graphics management library, and assets.	;
;###########################################;

.DATA

; DATA FOR PHAGE IMAGE
; Structure is this way:
;	- byte	Width (in pixels)
;	- byte 	Height (in pixels)
; TOTAL: 2 bytes per image header

IMAGE_WIDTH		EQU		0
IMAGE_HEIGHT	EQU		1

; ------------------------------------------------------------ ;
PHAGE_1			DB	51
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


PHAGE_2			DB	33
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
				
PHAGE_3			DB	19
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
				
COLORS			DB	29H
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

				
ZERO			DB	1,	1,	1,	1
				DB  1,	0,	0,	1
				DB  1,	0,  0,	1
				DB  1,	0,	0,	1
				DB  1,	0,	0,	1
				DB  1,	0,	0,	1
				DB  1,	1,	1,	1				
				
ONE				DB	0,	0,	1,	0
				DB  0,	1,	1,	0
				DB  0,	0,  1,	0
				DB  0,	0,	1,	0
				DB  0,	0,	1,	0
				DB  0,	0,	1,	0
				DB  0,	1,	1,	1

				
TWO				DB	1,	1,	1,	1
				DB  0,	0,	0,	1
				DB  0,	0,  0,	1
				DB  1,	1,	1,	1
				DB  1,	0,	0,	0
				DB  1,	0,	0,	0
				DB  1,	1,	1,	1

				
THREE			DB	1,	1,	1,	1
				DB  0,	0,	0,	1
				DB  0,	0,  0,	1
				DB  0,	1,	1,	1
				DB  0,	0,	0,	1
				DB  0,	0,	0,	1
				DB  1,	1,	1,	1


FOUR			DB	1,	0,	0,	1
				DB  1,	0,	0,	1
				DB  1,	0,  0,	1
				DB  1,	1,	1,	1
				DB  0,	0,	0,	1
				DB  0,	0,	0,	1
				DB  0,	0,	0,	1

				
FIVE			DB	1,	1,	1,	1
				DB  1,	0,	0,	0
				DB  1,	0,  0,	0
				DB  1,	1,	1,	1
				DB  0,	0,	0,	1
				DB  0,	0,	0,	1
				DB  1,	1,	1,	1
				
				
SIX			DB	1,	1,	1,	1
				DB  1,	0,	0,	0
				DB  1,	0,  0,	0
				DB  1,	1,	1,	1
				DB  1,	0,	0,	1
				DB  1,	0,	0,	1
				DB  1,	1,	1,	1


SEVEN			DB	1,	1,	1,	0
				DB  0,	0,	1,	0
				DB  0,	0,  1,	0
				DB  0,	1,	1,	1
				DB  0,	0,	1,	0
				DB  0,	0,	1,	0
				DB  0,	0,	1,	0

				
EIGHT			DB	1,	1,	1,	1
				DB  1,	0,	0,	1
				DB  1,	0,  0,	1
				DB  1,	1,	1,	1
				DB  1,	0,	0,	1
				DB  1,	0,	0,	1
				DB  1,	1,	1,	1


NINE			DB	1,	1,	1,	1
				DB  1,	0,	0,	1
				DB  1,	0,  0,	1
				DB  1,	1,	1,	1
				DB  0,	0,	0,	1
				DB  0,	0,	0,	1
				DB  1,	1,	1,	1	
				
NUMBERS			DW	ZERO, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE
				
.CODE
			
; Change to graphic mode.
CHANGE_GRAPHIC_MODE PROC NEAR
	
	; Change to graphic mode interrupt
	MOV AX, 0A000H
    MOV ES, AX
    MOV AX, 0013H
    INT 10H
	
	; Set background color
	MOV DI, 0
	MOV AL, 0
    MOV CX, 64000
	
	REP STOSB
	
	RET
	
CHANGE_GRAPHIC_MODE ENDP



; Change to graphic mode without background
CHANGE_GRAPHIC_MODE_NO_BACK PROC NEAR
	
	; Change to graphic mode interrupt
	MOV AX, 0A000H
    MOV ES, AX
    MOV AX, 0013H
    INT 10H
	
	RET
	
CHANGE_GRAPHIC_MODE_NO_BACK ENDP

; Cleans the buffer with the given color.
; Extra segment is assigned with the buffer address.
CLEAN_BUFFER MACRO BUFFER_ADDRESS, SIZE, COLOR
	; Extra segment value
	;MOV		BX, ES
	MOV		AX, BUFFER_ADDRESS
	MOV		ES, AX
	
	; Copies the value along the buffer
	CLD
	MOV		AL, COLOR
	MOV		CX, SIZE
	MOV		DI, 0
	REP 	STOSB
	
	; Extra segment restore
	; MOV		ES, BX
ENDM

; Copies (blits) the buffer to another of the same size
BLIT_BUFFER MACRO SEG_BUFFER_SRC, SEG_BUFFER_DEST, SIZE
	; Saves data segments
	MOV		BX, DS
	PUSH	BX
	MOV		BX, ES
	PUSH	BX
	MOV		AX, SEG_BUFFER_SRC
	MOV		DS, AX
	
	MOV		AX, SEG_BUFFER_DEST
	MOV		ES, AX
	
	; Copies data
	MOV		SI, 0
	MOV		DI, 0
	MOV		CX, SIZE
	REP		MOVSB
	
	; Restores data segments
	POP		AX
	MOV		ES, AX
	POP		AX
	MOV		DS, AX
ENDM

; Macro for printing points on screen
DRAW_POINT MACRO POS_X, POS_Y, ATRIB
	MOV		DX,	320		; Screen width
	MOV		AX, POS_Y	; Y position
	MUL		DX
	ADD		AX, POS_X	; AX = (POS_Y*320)+POS_X
	MOV		DI, AX
	
	MOV		AL, ATRIB	; Attibute byte
	STOSB

ENDM

; Procedure for printing images on screen 
; @param [WORD]: Image address 
; @param [WORD]: X position
; @param [WORD]: Y position
; @param [WORD]: Player data
DRAW_IMAGE PROC NEAR
    
	.DATA	
	ROW_AMOUNT	DB	0D
	COUNTER		DB	0D
	YPOSITION		DW	0D
	XPOSITION		DW	0D
	XPOSITION_ORIG	DW	0D
	VERIFIER		DW	0D
	COLOR			DW	0D
	
	.CODE
	
	; Prepare the stack
	PUSH 	BP
	MOV		BP, SP
	PUSHA

	; Loads image data
	MOV	BX, [BP+4]
	MOV	VERIFIER, BX
	ADD	VERIFIER, 2
	MOV	DL, IMAGE_HEIGHT[BX]
	MOV	ROW_AMOUNT, DL

	; Calculates the position where drawing starts
	PUSH	WORD PTR [BP+4]
	MOV		DX, WORD PTR [BP+8]
	PUSH	DX
	MOV		DX, WORD PTR [BP+6]
	PUSH	DX		
	CALL	POSITION_ADJUST
	ADD		SP, 6

	; Cycle prepare
	MOV CX, 0
	MOV CL, IMAGE_WIDTH[BX]

	; Determine color
	MOVZX	AX, [BP+10]
	PUSH	AX
	CALL	RETRIEVE_COLOR
	ADD		SP, 2

	; Prints each row
	DRAW_IMAGE_PRINT:
		PUSH	BX
		MOV		BX, VERIFIER
		CMP		BYTE PTR [BX], 0
		JE		TRANSPARENT
		MOV		DX,	320					; Screen width
		MOV		AX, YPOSITION			; Y position
		MUL		DX
		ADD		AX, XPOSITION			; AX = (POS_Y*320)+POS_X
		MOV		DI, AX
		MOV		AL, BYTE PTR COLOR		; Attribute byte
		STOSB
		TRANSPARENT:
		INC		VERIFIER		
		INC		XPOSITION
		POP		BX
	LOOP DRAW_IMAGE_PRINT

	; Initialize new row
	INC	YPOSITION
	MOV DX, XPOSITION_ORIG
	MOV	XPOSITION, DX
	MOV CL, IMAGE_WIDTH[BX]
	DEC ROW_AMOUNT
	JNZ DRAW_IMAGE_PRINT               
	DRAW_IMAGE_END:

	; Restore stack
	POPA
	POP	BP
	RET
	
DRAW_IMAGE ENDP

; Adjusts an image position
; @param [WORD]: X position
; @param [WORD]: Y position
; @param [WORD]: Image address
;------------------------------------------------------------;
POSITION_ADJUST PROC	NEAR
	; Prepare the stack
	PUSH 	BP
	MOV		BP, SP
	PUSHA	
	
	MOV		DX, 0
	
	; X position
	MOV		AX, WORD PTR [BP+4]
	MOV		BX, WORD PTR [BP+8]
	MOV		DL, IMAGE_WIDTH[BX]
	SHR		DX, 1
	SUB		AX, DX
	MOV		XPOSITION, AX
	MOV		XPOSITION_ORIG, AX

	; Y position
	MOV		AX, WORD PTR [BP+6]
	MOV		BX, WORD PTR [BP+8]
	MOV		DL, IMAGE_HEIGHT[BX]	
	SHR		DX, 1
	SUB		AX, DX
	MOV		YPOSITION, AX

	; Restore stack
	POPA
	POP	BP
	RET

POSITION_ADJUST ENDP


; Prints the amount of viruses over each phage
; @param [WORD]: Virus quantity
; @param [WORD]: X position
; @param [WORD]: Y position
PRINT_VIRUS_QUANTITY PROC NEAR

	.DATA

	UNITS	DB	0D
	TENS	DB	0D
	
	.CODE
	; Prepare the stack
	PUSH 	BP
	MOV		BP, SP
	PUSHA

	MOV		DL, 10
	MOV		AX, WORD PTR [BP+4]
	DIV		DL
	MOV		UNITS, AH
	MOV		TENS, AL
	
	PUSH	WORD PTR [BP+8]
	PUSH	WORD PTR [BP+6]
	MOVZX	DX, TENS
	PUSH	DX
	CALL	PRINT_TENS
	ADD		SP, 6
	
	PUSH	WORD PTR [BP+8]
	PUSH	WORD PTR [BP+6]
	MOVZX	DX, UNITS
	PUSH	DX
	CALL	PRINT_UNITS
	ADD		SP, 6
	
	; Restore stack
	POPA
	POP	BP
	RET

PRINT_VIRUS_QUANTITY ENDP

; Helper for number printing. Prints the tens part of the number.
; @param [WORD]: Number
; @param [WORD]: X position
; @param [WORD]: Y position
PRINT_TENS PROC NEAR
	; Prepare the stack
	PUSH 	BP
	MOV		BP, SP
	PUSHA
	
	MOV		BX, OFFSET NUMBERS
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
	CALL DRAW_NUMBER
	ADD	SP, 6
	
	; Restore stack
	POPA
	POP	BP
	RET
PRINT_TENS ENDP	

; Helper for virus quantity printing. Prints the units part of the number.
; @param [WORD]: Number
; @param [WORD]: X position
; @param [WORD]: Y position
;-------------------------------------------------------------------------;
PRINT_UNITS PROC NEAR
	; Prepare the stack
	PUSH 	BP
	MOV		BP, SP
	PUSHA

	MOV		BX, OFFSET NUMBERS
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
	CALL DRAW_NUMBER
	ADD	SP, 6	
	
	; Restore stack
	POPA
	POP	BP
	RET
PRINT_UNITS ENDP

; Draws a number image to the screen.
; @param [WORD]: Number offset
; @param [WORD]: X position
; @param [WORD]: Y position
;-----------------------------------------------------------------;
DRAW_NUMBER	PROC NEAR
	.DATA
	
	XCOORD	DW 0
	YCOORD	DW 0
	VAL		DW 0
		
	.CODE
	PUSH 	BP
	MOV		BP, SP
	PUSHA
	
	; Prepares the cycle
	MOV	AX, [BP+6]
	MOV XCOORD, AX
	MOV	AX, [BP+8]
	MOV	YCOORD, AX
	MOV AX, [BP+4]
	MOV	VAL, AX
	MOV CX, 0
	MOV CL, 4
	MOV	BX, 7

	; Print every row
	DRAW_NUMBER_CYCLE:
		PUSH	BX
		MOV		BX, VAL
		CMP		BYTE PTR [BX], 0
		JE		DRAW_NUMBER_NO_PRINT
		MOV		DX,	320					; Screen width
		MOV		AX, YCOORD				; Y position
		MUL		DX
		ADD		AX, XCOORD				; AX = (POS_Y*320)+POS_X
		MOV		DI, AX
		MOV		AL, 23H					; Attribute byte
		STOSB
		DRAW_NUMBER_NO_PRINT:
		INC		VAL		
		INC		XCOORD
		POP		BX
	LOOP DRAW_NUMBER_CYCLE

	; Initializes a new row
	INC	YCOORD
	MOV	AX, [BP+6]
	MOV XCOORD, AX
	;SUB	XCOORD, 4
	MOV CL, 4
	DEC BX
	JNZ DRAW_NUMBER_CYCLE               

	; Restore stack
	POPA
	POP	BP
	RET
DRAW_NUMBER ENDP


; Determines which color to use based on the player number.
; @param [WORD]: Player number (selec/no selec)
RETRIEVE_COLOR PROC	NEAR

	; Prepare the stack
	PUSH 	BP
	MOV		BP, SP
	PUSHA
	
	CMP	BYTE PTR [BP+4], 0FFH
	JE	RETRIEVE_COLOR_NEUTRAL
	MOV	BX, OFFSET COLORS
	ADD	BX, [BP+4]
	MOV	DX, [BX]
	MOV	COLOR, DX
	JMP	RETRIEVE_COLOR_DETERMINED
	
	RETRIEVE_COLOR_NEUTRAL:
	MOV	COLOR, 1
	
	RETRIEVE_COLOR_DETERMINED:
	
	; Restore stack
	POPA
	POP	BP
	RET
	
RETRIEVE_COLOR ENDP

; Restores graphic mode to text
CHANGE_TEXT_MODE PROC NEAR
	
	MOV AL,03H
	MOV AH,00H
	INT 10H
	
	RET

CHANGE_TEXT_MODE ENDP

