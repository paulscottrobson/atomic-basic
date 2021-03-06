; *****************************************************************************
; *****************************************************************************
;
;		Name:		unary.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Numeric Unary Functions
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;								Page
;
; *****************************************************************************

UnaryPage: 	;; [page]
		jsr 	UnaryFalse 					; set all to zero/int
		lda 	#BasicProgram & $FF
		sta 	esInt0,x
		lda 	#BasicProgram >> 8
		sta 	esInt1,x
		rts

; *****************************************************************************
;
;				Parenthesis (it's unary ... think about it)
;
; *****************************************************************************

UnaryParenthesis: 	;; [(]
		jsr 	EvaluateTOS					; evaluate expression
		jsr 	CheckRightParen				; check for )
		rts

; *****************************************************************************
;
;								True and False
;
; *****************************************************************************

UnaryTrue: 		;; [True]
		jsr 	Int32True
		rts
UnaryFalse:		;; [False]
		jsr 	Int32False
		rts

; *****************************************************************************
;
;							     Absolute value
;
; *****************************************************************************

UnaryAbs:		;; [abs]
		jsr 	EvaluateTerm				; work out value required and dispatch
		jsr		Int32Absolute
		makeinteger
		rts

; *****************************************************************************
;
;							Call 6502 Machine Code
;
; *****************************************************************************

UnarySys:		;; [sys]
		jsr 	EvaluateTerm				; address to call
		lda 	esInt0,x 					; copy call address
		sta 	temp0
		lda 	esInt1,x
		sta 	temp0+1
		pshx
		pshy
		lda 	aVariable 				 	; load AXY
		ldx 	xVariable
		ldy 	yVariable
		jsr 	_USCall						; call code
		sta 	aVariable 				 	; save AXY
		stx 	xVariable
		sty 	yVariable
		puly
		pulx
		lda 	aVariable 				 	; load A to return
		jmp 	Int32Set8Bit
		
_USCall:jmp 	(temp0)

; *****************************************************************************
;
;							     Numeric Sign
;
; *****************************************************************************

UnarySgn1:		;; [sgn]
		jsr 	EvaluateTerm				; work out value required and dispatch
		jsr 	Int32Sign
		makeinteger
		rts

; *****************************************************************************
;
;						Arithmetic not (1's complement)
;
; *****************************************************************************

UnaryNot:		;; [~]
		jsr 	EvaluateTerm				; work out value required and dispatch
		jsr 	Int32Not
		makeinteger
		rts


; *****************************************************************************
;
;								Minimum and Maximum
;
; *****************************************************************************

UnaryMin:		;; [min]	
		sec 								; min indicated with CS
		bcs 	UnaryMax+1
UnaryMax:		;; [max]					
		clc 								; max is CC.
		php 								; save what we're doing.
		jsr 	CheckLeftParen 				; check for (, required here
		jsr 	EvaluateTOSDeRef			; evaluate expression
		inx
		jsr 	CheckComma
		jsr 	EvaluateTOSDeRef
		jsr 	DerefBoth 					; dereference them.
		dex
		jsr 	CheckRightParen
		;
		jsr 	Int32Less 					; is p1 < p2, CS if true.
		lda 	#0 							; put into A, now 1 if <, 0 if > 		
		adc 	#0
		plp 
		adc 	#0 							; toggle bit 0 for Min.
		lsr 	a 							; put into carry
		bcc 	_UMinMaxExit 				; if clear just exit.
		;
		jsr 	SwapTopStack 				; swap two values over.
_UMinMaxExit:
		makeinteger
		rts

UTypeError:
		report 	TypeMismatch

; *****************************************************************************
;
;						Convert reference to value (@)
;
; *****************************************************************************

UnaryRefToValue: 	;; [@]
		lda 	#15
		jsr 	EvaluateLevelAX 			; get a term.
		lda 	esType,x
		bpl 	UTypeError 					; not a reference
		and 	#$7F 						; clear reference bit.
		sta 	esType,x 					; overwrite type
		makeinteger
		rts

; *****************************************************************************
;
;								hex Marker &
;
; *****************************************************************************

UnaryHexMarker: 	;; [&]
		jmp 	EvaluateTerm
		
; *****************************************************************************
;
;								Unary Random
;
; *****************************************************************************

UnaryRandom: 	;; [random]
		jsr 	Int32Random 				; random #
		makeinteger
		rts

; *****************************************************************************
;
;								Unary Length
;
; *****************************************************************************

UnaryLen: 	;; [len]
		jsr 	EvaluateTerm				; work out value required and dispatch
		lda 	esInt0,x 					; copy addr to temp0
		sta 	temp0
		lda 	esInt1,x
		sta 	temp0+1
		jsr 	UnaryFalse 					; sets return to int zero.
		pshy
		ldy 	#0
_ULCheck:
		lda 	(temp0),y
		beq 	_ULFound
		iny
		bne 	_ULCheck
_ULFound:		
		sty 	esInt0,x 					; update result
		puly
		rts
		rts

; *****************************************************************************
;
;								Unary Chr
;
; *****************************************************************************

UnaryChr: 	;; [chr]
		jsr 	EvaluateTerm				; work out value required and dereference
		lda 	esInt0,x 					; get char code
		sta 	ChrBuffer 					; put into buffer.
		lda 	#0
		sta 	ChrBuffer+1 				; make ASCIIZ
		;
		lda 	#ChrBuffer & $FF 			; set address
		sta 	esInt0,x
		lda 	#ChrBuffer >> 8
		sta 	esInt1,x
		inc 	esType,x 					; makes it a string
		rts

