#!/bin/sh

line_start='static Shortcut shortcuts'
line_end='shortcuts end'

echo '.SH SHORTCUTS'

sed -n "/$line_start/,/$line_end/p" src/config.h \
	| sed '/^$/d' \
	| sed '1,2d;$d' \
	| sed 's/\s\+=\s\+/=/' \
	| sed 's/[{},/\*]//g' \
	| sed 's/ $//' \
	| sed 's/\s\+/ /g' \
	| sed 's/ /.TP\n.B /' \
	| sed 's/ /\n/3'
