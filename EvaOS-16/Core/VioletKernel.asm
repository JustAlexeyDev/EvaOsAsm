org 0x8000
bits 16

start:
    ; Инициализация сегментов
    mov ax, cs
    mov ds, ax
    mov es, ax
    
    ; Инициализация стека
    mov ss, ax
    mov sp, 0xFFFE
    
    ; Очистка экрана
    call clear_screen
    
    ; Приветственное сообщение
    mov si, welcome_msg
    call print_string
    call print_newline
    
    jmp main_loop

; #################### ГЛАВНЫЙ ЦИКЛ ####################
main_loop:
    mov si, prompt
    call print_string
    
    call read_input
    call parse_command
    
    jmp main_loop



; ################### GUI ###############################
start_gui:
    ; Переключение в графический режим 320x200 256 цветов
    mov ax, 0x13
    int 0x10
    
    ; Установка сегмента видеопамяти
    mov ax, 0xA000
    mov es, ax
    
    ; Рисуем фон (синий)
    call draw_background
    
    ; Рисуем кнопки
    call draw_buttons
    
    ; Основной цикл GUI
.gui_loop:
    ; Ожидаем нажатия клавиши
    mov ah, 0x00
    int 0x16
    
    ; Проверка на Escape для выхода
    cmp al, 0x1B
    je .exit_gui
    
    ; Проверка на F1 (Help)
    cmp al, 0x3B  ; Scan code F1
    je .help_pressed
    
    ; Проверка на F2 (Reboot)
    cmp al, 0x3C  ; Scan code F2
    je .reboot_pressed
    
    jmp .gui_loop

.help_pressed:
    call show_help_message
    jmp .gui_loop

.reboot_pressed:
    call do_reboot
    jmp .gui_loop

.exit_gui:
    ; Возврат в текстовый режим
    mov ax, 0x03
    int 0x10
    ret

draw_background:
    ; Рисуем градиентный фон
    xor di, di
    mov cx, 320
    mov dx, 200
    mov al, 0x01  ; Начальный цвет (синий)
.y_loop:
    push cx
    mov cx, 320
.x_loop:
    mov [es:di], al
    inc di
    loop .x_loop
    inc al        ; Изменяем цвет для градиента
    pop cx
    dec dx
    jnz .y_loop
    ret

draw_buttons:
    ; Кнопка 1 (Help)
    mov cx, 50    ; X
    mov dx, 30    ; Y
    mov si, 100   ; Ширина
    mov di, 30    ; Высота
    mov al, 0x04  ; Красный
    call draw_button
    mov si, btn_help_text
    mov cx, 70
    mov dx, 40
    call draw_text
    
    ; Кнопка 2 (Reboot)
    mov cx, 50
    mov dx, 80
    mov si, 100
    mov di, 30
    mov al, 0x02  ; Зеленый
    call draw_button
    mov si, btn_reboot_text
    mov cx, 70
    mov dx, 90
    call draw_text
    
    ret

draw_button:
    ; Рисуем прямоугольник с рамкой
    pusha
    mov bx, dx
    add bx, di
    
    ; Внешняя рамка (темнее)
    mov ah, al
    sub ah, 0x02
    jnc .no_underflow
    mov ah, 0x00

.no_underflow:
    
.outer_loop:
    cmp dx, bx
    je .done
    push cx
    push si
.inner_loop:
    ; Проверка границ для рамки
    mov [es:di], ah  ; Рамка
    inc cx
    dec si
    jnz .inner_loop
    pop si
    pop cx
    inc dx
    jmp .outer_loop
    
    ; Внутренняя заливка
    add cx, 2
    add dx, 2
    sub si, 4
    sub di, 4
    mov bx, dx
    add bx, di
    sub bx, 4
.fill_loop:
    cmp dx, bx
    jg .done
    push cx
    push si
.fill_inner:
    mov [es:di], al
    inc di
    dec si
    jnz .fill_inner
    pop si
    pop cx
    inc dx
    jmp .fill_loop
    
.done:
    popa
    ret

draw_gui_text:
    ; Рисуем текст в графическом режиме
    pusha
    mov bx, dx
    mov dx, cx
.text_loop:
    lodsb
    or al, al
    jz .done
    
    ; Сохраняем позицию
    push si
    push dx
    push bx
    
    ; Установка курсора
    mov ah, 0x02
    xor bh, bh
    mov dh, bl
    mov dl, dl
    int 0x10
    
    ; Вывод символа
    mov ah, 0x0E
    mov bl, 0x0F  ; Белый цвет
    int 0x10
    
    ; Восстанавливаем позицию
    pop bx
    pop dx
    pop si
    
    inc dx
    jmp .text_loop

    .done:
    popa
    ret

draw_text:
    ; Рисуем текст в графическом режиме
    ; Вход: SI=текст, CX=X, DX=Y
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

show_help_message:
    ; Временный переход в текстовый режим
    pusha
    mov ax, 0x03
    int 0x10
    
    mov si, gui_help_full_msg
    call print_string
    
    ; Ждем любую клавишу
    mov ah, 0x00
    int 0x16
    
    ; Возврат в графический режим
    mov ax, 0x13
    int 0x10
    popa
    ret

do_reboot:
    mov si, gui_reboot_msg
    call draw_gui_text
    
    ; Задержка
    mov cx, 0xFFFF
.delay:
    nop
    loop .delay
    
    ; Перезагрузка
    int 0x19
    ret

; #################### ФУНКЦИЯ ЧТЕНИЯ ВВОДА ####################
read_input:
    mov di, input_buffer
    mov cx, 128
    xor bx, bx
    
.read_char:
    mov ah, 0x00
    int 0x16
    
    cmp al, 0x0D       ; Enter
    je .done
    
    cmp al, 0x08       ; Backspace
    je .backspace
    
    cmp bx, cx         ; Проверка переполнения буфера
    jge .read_char
    
    stosb
    inc bx
    mov ah, 0x0E
    int 0x10
    jmp .read_char
    
.backspace:
    test bx, bx
    jz .read_char
    dec di
    dec bx
    mov ah, 0x0E
    mov al, 0x08
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 0x08
    int 0x10
    jmp .read_char
    
.done:
    mov al, 0
    stosb
    call print_newline
    ret

; #################### ФУНКЦИЯ РАЗБОРА КОМАНД ####################
parse_command:
    mov si, input_buffer
    
    ; Пропуск пустых команд
    cmp byte [si], 0
    je .empty
    
    ; Удаление пробелов в начале
.trim_loop:
    lodsb
    cmp al, ' '
    je .trim_loop
    dec si
    
    ; Сравнение команд
    mov di, cmd_help
    call strcmp
    jnc .help
    
    mov di, cmd_ls
    call strcmp
    jnc .ls
    
    mov di, cmd_cat
    call strcmp
    jnc .cat
    
    mov di, cmd_echo
    call strcmp
    jnc .echo
    
    mov di, cmd_clear
    call strcmp
    jnc .clear
    
    mov di, cmd_reboot
    call strcmp
    jnc .reboot
    
    mov di, cmd_meminfo
    call strcmp
    jnc .meminfo
    
    mov di, cmd_date
    call strcmp
    jnc .date

    mov di, cmd_gui 
    call strcmp
    jnc .gui
    
    ; Неизвестная команда
    mov si, unknown_cmd_msg
    call print_string
    call print_newline
    ret
    
.empty:
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
    
    mov si, ls_dummy_files
    call print_string
    call print_newline
    ret
    
.cat:
    ; Проверка наличия имени файла
    mov si, input_buffer + 4
    cmp byte [si], 0
    je .cat_no_file
    
    mov di, dummy_filename
    call strcmp
    jnc .cat_file
    
.cat_no_file:
    mov si, file_not_found_msg
    call print_string
    call print_newline
    ret
    
.cat_file:
    mov si, dummy_file_content
    call print_string
    call print_newline
    ret
    
.echo:
    mov si, input_buffer + 5
    cmp byte [si], 0
    je .echo_empty
    
    call print_string
    call print_newline
    ret
    
.echo_empty:
    call print_newline
    ret
    
.clear:
    call clear_screen
    ret
    
.reboot:
    mov si, reboot_msg
    call print_string
    call print_newline
    
    ; Задержка перед перезагрузкой
    mov cx, 0xFFFF
.delay_loop:
    nop
    loop .delay_loop
    
    ; Перезагрузка через BIOS
    int 0x19
    ret
    
.meminfo:
    mov si, meminfo_msg
    call print_string
    
    ; Получаем и выводим размер памяти
    int 0x12
    call print_dec
    mov si, mem_kb_msg
    call print_string
    call print_newline
    ret
    
.date:
    ; Получаем дату от BIOS
    mov ah, 0x04
    int 0x1A
    
    ; Выводим дату (ДД/ММ/ГГГГ)
    mov al, dl      ; День
    call print_bcd
    mov al, '/'
    call print_char
    
    mov al, dh      ; Месяц
    call print_bcd
    mov al, '/'
    call print_char
    
    mov al, ch      ; Год (старшие разряды)
    call print_bcd
    mov al, cl      ; Год (младшие разряды)
    call print_bcd
    
    call print_newline
    
    ; Получаем время от BIOS
    mov ah, 0x02
    int 0x1A
    
    ; Выводим время (ЧЧ:ММ:СС)
    mov al, ch      ; Часы
    call print_bcd
    mov al, ':'
    call print_char
    
    mov al, cl      ; Минуты
    call print_bcd
    mov al, ':'
    call print_char
    
    mov al, dh      ; Секунды
    call print_bcd
    
    call print_newline
    ret

