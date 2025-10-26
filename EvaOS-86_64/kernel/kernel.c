#include "drivers/terminal/terminal.h"
#include "drivers/interrupts/idt.h"
#include "drivers/interrupts/pic.h"

void kernel_main(void) {
    terminal_init();
    terminal_writestring("VioletKernel x86_64 - Terminal Ready!\n");
    terminal_writestring("Init IDT...\n");

    idt_init();
    pic_init();
    
    terminal_writestring("Interrupts enabled!\n");

    while(1) {
        asm volatile("hlt");
    }
}