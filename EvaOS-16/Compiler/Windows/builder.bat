@echo off
REM Переход в директорию Core
cd ..\Core

REM Компиляция ASM файлов
nasm -f bin -o ..\OUT\VioletKernel.bin VioletKernel.asm
if %errorlevel% neq 0 (
    echo Ошибка компиляции VioletKernel.asm
    exit /b 1
)

nasm -f bin -o ..\OUT\bootloader.bin bootloader.asm
if %errorlevel% neq 0 (
    echo Ошибка компиляции bootloader.asm
    exit /b 1
)

REM Объединение файлов
python -c "open('..\OUT\EvaOS.bin', 'wb').write(open('..\OUT\bootloader.bin', 'rb').read() + open('..\OUT\VioletKernel.bin', 'rb').read())"
if %errorlevel% neq 0 (
    echo Ошибка объединения файлов
    exit /b 1
)

REM Запуск QEMU
qemu-system-x86_64 -fda ..\OUT\EvaOS.bin
if %errorlevel% neq 0 (
    echo Ошибка запуска QEMU
    exit /b 1
)