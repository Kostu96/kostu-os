;
; Copyright (C) 2023 Konstanty Misiak
;
; SPDX-License-Identifier: MIT
;

		[org 0x7C00]
		KERNEL_OFFSET equ 0x9000

		mov [BOOT_DRIVE], dl ; BIOS stores our boot drive in dl
		
		; Setup stack
		mov bp, 0x8000
		mov sp, bp

		mov ax, 0x0003
		int 0x10 ; Set video mode

		; Load additional sectors:
		mov dh, 5 ; load 5 sectors
		mov dl, [BOOT_DRIVE]
		mov bx, KERNEL_OFFSET
		mov es, bx
		xor bx, bx
		call disk_load

		mov ax, KERNEL_OFFSET
		mov ss, ax
		mov ds, ax
		mov es, ax
		mov fs, ax
		mov gs, ax
		
		jmp KERNEL_OFFSET:0

; Load dh sectors after boot sector from dl drive to es:bx:
disk_load:
		push dx

		mov ah, 0x2
		mov al, dh
		mov cx, 0x0002
		mov dh, 0 ; Start from cylider 0, head 0, sector 2
		int 0x13
		jc _disk_load_error
		pop dx
		cmp dh, al
		jne _disk_load_error
		ret

_disk_load_error:
		mov bx, _disk_load_err_msg
		call print_str
		hlt

_disk_load_err_msg: db "Disk load error!", 0

BOOT_DRIVE: db 0

		%include "prints.asm"

		; BIOS magic number:
		times 510 - ($ - $$) db 0
		dw 0xAA55