.gui:
    call start_gui
    ret

; #################### ФУНКЦИЯ СРАВНЕНИЯ СТРОК ####################
strcmp:
    pusha
.compare_loop:
    lodsb           ; Берем символ из SI
    mov bl, [di]    ; Берем символ из DI
    inc di
    
    cmp al, bl
    jne .not_equal
    
    test al, al     ; Проверка конца строки
    jz .equal
    
    jmp .compare_loop
    
.equal:
    popa
    clc             ; CF = 0 - строки равны
    ret
    
.not_equal:
    popa
    stc             ; CF = 1 - строки разные
    ret

; #################### ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ####################
print_string:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

print_char:
    mov ah, 0x0E
    int 0x10
    ret

print_newline:
    mov al, 0x0D
    call print_char
    mov al, 0x0A
    call print_char
    ret

clear_screen:
    mov ax, 0x0600
    xor cx, cx
    mov dx, 0x184F
    mov bh, 0x07
    int 0x10
    
    ; Установка курсора в начало
    mov ah, 0x02
    xor bh, bh
    xor dx, dx
    int 0x10
    ret

print_hex:
    push cx
    mov cx, 4
.hex_loop:
    rol ax, 4
    push ax
    and al, 0x0F
    add al, '0'
    cmp al, '9'
    jbe .print_digit
    add al, 7
.print_digit:
    call print_char
    pop ax
    loop .hex_loop
    pop cx
    ret

print_dec:
    pusha
    xor cx, cx
    mov bx, 10
.div_loop:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz .div_loop
    
.print_loop:
    pop ax
    add al, '0'
    call print_char
    loop .print_loop
    popa
    ret

print_bcd:
    push ax
    shr al, 4
    add al, '0'
    call print_char
    pop ax
    and al, 0x0F
    add al, '0'
    call print_char
    ret

; #################### ДАННЫЕ ####################
welcome_msg db 'Eva-OS - 0.008.573,  VioletKernel - ALPHA ', 0
prompt db 'V/:>_: ', 0
unknown_cmd_msg db 'Error: Command not reconized. Type "help" for display all commands.', 0
help_msg db 'Available commands:', 0Dh, 0Ah
         db 'help    - Show this help', 0Dh, 0Ah
         db 'ls      - List files', 0Dh, 0Ah
         db 'cat     - Show file content', 0Dh, 0Ah
         db 'echo    - Print text', 0Dh, 0Ah
         db 'clear   - Clear screen', 0Dh, 0Ah
         db 'reboot  - Reboot system', 0Dh, 0Ah
         db 'meminfo - Show memory info', 0Dh, 0Ah
         db 'date    - Show date and time', 0Dh, 0Ah
         db 'gui     - Enable GUI for this session', 0
ls_msg db 'Files in current directory:', 0
ls_dummy_files db 'file1.txt  file2.txt  README', 0
file_not_found_msg db 'Error: File not found', 0
dummy_filename db 'file1.txt', 0
dummy_file_content db 'This is content of file1.txt', 0
reboot_msg db 'System rebooting...', 0
meminfo_msg db 'Total memory: ', 0
mem_kb_msg db ' KB', 0

; Список команд
cmd_help db 'help', 0
cmd_ls db 'ls', 0
cmd_cat db 'cat', 0
cmd_echo db 'echo', 0
cmd_clear db 'clear', 0
cmd_reboot db 'reboot', 0
cmd_meminfo db 'meminfo', 0
cmd_date db 'date', 0
cmd_gui db 'gui', 0

input_buffer times 128 db 0

; text for gui
; Тексты для GUI
btn_help_text db 'F1 - HELP', 0
btn_reboot_text db 'F2 - REBOOT', 0
gui_help_msg db 'Press F1 for Help, F2 to Reboot, ESC to Exit', 0
gui_help_full_msg db 'GUI Help:', 0Dh, 0Ah
                 db 'F1 - Show this help', 0Dh, 0Ah
                 db 'F2 - Reboot system', 0Dh, 0Ah
                 db 'ESC - Return to console', 0Dh, 0Ah, 0
gui_reboot_msg db 'Rebooting system...', 0

; Выравнивание размера ядра
kernel_size equ $ - $$
padding_size equ (512 - (kernel_size % 512)) % 512
times padding_size db 0
