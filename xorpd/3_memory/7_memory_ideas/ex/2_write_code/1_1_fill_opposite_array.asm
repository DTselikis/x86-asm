format PE console
entry start

include 'win32a.inc'

HEIGHT = 3
WIDTH = 2

section '.bss' readable writable
      arr   dw  HEIGHT*WIDTH dup (?)
      arr2  dw  WIDTH*HEIGHT  dup (?)

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

  mov   esi, arr            ; Base address of first array
  xor   ecx, ecx            ; i = 0
  xor   eax, eax            ; Zero eax to remove garbage
arr2_out_loop:
  xor   ebx, ebx            ; j = 0
arr2_in_loop:
  mov   ax, word [esi]      ; arr[i, j]
  lea   edi, [arr2 + (ebx * WIDTH) * 2]   ; Skip n columns to go to appropiate row
  lea   edi, [edi + ecx * 2]              ; Column in this specific row
  mov   word [edi], ax                    ; arr2(j, i) = arr(i, j)
  add   esi, 0x2                          ; Move to the next element in arr
  inc   ebx                               ; j++
  cmp   ebx, WIDTH                        ; j < WIDTH
  jl    arr2_in_loop

  inc   ecx                               ; i++
  cmp   ecx, HEIGHT                       ; i < HEIGHT
  jl    arr2_out_loop

  mov   esi, arr            ; Get base address of the array
  mov   ecx, HEIGHT * WIDTH ; Number of total elements (itterations)
print_array:
  movzx eax, word [esi]     ; Load element at position i*j
  call  print_eax           ; Print value
  add   esi, 2              ; Move to next element (i++)
  loop  print_array

  call  print_delimiter

  mov   esi, arr2           ; Get base address of the array
  mov   ecx, HEIGHT * WIDTH ; Number of total elements (itterations)
print_array_2:
  movzx eax, word [esi]     ; Load element at position i*j
  call  print_eax           ; Print value
  add   esi, 2              ; Move to next element (i++)
  loop  print_array_2

  push  0
  call  [ExitProcess]

include 'training.inc'
