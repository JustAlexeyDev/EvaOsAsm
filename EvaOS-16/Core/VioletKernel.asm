org 0x8000
bits 16

start:
    ; Логирование начала выполнения ядра
    mov si, kernel_start_msg
    call print_string
    call print_newline

    ; Логирование инициализации ядра
    mov si, kernel_init_msg
    call print_string
    call print_newline

    ; Логирование отображения заголовка
    mov si, header_msg
    call print_string
    call print_newline

    ; Логирование перехода в главный цикл
    mov si, main_loop_start_msg
    call print_string
    call print_newline

    ; call start_gui
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
    mov cx, 128 

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
    cmp cx, 128
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
    jc .check_ls  

.help:
    mov si, help_msg
    call print_string
    call print_newline
    ret

.check_ls:
    mov di, cmd_ls
    call compare_strings
    jc .check_mkdir 

.ls:
    mov si, ls_msg
    call print_string
    call print_newline
    ret

.check_mkdir:
    mov di, cmd_mkdir
    call compare_strings
    jc .check_rmdir 

.mkdir:
    mov si, mkdir_msg
    call print_string
    call print_newline
    ret

.check_rmdir:
    mov di, cmd_rmdir
    call compare_strings
    jc .check_send 

.rmdir:
    mov si, rmdir_msg
    call print_string
    call print_newline
    ret

.check_send:
    mov di, cmd_send
    call compare_strings
    jc .check_clear 

.send:
    mov si, input_buffer + 5
    call print_string   
    call print_newline
    jmp main_loop      

.check_clear:
    mov di, cmd_clear
    call compare_strings
    jc .check_restart 

.clear:
    call clear_screen
    ret

.check_restart:
    mov di, cmd_restart
    call compare_strings
    jc .check_regstat 

.restart:
    jmp 0xFFFF:0x0000 

.check_regstat:
    mov di, cmd_regstat
    call compare_strings
    jc .check_gui 

.regstat:
    call print_registers
    ret

.check_gui:
    mov di, cmd_gui
    call compare_strings
    jc .unknown_cmd 

.gui:
    call start_gui
    ret

.unknown_cmd:
    mov si, unknown_cmd_msg
    call print_string
    call print_newline
    ret

compare_strings:
    push si
    push di
    push cx
    
.compare_loop:
    lodsb         
    scasb      
    jne .not_equal 
    
    test al, al  
    jz .equal   

    cmp al, ' '    
    je .equal   
    
    jmp .compare_loop 
    
.equal:
    clc          
    jmp .done
    
.not_equal:
    stc          
    
.done:
    pop cx
    pop di
    pop si
    ret

; Графическая оболочка
start_gui:
    ; Логирование запуска графической оболочки
    mov si, gui_start_msg
    call print_string
    call print_newline

    ; Переключение в графический режим 320x200x256
    mov ax, 0x13
    int 0x10

    ; Отрисовка интерфейса
    call draw_interface

    ; Обработка ввода
    call handle_input

    ; Возврат в текстовый режим
    mov ax, 0x03
    int 0x10
    ret

draw_interface:
    ; Отрисовка фона
    mov ax, 0xA000
    mov es, ax
    xor di, di
    mov cx, 320 * 200
    mov al, 0x1F  ; Синий цвет
    rep stosb

    ; Отрисовка прямоугольника (кнопка)
    mov cx, 100  ; X
    mov dx, 80   ; Y
    mov si, 120  ; Ширина
    mov di, 40   ; Высота
    mov al, 0x2F ; Цвет
    call draw_rectangle

    ; Отрисовка текста
    mov si, gui_msg
    mov cx, 110  ; X
    mov dx, 90   ; Y
    call draw_text

    ret

handle_input:
    ; Ожидание нажатия клавиши
    mov ah, 0x00
    int 0x16

    ; Выход по нажатию ESC
    cmp al, 0x1B
    je .exit

    jmp handle_input

.exit:
    ret

