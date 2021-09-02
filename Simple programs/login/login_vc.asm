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
    format_str    db    '%s'

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
  push      admin_password  ; Address of target string
  push      format_str      ; Format
  call      [scanf]
  add       esp, 0x4 * 0x2  ; Free memory of scanf

  ; Ask for user password
  push     prompt           ; Address of string
  call     [printf]
  add      esp, 0x4         ; Free memory of printf

  ; Read user password
  push     user_password    ; Address of target string
  push     format_str       ; Format
  call     [scanf]
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

section '.idata' import data readable

library kernel32, 'kernel32.dll',\
        msvcrt, 'msvcrt.dll'

import  kernel32,\
        ExitProcess, 'ExitProcess'

import  msvcrt,\
        printf, 'printf',\
        scanf, 'scanf',\
        strcmp, 'strcmp'
