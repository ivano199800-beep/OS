org 0
use32
ROOT_ENTRY:
db "__root__"
times 32-($ - ROOT_ENTRY) db 0
dd 0x00000003 ; nomod|directory
dd 0x00000000 ; special handler (NONE)
dd 0x10       ; length in sectors
dd 12         ; sector start
ALLOC_ENTRY:
db "__alloc__"
times 32-($ - ALLOC_ENTRY) db 0
dd 0x00000006 ; nomod|alloc
dd 0x00000000 ;
dd 0x10
dd 0
times 512 - $ db 0
ROOT_DIR:
times (10*512) - ($ - ROOT_DIR) db 0
