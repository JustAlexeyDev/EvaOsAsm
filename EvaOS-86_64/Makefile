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
GRUB_DIR = grub
ISO_DIR = iso

KERNEL_SRC = $(KERNEL_DIR)/kernel.asm
KERNEL_OBJ = $(KERNEL_DIR)/kernel.o
KERNEL_BIN = $(KERNEL_DIR)/kernel.bin
GRUB_CFG = $(GRUB_DIR)/grub.cfg
ISO_IMAGE = eva-os.iso

# Цели по умолчанию
.PHONY: all run clean help

all: $(ISO_IMAGE)

# Сборка ядра
$(KERNEL_BIN): $(KERNEL_OBJ)
	$(LD) $(LD_FLAGS) -o $@ $^

$(KERNEL_OBJ): $(KERNEL_SRC)
	$(ASM) $(ASM_FLAGS) $< -o $@

# Создание ISO образа
$(ISO_IMAGE): $(KERNEL_BIN) $(GRUB_CFG)
	@mkdir -p $(ISO_DIR)/boot/grub
	cp $(KERNEL_BIN) $(ISO_DIR)/boot/
	cp $(GRUB_CFG) $(ISO_DIR)/boot/grub/
	$(GRUB_MKRESCUE) -o $@ $(ISO_DIR)

# Запуск ISO образа в QEMU
run: $(ISO_IMAGE)
	$(QEMU) -cdrom $(ISO_IMAGE)

# Очистка
clean:
	rm -rf $(KERNEL_OBJ) $(KERNEL_BIN) $(ISO_IMAGE) $(ISO_DIR)

# Показать помощь
help:
	@echo "Доступные цели:"
	@echo "  all     - Создать ISO образ ($(ISO_IMAGE))"
	@echo "  run     - Запустить ISO образ в QEMU"
	@echo "  clean   - Очистить сгенерированные файлы"
	@echo "  help    - Показать эту справку"