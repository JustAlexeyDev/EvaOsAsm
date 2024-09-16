// kernel.cpp

#include <stdint.h>

void list_files(char* video_memory);
void create_directory(char* video_memory, const char* dir_name);

extern "C" void kernel_main() {
    char* video_memory = (char*)0xB8000;
    for (int i = 0; i < 80 * 25; i++) {
        video_memory[i * 2] = ' ';
        video_memory[i * 2 + 1] = 0x07;
    }

    const char* msg = "Welcome to EvaOS!";
    int pos = 0;
    while (msg[pos]) {
        video_memory[pos * 2] = msg[pos];
        video_memory[pos * 2 + 1] = 0x07;
        pos++;
    }

    list_files(video_memory);

    create_directory(video_memory, "NewDir");

    while (1) {}
}

void list_files(char* video_memory) {
    const char* files[] = {"file1.txt", "file2.txt", "dir1"};
    int num_files = sizeof(files) / sizeof(files[0]);

    int row = 1; 
    for (int i = 0; i < num_files; i++) {
        const char* file = files[i];
        int pos = 0;
        while (file[pos]) {
            video_memory[(row * 80 + pos) * 2] = file[pos];
            video_memory[(row * 80 + pos) * 2 + 1] = 0x07;
            pos++;
        }
        row++;
    }
}

void create_directory(char* video_memory, const char* dir_name) {
    int row = 5; 
    const char* msg = "Directory created: ";
    int pos = 0;
    while (msg[pos]) {
        video_memory[(row * 80 + pos) * 2] = msg[pos];
        video_memory[(row * 80 + pos) * 2 + 1] = 0x07;
        pos++;
    }

    pos = 0;
    while (dir_name[pos]) {
        video_memory[(row * 80 + 19 + pos) * 2] = dir_name[pos];
        video_memory[(row * 80 + 19 + pos) * 2 + 1] = 0x07;
        pos++;
    }
}