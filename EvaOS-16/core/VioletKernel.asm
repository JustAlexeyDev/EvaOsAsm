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
    ; jc .check_ls  

.help:
    mov si, help_msg
    call print_string
    call print_newline
    ret

; .check_ls:
;     mov di, cmd_ls
;     call compare_strings
;     jc .check_mkdir 

.ls:
    mov si, ls_msg
    call print_string
    call print_newline
    ret

; .check_mkdir:
;     mov di, cmd_mkdir
;     call compare_strings
;     jc .check_rmdir 

.mkdir:
    mov si, mkdir_msg
    call print_string
    call print_newline
    ret

; .check_rmdir:
;     mov di, cmd_rmdir
;     call compare_strings
;     jc .check_send 

.rmdir:
    mov si, rmdir_msg
    call print_string
    call print_newline
    ret

; .check_send:
;     mov di, cmd_send
;     call compare_strings
;     jc .check_clear 

.send:
    mov si, input_buffer + 5 
    call print_string
    call print_newline
    ret

; .check_clear:
;     mov di, cmd_clear
;     call compare_strings
;     jc .check_regstat 

.clear:
    call clear_screen
    ret

; .check_regstat:
;     mov di, cmd_regstat
;     call compare_strings
;     jc .unknown_cmd 

; .regstat:
;     ; call print_registers
;     ret

.unknown_cmd:
    mov si, unknown_cmd_msg
    call print_string
    call print_newline
    ret

compare_strings:
    mov cx, 0xffff 

.compare_loop:
    lodsb        
    scasb          
    jne .not_equal 

    test al, al    
    jz .equal      

    loop .compare_loop  

.equal:
    clc            
    ret

.not_equal:
    stc           
    ret

prompt db 'DISK_A:/>', 0
header_msg db 'Eva-OS VioletKernel - version 0.005.440', 0

unknown_cmd_msg db "Unknown command", 0
help_msg db "Commands: help, ls, mkdir, rmdir, send, clear, regstat", 0
ls_msg db "Listing directories...", 0
mkdir_msg db "Creating directory...", 0
rmdir_msg db "Removing directory...", 0

; Команды
cmd_help db "help", 0
cmd_ls db "ls", 0
cmd_mkdir db "mkdir", 0
cmd_rmdir db "rmdir", 0
cmd_send db "send", 0
cmd_clear db "clear", 0 
; cmd_regstat db "regstat", 0  

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
    mov bh, 0x07    
    mov cx, 0x0000 
    mov dx, 0x184F 
    int 0x10       
    mov ah, 0x02   
    mov bh, 0x00   
    mov dx, 0x0000 
    int 0x10        
    ret

; ; Функция для вывода значений регистров
; print_registers:
;     call print_newline
;     mov si, reg_ax_msg
;     call print_string
;     mov ax, [reg_ax]
;     call print_hex
;     call print_newline

;     mov si, reg_bx_msg
;     call print_string
;     mov ax, [reg_bx]
;     call print_hex
;     call print_newline

;     mov si, reg_cx_msg
;     call print_string
;     mov ax, [reg_cx]
;     call print_hex
;     call print_newline

;     mov si, reg_dx_msg
;     call print_string
;     mov ax, [reg_dx]
;     call print_hex
;     call print_newline

;     mov si, reg_si_msg
;     call print_string
;     mov ax, [reg_si]
;     call print_hex
;     call print_newline

;     mov si, reg_di_msg
;     call print_string
;     mov ax, [reg_di]
;     call print_hex
;     call print_newline

;     mov si, reg_bp_msg
;     call print_string
;     mov ax, [reg_bp]
;     call print_hex
;     call print_newline

;     mov si, reg_sp_msg
;     call print_string
;     mov ax, [reg_sp]
;     call print_hex
;     call print_newline

;     mov si, reg_cs_msg
;     call print_string
;     mov ax, [reg_cs]
;     call print_hex
;     call print_newline

;     mov si, reg_ds_msg
;     call print_string
;     mov ax, [reg_ds]
;     call print_hex
;     call print_newline

;     mov si, reg_es_msg
;     call print_string
;     mov ax, [reg_es]
;     call print_hex
;     call print_newline

;     mov si, reg_ss_msg
;     call print_string
;     mov ax, [reg_ss]
;     call print_hex
;     call print_newline

;     mov si, reg_flags_msg
;     call print_string
;     mov ax, [reg_flags]
;     call print_hex
;     call print_newline
;     ret

; ; Функция для вывода 16-битного числа в шестнадцатеричном формате
; print_hex:
;     pusha
;     mov cx, 4  ; 4 символа для 16-битного числа
; .loop:
;     rol ax, 4  ; Сдвигаем влево на 4 бита
;     push ax
;     and al, 0x0F  ; Берем младшие 4 бита
;     cmp al, 0x0A
;     jl .digit
;     add al, 'A' - 0x0A - '0'
; .digit:
;     add al, '0'
;     mov ah, 0x0E
;     int 0x10
;     pop ax
;     loop .loop
;     popa
;     ret

; ; Сообщения для регистров
; reg_ax_msg db "AX: ", 0
; reg_bx_msg db "BX: ", 0
; reg_cx_msg db "CX: ", 0
; reg_dx_msg db "DX: ", 0
; reg_si_msg db "SI: ", 0
; reg_di_msg db "DI: ", 0
; reg_bp_msg db "BP: ", 0
; reg_sp_msg db "SP: ", 0
; reg_cs_msg db "CS: ", 0
; reg_ds_msg db "DS: ", 0
; reg_es_msg db "ES: ", 0
; reg_ss_msg db "SS: ", 0
; reg_flags_msg db "FLAGS: ", 0

; ; Значения регистров (заглушки, которые можно заменить на реальные значения)
; reg_ax dw 0x1234
; reg_bx dw 0x5678
; reg_cx dw 0x9ABC
; reg_dx dw 0xDEF0
; reg_si dw 0x1122
; reg_di dw 0x3344
; reg_bp dw 0x5566
; reg_sp dw 0x7788
; reg_cs dw 0x99AA
; reg_ds dw 0xBBCC
; reg_es dw 0xDDEE
; reg_ss dw 0xFF00
; reg_flags dw 0x0002  ; Пример значения флагов