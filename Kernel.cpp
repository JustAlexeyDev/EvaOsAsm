#include <stdint.h>

#define VIDEO_MEMORY 0xB8000
#define WHITE_ON_BLACK 0x0F

void print_string(const char* str) {
    uint16_t* video_memory = (uint16_t*)VIDEO_MEMORY;
    while (*str) {
        *video_memory++ = (*str++) | (WHITE_ON_BLACK << 8);
    }
}

extern "C" void kernel_main() {
    print_string("Welcome to EvaOS!\n");

    while (1);
}