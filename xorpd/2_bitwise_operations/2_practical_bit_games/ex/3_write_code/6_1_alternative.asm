format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
	call	read_hex
	
	xor		ebx, ebx
	mov		ecx, 32d
bit_loop:
	shr		eax, 1
	jnc		next_loop	; Ckech to see if the rotated bit was 1
	inc		ebx
next_loop:
	cmp		ebx, 2
	jae		exit
	loop	bit_loop
	
exit:
	mov		eax, ebx
	call	print_eax
	
	push	0
	call	[ExitProcess]
	
include 'training.inc'