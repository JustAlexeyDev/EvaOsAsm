// kernel.cpp

#include <stdint.h>

// Объявления функций
void list_files(char* video_memory);
void create_directory(char* video_memory, const char* dir_name);

extern "C" void kernel_main() {
    // Инициализация видеорежима
    char* video_memory = (char*)0xB8000;
    for (int i = 0; i < 80 * 25; i++) {
        video_memory[i * 2] = ' ';
        video_memory[i * 2 + 1] = 0x07;
    }

    // Вывод сообщения
    const char* msg = "Welcome to EvaOS!";
    int pos = 0;
    while (msg[pos]) {
        video_memory[pos * 2] = msg[pos];
        video_memory[pos * 2 + 1] = 0x07;
        pos++;
    }

    // Вывод списка файлов
    list_files(video_memory);

    // Создание директории
    create_directory(video_memory, "NewDir");

    // Бесконечный цикл
    while (1) {}
}

// Функция для вывода списка файлов
void list_files(char* video_memory) {
    const char* files[] = {"file1.txt", "file2.txt", "dir1"};
    int num_files = sizeof(files) / sizeof(files[0]);

    int row = 1; // Начинаем с 1 строки после сообщения
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

// Функция для создания директории
void create_directory(char* video_memory, const char* dir_name) {
    // Просто выводим сообщение о создании директории
    int row = 5; // Начинаем с 5 строки
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