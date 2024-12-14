#include <stdio.h>
#include <string.h>

#define BUFFER_SIZE 64

char input_buffer[BUFFER_SIZE];

void print_string(const char *str) {
    while (*str) {
        putchar(*str++);
    }
}

void print_newline() {
    putchar('\r');
    putchar('\n');
}

void clear_screen() {
    printf("\033[H\033[J");
}

void read_input() {
    int i = 0;
    char ch;
    while (i < BUFFER_SIZE - 1) {
        ch = getchar();
        if (ch == '\r') {
            break;
        } else if (ch == 8) { 
            if (i > 0) {
                i--;
                printf("\b \b");
            }
        } else {
            input_buffer[i++] = ch;
            putchar(ch);
        }
    }
    input_buffer[i] = '\0';
    print_newline();
}

void parse_command() {
    if (strcmp(input_buffer, "help") == 0) {
        print_string("Commands: help, ls, mkdir, rmdir, send, clear");
        print_newline();
    } else if (strcmp(input_buffer, "ls") == 0) {
        print_string("Listing directories...");
        print_newline();
    } else if (strcmp(input_buffer, "mkdir") == 0) {
        print_string("Creating directory...");
        print_newline();
    } else if (strcmp(input_buffer, "rmdir") == 0) {
        print_string("Removing directory...");
        print_newline();
    } else if (strncmp(input_buffer, "send ", 5) == 0) {
        print_string(input_buffer + 5);
        print_newline();
    } else if (strcmp(input_buffer, "clear") == 0) {
        clear_screen();
    } else {
        print_string("Unknown command");
        print_newline();
    }
}

int main() {
    print_string("Eva-OS VioletKernel - version 0.006.442");
    print_newline();

    while (1) {
        print_newline();
        print_string("DISK_A:/>");
        read_input();
        parse_command();
    }

    return 0;
}

