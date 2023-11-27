#
# Copyright (C) 2023 Konstanty Misiak
#
# SPDX-License-Identifier: MIT
#

# $^ is substituted with all of the target’s dependancy files
# $< is the first dependancy
# $@ is the target file

CC = ${HOME}/opt/cross/bin/i686-elf-gcc
LD = ${HOME}/opt/cross/bin/i686-elf-ld

all: os.bin

os.bin: build/boot_sector.bin build/kernel.bin
	cat $^ > build/$@

build/boot_sector.bin: src/boot_sector.asm
	nasm $< -f bin -o $@ -I src

build/kernel.bin: build/kernel_entry.o build/kernel.o
	${LD} -o $@ -Ttext 0x1000 $^ --oformat=binary

build/kernel_entry.o: src/kernel_entry.asm
	nasm $< -f elf -o $@

build/kernel.o: src/kernel.c
	${CC} -ffreestanding -c $< -o $@
