; *****************************************************************************
; *****************************************************************************
;
;		Name:		iftdummy.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Dummy interface for runtime
;
; *****************************************************************************
; *****************************************************************************

ColdStart:
		jmp 	TestProgram
WarmStart:
		jmp 	WarmStart