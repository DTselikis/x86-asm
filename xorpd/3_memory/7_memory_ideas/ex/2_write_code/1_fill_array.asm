format PE console
entry start

include 'win32a.inc'

HEIGHT = 5
WIDTH = 4

section '.bss' readable writable
      arr   dw  HEIGHT*WIDTH dup (?)

section '.text' code readable executable

start:
  mov   esi, arr       ; Get base address of the array
  xor   ecx, ecx      ; i = 0
out_loop:             ; for (i = 0; i < WIDTH; i++)
  xor   ebx, ebx      ; j = 0
inn_loop:             ; for (j = 0; j < HEIGHT; j++)
  lea   edx, [ecx + ebx]    ; i + j
  mov   word [esi], dx      ; Store i + j to the coresponding index
  add   esi, 0x2            ; Move no the next element inside the array
  inc   ebx                 ; j++
  cmp   ebx, WIDTH          ; j < WIDTH
  jl    inn_loop

  inc   ecx                 ; i++
  cmp   ecx, HEIGHT         ; i < HEIGHT
  jl    out_loop

  mov   esi, arr            ; Get base address of the array
  mov   ecx, HEIGHT * WIDTH ; Number of total elements (itterations)
print_array:
  movzx eax, word [esi]     ; Load element at position i*j
  call  print_eax           ; Print value
  add   esi, 2              ; Move to next element (i++)
  loop  print_array

  push  0
  call  [ExitProcess]

include 'training.inc'
