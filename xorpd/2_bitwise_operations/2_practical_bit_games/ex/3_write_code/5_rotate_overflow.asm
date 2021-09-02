format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
	call	read_hex
	call	print_eax_binary
	
	;ror		eax, 54d
	
	;mov		ebx, eax
	;rol   		bx,19d
	;mov		eax, ebx
	
	;mov		edx, eax
	;ror		dh,10d
	;mov		eax, edx
	
	;mov		edx, eax
	;mov		cl,0feh
    ;ror		edx,cl
	;mov		eax, edx
	
	ror   eax,1001d
	
	call	print_eax_binary
	
	push	0
	call	[ExitProcess]
	
include 'training.inc'