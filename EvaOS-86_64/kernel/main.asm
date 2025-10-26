global _start
extern kernel_main

section .bss
align 4096
pml4_table:
    resb 4096
pdp_table:
    resb 4096
pd_table:
    resb 4096

section .data
; Сообщения для вывода
msg_check_lm:    db "Check_long_mode", 0
msg_setup_paging:db "Setup_paging", 0
msg_enable_lm:   db "Enable_long_mode", 0
msg_x64_ready:   db "x86_64 mode", 0
msg_call_kernel:db "Starting VioletKernel...", 0
msg_ok:          db " [OK]", 0

section .text
bits 32
_start:
    mov esp, stack_top
    
    ; Очищаем экран
    call clear_screen_32
    
    ; Проверка Long Mode
    mov esi, msg_check_lm
    mov edi, 0xb8000
    call print_string_32
    call check_long_mode
    mov esi, msg_ok
    mov edi, 0xb8000 + 15 * 2
    mov ah, 0x0a
    call print_string_32
    
    ; Настройка страничной организации
    mov esi, msg_setup_paging
    mov edi, 0xb8000 + 160
    call print_string_32
    call setup_paging
    mov esi, msg_ok
    mov edi, 0xb8000 + 160 + 12 * 2
    mov ah, 0x0a
    call print_string_32
    
    ; Long Mode
    mov esi, msg_enable_lm
    mov edi, 0xb8000 + 320
    call print_string_32
    call enable_long_mode
    mov esi, msg_ok
    mov edi, 0xb8000 + 320 + 16 * 2
    mov ah, 0x0a
    call print_string_32
    
    ; Переход в 64-битный режим
    lgdt [gdt64.pointer]
    jmp gdt64.code:long_mode_start

; Функция очистки экрана (32-битная)
clear_screen_32:
    mov edi, 0xb8000
    mov ecx, 80 * 25
    mov ax, 0x0f20
.clear_loop:
    mov [edi], ax
    add edi, 2
    loop .clear_loop
    ret

; Функция вывода строки (32-битная)
print_string_32:
    push eax
    push esi
    push edi
.loop:
    lodsb
    test al, al
    jz .done
    mov [edi], ax
    add edi, 2
    jmp .loop
.done:
    pop edi
    pop esi
    pop eax
    ret

check_long_mode:
    pushfd
    pop eax
    mov ecx, eax
    xor eax, 1 << 21
    push eax
    popfd
    pushfd
    pop eax
    xor eax, ecx
    jz .no_cpuid

    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb .no_long_mode

    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jz .no_long_mode
    ret

.no_cpuid:
.no_long_mode:
    mov esi, .error_msg
    mov edi, 0xb8000 + 400
    mov ah, 0x4f
    call print_string_32
    hlt
.error_msg: db "ERROR: Long Mode not supported", 0

setup_paging:
    ; Очищаем таблицы
    mov edi, pml4_table
    mov ecx, 4096 * 3
    xor eax, eax
    rep stosb

    ; PML4 -> PDP
    mov eax, pdp_table
    or eax, 0b11
    mov [pml4_table], eax

    ; PDP -> PD  
    mov eax, pd_table
    or eax, 0b11
    mov [pdp_table], eax

    ; Заполняем PD 2MB страницами
    mov ecx, 0
    mov eax, 0x00000000
    or eax, 0b10000011
    
.loop_pages:
    mov [pd_table + ecx * 8], eax
    add eax, 0x200000
    inc ecx
    cmp ecx, 512
    jl .loop_pages
    ret

enable_long_mode:
    mov eax, pml4_table
    mov cr3, eax

    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax
    ret

gdt64:
.null: equ $ - gdt64
    dq 0
.code: equ $ - gdt64
    dq (1 << 43) | (1 << 44) | (1 << 47) | (1 << 53)
.data: equ $ - gdt64
    dq (1 << 44) | (1 << 47) | (1 << 41)
.pointer:
    dw $ - gdt64 - 1
    dq gdt64

; 64-битный код
section .text
bits 64
long_mode_start:
    ; Выводим статус x86_64
    mov rsi, msg_x64_ready
    mov rdi, 0xb8000 + 480
    call print_string_64
    mov rsi, msg_ok
    mov rdi, 0xb8000 + 480 + 11 * 2
    mov ah, 0x0a
    call print_string_64
    
    ; Выводим сообщение о запуске ядра
    mov rsi, msg_call_kernel
    mov rdi, 0xb8000 + 640
    mov ah, 0x0e
    call print_string_64
    mov rsi, msg_ok
    mov rdi, 0xb8000 + 640 + 19 * 2
    mov ah, 0x0a
    call print_string_64

    call kernel_main
    
    hlt

; Функция вывода строки (64-битная)
print_string_64:
    push rax
    push rsi
    push rdi
.loop:
    lodsb
    test al, al
    jz .done
    mov [rdi], ax
    add rdi, 2
    jmp .loop
.done:
    pop rdi
    pop rsi
    pop rax
    ret

section .bss
align 16
stack_bottom:
    resb 4096 * 4
stack_top: