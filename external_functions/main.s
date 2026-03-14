default abs

extern  printf
extern  c_area
extern  c_cmfrnce
extern  r_area
extern  r_cmfrnce

global pi

section .data
  pi              dq  3.141592564
  radius          dq  10.0
  side1           dq  4
  side2           dq  5
  format_float    db  "%s %f", 10, 0
  format_int      db  "%s %d", 10, 0
  circle_area     db  "The circle area is ", 0
  circle_c        db  "The circle circumference is ", 0
  rectangle_area  db  "The rectangle area is ", 0
  rectangle_c     db  "The rectangle circumference is ", 0

section .text
global main

main:
  push  rbp
  mov   rbp, rsp

  movsd xmm0, qword [radius]
  call  c_area
  mov   rdi,  format_float
  mov   rsi,  circle_area
  mov   rax,  1
  call  printf

  movsd xmm0, qword [radius]
  call  c_cmfrnce
  mov   rdi,  format_float
  mov   rsi,  circle_c
  mov   rax,  1
  call  printf

  mov   rdi, qword [side1]
  mov   rsi, qword [side2]
  call  r_area
  mov   rdi,  format_int
  mov   rsi,  rectangle_area
  mov   rax,  1
  call  printf

  mov   rdi, qword [side1]
  mov   rsi, qword [side2]
  call  r_cmfrnce
  mov   rdi,  format_int
  mov   rsi,  rectangle_c
  mov   rax,  1
  call  printf

  mov rsp,  rbp
  pop rbp

  ret
