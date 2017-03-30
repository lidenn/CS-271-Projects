TITLE Random Integers   (Program 6.asm)

; Author: Dennis
; Course / Project ID : Program #6A              Date: 3/19/2017
; Description: Program asks users for 10 unsigned integers and finds 
;the average and sum

INCLUDE Irvine32.inc

; (insert constant definitions here)
	ARRAY_SIZE = 10 
	
;-------------------------------------------------
;Macro: get String
;Description: Reads a string for a variable
;Parameter: name, length
;-------------------------------------------------
getString	MACRO	name, length
	push	ecx	
	push	edx
	mov		edx, name    ; Keep without OFFSET because we are passing addresses as name
	mov		ecx, length
	call	ReadString
	pop		edx
	pop		ecx
ENDM

;-------------------------------------------------
;Macro:display String
;Description: display a string for a variable
;Parameter: name
;-------------------------------------------------
displayString	MACRO	name
	push	edx
	mov		edx, name
	call	WriteString
	pop		edx
ENDM

.data

Title1			BYTE	"Programming Assignment 6: Designing low-level I/O procedures",0
Author1			BYTE	"By: Dennis Li",0
Introduction1	BYTE	"Please provide 10 unsigned decimal integers.",0
Introduction2	BYTE	"Each number needs to be small enough to fit inside a 32-bit register.",0
Introduction3	BYTE	"After you have finished inputting the raw numbers I will display a list",0
Introduction4	BYTE	"of the integers, their sum, and their average value.",0
Closing_prompt	BYTE	"Thanks for playing!",0

string_num	BYTE	255	DUP(?)   ;256-1
temp_num	DWORD	?			  ;convert string to int	
temp_string BYTE	255 DUP(?)    ;convert int to string
average		DWORD	?
sum			DWORD	?
num_array	DWORD	ARRAY_SIZE	DUP(?)


Enter_num	BYTE	"Enter Unsigned Number: ",0
Error_msg	BYTE	"ERROR: You did not enter a unsigned number or your number was too big",0


Display_nums_prompt		BYTE	"You have entered the following number: ",0
Sum_prompt				BYTE	"Sum of these numbers is: ",0
Average_prompt			BYTE	"Average is: ",0
Space	BYTE	", ",0


.code
main PROC
;Introduction
	push	OFFSET Title1			;ebp+28
	push	OFFSET author1			;ebp+24
	push	OFFSET introduction1	;ebp+20
	push	OFFSET introduction2	;ebp+16
	push	OFFSET introduction3	;ebp+12
	push	OFFSET introduction4	;ebp+8	
	call	Introduction

;Get 10 nums
	mov		edi, OFFSET num_array
	mov		ecx, ARRAY_SIZE
	Get_ten_num:
		push	OFFSET error_msg	;ebp+24
		push	OFFSET Enter_num	;ebp+20
		push	OFFSET temp_num		;ebp+16
		push	OFFSET string_num  ;ebp+12
		push	SIZEOF string_num	;ebp+8
		call	ReadVal

		mov		eax, temp_num
		mov		[edi], eax
		add		edi, 4

		loop	Get_ten_num

	
;Calculate Average
	push	OFFSET sum			;ebp + 20	
	push	OFFSET average			;ebp + 16
	push	OFFSET num_array		;ebp+12
	push	ARRAY_SIZE				;ebp+8
	call	CalculateData


;Display Values using WriteVal
	mov		ecx, ARRAY_SIZE
	mov		esi, OFFSET num_array
	displayString	OFFSET Display_nums_prompt
	Display_ten:
		mov		eax, [esi]
		push	eax			; int in ebp+12
		push	OFFSET temp_string  ;ebp+8
		call	WriteVal
		add		esi, 4

		mov		eax, ecx		;Removes extra comma
		cmp		eax, 1
		je		skip_comma
		displayString	OFFSET space

		skip_comma:
		loop	Display_ten	
		call	CrLf

;Display Sum
	displayString	OFFSET sum_prompt
	push	sum
	push	OFFSET	temp_string
	call	WriteVal
	call	CrLF

;Display Average
	displayString	OFFSET average_prompt
	push	Average
	push	OFFSET	temp_string
	call	WriteVal
	call	CrLf

;closing
	push	OFFSET closing_prompt
	call	ClosingWords 

	exit
main ENDP


