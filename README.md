# EvaOS
 Eva-OS - это Open Source операционная система написанная на Assembler.

Цель проекта - создание модульной, гибкой и доступной системы как для рядового пользователя, так и для опытного программистов.

## Компиляция
Перейдите в директорию с нужной версией ОС
```sh
cd EvaOS-16
```
### 1 способ (авто-сборка)
Запустите авто-сборку системы
```
./compirun.bat
```

### 2 способ (ручная сборка)

Перевод dotasm в bin 
```sh
nasm -f bin -o VioletKernel.bin VioletKernel.asm
nasm -f bin -o bootloader.bin bootloader.asm   
```

Линковка
```sh
python -c "open('EvaOS.bin', 'wb').write(open('bootloader.bin', 'rb').read() + open('VioletKernel.bin', 'rb').read())"
```

Запуск через QEMU
```sh
qemu-system-x86_64 -fda EvaOS.bin
```

## Стек технологий:
```json
{
 "Эмуляторы": "QEMU",
 "Языки": "C++ GCC (Violet-Kernel), Python (runner)",
 "Программы": "GIT",
 "Компиляторы": "NASM(ASM ENV)"
}
```

