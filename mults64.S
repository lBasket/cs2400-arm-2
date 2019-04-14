		;		ARM Programming Assignment #2: 64 bit signed integer multiplier
		;		Write a 64-bit SIGNED multiplier. It should take only a small modification to your
		;		unsigned version. Remember (-6)*(-6) = 36, (-6)*6 = -36.
		;		Use the standard shift-and-add operation.
		;		Use the two numbers as an example but write it so it works for any two 16-bit numbers.
		;		Note that in VisUAL you cannot store 64-bit values (double words) directly. The upper
		;		and lower words are your higher 32 bits and lower 32 bits of the two numbers,
		;		respectively.
		;		Write the result in the provided "fill" word.
		;		Indicate if there was a high-bit carry using the provided "fill" word.
upper	DCD		0xA0BCFF0D, 0xFFF0ADEA
lower	DCD		0xFFF1AD2A, 0xA0ACEF0D
result	FILL		16
carry	FILL		4
		
		;0xFFF0ADEAA0ACEF0D
		;first	thing mult32 does is puts shit into r5/r6, so use those for ADR
		;18
		ADR		R5, upper
		ADR		R6, lower
		
		LDR		R0, [R5]
		LDR		R1, [R6, #4]
		
		BL		mult32
		
		MOV		R10, R2
		MOV		R11, R3
		
		;17
		ADR		R5, upper
		ADR		R6, lower
		
		LDR		R0, [R6]
		LDR		R1, [R5, #4]
		
		BL		mult32
		
		;20
		ADDS		R11, R3, R11
		ADCS		R10, R2, R10
		MOV		R12, #0
		BCC		qc
		
		MOV		R12, #1
		
qc		STR		R10, [sp, #4]
		STR		R11, [sp, #8]
		
		;19
		ADR		R5, upper
		
		LDR		R0, [R5]
		LDR		R1, [R5, #4]
		
		BL		mult32
		
		ADD		R12, R3, R12
		MOV		R11, R2
		
		
		;16
		ADR		R5, lower
		
		LDR		R0, [R5]
		LDR		R1, [R5, #4]
		
		BL		mult32
		
		;22
		LDR		R4, [sp, #4]
		LDR		R5, [sp, #8]
		
		ADD		R4, R3, R5, LSL #16
		ADCS		R2, R2, R4, LSL #16
		
		;23
		ADCS		R12, R12, R5, LSR #16
		ADC		R11, R11, R4, LSR #16

		;so close yet so far....
		
		
		
		
		
		END
		;BL		mult32
		;STR		R0, [sp]
		;STR		R1, [sp,#4]
		
		;LDR		R2, [sp]
		;LDR		R3, [sp,#4]
		;		========================================
		;		mult32 subroutine: multiplies two 32bit numbers using the a 16bit multiplier and booths algorithm
		;		INPUTS:
		;		R0: first 32bit multiplier
		;		R1: second 32bit multiplier
		;		OUTPUTS:
		;		R2: first half of product (MSB)
		;		R3: second half of product (LSB)
		;		CORRUPTS (dependencies):
		;		(R0, R1, R2, R3, R4), R5, R6, R7, R8, R9
		;		(not R10, R11, R12)
		;		========================================
mult32	STR		LR, [sp]			;save your escape from this subroutine!
		MOV		R5, R0, LSR #16	; Top half of R0
		MOV		R6, R1, LSR #16	; Top half of R1
		
		BIC		R7, R0, R5, LSL #16	; Bottom half of R0
		BIC		R8, R1, R6, LSL #16	; Bottom half of R1
		
		;		Put Bottom R0 (R7)* Bottom R1 (R8) into R9
		MOV		R0, R7
		MOV		R1, R8
		BL		mult
		MOV		R9, R2
		
		;		Put Bottom R0 (R7) * Top R1 (R6) into R10
		MOV		R0, R7
		MOV		R1, R6
		BL		mult
		MOV		R7, R2
		
		;		Put Top R0 (R5) * Bottom R1 (R8) into R11
		MOV		R0, R5
		MOV		R1, R8
		BL		mult
		MOV		R8, R2
		
		;		Put Top R0 (R5) * Top R1 (R6) into R12
		MOV		R0, R5
		MOV		R1, R6
		BL		mult
		MOV		R6, R2
		
		LDR		LR, [sp]			;retrieve your escape from this subroutine
		;		Add partials
		ADDS		R0, R8,R7
		
		ADDCS	R1, R6, #0x10000
		ADDS		R3, R9, R0, LSL #16 ;R3 not used til here
		ADC		R2, R1, R0, LSR #16
		
		;ADR		R8, result		; Load mem address of result into R11
		;ADR		R7, carry		; Load mem address of carry into R10
		
		;STR		R2, [R8], #4
		;STR		R3, [R8]
		
		BCC		stop
		MOV		R4, #1
		STR		R4, [R7]
		
stop		MOV		PC, LR ;END
		;		========================================
		;		mult subroutine: multiplies two 16bit numbers (R2 <- R0 * R1 )
		;		INPUTS:
		;		R0 : first 16bit multiplier
		;		R1 : second 16bit multiplier
		;		OUTPUTS:
		;		R2 : product (R0*R1)
		;		CORRUPTS:
		;		R0, R1, R2, R3, R4
		;		========================================
mult		MOV		R2, #0 			; (A) initialize to 0
		MOV		R3, #16			; (N) bit-counter, 16 for 16bit numbers (N)
		MOV		R4, #0			; Set carry-counter 0
		
checkQ	TST		R1, #0b1			; test if LSB in R1 is 1
		BEQ		skipadd			; Skip adding if LSB in R1 = 0
		
		ADDS		R2, R2, R0		; A = A + B
		BCC		skipadd			; skip tracking carry if no carry
		ADD		R4, R4, #1		; add 1 carry to R4
		
		
skipadd	MOV		R0, R0, LSL #1		; Shift B left
		MOV		R1, R1, LSR #1		; shift Q right
		
		SUBS		R3, R3, #1		; N = N - 1
		
		BNE		checkQ			; if N != 0, go back to check LSB of Q
		
		MOV		PC, LR
