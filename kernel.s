format binary
org 0x8c00 
jmp _start
use32
fmt_hex:dd 0
putc:dd 0
puts:dd 0
string:
db "32BIT MODE ACTIVATED" , 0x80 
db "SETTING UP INTERRUPT DISPATCH TABLE" , 0x80
db "CALLING"
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
	push string
	call dword [puts]
	sub esp , 4
	jmp $
	
