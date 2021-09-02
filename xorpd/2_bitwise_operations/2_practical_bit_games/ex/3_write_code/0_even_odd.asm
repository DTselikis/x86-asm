format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
	call	read_hex
	and		eax, 1		; If 1st is 1 then the number is odd
	call	print_eax
	
	push	0
	call	[ExitProcess]
	
include 'training.inc'