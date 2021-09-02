format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
	call	read_hex
	mov		edx, eax	; Store the value
	
	xor		ebx, ebx	; Zero counter
	mov		ecx, 32d	; Number of loops
bit_loop:
	and		eax, 1		; Check if current bit is 1
	jz		next_loop
	inc		ebx			; If it is, increase the counter
next_loop:
	cmp		ebx, 2		; If we found at least 2 1s, the number isn't in power of two
	jae		exit
	shr		edx, 1		; Take the next bit
	mov		eax, edx
	loop	bit_loop
	
exit:
	mov		eax, ebx
	call	print_eax
	
	push	0
	call	[ExitProcess]
	
include 'training.inc'