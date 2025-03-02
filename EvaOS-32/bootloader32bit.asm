org 0x7C00
bits 16

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Сообщение о запуске загрузчика
    mov si, boot_msg
    call print_string

    ; Загрузка GDT
    lgdt [gdt_descriptor]

    ; Переход в защищенный режим
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; Дальний прыжок для обновления CS
    jmp 0x08:protected_mode

bits 32
protected_mode:
    ; Инициализация сегментных регистров
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Чтение ядра с диска
    mov eax, 0x0000
    mov es, ax          ; Сегмент ES = 0x0000
    mov ebx, 0x8000     ; Адрес загрузки ядра (0x8000)
    mov ah, 0x02        ; Функция чтения секторов
    mov al, 5           ; Количество секторов для чтения (например, 5)
    mov ch, 0           ; Номер цилиндра (0)
    mov cl, 2           ; Номер начального сектора (2)
    mov dh, 0           ; Номер головки (0)
    mov dl, 0x00        ; Номер диска (0x00 для флоппи-диска)
    int 0x13            ; Вызов прерывания BIOS

    ; Проверка на ошибку
    jc disk_error       ; Если CF = 1, произошла ошибка

    ; Успешное чтение
    mov esi, success_msg
    call print_string_32
    jmp 0x8000          ; Переход к ядру

disk_error:
    ; Ошибка чтения диска
    mov esi, error_msg
    call print_string_32
    jmp $               ; Бесконечный цикл

boot_msg db "Bootloader loaded", 0
error_msg db 'Disk read error', 0
success_msg db 'Disk read success', 0

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

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

; GDT
gdt_start:
    dd 0x00000000
    dd 0x00000000
    dd 0x0000FFFF
    dd 0x00CF9A00
    dd 0x0000FFFF
    dd 0x00CF9200
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

times 510-($-$$) db 0
dw 0xAA55