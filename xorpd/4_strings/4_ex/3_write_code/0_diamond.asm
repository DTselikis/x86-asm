format PE console
entry start

include 'win32a.inc'

section '.data' data readable
    prompt    db    "Please enter a number: ", 0xd, 0xa, 0x0
    newline   db    0xd, 0xa, 0x0

section '.bss' readable writeable
    buff      db    44  dup (?)
    input     db    0x1
    flag      db    0x1 dup (0)

section '.text' code readable executable
start:
  mov    esi, prompt
  call   print_str
  call   read_hex

  test   eax, 0x0           ; Check if user input was 0
  jnz    exit

  mov    ecx, eax           ; Number of lines = input * 2 + 1 = number of max '*'
  shl    ecx, 1
  inc    ecx

  mov    eax, ecx
  mov    byte [input], al   ; Save max lines
print_diamond:
  push   ecx                ; Store at which line we are

  mov    ebx, 0x2           ; divide by 2 to find how many spaces we need to have in each side
  xor    edx, edx
  div    ebx
  mov    ebx, eax           ; Save for later use

  mov    ecx, eax           ; Use ecx fot loop counter
  mov    edi, buff          ; base address of our buffer
  jecxz  print_star         ; Check if we need to print spaces
  mov    eax, ' '           ; Space character (ASCII code), 1 byte
  ; mov    edi, buff
  rep    stosb              ; Store ecx times the byte from eax to memory pointed by edi

print_star:
  mov    eax, '*'           ; ASCII of '*'
  movzx  esi, byte [input]  ; Load maximum stars
  lea    ecx, [ebx * 2]     ; Calculate total spaces for this line
  sub    ecx, esi           ; and subtract them to find the number of '*' for this line
  neg    ecx                ; The subtraction will always give a negative number
  rep    stosb              ; Store '*'

  mov    ecx, ebx           ; Counter for spaces
  jecxz  line_terminate     ; Check if we need spaces
  mov    eax, ' '           ; ASCII of ' '
  rep    stosb              ; Store spaces to the other side

line_terminate:
  mov    byte [edi], 0x0    ; Store line terminator (C style) to the end of constracted string
  mov    esi, buff          ; Base address of our buffer
  call   print_str          ; Print until '\0'
  mov    esi, newline       ; Address of newline which containes the ASCIIs for a new line
  call   print_str

  pop    ecx                ; Restore the current line
  mov    dl, byte [flag]    ; Check if we reached max stars so we need to reverse
  cmp    dl, 0x0
  jz     no_inc
  shl    ebx, 2             ; In reverse we increase the spaces
no_inc:
  mov    eax, ebx           ; Save the number of spaces of the previous line
  cmp    eax, 0x0           ; If we reached max stars, start the reverse order
  jnz    next_itteration
  ;movzx  eax, byte [input]
  ;dec    eax
  mov    eax, 0x2           ; The first time we need 2 spaces in total
  inc    byte [flag]        ; Raise the flag of reverse order
next_itteration:
  loop   print_diamond

exit:
  push   0
  call   [ExitProcess]

include 'training.inc'
