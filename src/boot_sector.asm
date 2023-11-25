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

		mov bx, BOOTLOADER_MSG
		call print_str

		; Load additional sectors:
		mov dh, 9 ; load 9 sectors
		mov dl, [BOOT_DRIVE]
		mov bx, KERNEL_OFFSET
		mov es, bx
		xor bx, bx
		call disk_load

		cli ; disable interrupts before PROTECTED MODE switch
		lgdt [gdt_descriptor]
		mov eax, cr0
		or eax, 0x1
		mov cr0, eax
		jmp CODE_SEG:protected_mode_start
		
		hlt

%include "bios_routines.asm"

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

		call KERNEL_OFFSET

		hlt

BOOT_DRIVE: db 0
BOOTLOADER_MSG: db "Starting bootloader...", 0xD, 0xA, 0

%include "gdt.asm"

		; BIOS magic number:
		times 510 - ($ - $$) db 0
		dw 0xAA55
