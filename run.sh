#!/bin/env /bin/bash

qemu-system-x86_64 -drive file=OS.bin,format=raw -d in_asm -D qemu.log --display sdl,full-screen=on -no-reboot -icount 10
