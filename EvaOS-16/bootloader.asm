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

    mov ax, 0x0000
    mov es, ax
    mov bx, 0x8000
    mov ah, 0x02
    mov al, 1 
    mov ch, 0  
    mov cl, 2 
    mov dh, 0 
    mov dl, 0x00 
    int 0x13

    jnc success
    ; Disk read failed
    mov si, error_msg
    call print_string
    call print_newline
    jmp $

success:
    mov si, success_msg
    call print_string
    call print_newline
    jmp 0x8000  

success_msg db 'Disk read success', 0
error_msg db 'Disk read error', 0

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

times 510-($-$$) db 0
dw 0xAA55