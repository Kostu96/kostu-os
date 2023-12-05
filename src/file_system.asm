;
; Copyright (C) 2023 Konstanty Misiak
;
; SPDX-License-Identifier: MIT
;

; Modified FAT16
; Assume 1,44 MB floppy
; Sector is 512 B
; Cluster is 1 sector

; ROOT takes 7 sectors

; Dir entry:
; bytes:    desc.:
; 0-7       filename
; 8-10      extension
; 11        attributes
; 12-13     first cluster
; 14-15     size in bytes

; sector 2 - 8:
ROOT:   
        ; kernel.bin:
        db "kernel", 0, 0
        db "bin"
        db 0
        dw 0x0001
        dw 5224

        ; padding
        times 7 * 512 - ($ - ROOT) db 0
