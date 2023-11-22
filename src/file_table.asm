;
; Copyright (C) 2023 Konstanty Misiak
;
; SPDX-License-Identifier: MIT
;

; 16 B entries for file table:
; 0-9      file name
; 10-12    file extenstion
; 13       starting sector
; 14-15    file size in sectors, range 0x0000-0xFFFF of 512 B sectors. Max file size - 33'553'920 B = 32'767 KiB = 31 MiB

        db 'boot_sect', 0, 'bin', 0x01
        dw 0x0001
        db 'kernel', 0, 0, 0, 0, 'bin', 0x02
        dw 0x0001
        db 'file_table', 'bin', 0x03
        dw 0x0001

; Sector padding:
		times 512 - ($ - $$) db 0
