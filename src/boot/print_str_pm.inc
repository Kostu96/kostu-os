;
; Copyright (C) 2023 Konstanty Misiak
;
; SPDX-License-Identifier: MIT
;

[bits 32]

VIDEO_MEMORY equ 0xB8000
WHITE_ON_BLACK equ 0x0F

; prints a null-terminated string pointed by EBX
print_string_pm:
        pusha
        mov edx, VIDEO_MEMORY ; Set edx to the start of vid mem.
_print_str_pm_loop:
        mov al, [ebx] ; Store the char at EBX in AL
        cmp al, 0 ; if (al == 0), at end of string, so
        je _print_str_pm_done ; jump to done
        mov ah, WHITE_ON_BLACK ; Store the attributes in AH
        mov [edx], ax ; Store char and attributes at current character cell.
        inc ebx ; Increment EBX to the next char in string.
        add edx, 2 ; Move to next character cell in vid mem.
        jmp _print_str_pm_loop ; loop around to print the next char.
_print_str_pm_done:
        popa
        ret 
