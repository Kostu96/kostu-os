;
; Copyright (C) 2023 Konstanty Misiak
;
; SPDX-License-Identifier: MIT
;

[bits 32]
[extern kmain]

        mov ebx, MSG
        call print_string_pm

        call kmain
        jmp $

%include "print_str_pm.asm"

MSG: db "Just before calling kmain.", 0
