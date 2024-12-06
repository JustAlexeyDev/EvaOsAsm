org 0x7C00

jmp start

clear_cmd db 'clear', 0
mkdir_cmd db 'mkdir', 0
cd_cmd db 'cd', 0
touch_cmd db 'touch', 0
view_cmd db 'view', 0
del_cmd db 'del', 0

ls_cmd db "list", 0

unknown_cmd_msg db 'Unknown command', 0

mkdir_msg db 'Directory created', 0
cd_msg db 'Directory changed', 0
touch_msg db 'File created', 0
view_msg db 'File viewed', 0
del_msg db 'File or directory deleted', 0


version db '0.1', 0

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

main_loop:
    mov ah, 0x02
    xor bh, bh
    mov dh, 2
    mov dl, 0
    int 0x10

    mov si, prompt
    call print_string

    call read_command
    call process_command
    call print_newline
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

    mov si, unknown_cmd_msg
    call print_string

    call print_newline

    ret

.clear:
    call clear_screen
    call set_cursor_top_left  ; Возвращаем курсор в начало
    ret

.mkdir:
    mov si, mkdir_msg
    call print_string
    ret

.cd:
    mov si, cd_msg
    call print_string
    ret

.touch:
    mov si, touch_msg
    call print_string
    ret

.view:
    mov si, view_msg
    call print_string
    ret

.del:
    mov si, del_msg
    call print_string
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

header_msg db 'Eva-OS VioletKernel - version 0.000.425', 0
prompt db 'VKernel >', 0

command_buffer times 64 db 0

times 510-($-$$) db 0
dw 0xAA55