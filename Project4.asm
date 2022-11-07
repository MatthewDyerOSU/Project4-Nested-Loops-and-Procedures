TITLE Program Template     (template.asm)

; Author: Matthew Dyer
; Last Modified: 11/2/2022
; OSU email address: dyerma@oregonstate.edu
; Course number/section:   CS271
; Project Number: 4                Due Date: 11/13/2022
; Description: This program calculates prime numbers up to the nth prime. The user will be instructed
;	to enter a number (n), between 1 and 200 inclusive. If the user enters a number over 200 or under 1 they will
;	be given an error message and will be reprompted to enter a number. All the numbers up to and including the
;	nth prime will be calculated and displayed, 10 prime numbers per line. These will be displayed in ascending order, 
;	with at least 3 spaces in between each prime number. It is okay for the final row to display less than 10 numbers.

INCLUDE Irvine32.inc

; (insert macro definitions here)

MIN_INPUT = 1
MAX_INPUT = 200

.data

intro1		BYTE	"Prime Numbers, programmed by Matthew Dyer",0
intro2		BYTE	"Enter the number of prime numbers you would like to see.",13,10,
					"I'll accept orders for up to 200 primes.",13,10,0
prompt		BYTE	"Enter the number of primes to display [1-200]: ",0
space		BYTE	"   ",0			; 3 space characters for display spacing
input		DWORD	?				; user input
outtro		BYTE	"Results certified by Matthew Dyer. Goodbye!",0
error		BYTE	"Number out of range![1-200] Please try again.",0
validBool	DWORD	?				; will be 1 or 0 determined by the user input validation
prime		DWORD	?				; empty variable for storing prime numbers to be displayed
primeBool	DWORD	?				; will be 1 if prime or 0 if not prime
candidate	DWORD	1				; 
divisor		DWORD	2				; divisor to be incremented during primality loop
rowCount	DWORD	0				; when this equals 10, a new row will be started

.code
main PROC
	CALL	introduction
	CALL	getUserData
	CALL	showPrimes
	CALL	farewell
	Invoke ExitProcess,0	; exit to operating system
main ENDP

;------------------------------------------------------------------------------
; Name: Introduction
;
; This procedure introduces the user to the program and the program author
;
; Preconditions: None
;
; Postconditions: EDX contains OFFSET intro2
;
; Receives: None
;
; Returns: Intro messages to terminal
;------------------------------------------------------------------------------
introduction PROC
	MOV		EDX, OFFSET		intro1
	CALL	WriteString
	CALL	CrLf
	MOV		EDX, OFFSET		intro2
	CALL	WriteString
	CALL	CrLf
	RET
introduction ENDP
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Name: getUserData
;
; Prompts the user for input and calls validate procedure to validate user
;	input. If user input is invalid, reprompts the user for input.
;
; Preconditions: input needs to be DWORD sized unsigned decimal number
;
; Postconditions: input is moved to EAX
;
; Receives: unsigned decimal input from user, DWORD
;
; Returns: input variable that has been validated
;------------------------------------------------------------------------------
getUserData PROC
	_GetInput:
	MOV		EDX, OFFSET		prompt
	CALL	WriteString
	CALL	ReadDec
	MOV		input, EAX
	CALL	validate
	CMP		validBool, 1
	JNE		_GetInput
	RET
getUserData ENDP
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Name: validate
; 
; Validates the data in the input variable. Returns a 1 to validBool if valid,
;	returns a 0 to validBool if invalid.
;
; Preconditions: None
;
; Postconditions: EDX contains OFFSET error
;
; Receives: input variable
;
; Returns: validBool variable with a 1 for valid or 0 for invalid. Returns 
;	error message if invalid.
;------------------------------------------------------------------------------
validate PROC
	CMP		input, MIN_INPUT
	JL		_Error
	CMP		input, MAX_INPUT
	JG		_Error
	MOV		validBool, 1		; successfully validated
	JMP		_Validated
	_Error:
		MOV		EDX, OFFSET		error
		CALL	WriteString
		CALL	CrLf
		MOV		validBool, 0		; not validated, get new input
	_Validated:
		RET
validate ENDP
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Name: showPrimes
;
; Calculates and displays all of the prime numbers up to and including the nth prime,
;	where n is equal to the input variable. Results are displayed 10 per line, with
;	3 spaces in between each number.
;
; Preconditions: candidate = 1, rowCount = 0, input is validated
;
; Postconditions: EAX, ECX, EDX changed
;
; Receives: input, candidate, rowCount
;
; Returns: prints primes to terminal, spaced 3 spaces apart, 10 per line
;------------------------------------------------------------------------------
showPrimes PROC
; Displays the first prime, which is always 2, so that only odd numbers can be used after
	MOV		ECX, input			; display loop counter = num inputted by user
	MOV		EAX, 2				; 2 will always be included as first prime
	CALL	WriteDec
	MOV		EDX, OFFSET		space
	CALL	WriteString
	DEC		ECX
	INC		rowCount
	CMP		input, 1			; if user inputted 1, jump to end of procedure
	JE		_NoMorePrimes
; Calculate and display any further primes
	_DisplayLoop:
		ADD		candidate, 2
		CALL	isPrime
		CMP		primeBool, 0
		JE		_NotPrime
		MOV		EAX, prime
		CALL	WriteDec
		MOV		EDX, OFFSET		space
		CALL	WriteString
		INC		rowCount
		CMP		rowCount, 10
		JE		_NewRow
		LOOP	_DisplayLoop			
		JMP		_NoMorePrimes
		_NotPrime:
			JMP		_DisplayLoop			; Jumps back to top of loop without decrementing ECX
		_NewRow:
			CALL	CrLf
			MOV		rowCount, 0
			LOOP	_DisplayLoop		
		
	_NoMorePrimes:
		RET
showPrimes ENDP
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Name: isPrime
;
; Checks if a number is prime or not by trying to divide the candidate number by
;	every number less than it starting at 3. If the divisor is incremented until it
;	is equal to the candidate without the remainder ever being 0, then a prime is
;	found and primeBool is set to 1 (True). If not than primeBool is set to 0 (false).
;
; Preconditions: divisor = 2, candidate > 2
;
; Postconditions: None
;
; Receives: candidate, divisor
;
; Returns: primeBool = 1 if candidate is prime, 0 if candidate is not.
;------------------------------------------------------------------------------
isPrime PROC
	PUSHAD
	PUSH	divisor
	_PrimalityLoop:
		INC		divisor
		MOV		EAX, candidate
		CMP		EAX, divisor
		JE		_PrimeFound
		CDQ
		DIV		divisor
		CMP		EDX, 0
		JE		_PrimeNotFound
		JNE		_PrimalityLoop
		_PrimeFound:
			MOV		EAX, candidate
			MOV		prime, EAX
			MOV		primeBool, 1
			POP		divisor
			POPAD
			RET
		_PrimeNotFound:
			MOV		primeBool, 0
			POP		divisor
			POPAD
			RET
isPrime ENDP
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Preconditions: None
;
; Postconditions: EDX contains OFFSET outtro
;
; Receives: None
;
; Returns: Prints outtro message to terminal
;------------------------------------------------------------------------------
farewell PROC
	CALL	CrLf
	MOV		EDX, OFFSET		outtro
	CALL	WriteString
	CALL	CrLf
farewell ENDP
;------------------------------------------------------------------------------
END main
