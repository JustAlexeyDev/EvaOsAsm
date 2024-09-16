; bootloader.asm

BITS 16
ORG 0x7C00

start:
    ; Инициализация сегментных регистров
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; Очистка экрана
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    ; Вывод сообщения
    mov si, msg
    call print_string

    ; Загрузка ядра ОС
    mov ah, 0x02    ; Функция чтения сектора
    mov al, 1       ; Количество секторов для чтения
    mov ch, 0       ; Номер цилиндра
    mov cl, 2       ; Номер сектора (начиная со второго)
    mov dh, 0       ; Номер головки
    mov dl, 0       ; Дисковод (0 = A:)
    mov bx, 0x1000  ; Адрес загрузки ядра
    mov es, bx
    xor bx, bx
    int 0x13        ; Вызов BIOS для чтения сектора

    ; Переход к ядру ОС
    jmp 0x1000:0x0000

print_string:
    lodsb
    or al, al
    jz done
    mov ah, 0x0E
    int 0x10
    jmp print_string

done:
    ret

msg db 'EvaOS Bootloader', 0

times 510-($-$$) db 0
dw 0xAA55