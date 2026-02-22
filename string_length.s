; The following macro sets up the the stack frame of a function.
;
%macro prologue 0
    push rbp                   ; save rbp on the stack to restore it at the end of the function
    mov rbp, rsp               ; set rbp to rsp
%endmacro

;
; The following macro restores rbp from the stack and returns to the caller.
;
%macro epilogue 0
    mov rsp, rbp               ; discard local variables and restore stack pointer
    pop rbp                    ; restore the old frame pointer
    ret
%endmacro

%define SYSCALL_EXIT 60

section .data                  ; data segment
    str1 db "Hello, World!",0xa
    str2 db "A random string to be printed",0xa

section .text                  ; code segment
    global main              ; declare "main" entry point for the linker
    global string_length       ; make function visible to other modules
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
; Function to calculate the length
; of a string.
;
; Inputs:
;    rdi: the string
;
; Outputs:
;    rax: the length of the string
;
string_length:
    prologue
    xor rcx, rcx
.loop:
    mov bl, [rdi]
    cmp bl, 0
    je .end_loop
    inc rcx
    inc rdi
    jmp .loop
.end_loop: 
    mov rax, rcx
    epilogue

main:                           ; entry point
    lea  rdi, [str2]
    call string_length
    call exit
