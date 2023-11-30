;
; Copyright (C) 2023 Konstanty Misiak
;
; SPDX-License-Identifier: MIT
;

; Clears screen
cls:
	mov ax, 0x0003
	int 0x10
	ret

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

_disk_load_err_msg: db "Disk load error!", 0xD, 0xA, 0
