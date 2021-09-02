format PE console
entry start

include 'win32a.inc'

LENGTH = 0x28 ; 40d

section '.data' data readable
    prompt      db      'Enter a string:', 0xd, 0xa, 0x0
    encoded     db      'The string encoded in ROT13 is: ', 0xd, 0xa, 0x0

section '.bss' readable writable
    dEstr       db    LENGTH  dup(0)

section '.text' code readable executable
start:
  mov     esi, prompt
  call    print_str

  ; Read string from user
  mov     edi, dEstr
  mov     ecx, LENGTH
  call    read_line

  ; Find it's size
  push    ecx
  push    edi
  call    str_Size
  add     esp, 0x8
  mov     ecx, eax

  ; If user gave null input exit
  jecxz   exit

  ; Perform the encoding
  push    edi
  call    rot13
  add     esp, 0x4

  ; Show the encoded string
  mov     esi, encoded
  call    print_str
  mov     esi, dEstr
  call    print_str

exit:
  push    0
  call    [ExitProcess]

; ================================================
; str_Size (arr_addr, arr_max_len)
;
; Input:
;   (stack) arr_addr: Base address of the array
;   (stack) arr_max_len: Array's max length
; Output:
;   eax: Array's true length
; Operation:
;   Loops through the array until '\0' is found or max length is reached
;   to determine the real size if the array
;
str_Size:
  .arr_addr = 0x8     ; Offset of first argument in the stack
  .arr_size = 0xc     ; Offset of second argument in the stack
  push    ebp
  mov     ebp, esp

  push    edi
  push    ecx

  mov     edi, dword [ebp + .arr_addr]  ; Load base address from the stack
  mov     ecx, dword [ebp + .arr_size]  ; Load max length from the stack
  xor     eax, eax                      ; '\0'
  repnz   scasb   ; Loop until '\0' is found or max length is reached

  mov     esi, dword [ebp + .arr_addr]  ; Load base address from the stack
  dec     edi                           ; Go to '\0'
  sub     edi, esi                      ; Subtract end address from base address
  mov     eax, edi                      ; to get it's true length

  pop     ecx
  pop     edi

  leave
  ret

; ================================================
; rot13 (str)
;
; Input:
;   (stack) str: String to encode
; Output:
;   (memory) Encoded string
; Operation:
;   Load every character form the string array and replace it with the
;   encoded one

rot13:
  .arr_addr = 0x8         ; Offset of first argument in the stack
  push    ebp
  mov     ebp, esp

  push    esi
  push    eax

  mov     esi, dword [ebp + .arr_addr]  ; Load array's base address from stack
.loop_str:
  movzx   eax, byte [esi] ; Load char from str[i]
  test    eax, eax
  jz      .null_found     ; if (char == '\0') .return

  push    eax
  call    encode_char
  add     esp, 0x4        ; Free memory from encode_char

  mov     byte [esi], al  ; Store encoded char at str[i]
  inc     esi             ; Advance to the next character
  jmp     .loop_str

.null_found:
  pop     eax
  pop     esi

  leave
  ret

; ================================================
; encode_char (char)
;
; Input:
;   (stack) char: Character to encode
; Output:
;   eax: Encoded character
; Operation:
;   Checks if the character is an alphabetic one, and if it is, it encodes it
;   based on the ROT13 algorithm

; If character's ASCII between 'A' and 'Z' or 'a' and 'z' then we encode it,
; otherwise we just .return the same ASCII.
; To encode it, we check if we have at least 13 letters difference from 'z'. If
; we do, we make the encode. Otherwise, we start from the beggining by replacing
; current ASCII with 'A' or 'a' and then adding the remaining offset.

encode_char:
  .char = 0x8           ; Offset of first argument in the stack
  push    ebp
  mov     ebp, esp

  push    ecx

  mov     ecx, 0xd      ; Default algorithm's offset
  mov     eax, dword [ebp + .char]  ; Load character from the stack


  cmp     eax, 'A'
  jb      .return        ; if (char < 'A') it's special character
  cmp     eax, 'Z'
  ja      .check_lower  ; if (char > 'Z') check if it's lower
                        ; else it's an upper case character

  ; Character is upper case
  cmp     eax, 'M'      ; 'M' has exactly 13 offset from 'Z', so we have
  jbe     .encode       ; spare letters

  mov     ecx, 'Z'      ; Otherwise find the distance of the letter from 'Z'
  sub     ecx, eax      ; distance = 13 - ('Z' - char)
  sub     ecx, 0xc
  neg     ecx
  mov     eax, 'A'      ; and add it as an offset from
  jmp     .encode       ; the beginning of the alphabet
.check_lower:
  cmp     eax, 'a'
  jb      .return      ; if (char < 'a') it's special character (at this point)
  cmp     eax, 'z'
  ja      .return      ; if (char > 'z') it's a special character
                      ; else it's a lower case character

  ; Character is lower case
  cmp     eax, 'm'     ; 'm' has exactly 13 offset from 'z', so we have
  jbe     .encode      ; spare letters
  mov     ecx, 'z'     ; Otherwise find the distance of the letter from 'z'
  sub     ecx, eax      ; distance = 13 - ('Z' - char)
  sub     ecx, 0xc
  neg     ecx
  mov     eax, 'a'    ; and add it as an offset from
                      ; the beginning of the alphabet
.encode:
  add     eax, ecx    ; Add the offset

.return:
  pop     ecx

  leave
  ret


include 'training.inc'
