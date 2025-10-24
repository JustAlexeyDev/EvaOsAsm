#define VIDEO_MEMORY 0xB8000

// Функция для вывода строки
void print_string(const char* str, int position, char color) {
    char* video_memory = (char*)VIDEO_MEMORY;
    video_memory += position * 2; // Каждый символ занимает 2 байта
    
    for(int i = 0; str[i] != '\0'; i++) {
        video_memory[i * 2] = str[i];     // Символ
        video_memory[i * 2 + 1] = color;  // Цвет
    }
}

// Функция очистки экрана
void clear_screen(char color) {
    char* video_memory = (char*)VIDEO_MEMORY;
    for(int i = 0; i < 80 * 25 * 2; i += 2) {
        video_memory[i] = ' ';      // Пробел
        video_memory[i + 1] = color; // Цвет фона
    }
}

// Главная функция ядра
void kernel_main(void) {
    clear_screen(0x10);
    
    print_string("VioletKernel x86_64 - Ready", 0, 0x1F);
    
    while(1);
}