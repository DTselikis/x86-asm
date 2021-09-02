format PE console
entry start

include 'win32a.inc'

section '.data' data readable
    prompt      db    'Enter a number greater than 1: ', 0x0
    total       db    'Total prime number between 1 and n: ', 0x0

section '.text' code readable executable
start:
  mov    esi, prompt
  call   print_str
  call   read_hex

  call   calc_prime

  mov    esi, total
  call   print_str
  call   print_eax

  push   0
  call   [ExitProcess]

; ==========================
; Input:
;   ecx: The number to be checked
; Output:
;   edx: The reminder of the division
;   also tell as if the number is a prime
is_prime:
  push  edi          ; Save edi
  mov   edi, ecx     ; Save checking number
  dec   ecx          ; Decrease it because we know that each number devide himself
                     ; perfectly
.prime_inner_loop:
  mov   eax, edi     ; Restore checking number
  cdq                ; Zero edx
  div   ecx
  cmp   edx, 0x0     ; If edx is 0 then there is a number that can devide the
                     ; checking number perfectly
  jz    .return      ; so we return from the function
  dec   ecx          ; Decrease the divisor
  cmp   ecx, 0x0     ; Case that checking number is 2 (otherwase there would
  jz    .return      ; be a division by zero and we would have an exception)
  cmp   ecx, 0x1     ; We know 1 devide the number so no need to check
  jnz   .prime_inner_loop
.return:
  pop   edi          ; Restore edi
  ret

; ==========================
; Input:
;   eax: The number to be checked
; Output:
;   eax: number of prime numbers
calc_prime:
  mov   edi, 0x1      ; Cause of a bug we start from 1 because we know 2 is prime
  mov   esi, eax      ; Number of iterations
.prime_loop:
  mov   ecx, esi      ; Number to be checked
  call  is_prime
  cmp   edx, 0x0      ; If the division has no reminder, then there is at least
                      ; one other number (except 1 and himself) who can devide
                      ; it perfectly
  jz    .not_prime
  inc   edi           ; Increase number of primes
.not_prime:
  dec   esi           ; Decrease counter and also change the number to be checked
  cmp   esi, 0x1      ; If we reached number one, end, because we don't check 1
  jnz   .prime_loop

  mov   eax, edi      ; We will return the total to eax

  ret

include 'training.inc'
