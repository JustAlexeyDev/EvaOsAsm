; bootloader.asm

BITS 16
ORG 0x7C00

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ah, 0x00
    mov al, 0x03
    int 0x10

    mov si, msg
    call print_string

    mov ah, 0x02   
    mov al, 1      
    mov ch, 0      
    mov cl, 2       
    mov dh, 0      
    mov dl, 0      
    mov bx, 0x1000 
    mov es, bx
    xor bx, bx
    int 0x13        

    jmp 0x1000:0x0000

print_string:
    lodsb
    or al, al
    jz done
    mov ah, 0x0E
    int 0x10
    jmp print_string

done:
    ret

msg db 'EvaOS Bootloader', 0

times 510-($-$$) db 0
dw 0xAA55