format binary
org 0x8c00 
jmp _start
use32
get_ptr:dd 0
putc:dd 0
puts:dd 0
string:db "32BIT MODE ACTIVATED" , 0

_start:
	cli
	pop eax
	mov ds , ax
	mov ss , ax
	mov ds , ax
	mov es , ax
	mov gs , ax
	; il be lazy for now and hardcode this for now
	mov eax , [0x7e00 + 4]
	mov [puts] , eax
	push string
	call dword [puts]
	sub esp , 4
	jmp $
	
