format binary
org 0x8c00 
jmp _start
use32
fmt_hex:dd 0
putc:dd 0
puts:dd 0
clear:dd 0
string:
db "PROTECTED MODE ACTIVATED" , 0x80
db "SETTING UP INTERRUPT DISPATCH TABLE" , 0x80
db "SETTING UP SYMBOL UTILITY LOADER" , 0x80
db "CALLING CXX KERNEL void(0x10000)(void*(get_ptr)(const char*))" , 0x80
db "HANGING (TURN OF THE MACHINE)" , 0x80
db 0

dq 0x00000000000000000    
interrupt_dispatch_table:
dq 0
interrupt_dispatch_table_entry_count: dd ($ - interrupt_dispatch_table) / 4
_start:
	cli
	pop eax
	mov word ds , ax
	mov word ds , ax
	mov word es , ax
	mov word gs , ax
	; il be lazy for now and hardcode this for now
	mov eax , [0x7e00]
	mov [putc] , eax
	mov eax , [0x7e00 + 4]
	mov [puts] , eax
	mov eax , [0x7e00 + 8]
	mov [fmt_hex] , eax
  mov eax , [0x7e00 + 12]
  mov [clear] , eax
	.a:
  call dword [clear]
  call delay
  push string
  call dword [puts]
  call delay
  jmp .a


A:dd 0
delay:
  mov ecx , -1
  .loop:
  mov [A] , ecx
  mov ecx , [A]
  dec ecx
  test ecx , ecx
  jnz .loop
  ret
