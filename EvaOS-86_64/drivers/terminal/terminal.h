#ifndef TERMINAL_H
#define TERMINAL_H

#include <stddef.h>
#include <stdint.h>

void terminal_init(void);
void terminal_putchar(char c);
void terminal_write(const char* str);
void terminal_writestring(const char* str);

#endif