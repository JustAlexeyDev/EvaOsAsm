# Компиляторы и утилиты
ASM = nasm
LD = ld
GRUB_MKRESCUE = grub-mkrescue
QEMU = qemu-system-x86_64

# Флаги
ASM_FLAGS = -f elf64
LD_FLAGS = -n -T kernel/linker.ld

# Директории и файлы
KERNEL_DIR = kernel
ISO_DIR = iso
GRUB_DIR = grub

KERNEL_SRCS = $(KERNEL_DIR)/header.asm $(KERNEL_DIR)/main.asm
KERNEL_OBJS = $(KERNEL_SRCS:.asm=.o)
KERNEL_BIN = $(KERNEL_DIR)/kernel.bin
GRUB_CFG = $(GRUB_DIR)/grub.cfg
ISO_IMAGE = eva-os.iso

# Цели по умолчанию
.PHONY: all run clean help

all: $(ISO_IMAGE)

# Сборка ядра
$(KERNEL_BIN): $(KERNEL_OBJS)
	$(LD) $(LD_FLAGS) -o $@ $^

%.o: %.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

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

# Помощь
help:
	@echo "Цели: all, run, clean, help"