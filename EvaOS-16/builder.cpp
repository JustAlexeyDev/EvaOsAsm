#include <iostream>
#include <string>
#include <vector>
#include <cstdlib>
#include <filesystem>
#include <fstream> // Добавлено для работы с файловыми потоками

#define RESET   "\033[0m"
#define RED     "\033[31m"
#define GREEN   "\033[32m"
#define YELLOW  "\033[33m"
#define BLUE    "\033[34m"
#define MAGENTA "\033[35m"
#define CYAN    "\033[36m"

void compileAsmFile(const std::string& sourceFile, const std::string& outputFile) {
    std::string command = "nasm -f bin " + sourceFile + " -o " + outputFile;
    std::cout << BLUE << "[COMPILER] " << RESET << "Compiling " << sourceFile << " to " << outputFile << std::endl;
    std::cout << "Executing: " << command << std::endl; // Debugging output
    int result = std::system(command.c_str());
    if (result != 0) {
        std::cerr << RED << "[ERROR] " << RESET << "Compilation of " << sourceFile << " failed!" << std::endl;
        std::exit(1);
    }
    if (!std::filesystem::exists(outputFile)) {
        std::cerr << RED << "[ERROR] " << RESET << "Output file " << outputFile << " was not created!" << std::endl;
        std::exit(1);
    }
    std::cout << GREEN << "[SUCCESS] " << RESET << sourceFile << " compiled successfully to " << outputFile << std::endl;
}

void combineFiles(const std::vector<std::string>& inputFiles, const std::string& outputFile) {
    std::ofstream outFile(outputFile, std::ios::binary);
    if (!outFile) {
        std::cerr << RED << "[ERROR] " << RESET << "Failed to open output file: " << outputFile << std::endl;
        std::exit(1);
    }

    for (const auto& inputFile : inputFiles) {
        std::ifstream inFile(inputFile, std::ios::binary);
        if (!inFile) {
            std::cerr << RED << "[ERROR] " << RESET << "Failed to open input file: " << inputFile << std::endl;
            std::exit(1);
        }
        outFile << inFile.rdbuf();
    }

    std::cout << GREEN << "[SUCCESS] " << RESET << "Files combined into " << outputFile << std::endl;
}

int main() {
    std::vector<std::string> sourceFiles = {
        "bootloader.asm",
        "VioletKernel.asm"
    };

    std::vector<std::string> binaryFiles;
    std::string outputFile = "EvaOS.bin";

    // Компиляция ASM файлов
    for (const auto& source : sourceFiles) {
        std::string binaryFile = std::filesystem::path(source).stem().string() + ".bin";
        compileAsmFile(source, binaryFile);
        binaryFiles.push_back(binaryFile);
    }

    // Объединение бинарных файлов
    combineFiles(binaryFiles, outputFile);

    std::cout << GREEN << "[BUILD SUCCESS] " << RESET << "Build process completed successfully!" << std::endl;

    // Запуск QEMU
    std::cout << YELLOW << "[QEMU] " << RESET << "Starting QEMU with logging..." << std::endl;
    std::string qemuCommand = "qemu-system-x86_64 -fda " + outputFile + " -d cpu_reset,int,guest_errors -D qemu.log";
    std::cout << "Executing: " << qemuCommand << std::endl; // Debugging output
    int result = std::system(qemuCommand.c_str());
    if (result != 0) {
        std::cerr << RED << "[ERROR] " << RESET << "QEMU failed to start!" << std::endl;
        std::exit(1);
    }
    std::cout << GREEN << "[SUCCESS] " << RESET << "QEMU started successfully. Logs are saved in qemu.log." << std::endl;

    return 0;
}