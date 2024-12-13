#include <iostream>
#include <string>
#include <cstring>

const int BUFFER_SIZE = 64;

void print_string(const char* str) {
    std::cout << str;
}

void print_char(char c) {
    std::cout << c;
}

void print_newline() {
    std::cout << '\r' << '\n';
}

void clear_screen() {
    std::cout << "\033[H\033[2J"; // Escape sequence to clear the screen
}

bool compare_strings(const char* str1, const char* str2) {
    return std::strcmp(str1, str2) == 0;
}

void read_input(char* input_buffer) {
    int index = 0;
    char c;
    while (index < BUFFER_SIZE - 1) {
        std::cin.get(c);
        if (c == '\r') {
            break;
        } else if (c == '\b') {
            if (index > 0) {
                index--;
                print_char('\b');
                print_char(' ');
                print_char('\b');
            }
        } else {
            input_buffer[index++] = c;
            print_char(c);
        }
    }
    input_buffer[index] = '\0'; // Null-terminate the string
    print_newline();
}

void parse_command(const char* input_buffer) {
    if (compare_strings(input_buffer, "help")) {
        print_string("Commands: help, ls, mkdir, rmdir, send, clear, regstat");
        print_newline();
    } else if (compare_strings(input_buffer, "ls")) {
        print_string("Listing directories...");
        print_newline();
    } else if (compare_strings(input_buffer, "mkdir")) {
        print_string("Creating directory...");
        print_newline();
    } else if (compare_strings(input_buffer, "rmdir")) {
        print_string("Removing directory...");
        print_newline();
    } else if (compare_strings(input_buffer, "send")) {
        print_string(input_buffer + 5); // Assuming command is "send <message>"
        print_newline();
    } else if (compare_strings(input_buffer, "clear")) {
        clear_screen();
    } else {
        print_string("Unknown command");
        print_newline();
    }
}

int main() {
    print_string("Eva-OS VioletKernel - version 0.005.441");
    print_newline();

    char input_buffer[BUFFER_SIZE];
    while (true) {
        print_newline();
        print_string("DISK_A:/>");
        read_input(input_buffer);
        parse_command(input_buffer);
    }

    return 0;
}

