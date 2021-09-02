; Input: 00000001 (1b)
; ebx =  00000001
; input: 00000010

;        00000001
; XOR    00000010
;        00000011
; ebx =  00000011

; input: 00000001

; XOR	 00000011
; ebx =  00000010
; AND		    1
; ebx =  00000000
; out =  0

format PE console
entry start

include 'win32a.inc'

section '.text' code readable executable

start:
	call	read_hex
	mov		ebx, eax
	call	read_hex
	xor		ebx, eax
	call	read_hex
	xor		ebx, eax
	
	and		ebx, 1
	mov		eax, ebx
	call	print_eax
	
	push	0
	call	[ExitProcess]
	
include 'training.inc'