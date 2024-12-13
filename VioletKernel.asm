org 0x8000
bits 16

start:
    mov si, header_msg
    call print_string
    call print_newline
    jmp main_loop

main_loop:
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
    jc .check_ls  ; Если строки не равны, продолжить проверку

.help:
    mov si, help_msg
    call print_string
    call print_newline
    ret

.check_ls:
    mov di, cmd_ls
    call compare_strings
    jc .check_mkdir  ; Если строки не равны, продолжить проверку

.ls:
    mov si, ls_msg
    call print_string
    call print_newline
    ret

.check_mkdir:
    mov di, cmd_mkdir
    call compare_strings
    jc .check_rmdir  ; Если строки не равны, продолжить проверку

.mkdir:
    mov si, mkdir_msg
    call print_string
    call print_newline
    ret

.check_rmdir:
    mov di, cmd_rmdir
    call compare_strings
    jc .check_send  ; Если строки не равны, продолжить проверку

.rmdir:
    mov si, rmdir_msg
    call print_string
    call print_newline
    ret

.check_send:
    mov di, cmd_send
    call compare_strings
    jc .unknown_cmd  ; Если строки не равны, команда неизвестна

.send:
    mov si, input_buffer + 5  ; Пропустить "send "
    call print_string
    call print_newline
    ret

.unknown_cmd:
    mov si, unknown_cmd_msg
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

prompt db 'DISK_A:/>', 0
header_msg db 'Eva-OS VioletKernel - version 0.004.436', 0

unknown_cmd_msg db "Unknown command", 0
help_msg db "Commands: help, ls, mkdir, rmdir, send", 0
ls_msg db "Listing directories...", 0
mkdir_msg db "Creating directory...", 0
rmdir_msg db "Removing directory...", 0

; Команды
cmd_help db "help", 0
cmd_ls db "ls", 0
cmd_mkdir db "mkdir", 0
cmd_rmdir db "rmdir", 0
cmd_send db "send", 0

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