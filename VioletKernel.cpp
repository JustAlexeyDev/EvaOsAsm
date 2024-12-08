#include <iostream>
#include <string>
#include <cstring>

const int BUFFER_SIZE = 64;

void clear_screen() {
    std::cout << "\033[2J\033[1;1H"; 
}

void set_cursor_top_left() {
    std::cout << "\033[H"; 
}

void print_string(const char* str) {
    std::cout << str;
}

void print_newline() {
    std::cout << std::endl;
}

bool compare_strings(const char* str1, const char* str2) {
    return strcmp(str1, str2) == 0;
}

void read_command(char* command_buffer) {
    std::cin.getline(command_buffer, BUFFER_SIZE);
}

void process_command(const char* command_buffer) {
    if (compare_strings(command_buffer, "clear")) {
        clear_screen();
        set_cursor_top_left();
        print_newline();
    } else if (compare_strings(command_buffer, "mkdir")) {
        print_string("Directory created");
        print_newline();
    } else if (compare_strings(command_buffer, "cd")) {
        print_string("Directory changed");
        print_newline();
    } else if (compare_strings(command_buffer, "touch")) {
        print_string("File created");
        print_newline();
    } else if (compare_strings(command_buffer, "view")) {
        print_string("File viewed");
        print_newline();
    } else if (compare_strings(command_buffer, "del")) {
        print_string("File or directory deleted");
        print_newline();
    } else if (compare_strings(command_buffer, "ls")) {
        print_string("Listing directory contents");
        print_newline();
    } else {
        print_string("Unknown command");
    }
}

int main() {
    char command_buffer[BUFFER_SIZE];

    while (true) {
        set_cursor_top_left();
        print_string("VKernel > ");
        read_command(command_buffer);
        process_command(command_buffer);
    }

    return 0;
}

