default abs

extern  pi

section .data
section .bss
section .text

global  c_area

c_area:
  push  rbp
  mov   rbp,  rsp

  movsd xmm1, qword [pi]
  mulsd xmm0, xmm0
  mulsd xmm0, xmm1

  mov   rsp,  rbp
  pop   rbp
  ret
