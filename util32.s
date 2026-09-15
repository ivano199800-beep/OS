format binary
use32
org 0x7e00
dd putc
dd puts
dd format_hex
dd clear
dd 0  ; terminate
_end_header:
format_hex:
  mov eax , [esp + 4]
  and eax , 0xf
  add eax , '0'
  cmp eax , '9'
  jbe .done
  add eax , 7
  .done:
  ret
clear:
  push eax
  push ecx
  push ebx
  xor eax , eax
  mov ebx , 0xb8000
  mov ecx , 25*80*2
  .loop:
  dec ecx
  mov byte [ebx + ecx] , al
  test ecx , ecx
  jnz .loop
  pop ebx
  pop ecx
  pop eax
  ret
cursor: dw 0, 0     ; cursor[0] = X (0-79), cursor[2] = Y (0-24)
putc:
    jmp .send
    .special:
    push ebx
    cmp bl , 0x80
    jne .newline
    inc eax
    xor ecx , ecx
    dec ecx
    jmp .dend
    .newline:
    .dend:
    pop ebx
    jmp .skip
    .send:
    push ebp
    mov ebp, esp
    push ebx
    push ecx
    push edx

    
    mov ebx, [ebp + 8]       ; Fetch character byte parameter

    
    movzx ecx, word [cursor]     ; ecx = X coordinate
    movzx eax, word [cursor + 2] ; eax = Y coordinate

    
    imul edx, eax, 80       ; edx = Y * 80
    add edx, ecx            ; edx = (Y * 80) + X
    shl edx, 1              ; edx = edx * 2 (each character cell is 2 bytes)
    add edx, 0x000B8000     ; edx now points exactly to the target screen address
    test bl , 0x80
    jnz .special
    ; 4. Combine character value with white text attribute flag color
    mov bh, 0x0F            ; White font text color on black background
    mov [edx], bx           ; Write both character and color attribute to screen VRAM
    .skip:
    
    inc ecx        
    cmp ecx, 80    
    jb .save_cursor
    
    xor ecx, ecx   
    inc eax            
    cmp eax, 25        
    jb .save_cursor        
    xor eax, eax
    call clear

.save_cursor:
    mov [cursor], cx
    mov [cursor + 2], ax

    pop edx
    pop ecx
    pop ebx
    pop ebp
    ret

puts:
	push ebp
	push ecx
	mov ecx , [esp + 12]
	.loop:
	mov al , [ecx]
	test al , al
	jz .end
	and eax , 0xff
	push eax
	call putc
	add esp , 4
	inc ecx
	jmp .loop
	.end:
	pop ecx
	pop ebp
	ret
