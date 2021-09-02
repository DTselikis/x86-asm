format PE console
entry start

include 'win32a.inc'

MAX_INPUT = 40

section '.data' data readable
    admin_user    db    'Please enter a username: ', 0x0
    admin_pass    db    'Please enter a password: ', 0x0
    prompt        db    'Please enter password to login: ', 0x0
    correct_pass  db    'Correct password. Welcome %s!', 0xd, 0xa, 0x0
    wrong_pass    db    'Incorrect password!', 0xd, 0xa, 0x0
    format_str    db    '%s', 0x0
    new_line      db     0xd, 0xa, 0x0

section '.bss' readable writable
    admin_password db   MAX_INPUT dup (0)
    admin_name     db   MAX_INPUT dup (0)
    user_password  db   MAX_INPUT dup (0)

section '.text' code readable writable
start:
  ; Ask for admin username
  push       admin_user     ; Address of string
  call       [printf]
  add        esp, 0x4       ; Free memory of printf

  ; Read admin username
  push      admin_name      ; Address of targer string
  push      format_str      ; Format
  call      [scanf]
  add       esp, 0x4 * 0x2  ; Free memory of scanf

  ; Ask for admin pass
  push      admin_pass      ; Address of string
  call      [printf]
  add       esp, 0x4        ; Free memory of printf

  ; Read admin password
  push      MAX_INPUT
  push      admin_password
  call      mask_password
  add       esp, 0x4 * 0x2  ; Free memory of scanf

  ; Ask for user password
  push     prompt           ; Address of string
  call     [printf]
  add      esp, 0x4         ; Free memory of printf

  ; Read user password
  push      MAX_INPUT
  push      user_password
  call      mask_password
  add      esp, 0x4 * 0x2   ; Free memory of scanf

  ; Compare passwords
  push     user_password
  push     admin_password
  call     [strcmp]
  add      esp, 0x4 * 0x2   ; Free memory of strcmp

  test     eax, eax
  mov      ebx, 0x1        ; Argument counter

  jnz      .not_equal      ; If eax = 0 strings were equal, ZF = 1
  mov      eax, correct_pass
  push     admin_name      ; Second argument, only if password were correct
  inc      ebx             ; Increase argument counter
  jmp      .print_last
.not_equal:
  mov      eax, wrong_pass
.print_last:
  push     eax               ; Contains the address of certain string
  call     [printf]
  lea      esp, [ebx * 0x4]  ; Free memory of printf (1 or 2 arguments)

  push     0
  call     [ExitProcess]

; ================================================
; mask_password (char* buff, unsigned int max_size)
;
; Input:
;   (stack) buff: Base address of buffer
;   (stack) max_size: Max input size
; Output:
;  -
; Operation:
;   Reads from the console and prints '*' instead of
;   user's input
; Dependencies:
;   import  msvcrt,\
;   printf, 'printf',\
;   _getch, '_getch',\
;   _putch, '_putch',\
;   isalnum, 'isalnum'
;   data:
;   str_form  db    '%s', 0x0
;   new_line  db     0xd, 0xa, 0x0

mask_password:
  .buffer   = 0x8     ; Offset of first argument inside the stack
  .max_size = 0xc     ; Offset of second argument inside the stack

  push     ebp        ; Save the last frame
  mov      ebp, esp

  push     ebx        ; Save ebx

  mov      edi, dword [ebp + .buffer] ; Load buffer's address from the stack
  mov      ecx, dword [ebp + .max_size] ; Load max_size from the stack
.read_loop:   ; while (ch != '\n' || ch != '^C' || max_size > 0)
  call     [_getch]   ; Read user's input

  ; Check if input is '\n' or '^C'
  cmp      eax, 0xd     ; \n
  jz       .exit_read
  cmp      eax, 0x3     ; ^C
  jz       .exit_read

  mov      ebx, eax     ; Save eax

  ; Check if input is alphabetic
  push     eax
  call     [isalnum]
  add      esp, 0x4     ; Free memory of isalpha

  test     eax, eax     ; If eax != 0 then the input was alphabetic
  jz       .read_loop

  mov      eax, ebx     ; Restore eax
  stosb                 ; Store character in buffer and advance pointer

  push     '*'          ; Print '*' to the console
  call     [_putch]
  add      esp, 0x4     ; Free memory of _putch


  dec      ecx          ; Decrease max_size
  jnz      .read_loop
.exit_read:
  ; Prints and empty line
  push     new_line
  push     format_str
  call     [printf]
  add      esp, 0x4 * 0x2 ; Free memory of printf

  pop      ebx

  leave                 ; Restore ebp and esp
  ret

section '.idata' import data readable

library kernel32, 'kernel32.dll',\
        msvcrt, 'msvcrt.dll'

import  kernel32,\
        ExitProcess, 'ExitProcess'

import  msvcrt,\
        printf, 'printf',\
        scanf, 'scanf',\
        strcmp, 'strcmp',\
        _getch, '_getch',\
        _putch, '_putch',\
        isalnum, 'isalnum'
