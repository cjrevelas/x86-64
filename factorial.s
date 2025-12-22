%include "macros.s"

%define SYSCALL_EXIT 60

section .data                  ; data segment
x dq 0
n equ 8
scanf_format: db "%ld", 0
printf_format:  db "fact(%ld) = %ld", 0x0a, 0

section .text                  ; code segment
    global main                ; declare "main" entry point for the linker
    global factorial           ; make fact routine globally accessible
    extern scanf               ; scanf from libc
    extern printf              ; printf from libc

;
; Function that reads an integer number
; from the console
;
read_number:
    prologue

    sub rsp, 8

    lea   rdi, [scanf_format]   
    lea   rsi, [x]
    xor   rax, rax
    call  scanf

    epilogue

;
; Function that prints an integer number
; to the console
;
print_number:
    prologue

    sub rsp, 8
    lea   rdi, [printf_format]
    mov   rsi, [x]
    mov   rdx, rax
    xor   rax, rax
    call  printf

    epilogue

;
; Function to compute the factorial of
; an integer number
;
factorial:
    prologue

    sub rsp, 16       ; make room for the function's single argument

    cmp   rdi, 1      ; compare the value of the argument with one
    jg    greater     ; if the number <= 1, return 1
    mov   rax, 1      ; set return value to 1

    epilogue

greater:
    mov   [rsp+n], rdi
    dec   rdi
    call  factorial
    mov   rdi, [rsp+n]
    imul  rax, rdi

    epilogue
    
;
; Function that invokes the EXIT system call
; to terminate the program's execution.
;
exit:
    prologue

    mov  rax, SYSCALL_EXIT     ; EXIT system call will be performed
    mov  rdi, 0                ; error code
    syscall                    ; perform the system call

    epilogue

;
; The main function of the program
;
main:                          ; entry point
    call read_number           ; read an integer number from console
    mov  rdi, [x]              ; mov a to first argument of factorial call
    call factorial             ; go to compute factorial
    call print_number          ; print an integer number to the console
    call exit                  ; terminate program execution
