; Find the number that most commonly shows up in the array
; We expect the largerst number to be ff (so 1 byte) so every index
; of the array corresponds to a particular number

; ex: index 1 corresponds to number 0x1
;     index 2 corresponds to number 0x2
;     index fb corresponds to number 0xfb

format PE console
entry start

include 'win32a.inc'

ARR_LENGHT = 0xff   ; Size of array

section '.bss' readable writeable
      arr:    db ARR_LENGHT dup (?) ; fill with zeros at loading time

section '.text' code readable executable
start:
  call    read_hex ; Take input

  add     byte [arr + eax], 1 ; Increase by 1 the number to the corresponding index
                              ; If inputed number is 0x1 then we want to go to the index 1 of the array and increase this number
                              ; Because we dealing with bytes and because we have an array of bytes, every position in the
                              ; array has size of one byte. So from index 0 to index 1 the diffrerence is 1 byte.
                              ; If the address of the array is 004000 the address of the address that corresponds to
                              ; number 0x1 is 004001

  test    al, al     ; same with cmp eax, 0 but shorter https://stackoverflow.com/a/39558974
                     ; Performs bitwise AND
  jnz     start      ; Read number until the input is zero

  mov     ecx, ARR_LENGHT   ; loop counter
  mov     dl, cl            ; Index position (which is also the corresponded number)
  mov     al, byte [arr + ecx]  ; Move a byte (number) from array to al. We take the last number becasue of ecx
                                ; Array's address is calculated by adding the loop counter as an offset (because we deal with bytes)
                                ; to the base address of the array

  dec     ecx                   ; Decrease loop counter by 1
find_max:                       ; Find maximum number starting from the end of the array
  mov     bl, byte [arr + ecx]  ; Take the number i from array
  cmp     al, bl                ; Check if new number is greater
  jge     next_itter            ; If new number is greater
  mov     al, bl                ; make this number the current largest number
  mov     dl, cl                ; and save it's position
next_itter:                     ; else continue to the next loop
  loop    find_max

  mov     al, dl                ; Move the index (also number) with the most appearances to eax for printing
  call    print_eax

  push    0
  call    [ExitProcess]

include 'training.inc'
