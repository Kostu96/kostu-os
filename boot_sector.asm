;
; Copyright (C) 2023 Konstanty Misiak
;
; SPDX-License-Identifier: MIT
;

		org 0x7C00
		
		mov ax, 0x0003
		int 0x10 ; Set video mode

		mov bx, test_string
		call print_str
		mov bx, 0x12AB
		call print_hex

		jmp $

test_string: db 'Test', 0xD, 0xA, 0

		%include 'prints.asm'

; BIOS magic number:
		times 510 - ($ - $$) db 0
		dw 0xAA55
