;JOSH LEIDL - 200350878
;AS4 Q1

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
	
	LDR R6, =0x12345678
	MOV R12, #4
	
	;DESCRIPTION: Rotating shift left
	;ARGUMENTS: R6 = toShift, R12 = shiftAmount
	;CONSTRAINTS: shiftAmount < 32
	;RETURN: R4 = shifted
	BL rot_left
	
endLoop
	B endLoop

END		
	
rot_left
	;Store R0, R1, and R2 for use
	PUSH {R0, R1, R2}
	
	LSL R0, R6, R12
	
	MOV R4, #32
	SUB R2, R4, R12
	LSR R1, R6, R2
	
	ADD R4, R0, R1
	
	POP {R0, R1, R2}
	
	BX LR