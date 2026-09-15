format binary
org 0x7c00
jmp start_
; Data
data_section:
dw code_section - data_section
text: db "BOOT TEXT 16BIT" , 0xa  , 0xd, 0
disk_failure: db "FAILED TO LOAD KNELL" , 0xa , 0xd , 0 
; function (cdecl)16bit

  gdt_s:
  dq 0
  gdt_c:
  dw 0xffff 
  dw 0x0000
  db 0
  db 0x9a
  db 0xcf
  db 0
  gdt_d:
  dw 0xffff
  dw 0x0000
  db 0
  db 0x92
  db 0xcf
  db 0
  gdt_e:

  gdt_ds:
  dw gdt_e - gdt_s - 1
  dd gdt_s
  NCS equ gdt_c - gdt_s
  NDS equ gdt_d - gdt_s


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

start_:
  xor ax , ax 
  mov bp , sp
  mov ds , ax
  mov ss , ax
  mov sp , 0x7c00
  
  push dx
  push text
  call puts16
  add sp , 2
  
  ; LOAD EVERYTHING
  pop dx
  mov ah , 2
  mov al , 9
  mov ch , 0 
  mov cl , 2
  xor dh , dh
  mov bx , after
  int 0x13
  push disk_failure
  jc hang_
  add sp , 2
  
  cli

  in al , 0x92
  or al , 2 
  out 0x92 , al 

  lgdt [gdt_e]
  mov eax , cr0 
  or eax , 1
  mov cr0 , eax
  mov ax , NDS
  mov ss , ax
  push NDS
  jmp far NCS:0x8c00

hang_: ; HALT MESSAGE 
  call puts16
  .loop:
  hlt
  jmp .loop
times 510 - ($-$$) db 0
dw 0xAA55
after:
