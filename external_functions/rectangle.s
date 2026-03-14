default abs

extern  pi

section .data
section .bss
section .text

global  r_area
global  r_cmfrnce

r_area:
  push  rbp
  mov   rbp,  rsp

  mov   rax,  rsi
  imul  rax,  rdi

  mov   rsp,  rbp
  pop   rbp
  ret

r_cmfrnce:
  push  rbp
  mov   rbp,  rsp

  mov   rax,  rsi
  add   rax,  rdi
  add   rax,  rax

  mov   rsp,  rbp
  pop   rbp
  ret


