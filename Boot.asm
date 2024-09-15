[BITS 16]
[ORG 0x7C00]

start:
    xor ax, ax
    int 0x13

    mov bx, 0x1000  
    mov dh, 16     
    mov dl, 0x80   
    mov ch, 0     
    mov dh, 0    
    mov cl, 2     

    mov ah, 0x02  
    int 0x13
    jc disk_error 

    cli           
    lgdt [gdt_descriptor] 

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp 0x08:protected_mode

disk_error:
    hlt

[BITS 32]
protected_mode:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    jmp 0x1000 

gdt_start:
    dq 0x0

    dw 0xFFFF 
    dw 0x0   
    db 0x0    
    db 10011010b
    db 11001111b 
    db 0x0    

    dw 0xFFFF 
    dw 0x0    
    db 0x0   
    db 10010010b 
    db 11001111b 
    db 0x0     

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1 
    dd gdt_start               

times 510-($-$$) db 0
dw 0xAA55