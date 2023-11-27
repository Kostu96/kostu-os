;
; Copyright (C) 2023 Konstanty Misiak
;
; SPDX-License-Identifier: MIT
;

KERNEL_OFFSET equ 0x1000

[bits 16]
[org 0x7C00]

		mov [BOOT_DRIVE], dl ; BIOS stores our boot drive in dl
		
		mov bp, 0x9000
		mov sp, bp

		mov bx, BOOTLOADER_MSG1
		call print_str

		; Load additional sectors:
		mov dh, 2 ; number of sectors
		mov dl, [BOOT_DRIVE]
		mov bx, KERNEL_OFFSET
		mov es, bx
		xor bx, bx
		call disk_load

		mov bx, BOOTLOADER_MSG2
		call print_str

		cli ; disable interrupts before PROTECTED MODE switch
		lgdt [gdt_descriptor]
		mov eax, cr0
		or eax, 0x1
		mov cr0, eax
		jmp CODE_SEG:protected_mode_start
		
		jmp $

%include "bios_routines.asm"
%include "gdt.asm"

		[bits 32]
protected_mode_start:
		mov ax, DATA_SEG
		mov ds, ax
		mov ss, ax
		mov es, ax
		mov fs, ax
		mov gs, ax
		mov ebp, 0x90000
		mov esp, ebp

		mov ebx, BOOTLOADER_MSG3
		call print_string_pm

		call KERNEL_OFFSET

		jmp $

%include "print_str_pm.asm"

BOOT_DRIVE: db 0
BOOTLOADER_MSG1: db "Starting bootloader...", 0xD, 0xA, 0
BOOTLOADER_MSG2: db "Finished loading additional sectorsy.", 0xD, 0xA, 0
BOOTLOADER_MSG3: db "Starting executing in PROTECTED MODE.", 0xD, 0xA, 0

		; BIOS magic number:
		times 510 - ($ - $$) db 0
		dw 0xAA55
