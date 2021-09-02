format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
	call	read_hex
	call	print_eax_binary
	
	xor		edx, edx	; The register where the rotated number will be stored
	mov		ecx, 32d	; We want to rotate all 32 bits
bit_loop:
	xor		ebx, ebx	; Value of carry flag
	shr		eax, 1		; Emulate rotation by shifting and check the curry flag
	jnc		zero		; If the extracted bit was 0
	
	mov		ebx, 1b		; If the extracted bit was 0
zero:
	or		edx, ebx	; By perforing or we make sure that keep the previous bits
						; intact and also put the next bit correct (by masking)
	shl		edx, 1		; Shift its bit left so, eventualy, the firt bit become last
						; and effectively emulate rotation
	
	loop	bit_loop
	
	mov		eax, edx
	call	print_eax_binary
	push 	0
	call	[ExitProcess]
	
include 'training.inc'