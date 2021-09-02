format PE console
entry start

include 'win32a.inc'

section '.bss' readable writable
	nums	dd	100	dup (?)	; Tell the OS to allocate memory for 100 double words (100 * 4 bytes)
	
section '.text' code readable executable

start:
	call	read_hex
	mov		ebx, eax		; Store the inputed number
	
	mov		ecx, eax		; Loop condition
	xor		edi, edi		; Memory offset
reading_loop:
	call	read_hex
	mov		dword [nums + (4 * edi)], eax	; Store into memory
	
	inc		edi				; Increase offset to go to the next memomy block (block ?)
	loop	reading_loop
	
	xor		edi, edi		; Memory offset
	xor		esi, esi		; Sum
summing_loop:
	; n*a_1 + (n-1)*a_2 + ... + 1*a_n
	mov		eax, dword [nums + (4 * edi)]	; Load number from memomy
	cdq
	mul		ebx
	
	add		esi, eax
	
	inc		edi				; Increase offset to go to the next memomy block (block ?)
	dec		ebx
	jnz		summing_loop
	
	mov		eax, esi
	call	print_eax
	
	push	0
	call	[ExitProcess]
	
include 'training.inc'