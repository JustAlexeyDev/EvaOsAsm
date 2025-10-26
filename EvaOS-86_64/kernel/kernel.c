#include "drivers/terminal/terminal.h"

void kernel_main(void) {
    terminal_init();
    terminal_writestring("VioletKernel x86_64 - Terminal Ready!\n");
    terminal_writestring("> ");
    
    while(1);
}