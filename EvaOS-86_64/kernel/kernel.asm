section .text
global _start
align 4

; Multiboot2 header
multiboot_header:
    dd 0xe85250d6
    dd 0
    dd multiboot_header_end - multiboot_header
    dd -(0xe85250d6 + 0 + (multiboot_header_end - multiboot_header))
    
    ; Required end tag
    dw 0    ; type
    dw 0    ; flags
    dd 8    ; size
multiboot_header_end:

_start:
    ; Проверяем, что загружены через Multiboot2
    cmp eax, 0x36d76289
    jne .error
    
    ; Устанавливаем стек
    mov rsp, stack_top
    
    ; Вызываем основную функцию
    call kernel_main
    
.hang:
    hlt
    jmp .hang

.error:
    mov rsi, error_msg
    call print_string
    jmp .hang

kernel_main:
    push rbp
    mov rbp, rsp
    
    ; Выводим Hello World
    mov rsi, hello_msg
    call print_string
    
    pop rbp
    ret

; Функция для вывода строки
; Вход: RSI = указатель на строку
print_string:
    push rax
    push rbx
    push rsi
    mov rbx, 0xb8000  ; Начало видеопамяти
    
.print_loop:
    mov al, [rsi]
    cmp al, 0
    je .print_done
    
    ; Записываем символ и атрибут
    mov [rbx], al
    mov byte [rbx+1], 0x0F  ; Белый на черном
    
    add rsi, 1
    add rbx, 2
    jmp .print_loop
    
.print_done:
    pop rsi
    pop rbx
    pop rax
    ret

section .data
hello_msg: db "Hello World from VioletKernel!", 0
error_msg: db "Error: Not booted by Multiboot2-compliant bootloader!", 0

section .bss
align 16
stack_bottom:
    resb 16384  ; 16KB стек
stack_top: