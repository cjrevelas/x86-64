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
    data db 0xaa

section .text                  ; code segment
    global main              ; declare "main" entry point for the linker

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

func:
    ; func needs to keep somewhere the
    ; stack frame of the callee (in the stack)
    push rbp
    ; then it can create its own stack frame
    mov rbp, rsp
     
    ; func allocates space in its own stack frame
    sub rsp, 4                 
    mov [rbp-4], dword 0xffffffff
    
    ; we need restore the stack pointer
    ; to the value it had at the start
    ; of the function so that we are able
    ; to return to the callee. We can do this
    ; very easily by assigning back the base
    ; pointer to the stack pointer
    mov rsp, rbp
    ; return the base pointer of the callee
    pop rbp
    ; return to the callee using the return
    ; address that should be in the stack pointer
    ret

;
; The main function of the program
;
main:                           ; entry point
    ;sub rsp, 4                   ; allocate space for variable x 
    ;mov [rsp], dword 0x11111111  ; initialize variable x
    
    ;sub rsp, 4                   ; allocate space for variable y
    ;mov [rsp], dword 0x22222222  ; initialize variable y
    ;mov [rsp], dword 0x33333333  ; modify variable y
    
    ; if we want to modify variable x, we need to remember
    ; its offset from the current stack pointer
    ;mov [rsp+4], dword 0x33333333 ;
    
    ; this is why need stack frames
    ; if we need to add a z-variable then we need to remember
    ; to update the offsets
    ; x = [rsp+8]
    ; y = [rsp+4]
    ; to create and maintain a stack frame we need a base pointer
    ; this will be the register rbp, which serves as an
    ; anchor, while the stack pointer, rsp, is free to
    ; move up and down
    ; we setup the stack frame by assigning rsp to rbp
    mov rbp, rsp
    
    sub rsp, 4                    ; allocate space for variable x
    mov [rbp-4], dword 0x11111111 ; initialize variable x
    
    sub rsp, 4                    ; allocate space for variable y
    mov [rbp-8], dword 0x22222222 ; initialize variable y
    
    ; let's say now that we have another function, that
    ; needs to allocate space on the stack for its own
    ; local variables. To do this, it needs to create
    ; its own stack frame before allocating the space,
    ; by setting the base pointer equal the position
    ; of the stack pointer, when the function is called
    call func
    ; at this point, the stack should look exactly
    ; like before we called func

    ; now if we want to modify the variable x, we can simply
    ; do the following
    mov [rbp-4], dword 0x33333333 ; modify variable x
    
    call exit
