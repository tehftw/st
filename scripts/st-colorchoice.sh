st -S | dmenu | awk '{ print $1 }' | xargs st $@ -s &
