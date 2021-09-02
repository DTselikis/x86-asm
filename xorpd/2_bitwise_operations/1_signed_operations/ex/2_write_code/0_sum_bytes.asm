format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
	call	read_hex
	movzx	ebx, ah		; ah contains the 2nd bit
	movzx	edx, al		; al contains the 1st bit
	add		ebx, edx
	mov		ecx, 65536	; divide by 2^16 (4 bytes) to take the 4 rightmost
	xor		edx, edx	
	div		ecx
	movzx	edx, ah		; Now ah contains 4th bit
	add		ebx, edx
	movzx	edx, al		; Now al contains 3rd bit
	add		ebx, edx
	mov		eax, ebx
	call	print_eax
	
	push 0
	call [ExitProcess]
	
include 'training.inc'