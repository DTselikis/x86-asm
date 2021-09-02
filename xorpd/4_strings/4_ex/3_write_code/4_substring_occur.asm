format PE console
entry start

include 'win32a.inc'

MAX_INPUT = 60

section '.data' data readable
    prompt      db   'Enter a string:', 0xd, 0xa, 0x0
    prompt_2    db   'Enter a substing to search: ', 0xd, 0xa, 0x0
    error       db   'Null not found!', 0xd, 0xa, 0x0
    found_msg   db   'Substring was found at locations:', 0xd, 0xa, 0x0
    not_found   db   'Substring not found.', 0xd, 0xa, 0x0

section '.bss' readable writable
    input   db    MAX_INPUT dup(?)
    sub_str db    MAX_INPUT dup(?)
    pos     db    MAX_INPUT dup(?)
    occur   db    0x0

 ;  ===========================================================================
 ;    Brute force
 ;    Begin from the first byte of input array and form the first byte of
 ;    substring. If there's a match, advance both indexes until the
 ;    end of substring or a mismatch is found. In this case, restore
 ;    both indexes and advance inpur array's index so much positions as
 ;    the bytes we compared, becasue if there was a substing in there,
 ;    we would have found it.
 ;
 ;    Pos array
 ;    Stores the positions at which substing inside of the input array
 ;    found. We use "ocur" to determine at which offset we must store
 ;    the next position. ex. at the first occurance, the "ocur" will be
 ;    0, so we will store it at offset 0x0 of pos.
 ; ============================================================================

section '.text' code readable executable
start:
  mov   esi, prompt
  call  print_str
  mov   ecx, MAX_INPUT
  mov   edi, input                 ; Read string
  call  read_line
  mov   esi, prompt_2
  call  print_str
  mov   edi, sub_str
  call  read_line                  ; Read substring to search

  xor   eax, eax                   ; Find '\0'
  mov   ecx, MAX_INPUT             ; Max iterations
  mov   edi, sub_str               ; Base address of array
  repnz scasb                      ; Search until '\0' found (ZF = 1) or max number of iterations reached

  jz    no_substr                  ; If no substring was given

  xor   eax, eax                   ; Find '\0'
  mov   ecx, MAX_INPUT             ; Max iterations
  mov   edi, input                 ; Base address of array
  repnz scasb                      ; Search until '\0' found (ZF = 1) or max number of iterations reached

  jz    null_found

  mov   esi, error
  call  print_str
  jmp   exit

null_found:
  dec   edi                        ; Move edi backwards one position to point at '\0'
  lea   ecx, [edi - input]         ; Find the number of elements inside array (without '\0')
  mov   edi, input                 ; Base address of array

loop_input:
  mov   esi, sub_str               ; Base address of string to search
  mov   edx, edi                   ; Current position inside the input array
  inc   edx                        ; Will help in case we only need to move by 1 byte
  movzx eax, byte [esi]            ; Load the first character of substring
  cmp   al, byte [edi]             ; and compare it with the character in the current
                                   ; position inside input array

  jnz   next_itter
  mov   edx, edi                   ; Will help to determine next searching position
inner_loop:
  inc   esi                        ; Load the next character of substring
  cmp   byte [esi], 0x0            ; If it's '\0' it means we successfully found
                                   ; the substing inside the input array
  jz    found                      ; Match of the first char of substing

  inc   edx                        ; Move to the next character of input array
  movzx eax, byte [esi]            ; Load next character of substring
  cmp   al, byte [edx]             ; Compare the two characters
  jnz   next_itter                 ; If the they don't much, move to the next
                                   ; character of input array and start again
  jz    inner_loop                 ; If they much, continue searching

found:
  push  edx
  lea   edx, [edi - input]         ; Determine the position of the first letter
                                   ; of substring inside the input array
                                   ; We use edi because it contains the current
                                   ; starting position of the substing
  movzx eax, byte [occur]          ; Offset of the next empty byte of occur
  mov   byte [pos + eax], dl       ; Store the position
  inc   byte [occur]               ; Increase offset
  pop   edx

next_itter:
  mov   ebx, edx                   ; Copy edx
  sub   ebx, edi                   ; Determine how many bytes to advance
  jnz   advance
  inc   ebx                        ; For the case the substings occurance is at
                                   ; the zero position and it's only 1 character
                                   ; ebx would be 0 and ecx would never be 0
advance:
  add   edi, ebx                   ; Advance the memory of input array
  sub   ecx, ebx                   ; Lower the counter
  inc   ecx                        ; Add 1 because it will decrease 1 by loop
  loop  loop_input

  mov   esi, found_msg
  cmp   byte [occur], 0x0          ; If occurance is zero then the substing isn't found
  jnz   print_message
  
no_substr:
  mov   esi, not_found
  call  print_str
  jmp   exit

print_message:
  call  print_str

  movzx ecx, byte [occur]         ; Load the number of occurances (iterations)
  mov   esi, pos
print_loop:                       ; Load and print each position
  movzx eax, byte [esi]
  call  print_eax

  inc   esi                       ; Move to the next byte
  loop  print_loop

exit:
  push  0
  call  [ExitProcess]

include 'training.inc'
