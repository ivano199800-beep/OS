format binary
; bootloader
file "boot.bin"
; bios utilities
file "util32.bin"
times 2048 - ($-$$) db 0
file "fsutil.bin"
times 4096 - ($-$$) db 0
; first stage kernel (interupt dispatch table setup) , and loading the filesystem to launch 0/init.bin
file "kernel.bin"
times (4096 + 1024) - ($-$$) db 0
; filesystem first sector is the root table
file "filesystem.bin"
