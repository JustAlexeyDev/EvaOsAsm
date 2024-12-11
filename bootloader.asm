org 0x7C00
bits 16

start:
    xor ax, ax         
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00     

    call clear_screen
    call set_cursor_top_left

    mov si, header_msg
    call print_string
    call print_newline

    jmp 0x0000:0x8000 

; Остальной код...

clear_screen:
    mov ax, 0x0600
    xor cx, cx
    mov dx, 0x184F
    mov bh, 0x07
    int 0x10
    ret

set_cursor_top_left:
    mov ah, 0x02
    xor bh, bh
    xor dx, dx
    int 0x10
    ret

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string

.done:
    ret

print_newline:
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    ret

header_msg db 'Eva-OS VioletKernel - version 0.000.427', 0

times 510-($-$$) db 0
dw 0xAA55