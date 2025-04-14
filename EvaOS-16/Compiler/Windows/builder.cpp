#include <iostream>
#include <string>
#include <vector>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <chrono>
#include <iomanip>

#define RESET   "\033[0m"
#define RED     "\033[31m"
#define GREEN   "\033[32m"
#define YELLOW  "\033[33m"
#define BLUE    "\033[34m"
#define MAGENTA "\033[35m"
#define CYAN    "\033[36m"

std::ofstream logFile("../Logs/build.log", std::ios::app);

void logInfo(const std::string& message) {
    auto now = std::chrono::system_clock::now();
    auto now_time = std::chrono::system_clock::to_time_t(now);
    logFile << std::put_time(std::localtime(&now_time), "%Y-%m-%d %H:%M:%S") << " [INFO] " << message << std::endl;
    std::cout << GREEN << "[INFO]" << RESET << " " << message << std::endl;
}

void logError(const std::string& message) {
    auto now = std::chrono::system_clock::now();
    auto now_time = std::chrono::system_clock::to_time_t(now);
    logFile << std::put_time(std::localtime(&now_time), "%Y-%m-%d %H:%M:%S") << " [ERROR] " << message << std::endl;
    std::cerr << RED << "[ERROR]" << RESET << " " << message << std::endl;
}

void logWarning(const std::string& message) {
    auto now = std::chrono::system_clock::now();
    auto now_time = std::chrono::system_clock::to_time_t(now);
    logFile << std::put_time(std::localtime(&now_time), "%Y-%m-%d %H:%M:%S") << " [WARNING] " << message << std::endl;
    std::cout << YELLOW << "[WARNING]" << RESET << " " << message << std::endl;
}

void createOutDirectory() {
    if (!std::filesystem::exists("../../Out")) {
        std::filesystem::create_directory("../../Out");
        logInfo("Directory Out created.");
    } else {
        logInfo("Directory Out already exists.");
    }
}

void compileAsmFile(const std::string& sourceFile, const std::string& outputFile) {
    std::string command = "nasm -f bin ../../Core/" + sourceFile + " -o ../../Out/" + outputFile;
    logInfo("Compiling " + sourceFile + " to ../../Out/" + outputFile);
    logInfo("Executing: " + command);
    int result = std::system(command.c_str());
    if (result != 0) {
        logError("Compilation of " + sourceFile + " failed!");
        std::exit(1);
    }
    if (!std::filesystem::exists("../../Out/" + outputFile)) {
        logError("Output file ../../Out/" + outputFile + " was not created!");
        std::exit(1);
    }
    logInfo(sourceFile + " compiled successfully to ../../Out/" + outputFile);
}

void combineFiles(const std::vector<std::string>& inputFiles, const std::string& outputFile) {
    std::ofstream outFile("../../Out/" + outputFile, std::ios::binary);
    if (!outFile) {
        logError("Failed to open output file: ../../Out/" + outputFile);
        std::exit(1);
    }

    for (const auto& inputFile : inputFiles) {
        std::ifstream inFile("../../Out/" + inputFile, std::ios::binary);
        if (!inFile) {
            logError("Failed to open input file: ../../Out/" + inputFile);
            std::exit(1);
        }
        outFile << inFile.rdbuf();
    }

    logInfo("Files combined into ../../Out/" + outputFile);
}

int main() {
    logInfo("Starting build process...");
    createOutDirectory();

    std::vector<std::string> sourceFiles = {
        "bootloader.asm",
        "VioletKernel.asm"
    };

    std::vector<std::string> binaryFiles;
    std::string outputFile = "EvaOS.bin";

    for (const auto& source : sourceFiles) {
        std::string binaryFile = std::filesystem::path(source).stem().string() + ".bin";
        compileAsmFile(source, binaryFile);
        binaryFiles.push_back(binaryFile);
    }

    combineFiles(binaryFiles, outputFile);

    logInfo("Build process completed successfully!");

    logInfo("Starting QEMU with logging...");
    std::string qemuCommand = "qemu-system-x86_64 -fda ../../Out/" + outputFile + " -d cpu_reset,int,guest_errors -D ../Logs/qemu.log";
    logInfo("Executing: " + qemuCommand);
    int result = std::system(qemuCommand.c_str());
    if (result != 0) {
        logError("QEMU failed to start!");
        std::exit(1);
    }
    logInfo("QEMU started successfully. Logs are saved in ../Logs/qemu.log.");

    return 0;
}
