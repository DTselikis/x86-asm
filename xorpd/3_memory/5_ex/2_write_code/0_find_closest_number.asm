format PE console
entry start

include 'win32a.inc'

section '.data' data readable writeable
	nums		dd		23h, 75h, 111h, 0abch, 443h, 1000h, 5h, 2213h, 433a34h, 0deadbeafh ; Array of numbers
	end_nums:	; Ending address of the array
	
section '.text' code readable executable

start:
	call	read_hex
	mov		ebx, eax		; Store input
	
	mov		esi, 0x7fffffff	; Have the greatest positive 16-bit number as distance
	xor		edi, edi		; Element's offset inside the array
	mov		ecx, (end_nums - nums) / 4	; Number of elements inside the array (counter)
find_closest:							; Loop through the array
	mov		eax, dword [nums + 4*edi]	; Load nth number from the array
	sub		eax, ebx					; Distance between inputed number and nth array number
	
	cmp		esi, eax					; Check if this distance is less than previous
	jbe		next_loop					; If it is that means that nth number is closer to inputed number
	mov		esi, eax					; so we save this distance as the current lowest
	mov		edx, edi					; and also save the offset of nth array element
next_loop:								; This distance was not less than previous
	inc		edi							; Increase the array offset
	dec		ecx							; Counter
	jnz		find_closest
	
; At this point we have looped through the entire array and have determined the closest
; number and also saved its offset

	mov		eax, dword [nums + 4*edx]	; Load the number which had the least distance (with the use of offset)
	call	print_eax
	
	push	0
	call	[ExitProcess]
	
include 'training.inc'