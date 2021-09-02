format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
	call	read_hex
	call	print_eax_binary
	
	; Invert the first 16 bits
	mov		bh, ah
	mov		ah, al
	mov		al, bh
	
	; Rotate right 16 times so the
	; first 16 bits become the last 16
	ror		eax, 16
	
	; Invert the last 16 bits which now
	; are the first 16 bits
	mov		bh, ah
	mov		ah, al
	mov		al, bh
	
	call	print_eax_binary
	
	push	0
	call	[ExitProcess]
	
include 'training.inc'