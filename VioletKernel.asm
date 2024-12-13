org 0x8000
bits 16

start:
    mov si, header_msg
    call print_string
    call print_newline
    jmp main_loop

main_loop:

    ; mov si, kernelloaded_msg
    ; call print_string
    ; call print_newline

    call print_newline

    mov si, prompt
    call print_string

    call read_input
    call parse_command

    jmp main_loop

read_input:
    mov di, input_buffer
    mov cx, 64 

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
    cmp cx, 64
    je .read_char
    dec di
    inc cx
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
    call print_newline
    ret

parse_command:
    mov si, input_buffer
    mov di, cmd_help
    call compare_strings
    jnc .help  ; Если строки равны, перейти к обработке команды help

    mov di, cmd_ls
    call compare_strings
    jnc .ls    ; Если строки равны, перейти к обработке команды ls

    mov di, cmd_mkdir
    call compare_strings
    jnc .mkdir ; Если строки равны, перейти к обработке команды mkdir

    mov di, cmd_rmdir
    call compare_strings
    jnc .rmdir ; Если строки равны, перейти к обработке команды rmdir

    ; Если команда не найдена
    mov si, unknown_cmd_msg
    call print_string
    call print_newline
    ret

.help:
    mov si, help_msg
    call print_string
    call print_newline
    ret

.ls:
    mov si, ls_msg
    call print_string
    call print_newline
    ret

.mkdir:
    mov si, mkdir_msg
    call print_string
    call print_newline
    ret

.rmdir:
    mov si, rmdir_msg
    call print_string
    call print_newline
    ret

compare_strings:
    cmpsb
    jne .not_equal
    cmp byte [di], 0
    jne compare_strings
    clc
    ret

.not_equal:
    stc
    ret

prompt db 'USER INTERPUT >', 0
header_msg db 'Eva-OS VioletKernel - version 0.003.435', 0
kernelloaded_msg db "VioletKernel 16 BITS loaded", 0

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