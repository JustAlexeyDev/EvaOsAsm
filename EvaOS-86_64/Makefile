# Компиляторы и утилиты
ASM = nasm
LD = ld
GRUB_MKRESCUE = grub-mkrescue
QEMU = qemu-system-x86_64
GCC = gcc

# Флаги
ASM_FLAGS = -f elf64
LD_FLAGS = -n -T kernel/linker.ld
GCC_FLAGS = -c -ffreestanding -nostdlib -nostartfiles -nodefaultlibs -m64 -I.

# Директории и файлы
KERNEL_DIR = kernel
ISO_DIR = iso
GRUB_DIR = grub
DRIVERS_DIR = drivers

# Исходные файлы драйверов
PORTS_SRCS = $(DRIVERS_DIR)/ports/ports.c
TERMINAL_SRCS = $(DRIVERS_DIR)/terminal/terminal.c

# Исходные файлы ядра
ASM_SRCS = $(KERNEL_DIR)/header.asm $(KERNEL_DIR)/main.asm
C_SRCS = $(KERNEL_DIR)/kernel.c

# Все исходные файлы C
ALL_C_SRCS = $(C_SRCS) $(PORTS_SRCS) $(TERMINAL_SRCS)

# Объектные файлы
ASM_OBJS = $(ASM_SRCS:.asm=.o)
C_OBJS = $(ALL_C_SRCS:.c=.o)
KERNEL_OBJS = $(ASM_OBJS) $(C_OBJS)

KERNEL_BIN = $(KERNEL_DIR)/kernel.bin
GRUB_CFG = $(GRUB_DIR)/grub.cfg
ISO_IMAGE = eva-os.iso

# Цели по умолчанию
.PHONY: all run clean help

all: $(ISO_IMAGE)

# Сборка ядра (линковка всех объектных файлов)
$(KERNEL_BIN): $(KERNEL_OBJS)
	$(LD) $(LD_FLAGS) -o $@ $^

# Компиляция ассемблерных файлов
%.o: %.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

# Компиляция C файлов
%.o: %.c
	$(GCC) $(GCC_FLAGS) $< -o $@

# Создание ISO образа
$(ISO_IMAGE): $(KERNEL_BIN) $(GRUB_CFG)
	@mkdir -p $(ISO_DIR)/boot/grub
	cp $(KERNEL_BIN) $(ISO_DIR)/boot/
	cp $(GRUB_CFG) $(ISO_DIR)/boot/grub/
	$(GRUB_MKRESCUE) -o $@ $(ISO_DIR)

# Запуск в QEMU
run: $(ISO_IMAGE)
	$(QEMU) -cdrom $(ISO_IMAGE)

# Очистка
clean:
	rm -rf $(KERNEL_OBJS) $(KERNEL_BIN) $(ISO_IMAGE) $(ISO_DIR)
	find $(DRIVERS_DIR) -name "*.o" -delete

# Помощь
help:
	@echo "Цели: all, run, clean, help"