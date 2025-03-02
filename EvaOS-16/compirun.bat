@echo off
echo [INFO] Starting build process...

:: Компиляция загрузчика
echo [INFO] Compiling bootloader...
nasm -f bin -o bootloader.bin bootloader.asm
if errorlevel 1 (
    echo [ERROR] Failed to compile bootloader.asm
    exit /b 1
) else (
    echo [INFO] bootloader.bin successfully created.
)

:: Компиляция ядра
echo [INFO] Compiling kernel...
nasm -f bin -o VioletKernel.bin VioletKernel.asm
if errorlevel 1 (
    echo [ERROR] Failed to compile VioletKernel.asm
    exit /b 1
) else (
    echo [INFO] VioletKernel.bin successfully created.
)

:: Сборка образа ОС
echo [INFO] Creating OS image...
python -c "open('EvaOS.bin', 'wb').write(open('bootloader.bin', 'rb').read() + open('VioletKernel.bin', 'rb').read())"
if errorlevel 1 (
    echo [ERROR] Failed to create EvaOS.bin
    exit /b 1
) else (
    echo [INFO] EvaOS.bin successfully created.
)

:: Запуск QEMU с логированием
echo [INFO] Starting QEMU with logging...
qemu-system-x86_64 -fda EvaOS.bin -d cpu_reset,int,guest_errors -D qemu.log
if errorlevel 1 (
    echo [ERROR] QEMU failed to start.
    exit /b 1
) else (
    echo [INFO] QEMU started successfully. Logs are saved in qemu.log.
)

echo [INFO] Build and run process completed.