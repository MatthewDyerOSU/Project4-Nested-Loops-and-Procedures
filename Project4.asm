TITLE Program Template     (template.asm)

; Author: Matthew Dyer
; Last Modified: 11/2/2022
; OSU email address: dyerma@oregonstate.edu
; Course number/section:   CS271
; Project Number: 4                Due Date: 11/13/2022
; Description: This program calculates prime numbers. The user is instructed to enter the number of
;	primes to be displayed [1-200]. The user is reprompted if they enter an out of bounds number. The
;	program then calculates and displays all the prime numbers up to and including the nth prime. Results
;	will be displayed 10 prime numbers per line, in ascending order, with at least 3 spaces between numbers.
;	The final row may contain less than 10 numbers.

INCLUDE Irvine32.inc

; (insert macro definitions here)

MIN_INPUT = 1
MAX_INPUT = 200

.data

intro_1		BYTE	"Prime Numbers, programmed by Matthew Dyer",0
intro_2		BYTE	"Enter the number of prime numbers you would like to see.",13,10,
					"I'll accept orders for up to 200 primes.",13,10,0
prompt		BYTE	"Enter the number of primes to display [1-200]: ",0
space		BYTE	"   ",0			; 3 space characters for display spacing
input		DWORD	?				; user input
outtro		BYTE	"Results certified by Matthew Dyer. Goodbye!",0
error		BYTE	"Number out of range![1-200] Please try again.",0
valid_bool	DWORD	?				; will be 1 or 0 determined by the user input validation
prime		DWORD	?				; empty variable for storing prime numbers to be displayed
prime_bool	DWORD	?				; will be 1 if prime or 0 if not prime
candidate	DWORD	1
divisor		DWORD	1				; divisor to be incremented during primality loop

.code
main PROC

	; (insert executable instructions here)
	CALL	introduction
	CALL	getUserData


	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)
introduction PROC
	MOV		EDX, OFFSET		intro_1
	CALL	WriteString
	CALL	CrLf
	MOV		EDX, OFFSET		intro_2
	CALL	WriteString
	CALL	CrLf
	RET
introduction ENDP

getUserData PROC
	_GetInput:
	MOV		EDX, OFFSET		prompt
	CALL	WriteString
	CALL	ReadDec
	MOV		input, EAX
	CALL	validate
	CMP		valid_bool, 1
	JNE		_GetInput
	RET
getUserData ENDP

validate PROC
	CMP		input, MIN_INPUT
	JL		_Error
	CMP		input, MAX_INPUT
	JG		_Error
	MOV		valid_bool, 1		; successfully validated
	JMP		_Validated
	_Error:
		MOV		EDX, OFFSET		error
		CALL	WriteString
		CALL	CrLf
		MOV		valid_bool, 0		; not validated, get new input
	_Validated:
		RET
validate ENDP

showPrimes PROC
	MOV		ECX, input
	_DisplayLoop:
		INC		candidate
		CALL	isPrime


		MOV		EAX, prime
		CALL	WriteDec
		MOV		EDX, OFFSET		space
		CALL	WriteString
		LOOP	_DisplayLoop
	RET
showPrimes ENDP

isPrime PROC
		PUSH	ECX
		MOV		ECX, candidate
		DEC		ECX
	_PrimalityLoop:
		MOV		EAX, candidate
		MOV		EDX, 0
		DIV		ECX
		CMP		EDX, 0
		JNZ		_PrimalityLoop
		MOV		prime, candidate
	RET
isPrime ENDP

farewell PROC
	MOV		EDX, OFFSET		outtro
	CALL	WriteString
	CALL	CrLf
farewell ENDP
END main
