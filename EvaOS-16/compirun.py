import os
import platform
import subprocess
from colorama import Fore, Style, init

# Инициализация colorama
init(autoreset=True)

OUT_DIR = "OUT"

def create_out_directory():
    if not os.path.exists(OUT_DIR):
        os.makedirs(OUT_DIR)
        print(f"{Fore.GREEN}[INFO]{Style.RESET_ALL} Директория {OUT_DIR} создана.")

def run_windows():
    print(f"{Fore.YELLOW}[WINDOWS]{Style.RESET_ALL} Вы выбрали Windows.")
    compile_result = subprocess.run(["g++", "builder.cpp", "-o", "builder"], capture_output=True, text=True)
    if compile_result.returncode == 0:
        print(f"{Fore.GREEN}[SUCCESS]{Style.RESET_ALL} Компиляция прошла успешно.")
        subprocess.run(["./builder"])
    else:
        print(f"{Fore.RED}[ERROR]{Style.RESET_ALL} Ошибка компиляции:")
        print(compile_result.stderr)

def run_linux():
    print(f"{Fore.YELLOW}[LINUX]{Style.RESET_ALL} Вы выбрали Мулти-компилятор.")
    create_out_directory()

    # Компиляция VioletKernel.asm
    kernel_result = subprocess.run(
        ["nasm", "-f", "bin", "-o", f"{OUT_DIR}/VioletKernel.bin", "VioletKernel.asm"],
        capture_output=True, text=True
    )
    if kernel_result.returncode == 0:
        print(f"{Fore.GREEN}[SUCCESS]{Style.RESET_ALL} VioletKernel.asm успешно скомпилирован.")
    else:
        print(f"{Fore.RED}[ERROR]{Style.RESET_ALL} Ошибка компиляции VioletKernel.asm:")
        print(kernel_result.stderr)
        return

    # Компиляция bootloader.asm
    bootloader_result = subprocess.run(
        ["nasm", "-f", "bin", "-o", f"{OUT_DIR}/bootloader.bin", "bootloader.asm"],
        capture_output=True, text=True
    )
    if bootloader_result.returncode == 0:
        print(f"{Fore.GREEN}[SUCCESS]{Style.RESET_ALL} bootloader.asm успешно скомпилирован.")
    else:
        print(f"{Fore.RED}[ERROR]{Style.RESET_ALL} Ошибка компиляции bootloader.asm:")
        print(bootloader_result.stderr)
        return

    # Объединение файлов
    with open(f"{OUT_DIR}/EvaOS.bin", "wb") as eva_os:
        with open(f"{OUT_DIR}/bootloader.bin", "rb") as bootloader:
            eva_os.write(bootloader.read())
        with open(f"{OUT_DIR}/VioletKernel.bin", "rb") as kernel:
            eva_os.write(kernel.read())
    print(f"{Fore.GREEN}[SUCCESS]{Style.RESET_ALL} Файлы успешно объединены в OUT/EvaOS.bin.")

    # Запуск QEMU
    qemu_result = subprocess.run(
        ["qemu-system-x86_64", "-fda", f"{OUT_DIR}/EvaOS.bin"],
        capture_output=True, text=True
    )
    if qemu_result.returncode == 0:
        print(f"{Fore.GREEN}[SUCCESS]{Style.RESET_ALL} QEMU успешно запущен.")
    else:
        print(f"{Fore.RED}[ERROR]{Style.RESET_ALL} Ошибка запуска QEMU:")
        print(qemu_result.stderr)

def main():
    system = input(f"{Fore.CYAN}[INPUT]{Style.RESET_ALL} Как вы хотите скомпилировать ядро? Windows C++(1) / Мулти-компилятор(2): ").strip().lower()

    if system == "1":
        run_windows()
    elif system == "2":
        run_linux()
    else:
        print(f"{Fore.RED}[ERROR]{Style.RESET_ALL} Неверный выбор. Пожалуйста, введите '1' или '2'.")

if __name__ == "__main__":
    main()