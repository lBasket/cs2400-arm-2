		;		ARM Programming Assignment #2: 32 bit signed integer multiplier
		;
		;		Write a 32-bit SIGNED multiplier. It should take only a small modification to your
		;		unsigned version. Remember (-6)*(-6) = 36, (-6)*6 = -36.
		;		Use the standard shift-and-add operation.
		;		Use the two numbers as an example but write it so it works for any two 16-bit numbers.
		;		Write the result in the provided "fill" word.
		;		Indicate if there was a high-bit carry using the provided "fill" word.
		
		;		Your code here
		
		
		
		
		
numbers	DCD		0xA0BCFF0D, 0xFFF0ADEA
result	FILL		8
carry	FILL		4
tenk		DCD		0x10000 ; I needed this on my laptop but it appears not on my desktop?
sign		FILL		4		;indicate sign bit for result, 0=pos, 1=neg
		
		ADR		R12, numbers 		; Load mem address of numbers into R12
		LDR		R0, [R12] 		; (B) Load first number into R0
		LDR		R1, [R12, #4]! 	; (Q) Load second number in R1
		
		;		checking negatives can go here
		ADR		R12, numbers 		; Load mem address of numbers into R12
		LDR		R0, [R12] 		; (B) Load first number into R0
		LDR		R1, [R12, #4]! 	; (Q) Load second number in R1
		
		MOV		R3, #0		; clear r3 to 0
		ANDS		R2, R0, #0x80000000		; check last bit if it is negative
		
		BEQ		pos1 				;skip counting neg is is pos
		
		MOV		R3, #1				;count 1 neg
		
pos1		ANDS		R2, R1, #0x80000000		;check last bit in 2 if it is negative
		
		BEQ		pos2
		
		ADD		R3, R3, #1			; count another negative
		
pos2		CMP		R3, #1 					;0,2 negatives = pos result, 1 neg = neg result
		ADR		R4, sign			;put address of 'sign' into r4
		
		BNE		posres			;if R3 != 1, result is positive, branch to that section
		
		MOV		R3, #1		;R3=1, then move 1 into sign to indicate negative result
		STR		R3, [R4]
		
		B		signcheck		;skip positive result logic
		
posres	MOV		R3, #0		;R3!=1, move 0 into sign to indicate positive result
		STR		R3, [R4]
		
		
		;/end
		
		
		
signcheck	MOV		R5, R0, LSR #16	; Top half of R0
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
		MOV		R10, R2
		
		;		Put Top R0 (R5) * Bottom R1 (R8) into R11
		MOV		R0, R5
		MOV		R1, R8
		BL		mult
		MOV		R11, R2
		
		;		Put Top R0 (R5) * Top R1 (R6) into R12
		MOV		R0, R5
		MOV		R1, R6
		BL		mult
		MOV		R12, R2
		
		;		Add partials
		ADDS		R0, R11, R10
		ADR		R5, tenk
		LDR		R4, [R5]
		ADDCS	R1, R12, R4
		ADDS		R2, R9, R0, LSL #16
		ADC		R3, R1, R0, LSR #16
		
		ADR		R11, result		; Load mem address of result into R11
		ADR		R10, carry		; Load mem address of carry into R10
		
		STR		R3, [R11], #4
		STR		R2, [R11]
		
		;		setting negative flag at end is here
		
		;		/end
		
		BCC		stop
		MOV		R4, #1
		STR		R4, [R10]
		
stop		END
		
		
		
		



	
		
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
		;STR		R4, [R10]			; Stores the # of carries that occurred
		
		;STR		R2, [R11]			; Store product into 'result' in mem
		
		
		
		
		
		
		
		
		
