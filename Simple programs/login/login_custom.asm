format PE console
entry start

include 'win32a.inc'

MAX_INPUT = 40

section '.data' data readable
    admin_user    db    'Please enter a username: ', 0x0
    admin_pass    db    'Please enter a password: ', 0x0
    prompt        db    'Please enter password to login: ', 0x0
    correct_pass  db    'Correct password. Welcome!', 0xd, 0xa, 0x0
    wrong_pass    db    'Incorrect password!', 0xd, 0xa, 0x0

section '.bss' readable writable
    input_handle   dd    ?
    output_handle  dd    ?

    bytes_read     dd    ?
    bytes_written  dd    ?
    admin_bytes    dd    ?

    admin_password db   MAX_INPUT dup (0)
    user_password  db   MAX_INPUT dup (0)

section '.text' readable executable
start:
  ; Get STDIN handle
  push      STD_INPUT_HANDLE   ; Constant
  call      [GetStdHandle]
  mov       dword [input_handle], eax  ; Store returned handle to memory

  ; Get STDOUT handle
  push      STD_OUTPUT_HANDLE  ; Constant
  call      [GetStdHandle]
  mov       dword [output_handle], eax ; Store returned handle to memory

  ; Ask for admin username
  push      admin_user        ; String address
  call      print_str
  add       esp, 0x4          ; Free memory of print_str

  ; Read admin username
  push      MAX_INPUT
  push      admin_password    ; Here works as a buffer because it will be
                              ; overwritten
  call      read_str
  add       esp, 0x4 * 0x2    ; Free memory of read_str

  ; Ask for admin password
  push      admin_pass
  call      print_str
  add       esp, 0x4          ; Free memory of print_str

  ; Read admin password
  push      MAX_INPUT
  push      admin_password
  call      read_str
  add       esp, 0x4 * 0x2    ; Free memory of read_str
  mov       ecx, eax          ; Save password size
  mov       dword [admin_bytes], eax ; Store password size

  ; Ask for user password
  push      prompt
  call      print_str
  add       esp, 0x4          ; Free memory of print_str

  ; Read user password
  push      MAX_INPUT
  push      user_password
  call      read_str
  add       esp, 0x4 * 0x2    ; Free memory of read_str

  ; Find password size to know the max iterations
  push      admin_pass        ; Address of password
  call      str_Size
  add       esp, 0x4          ; Free memory of str_Size

  ; Compare the two passwords (as strings)
  mov       esi, admin_password ; Address of admin password
  mov       edi, user_password  ; Address of user password
  mov       ecx, dword [admin_bytes] ; Load password's size
  repz      cmpsb           ; Compare byte per byte until max iterations reached
                            ; or a difference is found

  jnz       .not_equal      ; ZF = 1
  mov       eax, correct_pass
  jmp       .print_last
.not_equal:
  mov       eax, wrong_pass
.print_last:
  push      eax               ; Contains the address of certain string
  call      print_str
  add       esp, 0x4          ; Free memory of print_str

  push      0
  call      [ExitProcess]


; ================================================
; print_str (char* str)
;
; Input:
;   (stack) str: Base address of the string
; Output:
;   eax: Number of bytes that written
; Operation:
;   Prints a string to file specified by "output_handle" (console)
print_str:
  .string = 0x8         ; Offset of first argument inside the stack
  push      ebp         ; Save address of previous frame
  mov       ebp, esp

  push      dword [ebp + .string] ; Load string's address from stack
  call      str_Size
  add       esp, 0x4    ; Free memory of str_Size

  push      0                      ; lpPverlapped
  push      bytes_written          ; lpNumberOfBytesWritten
  push      eax                    ; nNumberOfBytesToWrite
  push      dword [ebp + .string]  ; lpBuffer
  push      dword [output_handle]  ; hFile
  call      [WriteFile]

  mov       eax, dword [bytes_written]

  leave     ; Restore ebp and esp
  ret

; ================================================
; read_str (char* buffer, unsigned int max_size)
;
; Input:
;   (stack) str: Base address of the string
;   (stack) max_size: Max buffer size
; Output:
;   eax: Number of bytes that read
; Operation:
;   Read a string from file specified by "input_handle" (console)
read_str:
  .buff  = 0x8          ; Offset of buffer's address inside the stack
  .max_size = 0xc       ; Offset of buffer's size inside the stack
  push      ebp         ; Save old frame
  mov       ebp, esp

  push      0                         ; lpPverlapper
  push      bytes_read                ; lpNumberOfBytesRead
  push      dword [ebp + .max_size]   ; nNumberOfBytesToRead
  push      dword [ebp + .buff]       ; lpBuffer
  push      dword [input_handle]      ; hFile
  call      [ReadFile]

  mov       eax, dword [bytes_read]
  lea       eax, [eax - 0x2]          ; Don't count '\n\r'

  leave     ; Restore ebp and esp
  ret

; ================================================
; str_Size (char* str)
;
; Input:
;   (stack) str: Base address string
; Output:
;   eax: String size (without '\0')
; Operation:
;   Loops through the array until '\0' is found
;   to determine the real size if the array
;
str_Size:
  .arr_addr = 0x8     ; Offset of first argument in the stack
  push    ebp         ; Save old frame
  mov     ebp, esp

  push    esi         ; Save esi

  mov     esi, dword [ebp + .arr_addr] ; Load string's address from the stack

  xor     eax, eax            ; Character counter
.null_loop:                   ; while (ch != '\0')
  cmp     byte [esi], 0x0     ; Load character
  jnz     .next_itter
  jmp     .exit
.next_itter:
  inc     esi                 ; Advance pointer (ch++)
  inc     eax                 ; Increase counter
  jmp     .null_loop          ; loop

.exit:
  pop     esi                 ; Restore esi

  leave  ; Restore ebp and esp
  ret

section '.idata' import data readable

library kernel32, 'kernel32.dll'

import  kernel32,\
        GetStdHandle, 'GetStdHandle',\
        ReadFile, 'ReadFile',\
        WriteFile, 'WriteFile',\
        ExitProcess, 'ExitProcess'
