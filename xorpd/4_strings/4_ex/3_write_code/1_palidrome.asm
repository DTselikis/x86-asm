format PE console
entry start

include 'win32a.inc'

MAX_INPUT = 40

section '.data' data readable
    prompt  db    'Enter a phrase:', 0xd, 0xa, 0x0
    phrase  db    'The phrase: ', 0x0
    isn_pal db    ' is not palidrome.', 0xd, 0xa, 0x0
    is_pal  db    ' is palidrome.', 0xd, 0xa, 0x0
    error   db    'Null terminator not found!', 0xd, 0xa, 0x0

section '.bss' readable writable
    input   db    MAX_INPUT  dup (?)
    buff    db    MAX_INPUT / 2  dup (?)  ; Half of MAX_INPUT because it will
                                          ; store only the first half of the input

section '.text' code readable writable
start:
  mov   esi, prompt           ; Print user prompt
  call  print_str
  mov   edi, input            ; Base address of memory which will store user's input
  mov   ecx, MAX_INPUT        ; Max length of input
  call  read_line

  xor   eax, eax              ; Search for '\0'
  mov   ecx, MAX_INPUT        ; Limit research at the length of the memory
  mov   edi, input            ; Base address of user's input
  repnz scasb                 ; Loop through the memory until find '\0' (ZF = 1) or reach the end of the memory

  jz    null_found            ; If null is found
  mov   esi, error            ; Print error message
  call  print_str
  jmp   exit

null_found:
  ; dec   esi                   ; Move to the previous location in memory because "scasb" increase esi even at last interraton
                                ; WRONG, the esi would point to the location AFTER '\0' so we need to subtract 2 to point to the
                                ; actual end of the string

  sub   edi, 0x2              ; Point to the last byte of the string (without '\0')

  mov   ebx, edi              ; Save the last address of our memory (without '\0')
  sub   edi, input            ; Last address - base address = number of bytes
  ; neg   edi                   ; Because memory increases the memory will always be negative
                                ; WRONG, input is subtracted FROM edi

  mov   ecx, edi              ; Number of itterations (actual bytes of input)
  mov   edx, edi              ; Save it for later use
  mov   esi, input            ; Base address of user's input
  mov   edi, buff             ; Base address of buffer
  rep   movsb                 ; Copy from user input to buffer the first ecx bytes (the first half of the input)
                              ; Will stop when ecx = 0

  mov   ecx, edx              ; Number of iterations (half the numbe of stored bytes)
  mov   esi, ebx              ; Last address of user's input ('\0')
  ;; dec   esi                   ; Last address of user's input (without '\0')
                                 ; WRONG, don't know why it's here
  ; lea   edi, [buff + ecx]     ; Go the last used byte of the buffer
  mov   edi, buff
cmp_loop:                     ; Compare the first and second half of the inputed string
  movzx eax, byte [esi]       ; esi is used for the first half
  movzx ebx, byte [edi]       ; edi is used for the second half
  cmp   eax, ebx
  jnz   not_equal             ; We found at least one mismatch so no need to search further
  dec   esi                   ; esi's located at the end of the first half so we go backwards
  inc   edi                   ; edi's located at the beginning of the second half so go forward
  loop  cmp_loop

  ; ================================================
  ; EXAMPLE
  ; input: 1234k4321      1234k4321
  ;           ^ ^           ^   ^
  ;           | |           |   |
  ;        esi edi         esi edi
  ;
  ; input: 1234k4321      1234k4321
  ;         ^     ^       ^       ^
  ;         |     |       |       |
  ;        esi  edi      esi     edi
  ; ================================================
  ; std
  ; mov   ecx, edx
  ; mov   esi, input
  ; mov   edi, buff
  ; repz  cmpsb
  mov   eax, is_pal          ; Is palidrome message
  jmp   print_result
not_equal:
  mov   eax, isn_pal         ; Isn't palidrome message
print_result:
  mov   esi, phrase          ; "The phrase: "
  call  print_str
  mov   esi, input           ; "<user input>"
  call  print_str
  mov   esi, eax             ; "is\n't pallidrome"
  call  print_str

exit:
  push  0
  call  [ExitProcess]

include 'training.inc'