;-------------------------------------------------
;Macro:Introduction
;Description: Displays introduction and description
;Parameter: OFFSET author1, OFFSET title1, 
;OFFSET introduction1, OFFSET introduction2
;OFFSET introduction3, OFFSET introduction4
;-------------------------------------------------
; (insert additional procedures here)
Introduction PROC
	push ebp
	mov ebp, esp
	displayString [ebp+28]
	call	CrLF
	displayString [ebp+24]
	call	CrLF
	call	CrLf
	displayString [ebp+20]
	call	CrLF
	displayString [ebp+16]
	call	CrLF
	displayString [ebp+12]
	call	CrLF
	displayString [ebp+8]
	call	CrLF

	pop ebp
	ret 24
Introduction ENDP	

;-------------------------------------------------
;Procedure: ReadVal
;Description: Uses the getstring macro to get user's
;10 numbers as string, then converts to numbers
;Parameters: OFFSET error_msg, OFFSET Enter_num,
;OFFSET temp_num, OFFSET string_num  SIZEOF string_num
;-------------------------------------------------
ReadVal	PROC
	push ebp
	mov	ebp, esp
	pushad        ;push ecx, loop counter

	Start:

		mov		edx, [ebp+12]
		mov		ecx, [ebp+8]

		displayString	[ebp+20]	;display enter number
		getString	edx, ecx	;inputs string to edx, size ecx
		mov		esi, edx	;moves in order to lodsb
		mov		eax, 0		
		mov		ebx, 10
	

	Load:
		cld
		lodsb		;loads memory from the esi
		cmp		ax, 0	;signals end
		je		End_label

		cmp		ax, 48
		jb		Error
		cmp		ax, 57
		ja		Error
		jmp		load			; jumps to load to check for all of the characters
	Error:
		displaystring	[ebp+24]
		call			CrLF
		jmp				Start
	
 
	End_label:
		call	ParseDecimal32
		jc		Error				;This checks if it is in range of 32-bit
		mov		ecx, [ebp+16]  ;[EBP + 16 provides the address]
		mov		[ecx], eax     ;using [ecx] will access the inside 

	popad
	pop ebp
	ret 20

ReadVal	ENDP
;-------------------------------------------------
;Procedure: Calculate Data
;Description: Calculates the sum and average of array
;of numbers
;Parameters: OFFSET sum, OFFSET Average
;OFFSET num_array, ARRAY_SIZE
;-------------------------------------------------
CalculateData PROC
	push	ebp
	mov		ebp, esp

	mov		edi, [ebp+12]
	mov		ecx, [ebp+8]

	mov		eax, 0
	
	sum_nums:
		add		eax, [edi]
		add		edi, 4
		loop	sum_nums		; loop adding number to eax
		mov		edx, [ebp+20]
		mov		[edx], eax     ;mov eax to sum

	;Calculate Average
		;cdq
		mov		edx, 0
		mov		ebx, [ebp+8]
		div		ebx
		mov		edx, [ebp+16]
		mov		[edx] ,eax
	pop ebp
	ret 16
CalculateData ENDP

;-------------------------------------------------
;Procedure: WriteVal
;Description: Converts number to string and prints it
;Parameters: OFFSET number, OFFSET tempstring
;-------------------------------------------------
WriteVal PROC
	push	ebp
	mov		ebp, esp
	pushad

	mov		eax, [ebp +12]
	mov		edi, [ebp+8]
	push	0			;Signals end of digits	

	Convert:
		mov		edx, 0		;replaces cdq in order to take in the 2^32
		mov		ebx, 10
		div		ebx
		add		edx, 48
		push	edx       ;save ascii value
		cmp		eax, 0
		jne		Convert		;push 0 before to signal ending
		
	PopDigits:
		pop		[edi]    ;pops ascii one at a time into edi
		mov		eax, [edi]
		inc		edi			;Increment
		cmp		eax, 0
		jne		PopDigits

		mov		edx, [ebp+8]	;edx saved in temp num
		displayString	edx	  ;displays edx
	
	popad
	pop		ebp
	ret		8
WriteVal	ENDP

ClosingWords PROC
	push	ebp
	mov		ebp, esp
	call	CrLf
	displayString	[ebp+8]
	call	CrLf

	pop		ebp
	ret		4
ClosingWords ENDP
END main
