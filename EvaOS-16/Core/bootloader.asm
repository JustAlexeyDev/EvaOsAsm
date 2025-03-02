org 0x7C00
bits 16

start:
    xor ax, ax         
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00     

    ; Логирование начала загрузки
    call clear_screen
    call set_cursor_top_left
    mov si, start_msg
    call print_string
    call print_newline

    ; Логирование инициализации памяти
    mov si, init_memory_msg
    call print_string
    call print_newline

    ; Логирование настройки стека
    mov si, setup_stack_msg
    call print_string
    call print_newline

    ; Логирование начала чтения диска
    mov si, disk_read_start_msg
    call print_string
    call print_newline

    mov ax, 0x0000
    mov es, ax
    mov bx, 0x8000
    mov ah, 0x02
    mov al, 8
    mov ch, 0  
    mov cl, 2 
    mov dh, 0 
    mov dl, 0x00 
    int 0x13

    jnc disk_read_success
    
    ; Логирование ошибки чтения диска
    mov si, disk_read_error_msg
    call print_string
    call print_newline
    jmp $

disk_read_success:
    ; Логирование успешного чтения диска
    mov si, disk_read_success_msg
    call print_string
    call print_newline

    ; Логирование загрузки ядра
    mov si, kernel_loaded_msg
    call print_string
    call print_newline

    ; Логирование перехода к ядру
    mov si, jump_to_kernel_msg
    call print_string
    call print_newline

    ; Переход к загруженному ядру
    jmp 0x8000  

start_msg db '[ OK ] [ LOADER ] - Starting boot process...', 0
init_memory_msg db '[ OK ] [ LOADER ] - Initializing memory...', 0
setup_stack_msg db '[ OK ] [ LOADER ] - Setting up stack...', 0
disk_read_start_msg db '[ OK ] [ LOADER ] - Starting disk read...', 0
disk_read_success_msg db '[ OK ] [ LOADER ] - Disk read successful', 0
disk_read_error_msg db '[ FAIL ] [ LOADER ] - Disk read error', 0
kernel_loaded_msg db '[ OK ] [ LOADER ] - Kernel loaded successfully', 0
jump_to_kernel_msg db '[ OK ] [ LOADER ] - Jumping to kernel...', 0

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