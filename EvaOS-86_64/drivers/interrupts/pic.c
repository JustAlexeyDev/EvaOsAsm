#include "drivers/interrupts/pic.h"
#include "drivers/ports/ports.h"

void pic_init(void) {
    // Сохраняем маски
    uint8_t a1 = inb(PIC1_DATA);
    uint8_t a2 = inb(PIC2_DATA);
    
    // Инициализация
    outb(PIC1_COMMAND, ICW1_INIT | ICW1_ICW4);
    outb(PIC2_COMMAND, ICW1_INIT | ICW1_ICW4);
    
    // Смещения
    outb(PIC1_DATA, 0x20);  // IRQ 0-7 -> INT 0x20-0x27
    outb(PIC2_DATA, 0x28);  // IRQ 8-15 -> INT 0x28-0x2F
    
    // Каскадирование
    outb(PIC1_DATA, 4);
    outb(PIC2_DATA, 2);
    
    // Режим
    outb(PIC1_DATA, ICW4_8086);
    outb(PIC2_DATA, ICW4_8086);
    
    // Восстанавливаем маски
    outb(PIC1_DATA, a1);
    outb(PIC2_DATA, a2);
}

void pic_send_eoi(uint8_t irq) {
    if(irq >= 8) {
        outb(PIC2_COMMAND, 0x20);
    }
    outb(PIC1_COMMAND, 0x20);
}