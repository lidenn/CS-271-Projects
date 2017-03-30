TITLE Integer Accumulator     (Program3.asm)

; Author: Dennis
; Course / Project ID : Program #3                Date: 2/12/2017
; Description: This program finds the sum and the average of negative numbers that the user inputs.

INCLUDE Irvine32.inc

; (insert constant definitions here)
Lower_limit = -100

.data
opening		BYTE	"Welcome to the Integer Accumulator by Dennis Li",0
ask_name	BYTE	"What is your name?",0
greeting	BYTE	"Hello, ",0
user_name	BYTE	33 DUP(0)


ask_num				BYTE	"Please enter numbers in [-100, -1]",0
stop_instruct		BYTE	"Enter a non-negative number when you are finished to see the results",0
invalid_number		BYTE	"This number is not in the range of [-100,-1] and is not positive",0
enter_num			BYTE	"  Enter number: ",0
num_valid_inputs	BYTE	"Number of Valid inputs: ",0
num					DWORD	?
sum					DWORD	0
count				DWORD	0
average				DWORD	?

state_sum			BYTE	"Sum of your valid integers is: ",0
state_average		BYTE	"Average of your valid integers is: ",0
Extra_credit		BYTe	"**EC:Display lines for user number input",0

closing				BYTE	"Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ",0



.code
main PROC

;Introduction
mov		edx, OFFSET opening
call	writeString
call	CrLf
mov		edx, OFFSET ask_name
call	writeString
call	CrLf
mov		edx, OFFSET user_name
mov		ecx, 32
call	readString
call	CrLf
mov		edx, OFFSET greeting
call	writeString
mov		edx, OFFSET user_name
call	writeString
call CrLf

;Ask for numbers
	mov		edx, OFFSET ask_num
	call	writeString
	call	CrLf
	mov		edx, OFFSET stop_instruct
	call	writeString
	call	CrLf
	mov		edx, OFFSET extra_credit
	call	WriteString
	Call	CrLf
	
	input_num:
;Extra credit option: Display lines for user input		

		mov		eax, count
		add		eax, 1
		call	WriteDec

		mov		edx, OFFSET enter_num
		call	writeString
		mov		eax, num
		call	readInt
		cmp		eax, -1
		jg		end_loop		  ;Goes to end to find sum and average
		cmp		eax, lower_limit
		jl		invalid_loop	 ;States error and asks for another number
		add		eax, sum			;Accumulator for count(sum=sum+num)
		mov		sum, eax
		mov		eax, count			;Accumulator for count (number of valid inputs)
		add		eax, 1
		mov		count, eax
		jmp		input_num

	invalid_loop:
		mov		edx, OFFSET invalid_number
		call	writeString
		call	CrLf
		jmp		input_num



	end_loop:
		mov		eax, count ;If there are not valid numbers
		cmp		eax, 0
		jle		print 

		mov		eax, sum
		cdq
		mov		ebx, count
		idiv	ebx
		mov		average, eax


	

	

;Print results
print:
	mov		edx, OFFSET num_valid_inputs	;Number of valid inputs
	call	WriteString
	mov		eax, count
	call	WriteDec
	call	CrLf

	mov		edx, OFFSET state_sum			;Sum
	call	WriteString
	mov		eax, sum
	call	writeInt
	call	CrLf

	mov		edx, OFFSET state_average		;Average
	call	WriteString
	mov		eax, average
	call	WriteInt
	call	CrLf

;Closing
	mov		edx, OFFSET closing
	call	WriteString
	mov		edx, offset User_name
	call	WriteString
	call	CrLf


	exit
main ENDP

; (insert additional procedures here)

END main
