format PE console
entry start

include 'win32a.inc'

MAX_INPUT = 0x96        ; 150d
CHARACTERS = 0x32       ; 50d

section '.data' data readable
    prompt      db   "Enter a phrase:", 0xd, 0xa, 0x0
    char_start  db   "The character ", 0x0
    char_cont   db   " is the most common character on the string.", 0xd, 0xa, 0x0
    amount      db   "Amount of occurrences: ", 0x0
    error       db   "Null terminator not found!", 0xd, 0xa, 0x0

section '.bss' readable writable
    buff        db    MAX_INPUT   dup (?)
    char_array  db    CHARACTERS  dup (?)
    char        db    0x2         dup (0)

    ; ========================================================================
    ; Idea of char_array:
    ; Every position in char_array is correspond to a certain character.
    ; Because some ASCII codes are pretty large, we will convert it.
    ; Our convention is that the first 25 bytes (offsets 0 - 24) will be
    ; used for upper case characters and the last 25 (offsets 25 - 50)
    ; for lower case characters.
    ; Therefore offset 0 will be for 'A',
    ;                  24            'Z',
    ;                  25            'a',
    ;                  50            'z'
    ; Ex:
    ; 'A' has ASCII code 0x41 and it s an upper case character, so
    ; we will store it at the first half of our array. Therefore
    ; we subtract 0x41 from this character. The result will be
    ; it s offset inside the array. A, with ASCII 0x41 will have
    ; offset 0x0, so it will be stored at the first byte.
    ; 'B' with ASCII 0x42 will have offset of 0x1, so it will be
    ; stored at the second byte
    ; 'a' has ASCII code 0x61 and it s also a lower case letter.
    ; Therefore, we again subtract 0x61 to find it s offset
    ; in the second half of the array, and we add the offset 0x25
    ; because there starts the offsets for the lower case letters
    ; So, 'a' will have offset 0x0 + 0x25 = 0x25 which is the first
    ; byte of the second half.
    ; 'b' hast ASCII 0x62 so 0x1 + 0x25 = 0x26 which is the offset for
    ; the second byte of the second half.
    ;
    ; To find the corresponding character afet a certain index of the array
    ; we follow the opposite procedure.
    ; For upper case letters, we add 0x41, so offset 0x0 + 0x41 = 0x41 = 'A'
    ; For lower case letters, we add 0x61 and subtract 0x25, so
    ; 0x25 - 0x25 + 0x61 = 0x61 = 'a'
    ;
    ; ========================================================================

section ".text" code readable executable
start:
  mov   esi, prompt           ; Take input
  call  print_str
  mov   ecx, MAX_INPUT        ; Max length of buff
  mov   edi, buff             ; Base address of buff
  call  read_line

  xor   eax, eax              ; Search for '\0'
  mov   ecx, MAX_INPUT        ; Max iterations
  mov   edi, buff             ; Base address of buff
  repnz scasb                 ; Loop until '\0' is found or ecx is zero

  jz    null_found

  mov   esi, error            ; Inform user
  call  print_str
  jmp   exit

null_found:
  dec   edi                   ; Decrease one to go to the address of '\0'
  mov   ecx, edi
  sub   ecx, buff             ; Last address - base address - number of iterations
  mov   esi, buff             ; Base address of buff
count_chars:
  movzx eax, byte [esi]       ; Load character
  sub   eax, 0x20             ; Difference between a small case character with his
                              ; upper case corresponding is 0x30 (32d)
  jz    next_itter            ; If zero it means it was a space (ASCII 0x20)
  cmp   eax, 0x41             ; If the resulted number is less that 0x41 (which is ASCII for 'A')
                              ; it means this character is an upper case
  movzx eax, byte [esi]       ; Load character again because we lose it with sub
  jl    upper

  mov   edi, char_array
  lea   edi, [char_array + eax - 0x61 + 25d]    ; Find it's offset inside the array
                                                ; See "Idea of char_array" for more info
  jmp   inc_appear                              ; Move to the next byte
upper:
  lea   edi, [char_array + eax - 0x41]          ; Find it's offset inside the array
                                                ; See "Idea of char_array" for more info
inc_appear:
  inc   byte [edi]                              ; Increase the number of appearances
next_itter:
  ; mov   esi, char_array       ; Base address of char_array. Should't be here
  ; inc   byte [edi]              ; Increase the number of appearances
  inc   esi                     ; Move to the next character
  loop  count_chars

  mov   esi, char_array         ; Base addres of char_array
  movzx eax, byte [esi]         ; Set first character as the one with the most appearances
  mov   ebx, 0x0                ; First character = offset 0x0
  inc   esi                     ; Start searching from the next character in the array
  mov   ecx, 0x1                ; Second character = offseet 0x1
find_greater:
  cmp   byte [esi], al          ; Compare nth character's appearances with our max
  jle    next_find_itter        ; If new max was not found
  movzx eax, byte [esi]         ; If found, save the number of appearances
  mov   ebx, ecx                ; and it's offset
next_find_itter:
  inc   esi                     ; Move to the next character
  inc   ecx                     ; Increase counter
  cmp   ecx, CHARACTERS
  jnz   find_greater            ; while (i < CHARACTERS)

  cmp   ebx, 0x24               ; Determine if the character is from the first or second
                                ; half of the array, based on its offset
  jge   was_upper               ; offsets 0 - 24 = first half, 24 - 50 = second half
  add   ebx, 0x61               ; Add the ASCII of 'a'
  sub   ebx, 25d                ; and subtract it's offset
                                ; See "Idea of char_array" for more info
  jmp   save_ascii
was_upper:
  add   ebx, 0x41               ; Add the ASCII of 'A'
                                ; See "Idea of char_array" for more info
save_ascii:
  mov   byte [char], bl         ; Store the character's ASCII to be able to print it

  mov   esi, char_start         ; Print the messages
  call  print_str
  mov   esi, char
  call  print_str
  mov   esi, char_cont
  call  print_str
  mov   esi, amount
  call  print_str
  call  print_eax

exit:
  push  0
  call  [ExitProcess]

include 'training.inc'
