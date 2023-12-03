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

C_SOURCES = $(wildcard src/kernel/*.c src/drivers/*.c)
C_OBJS = ${C_SOURCES:%.c=./build/%.o}

all: os.bin

os.bin: build/boot_sector.bin build/file_system.bin build/kernel.bin
	cat $^ > build/$@

build/boot_sector.bin: src/boot/boot_sector.asm
	nasm $< -f bin -o $@ -I src/boot

build/file_system.bin: src/file_system.asm
	nasm $< -f bin -o $@

build/kernel.bin: build/kernel_entry.o ${C_OBJS}
	${LD} -o $@ -Ttext 0x1000 $^ --oformat=binary
	@size=$$(($$(wc -c < $@)));\
	echo "$$size ($$(printf '0x%02X' $$((size))))";

build/kernel_entry.o: src/kernel/kernel_entry.asm
	nasm $< -f elf -o $@ -I src/boot

./build/%.o: %.c
	mkdir -p $(dir $@)
	${CC} -ffreestanding -c $< -o $@

clean:
	rm -rf build
	mkdir build
