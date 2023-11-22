#!/bin/bash

mkdir -p build

nasm src/boot_sector.asm -o build/boot_sector.bin -I src
nasm src/kernel.asm -o build/kernel.bin -I src
nasm src/file_table.asm -o build/file_table.bin -I src

cd build

cat boot_sector.bin kernel.bin file_table.bin > os.bin
