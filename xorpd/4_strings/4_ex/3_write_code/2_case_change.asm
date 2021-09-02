format PE console
entry start

include 'win32a.inc'

MAX_INPUT = 40

section '.data' data readable
    prompt  db  "Please enter a phrase without spaces:", 0xd, 0xa, 0x0
    error   db  "Null terminator not found!", 0xd, 0xa, 0x0

section '.bss' readable writable
    buff    db  MAX_INPUT dup (?)

section '.text' code readable executable
start:
  mov    esi, prompt             ; Show prompt to user
  call   print_str
  mov    edi, buff               ; Max size of input
  mov    ecx, MAX_INPUT          ; Base address of input buffer
  call   read_line

  xor   eax, eax                 ; Search for '\0'
  mov   ecx, MAX_INPUT           ; Max iterations
  mov   edi, buff                ; Base address of buffer
  repnz scasb                    ; Search until '\0' found (ZF = 1) of max iterations reached

  jz    null_found
  mov   esi, error               ; Inform user that '\0' not found
  call  print_str
  jmp   exit

null_found:
  ; sub   edi, 0x2                 ; Subtrack 2 to go to the last usefull byte (except '\0')
                                   ; WRONG, it will give us one less iteration than we need (we count from 0)
  dec   edi                      ; Decrease one to go to '\0'
  mov   ecx, buff                ; Base address of buff
  sub   ecx, edi                 ; Base address - current address = number of bytes
  neg   ecx                      ; Smaller number - bigger number = negative number
  mov   esi, buff                ; Base address of buff
change_case:
  ; mov   bl, byte [esi]         WRONG, because ebx may contain garbage
  movzx ebx, byte [esi]          ; Load each character, from the beginning
  sub   ebx, 0x20                ; Difference between a small case character with his
                                 ; upper case corresponding is 0x30 (32d)
  cmp   ebx, 0x41                ; If the resulted number is less that 0x41 (which is ASCII for 'A')
                                 ; it means this character is an upper case
  jl    to_lower
  sub   byte [esi], 0x20         ; Otherwise it's an lower case and we subtract 0x20 to make it upper case
  jmp   next_itter
to_lower:
  add   byte [esi], 0x20         ; Add 0x20 to make the character lower case
next_itter:
  inc   esi                      ; Move to the next byte of memory (next character)
  loop  change_case

  mov   esi, buff                ; Base address of buff
  call  print_str
exit:
  push  0
  call  [ExitProcess]

include 'training.inc'
