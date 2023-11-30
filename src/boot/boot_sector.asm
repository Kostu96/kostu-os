;
; Copyright (C) 2023 Konstanty Misiak
;
; SPDX-License-Identifier: MIT
;

FAT_OFFSET equ 0x1000
KERNEL_OFFSET equ 0x2000

[bits 16]
[org 0x7C00]

		mov [BOOT_DRIVE], dl ; BIOS stores our boot drive in dl
		
		mov bp, 0x9000
		mov sp, bp

		call cls

		mov bx, WELCOME_MSG
		call print_str

		; Load FAT
		mov dh, 15 ; number of sectors
		mov dl, [BOOT_DRIVE]
		xor bx, bx
		mov es, bx
		mov bx, FAT_OFFSET
		call disk_load

		; Find kernel
		; ROOT directory starts in sector 10
		mov si, FAT_OFFSET + 8 * 512
		mov di, KERNEL_STR
loop:
		mov cx, KERNEL_STR_SIZE
		repe cmpsb
		mov bx, cx
		call print_hex
		cmp cx, 0
		je found
		add si, 5 ; go to the next entry
		mov bx, si
		call print_hex
		jmp loop
found:
		

		hlt

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

		;mov ebx, BOOTLOADER_MSG3
		;call print_string_pm

		call KERNEL_OFFSET

		jmp $

%include "print_str_pm.asm"

BOOT_DRIVE: db 0
WELCOME_MSG: db "Welcome to KostuOS!", 0xD, 0xA, 0
KERNEL_STR: db "kernel", 0, 0, "bin"
KERNEL_STR_SIZE equ $ - KERNEL_STR
;BOOTLOADER_MSG3: db "Starting executing in PROTECTED MODE.", 0

		; BIOS magic number:
		times 510 - ($ - $$) db 0
		dw 0xAA55
