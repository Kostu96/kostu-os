;
; Copyright (C) 2023 Konstanty Misiak
;
; SPDX-License-Identifier: MIT
;

FAT_OFFSET equ 0x1000
ROOT_OFFSET equ FAT_OFFSET + 8 * 512
ROOT_END equ ROOT_OFFSET + 7 * 512
KERNEL_OFFSET equ 0x2000

[bits 16]
[org 0x7C00]

		mov [BOOT_DRIVE], dl ; BIOS stores our boot drive in dl
		
		mov bp, 0x9000
		mov sp, bp

		; clear screen
		mov ax, 0x0003
		int 0x10

		mov bx, WELCOME_MSG
		call print_str

		; Load FAT
		mov cx, 2 ; start from sector 2
		mov dh, 15 ; number of sectors
		mov dl, [BOOT_DRIVE]
		xor bx, bx
		mov es, bx
		mov bx, FAT_OFFSET
		call disk_load

		; Find and load kernel
		mov bx, ROOT_OFFSET
dir_entry_loop:
		mov si, bx
		mov di, KERNEL_STR
		mov cx, KERNEL_STR_SIZE
		repe cmpsb
		cmp cx, 0
		je found
		add bx, 16 ; mov bx to the next dir entry
		cmp bx, ROOT_END
		jne dir_entry_loop
		mov bx, KERNEL_NOT_FOUND_MSG
		call print_str
		hlt
found:
		mov cx, [si + 1]
		add cx, 15 + 1 ; offset to the beginning of data
		mov ax, [si + 3]
		shr ax, 9
		inc ax
		mov dh, al
		mov dl, [BOOT_DRIVE]
		xor bx, bx
		mov es, bx
		mov bx, KERNEL_OFFSET
		call disk_load

		; Enter protected mode
		cli
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

		call KERNEL_OFFSET

		jmp $

%include "print_str_pm.asm"

BOOT_DRIVE: db 0
WELCOME_MSG: db "Welcome to KostuOS", 0xD, 0xA, 0
KERNEL_NOT_FOUND_MSG: db "Kernel missing", 0xD, 0xA, 0
KERNEL_STR: db "kernel", 0, 0, "bin"
KERNEL_STR_SIZE equ $ - KERNEL_STR

		; BIOS magic number:
		times 510 - ($ - $$) db 0
		dw 0xAA55
