;
; Copyright (C) 2023 Konstanty Misiak
;
; SPDX-License-Identifier: MIT
;

		mov bx, test_string
		call print_str
		mov bx, 0x12AB
		call print_hex

		hlt

test_string: db "Test", 0xD, 0xA, 0

		%include "bios_routines.asm"

; Sector padding:
		times 512 - ($ - $$) db 0
