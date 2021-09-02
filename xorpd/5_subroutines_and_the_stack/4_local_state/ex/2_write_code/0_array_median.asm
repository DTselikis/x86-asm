format PE console
entry start

include 'win32a.inc'

ARRAY_LENGTH = 0x9

section '.data' data readable writable
      arr     dd      4,8,1,9,23h,41h,15h,13h,44h
      med     db      'Median number of the array: ', 0x0

section '.text' code readable executable
start:
  push      ARRAY_LENGTH
  push      arr
  call      find_median
  add       esp, 0x4

  mov       esi, med
  call      print_str

  call      print_eax

  push      0
  call      [ExitProcess]

; ================================================
; find_median (arr_addr,arr_len)
;
; Input:
;   (stack) arr_addr: Base address of the array
;   (stack) arr_len: Array's length
; Output:
;   eax: Value of the median number
; Operation:
;   Loops through the sorted array finds the value of the number at the
;   median index
;
find_median:
  .arr_addrr =  0x8   ; Offset of first argument inside the stack
  .arr_len   =  0xc   ; Offset of second argument inside the stack
  push      ebp
  mov       ebp, esp

  push      esi
  push      edi

  mov       esi, dword [ebp + .arr_addrr] ; Load array's address from the stack
  mov       edi, dword [ebp + .arr_len]   ; Load array's length from the stack

  push      edi
  push      esi
  call      sort_arr  ; Sort the array in decending order
  add       esp, 0x8  ; Free memory of sort_arr

  shr       edi, 0x1  ; Divide by 2 to find the median
  mov       eax, dword [esi + 4*edi]  ; Load the number at the median index

  pop       edi
  pop       esi

  leave
  ret
; ================================================
; sort_arr(arr_addr,arr_len)
;
; Input:
;   Base address of the array and its length through the stack
; Output:
;   The array sorted
; Operation:
;   Loops through the array and set registers to differnt elements of the array
;
sort_arr:
    .arr_addr = 8h         ; Offset of the arr_addr argument inside the stack
    .arr_len = 0ch         ; Offset of the arr_len  argument inside the stack
    push    ebp
    mov     ebp,esp

    push    esi
    push    edi
    push    ecx
    push    ebx

    mov     esi,dword [ebp + .arr_addr]   ; Base address of the array
    mov     ecx,dword [ebp + .arr_len]    ; Array length
    lea     ebx,[esi + 4*ecx]             ; End address of the array

    jecxz   .no_elements                  ; If arr_len == 0
.outer_iter:                     ; for (i = 0; i < n; i++)
    mov     edi,esi              ; For the first iteration it will be the same number
.inner_iter:                     ; for (j = i; j < n; j++)
    push    edi
    push    esi
    call    compare_and_swap
    add     esp,4*2              ; Free arguments of compare_and_swap
    add     edi,4                ; Increase inner loop (j++)
    cmp     edi,ebx              ; Check if we reached the end of the array (j < n)
    jb      .inner_iter          ; Next j iteration
    add     esi,4                ; Increase outer loop (i++)
    cmp     esi,ebx              ; if (i < n)
    jb      .outer_iter          ; Next i iteration
.no_elements:

    pop     ebx
    pop     ecx
    pop     edi
    pop     esi

    pop     ebp
    ret


; ===============================================
; compare_and_swap(x_addr,y_addr)
;
; Input:
;   Addresses of two array elements
; Output:
;   The two elements, maybe swapped
; Operation:
;   Loads two array's element's values from the memory and compare them
;
compare_and_swap:
    .x_addr = 8h                ; arr[i]
    .y_addr = 0ch               ; arr[j]
    push    ebp
    mov     ebp,esp

    push    esi
    push    edi
    push    eax

    mov     esi, dword [ebp + .x_addr]    ; Address of arr[i]
    mov     edi, dword [ebp + .y_addr]    ; Address of arr[j]
    mov     eax, dword [esi]              ; Value of arr[i]
    cmp     eax,dword [edi]               ; Compare arr[i] and arr[j]
    jae     .x_above_equal                ; if (arr[i] > arr[j]) DON'T swap
    ; We only swap in the case where y > x:
    push    edi
    push    esi
    call    swap
    add     esp,4*2                       ; Free memory of swap's arguments
.x_above_equal:                           ; arr[i] > arr[j] so no swap needed

    pop     eax
    pop     edi
    pop     esi

    pop     ebp
    ret

; =================================================
; swap(x_addr,y_addr)
;
; Input:
;   Addresses of two array elements
; Output:
;   The elements swapped
; Operation:
;   Swaps the two elements by utilizing the stack
;
swap:
    .x_addr = 8h          ; Offset of arr[i] address inside the stack
    .y_addr = 0ch         ; Offset of arr[j] address inside the stack
    push    ebp
    mov     ebp,esp

    push    esi
    push    edi

    mov     esi,dword [ebp + .x_addr]   ; Load value of arr[i]
    mov     edi,dword [ebp + .y_addr]   ; Load value of arr[j]

    push    dword [esi]
    push    dword [edi]
    pop     dword [esi]
    pop     dword [edi]

    pop     edi
    pop     esi

    pop     ebp
    ret

include 'training.inc'
