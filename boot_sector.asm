;
; Copyright (C) 2023 Konstanty Misiak
;
; SPDX-License-Identifier: MIT
;

		org 0x7C00
		KERNEL_OFFSET equ 0x1000
		
		mov ax, 0x0003
		int 0x10 ; Set video mode

; Load additional sectors:
		mov ax, 0x0201
		mov cx, 0x0002 ; Cylinder 0, Sector 2
		mov dx, 0 ; Head 0
		mov bx, KERNEL_OFFSET
		mov es, bx
		xor bx, bx ; Load into es:bx = 0x1000:0x0
		int 0x13
		jc disk_error

		mov ax, KERNEL_OFFSET
		mov ds, ax
		mov es, ax
		mov fs, ax
		mov gs, ax
		mov ss, ax
		
		jmp KERNEL_OFFSET:0
disk_error:
		hlt

; BIOS magic number:
		times 510 - ($ - $$) db 0
		dw 0xAA55
