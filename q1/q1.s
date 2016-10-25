; Put your name and a title for the program here

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
	
	MOV R1, #16

endloop
	b endloop

END		