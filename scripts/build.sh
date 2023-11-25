#!/bin/bash

mkdir -p build

nasm src/boot_sector.asm -o build/boot_sector.bin -I src
#nasm src/kernel.asm -o build/kernel.bin -I src
nasm src/file_table.asm -o build/file_table.bin -I src

gcc -ffreestanding -c src/kernel.c -o build/kernel.o
ld -o build/kernel.bin -Ttext 0x1000 build/kernel.o --oformat=binary

cd build

cat boot_sector.bin kernel.bin > os.bin
