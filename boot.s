format binary
org 0x7c00
jmp start_
; Data
data_section:
dw code_section - data_section
text: db "BOOT TEXT 16BIT" , 0xa  , 0xd, 0
halt_message: db "HALT" , 0xa , 0xd , 0
; function (cdecl)16bit
code_section:
putc16: ; ret -> char
  push bx
  mov bx , sp
  add bx , 4
  mov al , [bx]
  mov ah , 0x0e
  int 10h
  pop bx
  ret
puts16:
  push bx
  mov bx , sp
  add bx , 4 
  mov si , [bx]
  .loop:
  mov al , [si]
  test al , al
  jz .end
  inc si
  push ax
  call putc16
  pop ax
  jmp .loop
  .end:
  pop bx
  ret
ldsec:
  ret
start_:
  xor ax , ax
  cli 
  mov bp , sp
  mov ds , ax
  mov ss , ax
  sti
  push text
  call puts16
  add sp , 2



hang_:
  call puts16
  .loop:
  hlt
  jmp .loop
times 510 - ($-$$) db 0
dw 0xAA55
