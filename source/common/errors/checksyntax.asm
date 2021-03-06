; *****************************************************************************
; *****************************************************************************
;
;		Name:		checksyntax.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Check for various syntactic elements
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;									Check ,
; *****************************************************************************

CheckComma:	
		pha
		lda 	#KWD_COMMA
		jmp 	CheckSyntax

; *****************************************************************************
;									Check (
; *****************************************************************************

CheckLeftParen:	
		pha
		lda 	#KWD_LPAREN
		jmp 	CheckSyntax

; *****************************************************************************
;									Check =
; *****************************************************************************

CheckEquals:	
		pha
		lda 	#KWD_EQUAL
		jmp 	CheckSyntax

; *****************************************************************************
;									Check TO
; *****************************************************************************

CheckTO:	
		pha
		lda 	#KWD_TO
		jmp 	CheckSyntax
		
; *****************************************************************************
;									Check )
; *****************************************************************************

CheckRightParen:	
		pha
		lda 	#KWD_RPAREN
		jmp 	CheckSyntax

; *****************************************************************************
;
;		Shared handler - do not call directly as ends PLA/RTS imbalanced.
;
; *****************************************************************************

CheckSyntax:
		cmp 	(codePtr),y
		bne 	_CSFail
		iny
		pla
		rts
_CSFail:
		report Syntax		

; *****************************************************************************
;
;						Table Entries for non command words
;
; *****************************************************************************

NoOp1:		;; [,]
NoOp2:		;; [;]
NoOp3:		;; [)]
NoOp6:		;; [proc]
NoOp7:		;; [then]
NoOp8:		;; [to]
NoOp9:		;; [step]

		report 	Syntax
		