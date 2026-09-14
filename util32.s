format binary
use32
org 0x7e00
dd putc
dd puts
dd 0  ; terminate
_end_header:
cursor: dw 0, 10     ; cursor[0] = X (0-79), cursor[2] = Y (0-24)
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

    ; 1. Grab the char argument from the cdecl stack structure
    mov ebx, [ebp + 8]       ; Fetch character byte parameter

    ; 2. Fetch current cursor positions
    movzx ecx, word [cursor]     ; ecx = X coordinate
    movzx eax, word [cursor + 2] ; eax = Y coordinate

    ; 3. Calculate Video RAM offset: (Y * 80 + X) * 2
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
    ; 5. Handle Text Mode Cursor Math Increment Tracking
    inc ecx                 ; Move cursor horizontally: X++
    cmp ecx, 80             ; Check if we hit the edge of the line
    jb .save_cursor         ; If X < 80, skip row wrap logic
    
    xor ecx, ecx            ; Reset column tracking: X = 0
    inc eax                 ; Move to next row down: Y++
    cmp eax, 25             ; Check if we went off the bottom of the screen
    jb .save_cursor         ; If Y < 25, continue normally
    
    xor eax, eax            ; Reset screen wrap back to top: Y = 0 (or add scrolling here!)

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
	and al , 0xff
	push eax
	call putc
	add esp , 4
	inc ecx
	jmp .loop
	.end:
	pop ecx
	pop ebp
	ret
