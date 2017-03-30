TITLE Random Integers   (Program 5.asm)

; Author: Dennis
; Course / Project ID : Program #5               Date: 2/19/2017
; Description: This program displays random numbers and then sorts and finds the median based
;on the user input of numbers

INCLUDE Irvine32.inc

; (insert constant definitions here)
Min = 10
Max = 200
Lo = 100
Hi = 999


.data

opening		BYTE	"Sorting random integers by Dennis Li",0
greeting	BYTE	"This program generates random numbers in range of [100, 999], displays the",0
greeting2	BYTE	"original list, sorted list, and median value ",0


ask_num				BYTE	"How many numbers should be generated [10, 200]: ",0
invalid_number		BYTE	"This number is not in the range of [10, 200]: ",0
user_num			DWORD	?
			
array		DWORD		200		DUP(?)
unsorted	BYTE		"Unsorted List: ",0
sorted		BYTE		"Sorted List: ",0
space		BYTE		"	",0

median		BYTE		"Median Number: ",0




closing		BYTE	"Results certified by Dennis Li. Good Bye ",0



.code

;Main procedure displays a user determined number of random integers and then sorts and find
;Median
main PROC
	call	Introduction

	push	OFFSET user_num
	call	GetData
	mov		eax, user_num
	call	WriteInt
	call	Crlf
	
	

	push	user_num
	push	OFFSET array
	call	FillArray


	push	user_num
	push	OFFSET array
	push	OFFSET unsorted
	call	PrintArray


	push	user_num
	push	OFFSET array
	call	SortArray

	call	CrLf
	push	user_num
	push	OFFSET array
	call	DisplayMedian

	call	CrLf

	push	user_num
	push	OFFSET array
	push	OFFSET sorted
	call	PrintArray

	exit
main ENDP

; (insert additional procedures here)

;Introduction greets the user and displays them information about the program
Introduction PROC
	mov		edx, OFFSET opening
	call	WriteString
	call	CrLf
	mov		edx, OFFSET greeting
	call	WriteString
	call	CrLf
	mov		edx, OFFSET greeting2
	call	WriteString
	call	CrLf
	ret
Introduction ENDP

;Get data retrieves an integer from the user for the number of random integers
GetData PROC
	push	ebp
	mov		ebp, esp
	mov		ebx, [ebp+8] ;address of user_num into ebx


	mov		edx, OFFSET ask_num
	call	Writestring
	jmp		input_num
	
	ask_new_num:
		mov		edx, OFFSET invalid_number
		call	WriteString
	
	input_num:
		call	Readint
		cmp		eax, Min
		jl		ask_new_num
		cmp		eax, Max
		jg		ask_new_num
		mov		user_num, eax

		mov		[ebx], eax  ;Put eax into the address at ebx

		pop		ebp ;restore stack
	ret		4
GetData ENDP

;Fill array fills the array with a certain number of random integers
FillArray PROC
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp+8]  ;array
	mov		ecx, [ebp+12]  ;count


	call	randomize
	random_num:
		mov		eax, hi    
		sub		eax, lo  ;subtracts high and low for range
		inc		eax
		call	RandomRange  
		add		eax, lo   ;adds back so it stays within the range of 100-999

		mov		[edi], eax  ;To actually access to individual arary spots and not just address, you must do brackets
		add		edi, 4
		loop	random_num
	
	pop		ebp
	ret		8

FillArray ENDP

;Print array: displays array, it may be either sorted or unsorted
PrintArray PROC
	push	ebp    
	mov		ebp, esp
	mov		ecx, [ebp+16]  ;count
	mov		edi, [ebp+12]  ;array
	mov		edx, [ebp+8]  ;sorted vs unsorted
	
	call	WriteString
	call	CrLf
	print_unsorted:
		mov		eax, [edi]      ;print number at edi
		call	WriteDec
		mov		edx, OFFSET space
		call	WriteString

		add		edi, 4       ;increment edit by 4
		loop	print_unsorted
	
	pop		ebp
	ret		12
PrintArray ENDP

;Sort array sorts the array of random integers from highest to lowest using selection sort
SortArray PROC
	push	ebp    
	mov		ebp, esp
	mov		ecx, [ebp+12]  ;count
	dec		ecx

	outer_loop:
		push	ecx
		mov		edi, [ebp+8]  ;array
	inner_loop:
		mov		eax, [edi]				;temporary largest
		cmp		[edi + 4], eax
		jg		Larger				;If it is larger,it will switch
		jmp		end_inner						;If it is smaller, it increments then goes to next number
	Larger:							;Switch

		mov		eax, [edi]			;moving beginning value to eax then save by popping
		push	eax 
		mov		eax, [edi +4]		;switching largest, to sorted
		mov		[edi], eax
		pop		eax					;pop back eax to move beginning value to unsorted
		mov		[edi+4], eax
			
	end_inner:	
		add		edi, 4	
		loop	inner_loop
		pop		ecx
		loop	outer_loop
		pop		ebp
			

	ret		8
SortArray ENDP

;Display median finds the median of the array and displays it
DisplayMedian	PROC
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp+8]  ;array
	mov		eax, [ebp+12]  ;count	
	


	mov		ebx, 2
	cdq
	div		ebx
	cmp		edx, 0
	je		_even    ;Jumps to even (average)

	_odd:
	mov		edx, OFFSET median 
	call	WriteString
	mov		ebx, 4
	mul		ebx
	mov		eax, [edi+eax]
	call	WriteDec
	jmp		end_median

	_even:
	mov		edx, OFFSET median    ;Even number must average of two numbers, then rounded
	call	WriteString
	mov		ebx, 4
	mul		ebx
	mov		ebx, [edi+eax]	
	sub		eax, 4
	mov		eax, [edi+eax]
	add		eax, ebx
	mov		ebx,2
	cdq
	div		ebx
	cmp		edx, 0
	je		round
	add		eax, 1
	round:
	call	WriteDec 


	end_median:
		pop ebp
		ret 8
DisplayMedian ENDP

;Farewell displays good bye to the user
Farewell PROC
	call	CrLf
	mov		edx, OFFSET closing
	call	WriteString
	call	CrLf

	ret
Farewell ENDP
	

END main
