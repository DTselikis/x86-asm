format PE console
entry start

include 'win32a.inc'

BUFF_SIZE = 8  + (2 * 4) + 1
; 8 = 1 dword
; 4 lines * 2 bytes (0xd, 0xa) for new line
; 1 for 0x0 '\0'

; =====================================================================
; We check the value of each byte and then we add it as an offset
; to find it's place in memory.
; If byte is 0x0, then the offset is 0x0 so '*' will be loaded
; =====================================================================

section '.data' data readable
    prompt:   db    'Enter a number in hex: ', 0x0
    char_arr: db    '*', ':', '#', '@'

section '.bss' readable writeable
    buff      db   BUFF_SIZE  dup (?)

section '.text' code readable executable
start:
  mov     esi, prompt
  call    print_str
  call    read_hex

  call    toPic

  mov     esi, buff
  call    print_str

  push    0
  call    [ExitProcess]

include 'training.inc'
; ==========================
; Input:
;   eax: dword to be made in ASCII
; Output:
;   -
; Fill the buff memory with the corresponding string
toPic:
  mov     edi, buff           ; Base memory of buff
  mov     ecx, 16d            ; 16 iterations (each time we check 2 bits)
  xor     edx, edx            ; Counter for line separator
  rol     eax, 0x2            ; Start from msb
  mov     ebx, eax            ; Save eax
.buff_loop:
  cmp     edx, 0x4            ; We want 4 characters in each line
  jnz     .same_line
  mov     word [edi], 0x0d0a  ; New line
  add     edi, 0x2            ; Move 2 bytes forward because we fill them above
  xor     edx, edx            ; Zero the counter
.same_line:
  and     eax, 11b            ; Chech 2 most right bits
  call    toAscii
  mov     byte [edi], al      ; Store character
  inc     edi                 ; Move to the next memory address
  rol     ebx, 0x2            ; Bring the next byte
  ; shr     ebx, 0x2          ; Use this to start from lsb
  inc     edx                 ; Increase counter for newline
  mov     eax, ebx            ; Restore eax
  loop    .buff_loop

  mov     word [edi], 0x0d0a  ; Put the last new line
  mov     byte [edi + 0x2], 0x0 ; Put the '\0'

  ret

  ; ==========================
  ; Input:
  ;   eax: Byte value
  ; Output:
  ;   eax: ASCII symbol
toAscii:
  lea     eax, [char_arr + eax] ; Find the address of the symbol
  movzx   eax, byte [eax]       ; Load the symbol and clear rest of eax

  ret
