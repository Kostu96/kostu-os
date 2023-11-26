#!/bin/bash

mkdir -p build

nasm src/boot_sector.asm -o build/boot_sector.bin -I src
nasm src/kernel_entry.asm -f elf -o build/kernel_entry.o

$HOME/opt/cross/bin/i686-elf-gcc -ffreestanding -c src/kernel.c -o build/kernel.o
$HOME/opt/cross/bin/i686-elf-ld -o build/kernel.bin -Ttext 0x1000 build/kernel_entry.o build/kernel.o --oformat=binary

cd build

cat boot_sector.bin kernel.bin > os.bin
