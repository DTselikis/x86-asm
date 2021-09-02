format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
	call	read_hex
	mov		ebx, eax
	
	xor		eax, eax
	cdq
	
	mov		ah, bh
	mov		cl, al
	mul		ecx
	
	mov		edx, eax
	
	mov		ecx, 65536
	mov		eax, ebx
	mov		ebx, edx
	cdq
	div		ecx
	
	mov		edx, eax
	xor		eax, eax
	xor		ecx, ecx
	mov		ah, dh
	mov		cl, dl
	mul		ecx
	
	add		eax, ebx
	
	call	print_eax
	
	push 0
	call [ExitProcess]

include 'training.inc'