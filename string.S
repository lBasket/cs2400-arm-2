		;		ARM Programming Assignment #2: Writing C-strings
		;
		;		Write a program that assembles the values in chars*
		;		into a C-style string. A C-style string is an array
		;		of byte-size characters, terminated by a NULL (0x0).
		;		Write the C-string to the FILL memory at 'string'.
		;		Note: It's up to you to declare the correct number
		;		of bytes to hold the result.
		
		;		Your code here
		
chars0	DCD		'T', 'h', 'e', ' ', '2', '0', '1', '8', ' ', 'T', 'u'
chars1	DCD		'r', 'i', 'n', 'g', ' ', 'A', 'w', 'a', 'r', 'd', ' '
chars2	DCD		'w', 'a', 's', ' ', 'a', 'w', 'a', 'r', 'd', 'e', 'd'
chars3	DCD		' ', 't', 'o', ' ', 'B', 'e', 'n', 'g', 'i', 'o'
chars4	DCD		' ', 'H', 'i', 'n', 't', 'o', 'n', ' ', 'a', 'n'
chars5	DCD		'd', ' ', 'L', 'e', 'C', 'u', 'n', 'n', ' ', 'f', 'o'
chars6	DCD		'r', ' ', 't', 'h', 'e', 'i', 'r', ' ', 'w', 'o', 'r'
chars7	DCD		'k', ' ', 'o', 'n', ' ', 'n', 'e', 'u', 'r', 'a', 'l'
chars8	DCD		'n', 'e', 't', 'w', 'o', 'r', 'k', 's', '.'
count	DCD		95
string	FILL		200
		
		;ADR		R0, count		;get count from memory & put into R12
		MOV		R12, #95
		ADR		R11, string ; filling list
		ADR		r10, chars0 ;take first list
		
newreg	MOV		R1, #0	; reset R1 to 0
		MOV		R2, #24	; reset R2 to 24
		
loop		CMP		R12, #84
		BEQ		gl2
		
		LDR		R0, [R10], #4	; Load next char into R0
		MOV		R0, R0, LSL R2	; shift R0 left by number in R2
		
		ORR		R1, R1, R0
		
		SUB		R12, R12, #1
		SUBS		R2, R2, #8			;subtract 8 from R2
		
		BPL		loop
		
		STR		R1, [R11], #4		;store full byte-aligned 32bits
		
		B		newreg
		
		
loop2	CMP		R12, #73
		BEQ		list3
		
mainl	LDR		R0, [R10], #4	; Load next char into R0
		MOV		R0, R0, LSL R2	; shift R0 left by number in R2
		
		ORR		R1, R1, R0
		
		SUB		R12, R12, #1
		SUBS		R2, R2, #8			;subtract 8 from R2
		
		BPL		endchk
		
		STR		R1, [R11], #4		;store full byte-aligned 32bits
		MOV		R1, #0	; reset R1 to 0
		MOV		R2, #24	; reset R2 to 24
		
		B		endchk
		
		
		
endchk	CMP		R12, #73
		BEQ		gl3
		
		CMP		R12, #62
		BEQ		gl4
		
		CMP		R12, #52
		BEQ		gl5
		
		CMP		R12, #42
		BEQ		gl6
		
		CMP		R12, #33
		BEQ		gl7
		
		CMP		R12, #22
		BEQ		gl8
		
		CMP		R12, #11
		BEQ		gl9
		
		CMP		R12, #0
		BNE		mainl
		END
		
		
gl2		ADR		R10, chars1
		B		mainl
		
gl3		ADR		R10, chars2
		B		mainl
		
gl4		ADR		R10, chars3
		B		mainl
		
gl5		ADR		R10, chars4
		B		mainl
		
gl6		ADR		R10, chars5
		B		mainl
		
gl7		ADR		R10, chars6
		B		mainl
		
gl8		ADR		R10, chars7
		B		mainl
		
gl9		ADR		R10, chars8
		B		mainl
