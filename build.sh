#!/bin/env /bin/bash



rm -f *.bin
rm -f *~
for src in $(find *.s); do
	if $src == "layout.s";then
		rm $src
	fi
	fasm "$src"
done
fasm layout.s
cp layout.bin os.bin
