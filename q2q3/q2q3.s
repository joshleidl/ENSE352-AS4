;JOSH LEIDL - 200350878
;AS4 Q2 Q3

;THIS CODE USES A COPIED LAB HEADER

;;; Directives
            PRESERVE8
            THUMB  
			
			
;;; Equates

INITIAL_MSP	EQU		0x20001000	; Initial Main Stack Pointer Value	Allocating 
								; 1000 bytes to the stack as it grows down.
			     
								    
; Vector Table Mapped to Address 0 at Reset
; Linker requires __Vectors to be exported

      AREA    RESET, DATA, READONLY
      EXPORT  __Vectors

__Vectors	DCD		INITIAL_MSP			; stack pointer value when stack is empty
        	DCD		Reset_Handler		; reset vector
	 		
			ALIGN

;The program
; Linker requires Reset_Handler

      AREA    MYCODE, CODE, READONLY



			ENTRY
			EXPORT	Reset_Handler

			ALIGN
				

Reset_Handler
PROC
	
	MOV R2, #0x20002000
	LDR R1, =testString
	MOV R3, #46
	
	BL byte_copy
	
	MOV R1, R2
	MOV R0, #14 ;Shift amount
	
	BL encrypt
	
endLoop
	B endLoop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; copy an array of bytes from source ptr R1 to dest ptr R2.  R3
;;; contains the number of bytes to copy.
;;; Require:
;;; The destination had better be somewhere in RAM, but that's the
;;; caller's responsibility.  As is the job to ensure the source and 
;;; dest arrays don't overlap.
;;;
;;; Promise: No registers are modified.  The destination buffer is
;;;          modified.
;;; Author: Prof. Karim Naqvi (Oct 2013)
	ALIGN
byte_copy  PROC
	push {r1,r2,r3,r4}

	mov r5, #0
loop
	ldrb r4, [r1]
	strb r4, [r2]
	
	add r1,#1
	add r2,#1
	add r5,#1
	cmp r3,r5
	bne loop
    
	pop	{r1,r2,r3,r4}
	bx	lr
	ENDP

;String in R1, shift amount in R0
;Encrypted string replaces old

ALIGN
encrypt
PROC
	
	PUSH{R2, R3}
	SUB R2, #26, R0 ;alternate encrypt amount
	
	
	
	
eLoop
	
	LDRB R3, [R1] ;R3 now holds character at pos R2

		
	CMP R3, #0
	BEQ doneCounting
	
	CMPLT R3, #64 ;Compare less than
	BEQ eLoop
	CMPGT R3, #90 ;Compare greater than
	BEQ tryLower
	
	B shiftUpper
	
tryLower
	
	CMPLT R3, #97
	BEQ eLoop
	CMPGT R3, #122
	BEQ eLoop
	
shiftLower

	ADD R3, R3, R0
	CMPGT R3, #122
	BEQ over
	
	STRB R3, [R1]
	
	B eLoop
	
shiftUpper

	ADD R3, R3, R0
	CMPGT R3, #90
	BEQ over
	
	STRB R3, [R1]
	
	B eLoop
	
over
	SUB R3, R3, R0
	SUB R3, R3, R2
	
	STRB R3, [R1]
	
	B eLoop
	
doneCounting
	
	POP{R2, R3}
	BX LR
	

ENDP
	
;String in R1, shift amount in R0
;Encrypted string replaces old
ALIGN
decrypt
PROC
	PUSH {R5}
	MOV R5, R0
	
	SUB R0, #26, R0
	
	PUSH {LR}
	BL encrypt
	
	POP {LR}
	MOV R0, R5
	POP {R5}
	
	BX LR
ENDP
	
END

testString
	DCB "The Quick Brown Fox Jumped Over The Lazy Dog.",0