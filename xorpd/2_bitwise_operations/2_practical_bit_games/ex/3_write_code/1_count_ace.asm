format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
	call	read_hex
	mov		edx, eax
	xor		ebx, ebx
	mov		ecx, 16d	; Because the register is 32 bit we need to rotate it 16 times
						; to check all the bits becasue its time we rotate by 2

nextbit:
	and		eax, 1
	add		ebx, eax
	ror		edx, 2
	mov		eax, edx
	loop	nextbit
	
	mov		eax, ebx
	call	print_eax
	
	push	0
	call 	[ExitProcess]

include 'training.inc'