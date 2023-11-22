#!/bin/bash

mkdir -p build

nasm boot_sector.asm -o build/boot_sector.bin
nasm kernel.asm -o build/kernel.bin

cd build

cat boot_sector.bin kernel.bin > os.bin

