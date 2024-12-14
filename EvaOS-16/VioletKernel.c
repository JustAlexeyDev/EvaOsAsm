#include <stdio.h>
#include <string.h>

#define BUFFER_SIZE 64

void print_string(const char* str) {
    printf("%s", str);
}

void print_char(char c) {
    putchar(c);
}

void print_newline() {
    printf("\r\n");
}

void clear_screen() {
    printf("\033");
}

int main() {

}