; Basic Assembly
; ==============
;
; Subroutines and the stack - Calling conventions
; -----------------------------------------------
;
; Scalar product
; @@@@@@@@@@@@@@
;
; 0.    Skim the code. Take a look at the functions and their descriptions.
;       Understand the dependencies between the functions (Which function calls
;       which function), and what is the special purpose of every function.
;
; 1.    Read the main code (Beginning from start), and see how the function
;       scalar_product is being called. Which calling convention is being used?
;
; 2.    Fill in the scalar_product function. This function calculates the scalar
;       product (Sometimes referred to as inner product) between two vectors.
;       See exact formula in the comments below.
;
;       Note that you may only fill in the scalar_product function. Do not
;       change the rest of the code.
;
;       Make sure that you deal with arguments and the stack according to the
;       correct calling convention. Think about the following:
;       - Who should clean the stack?
;       - Where should the return value be?
;       - Saving registers to the stack, so that your function will not have
;         side effects.
;
; 3.    Assemble and run the code. Verify the result that you get.
;
;       Just to be sure, check the value of esp before and after
;       the call to scalar_product, to verify that the stack is balanced.
;

format PE console
entry start

include 'win32a.inc'

struct VEC
    x   dd  ?
    y   dd  ?
ends

; ===============================================
section '.data' data readable writeable
    vec1            VEC     5,-4
    vec2            VEC     0c3h,-45h
    scalar_result   db  'Scalar product result: ',0
; ===============================================
section '.text' code readable executable

start:
    ; Invoke scalar product of vec1 and vec2:
    push    vec1
    push    vec2
    call    scalar_product

    ; Print result to the console:
    mov     esi,scalar_result
    call    print_str
    call    print_eax

    ; Exit the process:
	push	0
	call	[ExitProcess]


; =================================================
; scalar_product(v1,v2)
;
; Input:
;   v1,v2 vectors.
; Output:
;   (v1.x * v2.x) + (v1.y * v2.y)
; Calling Covention:
;   ? STD
;

; **** Fill in this function ****
scalar_product:
  push   ebx                          ; +4 bytes to stack
  push   ecx                          ; +4 bytes to stack

  mov    eax, dword [esp + 16]        ; Place of v1 address
  mov    ebx, dword [esp + 12]        ; Place of v2 address

  mov    eax, dword [eax]             ; Load v1.x

  mul    dword [ebx]                  ; Multiply with v2.x

  mov    ecx, eax

  mov    eax, dword [esp + 16]       ; Place of v1 address
  mov    eax, dword [eax + VEC.y]    ; Load v1.y

  mul    dword [ebx + VEC.y]         ; Multiply with v2.y

  add    ecx, eax
  add    eax, ecx

  pop    ecx
  pop    ebx

  ret   8


include 'training.inc'
