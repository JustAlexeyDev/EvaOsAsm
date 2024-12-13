nasm -f bin -o VioletKernel32bit.bin VioletKernel32bit.asm
nasm -f bin -o bootloader32bit.bin bootloader32bit.asm
python -c "open('EvaOS32bit.bin', 'wb').write(open('bootloader32bit.bin', 'rb').read() + open('VioletKernel32bit.bin', 'rb').read())"
qemu-system-x86_64 -fda EvaOS32bit.bin