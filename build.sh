#!/bin/env /bin/bash

rm -f *.bin
rm -f *~
for src in $(find *.s | sort); do
  if [ $src == "layout.s" ]; then
    continue
  fi
  echo "assembling $src"
  fasm "$src"
done
fasm layout.s
cp layout.bin OS.bin
