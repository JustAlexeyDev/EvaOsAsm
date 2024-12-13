org 0x8000
bits 16

main_loop:
    mov si, header_msg
    call print_string
    call print_newline

    mov si, kernelloaded_msg
    call print_string
    call print_newline

    call print_newline

    mov si, prompt
    call print_string

    call read_command

    call process_command

    call print_newline


    ; ; DEBUG MODE
    ; call print_registers
    ; call print_newline
    ; DEBUG MODE

    jmp main_loop

.clear:
    call set_cursor_top_left 
    ret

set_cursor_bottom:
    mov ah, 0x02
    xor bh, bh
    mov dh, 24 
    mov dl, 0   
    int 0x10
    ret

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
    call print_newline
    call set_cursor_top_left 
    ret

.mkdir:
    mov si, mkdir_msg
    call print_string
    call print_newline       
    ret

.cd:
    mov si, cd_msg
    call print_string
    call print_newline        
    ret

.touch:
    mov si, touch_msg
    call print_string
    call print_newline       
    ret

.view:
    mov si, view_msg
    call print_string
    call print_newline       
    ret

.del:
    mov si, del_msg
    call print_string
    call print_newline       
    ret

.ls:
    mov si, ls_msg
    call print_string
    call print_newline        
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

; DEBUG MODE

;  print_registers:
;     ; Вывод значения регистра AX
;     mov si, ax_msg
;     call print_string
;     mov ax, ax
;     call print_hex
;     call print_newline

;     ; Вывод значения регистра BX
;     mov si, bx_msg
;     call print_string
;     mov ax, bx
;     call print_hex
;     call print_newline

;     ; Вывод значения регистра CX
;     mov si, cx_msg
;     call print_string
;     mov ax, cx
;     call print_hex
;     call print_newline

;     ; Вывод значения регистра DX
;     mov si, dx_msg
;     call print_string
;     mov ax, dx
;     call print_hex
;     call print_newline

;     ; Вывод значения регистра SI
;     mov si, si_msg
;     call print_string
;     mov ax, si
;     call print_hex
;     call print_newline

;     ; Вывод значения регистра DI
;     mov si, di_msg
;     call print_string
;     mov ax, di
;     call print_hex
;     call print_newline

;     ; Вывод значения регистра DS
;     mov si, ds_msg
;     call print_string
;     mov ax, ds
;     call print_hex
;     call print_newline

;     ; Вывод значения регистра ES
;     mov si, es_msg
;     call print_string
;     mov ax, es
;     call print_hex
;     call print_newline

;     ; Вывод значения регистра SS
;     mov si, ss_msg
;     call print_string
;     mov ax, ss
;     call print_hex
;     call print_newline

;     ; Вывод значения регистра SP
;     mov si, sp_msg
;     call print_string
;     mov ax, sp
;     call print_hex
;     call print_newline

;     ret

; ax_msg db 'AX: ', 0
; bx_msg db 'BX: ', 0
; cx_msg db 'CX: ', 0
; dx_msg db 'DX: ', 0
; si_msg db 'SI: ', 0
; di_msg db 'DI: ', 0
; ds_msg db 'DS: ', 0
; es_msg db 'ES: ', 0
; ss_msg db 'SS: ', 0
; sp_msg db 'SP: ', 0

; print_hex:
;     pusha
;     mov cx, 4  
; .loop:
;     rol ax, 4 
;     mov bx, ax
;     and bx, 0x000F 
;     mov bl, [hex_chars + bx] 
;     mov ah, 0x0E
;     int 0x10
;     loop .loop
;     popa
;     ret

; hex_chars db '0123456789ABCDEF'

; ALL COMMANDS

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

prompt db 'USER INTERPUT >', 0

header_msg db 'Eva-OS VioletKernel - version 0.000.431', 0
kernelloaded_msg db "VioletKernel loaded", 0
command_buffer times 128 db 0