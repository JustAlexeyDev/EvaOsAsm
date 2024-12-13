org 0x8000
bits 32

main_loop:
    mov esi, header_msg
    call print_string_32
    call print_newline_32

    mov esi, kernelloaded_msg
    call print_string_32
    call print_newline_32

    call print_newline_32

    mov esi, prompt
    call print_string_32

    ; Считываем ввод пользователя
    call read_input_32

    ; Анализируем команду
    call parse_command_32

    jmp main_loop

read_input_32:
    mov edi, input_buffer
    mov ecx, 64 

.read_char:
    mov ah, 0x00
    int 0x16  

    cmp al, 0x0D
    je .done

    cmp al, 0x08 
    je .backspace

    stosb      
    mov ah, 0x0E
    int 0x10   
    loop .read_char

.backspace:
    cmp ecx, 64
    je .read_char
    dec edi
    inc ecx
    mov ah, 0x0E
    mov al, 0x08
    int 0x10   
    mov al, ' '
    int 0x10
    mov al, 0x08
    int 0x10
    jmp .read_char

.done:
    mov al, 0x00
    stosb        
    call print_newline_32
    ret

; Функция для анализа команды
parse_command_32:
    mov esi, input_buffer
    mov edi, cmd_help
    call compare_strings_32
    jc .help

    mov edi, cmd_ls
    call compare_strings_32
    jc .ls

    mov edi, cmd_mkdir
    call compare_strings_32
    jc .mkdir

    mov edi, cmd_rmdir
    call compare_strings_32
    jc .rmdir

    ; Если команда не найдена
    mov esi, unknown_cmd_msg
    call print_string_32
    call print_newline_32
    ret

.help:
    mov esi, help_msg
    call print_string_32
    call print_newline_32
    ret

.ls:
    mov esi, ls_msg
    call print_string_32
    call print_newline_32
    ret

.mkdir:
    call create_directory
    ret

.rmdir:
    mov esi, rmdir_msg
    call print_string_32
    call print_newline_32
    ret

compare_strings_32:
    cmpsb
    jne .not_equal
    cmp byte [edi], 0
    jne compare_strings_32
    clc
    ret

.not_equal:
    stc
    ret

prompt db 'USER INTERPUT >', 0
header_msg db 'Eva-OS VioletKernel - version 0.002.432', 0
kernelloaded_msg db "VioletKernel loaded", 0

unknown_cmd_msg db "Unknown command", 0
help_msg db "Commands: help, ls, mkdir, rmdir", 0
ls_msg db "Listing directories...", 0
mkdir_msg db "Creating directory...", 0
rmdir_msg db "Removing directory...", 0

; Команды
cmd_help db "help", 0
cmd_ls db "ls", 0
cmd_mkdir db "mkdir", 0
cmd_rmdir db "rmdir", 0

input_buffer times 64 db 0

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

print_newline_32:
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    ret

clear_screen_32:
    mov ax, 0x0600
    xor cx, cx
    mov dx, 0x184F
    mov bh, 0x07
    int 0x10
    ret

set_cursor_top_left_32:
    mov ah, 0x02
    xor bh, bh
    xor dx, dx
    int 0x10
    ret

; Функция для создания директории
create_directory:
    mov esi, mkdir_msg
    call print_string_32
    call print_newline_32
    ret

