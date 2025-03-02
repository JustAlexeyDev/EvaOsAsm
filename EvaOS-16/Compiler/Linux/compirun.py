import os
import platform
import subprocess
from colorama import Fore, Style, init
import logging
from datetime import datetime

init(autoreset=True)


LOGS_DIR = "../Logs"
OUT_DIR = "../Out"
CORE_DIR = "../Core"

if not os.path.exists(LOGS_DIR):
    os.makedirs(LOGS_DIR)

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    handlers=[
        logging.FileHandler(os.path.join(LOGS_DIR, "build.log")), 
        logging.StreamHandler() 
    ]
)

def log_info(message):
    """Логирование информационных сообщений."""
    logging.info(message)
    print(f"{Fore.GREEN}[INFO]{Style.RESET_ALL} {message}")

def log_error(message):
    """Логирование ошибок."""
    logging.error(message)
    print(f"{Fore.RED}[ERROR]{Style.RESET_ALL} {message}")

def log_warning(message):
    """Логирование предупреждений."""
    logging.warning(message)
    print(f"{Fore.YELLOW}[WARNING]{Style.RESET_ALL} {message}")

def log_debug(message):
    """Логирование отладочной информации."""
    logging.debug(message)
    print(f"{Fore.CYAN}[DEBUG]{Style.RESET_ALL} {message}")

def create_out_directory():
    """Создание директории OUT."""
    if not os.path.exists(OUT_DIR):
        os.makedirs(OUT_DIR)
        log_info(f"Directory {OUT_DIR} created.")
    else:
        log_info(f"Directory {OUT_DIR} already exists.")

def run_windows():
    """Запуск процесса для Windows."""
    log_info("You selected Windows.")
    compile_result = subprocess.run(["g++", "../Windows/builder.cpp", "-o", "../Windows/builder"], capture_output=True, text=True)
    if compile_result.returncode == 0:
        log_info("Compilation successful.")
        subprocess.run(["../Windows/builder"])
    else:
        log_error("Compilation error:")
        log_error(compile_result.stderr)

def run_linux():
    """Запуск процесса для Linux."""
    log_info("You selected Multi-compiler.")
    create_out_directory()

    log_info("Compiling VioletKernel.asm...")
    kernel_result = subprocess.run(
        ["nasm", "-f", "bin", "-o", os.path.join(OUT_DIR, "VioletKernel.bin"), os.path.join(CORE_DIR, "VioletKernel.asm")],
        capture_output=True, text=True
    )
    if kernel_result.returncode == 0:
        log_info("VioletKernel.asm compiled successfully.")
    else:
        log_error("VioletKernel.asm compilation error:")
        log_error(kernel_result.stderr)
        return

    log_info("Compiling bootloader.asm...")
    bootloader_result = subprocess.run(
        ["nasm", "-f", "bin", "-o", os.path.join(OUT_DIR, "bootloader.bin"), os.path.join(CORE_DIR, "bootloader.asm")],
        capture_output=True, text=True
    )
    if bootloader_result.returncode == 0:
        log_info("bootloader.asm compiled successfully.")
    else:
        log_error("bootloader.asm compilation error:")
        log_error(bootloader_result.stderr)
        return

    log_info("Merging files into OUT/EvaOS.bin...")
    try:
        with open(os.path.join(OUT_DIR, "EvaOS.bin"), "wb") as eva_os:
            with open(os.path.join(OUT_DIR, "bootloader.bin"), "rb") as bootloader:
                eva_os.write(bootloader.read())
            with open(os.path.join(OUT_DIR, "VioletKernel.bin"), "rb") as kernel:
                eva_os.write(kernel.read())
        log_info("Files successfully merged into OUT/EvaOS.bin.")
    except Exception as e:
        log_error(f"Error merging files: {e}")
        return

    log_info("Starting QEMU...")
    qemu_result = subprocess.run(
        ["qemu-system-x86_64", "-fda", os.path.join(OUT_DIR, "EvaOS.bin")],
        capture_output=True, text=True
    )
    if qemu_result.returncode == 0:
        log_info("QEMU started successfully.")
    else:
        log_error("QEMU startup error:")
        log_error(qemu_result.stderr)

def main():
    """Основная функция."""
    log_info("Starting build process...")
    system = input(f"{Fore.CYAN}[INPUT]{Style.RESET_ALL} How do you want to compile the kernel? Windows C++ (1) / Multi-compiler (2): ").strip().lower()

    if system == "1":
        run_windows()
    elif system == "2":
        run_linux()
    else:
        log_error("Invalid choice. Please enter '1' or '2'.")

if __name__ == "__main__":
    main()