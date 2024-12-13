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

    ; Загрузка сегмента GDT
    lgdt [gdt_descriptor]

    ; Переход в защищенный режим
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; Переход в 32-битный режим
    jmp 0x08:protected_mode

bits 32
protected_mode:
    ; Инициализация сегментных регистров
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Чтение ядра с диска
    mov eax, 0x0000
    mov es, ax
    mov ebx, 0x8000
    mov ah, 0x02
    mov al, 1 
    mov ch, 0  
    mov cl, 2 
    mov dh, 0 
    mov dl, 0x00 
    int 0x13

    jnc success
    ; Ошибка чтения диска
    mov esi, error_msg
    call print_string_32
    jmp $

success:
    mov esi, success_msg
    call print_string_32
    jmp 0x8000  ; Переход к ядру

error_msg db 'Disk read error', 0
success_msg db 'Disk read success', 0

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

print_string_32:
    mov ah, 0x0E
.loop:
    lodsb
    or al, al
    jz .done
    int 0x10
    jmp .loop
.done:
    ret

; GDT
gdt_start:
    ; Нулевой дескриптор
    dd 0x00000000
    dd 0x00000000

    ; Дескриптор кода (32-битный плоский режим)
    dd 0x0000FFFF
    dd 0x00CF9A00

    ; Дескриптор данных (32-битный плоский режим)
    dd 0x0000FFFF
    dd 0x00CF9200

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

times 510-($-$$) db 0
dw 0xAA55