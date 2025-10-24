global _start

section .bss
align 4096
; таблицы страниц для x64 режима
pml4_table:
    resb 4096
pdp_table:
    resb 4096
pd_table:
    resb 4096  

section .text
bits 32
_start:
    mov esp, stack_top

    call check_long_mode
    
    call setup_paging

    call enable_long_mode

    lgdt [gdt64.pointer]
    jmp gdt64.code:long_mode_start

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
    mov dword [0xb8000], 0x4f524f45  ; "ER"
    mov dword [0xb8004], 0x4f3a4f52  ; "R:"
    mov dword [0xb8008], 0x4f204f20  ; "  "
    mov dword [0xb800C], 0x4f4c4f36  ; "6L"
    hlt

setup_paging:
    mov edi, pml4_table
    mov ecx, 4096
    xor eax, eax
    rep stosb

    mov eax, pdp_table
    or eax, 0b11  ; Present + Writable
    mov [pml4_table], eax

    mov eax, pd_table
    or eax, 0b11  ; Present + Writable
    mov [pdp_table], eax

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
    dq 0
.code: equ $ - gdt64
    dq (1 << 43) | (1 << 44) | (1 << 47) | (1 << 53)
.pointer:
    dw $ - gdt64 - 1
    dq gdt64

section .text
bits 64
long_mode_start:
    mov edi, 0xb8000
    mov rcx, 500
    mov rax, 0x0f200f200f200f20  ; Черные пробелы
    rep stosq

    ; Выводим "x86_64 - OK" зеленым цветом
    mov byte [0xb8000], 'x'
    mov byte [0xb8002], '8'
    mov byte [0xb8004], '6'
    mov byte [0xb8006], '_'
    mov byte [0xb8008], '6'
    mov byte [0xb800a], '4'
    mov byte [0xb800c], ' '
    mov byte [0xb800e], '-'
    mov byte [0xb8010], ' '
    mov byte [0xb8012], 'O'
    mov byte [0xb8014], 'K'

    mov ecx, 11
    mov edi, 0xb8001
.set_color:
    mov byte [edi], 0x2f
    add edi, 2
    loop .set_color

    hlt

section .bss
align 16
stack_bottom:
    resb 4096 * 4 ;16KB
stack_top: