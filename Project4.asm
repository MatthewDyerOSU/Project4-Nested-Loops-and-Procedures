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

; (insert constant definitions here)

.data

; (insert variable definitions here)

.code
main PROC

; (insert executable instructions here)
CALL	introduction
CALL	getUserData

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)
introduction PROC
introduction ENDP

getUserData PROC
validate PROC
validate ENDP
getUserData ENDP

showPrimes PROC
isPrime PROC
isPrime ENDP
showPrimes ENDP

farewell PROC
farewell ENDP
END main
