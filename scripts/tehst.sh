#!/bin/sh

file_defaultcolor="$XDG_CONFIG_HOME/tehst-default-color"


print_help() {
	echo "usage: $0 [argum]" 
	echo "  [no argument]"
	echo "    exec st -s [defaultcolor]\""
	echo "  -p"
	echo "    colorpicker with dmenu"
	echo "  -c [colorscheme]"
	echo "    set default colorscheme to string" 
	echo "  -h"
	echo "    print this help"
	echo "  -g"
	echo "    get defaultcolor"
}


if [ -f $file_defaultcolor ]
then
	defaultcolor=$(cat "$file_defaultcolor")
fi


colorpicker()
{
	defaultcolor=$(st -S | dmenu | awk '{ print $1 }')
	set_default_color "$defaultcolor"
}


set_default_color()
{
	echo "$1"
	echo "$1" > "$file_defaultcolor"
}


run_st()
{
	st -s "$defaultcolor"
}



# parse arguments
if [ $# -eq "0" ]
then
	exec st -s "$defaultcolor"
fi

case $1 in
	-h)
	print_help
	;;
	-p)
	colorpicker
	;;
	-g)
	echo "$defaultcolor"
	;;
	-c)
	set_default_color "$2"
	;;
	-s)
	exec st -s "$defaultcolor"
	;;
esac

