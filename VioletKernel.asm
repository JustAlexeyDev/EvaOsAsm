org 0x7E00
bits 16

main_loop:
    ; Установка курсора
    mov ah, 0x02
    xor bh, bh
    mov dh, 2
    mov dl, 0
    int 0x10

    ; Вывод приглашения
    mov si, prompt
    call print_string

    ; Чтение команды
    call read_command

    ; Обработка команды
    call process_command

    ; Переход на новую строку
    call print_newline

    ; Повтор цикла
    jmp main_loop

read_command:
    mov bx, 0

.read_char:
    mov ah, 0x00
    int 0x16

    cmp al, 0x0D
    je .end

    mov ah, 0x0E
    int 0x10

    mov [command_buffer + bx], al
    inc bx

    jmp .read_char

.end:
    mov byte [command_buffer + bx], 0
    ret

process_command:
    mov si, command_buffer
    mov di, clear_cmd
    call compare_strings
    je .clear

    mov di, mkdir_cmd
    call compare_strings
    je .mkdir

    mov di, cd_cmd
    call compare_strings
    je .cd

    mov di, touch_cmd
    call compare_strings
    je .touch

    mov di, view_cmd
    call compare_strings
    je .view

    mov di, del_cmd
    call compare_strings
    je .del

    mov di, ls_cmd
    call compare_strings
    je .ls

    mov si, unknown_cmd_msg
    call print_string
    ret

.clear:
    call clear_screen
    call set_cursor_top_left  ; Возвращаем курсор в начало
    call print_newline        ; Переход на следующую строку
    ret

.mkdir:
    mov si, mkdir_msg
    call print_string
    call print_newline        ; Переход на следующую строку
    ret

.cd:
    mov si, cd_msg
    call print_string
    call print_newline        ; Переход на следующую строку
    ret

.touch:
    mov si, touch_msg
    call print_string
    call print_newline        ; Переход на следующую строку
    ret

.view:
    mov si, view_msg
    call print_string
    call print_newline        ; Переход на следующую строку
    ret

.del:
    mov si, del_msg
    call print_string
    call print_newline        ; Переход на следующую строку
    ret

.ls:
    mov si, ls_msg
    call print_string
    call print_newline        ; Переход на следующую строку
    ret

compare_strings:
    cmpsb
    jne .not_equal
    cmp byte [si], 0
    jne compare_strings
    cmp byte [di], 0
    jne compare_strings
    ret

.not_equal:
    xor ax, ax
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

clear_cmd db 'clear', 0
mkdir_cmd db 'mkdir', 0
cd_cmd db 'cd', 0
touch_cmd db 'touch', 0
view_cmd db 'view', 0
del_cmd db 'del', 0
ls_cmd db 'ls', 0

unknown_cmd_msg db 'Unknown command', 0

mkdir_msg db 'Directory created', 0
cd_msg db 'Directory changed', 0
touch_msg db 'File created', 0
view_msg db 'File viewed', 0
del_msg db 'File or directory deleted', 0
ls_msg db 'Listing directory contents', 0

prompt db 'VKernel >', 0

command_buffer times 64 db 0