#!/bin/env /bin/bash



qemu-system-i386 -drive file=OS.bin,format=raw  -d in_asm -D qemu.log --display sdl
tail -f qemu.log
