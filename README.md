# EvaOS
 Eva-OS - Это Open Source операционная система написанная на Assembler.

Цель проекта - создание модульной, гибкой и доступной системы как для рядового пользователя, так и для программистов.

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

