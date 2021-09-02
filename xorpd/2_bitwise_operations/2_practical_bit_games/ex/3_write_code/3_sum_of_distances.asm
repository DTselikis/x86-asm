format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
	call	read_hex
	mov		edx, eax	; Store the input
	xor		ebx, ebx	; Zero the sum
	xor		edi, edi	; Zero the current checking bit position (start from leftmost bit)
number_loop:			; Pass through the entire number
	and		eax, 1		; Check if the bit we are looking at is 1
	jz		next_number_loop
	
	mov		eax, edx	; Restore the value because it has the result of previous and
	mov		ecx, 1		; The least distance is 1 (the exact next bit)
bit_loop:				; Scan the rest number from the next position to find 1s
	shr		eax, 1		; Shift the number by 1 to go to the next bit (we don't want to check the current bit)
	mov		esi, eax	; Store the number
	and		eax, 1		; Check if the bit is 1
	jz		next_bit_loop
	
	;call	print_eax	
	;sub	eax, edi
	;cmp	eax, 0
	;jge	positive
	;neg	eax
positive:
	add		ebx, ecx	; If it is, then add the distance

next_bit_loop:
	mov		eax, esi	; Restore the number to perform next loop
	inc		ecx			; Increase the distance
	cmp		ecx, 31		; Check if we reached the last bit (we start from position 1)
	jnz		bit_loop

next_number_loop:
	inc		edi			; Move to the next bit checking for leading 1s
	shr		edx, 1		; Bring that bit to the start of the register
	mov		eax, edx	; Move the number to eax to perform next loop
	jnz		number_loop
	
						; We have reached at the end of the number's bits
	mov		eax, ebx
	call	print_eax
	
	push	0
	call	[ExitProcess]
	
include 'training.inc'