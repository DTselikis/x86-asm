format PE console
entry start

include 'win32a.inc'

NUM_OF_ELEMENTS = 0x3

struct PNT
    x   db  ?
    y   db  ?
ends

section '.bss' readable writeable
    pnt_arr  db NUM_OF_ELEMENTS * sizeof.PNT dup (?)

section '.text' code readable executable

start:
  mov   ecx, NUM_OF_ELEMENTS * 2     ; Read elements
  mov   esi, pnt_arr  ; Base address of the start of our memory
read_loop:
  call  read_hex
  mov   byte [esi], al ; Store input to the memory
  add   esi, PNT.y    ; struct PNT contains two bytes so we add the offset of the second byte

  loop  read_loop

  xor   ecx, ecx      ; i = 0
  mov   esi, pnt_arr  ; Base address of our memory
sort_loop:            ; for (i = 0; i < NUM_OF_ELEMENTS - 1; i++)
  mov   al, byte [esi]  ; Load first elemnt of struct
  mov   ah, byte [esi + PNT.y]  ; Load second elemnt of struct (with offset)

  xor   edx, edx      ; j = 0;
  mov   edi, esi      ; Copy the current address (element position for next itteration)
  inside_sort_loop:   ; for (j = 0; j < NUM_OF_ELEMENTS - i - 1)
    mov   bl, byte [edi + sizeof.PNT]   ; Load first element of second struct
    mov   bh, byte [edi + sizeof.PNT + PNT.y] ; Load second element of second struct

; Check if the values should be swapped
    cmp   al, bl
    jg    greater
    jl    less
    cmp   ah, bh
    jg    greater
    jle   less

; Swap
  greater:
    mov   byte [edi], bl
    mov   byte [edi + PNT.y], bh
    mov   byte [edi + sizeof.PNT], al
    mov   byte [edi + sizeof.PNT + PNT.y], ah


  less:
  next_iter:
    inc   edx   ; j++
    add   edi, sizeof.PNT ; Load next struct (address) to compare
    lea   eax, [ecx - 1 - NUM_OF_ELEMENTS] ; inner for's condition
    cmp   edx, eax
    jl   inside_sort_loop

  add   esi, sizeof.PNT   ; Load next struct to start onother loop of checks
  inc   ecx   ; i++
  cmp   ecx, NUM_OF_ELEMENTS - 1  ; outer for's condition
  jl    sort_loop

  mov   ecx, NUM_OF_ELEMENTS
  mov   esi, pnt_arr
print_array:
  call  print_delimiter
  movzx eax, byte [esi]   ; Our data is size of 1 byte so we zero extend to clean the register
  call  print_eax
  movzx eax, byte [esi + PNT.y]   ; offset of second element of same struct
  call  print_eax

  add   esi, sizeof.PNT   ; move to the address of the next struct
  loop  print_array

  push  0
  call  [ExitProcess]

include 'training.inc'
