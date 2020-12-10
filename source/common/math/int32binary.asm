; *****************************************************************************
; *****************************************************************************
;
;		Name:		int32binary.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Simple 32 bit binary logic operations
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;								And TOS+1 to TOS
;
; *****************************************************************************

Int32And:
		lda 	esInt0,x
		and 	esInt0+1,x
		sta 	esInt0,x

		lda 	esInt1,x
		and 	esInt1+1,x
		sta 	esInt1,x

		lda 	esInt2,x
		and 	esInt2+1,x
		sta 	esInt2,x

		lda 	esInt3,x
		and 	esInt3+1,x
		sta 	esInt3,x
		rts

; *****************************************************************************
;
;								ora TOS+1 to TOS
;
; *****************************************************************************

Int32Or:
		lda 	esInt0,x
		ora 	esInt0+1,x
		sta 	esInt0,x

		lda 	esInt1,x
		ora 	esInt1+1,x
		sta 	esInt1,x

		lda 	esInt2,x
		ora 	esInt2+1,x
		sta 	esInt2,x

		lda 	esInt3,x
		ora 	esInt3+1,x
		sta 	esInt3,x
		rts

; *****************************************************************************
;
;								Exor TOS+1 to TOS
;
; *****************************************************************************

Int32Xor:
		lda 	esInt0,x
		eor 	esInt0+1,x
		sta 	esInt0,x

		lda 	esInt1,x
		eor 	esInt1+1,x
		sta 	esInt1,x

		lda 	esInt2,x
		eor 	esInt2+1,x
		sta 	esInt2,x

		lda 	esInt3,x
		eor 	esInt3+1,x
		sta 	esInt3,x
		rts