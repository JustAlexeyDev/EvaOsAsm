# EvaOS
 Eva-OS - это Open Source операционная система написанная на Assembler.

Цель проекта - создание модульной, гибкой и доступной системы как для рядового пользователя, так и для опытного программистов.

## Компиляция
Перевод dotasm в bin 
```sh
nasm -f bin -o VioletKernel.bin VioletKernel.asm
nasm -f bin -o bootloader.bin bootloader.asm   
```

Линковка
```sh
Get-Content bootloader.bin, VioletKernel.bin | Set-Content EvaOS.bin  
```

Запуск через QEMU
```sh
qemu-system-x86_64 -fda EvaOS.bin
```

## Стек технологий:
```json
{
 "Эмуляторы": "QEMU, Oracle VirtualMachine",
 "Языки": "C++ GCC (Violet-Kernel), Python (runner)",
 "Программы": "GRUB, UltraISO, PowerShell, GIT",
 "Компиляторы": "NASM(ASM ENV)"
}
```
