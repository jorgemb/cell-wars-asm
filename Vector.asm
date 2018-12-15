;###########################################;
; Library for 32-bit floating point 2D 		;
; vector math.								;
;###########################################;

; Creates a zero vector.
; @param [WORD]: Vector address.
ZERO_VECTOR	PROC NEAR
	; Stack init
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	
	; Pushes zero value to stack and copies it to the
	; target vector.
	fldz
	
	MOV		BX, [BP+4]
	fst		DWORD PTR [BX]
	fstp	DWORD PTR [BX+4]
	
	
	POP		BX
	POP		BP
	RET
ZERO_VECTOR ENDP


; Adds two vectors and writes it on the target address.
; @param [WORD]: First vector address
; @param [WORD]: Second vector address
; @param [WORD]: Target vector address
VECTOR_SUM PROC NEAR
	; Stack init
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	SI
	PUSH	DI
	
	MOV		BX, [BP+4]	; First vector
	MOV		SI,	[BP+6]	; Second vector
	MOV		DI, [BP+8]	; Result
	
	; Sums the values
	; .. X
	FLD		DWORD PTR [BX]
	FADD	DWORD PTR [SI]
	FSTP	DWORD PTR [DI]
	
	; .. Y
	FLD		DWORD PTR [BX+4]
	FADD	DWORD PTR [SI+4]
	FSTP	DWORD PTR [DI+4]
	
	POP		DI
	POP		SI
	POP		BX
	POP		BP
	RET
VECTOR_SUM ENDP


; Subtracts the second vector from the first vector. Result
; saved in target address.
; @param [WORD]: Minuend address
; @param [WORD]: Subrahend address
; @param [WORD]: Target vector address
VECTOR_SUBTRACT PROC NEAR
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	SI
	PUSH	DI
	
	MOV		BX, [BP+4]	; Minuend
	MOV		SI,	[BP+6]	; Subtrahend
	MOV		DI, [BP+8]	; Difference
	
	; .. X
	FLD		DWORD PTR [BX]
	FSUB	DWORD PTR [SI]
	FSTP	DWORD PTR [DI]
	
	; .. Y
	FLD		DWORD PTR [BX+4]
	FSUB	DWORD PTR [SI+4]
	FSTP	DWORD PTR [DI+4]
	
	POP		DI
	POP		SI
	POP		BX
	POP		BP
	RET
VECTOR_SUBTRACT ENDP

; Returns the magnitude of the provided vector.
; @param[WORD]: Vector address
; ret [ST(0)]: Magnitude returned in stack.
VECTOR_MAGNITUDE	PROC NEAR
	; Stack init
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	
	; Moves vector to registry
	MOV		BX, [BP+4]
	
	; Squares the components
	FLD		DWORD PTR [BX]		; x
	FMUL	DWORD PTR [BX]		; x*x
	
	FLD		DWORD PTR [BX+4]	; y
	FMUL	DWORD PTR [BX+4]	; y*y
	
	FADD						; x*x + y*y
	FSQRT						; sqrt( x*x + y*y )
	
	POP		BX
	POP		BP
	RET
VECTOR_MAGNITUDE ENDP

; Calculates the scalar multiplication of a vector.
; @param [WORD]: Vector address
; @param [WORD]: Scalar address (in floating point)
; @param [WORD]: Target vector address
VECTOR_SCALAR PROC NEAR
	; Stack init
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	
	; Moves scalar to the stack
	MOV		BX, [BP+6]		; Scalar
	FLD		DWORD PTR [BX]
	
	;.. ST(1) = X, ST(0) = Y
	MOV		BX, [BP+4]		; Source vector
	FLD		DWORD PTR [BX]
	FLD		DWORD PTR [BX+4]
	
	MOV		BX, [BP+8]		; Target vector
	FMUL	ST, ST(2)
	FSTP	DWORD PTR [BX+4]			; Y component

	FMUL
	FSTP	DWORD PTR [BX]			; X component
	
	POP		BX
	POP		BP
	RET
VECTOR_SCALAR ENDP

; Normalizes the given vector.
; @param[WORD]: Vector address
; @param[WORD]: Target vector address
VECTOR_NORMALIZE PROC NEAR
	; Stack init
	PUSH	BP
	MOV		BP, SP
	PUSH	AX
	PUSH	BX
	PUSH	DI
	
	; Saves vector addresses
	MOV		BX, [BP+4]	; Source
	MOV		DI, [BP+6]	; Target
	
	; Vector magnitude
	PUSH	BX
	CALL	VECTOR_MAGNITUDE
	ADD		SP, 2
	
	; .. checks that the magnitude is not zero
	FTST
	FSTSW	AX
	SAHF
	JNE		VECTOR_NORMALIZE_CONTINUE
	
	; Copies values to target (as it cannot be normalized)
	FLD		DWORD PTR [BX]
	FSTP	DWORD PTR [DI]
	FLD		DWORD PTR [BX+4]
	FSTP	DWORD PTR [DI+4]
	JMP		VECTOR_NORMALIZE_END
	
	VECTOR_NORMALIZE_CONTINUE:
	; Divides each component by the magnitude
	; ..X
	FLD		DWORD PTR [BX]
	FDIV	ST, ST(1)		; x / |vector|
	FSTP	DWORD PTR [DI]
	
	; ..Y
	FLD		DWORD PTR [BX+4]
	FXCH					; Eliminates value from the stack
	FDIVP	ST(1), ST		; y / |vector|
	FSTP	DWORD PTR [DI+4]
	
	VECTOR_NORMALIZE_END:
	
	POP		DI
	POP 	BX
	POP		AX
	POP		BP
	RET
VECTOR_NORMALIZE ENDP

; Calculates the dot product of two vectors
; @param [WORD]: First vector address
; @param [WORD]: Second vector address
; @return [ST]: Target vector
VECTOR_DOT PROC NEAR
	; Stack init
	PUSH	BP
	MOV		BP, SP
	PUSH	BX
	PUSH	SI
	
	MOV		BX, [BP+4]	; First vector
	MOV		SI, [BP+6]	; Second vector
	
	; Calculates product of each component
	FLD		DWORD PTR [BX]
	FLD		DWORD PTR [SI]
	FMUL					; V1x*V2x
	
	FLD		DWORD PTR [BX+4]
	FLD		DWORD PTR [SI+4]
	FMUL					; V1y*V2y
	
	FADD					; V1y*V2y + V1x*V2x
	
	POP		SI
	POP		BX
	POP		BP
	RET
VECTOR_DOT ENDP
