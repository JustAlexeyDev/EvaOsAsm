[BITS 32]
org 0x8000

start:
    ; Инициализация стека
    mov esp, 0x9000

    ; Вывод сообщения о запуске ядра
    mov esi, kernel_msg
    call print_string
    call print_newline

    ; Основной цикл
    jmp main_loop

kernel_msg db "Kernel started", 0

main_loop:
    ; Вывод приглашения командной строки
    mov esi, prompt
    call print_string

    ; Чтение ввода пользователя
    call read_input

    ; Обработка команды
    call parse_command

    ; Повтор цикла
    jmp main_loop

; Функция чтения ввода пользователя
read_input:
    mov edi, input_buffer
    mov ecx, 64  ; Максимальная длина ввода

.read_char:
    ; Чтение символа с клавиатуры
    mov ah, 0x00
    int 0x16

    ; Если нажат Enter, завершаем ввод
    cmp al, 0x0D
    je .done

    ; Если нажат Backspace, обрабатываем удаление символа
    cmp al, 0x08
    je .backspace

    ; Сохраняем символ в буфер и выводим его на экран
    stosb
    mov ah, 0x0E
    int 0x10
    loop .read_char

.backspace:
    ; Если буфер пуст, игнорируем Backspace
    cmp ecx, 64
    je .read_char

    ; Удаляем символ из буфера и с экрана
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
    ; Завершаем строку нулевым символом
    mov al, 0x00
    stosb
    call print_newline
    ret

; Функция обработки команды
parse_command:
    mov esi, input_buffer

    ; Проверка команды "help"
    mov edi, cmd_help
    call compare_strings
    jc .check_ls

.help:
    mov esi, help_msg
    call print_string
    call print_newline
    ret

.check_ls:
    ; Проверка команды "ls"
    mov edi, cmd_ls
    call compare_strings
    jc .check_mkdir

.ls:
    mov esi, ls_msg
    call print_string
    call print_newline
    ret

.check_mkdir:
    ; Проверка команды "mkdir"
    mov edi, cmd_mkdir
    call compare_strings
    jc .check_rmdir

.mkdir:
    mov esi, mkdir_msg
    call print_string
    call print_newline
    ret

.check_rmdir:
    ; Проверка команды "rmdir"
    mov edi, cmd_rmdir
    call compare_strings
    jc .check_send

.rmdir:
    mov esi, rmdir_msg
    call print_string
    call print_newline
    ret

.check_send:
    ; Проверка команды "send"
    mov edi, cmd_send
    call compare_strings
    jc .check_clear

.send:
    mov esi, input_buffer + 5  ; Пропускаем "send "
    call print_string
    call print_newline
    jmp main_loop

.check_clear:
    ; Проверка команды "clear"
    mov edi, cmd_clear
    call compare_strings
    jc .check_restart

.clear:
    call clear_screen
    ret

.check_restart:
    ; Проверка команды "restart"
    mov edi, cmd_restart
    call compare_strings
    jc .check_regstat

.restart:
    ; Перезагрузка системы
    jmp 0xFFFF:0x0000

.check_regstat:
    ; Проверка команды "regstat"
    mov edi, cmd_regstat
    call compare_strings
    jc .unknown_cmd

.regstat:
    ; Вывод регистров
    call print_registers
    ret

.unknown_cmd:
    ; Неизвестная команда
    mov esi, unknown_cmd_msg
    call print_string
    call print_newline
    ret

; Функция сравнения строк
compare_strings:
    push esi
    push edi
    push ecx

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
    pop ecx
    pop edi
    pop esi
    ret

; Функция вывода строки
print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string

.done:
    ret

; Функция вывода новой строки
print_newline:
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    ret

; Функция очистки экрана
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

; Функция вывода регистров
print_registers:
    pusha

    mov esi, reg_ax_msg
    call print_string
    mov eax, [esp + 28]
    call print_hex

    mov esi, reg_bx_msg
    call print_string
    mov eax, [esp + 24]
    call print_hex

    mov esi, reg_cx_msg
    call print_string
    mov eax, [esp + 20]
    call print_hex

    mov esi, reg_dx_msg
    call print_string
    mov eax, [esp + 16]
    call print_hex

    mov esi, reg_si_msg
    call print_string
    mov eax, [esp + 12]
    call print_hex

    mov esi, reg_di_msg
    call print_string
    mov eax, [esp + 8]
    call print_hex

    mov esi, reg_bp_msg
    call print_string
    mov eax, [esp + 4]
    call print_hex

    mov esi, reg_sp_msg
    call print_string
    mov eax, [esp]
    call print_hex

    popa
    ret

; Функция вывода числа в шестнадцатеричном формате
print_hex:
    push ecx
    mov ecx, 8
.print_hex_loop:
    rol eax, 4
    push eax
    and al, 0x0F
    cmp al, 9
    jbe .print_hex_digit
    add al, 7
.print_hex_digit:
    add al, '0'
    mov ah, 0x0E
    int 0x10
    pop eax
    loop .print_hex_loop
    pop ecx
    ret

; Данные
prompt db 'DISK_A:/>', 0
header_msg db 'Eva-OS VioletKernel - version 0.004.438', 0

unknown_cmd_msg db "Unknown command", 0
help_msg db "Commands: help, ls, mkdir, rmdir, send, clear, restart, regstat", 0
ls_msg db "All dirs:", 0
mkdir_msg db "Creating directory...", 0
rmdir_msg db "Removing directory...", 0
restart_msg db "Restarting system...", 0

cmd_help db "help", 0
cmd_ls db "ls", 0
cmd_mkdir db "mkdir", 0
cmd_rmdir db "rmdir", 0
cmd_send db "send", 0
cmd_clear db "clear", 0
cmd_restart db "restart", 0
cmd_regstat db "regstat", 0

input_buffer times 64 db 0

reg_ax_msg db "EAX: ", 0
reg_bx_msg db " EBX: ", 0
reg_cx_msg db " ECX: ", 0
reg_dx_msg db " EDX: ", 0
reg_si_msg db " ESI: ", 0
reg_di_msg db " EDI: ", 0
reg_bp_msg db " EBP: ", 0
reg_sp_msg db " ESP: ", 0