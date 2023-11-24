;
; Copyright (C) 2023 Konstanty Misiak
;
; SPDX-License-Identifier: MIT
;

; Prints null terminated string pointed by bx into tty
print_str:
		push bx
		mov ah, 0x0E
_print_str_start:
		mov al, [bx]
		inc bx
		cmp al, 0
		jz _print_str_end
		int 0x10
		jmp _print_str_start
_print_str_end:
		pop bx
		ret

; Prints hexadecimal value in bx into tty
print_hex:
		push bx
		push di
		mov di, _print_hex_str + 5
_print_hex_start:
		mov ax, bx
		shr bx, 4
		and ax, 0xF
		cmp al, 9
		jnc _print_hex_AF
		add al, '0'
		jmp _print_hex_store
_print_hex_AF:
		add al, 55
_print_hex_store:
		mov [di], al
		dec di
		cmp di, _print_hex_str + 1
		jnz _print_hex_start

		mov bx, _print_hex_str
		call print_str
		pop di
		pop bx
		ret
_print_hex_str: db "0x0000", 0
