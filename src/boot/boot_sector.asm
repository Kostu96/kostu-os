;
; Copyright (C) 2023 Konstanty Misiak
;
; SPDX-License-Identifier: MIT
;

ROOT_OFFSET equ 0x1000
ROOT_END equ ROOT_OFFSET + 7 * 512
KERNEL_OFFSET equ 0x2000

[bits 16]
[org 0x7C00]

		xor ax, ax
		mov ds, ax

		mov [BOOT_DRIVE], dl ; BIOS stores our boot drive in dl
		
		; Setup stack
		xor ax, ax
		mov ss, ax
		mov sp, 0x9000

		; Load ROOT table
		mov cx, 2 ; start from sector 2
		mov dh, 7 ; number of sectors
		mov dl, [BOOT_DRIVE]
		xor bx, bx
		mov es, bx
		mov bx, ROOT_OFFSET
		call disk_load

		; Find and load kernel
		; ROOT_OFFSET should still be in bx
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
		add cx, 7 + 1 ; offset to the beginning of data
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

%include "bios_routines.inc"
%include "gdt.inc"

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

		jmp KERNEL_OFFSET

BOOT_DRIVE: db 0
KERNEL_NOT_FOUND_MSG: db "Kernel missing", 0xD, 0xA, 0
KERNEL_STR: db "kernel", 0, 0, "bin"
KERNEL_STR_SIZE equ $ - KERNEL_STR

		; BIOS magic number:
		times 510 - ($ - $$) db 0
		dw 0xAA55
