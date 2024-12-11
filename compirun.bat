nasm -f bin -o VioletKernel.bin VioletKernel.asm
nasm -f bin -o bootloader.bin bootloader.asm
python -c "open('EvaOS.bin', 'wb').write(open('bootloader.bin', 'rb').read() + open('VioletKernel.bin', 'rb').read())"
qemu-system-x86_64 -fda EvaOS.bin