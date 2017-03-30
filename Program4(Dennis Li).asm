TITLE Composite Numbers    (Program3.asm)

; Author: Dennis
; Course / Project ID : Program #4               Date: 2/19/2017
; Description: This program displays the number of composite numbers based on the user input

INCLUDE Irvine32.inc

; (insert constant definitions here)
Lower_limit = 1
Upper_limit = 400

.data

opening		BYTE	"Composite Numbers by Dennis Li",0
greeting	BYTE	"Enter the number of composite numbers you would like to see. ",0
greeting2	BYTE	"I'll accept orders for up to 400 composites",0



ask_num				BYTE	"Please enter number of composites to display [1, 400]: ",0
invalid_number		BYTE	"This number is not in the range of [1, 400]",0
ExtraCredit			BYTE	"EC: Extracredit Option 1, Align output columns"

user_num			DWORD	?
test_nums			DWORD	1			;Numbers being tested

divisible_count		DWORD	0			;Number of divisors
divisor				DWORD	1			;Divided by
num_composites		DWORD	0			

spacing				BYTE	"   ",0
one_d_space			BYTe	"  ",0
two_d_space			BYTE	" ",0





closing				BYTE	"Results certified by Dennis Li. Good Bye ",0



.code
main PROC
	call Introduction
	call GetUserData
	call ShowComposites
	call Farewell

	exit
main ENDP

; (insert additional procedures here)



Introduction PROC
	mov		edx, OFFSET opening
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ExtraCredit
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET greeting
	call	WriteString
	call	CrLf
	mov		edx, OFFSET greeting2
	call	WriteString
	call	CrLf
	call	CrLf
	ret
Introduction ENDP


GetUserData PROC
	valid:
		mov		edx, OFFSET ask_num
		call	WriteString
		call	ReadInt
		mov		user_num,eax
	
		;Data Validation
	
		mov		eax, user_num
		cmp		eax, Lower_limit
		jl		valid
		cmp		eax, Upper_limit
		jg		valid

	ret
GETUSERDATA ENDP

ShowComposites	PROC
	
	Divide:
		mov		eax, test_nums
		mov		ebx, divisor
		cdq
		div		ebx
		cmp		edx, 0
		jne		Increment_Divisor					;If there is remainder, it will increment the divisor and skip counting

	;Count Number of divisors
		mov		eax, divisible_count				
		add		eax, 1
		mov		divisible_count, eax
	
	;IS COMPOSITE (Checks if composite)
		mov		eax, divisible_count
		cmp		eax, 3
		jge		is_composite						;Leave inside loop (If composite)

	Increment_Divisor:								;Inside Loop (increments the divisor from 1-Test_num)		
		mov		eax, divisor  
		add		eax, 1
		mov		divisor, eax

		mov		eax, divisor
		cmp		eax, test_nums
		jle		Divide
		jmp		Increment_test_Num					;If it reaches test num, it leaves inside loop

	Is_Composite:													;Prints Numbers and continues with Outside loop
		mov		eax, num_composites
		add		eax, 1 
		mov		num_composites, eax
		mov		eax, test_nums
		call	WriteDec
		
		;EC: Align the columns
		cmp		eax, 10
		jl		one_digit_spacing
		cmp		eax, 100
		jl		two_digit_spacing
		jmp		organizing
		one_digit_spacing:
			mov		edx, OFFSET one_d_space
			call	WriteString
			jmp		organizing
		two_digit_spacing:
			mov		edx, OFFSET two_d_space
			call	WriteString
			jmp		organizing
	

		Organizing:
		;Sort into 10 columns
		mov		edx, OFFSET spacing
		call	WriteString

		;Sort into rows
		mov		eax, num_composites
		mov		ebx, 10
		cdq
		div		ebx
		cmp		edx, 0
		jne		Increment_Test_Num

		call	CrLf


	Increment_Test_Num:												;Outside Loop
		mov		eax, test_nums
		add		eax, 1
		mov		test_nums, eax

		mov		divisor, 1
		mov		divisible_count, 0

		mov		eax, num_composites
		cmp		eax, user_num
		jl		Divide						;Enters back into inside loop if number of composites is less than user_num


	Exit_loop:

	ret
ShowComposites ENDP


Farewell PROC
	call	CrLf
	mov		edx, OFFSET closing
	call	WriteString
	call	CrLf

	ret
Farewell ENDP
	

END main