draw_rectangle:
    ; Рисуем прямоугольник
    ; Вход: CX = X, DX = Y, SI = ширина, DI = высота, AL = цвет
    pusha
    mov bx, dx
    add bx, di
.outer_loop:
    cmp dx, bx
    je .done
    push cx
    push si
.inner_loop:
    ; Вычисляем адрес пикселя: di = (dx * 320) + cx
    mov ax, dx      ; ax = dx
    mov bx, 320     ; bx = 320
    mul bx          ; ax = dx * 320
    add ax, cx      ; ax = (dx * 320) + cx
    mov di, ax      ; di = (dx * 320) + cx
    mov [es:di], al
    inc cx
    dec si
    jnz .inner_loop
    pop si
    pop cx
    inc dx
    jmp .outer_loop
.done:
    popa
    ret

draw_text:
    ; Рисуем текст
    ; Вход: SI = строка, CX = X, DX = Y
    pusha
    mov ax, 0xA000
    mov es, ax
.text_loop:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    inc cx
    jmp .text_loop
.done:
    popa
    ret

prompt db 'DISK_MAIN:/>', 0
header_msg db 'Eva-OS VioletKernel - version 0.008.573. Running in 16-bits mode!', 0

unknown_cmd_msg db "Your command is not recognized as an internal or external command or operable program.", 0
help_msg db "Commands: help, ls, mkdir, rmdir, send, clear, restart, regstat, gui", 0
ls_msg db "All dirs:", 0
mkdir_msg db "Creating directory...", 0
rmdir_msg db "Removing directory...", 0
restart_msg db "Restarting system...", 0
gui_msg db "Press ESC to exit", 0

cmd_help db "help", 0
cmd_ls db "ls", 0
cmd_mkdir db "mkdir", 0
cmd_rmdir db "rmdir", 0
cmd_send db "send", 0
cmd_clear db "clear", 0 
cmd_restart db "restart", 0
cmd_regstat db "regstat", 0
cmd_gui db "gui", 0

input_buffer times 128 db 0

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
    jmp start
    ret

print_registers:
    pusha

    mov si, reg_ax_msg
    call print_string
    mov ax, [esp + 14]  
    call print_hex

    mov si, reg_bx_msg
    call print_string
    mov ax, [esp + 12]  
    call print_hex

    mov si, reg_cx_msg
    call print_string
    mov ax, [esp + 10]  
    call print_hex

    mov si, reg_dx_msg
    call print_string
    mov ax, [esp + 8]   
    call print_hex

    mov si, reg_si_msg
    call print_string
    mov ax, [esp + 6]   
    call print_hex

    mov si, reg_di_msg
    call print_string
    mov ax, [esp + 4]  
    call print_hex

    mov si, reg_bp_msg
    call print_string
    mov ax, [esp + 2] 
    call print_hex

    mov si, reg_sp_msg
    call print_string
    mov ax, [esp]      
    call print_hex

    popa
    ret

print_hex:
    push cx
    mov cx, 4
.print_hex_loop:
    rol ax, 4
    push ax
    and al, 0x0F
    cmp al, 9
    jbe .print_hex_digit
    add al, 7
.print_hex_digit:
    add al, '0'
    mov ah, 0x0E
    int 0x10
    pop ax
    loop .print_hex_loop
    pop cx
    ret

reg_ax_msg db "AX: ", 0
reg_bx_msg db " BX: ", 0
reg_cx_msg db " CX: ", 0
reg_dx_msg db " DX: ", 0
reg_si_msg db " SI: ", 0
reg_di_msg db " DI: ", 0
reg_bp_msg db " BP: ", 0
reg_sp_msg db " SP: ", 0

; Новые сообщения для логирования
kernel_start_msg db '[ OK ] [ KERNEL ] - Kernel started successfully', 0
kernel_init_msg db '[ OK ] [ KERNEL ] - Initializing kernel...', 0
main_loop_start_msg db '[ OK ] [ KERNEL ] - Entering main loop...', 0
gui_start_msg db '[ OK ] [ KERNEL ] - Starting GUI...', 0