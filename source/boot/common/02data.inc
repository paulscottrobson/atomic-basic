; *****************************************************************************
; *****************************************************************************
;
;		Name:		data.inc
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Data allocation
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;							   Zero Page Variables
;
; *****************************************************************************

		* = ZeroPageStart

codePtr:.fill 		3 						; code ptr - extra byte for paging.

tempShort:.fill 	1 						; used for v.short term saving.

temp0:	.fill 		2
temp1:	.fill 		2
temp2:	.fill 		2
temp3:	.fill 		2
temp4:	.fill 		2

StackPtr:.fill 		2						; highest byte allocated, stack works down.

LowMemory:.fill 	2 						; next byte available working up

; *****************************************************************************
;
;								Evaluation Stack
;
; *****************************************************************************

		* = DataStackStart

esType:	.fill 		DataStackSize 			; bit 7 any reference, bit 6 byte reference, bit 0 string.									
esInt0:	.fill 		DataStackSize		 	; 32 bit integer, also used for string address
esInt1:	.fill 		DataStackSize			; (16 bit only)
esInt2:	.fill 		DataStackSize		
esInt3:	.fill 		DataStackSize		

esStrLow = esInt0 							; String address synonym
esStrHigh = esInt1 

; *****************************************************************************
;
;								Other variables
;
; *****************************************************************************

		* = DataStart
		.align 	256  						; these two must be on one page.
		
RootVariables: 											
		.fill 	26*4 						; variables A-Z which are fixed.

HashTable:
		.fill 	HashTableSize*2 			; variable hash table.
	
Seed32:	
		.fill 	4 							; random number

Buffer:	 									; string conversion buffer.
		.fill 	20 		

ClockTicks: 								; clock ticks.
		.fill 	4		

IToSCount:									; characters output.s
		.fill 	1		