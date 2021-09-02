format PE console
entry start

include 'win32a.inc'

struct PNT
    x   dd  ?
    y   dd  ?
ends

struct RECT
    a   PNT ?
    c   PNT ?
    area  dd  ?
ends

section '.bss' readable writeable
    rect1  RECT ?
    rect2  RECT ?

section '.text' code readable executable

start:
  mov   ecx, 8      ; We need 8 points (for 4 coordinates)
  mov   esi, rect1  ; Base address of the start of our memory
read_loop:
  call  read_hex
  mov   dword [esi], eax ; Store input to the memory
  add   esi, RECT.a.y    ; We know each position inside RECT struct differs by 4 bytes (1 dword)
                         ; so every time we increase memory by 4 bytes to get to the next address
  ;mov   dword [rect1 + (8-ecx) * 4], eax  WRONG it will not assemble
  loop  read_loop

  ; See the elemtns of the array
  ;mov   ecx, 8
  ;mov   esi, rect1
;print_array:
  ;call  print_delimiter
  ;mov   eax, esi
  ;call  print_eax
  ;mov   eax, [esi]
  ;call  print_eax
  ;add   esi, RECT.a.y
  ;loop  print_array


  mov   esi, rect1    ; Base address of the start of our memory
  xor   ebx, ebx      ; Will store the area
  mov   ecx, 2        ; 2 itterations, one for each rectangle
  ;0, 12, 16, 28 offsets we need to read
find_area:
  mov   eax, dword [esi]  ; Load a.x
  mov   edx, dword [esi + RECT.c.x] ; Load c.x by adding the offest to the address
  sub   eax, edx      ; Substruct to find the distance (width)
  jg    positive
  neg   eax           ; If number if negative take the absolute value
positive:

  mov   ebx, eax      ; Save width

  mov   eax, dword [esi + RECT.a.y] ; Load a.y
  mov   edx, dword [esi + RECT.c.y] ; Load c.y
  sub   eax, edx      ; Substruct to find the distance (height)
  jg    positive2
  neg   eax           ; If number if negative take the absolute value

positive2:
  cdq                 ; clear edx
  imul  ebx           ; width * height to find the area
  mov   dword [esi + RECT.area], eax  ; store area based on offset

  add   esi, sizeof.RECT  ; Move to the memory of second rectrangle (by adding the size of struct RECT)
  loop  find_area

  mov   ebx, dword [rect1.area]   ; Load area of rect1
  mov   edx, dword [rect2.area]   ; Load area of rect2

  ; See areas
  ;call  print_delimiter
  ;call  print_delimiter
  ;mov   eax,  ebx
  ;call  print_eax
  ;mov   eax, edx
  ;call  print_eax


  mov   ecx, 0    ; Index of greater area
  cmp   ebx, edx  ; Compare areas
  jg    rect1_greater
  mov   ecx, 1
  mov   ebx, edx
rect1_greater:
  call  print_delimiter

  ;mov   eax, [ecx - 1]
  ;call  print_eax

  mov   eax, ecx  ; Print which rectangle has greater area
  call  print_eax

  mov   eax, ebx  ; Print the area
  call  print_eax

  push  0
  call  [ExitProcess]

include 'training.inc'
